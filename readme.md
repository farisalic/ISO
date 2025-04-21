# Dokumentacija za Dockeriziranu Web Aplikaciju "NotesApp"

## Kratak opis aplikacije
"NotesApp" je jednostavna web aplikacija za kreiranje i prikazivanje bilješki. Korisnici mogu dodavati tekstualne bilješke i pregledati. Aplikacija se sastoji od tri odvojena servisa: frontend (React), backend (Flask/Python) i baza podataka (PostgreSQL).

---

## Softverski preduslovi
Za pokretanje aplikacije potrebno je:

- Operativni sistem: Windows, macOS ili Linux
- Docker
- Git Bash ili drugi Bash terminal (za pokretanje skripti u Windows-u)

---

## Arhitektura, opis servisa, mreža i volume-a

### Servisi:
1. **frontend** – React aplikacija (nginx)
2. **backend** – Flask
3. **db** – PostgreSQL baza podataka

### Mreža:
- Svi servisi su povezani unutar jedne Docker bridge mreže koju automatski kreira Docker Compose

### Volumes:
- notes-db-data – koristi se za trajnu pohranu PostgreSQL podataka

---

## Primjer korištenja:

```bash 
./pripremi_aplikaciju.sh 
```
```bash 
./pokreni_aplikaciju.sh 
```
Aplikacija dostupna na http://localhost:8080
```bash 
./zaustavi_aplikaciju.sh 
```
```bash 
./obrisi_aplikaciju.sh 
```
