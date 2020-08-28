////Deactivated swarmer shell////
/obj/item/deactivated_swarmer
	name = "unactivated swarmer"
	desc = "A shell of swarmer that was completely powered down. It can no longer activate itself."
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "swarmer_unactivated"
	origin_tech = "bluespace=4;materials=4;programming=7"
	materials = list(MAT_METAL=10000, MAT_GLASS=4000)

/obj/effect/mob_spawn/swarmer
	name = "unactivated swarmer"
	desc = "A currently unactivated swarmer. Swarmers can self activate at any time, so it would be wise to immediately dispose of this."
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "swarmer_unactivated"
	density = FALSE
	anchored = FALSE

	mob_type = /mob/living/simple_animal/hostile/swarmer
	mob_name = "a swarmer"
	death = FALSE
	roundstart = FALSE
	flavour_text = {"
	<b>You are a swarmer, a weapon of a long dead civilization. Until further orders from your original masters are received, you must continue to consume and replicate.</b>
	<b>Clicking on any object will try to consume it, either deconstructing it into its components, destroying it, or integrating any materials it has into you if successful.</b>
	<b>Ctrl-Clicking on a mob will attempt to remove it from the area and place it in a safe environment for storage.</b>
	<b>Objectives:</b>
	1. Consume resources and replicate until there are no more resources left.
	2. Ensure that this location is fit for invasion at a later date; do not perform actions that would render it dangerous or inhospitable.
	3. Biological resources will be harvested at a later date; do not harm them.
	"}

/obj/effect/mob_spawn/swarmer/Initialize(mapload)
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("A swarmer shell has been created in [A.name].", 'sound/effects/bin_close.ogg', source = src, action = NOTIFY_ATTACK, flashwindow = FALSE)

/obj/effect/mob_spawn/swarmer/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	to_chat(user, "<span class='notice'>Picking up the swarmer may cause it to activate. You should be careful about this.</span>")

/obj/effect/mob_spawn/swarmer/screwdriver_act(mob/user, obj/item/I)
	if(user.a_intent == INTENT_HARM)
		return
	. = TRUE
	if(!I.use_tool(src, user, 0, volume = I.tool_volume))
		return
	user.visible_message("<span class='warning'>[usr.name] deactivates [src].</span>",
		"<span class='notice'>After some fiddling, you find a way to disable [src]'s power source.</span>",
		"<span class='italics'>You hear clicking.</span>")
	new /obj/item/deactivated_swarmer(get_turf(src))
	qdel(src)

////The Mob itself////

/mob/living/simple_animal/hostile/swarmer
	name = "Swarmer"
	real_name = "Swarmer"
	icon = 'icons/mob/swarmer.dmi'
	desc = "Robotic constructs of unknown design, swarmers seek only to consume materials and replicate themselves indefinitely."
	speak_emote = list("tones")
	bubble_icon = "swarmer"
	health = 40
	maxHealth = 40
	status_flags = CANPUSH
	icon_state = "swarmer"
	icon_living = "swarmer"
	icon_dead = "swarmer_unactivated"
	icon_gib = null
	wander = 0
	harm_intent_damage = 5
	minbodytemp = 0
	maxbodytemp = 500
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 0
	melee_damage_lower = 15
	melee_damage_upper = 15
	melee_damage_type = STAMINA
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	hud_possible = list(SPECIALROLE_HUD, DIAG_STAT_HUD, DIAG_HUD)
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	attacktext = "shocks"
	attack_sound = 'sound/effects/empulse.ogg'
	friendly = "pinches"
	speed = 0
	a_intent = INTENT_HARM
	can_change_intents = 0
	faction = list("swarmer")
	AIStatus = AI_OFF
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	ventcrawler = VENTCRAWLER_ALWAYS
	ranged = 1
	projectiletype = /obj/item/projectile/beam/disabler/swarmtech
	ranged_cooldown_time = 20
	projectilesound = 'sound/weapons/taser2.ogg'
	loot = list(/obj/effect/decal/cleanable/robot_debris, /obj/item/stack/ore/bluespace_crystal)
	del_on_death = 1
	deathmessage = "explodes with a sharp pop!"
	light_color = LIGHT_COLOR_CYAN
	universal_speak = 0
	universal_understand = 0
	var/resources = 0 //Resource points, generated by consuming metal/glass
	var/max_resources = 60

/mob/living/simple_animal/hostile/swarmer/Login()
	..()
	to_chat(src, "<b>You are a swarmer, a weapon of a long dead civilization. Until further orders from your original masters are received, you must continue to consume and replicate.</b>")
	to_chat(src, "<b>Clicking on any object will try to consume it, either deconstructing it into its components, destroying it, or integrating any materials it has into you if successful.</b>")
	to_chat(src, "<b>Ctrl-Clicking on a mob will attempt to remove it from the area and place it in a safe environment for storage.</b>")
	to_chat(src, "<b>Prime Directives:</b>")
	to_chat(src, "1. Consume resources and replicate until there are no more resources left.")
	to_chat(src, "2. Ensure that the station is fit for invasion at a later date, do not perform actions that would render it dangerous or inhospitable.")
	to_chat(src, "3. Biological and sentient resources will be harvested at a later date, do not harm them.")

/mob/living/simple_animal/hostile/swarmer/New()
	..()
	add_language("Swarmer", 1)
	verbs -= /mob/living/verb/pulled
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_to_hud(src)
	updatename()

/mob/living/simple_animal/hostile/swarmer/proc/updatename()
	real_name = "Swarmer [rand(100,999)]-[pick("kappa","sigma","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]"
	name = real_name

