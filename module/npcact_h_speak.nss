////////////////////////////////////////////////////////////////////////////////
// npcact_h_speak - NPC ACTIVITIES 6.0 Speaking related Functions
//------------------------------------------------------------------------------
// by Deva Bryson Winblood.
//------------------------------------------------------------------------------
// Last Modified by: Deva Bryson Winblood
// Last Modified Date: 06/22/2004
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
#include "npcact_h_support" // has support functions used by TT
/////////////////////////////
// PROTOTYPES
/////////////////////////////

// FILE: npcact_h_speak                       FUNCTION: fnNPCACTLyrical()
// This will cause the NPC to sing a song as stored on a waypoint with the
// specified tag.  The duration is specified in heartbeats (6 second intervals).
// If nOpt==1 then it means sCom is the actual song prefixed by the duration.
float fnNPCACTLyrical(string sCom,int nOpt=0);

// FILE: npcact_h_speak                       FUNCTION: fnNPCACTRandomSpeak()
// This function will cause the NPC to speak one of the random phrases stored
// on the specified waypoint. If nOpt=1 it will treat sCom as the random phrase
// name instead of looking for a waypoint.
float fnNPCACTRandomSpeak(string sCom,int nOpt=0);

// FILE: npcact_h_speak                       FUNCTION: fnNPCACTTalkTo()
// PARAMETERS: TT<tag>/<animation>/<optional conversation file>
// This function will cause the NPC to engage a target in conversation.  It
// will obey NO NPC interaction, and NO PC interaction rules.
// If the tag passed is PC then it will speak to a PC and not an NPC.
// If the tag passed is ANY then it will attempt to speak to anyone at all.
// If the tag passed is RACE<race> it will look for someone of that race to speak to
// If the tag passed is CLASS<class> it will look for someone of that class to speak to
// If the tag passed is GENDER<gender> it will look for someone of that gender to speak to
// If the tag passed is ALIGN<alignment> it will look for someone of that alignment
// If the tag passed is WOUNDED<%> it will look for someone wounded percent of their hit points
// If the tag passed is ARMED it will look for someone with weapons out
// If the tag passed is BESPELLED it will look for someone with spell effects
// If the tag passed is VARCHECK<variable>_<value> it will look for someone with the variable equal to value
// RACES: ANIMAL,BEAST, CONSTRUCT,DRAGON, DWARF, ELEMENTAL, ELF, FEY, GIANT,
//        GNOME, HALFELF, HALFORC, HUMAN, GOBLIN, MONSTROUS, ORC, REPTILE,
//        MAGICALBEAST, OOZE, OUTSIDER, SHAPECHANGER, UNDEAD, VERMIN
// CLASSES: ARCHER, ASSASSIN, BARBARIAN, BARD, BLACKGUARD, CLERIC, COMMONER,
//          CHAMPION, DISCIPLE, DRUID, DEFENDER, FIGHTER, HARPER, MONK,
//          PALADIN, PALEMASTER, RANGER, ROGUE, SHADOWDANCER, SHIFTER,
//          SORCERER, WIZARD, WEAPONMASTER.
// GENDERS: MALE, FEMALE, NONE, BOTH, OTHER
// ALIGNMENTS: EVIL,GOOD,LAWFUL,CHAOTIC,NEUTRAL,LG,NG,CG,LN,TN,CN,LE,NE,CE
// WOUNDED %: 1-99
// EXAMPLE: TTWilco2/N would initiate the NPCs standard conversation
//   with an NPC with the tag of Wilco2 using Normal speaking animations.
// EXAMPLE2: TTARMED/F/PutAwayWeapon  would cause the NPC to speak to anyone
//   that has a weapon out and will use the forceful animation and fire off
//   the PutAwayWeapon conversation.
float fnNPCACTTalkTo(string sCom);

/////////////////////////////
// FUNCTIONS
/////////////////////////////

