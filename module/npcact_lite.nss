////////////////////////////////////////////////////////////////////////////////
// npcact_lite - NPC ACTIVITIES 6.0  Lite version Interpretter
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             04/30/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/01/2004
// modified for ~ anim peak 4/15/09
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
#include "npcact_h_cust"   // customization
#include "npcact_h_core"   // core commands
#include "npcact_h_logic"  // logic commands
#include "npcact_h_make"   // creation commands
#include "npcact_h_var"    // variable initialization and setting commands
#include "npcact_h_vfx"    // visual effect commands
#include "npcact_h_speak"  // Speaking and singing related commands
/////////////////////////
// PROTOTYPES
/////////////////////////

void fnDoPauseThenEnd();

///////////////////////////////////////////////////////////////////////// MAIN
void main()
{
   object oMe=OBJECT_SELF;
   string sAct=GetLocalString(oMe,"sAct");
   float fDelay=0.2; // default delay
   string sCommand=fnParse(sAct);
   string sL1=GetStringLeft(sAct,1);
   string sL2=GetStringLeft(sAct,2);
   string sL3=GetStringLeft(sAct,3);
   string sL4=GetStringLeft(sAct,4);
   string sS;
   int nGNBDisabled=GetLocalInt(oMe,"nGNBDisabled");
   fnDebug(GetTag(oMe)+" LITE INTERPRETER",TRUE);
   if (nGNBDisabled!=TRUE&&fnGetIsBusy(oMe)==FALSE&&GetStringLength(sAct)>0)
   { // okay to deal with commands
     fnDebug("   sAct Before='"+sAct+"' LEN:"+IntToString(GetStringLength(sAct)),TRUE);
     sAct=fnRemoveParsed(sAct,sCommand);
     fnDebug("   sAct After='"+sAct+"' LEN:"+IntToString(GetStringLength(sAct)),TRUE);
     SetLocalString(oMe,"sAct",sAct);
     SetLocalInt(oMe,"nGNBInterpActivity",0); // used as fail safe
     /// begin the big if/else if
     if (sL1=="@")
     { // custom script
       fnDebug("["+GetTag(oMe)+"]Custom Script("+sCommand+")",TRUE);
       fDelay=fnNPCACTAtScript(sCommand);
     } // custom script
     else if (sL1=="'")
     { // Quick speak
       fDelay=0.1;
       AssignCommand(oMe,SpeakString(GetStringRight(sCommand,GetStringLength(sCommand)-1)));
     } // Quick Speak
     else if (sL1=="#")
     { // library call
       fnDebug("["+GetTag(oMe)+"]Library Call("+sCommand+")",TRUE);
       fDelay=fnNPCACTLibCall(sCommand);
     } // library call
     else if (sL1=="*")
     { // professions call
       fnDebug("["+GetTag(oMe)+"]Professions Call("+sCommand+")",TRUE);
       fDelay=fnNPCACTProfCall(sCommand);
     } // professions call
     else if (sL1=="&")
     { // IF logic
       fDelay=fnNPCACTLogicCore(sCommand);
     } // IF logic
     else if (sL1=="!")
     { // Set variable
       fDelay=fnNPCACTSetVariable(sCommand);
     } // Set variable
     else if (sL1=="+"||sL1=="-")
     { // variable addition and subtraction
       fDelay=fnNPCACTAddSubtract(sCommand);
     } // variable addition and subtraction
     else if (sL1=="$")
     { // custom event script assign
       fDelay=fnNPCACTScriptSet(sCommand);
     } // custom event script assign
     else if (sL1=="^")
     { // non-visual effect
       fDelay=fnNPCACTNonVFX(sCommand);
     } // non-visual effect
     else if (sL1=="]")
     { // Set Appearance
       fDelay=fnNPCACTSetAppearance(sCommand);
     } // Set Appearance
     else if (sL1=="[")
     { // Set Mode
       fDelay=fnNPCACTModeSet(sCommand);
     } // Set Mode
     else if (sL1==">")
     { // Set timed event
       fDelay=fnNPCACTInsertTimedEvent(sCommand);
     } // Set timed event
     else if (sL1=="~"||sL4=="ANIM") // mod peak 2/09
     { // animation command
       fDelay=fnNPCACTAnimate(sCommand);
     } // animation command
     else if (sL2=="TT")
     { // Talk to
       fDelay=fnNPCACTTalkTo(sCommand);
     } // Talk to
     else if (sL3=="RWL"||(sL2=="RW"&&GetStringLength(sCommand)>2))
     { // random word list
       fDelay=fnNPCACTRandomSpeak(sCommand);
     } // random word list
     else if (sL4=="LYRI"||sL2=="LY")
     { // sing song
       fDelay=fnNPCACTLyrical(sCommand);
     } // sing song
     else if (sL2=="RC")
     { // random command
       fDelay=fnNPCACTRandomCommand(sCommand);
     } // random command
     else if (sL2=="WP")
     { // set new destination
       sCommand=GetStringRight(sCommand,GetStringLength(sCommand)-2);
       SetLocalString(OBJECT_SELF,"sGNBDTag",sCommand);
     } // set new destination
     else if (sL1==":")
     { // create creature
       fDelay=fnNPCACTMakeCreature(sCommand);
     } // create creature
     else if (sL2=="AO")
     { // attack object by tag
       fDelay=fnNPCACTAttackObject(sCommand);
     } // attack object by tag
     else if (sL2=="CB")
     { // enter combat with person with specific tag
       fDelay=fnNPCACTEnterCombat(sCommand);
     } // enter combat with person with specific tag
     else if (sL2=="Cc")
     { // change clothing
       fDelay=fnNPCACTChangeClothes(sCommand);
     } // change clothing
     else if (sL2=="DO")
     { // Destroy Object by tag
       fDelay=fnNPCACTDestroyObject(sCommand);
     } // Destroy Object by tag
     else if (sL2=="EQ")
     { // Equip Weapons
       fDelay=fnNPCACTEquipWeapons();
     } // Equip Weapons
     else if (sL2=="UE")
     { // Unequip Weapons
       fDelay=fnNPCACTUnequipWeapons();
     } // Unequip Weapons
     else if (sCommand=="REST"||sCommand=="RS")
     { // rest
       fDelay=fnNPCACTRest();
     } // rest
     else if (sCommand=="SLEP"||sCommand=="SL")
     { // sleep
       fDelay=fnNPCACTSleep();
     } // sleep
     else if (sL4=="SITS")
     { // sits
       fDelay=fnNPCACTSitForSpecified(sCommand);
     } // sits
     else if (sL2=="CO"&&GetStringLength(sCommand)>2)
     { // create item
       fDelay=fnNPCACTMakeItem(sCommand);
     } // create item
     else if (sL2=="CP")
     { // create placeable
       fDelay=fnNPCACTMakePlaceable(sCommand);
     } // create placeable
     else if (sL4=="FOTG"||sL2=="FT")
     { // follow specific tag
       fDelay=fnNPCACTFollowByTag(sCommand);
     } // follow specific tag
     else if (sCommand=="RAND"||sCommand=="RW")
     { // random walk
       fDelay=fnNPCACTRandomWalk();
     } // random walk
     else if (sL4=="TAKE"||sL2=="TK")
     { // take item by tag
       fDelay=fnNPCACTTakeItem(sCommand);
     } // take item by tag
     else if (sL4=="WAIT"||sL2=="WT")
     { // wait
       fDelay=fnNPCACTWait(sCommand);
     } // wait
     else if (sL4=="SFAC"||sL2=="SF")
     { // Set Facing
       fDelay=fnNPCACTSetFacing(sCommand);
     } // Set Facing
     else if (sCommand=="LOCK"||sCommand=="lk")
     { // lock doors or container
       fDelay=fnNPCACTLockThings();
     } // lock doors or container
     else if (sCommand=="UNLOCK"||sCommand=="ul")
     { // unlock
       fDelay=fnNPCACTUnlock();
     } // unlock
     else if (sCommand=="CLOS"||sCommand=="CD")
     { // close door
       fDelay=fnNPCACTCloseDoors();
     } // close door
     else if (sL3=="LAG"||(sL1=="L"&&GetStringLength(sCommand)==2))
     { // lag commands
       sL1=GetStringRight(sCommand,1);
       if (sL1=="1") SetLocalInt(OBJECT_SELF,"nGNBLagMeth",1);
       else if (sL1=="2") SetLocalInt(OBJECT_SELF,"nGNBLagMeth",2);
       else if (sL1=="3") SetLocalInt(OBJECT_SELF,"nGNBLagMeth",3);
       else if (sL1=="4") SetLocalInt(OBJECT_SELF,"nGNBLagMeth",4);
     } // lag commands
     else if (sCommand=="NONP"||sCommand=="NN")
     { // no NPC interaction
       SetLocalInt(OBJECT_SELF,"nNN",TRUE);
       fDelay=0.1;
     } // no NPC interaction
     else if (sCommand=="YSNP"||sCommand=="YN")
     { // yes NPC interaction
       DeleteLocalInt(OBJECT_SELF,"nNN");
       fDelay=0.1;
     } // yes NPC interaction
     else if (sL2=="BS")
     { // base script set
       fDelay=fnNPCACTSetBaseScripts(sCommand);
     } // base script set
     else if (sL2=="BM")
     { // beam effect
       fDelay=fnNPCACTBeamEffect(sCommand);
     } // beam effect
     else if (sL3=="EFF")
     { // Effect
       fDelay=fnNPCACTEffects(sCommand);
     } // Effect
     else if (sL2=="FX")
     { // FX area
       fDelay=fnNPCACTPlaceableVFX(sCommand);
     } // FX area
     else if (sL2=="PF")
     { // persistent visual effect
       fDelay=fnNPCACTPersistentVFX(sCommand);
     } // persistent visual effect
     else if (sL2=="RV")
     { // remove visual effect
       fDelay=fnNPCACT4Visual(0,sCommand);
     } // remove visual effect
     else if (sL2=="VF")
     { // add visual effect
       fDelay=fnNPCACT4Visual(1,sCommand);
     } // add visual effect
     else if (sL2=="YP"||sL4=="YSPC")
     { // enable PC interaction
       DeleteLocalInt(OBJECT_SELF,"bNPCACTNOPC");
     } // enable PC interaction
     else if (sL2=="NP"||sL4=="NOPC")
     { // disable PC interaction
       SetLocalInt(OBJECT_SELF,"bNPCACTNOPC",TRUE);
     } // disable PC interaction
     /// end the big if/else if
     sAct=GetLocalString(oMe,"sAct"); // see if changed
     nGNBDisabled=GetLocalInt(oMe,"nGNBDisabled");
     if (fDelay<0.2) fDelay=0.1;
     if (GetStringLength(sAct)>0&&fDelay>0.0) { DelayCommand(fDelay,ExecuteScript("npcact_lite",oMe));   }
     else if (!nGNBDisabled) { DelayCommand(fDelay,fnDoPauseThenEnd()); }
     else { DelayCommand(2.0,ExecuteScript("npcact_lite",oMe)); }
   } // okay to deal with commands
   else if (!nGNBDisabled)
   {
     fnDoPauseThenEnd();
   }
   else { DelayCommand(2.0,ExecuteScript("npcact_lite",oMe)); }
}
///////////////////////////////////////////////////////////////////////// MAIN

/////////////////////////
// FUNCTIONS
/////////////////////////
void fnState1Required()
{ // PURPOSE: Make sure not stuck in a bad state
  // LAST MODIFIED BY: Deva Bryson Winblood
  if (GetLocalInt(OBJECT_SELF,"nGNBState")!=1) { SetLocalInt(OBJECT_SELF,"nGNBState",1); DelayCommand(0.3,fnState1Required()); }
} // fnState1Required()

void fnDoPauseThenEnd()
{ // PURPOSE: To check for a pause and handle that
  // and switch to state 1 when done with pause
  // LAST MODIFIED BY: Deva Bryson Winblood
  float fGNBPause=GetLocalFloat(OBJECT_SELF,"fGNBPause");
  if(GetLocalInt(OBJECT_SELF,"nASMethod")==6) fGNBPause=IntToFloat(Random(FloatToInt(fGNBPause))+1);
  SetLocalInt(OBJECT_SELF,"nGNBState",7);
  if (fGNBPause>0.0) { DelayCommand(fGNBPause,fnState1Required()); }
  else { fnState1Required(); }
} // fnDoPauseThenEnd()