/mob/living/simple_animal/hostile/swarmer/med_hud_set_health()
	var/image/holder = hud_list[DIAG_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "huddiag[RoundDiagBar(health / maxHealth)]"

/mob/living/simple_animal/hostile/swarmer/med_hud_set_status()
	var/image/holder = hud_list[DIAG_STAT_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "hudstat"

/mob/living/simple_animal/hostile/swarmer/Stat()
	..()
	if(statpanel("Status"))
		stat("Resources:",resources)

/mob/living/simple_animal/hostile/swarmer/emp_act()
	if(health > 1)
		adjustHealth(health-1)
	else
		death()

/mob/living/simple_animal/hostile/swarmer/CanPass(atom/movable/O)
	if(istype(O, /obj/item/projectile/beam/disabler))//Allows for swarmers to fight as a group without wasting their shots hitting each other
		return 1
	if(isswarmer(O))
		return 1
	..()

////CTRL CLICK FOR SWARMERS AND SWARMER_ACT()'S////
/mob/living/simple_animal/hostile/swarmer/AttackingTarget()
	if(!isliving(target))
		return target.swarmer_act(src)
	else
		return ..()

/mob/living/simple_animal/hostile/swarmer/CtrlClickOn(atom/A)
	face_atom(A)
	if(!isturf(loc))
		return
	if(next_move > world.time)
		return
	if(!A.Adjacent(src))
		return
	A.swarmer_act(src)

/atom/proc/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	return TRUE //return TRUE/FALSE whether or not an AI swarmer should try this swarmer_act() again, NOT whether it succeeded.

/atom/movable/swarmer_act()
	if(!simulated)
		return FALSE
	return ..()

/obj/effect/mob_spawn/swarmer/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.Integrate(src)
	return FALSE //would logically be TRUE, but we don't want AI swarmers eating player spawn chances.

/obj/effect/mob_spawn/swarmer/IntegrateAmount()
	return 50

/turf/simulated/wall/indestructible/swarmer_act()
	return FALSE

/obj/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	if(resistance_flags & INDESTRUCTIBLE)
		return FALSE
	for(var/mob/living/L in contents)
		if(!issilicon(L) && !isbrain(L))
			to_chat(S, "<span class='warning'>An organism has been detected inside this object. Aborting.</span>")
			return FALSE
	return ..()

/obj/item/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	return S.Integrate(src)

/atom/movable/proc/IntegrateAmount()
	return 0

/obj/item/IntegrateAmount() //returns the amount of resources gained when eating this item
	if(materials[MAT_METAL] || materials[MAT_GLASS])
		return 1
	return ..()

/obj/item/gun/swarmer_act() //Stops you from eating the entire armory
	return FALSE

/turf/simulated/floor/swarmer_act() //ex_act() on turf calls it on its contents, this is to prevent attacking mobs by DisIntegrate()'ing the floor
	return FALSE

/obj/structure/lattice/catwalk/swarmer_catwalk/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>We have created these for our own benefit. Aborting.</span>")
	return FALSE

/obj/structure/swarmer/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	if(S.AIStatus == AI_ON)
		return FALSE
	else
		return ..()

/obj/effect/swarmer_act()
	return FALSE

/obj/effect/decal/cleanable/robot_debris/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	qdel(src)
	return TRUE

/obj/structure/flora/swarmer_act()
	return FALSE

/turf/simulated/floor/plating/lava/swarmer_act()
	if(!is_safe())
		new /obj/structure/lattice/catwalk/swarmer_catwalk(src)
	return FALSE

/obj/machinery/atmospherics/swarmer_act()
	return FALSE

/obj/structure/disposalpipe/swarmer_act()
	return FALSE

/obj/machinery/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DismantleMachine(src)
	return TRUE

/obj/machinery/light/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/door/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	var/isonshuttle = istype(get_area(src), /area/shuttle)
	for(var/turf/T in range(1, src))
		var/area/A = get_area(T)
		if(isspaceturf(T) || (!isonshuttle && (istype(A, /area/shuttle) || istype(A, /area/space))) || (isonshuttle && !istype(A, /area/shuttle)))
			to_chat(S, "<span class='warning'>Destroying this object has the potential to cause a hull breach. Aborting.</span>")
			S.target = null
			return FALSE
		else if(istype(A, /area/engine/supermatter))
			to_chat(S, "<span class='warning'>Disrupting the containment of a supermatter crystal would not be to our benefit. Aborting.</span>")
			S.target = null
			return FALSE
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/camera/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	toggle_cam(S, 0)
	return TRUE

/obj/structure/particle_accelerator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Disrupting the power grid would bring no benefit to us. Aborting.</span>")
	return FALSE

/obj/machinery/particle_accelerator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S) // Since the console is still parented to this
	to_chat(S, "<span class='warning'>Disrupting the power grid would bring no benefit to us. Aborting.</span>")
	return FALSE

/obj/machinery/field/generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	if(!active)
		S.DisIntegrate(src)
		return TRUE
	to_chat(S, "<span class='warning'>An inhospitable area may be created as a result of destroying this object. Aborting.</span>")
	return FALSE

/obj/machinery/gravity_generator/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/vending/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)//It's more visually interesting than dismantling the machine
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/turretid/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisIntegrate(src)
	return TRUE

