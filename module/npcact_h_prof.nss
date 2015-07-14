///////////////////////////////////////////////////////////////////////////////
// npcact_h_prof - NPC ACTIVITIES 6.0 Professions Header File
// By Deva Bryson Winblood.   09/06/2004
// fnPROFActionMethod by Peak 05/19/2010
// Last modified 6/20/10 - Peak
//----------------------------------------------------------------------------
// PURPOSE: The purpose of this file is to provide support functions for
// extracting and cleaning up parameters and other tasks that will be needed
// repeatedly for the various professions scripts.
///////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
#include "npcact_h_moving"
#include "npcact_h_anim"
/////////////////////////////
// PROTOTYPES
/////////////////////////////

// FILE: npcact_h_prof                     FUNCTION: fnPROFCleanupArgs()
//  This function will delete the argument variables used by this profession
// and should be called by any profession script that no longer needs its
// arguments.
void fnPROFCleanupArgs(object oNPC=OBJECT_SELF);

// FILE: npcact_h_prof                     FUNCTION: fnPROFActionMethod()
// This function handles the action methods for Actions for a given
//profession.  This section of code was used frequently thus, it was
//put into this header. - Deva
/*
sMethod is a series of method commands with period "." delimiters
Commands: W1,W2,W3: specific placeables/waypoints of activity; @ custom script;
! animation using Magic Number; ET equip tool; A attack object (without faction
change); UT unequip tool; U use object; F face object/waypoint; ' say; P pause;
L look; D done (for your debugging use: W1.ET.AStone.~!16/50.D.W2.UT.!2/10
finishes before W2, so you can check out small portions without rewriting)
new: L Action: random look left, look right, scratch head - peak 5/10
oTool is the optional tool object for the profession. No tool needed in some
cases - harvesting eggs, consuming etc. sLoc1-3 = tags for W objects/locations
NA = not applicable. The variable bPROFActionMethodSuccess will be set to TRUE
when this script is successful, FALSE otherwise. Variable bPROFActDone==TRUE
indicates script is done. These variables are stored on the NPC. - Peak */
void fnPROFActionMethod(string sMethod,object oTool=OBJECT_INVALID, object oNPC=OBJECT_SELF,string sLoc1="NA",string sLoc2="NA",string sLoc3="NA");

// FILE: npcact_h_prof                     FUNCTION: fnPROFContainerHasItem()
// This function will return an object in a store, container, etc. inventory
// by traversing its inventory and looking for the item.
object fnPROFContainerHasItem(object oContainer,string sItemTag);

// FILE: npcact_h_prof                     FUNCTION: GetPlayerID()
// This function returns a string formatted ID for the player.  If you have
// a specific way of storing IDs for your module simply replace this function with
// your own and rebuild the scripts.
string GetPCPlayerID(object oPC);


/////////////////////////////
// FUNCTIONS
/////////////////////////////

object fnPROFContainerHasItem(object oContainer,string sItemTag)
{ // PURPOSE: To find an item in a container
  object oRet=OBJECT_INVALID;
  object oInv=GetFirstItemInInventory(oContainer);
  while(oRet==OBJECT_INVALID&&oInv!=OBJECT_INVALID)
  { // traverse inventory
    if (GetTag(oInv)==sItemTag) oRet=oInv;
    oInv=GetNextItemInInventory(oContainer);
  } // traverse inventory
  return oRet;
} // fnPROFContainerHasItem()

