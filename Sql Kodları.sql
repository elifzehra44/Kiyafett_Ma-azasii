CREATE DATABASE kiyafet_magazasi;
USE kiyafet_magazasi;

-- Müşteriler Tablosu
CREATE TABLE musteriler (
    musteri_id INT AUTO_INCREMENT,
    musteri_adi VARCHAR(50) NOT NULL,
    musteri_soyad VARCHAR(50) NOT NULL,
    musteri_tel VARCHAR(25) NOT NULL,
    musteri_mail VARCHAR(250) NOT NULL,
    musteri_adres VARCHAR(250) NOT NULL,
    
    PRIMARY KEY(musteri_id)
);

-- Kategoriler Tablosu
CREATE TABLE kategoriler (
    kategori_id INT PRIMARY KEY AUTO_INCREMENT,
    kategori_adi VARCHAR(50) NOT NULL
);

-- Ürünler Tablosu
CREATE TABLE urunler (
    urun_id INT PRIMARY KEY AUTO_INCREMENT,
    kategori_id INT,
    urun_adi VARCHAR(100) NOT NULL,
    fiyat DECIMAL(10, 2) NOT NULL,
    stok_miktari INT NOT NULL,
    renk VARCHAR(50),
    beden VARCHAR(10),
    FOREIGN KEY (kategori_id) REFERENCES kategoriler(kategori_id)
);

