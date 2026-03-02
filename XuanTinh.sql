CREATE TABLE KHOA(
    Makhoa VARCHAR2(10) PRIMARY KEY,
    Tenkhoa VARCHAR2(50),
    Dienthoai VARCHAR2(15)
);

CREATE TABLE LOP(
    Malop VARCHAR2(10) PRIMARY KEY,
    Tenlop VARCHAR2(50),
    Khoa VARCHAR2(20),
    Hedt VARCHAR2(20),
    Namnhaphoc NUMBER,
    Makhoa VARCHAR2(10),
    CONSTRAINT fk_khoa
    FOREIGN KEY (Makhoa) REFERENCES KHOA(Makhoa)
);


INSERT INTO KHOA VALUES('K01','Cong nghe thong tin','0909000001');
INSERT INTO KHOA VALUES('K02','Ke toan','0909000002');
INSERT INTO KHOA VALUES('K03','Quan tri kinh doanh','0909000003');

INSERT INTO LOP VALUES('L01','CNTT1','K2024','DH',2024,'K01');
INSERT INTO LOP VALUES('L02','CNTT2','K2024','DH',2024,'K01');
INSERT INTO LOP VALUES('L03','KT1','K2023','CD',2023,'K02');

COMMIT;


CREATE OR REPLACE PROCEDURE them_khoa(
    p_makhoa VARCHAR2,
    p_tenkhoa VARCHAR2,
    p_dienthoai VARCHAR2
)
AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem
    FROM KHOA
    WHERE UPPER(tenkhoa)=UPPER(p_tenkhoa);

    IF v_dem > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ten khoa da ton tai');
    ELSE
        INSERT INTO KHOA VALUES(p_makhoa,p_tenkhoa,p_dienthoai);
        DBMS_OUTPUT.PUT_LINE('Them khoa thanh cong');
        COMMIT;
    END IF;
END;


BEGIN
 them_khoa('K10','Cong nghe thong tin','0999');
END;

BEGIN
 them_khoa('K10','Du lich','0777');
END;
SELECT * FROM KHOA;

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE them_lop(
    p_malop VARCHAR2,
    p_tenlop VARCHAR2,
    p_khoa VARCHAR2,
    p_hedt VARCHAR2,
    p_namnhaphoc NUMBER,
    p_makhoa VARCHAR2
)
AS
    v_demlop NUMBER := 0;
    v_demkhoa NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_demlop
    FROM LOP
    WHERE UPPER(tenlop)=UPPER(p_tenlop);

    IF v_demlop > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ten lop da ton tai');
        RETURN;
    END IF;
    SELECT COUNT(*) INTO v_demkhoa
    FROM KHOA
    WHERE makhoa=p_makhoa;

    IF v_demkhoa = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ma khoa khong ton tai');
        RETURN;
    END IF;
    INSERT INTO LOP VALUES(p_malop,p_tenlop,p_khoa,p_hedt,p_namnhaphoc,p_makhoa);
    DBMS_OUTPUT.PUT_LINE('Them lop thanh cong');
    COMMIT;
END;

BEGIN
 them_lop('L10','CNTT10','K2024','DH',2024,'K01');
END;
/
BEGIN
 them_lop('L11','CNTT10','K2024','DH',2024,'K01');
END;
/
BEGIN
 them_lop('L12','CNTT12','K2024','DH',2024,'K99');
END;
/
SELECT * FROM LOP;

CREATE OR REPLACE PROCEDURE them_khoa_v2(
    p_makhoa IN VARCHAR2,
    p_tenkhoa IN VARCHAR2,
    p_dienthoai IN VARCHAR2,
    p_kq OUT NUMBER
)
AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem
    FROM KHOA
    WHERE UPPER(tenkhoa)=UPPER(p_tenkhoa);

    IF v_dem > 0 THEN
        p_kq := 0;   
    ELSE
        INSERT INTO KHOA VALUES(p_makhoa,p_tenkhoa,p_dienthoai);
        COMMIT;
        p_kq := 1;  
    END IF;

END;
/

DECLARE
 v_kq NUMBER;
BEGIN
 them_khoa_v2('K50','Cong nghe thong tin','0999',v_kq);
 DBMS_OUTPUT.PUT_LINE('Ket qua: '||v_kq);
END;
/
DECLARE
 v_kq NUMBER;
BEGIN
 them_khoa_v2('K51','Du lich','0888',v_kq);
 DBMS_OUTPUT.PUT_LINE('Ket qua: '||v_kq);
END;
/


------------------------------------
CREATE OR REPLACE PROCEDURE them_lop_v2(
    p_malop IN VARCHAR2,
    p_tenlop IN VARCHAR2,
    p_khoa IN VARCHAR2,
    p_hedt IN VARCHAR2,
    p_namnhaphoc IN NUMBER,
    p_makhoa IN VARCHAR2,
    p_kq OUT NUMBER
)
AS
    v_demlop NUMBER := 0;
    v_demkhoa NUMBER := 0;
BEGIN

    SELECT COUNT(*) INTO v_demlop
    FROM LOP
    WHERE UPPER(tenlop)=UPPER(p_tenlop);

    IF v_demlop > 0 THEN
        p_kq := 0;
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_demkhoa
    FROM KHOA
    WHERE makhoa = p_makhoa;

    IF v_demkhoa = 0 THEN
        p_kq := 1;
        RETURN;
    END IF;

    INSERT INTO LOP
    VALUES(p_malop,p_tenlop,p_khoa,p_hedt,p_namnhaphoc,p_makhoa);

    COMMIT;
    p_kq := 2;

END;
/

DECLARE
 v_kq NUMBER;
BEGIN
 them_lop_v2('L90','CNTT1','K2024','DH',2024,'K01',v_kq);
 DBMS_OUTPUT.PUT_LINE('Ket qua: '||v_kq);
END;
/


DECLARE
 v_kq NUMBER;
BEGIN
 them_lop_v2('L91','TESTMOI1','K2024','DH',2024,'K99',v_kq);
 DBMS_OUTPUT.PUT_LINE('Ket qua: '||v_kq);
END;
/
DECLARE
 v_kq NUMBER;
BEGIN
 them_lop_v2('L92','TESTMOI2','K2024','DH',2024,'K01',v_kq);
 DBMS_OUTPUT.PUT_LINE('Ket qua: '||v_kq);
END;
/