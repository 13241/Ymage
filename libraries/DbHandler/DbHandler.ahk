; Documentation


#Include libraries/db/DBA.ahk

Class dbhandler
{
	db := 0
	
	items := {}
	itemseffects := {}
	effects := {}
	changesonattempt := {}
	attempts := {}
	
	last_ids := {}
	
	Connect() ; funConnect
	{
		connectionString := "Server=localhost;Port=3306;Database=ymage;Uid=root;Pwd=;"
		this.db := DBA.DataBaseFactory.OpenDataBase("MySQL", connectionString)
		
		this.GetEffects()
		
		this.last_ids["items"] := this.GetLastId("items")
		this.last_ids["attempts"] := this.GetLastId("attempts")
	}
	
	GetEffects() ; funGetEffects
	{
		sql=
		(
		SELECT id, effect, rune, pwrPerUnit, basic, pa, ra
		FROM effects
		)
		selection := this.db.Query(sql)
		For index, row in selection.Rows
		{
			this.effects[row["effect"]] := {}
			this.effects[row["effect"]]["rune"] := row["rune"]
			this.effects[row["effect"]]["pwrPerUnit"] := row["pwrPerUnit"]
			this.effects[row["effect"]]["basic"] := row["basic"]
			this.effects[row["effect"]]["pa"] := row["pa"]
			this.effects[row["effect"]]["ra"] := row["ra"]
			this.effects[row["effect"]]["id"] := row["id"]
		}
	}
	
	GetLastId(table) ; funGetLastId
	{
		sql=
		(
		SELECT MAX(id) AS max
		FROM %table%
		)
		selection := this.db.Query(sql)
		For index, row in selection.Rows
		{
			if(row["max"] != "")
			{
				wazaa := row["max"]
				MsgBox, %wazaa%
				return row["max"]
			}
			else
			{
				MsgBox, 0
				return 0
			}
		}
	}
	
	
}