-- Satışlar Tablosu
CREATE TABLE satislar (
    satis_id VARCHAR(64) NOT NULL,
    musteri_id INT NOT NULL,
    urun_id INT NOT NULL,     
    satis_tarih DATETIME NOT NULL, 
    satis_fiyat FLOAT NOT NULL, 
    
    PRIMARY KEY(satis_id),
   
    FOREIGN KEY(musteri_id) REFERENCES musteriler(musteri_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    FOREIGN KEY(urun_id) REFERENCES urunler(urun_id)
        ON DELETE CASCADE ON UPDATE CASCADE                         
);

-- Ödemeler Tablosu
CREATE TABLE odemeler (
    odeme_id VARCHAR(64) NOT NULL,
    satis_id VARCHAR(64) NOT NULL,
    odeme_tarih DATETIME NOT NULL, 
    odeme_tutari FLOAT NOT NULL, 
    odeme_tur VARCHAR(64) NOT NULL,
    aciklama VARCHAR(64) NOT NULL,
    
    PRIMARY KEY(odeme_id),
   
    FOREIGN KEY(satis_id) REFERENCES satislar(satis_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Siparisler Tablosu
CREATE TABLE siparisler (
    siparis_id INT PRIMARY KEY AUTO_INCREMENT,
    musteri_id INT NOT NULL,
    urun_id INT NOT NULL,
    tarih DATE NOT NULL, 
    adet INT NOT NULL,
    toplam_fiyat FLOAT NOT NULL,
    
    FOREIGN KEY(musteri_id) REFERENCES musteriler(musteri_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
          
    FOREIGN KEY(urun_id) REFERENCES urunler(urun_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Siparis_Detaylari Tablosu
CREATE TABLE siparis_detaylari (
    siparis_detay_id INT PRIMARY KEY AUTO_INCREMENT,
    siparis_id INT,
    urun_id INT,
    adet INT NOT NULL,
    toplam_fiyat DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (siparis_id) REFERENCES siparisler(siparis_id),
    FOREIGN KEY (urun_id) REFERENCES urunler(urun_id)
);

-- İndirimler Tablosu
CREATE TABLE indirimler (
    indirim_id FLOAT AUTO_INCREMENT,
    urun_id INT NOT NULL,
    indirim_orani FLOAT NOT NULL,
    baslangic_tarihi DATE NOT NULL, 
    bitis_tarihi DATE NOT NULL, 
    
    PRIMARY KEY (indirim_id),
   
    FOREIGN KEY(urun_id) REFERENCES urunler(urun_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Kategori Ekleme Örneği
INSERT INTO kategoriler (kategori_adi) VALUES ('Pantolon');
INSERT INTO kategoriler (kategori_adi) VALUES ('Gömlek');
INSERT INTO kategoriler (kategori_adi) VALUES ('Ceket');

-- Pantolon Ekleme Örneği
INSERT INTO urunler (kategori_id, urun_adi, fiyat, stok_miktari, renk, beden) VALUES (1, 'Spor Pantolon', 49.99, 100, 'Mavi', 'M');
INSERT INTO urunler (kategori_id, urun_adi, fiyat, stok_miktari, renk, beden) VALUES (1, 'Klasik Pantolon', 59.99, 80, 'Siyah', 'L');

-- Gömlek Ekleme Örneği
INSERT INTO urunler (kategori_id, urun_adi, fiyat, stok_miktari, renk, beden) VALUES (2, 'Polo Gömlek', 29.99, 120, 'Beyaz', 'S');
INSERT INTO urunler (kategori_id, urun_adi, fiyat, stok_miktari, renk, beden) VALUES (2, 'Yazlık Gömlek', 39.99, 90, 'Yeşil', 'XL');

-- Ceket Ekleme Örneği
INSERT INTO urunler (kategori_id, urun_adi, fiyat, stok_miktari, renk, beden) VALUES (3, 'Deri Ceket', 89.99, 50, 'Kahverengi', 'L');
INSERT INTO urunler (kategori_id, urun_adi, fiyat, stok_miktari, renk, beden) VALUES (3, 'Kışlık Ceket', 79.99, 60, 'Siyah', 'M');





-- Müşteri eklemek için stored procedure

DELIMITER $$
CREATE PROCEDURE musteriler_hepsi ()
BEGIN
    SELECT 
        musteri_id      as ID,
        musteri_ad      as Adı,
        musteri_soyad   as Soyadı,
        musteri_tel     as Telefon, 
        musteri_mail    as Mail,
        musteri_adres   as Adres
    FROM  musteriler;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE musteri_ekle (
    id      varchar(64) ,
    ad      varchar(64) ,
    soy     varchar(64) ,
    tel     varchar(25) ,
    mail    varchar(250),
    adr     varchar(250)
)
BEGIN
    INSERT INTO musteriler
    VALUES  (id, ad, soy, tel, mail, adr);
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE musteri_guncelle (
    id      varchar(64) ,
    ad      varchar(64) ,
    soy     varchar(64) ,
    tel     varchar(25) ,
    mail    varchar(250),
    adr     varchar(250)
)
BEGIN
    UPDATE musteriler
    SET 
        musteri_ad      = ad,
        musteri_soyad   = soy,
        musteri_tel     = tel,
        musteri_mail    = mail,
        musteri_adres   = adr
    WHERE 
        musteri_id      = id;
END $$
DELIMITER ;





DELIMITER $$
CREATE PROCEDURE musteri_sil (
    id      varchar(64) 
)
BEGIN
    DELETE FROM musteriler
    WHERE   musteri_id  = id;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE musteri_bul (
    filtre  varchar(32) 
)
BEGIN
    SELECT * FROM musteriler
    WHERE 
        musteri_id      LIKE  CONCAT('%',filtre,'%') OR
        musteri_ad      LIKE  CONCAT('%',filtre,'%') OR
        musteri_soyad   LIKE  CONCAT('%',filtre,'%') OR
        musteri_tel     LIKE  CONCAT('%',filtre,'%') OR
        musteri_mail    LIKE  CONCAT('%',filtre,'%') OR
        musteri_adres   LIKE  CONCAT('%',filtre,'%');
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE musteri_satislar(
    id          varchar(64)  
)
BEGIN
    SELECT * FROM satislar
    WHERE musteri_id = id;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE urunler_hepsi ()
BEGIN
    SELECT * FROM urunler;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE urun_ekle (
    id          varchar(64)  ,
    ad          varchar(250) ,
    kategori    varchar(250) ,
    fiyat       float        ,
    stok        float        ,
    birim       varchar(16)  ,
    detay       varchar(250) 
)
BEGIN
    INSERT INTO urunler
    VALUES  (id, ad, kategori, fiyat, stok, birim, detay);
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE urun_guncelle (
    id          varchar(64)  ,
    ad          varchar(250) ,
    kategori    varchar(250) ,
    fiyat       float        ,
    stok        float        ,
    birim       varchar(16)  ,
    detay       varchar(250) 
)
BEGIN
    UPDATE urunler
    SET 
        urun_ad       = ad,
        urun_kategori = kategori,
        urun_fiyat    = fiyat,
        urun_stok     = stok,
        urun_birim    = birim,
        urun_detay    = detay
    WHERE 
        urun_id       = id;
END $$
DELIMITER ;




DELIMITER $$
CREATE PROCEDURE urun_stok_guncelle (
    id          varchar(64)  ,
    stok        float        
)
BEGIN
    UPDATE  urunler
    SET 
        urun_stok     = stok
    WHERE 
        urun_id       = id;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE urun_sil (
    id          varchar(64)  
)
BEGIN
    DELETE FROM urunler
    WHERE urun_id  = id;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE urun_bul (
    filtre      varchar(32)
)
BEGIN
    SELECT * FROM urunler
    WHERE 
        urun_id       LIKE  CONCAT('%',filtre,'%') OR
        urun_ad       LIKE  CONCAT('%',filtre,'%') OR
        urun_kategori LIKE  CONCAT('%',filtre,'%') OR
        urun_fiyat    LIKE  CONCAT('%',filtre,'%') OR
        urun_stok     LIKE  CONCAT('%',filtre,'%') OR
        urun_birim    LIKE  CONCAT('%',filtre,'%') OR
        urun_detay    LIKE  CONCAT('%',filtre,'%') ;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE urun_satislar(
    id          varchar(64)  
)
BEGIN
    SELECT * FROM  satislar
    WHERE urun_id = id;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE satis_ekle (
    sid     varchar(64) ,
    mid     varchar(64) ,
    uid     varchar(64) ,    
    tarih   datetime    ,
    fiyat   float       
)
BEGIN
    INSERT INTO satislar
    VALUES  (sid, mid, uid, tarih, fiyat);
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE satis_sil (
    id          varchar(64)  
)
BEGIN
    DELETE FROM satislar
    WHERE satis_id  = id;
END $$
DELIMITER ;





DELIMITER $$
CREATE PROCEDURE satis_guncelle (
    sid         varchar(64),
    mid         varchar(64),
    uid         varchar(64),
    tarih       datetime   ,
    fiyat       float      
)
BEGIN
    UPDATE satislar
    SET 
        musteri_id    = mid,
        urun_id       = uid,
        satis_tarih   = tarih,
        satis_fiyat   = fiyat
    WHERE 
        satis_id      = sid;
END $$
DELIMITER ;




DELIMITER $$
CREATE PROCEDURE satis_detay (
)
BEGIN
SELECT   
        s.satis_id,
        m.musteri_id,
        u.urun_id,
        CONCAT(musteri_ad,' ', musteri_soyad ) as `Müşteri Ad Soyad`,
        urun_ad as `Ürün`,
        urun_kategori as `Kategori`,
        urun_fiyat as `Birim Fiyat`,
        satis_fiyat as `Satış Fiyatı`,
        satis_tarih as `Satış Tarihi`
FROM    abc_musteriler m inner join  abc_satislar s 
    on m.musteri_id = s.musteri_id 
        inner join abc_urunler u on s.urun_id = u.urun_id;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE odeme_ekle (
    oid     varchar(64) ,
    mid     varchar(64) ,   
    tarih   datetime    ,
    tutar   float       ,
    tur     varchar(25) ,
    aciklama varchar(250)
)
BEGIN
    INSERT INTO odemeler
    VALUES  (oid, mid, tarih, tutar, tur, aciklama);
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE odeme_detay (
)
BEGIN
SELECT   
        o.odeme_id,
        m.musteri_id,
        CONCAT(musteri_ad,' ', musteri_soyad ) as `Müşteri Ad Soyad`,
        o.odeme_tarih as `Ödeme Tarihi`,
        o.odeme_tutar as `Ödeme Tutarı`,
        o.odeme_tur as `Ödeme Türü`,
        o.odeme_aciklama as `Açıklama`
        
FROM    musteriler m inner join  odemeler o 
    on m.musteri_id = o.musteri_id;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE odeme_guncelle (
    oid     varchar(64) ,
    mid     varchar(64) ,   
    tarih   datetime    ,
    tutar   float       ,
    tur     varchar(25) ,
    aciklama varchar(250)
)
BEGIN
    UPDATE odemeler
    SET
        musteri_id      = mid,
        odeme_tarih     = tarih,
        odeme_tutar     = tutar,
        odeme_tur       = tur,
        odeme_aciklama  = aciklama
    WHERE 
        odeme_id = oid; 
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE odeme_sil (
    oid     varchar(64) 
)
BEGIN
    DELETE FROM odemeler
    WHERE odeme_id = oid;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE musteri_bakiye(
    id      varchar(64)
)
BEGIN
    declare borc  float;
    declare odeme float;
    
    SELECT  SUM(satis_fiyat) into borc  
    FROM    satislar 
    WHERE   musteri_id = id;
    
    SELECT  SUM(odeme_tutar) into odeme  
    FROM    odemeler 
    WHERE   musteri_id = id;
    
    SELECT odeme - borc;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE satislar_toplam()
BEGIN
    SELECT  SUM(satis_fiyat)  
    FROM    satislar ;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE odemeler_toplam()
BEGIN
    SELECT  SUM(odeme_tutar)  
    FROM    odemeler ;
END $$
DELIMITER ;


call satislartoplam();
call odemelertoplam();
