# qb-chicken
Chicken JOB For QBUS
Shared.LUA

Items
["alive_chicken"] 				 = {["name"] = "alive_chicken", 			  	["label"] = "Canlı Tavuk", 				["weight"] = 2500, 		["type"] = "item", 		["image"] = "tavukc.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "tavuk"},
	
["slaughtered_chicken"] 		 = {["name"] = "slaughtered_chicken", 			["label"] = "Kesilmiş Tavuk", 			["weight"] = 850, 		["type"] = "item", 		["image"] = "tavukk.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "tavuk"},
	

["packaged_chicken"] 			 = {["name"] = "packaged_chicken", 			  	["label"] = "Paketlenmiş Tavuk", 		["weight"] = 400, 		["type"] = "item", 		["image"] = "tavukp.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false, ["rare"] = false,   ["combinable"] = nil,   ["description"] = "tavuk"},

-
Job

["butcher"] = {
		label = "Kasap",
		payment = 20,
		defaultDuty = true,
	},
