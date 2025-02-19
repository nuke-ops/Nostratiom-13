//Aux base construction console
/mob/camera/aiEye/remote/base_construction
	name = "construction holo-drone"
	move_on_shuttle = 1 //Allows any curious crew to watch the base after it leaves. (This is safe as the base cannot be modified once it leaves)
	icon = 'icons/obj/mining.dmi'
	icon_state = "construction_drone"
	var/area/starting_area

/mob/camera/aiEye/remote/base_construction/Initialize(mapload)
	. = ..()
	starting_area = get_area(loc)

/mob/camera/aiEye/remote/base_construction/setLoc(var/t)
	var/area/curr_area = get_area(t)
	if(curr_area == starting_area || istype(curr_area, /area/shuttle/auxillary_base))
		return ..()
	//While players are only allowed to build in the base area, but consoles starting outside the base can move into the base area to begin work.

/mob/camera/aiEye/remote/base_construction/relaymove(mob/user, direct)
	dir = direct //This camera eye is visible as a drone, and needs to keep the dir updated
	..()

/obj/item/construction/rcd/internal //Base console's internal RCD. Roundstart consoles are filled, rebuilt cosoles start empty.
	name = "internal RCD"
	max_matter = 600 //Bigger container and faster speeds due to being specialized and stationary.
	no_ammo_message = "<span class='warning'>Internal matter exhausted. Please add additional materials.</span>"
	delay_mod = 0.5
	upgrade = TRUE
	var/obj/machinery/computer/camera_advanced/base_construction/console

/obj/item/construction/rcd/internal/check_menu(mob/living/user)
	if(!istype(user) || user.incapacitated() || !user.Adjacent(console))
		return FALSE
	return TRUE

/obj/machinery/computer/camera_advanced/base_construction
	name = "base construction console"
	desc = "An industrial computer integrated with a camera-assisted rapid construction drone."
	networks = list("ss13")
	var/obj/item/construction/rcd/internal/RCD //Internal RCD. The computer passes user commands to this in order to avoid massive copypaste.
	circuit = /obj/item/circuitboard/computer/base_construction
	off_action = /datum/action/innate/camera_off/base_construction
	jump_action = null
	var/datum/action/innate/aux_base/switch_mode/switch_mode_action = /datum/action/innate/aux_base/switch_mode //Action for switching the RCD's build modes
	var/datum/action/innate/aux_base/build/build_action = /datum/action/innate/aux_base/build //Action for using the RCD
	var/datum/action/innate/aux_base/airlock_type/airlock_mode_action = /datum/action/innate/aux_base/airlock_type //Action for setting the airlock type
	var/datum/action/innate/aux_base/window_type/window_action = /datum/action/innate/aux_base/window_type //Action for setting the window type
	var/datum/action/innate/aux_base/place_fan/fan_action = /datum/action/innate/aux_base/place_fan //Action for spawning fans
	var/fans_remaining = 0 //Number of fans in stock.
	var/datum/action/innate/aux_base/install_turret/turret_action = /datum/action/innate/aux_base/install_turret //Action for spawning turrets
	var/turret_stock = 0 //Turrets in stock
	var/obj/machinery/computer/auxillary_base/found_aux_console //Tracker for the Aux base console, so the eye can always find it.

	icon_screen = "mining"
	icon_keyboard = "rd_key"

	light_color = LIGHT_COLOR_PINK

/obj/machinery/computer/camera_advanced/base_construction/Initialize(mapload)
	. = ..()

	populate_actions_list()

	RCD = new(src)
	RCD.console = src
	if(mapload) //Map spawned consoles have a filled RCD and stocked special structures
		RCD.matter = RCD.max_matter
		fans_remaining = 4
		turret_stock = 4

/**
 * Fill the construction_actios list with actions
 *
 * Instantiate each action object that we'll be giving to users of
 * this console, and put it in the actions list
 */
/obj/machinery/computer/camera_advanced/base_construction/proc/populate_actions_list()
	actions += new switch_mode_action(src)
	actions += new build_action(src)
	actions += new airlock_mode_action(src)
	actions += new window_action(src)
	actions += new fan_action(src)
	actions += new turret_action(src)

/obj/machinery/computer/camera_advanced/base_construction/CreateEye()

	var/spawn_spot
	for(var/obj/machinery/computer/auxillary_base/ABC in GLOB.machines)
		if(istype(get_area(ABC), /area/shuttle/auxillary_base))
			found_aux_console = ABC
			break

	if(found_aux_console)
		spawn_spot = found_aux_console
	else
		spawn_spot = src


	eyeobj = new /mob/camera/aiEye/remote/base_construction(get_turf(spawn_spot))
	eyeobj.origin = src


/obj/machinery/computer/camera_advanced/base_construction/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/rcd_ammo) || istype(W, /obj/item/stack/sheet))
		RCD.attackby(W, user, params) //If trying to feed the console more materials, pass it along to the RCD.
	else
		return ..()

/obj/machinery/computer/camera_advanced/base_construction/Destroy()
	QDEL_NULL(RCD)
	return ..()

/obj/machinery/computer/camera_advanced/base_construction/GrantActions(mob/living/user)
	eyeobj.invisibility = 0 //When the eye is in use, make it visible to players so they know when someone is building.
	return ..()

