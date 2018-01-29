/*
	DataBase NameSpace Import
*/

#Include %A_LineFile%\..\Base.ahk
#Include %A_LineFile%\..\ArchLogger.ahk
#Include %A_LineFile%\..\MemoryBuffer.ahk
#Include %A_LineFile%\..\Collection.ahk

; drivers / header definitions
#Include %A_LineFile%\..\ADO.ahk
#Include %A_LineFile%\..\SQLite_L.ahk
#Include %A_LineFile%\..\mySQL.ahk


class DBA ; namespace DBA
{
	/*
	* All thefollowing included classes will be contained in the DBA namespace
	* which is actually just an encapsulating class
	*
	*/
	
	;base classes
	#Include %A_LineFile%\..\DataBaseFactory.ahk
	#Include %A_LineFile%\..\DataBaseAbstract.ahk
	

	; Concrete SQL-Provider Implementations
	#Include %A_LineFile%\..\DataBaseSQLLite.ahk
	#Include %A_LineFile%\..\DataBaseMySQL.ahk
	#Include %A_LineFile%\..\DataBaseADO.ahk
	
	#Include %A_LineFile%\..\RecordSetSqlLite.ahk
	#Include %A_LineFile%\..\RecordSetADO.ahk
	#Include %A_LineFile%\..\RecordSetMySQL.ahk
}