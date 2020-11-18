//////////////////////////////////////////////
//			Aquarium Supplies				//
//////////////////////////////////////////////

/obj/item/fish_net
	name = "fish net"
	desc = "A tiny net for harvesting fish and eggs from an aquarium. It's a death sentence!"
	description_info = "<b>Use</b> it in your hand to switch between harvesting fish and eggs."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "net"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	var/mode = MODE_FISH

//Fancy pants radial menu to switch between scooping eggs and fish with the net, just like an RCD
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
//				The Fish					//
//////////////////////////////////////////////


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
	list_reagents = list("protein" = 5)

	var/meatobject = null 										//What meat do we get when we filet the fish? (Type path)
	var/meatamount = 0 											//How much meat do we get from each fish? (Int)
	var/list/bonusobject = list() 								//If specified, the fish will also drop this item when butchered. (List of type paths)

	var/list/passiveproduct = null								//What this fish produces passively, if anything. (Type path)
	var/producerate = 1											//If the fish has a passive product, how quickly it makes it. 1 is max speed, 0 means no production. (decimal 0 - 1)

	var/obj/item/fish_eggs/egg_item = /obj/item/fish_eggs		//What eggs does this fish lay? (Type path)
	var/breedrate = 1 											//How quickly fish lay eggs when breeding is possible. 1 is max speed, 0 means no eggs at all. (decimal 0 - 1)

/obj/item/reagent_containers/food/snacks/fish/attackby(var/obj/item/O, var/mob/user as mob)
	. = ..()
	if(is_sharp(O))
		if(meatobject)
			to_chat(user, "You carefully clean and gut [src].")
			var/i
			for(i=0, i<meatamount+1, i++)
				new meatobject(get_turf(src))
		if(bonusobject.len)
			for(var/obj/B in bonusobject)
				new B(get_turf(src))
		qdel(src)
	return

/obj/item/reagent_containers/food/snacks/fish/shrimp
	name = "shrimp"
	desc = "A single raw shrimp."
	icon = 'icons/obj/food/seafood.dmi'
	icon_state = "shrimp_raw"
	filling_color = "#FF1C1C"
	egg_item = /obj/item/fish_eggs/shrimp

/obj/item/reagent_containers/food/snacks/fish/shrimp/New()
	..()
	desc = pick("Anyway, like I was sayin', shrimp is the fruit of the sea.", "You can barbecue it, boil it, broil it, bake it, saute it.")



/obj/item/reagent_containers/food/snacks/fish/feederfish
	name = "feeder fish"
	desc = "A tiny feeder fish. Sure doesn't look very filling..."
	icon = 'icons/obj/food/seafood.dmi'
	icon_state = "feederfish"
	filling_color = "#FF1C1C"
	egg_item = /obj/item/fish_eggs/feederfish


/obj/item/reagent_containers/food/snacks/fish/glofish
	name = "glofish"
	desc = "A small bio-luminescent fish. Not very bright, but at least it's pretty!"
	icon_state = "glofish"
	egg_item = /obj/item/fish_eggs/glofish

/obj/item/reagent_containers/food/snacks/fish/glofish/Initialize()
	..()
	set_light(2,1,"#99FF66")



/obj/item/reagent_containers/food/snacks/fish/electric_eel
	name = "electric eel"
	desc = "An eel capable of producing an electric shock. Luckily it's rather weak out of water."
	icon_state = "electric_eel"
	list_reagents = list("protein" = 5, "teslium" = 1)
	egg_item = /obj/item/fish_eggs/electric_eel


/obj/item/reagent_containers/food/snacks/fish/shark
	name = "shark"
	desc = "Warning: Keep away from tornadoes."
	icon_state = "shark"
	hitsound = 'sound/weapons/bite.ogg'
	force = 3
	egg_item = /obj/item/fish_eggs/shark

/obj/item/reagent_containers/food/snacks/fish/shark/attackby(var/obj/item/O, var/mob/user as mob)
	if(istype(O, /obj/item/wirecutters))
		to_chat(user, "You rip out the teeth of \the [src.name]!")
		new /obj/item/reagent_containers/food/snacks/fish/toothless_shark(get_turf(src))
		new /obj/item/shard/shark_teeth(get_turf(src))
		qdel(src)
		return
	..()


/obj/item/reagent_containers/food/snacks/fish/catfish
	name = "catfish"
	desc = "Apparently, catfish don't purr like you might have expected them to. Such a confusing name!"
	icon_state = "catfish"
	egg_item = /obj/item/fish_eggs/catfish


/obj/item/reagent_containers/food/snacks/fish/goldfish
	name = "goldfish"
	desc = "A goldfish, just like the one you never won at the county fair."
	icon_state = "goldfish"
	egg_item = /obj/item/fish_eggs/goldfish


/obj/item/reagent_containers/food/snacks/fish/salmon
	name = "salmon"
	desc = "The second-favorite food of Space Bears, right behind crew members."
	icon_state = "salmon"
	egg_item = /obj/item/fish_eggs/salmon


/obj/item/reagent_containers/food/snacks/fish/babycarp
	name = "baby space carp"
	desc = "Substantially smaller than the space carp lurking outside the hull, but still unsettling."
	icon_state = "babycarp"
	hitsound = 'sound/weapons/bite.ogg'
	force = 3
	egg_item = /obj/item/fish_eggs/babycarp


/obj/item/reagent_containers/food/snacks/fish/clownfish
	name = "clown fish"
	desc = "Even underwater, you cannot escape the HONKing."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "clownfish"
	throwforce = 1
	force = 1
	egg_item = /obj/item/fish_eggs/clownfish

/obj/item/reagent_containers/food/snacks/fish/crimson_ray
	name = "crimson ray"
	desc = "This toothy \"fish\" lives in rivers of molten magma. Lovely..."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "crimson_ray"
	throwforce = 1
	force = 1
	egg_item = /obj/item/fish_eggs/crimson_ray
	bonusobject =

//////////////////////////////////////////////
//			Fish-related loot				//
//////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/fish/toothless_shark
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

/obj/item/kitchen/knife/raytooth
	name = "ray tooth"
	desc = "A razor-sharp tooth from a dead crimson ray."
	icon = 'icons/obj/fish_items.dmi'
	icon_state = "raytooth"
	force = 15
	throwforce = 10
	attack_verb = list("stabbed", "gored", "sliced", "slashed", "cut")

