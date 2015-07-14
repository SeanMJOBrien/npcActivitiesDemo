///////////////////////////////////////////////////////////////////////////////
// npcact_scripte - OnBlocked default script for NPC ACTIVITIES 6.0
// By Deva Bryson Winblood.   Last Modified: 05/24/10 peak
///////////////////////////////////////////////////////////////////////////////
// DOCUMENTATION FOR THIS SCRIPT:
// This script supports SPEAKING ON BLOCK variables of the following names:
// sGNBDoorBlock, sGNBLockedBlock,sGNBAnimalBlock, sGNBVerminBlock, sGNBPrejudicedBlock,
// sGNBMaleBlock, sGNBFemaleBlock, sGNBPCBlock, sGNBNPCBlock, sGNBCreatureBlock,
// sGNBContainerBlock, and sGNBPlaceableBlock.    corPeak
// -- the value should be <#>/<statement>/<statement> where # is the # of statements
// available and statement is what you want them to say.  If a statement is set to NA
// they will say nothing in that case
// It also supports SCRIPT EXECUTION ON BLOCK variables and these variables
// are named the same as all of the above scripts but, have Scr appended to the
// end of the variable name.  The value is the script to execute.
// You can also change the default BEHAVIOUR when blocked by a CREATURE or PLACEABLE
// This is stored as the variable nGNBBlockingBehavior and by default is 0
// 0 = normal behavior
// 1 = run away short distance
// 2 = run away long distance
// 3 = pick nearby object and move towards it a bit
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"

int fnBashOkay(object oDoor)
{ // can we bash it?
  int bReturn=FALSE;
  if (GetPlotFlag(oDoor)!=TRUE&&GetAlignmentLawChaos(OBJECT_SELF)!=ALIGNMENT_LAWFUL)
    bReturn=TRUE;
  return bReturn;
} // fnBashOkay()

void fnAbortThisDestination()
{ // cancel moving to this destination return to POST or NIGHT
  SetLocalString(OBJECT_SELF,"sGNBDTag","");
  SetLocalString(OBJECT_SELF,"sGNBActions","");
} // fnAbortThisDestination()

void fnDoSpeech(string sSay)
{
  object oMe=OBJECT_SELF;
  string sParse;
  int nN;
  int nC;
  int nR;
  string sMaster=sSay;
  fnDebug("Blocked - Do Speech '"+sSay+"'",TRUE);
  sParse=fnParse(sMaster,"/");
  nN=StringToInt(sParse);
  if (nN>0)
  { // statements
    sMaster=fnRemoveParsed(sMaster,sParse,"/");
    nR=Random(nN)+1;
    nC=1;
    sParse=fnParse(sMaster,"/");
    sMaster=fnRemoveParsed(sMaster,sParse,"/");
    while(nC<nR&&GetStringLength(sMaster)>0)
    { // find statement
      nC++;
      sParse=fnParse(sMaster,"/");
      sMaster=fnRemoveParsed(sMaster,sParse,"/");
    } // find statement
    if (sParse!="NA"&&sParse!="")
    {
      AssignCommand(oMe,SpeakString(sParse));
    }
  } // statements
} // fnDoSpeech()

int fnStringCheck(string sS)
{ // check to see if speak or script strings defined
  int nRet=FALSE;
  if (GetLocalString(OBJECT_SELF,sS)!="") nRet=TRUE;
  if (GetLocalString(OBJECT_SELF,sS+"Scr")!="") nRet=TRUE;
  return nRet;
} // fnStringCheck()

void fnDoorBlocked(object oDoor,int bLocked=FALSE)
{
  string sValue;
  fnDebug("fnDoorBlocked()",TRUE);
  if (bLocked==TRUE)
  { // LOCKED DOOR
    sValue=GetLocalString(oDoor,"sGNBLockedBlock");
    if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
    sValue=GetLocalString(oDoor,"sGNBLockedBlockScr");
    if (GetStringLength(sValue)>2) ExecuteScript(sValue,OBJECT_SELF);
  } // LOCKED DOOR
  else
  { // NOT LOCKED
    sValue=GetLocalString(oDoor,"sGNBDoorBlock");
    if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
    sValue=GetLocalString(oDoor,"sGNBDoorBlockScr");
    if (GetStringLength(sValue)>2) ExecuteScript(sValue,OBJECT_SELF);
  } // NOT LOCKED
} // fnDoorBlocked()

void fnPlaceableBlocked(object oPlc,int bContainer=FALSE)
{
  string sValue;
  fnDebug("fnPlaceableBlocked()",TRUE);
  if (bContainer==TRUE)
  { // Containet
    sValue=GetLocalString(oPlc,"sGNBContainerBlock");
    if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
    sValue=GetLocalString(oPlc,"sGNBContainerBlockScr");
    if (GetStringLength(sValue)>2) ExecuteScript(sValue,OBJECT_SELF);
  } // Containet
  else
  { // Not a container
    sValue=GetLocalString(oPlc,"sGNBPlaceableBlock");
    if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
    sValue=GetLocalString(oPlc,"sGNBPlaceableBlockScr");
    if (GetStringLength(sValue)>2) ExecuteScript(sValue,OBJECT_SELF);
  } // Not a container
} // fnPlaceableBlocked()

