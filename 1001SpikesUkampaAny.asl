
state("1001 Spikes")
{
	// stores flags for every level (0x00 : uncompleted ; 0x01 : skipped ; 0x02 : completed)
	byte35 levelFlags : 0x12BEC0;

	int screenStack : 0x132878;
	int skulls : 0x0012B4DC, 0x00, 0x00;
	int lives : 0x12b4c8;
}

startup
{
	vars.levelCount = 0;

	settings.Add("splitAllLevels", true, "Split for every level (turn off to split for every world)");

	// setting up a death count that can be displayed with asl var viewer
	// asl var viewer doesn't update when the variable is 0 (or "0"), so we need a 2nd variable as a workaround
	vars.deathCount = 0;
	vars.useThisDeathCount = "-";
}

start
{
	vars.levelCount = 0;
	vars.deathCount = 0;
	vars.useThisDeathCount = "-";
	return (current.levelFlags[0] == 0 && current.screenStack == 2);
}

reset
{
	// if we're back on the save selection screen
	return (current.screenStack == 1);
}

split
{
	// prevents splitting before resetting 
	if (current.screenStack < 3){
		return false;
	}

	if (timer.Run.CategoryName == "Any% Ukampa") {
		if (settings["splitAllLevels"]) {
			// split for every level
			if (
					current.levelFlags[vars.levelCount] != old.levelFlags[vars.levelCount] &&
					current.levelFlags[vars.levelCount] == 0x02
			   ) 
			{
				vars.levelCount = Math.Min(34, ++vars.levelCount);
				//vars.levelCount < 34 ? ++vars.levelCount : 34;
				return true;
			}
		}
		else {
			// split for every world
			if (
					current.levelFlags[vars.levelCount] != old.levelFlags[vars.levelCount] &&
					current.levelFlags[vars.levelCount] == 0x02
			   ) 
			{
				if (vars.levelCount % 6 == 5 || vars.levelCount == 34) {
					vars.levelCount = Math.Min(34, ++vars.levelCount);
					return true;
				}
				else {
					vars.levelCount = Math.Min(34, ++vars.levelCount);
				}
			}
		}
	}
	else if(timer.Run.CategoryName == "All Skulls (Ukampa)") {
		if (settings["splitAllLevels"]) {
			// split for every level
			if (
					current.levelFlags[vars.levelCount] == 0x02 &&
					current.skulls == Math.Pow(2, Math.Min(30, vars.levelCount + 1)) - 1
			   ) 
			{
				vars.levelCount = Math.Min(34, ++vars.levelCount);
				return true;
			}
		}
		else {
			// split for every world
			if (
					current.levelFlags[vars.levelCount] == 0x02 &&
					current.skulls == Math.Pow(2, Math.Min(30, vars.levelCount + 1)) - 1
			   ) 
			{
				if (vars.levelCount % 6 == 5 || vars.levelCount == 34) {
					vars.levelCount = Math.Min(34, ++vars.levelCount);
					return true;
				}
				else {
					vars.levelCount = Math.Min(34, ++vars.levelCount);
				}
			}
		}
	}
}

update
{
	// death count
	if (current.lives < old.lives)
	{
		++vars.deathCount;
	}
	vars.useThisDeathCount = vars.deathCount != 0 ? vars.deathCount : "-";
	

	// debug stuff
	if (current.levelFlags[vars.levelCount] != old.levelFlags[vars.levelCount] ) {
		print("level : " + vars.levelCount.ToString());
	}
}
