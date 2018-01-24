;====================================================================
; MySQL Library Usage Examples
;
; Programmer: Alan Lilly (panofish@gmail.com) 
; AutoHotkey: v1.1.04.00 (autohotkey_L ANSI version)
;====================================================================

#SingleInstance force
outputdebug DBGVIEWCLEAR

#include mysql.ahk     ; reference local directory copy
;#include <mysql>      ; reference lib copy

;============================================================
; make database connection to mysql 
;============================================================ 

mysql := new mysql     ; instantiates mysql object

db := mysql.connect("host","userid","password","database")           ; host,user,password,database

if mysql.error
    exitapp

;============================================================
; single column select example
;============================================================ 

fullname := mysql.query(db, "SELECT username FROM user WHERE userid='" A_UserName "'")

;============================================================
; disable error handling in mysql function and handle error locally
;============================================================ 

sql := "xELECT username FROM user WHERE userid='alilly'"

fullname := mysql.query(db, sql, 0)

if mysql.error
    outputdebug % "MySQL Error = " mysql.error "`nMySQL Error String =" mysql.errstr 

;============================================================
; multi column select example (columns divided by pipe)
;============================================================ 
    
id := "alilly"
    
sql = 
(
     select username,
            userid
       from user
      WHERE userid = "%id%"
)

rec := mysql.query(db, sql) 

StringSplit, array, rec, |  

username     := array1
userid       := array2

;============================================================
; update example with escape string 
;============================================================ 

username := "Alan Lilly"
username := mysql.escape_string(username)

sql = 
(
    UPDATE user
       SET username = "%username%"
     WHERE userid = "%id%"
)

result := mysql.query(db, sql)

;============================================================
; multi-row / multi-column select example (rows divided by newline)
; and display results in a gui listview
;============================================================ 
    
sql = 
(
     select username,
            userid
       from user
)

result := mysql.query(db, sql) 

Loop, Parse, result, `n     ; parse rows
{
    StringSplit, array, A_LoopField, |      ; parse columns

    username     := array1
    userid       := array2

}

;============================================================
; Fill Listview with sql output example
;============================================================ 

Gui, Add, ListView, section r15 w300 vLIST1 

Gui, Show,,MySQL Lib Example

sql = 
(
     select username as "Full Name",
            userid
       from user
)

result := mysql.query(db, sql) 
    
mysql.lvfill(sql, result, "LIST1")  

return