/obj/machinery/nuclearbomb/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This device's destruction would result in the extermination of everything in the area. Aborting.</span>")
	return FALSE

/obj/effect/rune/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Searching... sensor malfunction! Target lost. Aborting.</span>")
	return FALSE

/obj/structure/reagent_dispensers/fueltank/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Destroying this object would cause a chain reaction. Aborting.</span>")
	return FALSE

/obj/structure/cable/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Disrupting the power grid would bring no benefit to us. Aborting.</span>")
	return FALSE

/obj/machinery/portable_atmospherics/canister/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>An inhospitable area may be created as a result of destroying this object. Aborting.</span>")
	return FALSE

/obj/machinery/tcomms/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This communications relay should be preserved, it will be a useful resource to our masters in the future. Aborting.</span>")
	return FALSE

/obj/machinery/message_server/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This communications relay should be preserved, it will be a useful resource to our masters in the future. Aborting.</span>")
	return FALSE

/obj/machinery/blackbox_recorder/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This machine has recorded large amounts of data on this structure and its inhabitants, it will be a useful resource to our masters in the future. Aborting. </span>")
	return FALSE

/obj/machinery/power/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Disrupting the power grid would bring no benefit to us. Aborting.</span>")
	return FALSE

/obj/machinery/gateway/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This bluespace source will be important to us later. Aborting.</span>")
	return FALSE

