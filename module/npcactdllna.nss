/////////////////////////////////////////////////////////////////////////
// NPC ACTIVITIES 5.0 - ACTION LIBRARY
// Version: 1.0
// Library name: NA
// Also used with NPC ACTIVITIES 6.0 but, did not require modification
//=======================================================================
// Author: Deva Bryson Winblood
// Date  : 02/20/2003
// Modified by peak 4/12/09, added Frozen Animation
//=======================================================================
// This library handles actions that do not neatly fall under another
// library category but, are useful to the development of a module.
// Can be called by upper-case: #NA/...  peak 5/09
//////////////////////////////////////////////////////////////////////////
#include "npcactlibtoolh"
const int DEBUG_LIB =FALSE;
// #Parm1   FUNCTION                   PARAMETERS
//------------------------------------------------------------------------
// 1        Use Placeable by Tag       Placeable Tag
// 2        Check for open weapons     Handle Method / Prison Tag
// 3        Check for Decency          Handle Method / Prison Tag
// 4        No Animals Allowed         Handle Method / Prison Tag
// 5        If possess item talk to    Item Tag / conversation file
// 6        Equip specific item        Item Tag / Slot # per documentation
// 7        Frozen animation           Animation / Freeze moment / Duration
///////////////////////////////// PROTOTYPES //////////////////////////////
void LIB1UseByTag(string sTag);
void LIB2NoWeapons(string sMethod, string sPrison,int nEND=FALSE);
void LIB3Decency(string sMethod, string sPrison,int nEND=FALSE);
void LIB4NoAnimals(string sMethod, string sPrison,int nEND=FALSE);
void LIB5ItemTriggerTalk(string sItem,string sConversation);
void LIB6EquipItem(string sItem,string sSlot);
void LIB7FrozenAnimation(string sAnimation, string sFreeze, string sDuration);

//=============================================[ M A I N ]=================
void main()
{
  string sParmIn=GetLocalString(OBJECT_SELF,"sLIBParm");
  DeleteLocalString(OBJECT_SELF,"sLIBParm");
  fnTokenizeParameters(sParmIn);
  int nArgC=GetLocalInt(OBJECT_SELF,"nArgc");
  string sParm;
  int nFuncNum; // function number
  string sParm1;
  string sParm2;
  string sParm3;
  object oPC=GetFirstPC();
  if (DEBUG_LIB) SendMessageToPC(oPC,"[=====NA LIB CALLED=====] ARGS:"+IntToString(nArgC));
  if (nArgC>0)
  { // Arguments were passed
    SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE); // no interference
    sParm=GetLocalString(OBJECT_SELF,"sArgv1");
    nFuncNum=StringToInt(sParm);
    if (nArgC>1) sParm1=GetLocalString(OBJECT_SELF,"sArgv2");
    if (nArgC>2) sParm2=GetLocalString(OBJECT_SELF,"sArgv3");
    if (nArgC>3) sParm3=GetLocalString(OBJECT_SELF,"sArgv4");
    if (DEBUG_LIB) SendMessageToPC(oPC,"[Arguments 1:"+sParm+" 2:"+sParm1+" 3:"+sParm2+" 4:"+sParm3+"]");
    switch(nFuncNum)
    { // Choose library function to call
      case 1: { // Use Placeable by Tag
        SetLocalInt(OBJECT_SELF,"nGNBMaxHB",2);
        if (DEBUG_LIB) SendMessageToPC(oPC,"       USE PLACEABLE");
        LIB1UseByTag(sParm1);
        break;
      } // Use Placeable by Tag
      case 2: { // Check for open weapons
        SetLocalInt(OBJECT_SELF,"nGNBMaxHB",2);
        if (DEBUG_LIB) SendMessageToPC(oPC,"       CHECK FOR WEAPONS");
        LIB2NoWeapons(sParm1,sParm2);
        break;
      } // Check for open weapons
      case 3: { // Check for Decency
        SetLocalInt(OBJECT_SELF,"nGNBMaxHB",2);
        if (DEBUG_LIB) SendMessageToPC(oPC,"       CHECK FOR DECENCY");
        LIB3Decency(sParm1,sParm2);
        break;
      } // Check for Decency
      case 4: { // No Animals allowed
        SetLocalInt(OBJECT_SELF,"nGNBMaxHB",2);
        if (DEBUG_LIB) SendMessageToPC(oPC,"       NO ANIMALS ALLOWED");
        LIB4NoAnimals(sParm1,sParm2);
        break;
      } // No Animals allowed
      case 5: { // Possess item talk to
        SetLocalInt(OBJECT_SELF,"nGNBMaxHB",2);
        if (DEBUG_LIB) SendMessageToPC(oPC,"       ITEM TRIGGER TALK");
        LIB5ItemTriggerTalk(sParm1,sParm2);
        break;
      } // Possess item talk to
      case 6: { // Equip specific item
        SetLocalInt(OBJECT_SELF,"nGNBMaxHB",1);
        if (DEBUG_LIB) SendMessageToPC(oPC,"       EQUIP SPECIFIC ITEM");
        LIB6EquipItem(sParm1,sParm2);
        break;
      } // Equip specific item
      case 7: { // Frozen animation
        SetLocalInt(OBJECT_SELF,"nGNBMaxHB",1);
        if (DEBUG_LIB) SendMessageToPC(oPC,"       assume frozen animation");
        LIB7FrozenAnimation(sParm1,sParm2,sParm3);
        break;
      } // Equip specific item
      default: { SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE); break; }
    } // Choose library function to call
  } // Arguments were passed
  fnFreeParms();
}
//==================================================[ M A I N ]===============