/obj/machinery/computer/camera_advanced/base_construction/remove_eye_control(mob/living/user)
	eyeobj.invisibility = INVISIBILITY_MAXIMUM //Hide the eye when not in use.
	return ..()

/datum/action/innate/aux_base //Parent aux base action
	icon_icon = 'icons/mob/actions/actions_construction.dmi'
	var/mob/camera/aiEye/remote/base_construction/remote_eye //Console's eye mob
	var/obj/machinery/computer/camera_advanced/base_construction/B //Console itself

/datum/action/innate/aux_base/Activate()
	if(!target)
		return TRUE
	remote_eye = owner.remote_control
	B = target
	if(!B.RCD) //The console must always have an RCD.
		B.RCD = new /obj/item/construction/rcd/internal(B) //If the RCD is lost somehow, make a new (empty) one!
		B.RCD.console = B

/datum/action/innate/aux_base/proc/check_spot()
//Check a loction to see if it is inside the aux base at the station. Camera visbility checks omitted so as to not hinder construction.
	var/turf/build_target = get_turf(remote_eye)
	var/area/build_area = get_area(build_target)

	if(!istype(build_area, /area/shuttle/auxillary_base))
		to_chat(owner, "<span class='warning'>You can only build within the mining base!</span>")
		return FALSE

	if(!is_station_level(build_target.z))
		to_chat(owner, "<span class='warning'>The mining base has launched and can no longer be modified.</span>")
		return FALSE

	return TRUE

/datum/action/innate/camera_off/base_construction
	name = "Log out"

//*******************FUNCTIONS*******************

/datum/action/innate/aux_base/build
	name = "Build"
	button_icon_state = "build"

/datum/action/innate/aux_base/build/Activate()
	if(..())
		return

	if(!check_spot())
		return

	var/turf/target_turf = get_turf(remote_eye)
	var/atom/rcd_target = target_turf

	//Find airlocks and other shite
	for(var/obj/S in target_turf)
		if(LAZYLEN(S.rcd_vals(owner,B.RCD)))
			rcd_target = S //If we don't break out of this loop we'll get the last placed thing

	owner.DelayNextAction(CLICK_CD_RANGE)
	B.RCD.afterattack(rcd_target, owner, TRUE) //Activate the RCD and force it to work remotely!
	playsound(target_turf, 'sound/items/deconstruct.ogg', 60, 1)

/datum/action/innate/aux_base/switch_mode
	name = "Switch Mode"
	button_icon_state = "builder_mode"

/datum/action/innate/aux_base/switch_mode/Activate()
	if(..())
		return

	var/list/buildlist = list("Walls and Floors" = 1,"Airlocks" = 2,"Deconstruction" = 3,"Windows and Grilles" = 4)
	var/buildmode = input("Set construction mode.", "Base Console", null) in buildlist
	if(buildmode)
		B.RCD.mode = buildlist[buildmode]
		to_chat(owner, "Build mode is now [buildmode].")

/datum/action/innate/aux_base/airlock_type
	name = "Select Airlock Type"
	button_icon_state = "airlock_select"

/datum/action/innate/aux_base/airlock_type/Activate()
	if(..())
		return

/datum/action/innate/aux_base/window_type
	name = "Select Window Glass"
	button_icon_state = "window_select"

/datum/action/innate/aux_base/window_type/Activate()
	if(..())
		return
	B.RCD.toggle_window_glass() // Nostra change - glass instead of type

/datum/action/innate/aux_base/place_fan
	name = "Place Tiny Fan"
	button_icon_state = "build_fan"

/datum/action/innate/aux_base/place_fan/Activate()
	if(..())
		return

	var/turf/fan_turf = get_turf(remote_eye)

	if(!B.fans_remaining)
		to_chat(owner, "<span class='warning'>[B] is out of fans!</span>")
		return

	if(!check_spot())
		return

	if(fan_turf.density)
		to_chat(owner, "<span class='warning'>Fans may only be placed on a floor.</span>")
		return

	new /obj/structure/fans/tiny(fan_turf)
	B.fans_remaining--
	to_chat(owner, "<span class='notice'>Tiny fan placed. [B.fans_remaining] remaining.</span>")
	playsound(fan_turf, 'sound/machines/click.ogg', 50, 1)

/datum/action/innate/aux_base/install_turret
	name = "Install Plasma Anti-Wildlife Turret"
	button_icon_state = "build_turret"

/datum/action/innate/aux_base/install_turret/Activate()
	if(..())
		return

	if(!check_spot())
		return

	if(!B.turret_stock)
		to_chat(owner, "<span class='warning'>Unable to construct additional turrets.</span>")
		return

	var/turf/turret_turf = get_turf(remote_eye)

	if(is_blocked_turf(turret_turf))
		to_chat(owner, "<span class='warning'>Location is obstructed by something. Please clear the location and try again.</span>")
		return

	var/obj/machinery/porta_turret/aux_base/T = new /obj/machinery/porta_turret/aux_base(turret_turf)
	if(B.found_aux_console)
		B.found_aux_console.turrets += T //Add new turret to the console's control

	B.turret_stock--
	to_chat(owner, "<span class='notice'>Turret installation complete!</span>")
	playsound(turret_turf, 'sound/items/drill_use.ogg', 65, 1)
