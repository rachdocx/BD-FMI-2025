CREATE TABLE CASA_DE_DISCURI (
    id_casa_discuri NUMBER(3,0) CONSTRAINT pk_casa_de_discuri PRIMARY KEY,
    nume_casa VARCHAR2(100),
    email VARCHAR2(100)
);

CREATE SEQUENCE SEQ_CASA_DE_DISCURI
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE PRODUS (
    id_produs NUMBER(3,0) CONSTRAINT pk_produs PRIMARY KEY,
    pret NUMBER(6,2),
    data_lansare DATE DEFAULT SYSDATE
);

CREATE SEQUENCE SEQ_PRODUS
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE GEN (
    id_gen NUMBER(3,0) CONSTRAINT pk_gen PRIMARY KEY,
    nume_gen VARCHAR2(100)
);

CREATE SEQUENCE SEQ_GEN
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE ALBUM (
    id_produs NUMBER(3,0) CONSTRAINT pk_album PRIMARY KEY,
    nume_album VARCHAR2(100),
    lungime CHAR(5),
    id_casa_discuri NUMBER(3,0),
    id_gen NUMBER(3,0), 
    CONSTRAINT fk_album_produs FOREIGN KEY (id_produs) REFERENCES PRODUS(id_produs),
    CONSTRAINT fk_album_casa FOREIGN KEY (id_casa_discuri) REFERENCES CASA_DE_DISCURI(id_casa_discuri),
    CONSTRAINT fk_album_gen FOREIGN KEY (id_gen) REFERENCES GEN(id_gen) 
);

CREATE TABLE MERCHANDISE (
    id_produs NUMBER(3,0) CONSTRAINT pk_merchandise PRIMARY KEY,
    tip_merch VARCHAR2(100),
    marime_merch VARCHAR2(4),
    CONSTRAINT fk_merchandise_produs FOREIGN KEY (id_produs) REFERENCES PRODUS(id_produs)
);

CREATE TABLE ARTIST (
    id_artist NUMBER(3,0) CONSTRAINT pk_artist PRIMARY KEY,
    prenume VARCHAR2(100),
    nume_familie VARCHAR2(100),
    trupa VARCHAR2(100)
);

CREATE SEQUENCE SEQ_ARTIST
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE FURNIZOR (
    id_furnizor NUMBER(3,0) CONSTRAINT pk_furnizor PRIMARY KEY,
    nume_furnizor VARCHAR2(100),
    numar_telefon CHAR(10),
    adresa VARCHAR2(100)
);

CREATE SEQUENCE SEQ_FURNIZOR
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE FORMAT_MEDIA (
    id_format_media NUMBER(3,0) CONSTRAINT pk_format_media PRIMARY KEY,
    nume_format_media VARCHAR2(100),
    id_produs NUMBER(3,0),
    procent_adaugat NUMBER(3,0) DEFAULT 0,
    CONSTRAINT fk_format_media_produs FOREIGN KEY (id_produs) REFERENCES PRODUS(id_produs)
);

CREATE SEQUENCE SEQ_FORMAT_MEDIA
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE FUNCTIE (
    id_functie NUMBER(3,0) CONSTRAINT pk_functie PRIMARY KEY,
    nume_functie VARCHAR2(100),
    salariu_min NUMBER(6,2),
    salariu_max NUMBER(6,2)
);

CREATE SEQUENCE SEQ_FUNCTIE
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE ANGAJAT (
    id_angajat NUMBER(3,0) CONSTRAINT pk_angajat PRIMARY KEY,
    id_functie NUMBER(3,0),
    nume_familie VARCHAR2(100),
    prenume VARCHAR2(100),
    numar_telefon CHAR(10), 
    data_angajare DATE DEFAULT SYSDATE,
    salariu NUMBER(6,2),
    CONSTRAINT fk_angajat_functie FOREIGN KEY (id_functie) REFERENCES FUNCTIE(id_functie)
);

CREATE SEQUENCE SEQ_ANGAJAT
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE CUMPARATOR (
    id_cumparator NUMBER(3,0) CONSTRAINT pk_cumparator PRIMARY KEY,
    nume_familie VARCHAR2(100),
    prenume VARCHAR2(100),
    adresa VARCHAR2(300),
    oras VARCHAR2(100)
);

CREATE SEQUENCE SEQ_CUMPARATOR
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE STOC (
    id_stoc NUMBER(3,0) CONSTRAINT pk_stoc PRIMARY KEY,
    id_produs NUMBER(3,0),
    id_furnizor NUMBER(3,0),
    cantitate NUMBER(3,0) DEFAULT 0,
    CONSTRAINT fk_stoc_produs FOREIGN KEY (id_produs) REFERENCES PRODUS(id_produs),
    CONSTRAINT fk_stoc_furnizor FOREIGN KEY (id_furnizor) REFERENCES FURNIZOR(id_furnizor)
);

CREATE SEQUENCE SEQ_STOC
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE ACHIZITIE (
    id_achizitie NUMBER(3,0) CONSTRAINT pk_achizitie PRIMARY KEY,
    id_cumparator NUMBER(3,0),
    id_angajat NUMBER(3,0),
    id_produs NUMBER(3,0),
    data_achizitie DATE DEFAULT SYSDATE,
    metoda_plata VARCHAR2(100) DEFAULT 'Card',
    status VARCHAR2(100) DEFAULT 'Pending',
    cantitate NUMBER(3,0) DEFAULT 1,
    CONSTRAINT fk_achizitie_cumparator FOREIGN KEY (id_cumparator) REFERENCES CUMPARATOR(id_cumparator),
    CONSTRAINT fk_achizitie_angajat FOREIGN KEY (id_angajat) REFERENCES ANGAJAT(id_angajat),
    CONSTRAINT fk_achizitie_produs FOREIGN KEY (id_produs) REFERENCES PRODUS(id_produs)
);

CREATE SEQUENCE SEQ_ACHIZITIE
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE MELODIE (
    id_melodie NUMBER(3,0) CONSTRAINT pk_melodie PRIMARY KEY,
    id_artist NUMBER(3,0),
    id_produs NUMBER(3,0),
    titlu VARCHAR2(100),
    lungime VARCHAR2(100),
    CONSTRAINT fk_melodie_artist FOREIGN KEY (id_artist) REFERENCES ARTIST(id_artist),
    CONSTRAINT fk_melodie_produs FOREIGN KEY (id_produs) REFERENCES PRODUS(id_produs)
);

CREATE SEQUENCE SEQ_MELODIE
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;