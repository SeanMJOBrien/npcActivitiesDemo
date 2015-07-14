//Add to OnSpawn of Leader creature.
//void GetSpawnResRef()
void main()
{
object oSelf = OBJECT_SELF;
string sTag = GetTag(oSelf);
//Prevents summons from creating extra spawns.
if(GetMaster(oSelf) != OBJECT_INVALID)
  return;
//Change the following strings to account for the actual spawns.
if(sTag == "foe")
  {
  SetLocalInt(oSelf, "NumSpawns", 1); //Insert the number of different followers you will use
  SetLocalString(oSelf, "Spawn1", "drgr_sqr002");
  SetLocalInt(oSelf, "Spawn1Num", 3);// Sets the number uses for this follower
  SetLocalString(oSelf, "Spawn2", "drgr_sqr002");
  SetLocalInt(oSelf, "Spawn2Num", 0);
  }
if(sTag == "CREATURE2")
  {
  SetLocalInt(oSelf, "NumSpawns", 4);
  SetLocalString(oSelf, "Spawn1", "INSERT_FIRST_SPAWN_RESREF_HERE");
  SetLocalInt(oSelf, "Spawn1Num", 3);
  SetLocalString(oSelf, "Spawn2", "INSERT_SECOND_SPAWN_RESREF_HERE");
  SetLocalInt(oSelf, "Spawn2Num", 2);
  SetLocalString(oSelf, "Spawn3", "INSERT_THIRD_SPAWN_RESREF_HERE");
  SetLocalInt(oSelf, "Spawn3Num", 5);
  SetLocalString(oSelf, "Spawn4", "INSERT_FOURTH_SPAWN_RESREF_HERE");
  SetLocalInt(oSelf, "Spawn4Num", 1);
  }
//Keep repeating until all cases are accounted for
return;
}
