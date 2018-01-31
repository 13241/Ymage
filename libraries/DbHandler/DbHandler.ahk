; Documentation


#Include %A_LineFile%\..\..\db\DBA.ahk

Class dbhandler
{
	db := 0
	
	item := {}
	itemeffects := {}
	effects := {}
	changesonattempt := {}
	attempts := {}
	
	last_ids := {}
	
	current_item_id := 0
	
	attempts_count := 0
	
	AttemptsCount[] ; propAttemptsCount
	{
		get {
			return this.attempts_count
		}
	}
	
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
		this.current_item_id := this.last_ids["items"] + 1
		return 0
	}
	
	ItemIdentification(name, level) ; funItemIdentification
	{
		item_exists := this.ItemExists(name)
		if(item_exists = 0)
		{
			this.item["id"] := this.current_item_id
			this.item["name"] := name
			this.item["level"] := level
		}
	}
	
	ItemEffectsIdentification(max_pwr_dic) ; funItemEffectsIdentification
	{
		if(this.current_item_id = this.last_ids["items"] + 1)
		{
			totalPwr := 0
			For effect, pwr in max_pwr_dic
			{
				effect_id := this.effects[effect]["id"]
				this.itemeffects[effect_id] := {}
				this.itemeffects[effect_id]["idItem"] := this.current_item_id
				this.itemeffects[effect_id]["idEffect"] := effect_id
				this.itemeffects[effect_id]["maxPwr"] := pwr
				totalPwr := totalPwr + pwr
			}
			this.item["maxPwr"] := totalPwr
		}
	}
	
	InsertItem() ; funInsertItem()
	{
		if(this.current_item_id = this.last_ids["items"] + 1)
		{
			this.db.Insert(this.item, "items")
			itemeffects_collection := new Collection()
			itemeffects_collection.AddRange(this.itemeffects)
			this.db.InsertMany(itemeffects_collection, "itemseffects")
		}
	}
	
	AddAttempt(effect, current_reliquat, attempted_pwr_effect, current_pwr_item, result) ; funAddAttempt
	{
		this.attempts_count := this.attempts_count + 1
		attempt_id := this.last_ids["attempts"] + this.attempts_count
		
		this.attempts[attempt_id] := {}
		this.attempts[attempt_id]["id"] := attempt_id
		this.attempts[attempt_id]["idEffect"] := this.effects[effect]["id"]
		this.attempts[attempt_id]["idItem"] := this.current_item_id
		this.attempts[attempt_id]["currentReliquat"] := current_reliquat
		this.attempts[attempt_id]["attemptedPwrEffect"] := attempted_pwr_effect
		this.attempts[attempt_id]["currentPwrItem"] := current_pwr_item
		this.attempts[attempt_id]["result"] := result
		return attempt_id
	}
	
	AddChangeOnAttempt(attempt_id, effect, pwr_before, pwr_after) ; funAddChangeOnAttempt
	{
		effect_id := this.effects[effect]["id"]
		unique_id := attempt_id . "" . effect_id
		
		this.changesonattempt[unique_id] := {}
		this.changesonattempt[unique_id]["idAttempt"] := attempt_id
		this.changesonattempt[unique_id]["idEffect"] := effect_id
		this.changesonattempt[unique_id]["pwrBefore"] := pwr_before
		this.changesonattempt[unique_id]["pwrAfter"] := pwr_after
	}
	
	InsertAttempts() ; funInsertAttempts
	{
		attempts_collection := new Collection()
		attempts_collection.AddRange(this.attempts)
		this.db.InsertMany(attempts_collection, "attempts")
		changesonattempt_collection := new Collection()
		changesonattempt_collection.AddRange(this.changesonattempt)
		this.db.InsertMany(changesonattempt_collection, "changesonattempt")
		this.attempts := {}
		this.changesonattempt := {}
	}
}