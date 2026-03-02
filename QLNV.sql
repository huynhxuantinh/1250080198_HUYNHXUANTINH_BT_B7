CREATE TABLE tblChucVu(
    MaCV VARCHAR2(10) PRIMARY KEY,
    TenCV VARCHAR2(50)
);
CREATE TABLE tblNhanVien(
    MaNV VARCHAR2(10) PRIMARY KEY,
    MaCV VARCHAR2(10),
    TenNV VARCHAR2(50),
    NgaySinh DATE,
    LuongCanBan NUMBER,
    NgayCong NUMBER,
    PhuCap NUMBER,
    CONSTRAINT fk_cv FOREIGN KEY(MaCV)
    REFERENCES tblChucVu(MaCV)
);
INSERT INTO tblChucVu VALUES('CV01','Giam doc');
INSERT INTO tblChucVu VALUES('CV02','Truong phong');
INSERT INTO tblChucVu VALUES('CV03','Nhan vien');
INSERT INTO tblChucVu VALUES('CV04','Thuc tap');

COMMIT;
INSERT INTO tblNhanVien 
VALUES('NV01','CV01','Nguyen Van A',TO_DATE('01/01/1990','DD/MM/YYYY'),500,26,200);

INSERT INTO tblNhanVien 
VALUES('NV02','CV02','Tran Van B',TO_DATE('05/03/1995','DD/MM/YYYY'),400,25,150);

INSERT INTO tblNhanVien 
VALUES('NV03','CV03','Le Van C',TO_DATE('10/07/2000','DD/MM/YYYY'),300,24,100);

COMMIT;
SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE SP_Them_Nhan_Vien(
 p_MaNV VARCHAR2,
 p_MaCV VARCHAR2,
 p_TenNV VARCHAR2,
 p_NgaySinh DATE,
 p_LuongCanBan NUMBER,
 p_NgayCong NUMBER,
 p_PhuCap NUMBER
)
AS
 v_dem NUMBER:=0;
BEGIN
 SELECT COUNT(*) INTO v_dem
 FROM tblChucVu
 WHERE MaCV=p_MaCV;

 IF v_dem=0 THEN
   DBMS_OUTPUT.PUT_LINE('MaCV khong ton tai');
 ELSE
   INSERT INTO tblNhanVien
   VALUES(p_MaNV,p_MaCV,p_TenNV,p_NgaySinh,p_LuongCanBan,p_NgayCong,p_PhuCap);
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Them nhan vien thanh cong');
 END IF;
END;
/

BEGIN
 SP_Them_Nhan_Vien('NV10','CV02','Pham Van D',
 TO_DATE('02/02/1999','DD/MM/YYYY'),350,26,120);
END;
/

CREATE OR REPLACE PROCEDURE SP_CapNhat_Nhan_Vien(
 p_MaNV VARCHAR2,
 p_MaCV VARCHAR2,
 p_TenNV VARCHAR2,
 p_NgaySinh DATE,
 p_LuongCanBan NUMBER,
 p_NgayCong NUMBER,
 p_PhuCap NUMBER
)
AS
 v_dem NUMBER:=0;
BEGIN
 SELECT COUNT(*) INTO v_dem
 FROM tblChucVu
 WHERE MaCV=p_MaCV;

 IF v_dem=0 THEN
   DBMS_OUTPUT.PUT_LINE('MaCV khong ton tai');
 ELSE
   UPDATE tblNhanVien
   SET MaCV=p_MaCV,
       TenNV=p_TenNV,
       NgaySinh=p_NgaySinh,
       LuongCanBan=p_LuongCanBan,
       NgayCong=p_NgayCong,
       PhuCap=p_PhuCap
   WHERE MaNV=p_MaNV;

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Cap nhat thanh cong');
 END IF;
END;
/

BEGIN
 SP_CapNhat_Nhan_Vien('NV01','CV03','Nguyen Van A',
 TO_DATE('01/01/1990','DD/MM/YYYY'),600,26,300);
END;
/

