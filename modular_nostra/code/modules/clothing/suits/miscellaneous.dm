/obj/item/clothing/suit/hooded/wintercoat/utility
	name = "utility winter coat"
	desc = "A bright and cozy winter coat"
	icon = 'modular_nostra/icons/obj/clothing/suits.dmi'
	mob_overlay_icon = 'modular_nostra/icons/mob/clothing/suit.dmi' //ill be real honest here, i made 2 items with usage of this, but while making this exact item i forgot about existance of mob_overlay_icon at all, dear fucking god
	icon_state = "coatutility"
	item_state = "coatutility"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 10, "rad" = 5, "fire" = 0, "acid" = 5)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter)
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/head/hooded/winterhood
	name = "utility winter hood"
	desc = "A hood attached to a bright winter coat."
	mob_overlay_icon = 'modular_nostra/icons/mob/clothing/head.dmi'
	icon_state = "winterhood_utility"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 10, "rad" = 5, "fire" = 0, "acid" = 5)
	flags_inv = HIDEHAIR|HIDEEARS
	rad_flags = RAD_NO_CONTAMINATE

/obj/item/clothing/suit/hooded/wintercoat/armor //dont expect this to be in game, unless spawned by admins
	name = "armored winter coat"
	desc = "A heavy winter coat"
	icon = 'modular_nostra/icons/obj/clothing/suits.dmi'
	mob_overlay_icon = 'modular_nostra/icons/mob/clothing/suit.dmi'
	icon_state = "coatarmor"
	item_state = "coatarmor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list("melee" = 30, "bullet" = 20, "laser" = 5, "energy" = 5, "bomb" = 15, "bio" = 15, "rad" = 5, "fire" = 0, "acid" = 15)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter)
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/head/hooded/winterhood
	name = "armored winter hood"
	desc = "A hood attached to a heavily armored winter coat."
	mob_overlay_icon = 'modular_nostra/icons/mob/clothing/head.dmi'
	icon_state = "winterhood_armor"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list("melee" = 25, "bullet" = 15, "laser" = 5,"energy" = 0, "bomb" = 10, "bio" = 10, "rad" = 5, "fire" = 0, "acid" = 10)
	flags_inv = HIDEHAIR|HIDEEARS
	rad_flags = RAD_NO_CONTAMINATE
