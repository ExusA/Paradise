//////////////////////////////////////////////
//			Aquarium Supplies				//
//////////////////////////////////////////////

/obj/item/fish_net
	name = "fish net"
	desc = "A tiny net for harvesting fish and eggs from an aquarium. It's a death sentence!"
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "net"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	var/mode = MODE_FISH

//Fancy pants radial menu to switch between scooping eggs and fish
/obj/item/fish_net/attack_self(mob/user)
	radial_menu(user)

/obj/item/fish_net/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/fish_net/proc/radial_menu(mob/user)
	if(!check_menu(user))
		return
	var/list/choices = list(
		MODE_FISHEGGS = image(icon = 'icons/obj/fish_items.dmi', icon_state = "eggs"),
		MODE_FISH = image(icon = 'icons/obj/fish_items.dmi', icon_state = "goldfish")
	)
	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, .proc/check_menu, user))
	if(!check_menu(user))
		return
	switch(choice)
		if(MODE_FISHEGGS, MODE_FISH)
			mode = choice
		else
			return
	to_chat(user, "<span class='notice'>You are now collecting [mode] with the fish scoop.</span>")

/obj/item/fish_net/suicide_act(mob/user)			//"A tiny net is a death sentence: it's a net and it's tiny!" https://www.youtube.com/watch?v=FCI9Y4VGCVw
	to_chat(viewers(user), "<span class='warning'>[user] places the [src.name] on top of [user.p_their()] head, [user.p_their()] fingers tangled in the netting! It looks like [user.p_theyre()] trying to commit suicide.</span>")
	return OXYLOSS

/obj/item/fishfood
	name = "fish food can"
	desc = "A small can of Carp's Choice brand fish flakes. The label shows a smiling Space Carp."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "fish_food"
	throwforce = 1
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7

/obj/item/tank_brush
	name = "aquarium brush"
	desc = "A brush for cleaning the inside of aquariums. Contains a built-in odor neutralizer."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "brush"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	attack_verb = list("scrubbed", "brushed", "scraped")

/obj/item/tank_brush/suicide_act(mob/user)
	to_chat(viewers(user), "<span class='warning'>[user] is vigorously scrubbing [user.p_them()]self raw with the [name]! It looks like [user.p_theyre()] trying to commit suicide.</span>")
	return BRUTELOSS|FIRELOSS

//////////////////////////////////////////////
//				Fish Items					//
//////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/fish/shrimp
	name = "shrimp"
	desc = "A single raw shrimp."
	icon = 'icons/obj/food/seafood.dmi'
	icon_state = "shrimp_raw"
	filling_color = "#FF1C1C"

/obj/item/reagent_containers/food/snacks/fish/shrimp/New()
	..()
	desc = pick("Anyway, like I was sayin', shrimp is the fruit of the sea.", "You can barbecue it, boil it, broil it, bake it, saute it.")
	reagents.add_reagent("protein", 1)
	src.bitesize = 1

/obj/item/reagent_containers/food/snacks/fish/feederfish
	name = "feeder fish"
	desc = "A tiny feeder fish. Sure doesn't look very filling..."
	icon = 'icons/obj/food/seafood.dmi'
	icon_state = "feederfish"
	filling_color = "#FF1C1C"

/obj/item/reagent_containers/food/snacks/fish/shrimp/New()
	..()
	reagents.add_reagent("protein", 1)
	src.bitesize = 1

/obj/item/reagent_containers/food/snacks/fish
	name = "fish"
	desc = "A generic fish"
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "fish"
	throwforce = 1
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	force = 1
	bitesize = 6
	list_reagents = list("protein" = 5, "water" = 2)

/obj/item/reagent_containers/food/snacks/fish/glofish
	name = "glofish"
	desc = "A small bio-luminescent fish. Not very bright, but at least it's pretty!"
	icon_state = "glofish"

/obj/item/reagent_containers/food/snacks/fish/glofish/New()
	..()
	set_light(2,1,"#99FF66")