void fnPROFActionMethod(string sMethod,object oTool=OBJECT_INVALID, object oNPC=OBJECT_SELF,string sLoc1="NA",string sLoc2="NA",string sLoc3="NA")
{ // PURPOSE: To handle the special methods of a profession
  // rewritten Peak (Peter D. Busby) 5/19/10 debugged 5/21/10
  int METHOD_FAILED = 16; // failsafe: modify if needed, max 19.
  object oOb=OBJECT_INVALID;
  int nN;
  string sS, sSS, sParse;
  string sActs = sMethod;
  int bDone=TRUE; // when true, specific Action complete
  int bSuccess=TRUE; // FALSE on failure to complete Method
  float fDelay=0.1;  // for reiteration
  int nInAction=GetLocalInt(oNPC,"nPROFInAction"); // iteration count
  fnDebug("fnActionMethod called with sMethod "+sMethod+", oTool=="+GetTag(oTool)+" oNPC=="+fnGetNPCTag(oNPC)+" sLoc1=="+sLoc1+" sLoc2=="+sLoc2+" sLoc3=="+sLoc3);
  fnDebugInt("InAction",nInAction,TRUE); // display AM# // requires new npcactivitiesh
  int nSpeed=GetLocalInt(oNPC,"nGNBStateSpeed");
  if (nSpeed<1) nSpeed=6;
  // variables set
  nInAction++;
  SetLocalInt(oNPC,"nPROFInAction",nInAction);
  fnDebug("At nPROFInAction=="+IntToString(nInAction)+", ActionMethod string== "+sActs,TRUE);
  sParse=fnParse(sActs);
  if (GetStringLeft(sParse,1)=="W")
  { // go to work area
    if (GetStringRight(sParse,1)=="1") { oOb=GetObjectByTag(sLoc1); }
    else if (GetStringRight(sParse,1)=="2") { oOb=GetObjectByTag(sLoc2); }
    else if (GetStringRight(sParse,1)=="3") { oOb=GetObjectByTag(sLoc3); }
    if (GetIsObjectValid(oOb))
    { // valid destination
      if (GetArea(oOb)!=GetArea(oNPC)||GetDistanceBetween(oOb,oNPC)>2.5)
      { // move
        SetLocalInt(oNPC,"nGNBProfProc",1); // let States know still processing
        nN=fnMoveToDestination(oNPC,oOb); //what about dist sensitivity?
        fnDebug("In Action Method, fnMoveToDestination returned "+IntToString(nN),TRUE);
        if(nN==0) bDone=FALSE; // move fn still in process
        else if(nN==-1)
        { // move fn failed
          fnDebug("In Action Method, failed to arrive at "+sParse+" == "+GetTag(oOb),FALSE);
          bSuccess=FALSE; // flag failure
          nInAction=METHOD_FAILED; // trigger exit from Action Method
        } // move fn failed
      } // move. Note, the default else is to proceed to the next Action.
      DelayCommand(3.0,AssignCommand(oNPC,SetFacingPoint(GetPosition(oOb)))); // face object
    } // valid destination
    else
    { // invalid
      fnDebug("Action Method destination "+sParse+" does not exist. Check corresponding input sLoc#");
      bSuccess=FALSE; // flag failure
    //  nInAction=METHOD_FAILED; // trigger exit from Action Method
    } // invalid
  } // go to work area
  else if (GetStringLeft(sParse,1)=="@")
  { // custom script
    sS=GetStringRight(sParse,GetStringLength(sParse)-1);
    AssignCommand(oNPC,ActionDoCommand(ExecuteScript(sS,oNPC)));
    if(GetLocalInt(oNPC,"nPROFScriptedActionSuccess")==2) // scripter may save results on NPC: 0 or nothing = continue to next Action
    { bSuccess=FALSE;                                     // 1 indicates Action still proceeding; ActionMethod failsafe time out @17 hb still active
      nInAction=METHOD_FAILED; // trigger exit            // 2 indicates failure of Action, trigger immediate exit and flag failure if critical
    }                                                     // To clean up, delete LocalInt nPROFScriptedActionSuccess to continue with success
    if(GetLocalInt(oNPC,"nPROFScriptedActionSuccess")==1) bDone=FALSE; // default is to continue, so set to 1 for reiteration of subscript
  } // custom script
  else if (GetStringLeft(sParse,1)=="!")
  { // animation
    sS=GetStringRight(sParse,GetStringLength(sParse)-1);
    sSS=fnParse(sS,"/"); // this is the anim ##
    nN=fnNPCACTAnimMagicNumber(sSS); // modPeak 6/10
    sS=fnRemoveParsed(sS,sSS,"/"); // this is 5 x the duration in sec
    fDelay=IntToFloat(StringToInt(sS))*0.2;
    AssignCommand(oNPC,ActionPlayAnimation(nN,1.0,fDelay));
  } // animation
  else if (sParse=="ET")
  { // equip tool
    if (GetIsObjectValid(oTool))
    { // tool is valid
      AssignCommand(oNPC,ActionEquipItem(oTool,INVENTORY_SLOT_RIGHTHAND));
    } // tool is valid
  } // equip tool
  else if (GetStringLeft(sParse,1)=="A")
  { // attack object <Tag> / <Dur> sec (+1)
    sS=GetStringRight(sParse,GetStringLength(sParse)-1);
    sSS=fnParse(sS,"/");
    oOb=GetNearestObjectByTag(sSS,oNPC,1);
    sS=fnRemoveParsed(sS,sSS,"/");
    fDelay=IntToFloat(StringToInt(sS))+1.0;
    if(GetIsObjectValid(oOb))
    { // do it, using tool as equipped
      DelayCommand(fDelay,AssignCommand(oNPC,ClearAllActions()));
      AssignCommand(oNPC,ActionAttack(oOb,TRUE)); //ActionAttack is always successful
    } // do it, continues for Dur seconds
  } // attack object
  else if (sParse=="UT")
  { // unequip tool
    if (GetIsObjectValid(oTool))
    { // tool is valid
      AssignCommand(oNPC,ActionUnequipItem(oTool));
    } // tool is valid
  } // unequip tool
  else if (GetStringLeft(sParse,1)=="U")
  { // use object
    sS=GetStringRight(sParse,GetStringLength(sParse)-1);
    oOb=GetNearestObjectByTag(sS,oNPC,1);
    if(GetIsObjectValid(oOb))
    { // do it
      AssignCommand(oNPC,ActionInteractObject(oOb));
    } // do it
  } // use object
  else if (GetStringLeft(sParse,1)=="F")
  { // face
    sS=GetStringRight(sParse,GetStringLength(sParse)-1);
    oOb=GetNearestObjectByTag(sS,oNPC,1);
    if(GetIsObjectValid(oOb))
    { // do it
      AssignCommand(oNPC,ActionDoCommand(SetFacingPoint(GetPosition(oOb))));
    } // do it
  } // face
  else if (GetStringLeft(sParse,1)=="'")
  { // say something
    sS=GetStringRight(sParse,GetStringLength(sParse)-1);
    AssignCommand(oNPC,ActionSpeakString(sS));
  } // say something
  else if (GetStringLeft(sParse,1)=="P")
  { // pause
    sS=GetStringRight(sParse,GetStringLength(sParse)-1);
    fDelay=IntToFloat(StringToInt(sS));
    AssignCommand(oNPC,ActionWait(fDelay));
  } // pause
  else if (GetStringLeft(sParse,1)=="L")
  { // look
    sS=GetStringRight(sParse,GetStringLength(sParse)-1);
    nN=StringToInt(sS);
    fDelay=IntToFloat(nN);
    while(nN>0)
    { // look around
      if(d4()==1)
      { // turn
        oOb=GetNearestObject(OBJECT_TYPE_CREATURE,oNPC,d6());
        if(oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_CREATURE,oNPC,1);
        if(oOb!=OBJECT_INVALID) AssignCommand(oNPC,ActionDoCommand(SetFacingPoint(GetPosition(oOb))));
      } // turn
      if(d4()==1) AssignCommand(oNPC,ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT,1.0,fDelay/3));
      if(d4()==1) AssignCommand(oNPC,ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT,1.0,fDelay/3));
      if(d4()==1) AssignCommand(oNPC,ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD,1.0,fDelay/3));
      if(d4()==1) AssignCommand(oNPC,ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT,1.0,fDelay/3));
      if(d4()==1) AssignCommand(oNPC,ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT,1.0,fDelay/3));
      nN--;
    } // look around
  } // look
  // assess results
  if (bDone)
  { // Action is complete
    sActs=fnRemoveParsed(sActs,sParse); // prepare for next Action
    nInAction=1;
  } // Action is complete
  if (sActs==""||!bSuccess||GetStringLeft(sParse,1)=="D")
  { // trigger exit
    nInAction=20;
  } // trigger exit
  if(nInAction<METHOD_FAILED)
  { // reiterate
    SetLocalInt(oNPC,"nPROFInAction",nInAction);
    DelayCommand(IntToFloat(nSpeed)+fDelay,fnPROFActionMethod(sActs,oTool,oNPC,sLoc1,sLoc2,sLoc3));
  } // reiterate
  else
  { // exit
    fnDebug("Exit routine, nPROFInAction=="+IntToString(nInAction)+". If <20, timeout failure, else success.",TRUE);
    DeleteLocalInt(oNPC,"nPROFInAction");
    AssignCommand(oNPC,ActionDoCommand(SetLocalInt(oNPC,"bPROFActDone",TRUE)));
    if(nInAction<20)
    { // timed out
      bSuccess=FALSE;
    } // timed out
  } // exit
  SetLocalInt(oNPC,"bPROFActionMethodSuccess",bSuccess); // in case profession script needs to know
} // fnPROFActionMethod()


void fnPROFCleanupArgs(object oNPC=OBJECT_SELF)
{ // PURPOSE: To cleanup sArgV# and nArgC variables when they are no longer needed
  int nC=GetLocalInt(oNPC,"nArgC");
  int nLoop=1;
  while(nLoop<=nC)
  { // delete variables
    DeleteLocalString(oNPC,"sArgV"+IntToString(nLoop));
    nLoop++;
  } // delete variables
  DeleteLocalInt(oNPC,"nArgC");
} // fnPROFCleanupArgs()

string GetPCPlayerID(object oPC)
{ // PURPOSE: To return a string representing this players ID
  string sRet="";
  if (GetIsPC(oPC))
  { // is PC
    sRet=GetPCPublicCDKey(oPC)+GetPCPlayerName(oPC)+GetName(oPC);
  } // is PC
  return sRet;
} // GetPlayerID()

//void main(){} // comment out after compiling, then save