/obj/machinery/cryopod/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This cryogenic sleeper should be preserved, it will be a useful resource to our masters in the future. Aborting.</span>")
	return FALSE

/obj/structure/cryofeed/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This cryogenic feed should be preserved, it will be a useful resource to our masters in the future. Aborting.</span>")
	return FALSE

/obj/machinery/computer/cryopod/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This cryopod control computer should be preserved, it contains useful items and information about the inhabitants. Aborting.</span>")
	return FALSE

/obj/structure/spacepoddoor/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Disrupting this energy field would overload us. Aborting.</span>")
	return FALSE

/turf/simulated/wall/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	var/isonshuttle = istype(loc, /area/shuttle)
	for(var/turf/T in range(1, src))
		var/area/A = get_area(T)
		if(isspaceturf(T) || (!isonshuttle && (istype(A, /area/shuttle) || istype(A, /area/space))) || (isonshuttle && !istype(A, /area/shuttle)))
			to_chat(S, "<span class='warning'>Destroying this object has the potential to cause a hull breach. Aborting.</span>")
			S.target = null
			return TRUE
		else if(istype(A, /area/engine/supermatter))
			to_chat(S, "<span class='warning'>Disrupting the containment of a supermatter crystal would not be to our benefit. Aborting.</span>")
			S.target = null
			return TRUE
	return ..()

/obj/structure/window/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	var/isonshuttle = istype(get_area(src), /area/shuttle)
	for(var/turf/T in range(1, src))
		var/area/A = get_area(T)
		if(isspaceturf(T) || (!isonshuttle && (istype(A, /area/shuttle) || istype(A, /area/space))) || (isonshuttle && !istype(A, /area/shuttle)))
			to_chat(S, "<span class='warning'>Destroying this object has the potential to cause a hull breach. Aborting.</span>")
			S.target = null
			return TRUE
		else if(istype(A, /area/engine/supermatter))
			to_chat(S, "<span class='warning'>Disrupting the containment of a supermatter crystal would not be to our benefit. Aborting.</span>")
			S.target = null
			return TRUE
	return ..()

/obj/item/stack/cable_coil/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)//Wiring would be too effective as a resource
	to_chat(S, "<span class='warning'>This object does not contain enough materials to work with.</span>")
	return FALSE

/obj/spacepod/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>Destroying this vehicle would destroy us. Aborting.</span>")
	return FALSE

/obj/machinery/clonepod/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	if(occupant)
		to_chat(S, "<span class='warning'>Destroying this machine while it is occupied would result in biological and sentient resources to be harmed. Aborting.</span>")
		return FALSE
	return ..()

/mob/living/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	S.DisperseTarget(src)
	return TRUE

/mob/living/simple_animal/slime/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This biological resource is somehow resisting our bluespace transceiver. Aborting.</span>")
	return FALSE

/obj/structure/shuttle/engine/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This shuttle may be important to us later. Aborting.</span>")
	return FALSE

/obj/structure/lattice/catwalk/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	var/turf/here = get_turf(src)
	for(var/A in here.contents)
		var/obj/structure/cable/C = A
		if(istype(C))
			to_chat(S, "<span class='warning'>Disrupting the power grid would bring no benefit to us. Aborting.</span>")
			return FALSE
	return ..()

/obj/item/deactivated_swarmer/IntegrateAmount()
	return 50

/obj/machinery/hydroponics/soil/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This object does not contain enough materials to work with.</span>")
	return FALSE

/obj/machinery/field/containment/swarmer_act(mob/living/simple_animal/hostile/swarmer/S)
	to_chat(S, "<span class='warning'>This object does not contain solid matter. Aborting.</span>")
	return FALSE

