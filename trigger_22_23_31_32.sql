/*============================================================================*/
/* Trigger 22: khi insert, update hoa don thi ngay HD > ngay DK cua khach hang*/
/*============================================================================*/
drop trigger trigger_hoadon_khachhang;

set define off;
create or replace trigger trigger_hoadon_khachhang
after insert or update of NGHD on HOADON
for each row
declare
    v_ngdk KHACHHANG.NGDK%type;
begin
    select KHACHHANG.NGDK into v_ngdk
    from KHACHHANG
    WHERE KHACHHANG.MAKH =: NEW.MAKH;
    
    if(:new.NGHD < v_ngdk)
    then 
        raise_application_error(-2000, 'Loi !!');
    end if;
end;

/* khi update khach hang thi ngay DK < ngay HD */
drop trigger trigger_khachhang_hoadon;

set define off;
create or replace trigger trigger_khachhang_hoadon
after update of NGDK on KHACHHANG
for each row
declare
    v_nghd HOADON.NGHD%type;
    cur_kv HOADON.MAKH%type;
    cursor cur is select MAHD
                    from HOADON
                    where MAKH =:NEW.MAKH;
begin
    open cur;
    loop
        fetch cur into cur_kv;
        exit when cur%NOTFOUND;
        select HOADON.NGHD into v_nghd
        from HOADON
        WHERE HOADON.MAHD = cur_kv;
        if(:new.NGDK > v_nghd)
        then 
            raise_application_error(-2000, 'Loi !!!');
        else 
            dbms_output.put_line('Sua thanh cong');
        end if;
    end loop;
end;
/*============================================================================*/
/* Trigger 23: khi insert, update hoa don thi ngay HD > ngay VL cua nhan vien */
/*============================================================================*/
drop trigger trigger_hoadon_nhanvien;

set define off;
create or replace trigger trigger_hoadon_nhanvien
after insert or update of NGHD on HOADON
for each row
declare
    v_ngvl NHANVIEN.NGVL%type;
begin
    select NHANVIEN.NGVL into v_ngvl
    from NHANVIEN
    WHERE NHANVIEN.MANHANVIEN=: NEW.MANHANVIEN;
    
    if(:new.NGHD < v_ngvl)
    then 
        raise_application_error(-2000, 'Loi !! Ngay hoa don phai lon hon ngay vao lam cua nhan vien');
    end if;
end;

/* khi update nhan vien thi ngay VL < ngay HD */
drop trigger trigger_nhanvien_hoadon;

set define off;
create or replace trigger trigger_nhanvien_hoadon
after update of NGVL on NHANVIEN
for each row
declare
    v_nghd HOADON.NGHD%type;
    cur_kv HOADON.MANHANVIEN%type;
    cursor cur is select MAHD
                    from HOADON
                    where MANHANVIEN =:NEW.MANHANVIEN;
begin
    open cur;
    loop
        fetch cur into cur_kv;
        exit when cur%NOTFOUND;
        select HOADON.NGHD into v_nghd
        from HOADON
        WHERE HOADON.MAHD = cur_kv;
        if(:new.NGVL > v_nghd)
        then 
            raise_application_error(-2000, 'Loi !!!');
        else 
            dbms_output.put_line('Sua thanh cong');
        end if;
    end loop;
end;
/*============================================================================*/
/* Trigger 31: SDT cua nhan vien la duy nhat                                  */
/*============================================================================*/
drop trigger trigger_nhanvien_sdt;

set define off;
create or replace trigger trigger_nhanvien_sdt
before insert or update on NHANVIEN
for each row
declare 
    v_count number;
begin
    if updating or inserting then
        select count(*) into v_count
        from NHANVIEN
        where SDT =:NEW.SDT;
        if (v_count > 0) then
            raise_application_error(-20000, 'So dien thoai da ton tai');
            commit;
        end if;
    end if;
end;
/*============================================================================*/
/* Trigger 32: SDT cua khach hang la duy nhat                                  */
/*============================================================================*/
drop trigger trigger_khachhang_sdt;

set define off;
create or replace trigger trigger_khachhang_sdt
before insert or update of SDT on KHACHHANG
for each row
declare 
    v_count number;
begin
    if updating or inserting then
        select count(*) into v_count
        from KHACHHANG
        where SDT =:NEW.SDT;
        if (v_count > 0) then
            raise_application_error(-20000, 'So dien thoai da ton tai');
            commit;
        end if;
    end if;
end;