void fnCreatureBlockedReactCheck(object oCreature)
{
   object oMe=OBJECT_SELF;
   int nGender=GetGender(oCreature);
   int nRace=GetRacialType(oCreature);
   string sValue;
   fnDebug("fnCreatureBlockedReactCheck()",TRUE);
  if (GetLocalInt(oCreature,"bHasBlocked"+GetTag(oMe))!=TRUE)
  { // has not already blocked
   SetLocalInt(oCreature,"bHasBlocked"+GetTag(oMe),TRUE);
   DelayCommand(20.0,DeleteLocalInt(oCreature,"bHasBlocked"+GetTag(oMe)));
   if (nRace==RACIAL_TYPE_ANIMAL&&fnStringCheck("sGNBAnimalBlock"))
   { // blocked by an animal
     sValue=GetLocalString(oMe,"sGNBAnimalBlock");
     if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
     sValue=GetLocalString(oMe,"sGNBAnimalBlockScr");
     if (GetStringLength(sValue)>2) ExecuteScript(sValue,oMe);
   } // blocked by an animal
   else if (nRace==RACIAL_TYPE_VERMIN&&fnStringCheck("sGNBVerminBlock"))
   { // blocked by vermin
     sValue=GetLocalString(oMe,"sGNBVerminBlock");
     if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
     sValue=GetLocalString(oMe,"sGNBVerminBlockScr");
     if (GetStringLength(sValue)>2) ExecuteScript(sValue,oMe);
   } // blocked by vermin
   else if (nRace!=GetRacialType(OBJECT_SELF)&&fnStringCheck("sGNBPrejudicedBlock"))
   { // Prejudiced
     sValue=GetLocalString(oMe,"sGNBPrejudicedBlock");
     if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
     sValue=GetLocalString(oMe,"sGNBPrejudicedBlockScr");
     if (GetStringLength(sValue)>2) ExecuteScript(sValue,oMe);
   } // Prejudiced
   else if (nGender==GENDER_MALE&&fnStringCheck("sGNBMaleBlock"))
   { // Male
     sValue=GetLocalString(oMe,"sGNBMaleBlock");
     if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
     sValue=GetLocalString(oMe,"sGNBMaleBlockScr");
     if (GetStringLength(sValue)>2) ExecuteScript(sValue,oMe);
   } // Male
   else if (nGender==GENDER_FEMALE&&fnStringCheck("sGNBFemaleBlock"))
   { // Female
     sValue=GetLocalString(oMe,"sGNBFemaleBlock");
     if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
     sValue=GetLocalString(oMe,"sGNBFemaleBlockScr");
     if (GetStringLength(sValue)>2) ExecuteScript(sValue,oMe);
   } // Female
   else if (GetIsPC(oCreature)&&fnStringCheck("sGNBPCBlock"))
   { // PC
     sValue=GetLocalString(oMe,"sGNBPCBlock");
     if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
     sValue=GetLocalString(oMe,"sGNBPCBlockScr");
     if (GetStringLength(sValue)>2) ExecuteScript(sValue,oMe);
   } // PC
   else if (!GetIsPC(oCreature)&&fnStringCheck("sGNBNPCBlock"))
   { // NPC
     sValue=GetLocalString(oMe,"sGNBNPCBlock");
     if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
     sValue=GetLocalString(oMe,"sGNBNPCBlockScr");
     if (GetStringLength(sValue)>2) ExecuteScript(sValue,oMe);
   } // NPC
   else if (fnStringCheck("sGNBCreatureBlock"))
   { // Creature
     sValue=GetLocalString(oMe,"sGNBCreatureBlock");
     if (GetStringLength(sValue)>1) fnDoSpeech(sValue);
     sValue=GetLocalString(oMe,"sGNBCreatureBlockScr");
     if (GetStringLength(sValue)>2) ExecuteScript(sValue,oMe);
   } // Creature
  } // Has already blocked
} // fnCreatureBlockedReactCheck()

void fnBlockingBehavior(object oBlocker)
{
  object oMe=OBJECT_SELF;
  object oMove;
  float fDur=3.0;
  int nOpt=GetLocalInt(oMe,"nGNBBlockingBehavior");
  if (nOpt==2) fDur=6.0;
  AssignCommand(oMe,ClearAllActions());
  fnDebug("npcact_scripte - Blocking Behavior",TRUE);
  if (nOpt!=3)
  {
    AssignCommand(oMe,ActionMoveAwayFromLocation(GetLocation(oBlocker),TRUE));
  }
  else
  { // find nearby object
    oMove=GetNearestObject(OBJECT_TYPE_ALL,oMe,d10());
    if (!GetIsObjectValid(oMove)) oMove=GetNearestObject(OBJECT_TYPE_ALL,oMe,d8());
    if (!GetIsObjectValid(oMove)) oMove=GetNearestObject(OBJECT_TYPE_ALL,oMe,d6());
    if (!GetIsObjectValid(oMove)) oMove=GetNearestObject(OBJECT_TYPE_ALL,oMe,d4());
    if (GetIsObjectValid(oMove))
    {
      AssignCommand(oMe,ActionMoveToObject(oMove,TRUE,1.0));
    }
  } // find nearby object
  DelayCommand(fDur,AssignCommand(oMe,ClearAllActions()));
} // fnBlockingBehavior()