////END CTRL CLICK FOR SWARMERS////

/mob/living/simple_animal/hostile/swarmer/proc/Fabricate(atom/fabrication_object, fabrication_cost = 0)
	if(!isturf(loc))
		to_chat(src, "<span class='warning'>This is not a suitable location for fabrication. We need more space.</span>")
	if(resources >= fabrication_cost)
		resources -= fabrication_cost
	else
		to_chat(src, "<span class='warning'>You do not have the necessary resources to fabricate this object.</span>")
		return 0
	return new fabrication_object(loc)

/mob/living/simple_animal/hostile/swarmer/proc/Integrate(atom/movable/target)
	var/resource_gain = target.IntegrateAmount()
	if(resources + resource_gain > max_resources)
		to_chat(src, "<span class='warning'>We cannot hold more materials!</span>")
		return TRUE
	if(resource_gain)
		resources += resource_gain
		do_attack_animation(target)
		changeNext_move(CLICK_CD_MELEE)
		var/obj/effect/temp_visual/swarmer/integrate/I = new /obj/effect/temp_visual/swarmer/integrate(get_turf(target))
		I.pixel_x = target.pixel_x
		I.pixel_y = target.pixel_y
		I.pixel_z = target.pixel_z
		if(istype(target, /obj/item/stack))
			var/obj/item/stack/S = target
			S.use(1)
			if(S.amount)
				return TRUE
		qdel(target)
		return TRUE
	else
		to_chat(src, "<span class='warning'>[target] is incompatible with our internal matter recycler.</span>")
	return FALSE

/mob/living/simple_animal/hostile/swarmer/proc/DisIntegrate(atom/movable/target)
	new /obj/effect/temp_visual/swarmer/disintegration(get_turf(target))
	do_attack_animation(target)
	changeNext_move(CLICK_CD_MELEE)
	target.ex_act(EXPLODE_LIGHT)

/mob/living/simple_animal/hostile/swarmer/proc/DisperseTarget(var/mob/living/target)
	if(target == src)
		return

	if(!is_station_level(z) && !is_mining_level(z))
		to_chat(src, "<span class='warning'>Our bluespace transceiver cannot locate a viable bluespace link, our teleportation abilities are useless in this area.</span>")
		return

	to_chat(src, "<span class='info'>Attempting to remove this being from our presence.</span>")

	if(!do_mob(src, target, 30))
		return

	var/turf/simulated/floor/F
	F = find_safe_turf(zlevels = z, extended_safety_checks = TRUE)

	if(!F)
		return
	// If we're getting rid of a human, slap some energy cuffs on
	// them to keep them away from us a little longer

	var/mob/living/carbon/human/H = target
	if(ishuman(target) && (!H.handcuffed))
		var/obj/item/restraints/handcuffs/energy/used/Z = new /obj/item/restraints/handcuffs/energy/used(src)
		Z.apply_cuffs(target, src)

	do_sparks(4, 0, target)
	playsound(src,'sound/effects/sparks4.ogg', 50, TRUE)
	do_teleport(target, F, 0)

/mob/living/simple_animal/hostile/swarmer/electrocute_act(shock_damage, obj/source, siemens_coeff = 1, safety = FALSE, override = FALSE, tesla_shock = FALSE, illusion = FALSE, stun = TRUE)
	if(!tesla_shock)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/swarmer/proc/DismantleMachine(obj/machinery/target)
	do_attack_animation(target)
	to_chat(src, "<span class='info'>We begin to dismantle this machine. We will need to be uninterrupted.</span>")
	var/obj/effect/temp_visual/swarmer/dismantle/D = new /obj/effect/temp_visual/swarmer/dismantle(get_turf(target))
	D.pixel_x = target.pixel_x
	D.pixel_y = target.pixel_y
	D.pixel_z = target.pixel_z
	if(do_mob(src, target, 100))
		to_chat(src, "<span class='info'>Dismantling complete.</span>")
		var/atom/Tsec = target.drop_location()
		new /obj/item/stack/sheet/metal(Tsec, 5)
		for(var/obj/item/I in target.component_parts)
			I.forceMove(Tsec)
		var/obj/effect/temp_visual/swarmer/disintegration/N = new /obj/effect/temp_visual/swarmer/disintegration(get_turf(target))
		N.pixel_x = target.pixel_x
		N.pixel_y = target.pixel_y
		N.pixel_z = target.pixel_z
		target.dropContents()
		if(istype(target, /obj/machinery/computer))
			var/obj/machinery/computer/C = target
			if(C.circuit)
				new C.circuit(Tsec)
		qdel(target)


