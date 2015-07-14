///////////////////////////////////////////////////////////////////////////////
// NPC ACTIVITIES 6.1 - Bioware Patch 1.67 NPC ACTIVITIES extension library
// Version: 1.0
// Library name: 67
//=======================================================================
// Author: Deva Bryson Winblood
// Date  : 2/2/2006 & 2/3/2006
//=======================================================================
// This library provides access to commands and functions introduced
// in Bioware Neverwinter Nights Patch 1.67
//
//////////////////////////////////////////////////////////////////////////
#include "npcactlibtoolh"
////////////////////////////////////
// PROTOTYPES
////////////////////////////////////
int fnGetBodyPartNumber(string sName);
int fnGetTailNumber(string sName);
int fnGetWingNumber(string sName);
int fnGetFootstepNumber(string sName);
int fnGetPhenotypeNumber(string sName);
void fnCreateTrap(string sType,string sSize,string sWP,string sOpt);
void fnCreateObjectTrap(string sType,string sTag,string sOpt);
int fnGetTrapNumber(string sName);

///////////////////////////////////////////////////////////////// [ M A I N ]
void main()
{
   string sParmIn=GetLocalString(OBJECT_SELF,"sLIBParm");
   string sParm;
   string sParm1;
   string sParm2;
   string sParm3;
   string sParm4;
   object oMe=OBJECT_SELF;
   int nN;
   int nArgC;
   DLL_TokenizeParameters(sParmIn);
   nArgC=GetLocalInt(oMe,"nArgc");
   if (nArgC>0)
   { // Parameters were passed
     sParm=GetLocalString(oMe,"sArgv1");
     sParm1=GetLocalString(oMe,"sArgv2");
     sParm2=GetLocalString(oMe,"sArgv3");
     sParm3=GetLocalString(oMe,"sArgv4");
     sParm4=GetLocalString(oMe,"sArgv5");
     sParm=GetStringUpperCase(sParm);
     if (sParm=="REST")
     { // forced rest
       AssignCommand(oMe,ForceRest(oMe));
     } // forced rest
     else if (sParm=="SBP")
     { // set body part
       nN=fnGetBodyPartNumber(sParm1);
       SetCreatureBodyPart(nN,StringToInt(sParm2));
     } // set body part
     else if (sParm=="GBP")
     { // get body part
       nN=fnGetBodyPartNumber(sParm1);
       nN=GetCreatureBodyPart(nN);
       SetLocalInt(oMe,sParm2,nN);
     } // get body part
     else if (sParm=="STT")
     { // set tail type
       nN=fnGetTailNumber(sParm1);
       SetCreatureTailType(nN);
     } // set tail type
     else if (sParm=="GTT")
     { // get tail type
       nN=GetCreatureTailType();
       SetLocalInt(oMe,sParm1,nN);
     } // get tail type
     else if (sParm=="SWT")
     { // set wing type
       nN=fnGetWingNumber(sParm1);
       SetCreatureWingType(nN);
     } // set wing type
     else if (sParm=="GWT")
     { // get wing type
       nN=GetCreatureWingType();
       SetLocalInt(oMe,sParm1,nN);
     } // get wing type
     else if (sParm=="SFST")
     { // set footstep type
       nN=fnGetFootstepNumber(sParm1);
       SetFootstepType(nN);
     } // set footstep type
     else if (sParm=="NAME")
     { // set name
       SetName(oMe,sParm1);
     } // set name
     else if (sParm=="SPT")
     { // set phenotype
       nN=fnGetPhenotypeNumber(sParm1);
       SetPhenoType(nN);
     } // set phenotype
     else if (sParm=="GPT")
     { // get phenotype
       nN=GetPhenoType(oMe);
       SetLocalInt(oMe,sParm1,nN);
     } // get phenotype
     else if (sParm=="GR")
     { // get racial type
       nN=GetRacialType(oMe);
       SetLocalInt(oMe,sParm1,nN);
     } // get racial type
     else if (sParm=="SPID")
     { // set portrait ID
       nN=StringToInt(sParm1);
       if (nN<0) nN=0;
       SetPortraitId(oMe,nN);
     } // set portrait ID
     else if (sParm=="CT")
     { // create trap at location
       fnCreateTrap(sParm1,sParm2,sParm3,sParm4);
     } // create trap at location
     else if (sParm=="CTO")
     { // create trap on object
       fnCreateObjectTrap(sParm1,sParm2,sParm3);
     } // create trap on object
   } // Parameters were passed
   DLL_FreeParameters();
}
///////////////////////////////////////////////////////////////// [ M A I N ]

