ENT.Type = "anim"
ENT.Base = "bb_printer_ink_small"
ENT.PrintName = "Ink - 10000 mL"
ENT.Author = "Tyler B."
ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.PrinterInfo = { -- per second
	health = {
		max = 100,
		rate = 0.1 -- regen
	},
	
	ink = {
		max = 20000,
		rate = 200
	}
}