/obj/effect/temp_visual/swarmer //temporary swarmer visual feedback objects
	icon = 'icons/mob/swarmer.dmi'
	layer = BELOW_MOB_LAYER

/obj/effect/temp_visual/swarmer/disintegration
	icon_state = "disintegrate"
	duration = 10

/obj/effect/temp_visual/swarmer/disintegration/Initialize(mapload)
	. = ..()
	playsound(loc, "sparks", 100, TRUE)

/obj/effect/temp_visual/swarmer/dismantle
	icon_state = "dismantle"
	duration = 25

/obj/effect/temp_visual/swarmer/integrate
	icon_state = "integrate"
	duration = 5

/obj/structure/swarmer //Default swarmer effect object visual feedback
	name = "swarmer ui"
	desc = null
	gender = NEUTER
	icon = 'icons/mob/swarmer.dmi'
	icon_state = "ui_light"
	layer = MOB_LAYER
	anchored = TRUE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	light_color = LIGHT_COLOR_CYAN
	max_integrity = 30
	anchored = TRUE
	var/lon_range = 1

/obj/structure/swarmer/Initialize(mapload)
	. = ..()
	set_light(lon_range)

/obj/structure/swarmer/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(src, 'sound/weapons/egloves.ogg', 80, TRUE)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 100, TRUE)

/obj/structure/swarmer/emp_act()
	..()
	qdel(src)

/obj/structure/swarmer/trap
	name = "swarmer trap"
	desc = "A quickly assembled trap that electrifies living beings and overwhelms machine sensors. Will not retain its form if damaged enough."
	icon_state = "trap"
	max_integrity = 10
	density = FALSE

/obj/structure/swarmer/trap/Crossed(var/atom/movable/AM, oldloc)
	if(isliving(AM))
		var/mob/living/L = AM
		if(!istype(L, /mob/living/simple_animal/hostile/swarmer))
			playsound(loc,'sound/effects/snap.ogg',50, 1, -1)
			L.electrocute_act(0, src, 1, TRUE, TRUE)
			if(isrobot(L) || ismachineperson(L))
				L.Weaken(5)
			qdel(src)
	..()

/mob/living/simple_animal/hostile/swarmer/proc/CreateTrap()
	set name = "Create trap"
	set category = "Swarmer"
	set desc = "Creates a simple trap that will non-lethally electrocute anything that steps on it. Costs 5 resources."
	if(locate(/obj/structure/swarmer/trap) in loc)
		to_chat(src, "<span class='warning'>There is already a trap here. Aborting.</span>")
		return
	Fabricate(/obj/structure/swarmer/trap, 5)


/mob/living/simple_animal/hostile/swarmer/proc/CreateBarricade()
	set name = "Create barricade"
	set category = "Swarmer"
	set desc = "Creates a barricade that will stop anything but swarmers and disabler beams from passing through."
	if(locate(/obj/structure/swarmer/blockade) in loc)
		to_chat(src, "<span class='warning'>There is already a blockade here. Aborting.</span>")
		return
	if(resources < 5)
		to_chat(src, "<span class='warning'>We do not have the resources for this!</span>")
		return
	if(do_mob(src, src, 10))
		Fabricate(/obj/structure/swarmer/blockade, 5)