/////////////////////////////////////
// FUNCTIONS
/////////////////////////////////////

int fnGetBodyPartNumber(string sName)
{ // PURPOSE: Provide body part number
  int nRet=0;
  string sU=GetStringUpperCase(sName);
  if (sU=="RFOOT") nRet=CREATURE_PART_RIGHT_FOOT;
  else if (sU=="LFOOT") nRet=CREATURE_PART_LEFT_FOOT;
  else if (sU=="RSHIN") nRet=CREATURE_PART_RIGHT_SHIN;
  else if (sU=="LSHIN") nRet=CREATURE_PART_LEFT_SHIN;
  else if (sU=="RTHIGH") nRet=CREATURE_PART_RIGHT_THIGH;
  else if (sU=="LTHIGH") nRet=CREATURE_PART_LEFT_THIGH;
  else if (sU=="PELVIS") nRet=CREATURE_PART_PELVIS;
  else if (sU=="TORSO") nRet=CREATURE_PART_TORSO;
  else if (sU=="NECK") nRet=CREATURE_PART_NECK;
  else if (sU=="BELT") nRet=CREATURE_PART_BELT;
  else if (sU=="HEAD") nRet=CREATURE_PART_HEAD;
  else if (sU=="RFOREA") nRet=CREATURE_PART_RIGHT_FOREARM;
  else if (sU=="LFOREA") nRet=CREATURE_PART_LEFT_FOREARM;
  else if (sU=="RBICEP") nRet=CREATURE_PART_RIGHT_BICEP;
  else if (sU=="LBICEP") nRet=CREATURE_PART_LEFT_BICEP;
  else if (sU=="RSHOULDER") nRet=CREATURE_PART_RIGHT_SHOULDER;
  else if (sU=="LSHOULDER") nRet=CREATURE_PART_LEFT_SHOULDER;
  else if (sU=="RHAND") nRet=CREATURE_PART_RIGHT_HAND;
  else if (sU=="LHAND") nRet=CREATURE_PART_LEFT_HAND;
  return nRet;
} // fnGetBodyPartNumber()

int fnGetTailNumber(string sName)
{ // PURPOSE: Get Tail Number
  int nRet=CREATURE_TAIL_TYPE_NONE;
  string sU=GetStringUpperCase(sName);
  if (sU=="BONE") nRet=CREATURE_TAIL_TYPE_BONE;
  else if (sU=="DEVIL") nRet=CREATURE_TAIL_TYPE_DEVIL;
  else if (sU=="LIZARD") nRet=CREATURE_TAIL_TYPE_LIZARD;
  else if (StringToInt(sU)>0) nRet=StringToInt(sU);
  return nRet;
} // fnGetTailNumber()

int fnGetWingNumber(string sName)
{ // PURPOSE: Get the Wing Number
  int nRet=CREATURE_WING_TYPE_NONE;
  string sU=GetStringUpperCase(sName);
  if (sU=="ANGEL") nRet=CREATURE_WING_TYPE_ANGEL;
  else if (sU=="BAT") nRet=CREATURE_WING_TYPE_BAT;
  else if (sU=="BIRD") nRet=CREATURE_WING_TYPE_BIRD;
  else if (sU=="BUTTERFLY") nRet=CREATURE_WING_TYPE_BUTTERFLY;
  else if (sU=="DEMON") nRet=CREATURE_WING_TYPE_DEMON;
  else if (sU=="DRAGON") nRet=CREATURE_WING_TYPE_DRAGON;
  else if (StringToInt(sU)>0) nRet=StringToInt(sU);
  return nRet;
} // fnGetWingNumber()