/////////////////////////////////////////////////////////////////////// MAIN
void main()
{
     object oMe=OBJECT_SELF;
     object oDoor=GetBlockingDoor();
     int nInt=GetAbilityScore(OBJECT_SELF,ABILITY_INTELLIGENCE);
     int nRace=GetRacialType(OBJECT_SELF);
     object oKey=GetItemPossessedBy(OBJECT_SELF,GetLockKeyTag(oDoor));
     //AssignCommand(OBJECT_SELF,SpeakString("I am blocked by "+GetName(oDoor)+"."));
     fnDebug("Blocked By "+GetName(oDoor),TRUE);
     if (GetObjectType(oDoor)==OBJECT_TYPE_DOOR)
     { // blocked by a door
       if (fnStringCheck("sGNBDoorBlock")) fnDoorBlocked(oDoor);
       if (nInt>=7&&nRace!=RACIAL_TYPE_ANIMAL&&nRace!=RACIAL_TYPE_VERMIN&&nRace!=RACIAL_TYPE_BEAST)
       { // has ability to open door
         if (GetIsTrapped(oDoor)==TRUE)
         { // door is trapped
           if (GetHasSkill(SKILL_DISABLE_TRAP,OBJECT_SELF)==TRUE)
           { // try to disarm the trap
             ActionUseSkill(SKILL_DISABLE_TRAP,oDoor);
             return;
           } // try to disarm the trap
           else
           { // cannot disarm traps
             fnAbortThisDestination();
             return;
           } // cannot disarm traps
         } // door is trapped
         else if (GetLocked(oDoor)==TRUE)
         { // door is locked
           if (fnStringCheck("sGNBLockedBlock")) fnDoorBlocked(oDoor,TRUE);
           if (oKey!=OBJECT_INVALID)
           { // unlock door
             DoDoorAction(oDoor,DOOR_ACTION_UNLOCK);
             SetLocked(oDoor,FALSE);
             return;
           } // unlock door
           else
           { // don't have the key
             if (GetHasSkill(SKILL_OPEN_LOCK,OBJECT_SELF)==TRUE)
             { // try to pick the lock
               ActionUseSkill(SKILL_OPEN_LOCK,oDoor);
               return;
             } // try to pick the lock
             else
             { // cannot pick locks
               if (fnBashOkay(oDoor)==TRUE)
               { // we can bash it
                 DoDoorAction(oDoor,DOOR_ACTION_BASH);
                 return;
               } // we can bash it
               else
               { // this door is not passable
                 fnAbortThisDestination();
                 return;
               } // this door is not passable
             } // cannot pick locks
           } // don't have the key
         } // door is locked
         else
         { // door is not locked
           if (GetIsDoorActionPossible(oDoor,DOOR_ACTION_OPEN)==TRUE)
           { // can open door
             DoDoorAction(oDoor,DOOR_ACTION_OPEN);
             AssignCommand(oDoor,ActionOpenDoor(oDoor));
             return;
           } // can open door
         } // door is not locked
       } // has ability to open door
       else if (nInt>=7)
       { // cannot open door but, might bash or claw it
         if (fnBashOkay(oDoor)==TRUE)
         { // we can bash it
           DoDoorAction(oDoor,DOOR_ACTION_BASH);
           return;
         } // we can bash it
         else
         { // this door is not passable
           fnAbortThisDestination();
           return;
         } // this door is not passable
       } // cannot open door but, might bash or claw it
      } // object type door
      else if (GetObjectType(oDoor)==OBJECT_TYPE_CREATURE)
      { // blocked by a creature
        if (GetLocalInt(oMe,"nNN")!=TRUE&&GetIsPC(oDoor)==FALSE) //nNN from FULL interpreter
        { // NPC
          fnCreatureBlockedReactCheck(oDoor);
        } // NPC
        else if (GetLocalInt(oMe,"nNPCACTNOPC")!=TRUE&&GetIsPC(oDoor)==TRUE)
        { // PC
          fnCreatureBlockedReactCheck(oDoor);
        } // PC
      } // blocked by a creature
      else if (GetObjectType(oDoor)==OBJECT_TYPE_PLACEABLE)
      { // blocked by a placeable
        if (GetHasInventory(oDoor)&&fnStringCheck("sGNBContainerBlock")) fnPlaceableBlocked(oDoor,TRUE);
        else if (fnStringCheck("sGNBPlaceableBlock")) fnPlaceableBlocked(oDoor);
      } // blocked by a placeable
      if (GetLocalInt(OBJECT_SELF,"nGNBBlockingBehavior")!=0) fnBlockingBehavior(oDoor);
}
//////////////////////////////////////////////////////////////////////// MAIN