////////////////////////////////////////////////////////////////////
//  LIBRARY SUPPORT FUNCTIONS
////////////////////////////////////////////////////////////////////

int fnWeaponProperties(object oItem)
{ // return TRUE if item is a weapon
  int nRet=FALSE;
  int nType=GetBaseItemType(oItem);
  switch(nType)
  { // weapons
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_CLUB:
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DART:
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_SLING:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WARHAMMER: { nRet=TRUE; break; }
  } // weapons
  return nRet;
} // fnWeaponProperties()

int fnHasWeapon(object oTest)
{ // Test to see if this person is wielding a weapon
  int nRet=FALSE;
  object oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTest);
  if (fnWeaponProperties(oItem)) nRet=TRUE;
  oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oTest);
  if (fnWeaponProperties(oItem)) nRet=TRUE;
  return nRet;
} // fnHasWeapon()

void fnHandleLaw(string sMethod,string sPrison,object oTarget)
{ // Justice needs to be served
  int nMethod=StringToInt(sMethod);
  object oDest=GetWaypointByTag(sPrison);
  effect eKnockdown=EffectKnockdown();
  int nC=1;
  object oFriend;
  switch (nMethod)
  { // justice switch
    case 0: { // empty threats
     break;
    } // empty threats
    case 1: { // attack and kill
     SetIsTemporaryEnemy(oTarget,OBJECT_SELF,TRUE,60.0);
     SetIsTemporaryEnemy(OBJECT_SELF,oTarget,TRUE,60.0);
     ActionAttack(oTarget);
     break;
    } // attack and kill
    case 2: { // transport to jail
     ActionForceMoveToObject(oTarget,TRUE,2.0,6.0);
     ActionDoCommand(AssignCommand(oTarget,ClearAllActions()));
     ActionDoCommand(AssignCommand(oTarget,JumpToObject(oDest)));
     ActionDoCommand(DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKnockdown,oTarget,3.0)));
     break;
    } // transport to jail
    case 3: { // attack and kill - call for help
     ActionSpeakString("ALERT!!! ALERT!!!",TALKVOLUME_SHOUT);
     SetIsTemporaryEnemy(oTarget,OBJECT_SELF,TRUE,60.0);
     SetIsTemporaryEnemy(OBJECT_SELF,oTarget,TRUE,60.0);
     ActionAttack(oTarget);
     oFriend=GetNearestObjectByTag(GetTag(OBJECT_SELF),oTarget,nC);
     while (oFriend!=OBJECT_INVALID)
     {
       ActionSpeakString("I'm on the way!",TALKVOLUME_SHOUT);
       SetIsTemporaryEnemy(oTarget,oFriend,TRUE,60.0);
       SetIsTemporaryEnemy(oFriend,oTarget,TRUE,60.0);
       SetLocalInt(oFriend,"nGNBDisabled",TRUE);
       DelayCommand(120.0,SetLocalInt(oFriend,"nGNBDisabled",FALSE));
       AssignCommand(oFriend,ActionForceMoveToObject(oTarget,TRUE,10.0));
       AssignCommand(oFriend,ActionAttack(oTarget));
       nC++;
       oFriend=GetNearestObjectByTag(GetTag(OBJECT_SELF),oTarget,nC);
     }
     break;
    } // attack and kill - call for help
  } // justice switch
} // fnHandleLaw()