int fnGetFootstepNumber(string sName)
{ // PURPOSE: Return number for footstep
  int nRet=FOOTSTEP_TYPE_NONE;
  string sU=GetStringUpperCase(sName);
  if (sU=="BEETLE") nRet=FOOTSTEP_TYPE_BEETLE;
  else if (sU=="DEFAULT") nRet=FOOTSTEP_TYPE_DEFAULT;
  else if (sU=="DRAGON") nRet=FOOTSTEP_TYPE_DRAGON;
  else if (sU=="FEATHER_WING") nRet=FOOTSTEP_TYPE_FEATHER_WING;
  else if (sU=="HOOF") nRet=FOOTSTEP_TYPE_HOOF;
  else if (sU=="HOOF_LARGE") nRet=FOOTSTEP_TYPE_HOOF_LARGE;
  else if (sU=="LARGE") nRet=FOOTSTEP_TYPE_LARGE;
  else if (sU=="LEATHER_WING") nRet=FOOTSTEP_TYPE_LEATHER_WING;
  else if (sU=="NORMAL") nRet=FOOTSTEP_TYPE_NORMAL;
  else if (sU=="SEAGULL") nRet=FOOTSTEP_TYPE_SEAGULL;
  else if (sU=="SHARK") nRet=FOOTSTEP_TYPE_SHARK;
  else if (sU=="SKELETON") nRet=FOOTSTEP_TYPE_SKELETON;
  else if (sU=="SOFT") nRet=FOOTSTEP_TYPE_SOFT;
  else if (sU=="SPIDER") nRet=FOOTSTEP_TYPE_SPIDER;
  else if (sU=="WATER_LARGE") nRet=FOOTSTEP_TYPE_WATER_LARGE;
  else if (sU=="WATER_NORMAL") nRet=FOOTSTEP_TYPE_WATER_NORMAL;
  else if (StringToInt(sU)>0) nRet=StringToInt(sU);
  return nRet;
} // fnGetFootstepNumber()

int fnGetPhenotypeNumber(string sName)
{ // PURPOSE: Get Number for Phenotype
  int nRet=PHENOTYPE_NORMAL;
  string sU=GetStringUpperCase(sName);
  if (sU=="BIG") nRet=PHENOTYPE_BIG;
  else if (StringToInt(sU)>0) nRet=StringToInt(sU);
  else if (sU=="CUSTOM1") nRet=PHENOTYPE_CUSTOM1;
  else if (sU=="CUSTOM2") nRet=PHENOTYPE_CUSTOM2;
  else if (sU=="CUSTOM3") nRet=PHENOTYPE_CUSTOM3;
  else if (sU=="CUSTOM4") nRet=PHENOTYPE_CUSTOM4;
  else if (sU=="CUSTOM5") nRet=PHENOTYPE_CUSTOM5;
  else if (sU=="CUSTOM6") nRet=PHENOTYPE_CUSTOM6;
  else if (sU=="CUSTOM7") nRet=PHENOTYPE_CUSTOM7;
  else if (sU=="CUSTOM8") nRet=PHENOTYPE_CUSTOM8;
  else if (sU=="CUSTOM9") nRet=PHENOTYPE_CUSTOM9;
  else if (sU=="CUSTOM10") nRet=PHENOTYPE_CUSTOM10;
  else if (sU=="CUSTOM11") nRet=PHENOTYPE_CUSTOM11;
  else if (sU=="CUSTOM12") nRet=PHENOTYPE_CUSTOM12;
  else if (sU=="CUSTOM13") nRet=PHENOTYPE_CUSTOM13;
  else if (sU=="CUSTOM14") nRet=PHENOTYPE_CUSTOM14;
  else if (sU=="CUSTOM15") nRet=PHENOTYPE_CUSTOM15;
  else if (sU=="CUSTOM16") nRet=PHENOTYPE_CUSTOM16;
  else if (sU=="CUSTOM17") nRet=PHENOTYPE_CUSTOM17;
  else if (sU=="CUSTOM18") nRet=PHENOTYPE_CUSTOM18;
  return nRet;
} // fnGetPhenotypeNumber()

