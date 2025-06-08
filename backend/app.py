from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg2
import os

app = Flask(__name__)
CORS(app)

DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("POSTGRES_DB", "notesdb")
DB_USER = os.getenv("POSTGRES_USER", "user")
DB_PASS = os.getenv("POSTGRES_PASSWORD", "password")

def get_connection():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )

# Health check endpoints
@app.route("/", methods=["GET"])
def root():
    return jsonify({"status": "healthy", "service": "notes-api"}), 200

@app.route("/api/health", methods=["GET"])
def health():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT 1")
        cur.close()
        conn.close()
        return jsonify({"status": "healthy", "database": "connected"}), 200
    except Exception as e:
        return jsonify({"status": "unhealthy", "error": str(e)}), 500

# Original routes (za nginx proxy)
@app.route("/notes", methods=["GET"])
def get_notes():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, content FROM notes ORDER BY id DESC")
    notes = [{"id": row[0], "content": row[1]} for row in cur.fetchall()]
    cur.close()
    conn.close()
    return jsonify(notes)

@app.route("/notes", methods=["POST"])
def add_note():
    data = request.get_json()
    content = data.get("content")
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("INSERT INTO notes (content) VALUES (%s)", (content,))
    conn.commit()
    cur.close()
    conn.close()
    return jsonify({"message": "Note added"}), 201

# API routes (za direktan ALB pristup)
@app.route("/api/notes", methods=["GET"])
def api_get_notes():
    return get_notes()

@app.route("/api/notes", methods=["POST"])
def api_add_note():
    return add_note()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
