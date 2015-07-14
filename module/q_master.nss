void GetSpawnResRef()
{
object oSelf = OBJECT_SELF;
string sTag = GetTag(oSelf);
//Prevents summons from creating extra spawns.
if(GetMaster(oSelf) != OBJECT_INVALID)
  return;
//Change the following strings to account for the actual spawns.

// Need to change this script to check the LocalVar, since we use Tags for everything in NPCA
if(sTag == "friend")
  {
  SetLocalInt(oSelf, "NumSpawns", 2); //Insert the number of different followers you will use
  SetLocalString(oSelf, "Spawn1", "dwf_sqr002");
  SetLocalInt(oSelf, "Spawn1Num", 3);// Sets the number uses for this follower
  SetLocalString(oSelf, "Spawn2", "dwf_sqr2");
  SetLocalInt(oSelf, "Spawn2Num", 1);
  }
if(sTag == "foe")
  {
  SetLocalInt(oSelf, "NumSpawns", 2); //Insert the number of different followers you will use
  SetLocalString(oSelf, "Spawn1", "drgr_sqr002");
  SetLocalInt(oSelf, "Spawn1Num", 3);// Sets the number uses for this follower
  SetLocalString(oSelf, "Spawn2", "drgr_sqr2");
  SetLocalInt(oSelf, "Spawn2Num", 1);
  }
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
//  ExecuteScript("qnw_c2_default9",oSelf);
}