int fnGetFaction(string sFact)
{ // PURPOSE: Return faction number
  int nRet=STANDARD_FACTION_HOSTILE;
  string sU=GetStringUpperCase(sFact);
  if (sU=="C") nRet=STANDARD_FACTION_COMMONER;
  else if (sU=="D") nRet=STANDARD_FACTION_DEFENDER;
  else if (sU=="M") nRet=STANDARD_FACTION_MERCHANT;
  return nRet;
} // fnGetFaction()

void fnCreateTrap(string sType,string sSize,string sWP,string sOpt)
{ // PURPOSE: Create Trap at waypoint
 int nType=fnGetTrapNumber(sType);
 int nSize=StringToInt(sSize);
 object oWP=GetNearestObjectByTag(sWP);
 int nFaction=fnGetFaction(sOpt);
 if (oWP!=OBJECT_INVALID&&nSize>0)
 { // waypoint exists
   oWP=CreateTrapAtLocation(nType,GetLocation(oWP),IntToFloat(nSize),"",nFaction);
 } // waypoint exists
} // fnCreateTrap()

void fnCreateObjectTrap(string sType,string sTag,string sOpt)
{ // PURPOSE: Create Trap on Object
  int nType=fnGetTrapNumber(sType);
  object oOb=GetNearestObjectByTag(sTag);
  int nFaction=fnGetFaction(sOpt);
  if (oOb!=OBJECT_INVALID)
  { // trap object
    CreateTrapOnObject(nType,oOb,nFaction);
  } // trap object
} // fnCreateObjectTrap()

