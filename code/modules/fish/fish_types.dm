
/datum/fish
	var/obj/egg_item = /obj/item/fish_eggs
	var/obj/fish_item = /obj/item/reagent_containers/food/snacks/fish
	var/crossbreeder = 1	//determines if the fish will attempt to breed with other types, set to 0 if you want the fish to only lay eggs with its own species

/datum/fish/proc/special_interact(obj/machinery/fishtank/my_tank)
	return

/datum/fish/goldfish
	egg_item = /obj/item/fish_eggs/goldfish
	fish_item = /obj/item/reagent_containers/food/snacks/fish/goldfish

/datum/fish/glofish
	egg_item = /obj/item/fish_eggs/glofish
	fish_item = /obj/item/reagent_containers/food/snacks/fish/glofish

/datum/fish/clownfish
	egg_item = /obj/item/fish_eggs/clownfish
	fish_item = /obj/item/reagent_containers/food/snacks/fish/clownfish

/datum/fish/shark
	egg_item = /obj/item/fish_eggs/shark
	fish_item = /obj/item/reagent_containers/food/snacks/fish/shark

/datum/fish/babycarp
	egg_item = /obj/item/fish_eggs/babycarp
	fish_item = /obj/item/reagent_containers/food/snacks/fish/babycarp

/datum/fish/catfish
	egg_item = /obj/item/fish_eggs/catfish
	fish_item = /obj/item/reagent_containers/food/snacks/fish/catfish

/datum/fish/catfish/special_interact(obj/machinery/fishtank/my_tank)
	if(!my_tank || !istype(my_tank))
		return
	if(my_tank.filth_level > 0 && prob(33))
		my_tank.adjust_filth_level(-0.1)

/datum/fish/salmon
	egg_item = /obj/item/fish_eggs/salmon
	fish_item = /obj/item/reagent_containers/food/snacks/fish/salmon

/datum/fish/shrimp
	egg_item = /obj/item/fish_eggs/shrimp
	fish_item = /obj/item/reagent_containers/food/snacks/fish/shrimp
	crossbreeder = 0

/datum/fish/feederfish
	egg_item = /obj/item/fish_eggs/feederfish
	fish_item = /obj/item/reagent_containers/food/snacks/fish/feederfish

/datum/fish/feederfish/special_interact(obj/machinery/fishtank/my_tank)
	if(!my_tank || !istype(my_tank))
		return
	if(my_tank.fish_count < 2)
		return
	if(my_tank.food_level <= 5 && prob(25))
		my_tank.adjust_food_level(1)
		my_tank.kill_fish(src)

/datum/fish/electric_eel
	egg_item = /obj/item/fish_eggs/electric_eel
	fish_item = /obj/item/reagent_containers/food/snacks/fish/electric_eel
	crossbreeder = 0