int fnHasBeasts(object oT)
{ // does target have beasts within 15 meters of speaker?
  int nRet=FALSE;
  object oBeast=GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oT);
  float fDist=GetDistanceToObject(oBeast);
  if (oBeast!=OBJECT_INVALID&&fDist!=-1.0&&fDist<15.1) nRet=TRUE;
  else
  { // familiar
    oBeast=GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oT);
    fDist=GetDistanceToObject(oBeast);
    if (oBeast!=OBJECT_INVALID&&fDist!=-1.0&&fDist<15.1) nRet=TRUE;
    else
    { // summoned
      oBeast=GetAssociate(ASSOCIATE_TYPE_SUMMONED,oT);
      fDist=GetDistanceToObject(oBeast);
      if (oBeast!=OBJECT_INVALID&&fDist!=-1.0&&fDist<15.1) nRet=TRUE;
    } // summoned
  } // familiar
  return nRet;
} // fnHasBeasts()

///////////////////////////////////////////////////////////////////
//                    LIBRARY  F U N C T I O N S
///////////////////////////////////////////////////////////////////

void LIB1UseByTag(string sTag)
{ // Use object by tag
  DelayCommand(30.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  object oUse=GetNearestObjectByTag(sTag);
  if (oUse!=OBJECT_INVALID&&GetDistanceBetween(OBJECT_SELF,oUse)<10.0)
  { // !OI
    ActionMoveToObject(oUse);
    ActionDoCommand(SetFacingPoint(GetPosition(oUse)));
    ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0,3.0);
    ActionInteractObject(oUse);
  } // !OI
  ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
} // LIB1UseByTag()


void LIB2NoWeapons(string sMethod,string sPrison,int nEnd=FALSE)
{ // Check for weapons
  //DelayCommand(10.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE)); // removed, crippling Professions - Peak 5/10
  SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE);
  int nL2WC=GetLocalInt(OBJECT_SELF,"nL2WC");
  object oL2WARNED=GetLocalObject(OBJECT_SELF,"oL2WARNED");
  object oPC;
  int nC=1;
  int nENDM=nEnd;
  //DelayCommand(120.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  //SendMessageToPC(GetFirstPC(),"[WC]"+GetName(OBJECT_SELF)+" nL2WC:"+IntToString(nL2WC)+" WARNED:"+GetName(oL2WARNED));
  if (oL2WARNED!=OBJECT_INVALID&&nL2WC>0)
  { // already warned someone
    if (fnHasWeapon(oL2WARNED)&&!GetIsDead(oL2WARNED)&&GetDistanceBetween(OBJECT_SELF,oL2WARNED)!=0.0&&GetDistanceBetween(OBJECT_SELF,oL2WARNED)<30.0)
    { // still wielding
      nL2WC++;
      SetLocalInt(OBJECT_SELF,"nL2WC",nL2WC);
      switch (nL2WC)
      {
        case 2: { // second warning
         ActionSpeakString("You MUST put your weapons away now!!");
         ActionWait(5.0);
         DelayCommand(6.0,LIB2NoWeapons(sMethod,sPrison));
         break;
        } // second warning
        case 3: { // third warning
         ActionSpeakString("This is your LAST warning.  Put your weapons away!");
         ActionWait(5.0);
         DelayCommand(6.0,LIB2NoWeapons(sMethod,sPrison));
         break;
        } // third warning
        default: { // 4 or more
         ActionSpeakString("You will be forced to put your weapons away NOW!",TALKVOLUME_SHOUT);
         fnHandleLaw(sMethod,sPrison,oL2WARNED);
         DeleteLocalInt(OBJECT_SELF,"nL2WC");
         DeleteLocalObject(OBJECT_SELF,"oL2WARNED");
         if (sMethod=="0"||sMethod=="2") nENDM=TRUE;
         break;
        } // 4 or more
      }
    } // still wielding
    else
    { // he has put it away
      ActionSpeakString("Thank you for putting your weapons away.");
      DeleteLocalInt(OBJECT_SELF,"nL2WC");
      DeleteLocalObject(OBJECT_SELF,"oL2WARNED");
      SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE);
      nENDM=TRUE;
    } // he has put it away
  } // already warned someone
  else
  { // search for others possibly needing warning
    oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
    while(oPC!=OBJECT_INVALID&&oL2WARNED==OBJECT_INVALID)
    { // look for those packing weapons
      if (fnHasWeapon(oPC))
      { // found someone
        ActionDoCommand(SetFacingPoint(GetPosition(oPC)));
        ActionSpeakString("Your weapons must be put away while in this area.");
        ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE,1.0,5.0);
        SetLocalObject(OBJECT_SELF,"oL2WARNED",oPC);
        SetLocalInt(OBJECT_SELF,"nL2WC",1);
        oL2WARNED=oPC;
        DelayCommand(6.0,LIB2NoWeapons(sMethod,sPrison));
      } // found someone
      else
       nENDM=TRUE;
      nC++;
      oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
    } // look for those packing weapons
  } // search for others possibly needing warning
  if (GetLocalObject(OBJECT_SELF,"oL2WARNED")==OBJECT_INVALID) nENDM=TRUE;
  if (nENDM)
  {
    //SendMessageToPC(GetFirstPC(),"[WEP]"+GetName(OBJECT_SELF));
    ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
    DelayCommand(60.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  }
} // LIB2NoWeapons()


