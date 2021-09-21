/mob/living/simple_animal/hostile/megafauna/apothalsnow
	name = "apothal snow"
	desc = "A being made purely of ice"
	health = 1500
	maxHealth = 1500
	attack_verb_continuous = "shatters"
	attack_verb_simple = "freezes"
	attack_sound = 'sound/magic/clockwork/ratvar_attack.ogg'
	icon_state = "apo"
	icon_living = "apo"
	icon_dead = "dragon_dead"
	health_doll_icon = "apo"
	friendly_verb_continuous = "frowns upon"
	friendly_verb_simple = "frown upon"
	icon = 'icons/mob/lavaland/96x96megafauna.dmi'
	speak_emote = list("bellows")
	armour_penetration = 20
	melee_damage_lower = 35
	melee_damage_upper = 50
	speed = 2
	move_to_delay = 5
	ranged = 1
	pixel_x = -32
	del_on_death = TRUE
	loot = list(/obj/item/claymore/unforgiven)
	butcher_results = list(/obj/item/stack/ore/diamond = 5, /obj/item/stack/sheet/sinew = 5, /obj/item/stack/sheet/animalhide/ashdrake = 10, /obj/item/stack/sheet/bone = 30)
	deathmessage = "<span class='colossus'>screams in agony before breaking apart</span>"
	death_sound = 'sound/magic/abomscream.ogg'

/mob/living/simple_animal/hostile/megafauna/apothalsnow/devour(mob/living/L)
	visible_message("<span class='colossus'>[src] tears [L] apart!</span>")
	L.gib()

/mob/living/simple_animal/hostile/megafauna/apothalsnow/OpenFire()
	anger_modifier = clamp(((maxHealth - health)/50),0,20)
	ranged_cooldown = world.time + 90

	move_to_delay = initial(move_to_delay)

	if(prob(20+anger_modifier)) //Major attack
		INVOKE_ASYNC(src, .proc/frozenblast)
		if(health < maxHealth/1.5)
			rush()
			move_to_delay = 2.5

		if(health < maxHealth/3)
			INVOKE_ASYNC(src, .proc/frozenblast_angered)

	else if(prob(20))
		ranged_cooldown = world.time + 10
		rush()
	else
		if(prob(70))
			ranged_cooldown = world.time + 30
			blast_weak()
		else if(health < maxHealth/0.7)
			ranged_cooldown = world.time + 10
			blast_strong()
		else
			ranged_cooldown = world.time + 50
			INVOKE_ASYNC(src, .proc/frozenblast)


/mob/living/simple_animal/hostile/megafauna/apothalsnow/Initialize()
	. = ..()
	internal = new/obj/item/gps/internal/apothalsnow(src)

/mob/living/simple_animal/hostile/megafauna/apothalsnow/proc/frozenblast()
	blast_weak()
	sleep(5)
	blast_weak()
	sleep(5)
	blast_weak()
	sleep(5)
	blast_weak()

/mob/living/simple_animal/hostile/megafauna/apothalsnow/proc/rush()
	for(var/mob/M in range(20,src))
		if(M.client)
			flash_color(M.client, "#00C8B7", 1.2)
			shake_camera(M, 5, 4)
	playsound(src, 'sound/magic/clockwork/narsie_attack.ogg', 200, 1)
	move_to_delay = 3.8
	sleep(5)
	move_to_delay = 5


/mob/living/simple_animal/hostile/megafauna/apothalsnow/proc/frozenblast_angered()
	blast_strong()
	sleep(10)
	blast_strong()
	sleep(8)
	blast_strong()
	sleep(6)
	blast_strong()
	sleep(4)
	blast_strong()
	sleep(2)
	blast_strong()

/mob/living/simple_animal/hostile/megafauna/apothalsnow/proc/shoot_projectile(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/item/projectile/P = new /obj/item/projectile/apothalsnow(startloc)
	P.preparePixelProjectile(marker, startloc)
	P.firer = src
	if(target)
		P.original = target
	P.fire(set_angle)

/mob/living/simple_animal/hostile/megafauna/apothalsnow/proc/blast_weak(set_angle)
	var/turf/target_turf = get_turf(target)
	playsound(src, 'sound/magic/clockwork/invoke_general.ogg', 200, 1, 2)
	newtonian_move(get_dir(target_turf, src))
	var/angle_to_target = Get_Angle(src, target_turf)
	visible_message("<span class='colossus'>You will never be forgiven!</span>")
	if(isnum(set_angle))
		angle_to_target = set_angle
	var/static/list/apothalsnow_shotgun_shot_angles = list(8.5, 0, -8.5)
	for(var/i in apothalsnow_shotgun_shot_angles)
		shoot_projectile(target_turf, angle_to_target + i)


/mob/living/simple_animal/hostile/megafauna/apothalsnow/proc/blast_strong(set_angle)
	var/turf/target_turf = get_turf(target)
	playsound(src, 'sound/magic/clockwork/invoke_general.ogg', 200, 1, 2)
	newtonian_move(get_dir(target_turf, src))
	var/angle_to_target = Get_Angle(src, target_turf)
	visible_message("<span class='colossus'>Beg for mercy!</span>")
	if(isnum(set_angle))
		angle_to_target = set_angle
	var/static/list/apothalsnow_shotgun_shot_angles = list(180.5, 150.5, 120.5, 90.5, 60.5, 30.5, 0, -30.5, -60.5, -90.5, -120.5, -150.5)
	for(var/i in apothalsnow_shotgun_shot_angles)
		shoot_projectile(target_turf, angle_to_target + i)


/obj/item/projectile/apothalsnow
	name ="ice bolt"
	icon_state= "chronobolt"
	damage = 25
	armour_penetration = 45
	pixels_per_second = TILES_TO_PIXELS(5)
	eyeblur = 0
	damage_type = BRUTE
	pass_flags = PASSTABLE


/obj/item/gps/internal/apothalsnow
	icon_state = null
	gpstag = "Frozen Signal"
	desc = "Get in the fucking robot."
	invisibility = 100