CREATE OR REPLACE PROCEDURE SP_LuongLN
AS
BEGIN
 FOR r IN (
   SELECT MaNV, TenNV,
   LuongCanBan*NgayCong + PhuCap AS Luong
   FROM tblNhanVien
 )
 LOOP
   DBMS_OUTPUT.PUT_LINE(
   r.MaNV || ' - ' || r.TenNV || ' - Luong: ' || r.Luong);
 END LOOP;
END;
/
BEGIN
 SP_LuongLN;
END;
/


CREATE OR REPLACE PROCEDURE sp_them_nhan_vien1(
 p_MaNV VARCHAR2,
 p_MaCV VARCHAR2,
 p_TenNV VARCHAR2,
 p_NgaySinh DATE,
 p_LuongCB NUMBER,
 p_NgayCong NUMBER,
 p_PhuCap NUMBER,
 p_kq OUT NUMBER
)
AS
 v_dem NUMBER:=0;
BEGIN
 SELECT COUNT(*) INTO v_dem
 FROM tblChucVu
 WHERE MaCV=p_MaCV;

 IF v_dem=0 THEN
   p_kq:=0; 
 ELSE
   INSERT INTO tblNhanVien
   VALUES(p_MaNV,p_MaCV,p_TenNV,p_NgaySinh,p_LuongCB,p_NgayCong,p_PhuCap);
   COMMIT;
   p_kq:=1; 
 END IF;

END;
/

DECLARE
 v_kq NUMBER;
BEGIN
 sp_them_nhan_vien1('NV20','CV02','Pham Van X',
 TO_DATE('02/02/2000','DD/MM/YYYY'),400,26,200,v_kq);
 DBMS_OUTPUT.PUT_LINE('Ket qua: '||v_kq);
END;
/

CREATE OR REPLACE PROCEDURE sp_them_nhan_vien2(
 p_MaNV VARCHAR2,
 p_MaCV VARCHAR2,
 p_TenNV VARCHAR2,
 p_NgaySinh DATE,
 p_LuongCB NUMBER,
 p_NgayCong NUMBER,
 p_PhuCap NUMBER,
 p_kq OUT NUMBER
)
AS
 v_demNV NUMBER:=0;
 v_demCV NUMBER:=0;
BEGIN
 SELECT COUNT(*) INTO v_demNV
 FROM tblNhanVien
 WHERE MaNV=p_MaNV;

 IF v_demNV>0 THEN
   p_kq:=0;
   RETURN;
 END IF;
 SELECT COUNT(*) INTO v_demCV
 FROM tblChucVu
 WHERE MaCV=p_MaCV;

 IF v_demCV=0 THEN
   p_kq:=1;
   RETURN;
 END IF;
 INSERT INTO tblNhanVien
 VALUES(p_MaNV,p_MaCV,p_TenNV,p_NgaySinh,p_LuongCB,p_NgayCong,p_PhuCap);

 COMMIT;
 p_kq:=2;

END;
/

DECLARE
 v_kq NUMBER;
BEGIN
 sp_them_nhan_vien2('NV30','CV01','Test NV',
 TO_DATE('01/01/2001','DD/MM/YYYY'),300,25,100,v_kq);
 DBMS_OUTPUT.PUT_LINE('Ket qua: '||v_kq);
END;
/


CREATE OR REPLACE PROCEDURE sp_capnhat_ngaysinh(
 p_MaNV VARCHAR2,
 p_NgaySinh DATE,
 p_kq OUT NUMBER
)
AS
 v_dem NUMBER:=0;
BEGIN
 SELECT COUNT(*) INTO v_dem
 FROM tblNhanVien
 WHERE MaNV=p_MaNV;

 IF v_dem=0 THEN
   p_kq:=0;
 ELSE
   UPDATE tblNhanVien
   SET NgaySinh=p_NgaySinh
   WHERE MaNV=p_MaNV;

   COMMIT;
   p_kq:=1; -- cập nhật thành công
 END IF;

END;
/
DECLARE
 v_kq NUMBER;
BEGIN
 sp_capnhat_ngaysinh('NV01',
 TO_DATE('10/10/1998','DD/MM/YYYY'),v_kq);
 DBMS_OUTPUT.PUT_LINE('Ket qua: '||v_kq);
END;
/