void LIB3Decency(string sMethod, string sPrison,int nEnd=FALSE)
{ // Check to make sure wearing clothes
  int nL3DC=GetLocalInt(OBJECT_SELF,"nL3DC");
  object oL3WARNED=GetLocalObject(OBJECT_SELF,"oL3WARNED");
  object oPC;
  int nC=1;
  int nENDM=nEnd;
  //DelayCommand(120.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  //SendMessageToPC(GetFirstPC(),"[DC]"+GetName(OBJECT_SELF)+" nL3DC:"+IntToString(nL3DC)+" WARNED:"+GetName(oL3WARNED));
  if (oL3WARNED!=OBJECT_INVALID&&nL3DC>0)
  { // already warning someone
    SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE);
    if (GetItemInSlot(INVENTORY_SLOT_CHEST,oL3WARNED)==OBJECT_INVALID&&!GetIsDead(oL3WARNED)&&GetDistanceBetween(OBJECT_SELF,oL3WARNED)!=0.0&&GetDistanceBetween(OBJECT_SELF,oL3WARNED)<30.0)
    { // still wielding
      nL3DC++;
      SetLocalInt(OBJECT_SELF,"nL3DC",nL3DC);
      switch (nL3DC)
      {
        case 2: { // second warning
         ActionSpeakString("You MUST put some clothes on or leave this area immediately.");
         ActionWait(5.0);
         DelayCommand(6.0,LIB3Decency(sMethod,sPrison));
         break;
        } // second warning
        case 3: { // third warning
         ActionSpeakString("This is your LAST warning.  Put some clothing on!");
         ActionWait(5.0);
         DelayCommand(6.0,LIB3Decency(sMethod,sPrison));
         break;
        } // third warning
        default: { // 4 or more
         ActionSpeakString("You will be forced to comply with our deceny regulations!",TALKVOLUME_SHOUT);
         fnHandleLaw(sMethod,sPrison,oL3WARNED);
         DeleteLocalInt(OBJECT_SELF,"nL3DC");
         DeleteLocalObject(OBJECT_SELF,"oL3WARNED");
         if (sMethod=="2"||sMethod=="0") nENDM=TRUE;
         break;
        } // 4 or more
      }
    } // still wielding
    else
    { // he has put it away
      ActionSpeakString("Thank you. You are much more suitable looking with clothing on.");
      DeleteLocalInt(OBJECT_SELF,"nL3DC");
      DeleteLocalObject(OBJECT_SELF,"oL3WARNED");
      nENDM=TRUE;
    } // he has put it away
  } // already warning someone
  else
  { // Look for someone else
    oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
    while(oPC!=OBJECT_INVALID&&oL3WARNED==OBJECT_INVALID)
    { // look for those wearing no clothes
      if (GetItemInSlot(INVENTORY_SLOT_CHEST,oPC)==OBJECT_INVALID)
      { // found someone
        SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE);
        ActionDoCommand(SetFacingPoint(GetPosition(oPC)));
        ActionSpeakString("Excuse me, you must have clothing to be in this area.");
        ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE,1.0,5.0);
        SetLocalObject(OBJECT_SELF,"oL3WARNED",oPC);
        SetLocalInt(OBJECT_SELF,"nL3DC",1);
        oL3WARNED=oPC;
        DelayCommand(6.0,LIB3Decency(sMethod,sPrison));
      } // found someone
      else
       nENDM=TRUE;
      nC++;
      oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
    } // look for those packing weapons
  } // Look for someone else
  if (GetLocalObject(OBJECT_SELF,"oL3WARNED")==OBJECT_INVALID) nENDM=TRUE;
  if (nENDM)
  {
    //SendMessageToPC(GetFirstPC(),"[DEC]"+GetName(OBJECT_SELF));
    ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
    DelayCommand(60.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  }
} // LIB3Decency()