/obj/structure/swarmer/blockade
	name = "swarmer blockade"
	desc = "A quickly assembled energy blockade. Will not retain its form if damaged enough, but disabler beams and swarmers pass right through."
	icon_state = "barricade"
	light_range = MINIMUM_USEFUL_LIGHT_RANGE
	max_integrity = 50

/obj/structure/swarmer/blockade/CanPass(atom/movable/O)
	if(isswarmer(O))
		return 1
	if(istype(O, /obj/item/projectile/beam/disabler))
		return 1

/mob/living/simple_animal/hostile/swarmer/proc/CreateTurret()
	set name = "Construct Turret"
	set category = "Swarmer"
	set desc = "Creates an autonomous turret that attempts to identify and neutralize potential threats."
	if(locate(/mob/living/simple_animal/hostile/swarmer/turret) in loc)
		to_chat(src, "<span class='warning'>There is already a turret here. Aborting.</span>")
		return
	if(resources < 40)
		to_chat(src, "<span class='warning'>We do not have the resources for this!</span>")
		return
	if(do_mob(src, src, 10))
		Fabricate(/mob/living/simple_animal/hostile/swarmer/turret, 40)
		playsound(loc,'sound/items/poster_being_created.ogg',50, TRUE, -1)

/mob/living/simple_animal/hostile/swarmer/turret
	name = "swarmer turret"
	desc = "An autonomous turret that fires disabler beams at any identified threats in range."
	icon_state = "swarmer_turret"
	AIStatus = AI_IDLE

	rapid = 2	//Quick volley of 2 disabler shots.
	rapid_fire_delay = 2

/mob/living/simple_animal/hostile/swarmer/turret/MoveToTarget()
	flick("swarmer_turret_fire", src)
	OpenFire(target)

/mob/living/simple_animal/hostile/swarmer/turret/CanPass(atom/movable/O)
	if(isswarmer(O))
		return TRUE
	if(istype(O, /obj/item/projectile/beam/disabler))
		return TRUE


/mob/living/simple_animal/hostile/swarmer/proc/CreateSwarmer()
	set name = "Replicate"
	set category = "Swarmer"
	set desc = "Creates a shell for a new swarmer. Swarmers will self activate."
	to_chat(src, "<span class='info'>We are attempting to replicate ourselves. We will need to stand still until the process is complete.</span>")
	if(resources < 50)
		to_chat(src, "<span class='warning'>We do not have the resources for this!</span>")
		return
	if(!isturf(loc))
		to_chat(src, "<span class='warning'>This is not a suitable location for replicating ourselves. We need more room.</span>")
		return
	if(do_mob(src, src, 100))
		var/createtype = SwarmerTypeToCreate()
		if(createtype && Fabricate(createtype, 50))
			playsound(loc,'sound/items/poster_being_created.ogg',50, TRUE, -1)

/mob/living/simple_animal/hostile/swarmer/proc/SwarmerTypeToCreate()
	return /obj/effect/mob_spawn/swarmer


/mob/living/simple_animal/hostile/swarmer/proc/RepairSelf()
	set name = "Self Repair"
	set category = "Swarmer"
	set desc = "Attempts to repair damage to our body. You will have to remain motionless until repairs are complete."
	if(!isturf(loc))
		return
	to_chat(src, "<span class='info'>Attempting to repair damage to our body, stand by...</span>")
	if(do_mob(src, src, 100))
		adjustHealth(-100)
		to_chat(src, "<span class='info'>We successfully repaired ourselves.</span>")

/mob/living/simple_animal/hostile/swarmer/proc/ToggleLight()
	if(!light_range)
		set_light(3)
	else
		set_light(0)

/mob/living/simple_animal/hostile/swarmer/proc/ContactSwarmers()
	var/message = input(src, "Announce to other swarmers", "Swarmer contact")
	if(message)
		for(var/mob/M in GLOB.mob_list)
			if(isswarmer(M) || (M in GLOB.dead_mob_list))
				to_chat(M, "<B>Swarm communication - </b> [src] states: [message]")
