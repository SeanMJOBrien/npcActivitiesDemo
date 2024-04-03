void GetSpawnResRef()
{
object oSelf = OBJECT_SELF;
string sTag = GetTag(oSelf);
//Prevents summons from creating extra spawns.
if(GetMaster(oSelf) != OBJECT_INVALID)
  return;
//Change the following strings to account for the actual spawns.
if(sTag == "friend")
  {
  SetLocalInt(oSelf, "NumSpawns", 2); //Insert the number of different followers you will use
  SetLocalString(oSelf, "Spawn1", "dwf_sqr002");
  SetLocalInt(oSelf, "Spawn1Num", 3);// Sets the number uses for this follower
  SetLocalString(oSelf, "Spawn2", "dwf_sqr2");
  SetLocalInt(oSelf, "Spawn2Num", 1);
  }
/*if(sTag == "CREATURE2")
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
  }           */
//Keep repeating until all cases are accounted for
return;
}

void DoExtraSpawn(int nCreatures, string sResRef)
{
object oSelf = OBJECT_SELF;
object oArea = GetArea(oSelf);
object oSpawn;
vector vPos;
location lLoc;
int nCount = 0;
while(nCount < nCreatures)
  {
  vPos = GetPosition(oSelf) + AngleToVector(IntToFloat(Random(360)));
  lLoc = Location(oArea, vPos, GetFacing(oSelf));
  oSpawn = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLoc);
  SetLocalObject(oSpawn, "MASTER", oSelf);
  nCount++;
  }
}

void main()
{
object oSelf = OBJECT_SELF;
GetSpawnResRef();
int nCount = 1;
int nFollowers = GetLocalInt(oSelf, "NumSpawns");
string sNum;
string sResRef;
int nNum;
while(nCount <= nFollowers)
  {
  sNum = "Spawn" + IntToString(nCount);
  sResRef = GetLocalString(oSelf, sNum);
  sNum += "Num";
  nNum = GetLocalInt(oSelf, sNum);
  DoExtraSpawn(nNum, sResRef);
  nCount++;
  }
  //Qlippoth add for treasure, etc.
  ExecuteScript("qnw_c2_default9",oSelf);
}
