const apiUrl = "/api/notes";

async function fetchNotes() {
  const res = await fetch(apiUrl);
  const notes = await res.json();
  const notesDiv = document.getElementById("notes");
  notesDiv.innerHTML = "";
  notes.forEach(note => {
    const div = document.createElement("div");
    div.className = "note";
    div.textContent = note.content;
    notesDiv.appendChild(div);
  });
}

async function addNote() {
  const input = document.getElementById("noteInput");
  const content = input.value.trim();
  if (!content) return;
  await fetch(apiUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ content })
  });
  input.value = "";
  fetchNotes();
}

fetchNotes();