/obj/item/reagent_containers/food/snacks/fish/electric_eel
	name = "electric eel"
	desc = "An eel capable of producing an electric shock. Luckily it's rather weak out of water."
	icon_state = "electric_eel"
	list_reagents = list("protein" = 5, "water" = 2, "teslium" = 1)

/obj/item/reagent_containers/food/snacks/fish/shark
	name = "shark"
	desc = "Warning: Keep away from tornadoes."
	icon_state = "shark"
	hitsound = 'sound/weapons/bite.ogg'
	force = 3

/obj/item/reagent_containers/food/snacks/fish/attackby(var/obj/item/O, var/mob/user as mob)
	if(istype(O, /obj/item/wirecutters))
		to_chat(user, "You rip out the teeth of \the [src.name]!")
		new /obj/item/fish/toothless_shark(get_turf(src))
		new /obj/item/shard/shark_teeth(get_turf(src))
		qdel(src)
		return
	..()

/obj/item/fish/toothless_shark
	name = "toothless shark"
	desc = "Looks like someone ripped it's teeth out!"
	icon_state = "shark"
	hitsound = 'sound/effects/snap.ogg'

/obj/item/shard/shark_teeth
	name = "shark teeth"
	desc = "A number of teeth, supposedly from a shark."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "teeth"
	force = 2.0
	throwforce = 5.0
	materials = list()

/obj/item/shard/shark_teeth/New()
	..()
	src.pixel_x = rand(-5,5)
	src.pixel_y = rand(-5,5)

/obj/item/reagent_containers/food/snacks/fish/catfish
	name = "catfish"
	desc = "Apparently, catfish don't purr like you might have expected them to. Such a confusing name!"
	icon_state = "catfish"

/obj/item/reagent_containers/food/snacks/fish/catfish/attackby(var/obj/item/O, var/mob/user as mob)
	if(is_sharp(O))
		to_chat(user, "You carefully clean and gut \the [src.name].")
		new /obj/item/reagent_containers/food/snacks/catfishmeat(get_turf(src))
		new /obj/item/reagent_containers/food/snacks/catfishmeat(get_turf(src))
		qdel(src)
		return
	..()

/obj/item/reagent_containers/food/snacks/fish/goldfish
	name = "goldfish"
	desc = "A goldfish, just like the one you never won at the county fair."
	icon_state = "goldfish"

/obj/item/reagent_containers/food/snacks/fish/salmon
	name = "salmon"
	desc = "The second-favorite food of Space Bears, right behind crew members."
	icon_state = "salmon"

/obj/item/reagent_containers/food/snacks/fish/salmon/attackby(var/obj/item/O, var/mob/user as mob)
	if(is_sharp(O))
		to_chat(user, "You carefully clean and gut \the [src.name].")
		new /obj/item/reagent_containers/food/snacks/salmonmeat(get_turf(src))
		new /obj/item/reagent_containers/food/snacks/salmonmeat(get_turf(src))
		qdel(src)
		return
	..()

/obj/item/reagent_containers/food/snacks/fish/babycarp
	name = "baby space carp"
	desc = "Substantially smaller than the space carp lurking outside the hull, but still unsettling."
	icon_state = "babycarp"
	hitsound = 'sound/weapons/bite.ogg'
	force = 3

/obj/item/reagent_containers/food/snacks/fish/babycarp/attackby(var/obj/item/O, var/mob/user as mob)
	if(is_sharp(O))
		to_chat(user, "You carefully clean and gut \the [src.name].")
		new /obj/item/reagent_containers/food/snacks/carpmeat(get_turf(src)) //just one fillet; this is a baby, afterall.
		qdel(src)
		return
	..()


/obj/item/reagent_containers/food/snacks/fish/clownfish
	name = "clown fish"
	desc = "Even underwater, you cannot escape HONKing."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "clownfish"
	throwforce = 1
	force = 1
	attack_verb = list("slapped", "humiliated", "hit", "rubbed")