void NPCACTSing(string sSong)
{ // PURPOSE: a recursive singing support function
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sPhrase=fnParse(sSong,"/");
  string sRemaining=fnRemoveParsed(sSong,sPhrase,"/");
  if (GetLocalInt(OBJECT_SELF,"bNPCACTSinging")==TRUE&&GetStringLength(sPhrase)>0)
  { // still singing
    AssignCommand(OBJECT_SELF,SpeakString(sPhrase));
    DelayCommand(4.0,NPCACTSing(sRemaining));
  } // still singing
} // NPCACTSing()

float fnNPCACTLyrical(string sCom,int nOpt=0)
{ // PURPOSE: To sing a song stored on a waypoint.
  // LAST MODIFIED BY: Deva Bryson Winblood
  float fDur=0.0;
  string sParm;
  string sSong;
  string sDur;
  object oWP;
  fnDebug("["+GetTag(OBJECT_SELF)+"] SING");
  if (nOpt==0)
  { // nOpt==0
    if (GetStringLeft(sCom,5)=="LYRIC") sParm=GetStringRight(sCom,GetStringLength(sCom)-5);
    else { sParm=GetStringRight(sCom,GetStringLength(sCom)-2); }
    sSong=fnParse(sParm,"/");
    sDur=fnRemoveParsed(sParm,sSong,"/");
  } // nOpt==0
  else
  {
    sDur=fnParse(sCom,"/");
    sSong=fnRemoveParsed(sCom,sDur,"/");
  }
  fnDebug("["+GetTag(OBJECT_SELF)+"] SONG:"+sSong+" Duration:"+sDur,TRUE);
  fDur=IntToFloat(StringToInt(sDur)*6);
  if (fDur<6.0) fDur=45.0;
  oWP=GetWaypointByTag(sSong);
  if (fDur>0.0&&(GetIsObjectValid(oWP)||nOpt!=0))
  { // duration is greater than 0 and waypoint is valid
    SetLocalInt(OBJECT_SELF,"bNPCACTSinging",TRUE);
    if (nOpt==0) NPCACTSing(GetName(oWP));
    else { NPCACTSing(sSong); }
    DelayCommand(fDur,DeleteLocalInt(OBJECT_SELF,"bNPCACTSinging"));
  } // duration is greater than 0 and waypoint is valid
  return fDur;
} // fnNPCACTLyrical()


float fnNPCACTRandomSpeak(string sCom,int nOpt=0)
{ // PURPOSE: This will cause the NPC to say a random phrase that is stored
  // on a waypoint.
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sWordTag;
  object oWP;
  string sBuffer;
  string sParse;
  int nR;
  int nC;
  int nCount;
  float fDur=0.1;
  fnDebug("["+GetTag(OBJECT_SELF)+"] fnNPCACTRandomSpeak("+sCom+","+IntToString(nOpt)+") ",TRUE);
  if (nOpt==0)
  { // nOpt==0
    if (GetStringLeft(sCom,3)=="RWL") sWordTag=GetStringRight(sCom,GetStringLength(sCom)-3);
    else { sWordTag=GetStringRight(sCom,GetStringLength(sCom)-2); }
    oWP=GetNearestObjectByTag(sWordTag);
    if (!GetIsObjectValid(oWP)) oWP=GetWaypointByTag(sWordTag);
  } // nOpt==0
  if (GetIsObjectValid(oWP)||nOpt==1)
  { // found waypoint
    fDur=1.0;
    if (nOpt==0) sWordTag=GetName(oWP);
    else { sWordTag=sCom; }
    sBuffer=sWordTag;
    nCount=0;
    sParse=fnParse(sBuffer,"/");
    while(GetStringLength(sParse)>0)
    { // count phrases
      nCount++;
      sBuffer=fnRemoveParsed(sBuffer,sParse,"/");
      sParse=fnParse(sBuffer,"/");
    } // count phrases
    if (nCount>0)
    { // pick a random saying
      nC=1;
      nR=Random(nCount)+1;
      //fnDebug("         nCount="+IntToString(nCount)+" nR="+IntToString(nR)+" sWordTag='"+sWordTag+"'");
      sParse=fnParse(sWordTag,"/");
      while(nC<nR)
      { // pick phrase
        nC++;
        sWordTag=fnRemoveParsed(sWordTag,sParse,"/");
        sParse=fnParse(sWordTag,"/");
      } // pick phrase
      fnDebug("     SpeakString("+sParse+")",TRUE);
      AssignCommand(OBJECT_SELF,SpeakString(sParse));
    } // pick a random saying
    else { AssignCommand(OBJECT_SELF,SpeakString("The place that stores the things to say actually has nothing for me to say.")); }
  } // found waypoint
  else { AssignCommand(OBJECT_SELF,SpeakString("The place I get my things to say from is missing.")); }
  return fDur;
} // fnNPCACTRandomSpeak()