void LIB4NoAnimals(string sMethod, string sPrison,int nEnd=FALSE)
{ // Check to make sure no animal companions, familiars, etc.
  SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE);
  int nL4WC=GetLocalInt(OBJECT_SELF,"nL4WC");
  object oL4WARNED=GetLocalObject(OBJECT_SELF,"oL4WARNED");
  object oPC;
  int nC=1;
  int nENDM=nEnd;
  //DelayCommand(120.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  //SendMessageToPC(GetFirstPC(),"[WC]"+GetName(OBJECT_SELF)+" nL2WC:"+IntToString(nL2WC)+" WARNED:"+GetName(oL2WARNED));
  if (oL4WARNED!=OBJECT_INVALID&&nL4WC>0)
  { // already warned someone
    if (fnHasBeasts(oL4WARNED)&&!GetIsDead(oL4WARNED)&&GetDistanceBetween(OBJECT_SELF,oL4WARNED)!=0.0&&GetDistanceBetween(OBJECT_SELF,oL4WARNED)<30.0)
    { // still wielding
      nL4WC++;
      SetLocalInt(OBJECT_SELF,"nL4WC",nL4WC);
      switch (nL4WC)
      {
        case 2: { // second warning
         ActionSpeakString("You MUST send your beasts away now!!");
         ActionWait(5.0);
         DelayCommand(6.0,LIB4NoAnimals(sMethod,sPrison));
         break;
        } // second warning
        case 3: { // third warning
         ActionSpeakString("This is your LAST warning.  Send your beasts away!!");
         ActionWait(5.0);
         DelayCommand(6.0,LIB4NoAnimals(sMethod,sPrison));
         break;
        } // third warning
        default: { // 4 or more
         ActionSpeakString("You will be forced to part with your beasts now!!!",TALKVOLUME_SHOUT);
         fnHandleLaw(sMethod,sPrison,oL4WARNED);
         DeleteLocalInt(OBJECT_SELF,"nL4WC");
         DeleteLocalObject(OBJECT_SELF,"oL4WARNED");
         if (sMethod=="0"||sMethod=="2") nENDM=TRUE;
         break;
        } // 4 or more
      }
    } // still wielding
    else
    { // he has put it away
      ActionSpeakString("Thank you for sending your beasts away.");
      DeleteLocalInt(OBJECT_SELF,"nL4WC");
      DeleteLocalObject(OBJECT_SELF,"oL4WARNED");
      SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE);
      nENDM=TRUE;
    } // he has put it away
  } // already warned someone
  else
  { // search for others possibly needing warning
    oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
    while(oPC!=OBJECT_INVALID&&oL4WARNED==OBJECT_INVALID)
    { // look for those packing weapons
      if (fnHasBeasts(oPC))
      { // found someone
        ActionDoCommand(SetFacingPoint(GetPosition(oPC)));
        ActionSpeakString("Animal companions, familiars, and summoned creatures are not permitted here.  Please send them away.");
        ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE,1.0,5.0);
        SetLocalObject(OBJECT_SELF,"oL4WARNED",oPC);
        SetLocalInt(OBJECT_SELF,"nL4WC",1);
        oL4WARNED=oPC;
        DelayCommand(6.0,LIB4NoAnimals(sMethod,sPrison));
      } // found someone
      else
       nENDM=TRUE;
      nC++;
      oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
    } // look for those packing weapons
  } // search for others possibly needing warning
  if (GetLocalObject(OBJECT_SELF,"oL4WARNED")==OBJECT_INVALID) nENDM=TRUE;
  if (nENDM)
  {
    //SendMessageToPC(GetFirstPC(),"[WEP]"+GetName(OBJECT_SELF));
    ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
    DelayCommand(60.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  }
} // LIB4NoAnimals()


