
state("1001 Spikes")
{
	byte35 levels : 0x12BEC0;
	int FSMStack : 0x132878;
	int screen : 0x132860;

}

start
{
	return (current.levels[0] == 0 && current.FSMStack == 2);
}

reset
{
	return (current.FSMStack == 1);
}

split
{
	if (current.FSMStack < 3){
		return;
	}

	for(int i = 0 ; i < 35 ; i++) {
		if(current.levels[i] != old.levels[i]) return true;
	}
}

update
{
	/// print(current.screen.ToString());
}