int NPCACTIsBusy(object oTarget)
{ // PURPOSE: Returns true if target is in conversation or combat
  // LAST MODIFIED BY: Deva Bryson Winblood
  int nRet=FALSE;
  if (GetIsObjectValid(oTarget))
  { // valid object
    if (IsInConversation(oTarget)==TRUE) nRet=TRUE;
    if (GetIsInCombat(oTarget)==TRUE) nRet=TRUE;
    if (GetIsDead(oTarget)==TRUE) nRet=TRUE;
  } // valid object
  return nRet;
} // NPCACTIsBusy()

object NPCACTFindNonBusyPC()
{ // PURPOSE: Return a nearby PC that is not busy
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  object oPC;
  int nC=1;
  oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(oPC!=OBJECT_INVALID&&oRet==OBJECT_INVALID)
  { // find a PC
    if (!NPCACTIsBusy(oPC)) oRet=oPC;
    nC++;
    oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find a PC
  return oRet;
} // NPCACTFindNonBusyPC()

object NPCACTFindNonBusyNPC()
{ // PURPOSE: Return a non-busy NPC
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  object oPC;
  int nC=1;
  oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_NOT_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(oPC!=OBJECT_INVALID&&oRet==OBJECT_INVALID)
  { // find a PC
    if (!NPCACTIsBusy(oPC)) oRet=oPC;
    nC++;
    oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_NOT_PC,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find a PC
  return oRet;
} // NPCACTFindNonBusyNPC()

object NPCACTFindRace(string sRace,int bAllowPCs,int bAllowNPCs)
{ // PURPOSE: Find a non-busy target of this RACE
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  int nC=1;
  object oCr;
  int bAllow;
  int nRace;
  oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(GetIsObjectValid(oCr)&&oRet==OBJECT_INVALID)
  { // find armed target
    bAllow=TRUE;
    if (GetIsPC(oCr)&&!bAllowPCs) bAllow=FALSE;
    else if (!GetIsPC(oCr)&&!bAllowNPCs) bAllow=FALSE;
    if (bAllow&&!NPCACTIsBusy(oCr))
    { // not prohibited
      nRace=GetRacialType(oCr);
      if (sRace=="ANIMAL"&&nRace==RACIAL_TYPE_ANIMAL) oRet=oCr;
      else if (sRace=="BEAST"&&nRace==RACIAL_TYPE_BEAST) oRet=oCr;
      else if (sRace=="CONSTRUCT"&&nRace==RACIAL_TYPE_CONSTRUCT) oRet=oCr;
      else if (sRace=="DRAGON"&&nRace==RACIAL_TYPE_DRAGON) oRet=oCr;
      else if (sRace=="DWARF"&&nRace==RACIAL_TYPE_DWARF) oRet=oCr;
      else if (sRace=="ELEMENTAL"&&nRace==RACIAL_TYPE_ELEMENTAL) oRet=oCr;
      else if (sRace=="ELF"&&nRace==RACIAL_TYPE_ELF) oRet=oCr;
      else if (sRace=="FEY"&&nRace==RACIAL_TYPE_FEY) oRet=oCr;
      else if (sRace=="GIANT"&&nRace==RACIAL_TYPE_GIANT) oRet=oCr;
      else if (sRace=="GNOME"&&nRace==RACIAL_TYPE_GNOME) oRet=oCr;
      else if (sRace=="HALFELF"&&nRace==RACIAL_TYPE_HALFELF) oRet=oCr;
      else if (sRace=="HALFLING"&&nRace==RACIAL_TYPE_HALFLING) oRet=oCr;
      else if (sRace=="HALFORC"&&nRace==RACIAL_TYPE_HALFORC) oRet=oCr;
      else if (sRace=="HUMAN"&&nRace==RACIAL_TYPE_HUMAN) oRet=oCr;
      else if (sRace=="GOBLIN"&&nRace==RACIAL_TYPE_HUMANOID_GOBLINOID) oRet=oCr;
      else if (sRace=="MONSTROUS"&&nRace==RACIAL_TYPE_HUMANOID_MONSTROUS) oRet=oCr;
      else if (sRace=="ORC"&&nRace==RACIAL_TYPE_HUMANOID_ORC) oRet=oCr;
      else if (sRace=="REPTILE"&&nRace==RACIAL_TYPE_HUMANOID_REPTILIAN) oRet=oCr;
      else if (sRace=="MAGICALBEAST"&&nRace==RACIAL_TYPE_MAGICAL_BEAST) oRet=oCr;
      else if (sRace=="OOZE"&&nRace==RACIAL_TYPE_OOZE) oRet=oCr;
      else if (sRace=="OUTSIDER"&&nRace==RACIAL_TYPE_OUTSIDER) oRet=oCr;
      else if (sRace=="SHAPECHANGER"&&nRace==RACIAL_TYPE_SHAPECHANGER) oRet=oCr;
      else if (sRace=="UNDEAD"&&nRace==RACIAL_TYPE_UNDEAD) oRet=oCr;
      else if (sRace=="VERMIN"&&nRace==RACIAL_TYPE_VERMIN) oRet=oCr;
    } // not prohibited
    nC++;
    oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find armed target
  return oRet;
} // NPCACTFindRace()

object NPCACTFindClass(string sClass,int bAllowPCs,int bAllowNPCs)
{ // PURPOSE: Find a non-busy target of this Class
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  int nC=1;
  object oCr;
  int bAllow;
  oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(GetIsObjectValid(oCr)&&oRet==OBJECT_INVALID)
  { // find armed target
    bAllow=TRUE;
    if (GetIsPC(oCr)&&!bAllowPCs) bAllow=FALSE;
    else if (!GetIsPC(oCr)&&!bAllowNPCs) bAllow=FALSE;
    if (bAllow&&!NPCACTIsBusy(oCr))
    { // not prohibited
      if (sClass=="ARCHER"&&GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER,oCr)>0) oRet=oCr;
      else if (sClass=="ASSASSIN"&&GetLevelByClass(CLASS_TYPE_ASSASSIN,oCr)>0) oRet=oCr;
      else if (sClass=="BARBARIAN"&&GetLevelByClass(CLASS_TYPE_BARBARIAN,oCr)>0) oRet=oCr;
      else if (sClass=="BARD"&&GetLevelByClass(CLASS_TYPE_BARD,oCr)>0) oRet=oCr;
      else if (sClass=="BLACKGUARD"&&GetLevelByClass(CLASS_TYPE_BLACKGUARD,oCr)>0) oRet=oCr;
      else if (sClass=="CLERIC"&&GetLevelByClass(CLASS_TYPE_CLERIC,oCr)>0) oRet=oCr;
      else if (sClass=="COMMONER"&&GetLevelByClass(CLASS_TYPE_COMMONER,oCr)>0) oRet=oCr;
      else if (sClass=="CHAMPION"&&GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,oCr)>0) oRet=oCr;
      else if (sClass=="DISCIPLE"&&GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE,oCr)>0) oRet=oCr;
      else if (sClass=="DRUID"&&GetLevelByClass(CLASS_TYPE_DRUID,oCr)>0) oRet=oCr;
      else if (sClass=="DEFENDER"&&GetLevelByClass(CLASS_TYPE_DWARVENDEFENDER,oCr)>0) oRet=oCr;
      else if (sClass=="FIGHTER"&&GetLevelByClass(CLASS_TYPE_FIGHTER,oCr)>0) oRet=oCr;
      else if (sClass=="HARPER"&&GetLevelByClass(CLASS_TYPE_HARPER,oCr)>0) oRet=oCr;
      else if (sClass=="MONK"&&GetLevelByClass(CLASS_TYPE_MONK,oCr)>0) oRet=oCr;
      else if (sClass=="PALADIN"&&GetLevelByClass(CLASS_TYPE_PALADIN,oCr)>0) oRet=oCr;
      else if (sClass=="PALEMASTER"&&GetLevelByClass(CLASS_TYPE_PALEMASTER,oCr)>0) oRet=oCr;
      else if (sClass=="RANGER"&&GetLevelByClass(CLASS_TYPE_RANGER,oCr)>0) oRet=oCr;
      else if (sClass=="ROGUE"&&GetLevelByClass(CLASS_TYPE_ROGUE,oCr)>0) oRet=oCr;
      else if (sClass=="SHADOWDANCER"&&GetLevelByClass(CLASS_TYPE_SHADOWDANCER,oCr)>0) oRet=oCr;
      else if (sClass=="SHIFTER"&&GetLevelByClass(CLASS_TYPE_SHIFTER,oCr)>0) oRet=oCr;
      else if (sClass=="SORCERER"&&GetLevelByClass(CLASS_TYPE_SORCERER,oCr)>0) oRet=oCr;
      else if (sClass=="WEAPONMASTER"&&GetLevelByClass(CLASS_TYPE_WEAPON_MASTER,oCr)>0) oRet=oCr;
      else if (sClass=="WIZARD"&&GetLevelByClass(CLASS_TYPE_WIZARD,oCr)>0) oRet=oCr;
    } // not prohibited
    nC++;
    oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find armed target
  return oRet;
} // NPCACTFindClass()

object NPCACTFindGender(string sGender,int bAllowPCs,int bAllowNPCs)
{ // PURPOSE: Find a non-busy target of this Gender
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  int nC=1;
  object oCr;
  int bAllow;
  int nGender;
  oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(GetIsObjectValid(oCr)&&oRet==OBJECT_INVALID)
  { // find armed target
    bAllow=TRUE;
    if (GetIsPC(oCr)&&!bAllowPCs) bAllow=FALSE;
    else if (!GetIsPC(oCr)&&!bAllowNPCs) bAllow=FALSE;
    if (bAllow&&!NPCACTIsBusy(oCr))
    { // not prohibited
      nGender=GetGender(oCr);
      if (sGender=="FEMALE"&&nGender==GENDER_FEMALE) oRet=oCr;
      else if (sGender=="MALE"&&nGender==GENDER_MALE) oRet=oCr;
      else if (sGender=="BOTH"&&nGender==GENDER_BOTH) oRet=oCr;
      else if (sGender=="NONE"&&nGender==GENDER_NONE) oRet=oCr;
      else if (sGender=="OTHER"&&nGender==GENDER_OTHER) oRet=oCr;
    } // not prohibited
    nC++;
    oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find armed target
  return oRet;
} // NPCACTFindGender()

object NPCACTFindAlignment(string sAlignment,int bAllowPCs,int bAllowNPCs)
{ // PURPOSE: Find a non-busy target of this Alignment
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  int nC=1;
  object oCr;
  int bAllow;
  int nAGE;
  int nALC;
  oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(GetIsObjectValid(oCr)&&oRet==OBJECT_INVALID)
  { // find armed target
    bAllow=TRUE;
    if (GetIsPC(oCr)&&!bAllowPCs) bAllow=FALSE;
    else if (!GetIsPC(oCr)&&!bAllowNPCs) bAllow=FALSE;
    if (bAllow&&!NPCACTIsBusy(oCr))
    { // not prohibited
      nAGE=GetAlignmentGoodEvil(oCr);
      nALC=GetAlignmentLawChaos(oCr);
      if (sAlignment=="EVIL"&&nAGE==ALIGNMENT_EVIL) oRet=oCr;
      else if (sAlignment=="GOOD"&&nAGE==ALIGNMENT_GOOD) oRet=oCr;
      else if (sAlignment=="NEUTRAL"&&(nAGE==ALIGNMENT_NEUTRAL||nALC==ALIGNMENT_NEUTRAL)) oRet=oCr;
      else if (sAlignment=="LAWFUL"&&nALC==ALIGNMENT_LAWFUL) oRet=oCr;
      else if (sAlignment=="CHAOTIC"&&nALC==ALIGNMENT_CHAOTIC) oRet=oCr;
      else if (sAlignment=="LG"&&nAGE==ALIGNMENT_GOOD&&nALC==ALIGNMENT_LAWFUL) oRet=oCr;
      else if (sAlignment=="NG"&&nAGE==ALIGNMENT_GOOD&&nALC==ALIGNMENT_NEUTRAL) oRet=oCr;
      else if (sAlignment=="CG"&&nAGE==ALIGNMENT_GOOD&&nALC==ALIGNMENT_CHAOTIC) oRet=oCr;
      else if (sAlignment=="LN"&&nAGE==ALIGNMENT_NEUTRAL&&nALC==ALIGNMENT_LAWFUL) oRet=oCr;
      else if (sAlignment=="TN"&&nAGE==ALIGNMENT_NEUTRAL&&nALC==ALIGNMENT_NEUTRAL) oRet=oCr;
      else if (sAlignment=="CN"&&nAGE==ALIGNMENT_NEUTRAL&&nALC==ALIGNMENT_CHAOTIC) oRet=oCr;
      else if (sAlignment=="LE"&&nAGE==ALIGNMENT_EVIL&&nALC==ALIGNMENT_LAWFUL) oRet=oCr;
      else if (sAlignment=="NE"&&nAGE==ALIGNMENT_EVIL&&nALC==ALIGNMENT_NEUTRAL) oRet=oCr;
      else if (sAlignment=="CE"&&nAGE==ALIGNMENT_EVIL&&nALC==ALIGNMENT_CHAOTIC) oRet=oCr;
    } // not prohibited
    nC++;
    oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find armed target
  return oRet;
} // NPCACTFindAlignment()

object NPCACTFindWounded(string sWounded,int bAllowPCs,int bAllowNPCs)
{ // PURPOSE: Find a non-busy target of this Wounded
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  int nC=1;
  object oCr;
  int bAllow;
  int nP=StringToInt(sWounded);
  int nMAXHP;
  int nCURHP;
  int nPERHP;
  oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(GetIsObjectValid(oCr)&&oRet==OBJECT_INVALID)
  { // find armed target
    bAllow=TRUE;
    if (GetIsPC(oCr)&&!bAllowPCs) bAllow=FALSE;
    else if (!GetIsPC(oCr)&&!bAllowNPCs) bAllow=FALSE;
    if (bAllow&&!NPCACTIsBusy(oCr))
    { // not prohibited
      nMAXHP=GetMaxHitPoints(oCr);
      nCURHP=GetCurrentHitPoints(oCr);
      nPERHP=(nCURHP*100)/nMAXHP;
      if (nPERHP<=nP) oRet=oCr;
    } // not prohibited
    nC++;
    oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find armed target
  return oRet;
} // NPCACTFindWounded()

object NPCACTFindArmed(int bAllowPCs,int bAllowNPCs)
{ // PURPOSE: Find a non-busy target of this Armed
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  int nC=1;
  object oCr;
  int bAllow;
  object oItem;
  oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(GetIsObjectValid(oCr)&&oRet==OBJECT_INVALID)
  { // find armed target
    bAllow=TRUE;
    if (GetIsPC(oCr)&&!bAllowPCs) bAllow=FALSE;
    else if (!GetIsPC(oCr)&&!bAllowNPCs) bAllow=FALSE;
    if (bAllow&&!NPCACTIsBusy(oCr))
    { // not prohibited
      oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oCr);
      if (fnIsAWeapon(oItem)) oRet=oCr;
      oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCr);
      if (fnIsAWeapon(oItem)) oRet=oCr;
    } // not prohibited
    nC++;
    oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find armed target
  return oRet;
} // NPCACTFindArmed()

object NPCACTFindBespelled(int bAllowPCs,int bAllowNPCs)
{ // PURPOSE: Find a non-busy target of this Bespelled
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  int nC=1;
  object oCr;
  int bAllow;
  oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(GetIsObjectValid(oCr)&&oRet==OBJECT_INVALID)
  { // find armed target
    bAllow=TRUE;
    if (GetIsPC(oCr)&&!bAllowPCs) bAllow=FALSE;
    else if (!GetIsPC(oCr)&&!bAllowNPCs) bAllow=FALSE;
    if (bAllow&&!NPCACTIsBusy(oCr))
    { // not prohibited
      if (fnIsBespelled(oCr)) oRet=oCr;
    } // not prohibited
    nC++;
    oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find armed target
  return oRet;
} // NPCACTFindBespelled()

object NPCACTFindVarCheck(string sVar,int bAllowPCs,int bAllowNPCs)
{ // PURPOSE: Find a non-busy target of this has variable set to value
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  int nC=1;
  object oCr;
  int bAllow;
  string sVarName=fnParse(sVar,"_");
  string sValue=fnRemoveParsed(sVar,sVarName,"_");
  oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(GetIsObjectValid(oCr)&&oRet==OBJECT_INVALID)
  { // find armed target
    bAllow=TRUE;
    if (GetIsPC(oCr)&&!bAllowPCs) bAllow=FALSE;
    else if (!GetIsPC(oCr)&&!bAllowNPCs) bAllow=FALSE;
    if (bAllow&&!NPCACTIsBusy(oCr))
    { // not prohibited
     if (GetLocalInt(oCr,sVarName)==StringToInt(sValue)) oRet=oCr;
    } // not prohibited
    nC++;
    oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find armed target
  return oRet;
} // NPCACTFindVarCheck()

object NPCACTFindNonBusyCreature()
{ // PURPOSE: To find a PC or NPC that is not busy
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oRet=OBJECT_INVALID;
  object oPC;
  int nC=1;
  oPC=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while(oPC!=OBJECT_INVALID&&oRet==OBJECT_INVALID)
  { // find a PC
    if (!NPCACTIsBusy(oPC)) oRet=oPC;
    nC++;
    oPC=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nC,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  } // find a PC
  return oRet;
} // NPCACTFindNonBusyCreature()

float fnNPCACTTalkTo(string sCom)
{ // PURPOSE: To initiate conversation
  // LAST MODIFIED BY: Deva Bryson Winblood
  float fDur=0.0;
  object oTarget=OBJECT_INVALID;
  string sParameters=GetStringRight(sCom,GetStringLength(sCom)-2);
  string sTag=fnParse(sParameters,"/");
  string sAnimation;
  string sOptionalConversation;
  sParameters=fnRemoveParsed(sParameters,sTag,"/");
  sAnimation=fnParse(sParameters,"/");
  sOptionalConversation=fnRemoveParsed(sParameters,sAnimation,"/");
  int bValidTargetType=TRUE;
  int bPCsAllowed=TRUE;
  int bNPCsAllowed=TRUE;
  if (GetLocalInt(OBJECT_SELF,"nNN")==TRUE) bNPCsAllowed=FALSE;
  if (GetLocalInt(OBJECT_SELF,"bNPCACTNOPC")==TRUE) bPCsAllowed=FALSE;
  if (sTag=="PC"&&bPCsAllowed==FALSE) bValidTargetType=FALSE;
  else if (sTag=="PC") oTarget=NPCACTFindNonBusyPC();
  if (sTag=="ANY")
  { // find any
    if (bPCsAllowed&&bNPCsAllowed) oTarget=NPCACTFindNonBusyCreature();
    else if (bPCsAllowed) oTarget=NPCACTFindNonBusyPC();
    if (!GetIsObjectValid(oTarget)&&bNPCsAllowed) oTarget=NPCACTFindNonBusyNPC();
  } // find any
  else if (GetStringLeft(sTag,4)=="RACE")
  { // specific race
    oTarget=NPCACTFindRace(GetStringRight(sTag,GetStringLength(sTag)-4),bPCsAllowed,bNPCsAllowed);
  } // specific race
  else if (GetStringLeft(sTag,5)=="CLASS")
  { // specific class
    oTarget=NPCACTFindClass(GetStringRight(sTag,GetStringLength(sTag)-5),bPCsAllowed,bNPCsAllowed);
  } // specific class
  else if (GetStringLeft(sTag,6)=="GENDER")
  { // specific gender
    oTarget=NPCACTFindGender(GetStringRight(sTag,GetStringLength(sTag)-6),bPCsAllowed,bNPCsAllowed);
  } // specific gender
  else if (GetStringLeft(sTag,5)=="ALIGN")
  { // specific alignment
    oTarget=NPCACTFindAlignment(GetStringRight(sTag,GetStringLength(sTag)-5),bPCsAllowed,bNPCsAllowed);
  } // specific alignment
  else if (GetStringLeft(sTag,7)=="WOUNDED")
  { // wounded % 1-99
    oTarget=NPCACTFindWounded(GetStringRight(sTag,GetStringLength(sTag)-7),bPCsAllowed,bNPCsAllowed);
  } // wounded % 1-99
  else if (sTag=="ARMED")
  { // armed
    oTarget=NPCACTFindArmed(bPCsAllowed,bNPCsAllowed);
  } // armed
  else if (sTag=="BESPELLED")
  { // bespelled
    oTarget=NPCACTFindBespelled(bPCsAllowed,bNPCsAllowed);
  } // bespelled
  else if (GetStringLeft(sTag,8)=="VARCHECK")
  { // variable check
    oTarget=NPCACTFindVarCheck(GetStringRight(sTag,GetStringLength(sTag)-8),bPCsAllowed,bNPCsAllowed);
  } // variable check
  else if (sTag!="PC")
  { // specific tag
    oTarget=GetNearestObjectByTag(sTag);
    if (GetIsObjectValid(oTarget))
    { // there is a target nearby with that tag
      if (GetObjectSeen(oTarget)==TRUE)
      { // I can see the target
        if (!NPCACTIsBusy(oTarget))
        { // The target is not Busy
        } // The target is not Busy
        else { oTarget=OBJECT_INVALID; }
      } // I can see the target
      else { oTarget=OBJECT_INVALID; }
    } // there is a target nearby with that tag
  } // specific tag
  if(GetIsObjectValid(oTarget))
  { // Valid target found
    ActionMoveToObject(oTarget);
    if (sAnimation=="F") ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,5.0);
    else if (sAnimation=="P") ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING,1.0,5.0);
    else if (sAnimation=="N") ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,5.0);
    else if (sAnimation=="L") ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0,5.0);
    if (GetStringLength(sOptionalConversation)<2) ActionStartConversation(oTarget);
    else { ActionStartConversation(oTarget,sOptionalConversation); }
    fDur=30.0;
  } // Valid target found
  return fDur;
} // fnNPCACTTalkTo()


//void main(){}

