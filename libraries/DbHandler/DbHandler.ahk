; Documentation


#Include %A_LineFile%\..\..\db\DBA.ahk

Class dbhandler
{
	db := 0
	
	items := {}
	itemseffects := {}
	effects := {}
	changesonattempt := {}
	attempts := {}
	
	last_ids := {}
	
	current_item_id := 0
	
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
				return row["max"]
			}
		}
		return 0
	}
	
	ItemExists(name) ; funItemExists
	{
		sql=
		(
		SELECT id
		FROM items
		WHERE name = "%name%"
		)
		selection := this.db.Query(sql)
		For index, row in selection.Rows
		{
			if(row["id"] != "")
			{
				this.current_item_id := row["id"]
				return row["id"]
			}
		}
		return 0
	}
	
	ItemIdentification(name, level) ; funItemIdentification
	{
		item_exists := this.ItemExists(name)
		if(item_exists = 0)
		{
			item_id := this.last_ids["items"] + 1
			this.items[item_id] := {}
			this.items[item_id]["id"] := item_id
			this.items[item_id]["name"] := name
			this.items[item_id]["level"] := level
		}
	}
	
	ItemEffectsIdentification(max_pwr_dic) ; funItemEffectsIdentification
	{
		item_id := this.last_ids["items"] + 1
		if(this.current_item_id = 0)
		{
			totalPwr := 0
			For effect, pwr in max_pwr_dic
			{
				effect_id := this.effects[effect]["id"]
				unique_id := item_id . "" . effect_id
				this.itemseffects[unique_id] := {}
				this.itemseffects[unique_id]["idItem"] := item_id
				this.itemseffects[unique_id]["idEffect"] := effect_id
				this.itemseffects[unique_id]["maxPwr"] := pwr
				totalPwr := totalPwr + pwr
			}
			this.items[item_id]["maxPwr"] := totalPwr
		}
	}
	
	InsertItems()
	{
		if(this.current_item_id = 0)
		{
			items_collection := new Collection()
			items_collection.AddRange(this.items)
			this.db.InsertMany(items_collection, "items")
			itemseffects_collection := new Collection()
			itemseffects_collection.AddRange(this.itemseffects)
			this.db.InsertMany(itemseffects_collection, "itemseffects")
		}
	}
}