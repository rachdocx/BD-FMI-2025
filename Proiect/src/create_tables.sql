-- tabela RECORD LABEL
CREATE TABLE RECORD_LABEL (
    id_record_label NUMBER(3,0) CONSTRAINT pk_record_label PRIMARY KEY,
    label_name VARCHAR2(100),
    email VARCHAR2(100)
);

CREATE SEQUENCE SEQ_RECORD_LABEL
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE PRODUCT (
    id_product NUMBER(3,0) CONSTRAINT pk_product PRIMARY KEY,
    price NUMBER(6,2),
    release_date DATE DEFAULT SYSDATE
);

CREATE SEQUENCE SEQ_PRODUCT
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE ALBUM (
    id_product NUMBER(3,0) CONSTRAINT pk_album PRIMARY KEY,
    durata VARCHAR2(100),
    id_record_label NUMBER(3,0),
    CONSTRAINT fk_album_product FOREIGN KEY (id_product) REFERENCES PRODUCT(id_product),
    CONSTRAINT fk_album_label FOREIGN KEY (id_record_label) REFERENCES RECORD_LABEL(id_record_label)
);

CREATE TABLE MERCHANDISE (
    id_product NUMBER(3,0) CONSTRAINT pk_merchandise PRIMARY KEY,
    merch_type VARCHAR2(100),
    merch_size VARCHAR2(4),
    CONSTRAINT fk_merchandise_product FOREIGN KEY (id_product) REFERENCES PRODUCT(id_product)
);

CREATE TABLE GENRE (
    id_genre NUMBER(3,0) CONSTRAINT pk_genre PRIMARY KEY,
    genre_name VARCHAR2(100),
    id_album NUMBER(3,0),
    CONSTRAINT fk_genre_album FOREIGN KEY (id_album) REFERENCES ALBUM(id_product)
);

CREATE SEQUENCE SEQ_GENRE
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE ARTIST (
    id_product NUMBER(3,0) CONSTRAINT pk_artist PRIMARY KEY,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    band VARCHAR2(100),
    CONSTRAINT fk_artist_product FOREIGN KEY (id_product) REFERENCES PRODUCT(id_product)
);

CREATE TABLE PROVIDER (
    id_provider NUMBER(3,0) CONSTRAINT pk_provider PRIMARY KEY,
    provider_name VARCHAR2(100),
    phone_number CHAR(11),
    adress VARCHAR2(100)
);

CREATE SEQUENCE SEQ_PROVIDER
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE MEDIA_FORMAT (
    id_media_format NUMBER(3,0) CONSTRAINT pk_media_format PRIMARY KEY,
    media_format_name VARCHAR2(100),
    id_product NUMBER(3,0),
    procent_added NUMBER(3,0) DEFAULT 0,
    CONSTRAINT fk_media_format_product FOREIGN KEY (id_product) REFERENCES PRODUCT(id_product)
);

CREATE SEQUENCE SEQ_MEDIA_FORMAT
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE FUNCTION (
    id_function NUMBER(3,0) CONSTRAINT pk_function PRIMARY KEY,
    function_name VARCHAR2(100),
    min_salary NUMBER(6,2),
    max_salary NUMBER(6,2)
);

CREATE SEQUENCE SEQ_FUNCTION
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE EMPLOYEE (
    id_employee NUMBER(3,0) CONSTRAINT pk_employee PRIMARY KEY,
    id_function NUMBER(3,0),
    last_name VARCHAR2(100),
    first_name VARCHAR2(100),
    phone CHAR(11),
    hire_date DATE DEFAULT SYSDATE,
    salary NUMBER(6,2),
    CONSTRAINT fk_employee_function FOREIGN KEY (id_function) REFERENCES FUNCTION(id_function)
);

CREATE SEQUENCE SEQ_EMPLOYEE
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE CUSTOMER (
    id_customer NUMBER(3,0) CONSTRAINT pk_customer PRIMARY KEY,
    last_name VARCHAR2(100),
    first_name VARCHAR2(100),
    adress VARCHAR2(300),
    city VARCHAR2(100)
);

CREATE SEQUENCE SEQ_CUSTOMER
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE STOCK (
    id_stock NUMBER(3,0) CONSTRAINT pk_stock PRIMARY KEY,
    id_product NUMBER(3,0),
    id_provider NUMBER(3,0),
    quantity NUMBER(3,0) DEFAULT 0,
    CONSTRAINT fk_stock_product FOREIGN KEY (id_product) REFERENCES PRODUCT(id_product),
    CONSTRAINT fk_stock_provider FOREIGN KEY (id_provider) REFERENCES PROVIDER(id_provider)
);

CREATE SEQUENCE SEQ_STOCK
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE PURCHASE (
    id_purchase NUMBER(3,0) CONSTRAINT pk_purchase PRIMARY KEY,
    id_customer NUMBER(3,0),
    id_employee NUMBER(3,0),
    id_product NUMBER(3,0),
    purchase_date DATE DEFAULT SYSDATE,
    payment_method VARCHAR2(100) DEFAULT 'Card',
    status VARCHAR2(100) DEFAULT 'Pending',
    quantity NUMBER(3,0) DEFAULT 1,
    CONSTRAINT fk_purchase_customer FOREIGN KEY (id_customer) REFERENCES CUSTOMER(id_customer),
    CONSTRAINT fk_purchase_employee FOREIGN KEY (id_employee) REFERENCES EMPLOYEE(id_employee),
    CONSTRAINT fk_purchase_product FOREIGN KEY (id_product) REFERENCES PRODUCT(id_product)
);

CREATE SEQUENCE SEQ_PURCHASE
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;

CREATE TABLE SONG (
    id_track_list NUMBER(3,0) CONSTRAINT pk_song PRIMARY KEY,
    id_artist NUMBER(3,0),
    id_product NUMBER(3,0),
    title VARCHAR2(100),
    length VARCHAR2(100),
    CONSTRAINT fk_song_artist FOREIGN KEY (id_artist) REFERENCES ARTIST(id_product),
    CONSTRAINT fk_song_product FOREIGN KEY (id_product) REFERENCES PRODUCT(id_product)
);

CREATE SEQUENCE SEQ_SONG
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 1000
    NOCYCLE;
