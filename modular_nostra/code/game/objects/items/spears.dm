
/obj/item/spear/bamboospear	//Blatant imitation of spear, but made out of bamboo. Not valid for explosive modification.
	icon = 'modular_nostra/icons/obj/items_and_weapons.dmi'
	icon_state = "bamboo_spear0"
	lefthand_file = 'modular_nostra/icons/obj/polearms_lefthand.dmi'
	righthand_file = 'modular_nostra/icons/obj/polearms_righthand.dmi'
	name = "bamboo spear"
	desc = "A haphazardly-constructed yet still deadly weapon. Made of thick bamboo."
	force = 9
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	reach = 2
	throwforce = 32 //Stronger throwing damage
	embedding = list("embedded_impact_pain_multiplier" = 3)
	armour_penetration = 13				
	custom_materials = null
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	sharpness = SHARP_EDGED
	icon_prefix = "bamboo_spear"

/obj/item/spear/bamboospear/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=9, force_wielded=18, icon_wielded="[icon_prefix]1")
