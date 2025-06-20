from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["RecordStore"]
if "Album" not in db.list_collection_names():
    db.create_collection("Album")
if "Merchandise" not in db.list_collection_names():
    db.create_collection("Merchandise")
if "Achizitie" not in db.list_collection_names():
    db.create_collection("Achizitie")

albums = db["Album"]
merch = db["Merchandise"]
achizitii = db["Achizitie"]

while True:
    print("\n==== MENIU ====")
    print("1. Introduceti un album")
    print("2. Introduceti un produs merchandise")
    print("3. Introduceti o achizitie")
    print("0. Iesire")
    opt = input("Optiune: ")

    if opt == "0":
        print("Exit.")
        break

    elif opt == "1":
        nume_album = input("Nume album: ")
        pret = float(input("Pret: "))
        data_lansare = input("Data lansare (YYYY-MM-DD): ")
        lungime = input("Durata album (ex: 49:07): ")

        gen_nume = input("Gen muzical: ")
        casa_nume = input("Nume casa discuri: ")
        casa_email = input("Email casa discuri: ")

        formate_disponibile = []
        while True:
            nume_format = input("Format media (CD, Vinyl etc) [ENTER pt stop]: ")
            if nume_format == "":
                break
            procent = int(input("Procent adaugat: "))
            formate_disponibile.append({"nume": nume_format, "procent_adaugat": procent})

        melodii = []
        while True:
            titlu = input("Titlu melodie [ENTER pt stop]: ")
            if titlu == "":
                break
            lungime_melodie = input("Durata melodie: ")
            prenume = input("Prenume artist: ")
            nume_familie = input("Nume familie artist: ")
            trupa = input("Trupa (ENTER daca nu are): ")
            melodii.append({
                "titlu": titlu,
                "lungime": lungime_melodie,
                "artist": {
                    "prenume": prenume,
                    "nume_familie": nume_familie,
                    "trupa": trupa if trupa else None
                }
            })

        album = {
            "nume_album": nume_album,
            "pret": pret,
            "data_lansare": data_lansare,
            "lungime": lungime,
            "gen": {"nume": gen_nume},
            "casa_discuri": {"nume": casa_nume, "email": casa_email},
            "formate_disponibile": formate_disponibile,
            "melodii": melodii
        }

        albums.insert_one(album)
        print("Album adaugat.")

    elif opt == "2":
        nume = input("Nume produs: ")
        tip = input("Tip produs (Tricou, Poster etc): ")
        marime = input("Marime (ENTER daca nu are): ")
        pret = float(input("Pret: "))
        data_lansare = input("Data lansare (YYYY-MM-DD): ")

        stoc = []
        while True:
            cantitate = input("Cantitate pe stoc [ENTER pt stop]: ")
            if cantitate == "":
                break
            cantitate = int(cantitate)
            furnizor_nume = input("Nume furnizor: ")
            furnizor_telefon = input("Telefon furnizor: ")
            furnizor_adresa = input("Adresa furnizor: ")
            stoc.append({
                "cantitate": cantitate,
                "furnizor": {
                    "nume": furnizor_nume,
                    "telefon": furnizor_telefon,
                    "adresa": furnizor_adresa
                }
            })

        produs = {
            "nume": nume,
            "tip": tip,
            "marime": marime if marime else None,
            "pret": pret,
            "data_lansare": data_lansare,
            "stoc": stoc
        }

        merch.insert_one(produs)
        print("Merchandise adaugat.")

    elif opt == "3":
        data = input("Data achizitie (YYYY-MM-DD): ")
        metoda_plata = input("Metoda plata (Cash, Card etc): ")
        status = input("Status (Pending, Completed): ")
        cantitate = int(input("Cantitate: "))

        cumparator_nume = input("Nume cumparator: ")
        cumparator_prenume = input("Prenume cumparator: ")
        adresa = input("Adresa cumparator: ")
        oras = input("Oras: ")

        angajat_nume = input("Nume angajat: ")
        angajat_prenume = input("Prenume angajat: ")
        functie_nume = input("Functie: ")
        salariu_min = float(input("Salariu minim functie: "))
        salariu_max = float(input("Salariu maxim functie: "))
        telefon = input("Telefon angajat: ")
        data_angajare = input("Data angajare (YYYY-MM-DD): ")
        salariu = float(input("Salariu actual: "))

        tip_produs = input("Tip produs (Album sau Merchandise): ")
        nume_produs = input("Nume produs: ")
        pret_produs = float(input("Pret produs: "))

        achizitie = {
            "data": data,
            "metoda_plata": metoda_plata,
            "status": status,
            "cantitate": cantitate,
            "cumparator": {
                "nume": cumparator_nume,
                "prenume": cumparator_prenume,
                "adresa": adresa,
                "oras": oras
            },
            "angajat": {
                "nume": angajat_nume,
                "prenume": angajat_prenume,
                "functie": {
                    "nume": functie_nume,
                    "salariu_min": salariu_min,
                    "salariu_max": salariu_max
                },
                "telefon": telefon,
                "data_angajare": data_angajare,
                "salariu": salariu
            },
            "produs": {
                "tip": tip_produs,
                "nume": nume_produs,
                "pret": pret_produs
            }
        }

        achizitii.insert_one(achizitie)
        print("Achizitie adaugata.")

    else:
        print("Optiune invalida.")