void LIB5ItemTriggerTalk(string sItem, string sConversation)
{ // If perceived PC possesses the item approach and speak
  object oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,1,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
  int nC=1;
  while(!IsInConversation(OBJECT_SELF)&&oPC!=OBJECT_INVALID)
  { // pcs
   if (!IsInConversation(oPC)&&GetItemPossessedBy(oPC,sItem)!=OBJECT_INVALID)
   { // speak to them
     oPC=OBJECT_INVALID; // done
     SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE);
     ActionMoveToObject(oPC,TRUE,2.0);
     ActionStartConversation(oPC,sConversation);
   } // speak to them
   else
   { // keep looking
     nC++;
     oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,1,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
   } // keep looking
  } // pcs
  ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  DelayCommand(20.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
} // LIB5ItemTriggerTalk()


void LIB6EquipItem(string sItem,string sSlot)
{ // equip specific item in Inventory slot #
  object oItem=GetItemPossessedBy(OBJECT_SELF,sItem);
  int nSlot=StringToInt(sSlot);
  if (oItem!=OBJECT_INVALID)
  { // has the item
    SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE);
    if (nSlot==0) nSlot=INVENTORY_SLOT_HEAD;
    else if (nSlot==1) nSlot=INVENTORY_SLOT_RIGHTHAND;
    else if (nSlot==2) nSlot=INVENTORY_SLOT_LEFTHAND;
    else if (nSlot==3) nSlot=INVENTORY_SLOT_BELT;
    else if (nSlot==4) nSlot=INVENTORY_SLOT_CHEST;
    else if (nSlot==5) nSlot=INVENTORY_SLOT_BOOTS;
    else if (nSlot==6) nSlot=INVENTORY_SLOT_RIGHTRING;
    else if (nSlot==7) nSlot=INVENTORY_SLOT_LEFTRING;
    else if (nSlot==8) nSlot=INVENTORY_SLOT_NECK;
    else if (nSlot==9) nSlot=INVENTORY_SLOT_CLOAK;
    else if (nSlot==10)nSlot=INVENTORY_SLOT_ARROWS;
    else if (nSlot==11)nSlot=INVENTORY_SLOT_BOLTS;
    else if (nSlot==12)nSlot=INVENTORY_SLOT_BULLETS;
    ActionEquipItem(oItem,nSlot);
  } // has the item
  ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  DelayCommand(4.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
} // LIB6EquipItem()


void LIB7FrozenAnimation(string sAnimation, string sFreeze, string sDuration)
{ // place target in frozen animation
  object oTarget = GetObjectByTag(GetTag(OBJECT_SELF));
  float fFreeze = StringToFloat(sFreeze)/10;
  float fDuration = StringToFloat(sDuration)/10;
  int nAnimation = StringToInt(sAnimation);
  //-- anim started and frozen. target frozen (not commandable)
  effect eFreeze = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
  DelayCommand(fFreeze + fDuration + 3, SetLocalInt (OBJECT_SELF, "nGNBDisabled", FALSE));
  SetLocalInt (OBJECT_SELF, "nGNBDisabled", TRUE);
  AssignCommand(oTarget, PlayAnimation(nAnimation, 1.0, 0.0));
  AssignCommand(oTarget, ActionWait (fFreeze + fDuration+2.0));
  DelayCommand(fFreeze, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFreeze, oTarget));
  DelayCommand(fFreeze + fDuration, RemoveEffect(oTarget, eFreeze));
}