int fnGetTrapNumber(string sName)
{ // PURPOSE: Return the number for the trap
  int nRet=0;
  string sU=GetStringUpperCase(sName);
  if (sU=="AACID") nRet=TRAP_BASE_TYPE_AVERAGE_ACID;
  else if (sU=="AACIDS") nRet=TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH;
  else if (sU=="AELEC") nRet=TRAP_BASE_TYPE_AVERAGE_ELECTRICAL;
  else if (sU=="AFIRE") nRet=TRAP_BASE_TYPE_AVERAGE_FIRE;
  else if (sU=="AFROST") nRet=TRAP_BASE_TYPE_AVERAGE_FROST;
  else if (sU=="AGAS") nRet=TRAP_BASE_TYPE_AVERAGE_GAS;
  else if (sU=="AHOLY") nRet=TRAP_BASE_TYPE_AVERAGE_HOLY;
  else if (sU=="ANEGATIVE") nRet=TRAP_BASE_TYPE_AVERAGE_NEGATIVE;
  else if (sU=="ASONIC") nRet=TRAP_BASE_TYPE_AVERAGE_SONIC;
  else if (sU=="ASPIKE") nRet=TRAP_BASE_TYPE_AVERAGE_SPIKE;
  else if (sU=="ATANGLE") nRet=TRAP_BASE_TYPE_AVERAGE_TANGLE;
  else if (sU=="DACID") nRet=TRAP_BASE_TYPE_DEADLY_ACID;
  else if (sU=="DACIDS") nRet=TRAP_BASE_TYPE_DEADLY_ACID_SPLASH;
  else if (sU=="DELEC") nRet=TRAP_BASE_TYPE_DEADLY_ELECTRICAL;
  else if (sU=="DFIRE") nRet=TRAP_BASE_TYPE_DEADLY_FIRE;
  else if (sU=="DFROST") nRet=TRAP_BASE_TYPE_DEADLY_FROST;
  else if (sU=="DGAS") nRet=TRAP_BASE_TYPE_DEADLY_GAS;
  else if (sU=="DHOLY") nRet=TRAP_BASE_TYPE_DEADLY_HOLY;
  else if (sU=="DNEGATIVE") nRet=TRAP_BASE_TYPE_DEADLY_NEGATIVE;
  else if (sU=="DSONIC") nRet=TRAP_BASE_TYPE_DEADLY_SONIC;
  else if (sU=="DSPIKE") nRet=TRAP_BASE_TYPE_DEADLY_SPIKE;
  else if (sU=="DTANGLE") nRet=TRAP_BASE_TYPE_DEADLY_TANGLE;
  else if (sU=="EELEC") nRet=TRAP_BASE_TYPE_EPIC_ELECTRICAL;
  else if (sU=="EFIRE") nRet=TRAP_BASE_TYPE_EPIC_FIRE;
  else if (sU=="EFROST") nRet=TRAP_BASE_TYPE_EPIC_FROST;
  else if (sU=="ESONIC") nRet=TRAP_BASE_TYPE_EPIC_SONIC;
  else if (sU=="MACID") nRet=TRAP_BASE_TYPE_MINOR_ACID;
  else if (sU=="MACIDS") nRet=TRAP_BASE_TYPE_MINOR_ACID_SPLASH;
  else if (sU=="MELEC") nRet=TRAP_BASE_TYPE_MINOR_ELECTRICAL;
  else if (sU=="MFIRE") nRet=TRAP_BASE_TYPE_MINOR_FIRE;
  else if (sU=="MFROST") nRet=TRAP_BASE_TYPE_MINOR_FROST;
  else if (sU=="MGAS") nRet=TRAP_BASE_TYPE_MINOR_GAS;
  else if (sU=="MHOLY") nRet=TRAP_BASE_TYPE_MINOR_HOLY;
  else if (sU=="MNEGATIVE") nRet=TRAP_BASE_TYPE_MINOR_NEGATIVE;
  else if (sU=="MSONIC") nRet=TRAP_BASE_TYPE_MINOR_SONIC;
  else if (sU=="MSPIKE") nRet=TRAP_BASE_TYPE_MINOR_SPIKE;
  else if (sU=="MTANGLE") nRet=TRAP_BASE_TYPE_MINOR_TANGLE;
  else if (sU=="SACID") nRet=TRAP_BASE_TYPE_STRONG_ACID;
  else if (sU=="SACIDS") nRet=TRAP_BASE_TYPE_STRONG_ACID_SPLASH;
  else if (sU=="SELEC") nRet=TRAP_BASE_TYPE_STRONG_ELECTRICAL;
  else if (sU=="SFIRE") nRet=TRAP_BASE_TYPE_STRONG_FIRE;
  else if (sU=="SFROST") nRet=TRAP_BASE_TYPE_STRONG_FROST;
  else if (sU=="SGAS") nRet=TRAP_BASE_TYPE_STRONG_GAS;
  else if (sU=="SHOLY") nRet=TRAP_BASE_TYPE_STRONG_HOLY;
  else if (sU=="SNEGATIVE") nRet=TRAP_BASE_TYPE_STRONG_NEGATIVE;
  else if (sU=="SSONIC") nRet=TRAP_BASE_TYPE_STRONG_SONIC;
  else if (sU=="SSPIKE") nRet=TRAP_BASE_TYPE_STRONG_SPIKE;
  else if (sU=="STANGLE") nRet=TRAP_BASE_TYPE_STRONG_TANGLE;
  return nRet;
} // fnGetTrapNumber()
