////////////////////////////////////////////////////////////////////////////////
// NPCACT_STATES - This is the main function that drives NPC ACTIVITIES
//------------------------------------------------------------------------------
// By Deva Bryson Winblood.  04/27/2004   LAST MODIFIED: 05/14/2006
// Debugged & modified - Peak 05/10 special effects 6/04/10 thanks Narph
// fnReturnDestinationObject() rewritten 5/10 - Peak
// Gloaming time of day added - Peak 5/10
// Module nGNBStateSpeed added,  6/06/10
////////////////////////////////////////////////////////////////////////////////
// VARIABLES OF INTEREST USED IN THIS SCRIPT
//===========================================
// nGNBStateSpeed = delay in seconds before calling this script again(default=6)
// May be set on NPC or on module to affect all. If set on NPC, apawn-in places
// nGNBInherentStateSpeed on NPC, so _h_moving can vary it & it slowly reverts
// bGNBProfessions= variable used to monitor professions style library scripts
// oDest = Current destination object
// nGNBState = State of this script
// sGNBDTag = Destination tag for next destination
// nGNBLagMeth = Lag method
// bNPCACTPREPARSE = If true then waypoints will be preparsed
// nGNBRandomizeDelay = Amount in 10ths of a second max random amount to delay
// nGNBMoveSensitivity = range in 10ths of second to arrive at the destination (on NPC else on module)
// nGNBProcessing = Sentinel variable used to monitor the processing of this
//               script
// nGNBRun = Movement mode
// oGNBArrived = Destination arrived at most recently
// nGNBCloseMode = Mode for finding destinations
// bGNBStayInArea = if set to TRUE will cause NPC to only search for destinations
//               within the same area. If set on module, applies to all NPCs
// sGNBFailDestScript = Script to run if destination cannot be found
// bGNBLoadBalance = if set to 1 then NPCs will jump between waypoints when PCs
//                 are not present.
//
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
#include "npcactstackh"
/////////////////////
// PROTOTYPES
/////////////////////

// FILE: npcact_states      FUNCTION: fnImplementLagMethod4()
// This function will store the current health, and location of an NPC
// on the AREA it currently resides in.  When a PC enters the area any such
// NPCs will be restored to their prior location using a npcact_area_ent script.
void fnImplementLagMethod4();

// FILE: npcact_states      FUNCTION: fnReturnDestinationObject()
// This function when passed the destination parameters will return an
// object matching the criteria or OBJECT_INVALID if it could not find one.
object fnReturnDestinationObject(string sDestTag="");

// FILE: npcact_states      FUNCTION: fnCheckHoursOfOperation()
// This function will return TRUE if the hours of operation passed to the
// function indicates it is okay to do things at this time.
int fnCheckHoursOfOperation(string sHours);

/////////////////////////////////////////////////////////////////////// MAIN
void main()
{
  // begin variable declaration
  object oMe=OBJECT_SELF;
  int nGNBStateSpeed=GetLocalInt(oMe,"nGNBStateSpeed");
  if(!nGNBStateSpeed) nGNBStateSpeed=GetLocalInt(GetModule(),"nGNBStateSpeed"); // 6/06/10 Peak
  int bGNBProfessions=GetLocalInt(oMe,"bGNBProfessions");
  int nGNBProfProc;
  object oDest=GetLocalObject(oMe,"oDest");
  int nGNBState=GetLocalInt(oMe,"nGNBState");
  fnDebugInt("GNBState",nGNBState);
  int nN;
  int nStart;
  int nEnd;
  object oOb;
  string sS;
  string sName;
  float fF;
  string sS2;
  string sS3;
  string sSS;
  string sGNBDTag=GetLocalString(oMe,"sGNBDTag");
  int nLagMethod=GetLocalInt(oMe,"nGNBLagMeth");
  int bContinue=TRUE;
  int bOk;
  int bLoadBalance=GetLocalInt(GetModule(),"bGNBLoadBalance");
  int bPreParse=GetLocalInt(GetModule(),"bNPCACTPREPARSE");
  float fDelay=0.0;
  int nDelayVal=GetLocalInt(GetModule(),"nGNBRandomizeDelay");
  int nMoveSensitivity=GetLocalInt(GetModule(),"nGNBMoveSensitivity");
  float fMoveSensitivity;
  if (GetLocalInt(oMe,"nGNBMoveSensitivity")>0) nMoveSensitivity=GetLocalInt(oMe,"nGNBMoveSensitivity");
  if (nMoveSensitivity<1) nMoveSensitivity=10;
  fMoveSensitivity=IntToFloat(nMoveSensitivity)/10.0;
  // end variable declaration
  fnDebug(" [npcact_states]",TRUE);
  SetLocalInt(oMe,"nGNBProcessing",1); // set sentinel variable letting npcactivites6 know that processing still occurs
  if (nDelayVal>0)
  { // set random delay
    nDelayVal=Random(nDelayVal); // note: can be 0 delay - peak
    fDelay=IntToFloat(nDelayVal);
    fDelay=fDelay/10.0;
  } // set random delay
  if (fnGetIsBusy(oMe)==TRUE) bContinue=FALSE;
  if (nLagMethod==3&&GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oMe,1)==OBJECT_INVALID) bContinue=FALSE;
  if (nLagMethod==4&&GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oMe,1)==OBJECT_INVALID) fnImplementLagMethod4();
  if (bContinue)
  { // not busy
    fnDebug("",TRUE); // debug dump
    if (bGNBProfessions==TRUE)
    { // professions script is in control
      fnDebug("Professions is in control");
      nGNBProfProc=GetLocalInt(oMe,"nGNBProfProc");
      nN=GetLocalInt(oMe,"nGNBProfFail");
      fnDebugInt("States Prof monitor: ",nGNBProfProc);
      if (nN<1) nN=15;
      if (nGNBProfProc>nN)
      { // professions appears stuck let core activities take over again
        DeleteLocalInt(oMe,"bGNBProfessions");
        DeleteLocalInt(oMe,"nGNBProfProc");
        AssignCommand(oMe,ClearAllActions(TRUE));
      } // professions appears stuck let core activities take over again
      else
      { // professions seems to be still functional
        nGNBProfProc++;
        SetLocalInt(oMe,"nGNBProfProc",nGNBProfProc);
      } // professions seems to be still functional
    } // professions script is in control
    else
    { // let's process some information and handle the states----------
      switch(nGNBState)
      { // main state switch-------------------
        case 0: { // initialize this NPC for NPC ACTIVITIES
          if (oDest==OBJECT_INVALID)
          { // need to pick POST_ or NIGHT_
            fnDebug(" Pick POST_ or NIGHT_",TRUE);
            SetLocalString(oMe,"sGNBDTag","00");
          } // need to pick POST_ or NIGHT
          SetLocalInt(oMe,"nGNBState",1);
        } // intialize this NPC for NPC ACTIVITIES
        case 1: { // choose destination
          oDest=fnReturnDestinationObject(sGNBDTag);
          fnDebug("Choose Destination="+fnGetNPCTag(oDest),TRUE);
          if (oDest==OBJECT_INVALID) oDest=fnReturnDestinationObject(); // failsafe POST/NIGHT
          if (!GetIsObjectValid(oDest)&&GetStringLength(GetLocalString(GetModule(),"sGNBFailDestScript"))<2) fnDebug(GetTag(oMe)+" could not find destination '"+sGNBDTag+"'");
          else if (!GetIsObjectValid(oDest)) ExecuteScript(GetLocalString(GetModule(),"sGNBFailDestScript"),oMe);
          SetLocalObject(oMe,"oDest",oDest);
          DeleteLocalString(oMe,"sGNBDTag");
          SetLocalInt(oMe,"nGNBState",2);
        } // choose destination
        case 2: { // move to destination
          fnDebug(GetTag(oMe)+" move to destination.",TRUE);
          nN=0;
          if (bLoadBalance)
          { // load balance mode active
            oOb=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oMe,1);
            if (!GetIsObjectValid(oOb)) nN=1; // jump mode
          } // load balance mode active
          if (GetLocalInt(oMe,"nGNBRun")!=5&&nN!=1)
          { // !teleport
            DebugMove("Call fnMTD from State 2 no teleport");
            nN=fnMoveToDestination(oMe,oDest,fMoveSensitivity);
            if (nN!=1&&nN!=-1) SetLocalInt(oMe,"nGNBState",3);
            else if (nN==1) { SetLocalInt(oMe,"nGNBState",4); SetFacing(GetFacing(oDest)); fnDebug(GetTag(oMe)+" arrived.",TRUE); break; }
            else if (nN==-1) { AssignCommand(oMe,ClearAllActions()); SetLocalInt(oMe,"nGNBState",1);
              fnDebug(GetTag(oMe)+" could not reach destination.",TRUE); break; }
          } // !teleport
          else if (GetIsObjectValid(oDest))
          { // quick teleport
            AssignCommand(oMe,JumpToObject(oDest));
            DelayCommand(0.5,ClearAllActions(TRUE));
            DelayCommand(0.6,JumpToLocation(GetLocation(oDest)));
            SetLocalInt(oMe,"nGNBState",4);
            SetFacing(GetFacing(oDest));
            fnDebug(GetTag(oMe)+" arrived.",TRUE);
          } // quick teleport
          else
          {
            AssignCommand(oMe,SpeakString("I cannot reach my destination it is showing as an invalid object."));
          }
        } // move to destination
        case 3: { // wait for arrival at destination
         if (nGNBState==3)
         { // wait to get there
          fnDebug("Wait for arrival at destination.",TRUE);
          DebugMove("Call fnMTD from State 3");
          nN=fnMoveToDestination(oMe,oDest,fMoveSensitivity);
          if (nN==1)
          { // arrived
            SetLocalInt(oMe,"nGNBState",4);
            SetFacing(GetFacing(oDest));
            fnDebug(GetTag(oMe)+" arrived.",TRUE);
          } // arrived
          else if (nN==-1)
          { // can't arrive
            AssignCommand(oMe,ClearAllActions());
            SetLocalInt(oMe,"nGNBState",1);
            fnDebug(GetTag(oMe)+" could not reach destination.",TRUE);
          } // can't arrive
          else { fnDebug("Not there yet.",TRUE);
             break;
          }
         } // wait to get there
        } // wait for arrival at destination
        case 4: { // process waypoint
         if (nGNBState==4)
         { // process waypoint
          fnDebug("Process Waypoint",TRUE);
          SetLocalObject(oMe,"oGNBArrived",oDest);
          if (bPreParse==TRUE&&GetLocalInt(oDest,"bParsed")==TRUE)
          { // already parsed
            fnDebug("  ALREADY PARSED",TRUE);
            sS=GetLocalString(oDest,"sGNBDTag");
            SetLocalString(oMe,"sGNBDTag",sS);
            fF=GetLocalFloat(oDest,"fGNBPause");
            SetLocalFloat(oMe,"fGNBPause",fF);
            nN=GetLocalInt(oDest,"nGNBRun");
            SetLocalInt(oMe,"nGNBRun",nN);
            if (nN==8)
            { // special effects
              nN=GetLocalInt(oDest,"nGNBEDepart");
              SetLocalInt(oMe,"nGNBEDepart",nN);
              nN=GetLocalInt(oDest,"nGNBEAppear");
              SetLocalInt(oMe,"nGNBEAppear",nN);
            } // special effects
            sS=GetLocalString(oDest,"sGNBHours");
            SetLocalString(oMe,"sGNBHours",sS);
            nN=GetLocalInt(oDest,"nASMethod");
            SetLocalInt(oMe,"nASMethod",nN);
            sS=GetLocalString(oDest,"sAct");
            SetLocalString(oMe,"sAct",sS);
          } // already parsed
          else
          { // parse
            fnDebug("   PARSE",TRUE);
            sName=GetName(oDest); // grab waypoint name
            sS=fnParse(sName); // get destination
            fnDebug("     Destination:"+sS,TRUE);
            SetLocalString(oMe,"sGNBDTag",sS);
            if (bPreParse==TRUE) SetLocalString(oDest,"sGNBDTag",sS);
            sName=fnRemoveParsed(sName,sS);
            sS=fnParse(sName); // get pause duration
            fnDebug("     Pause Duration:"+sS,TRUE);
            nN=StringToInt(sS);
            fF=IntToFloat(nN);
            SetLocalFloat(oMe,"fGNBPause",fF);
            if (bPreParse==TRUE) SetLocalFloat(oDest,"fGNBPause",fF);
            sName=fnRemoveParsed(sName,sS);
            sS=fnParse(sName); // movement type
            sS=GetStringUpperCase(sS); // lower case accepted
            fnDebug("      Movement Type:"+sS,TRUE);
            nN=0; // walk
            fnDebug("===PARSE BEFORE IF:"+sS,TRUE);
            SetLocalInt(oMe,"nRun",FALSE);
            if (sS=="R") { nN=1; SetLocalInt(oMe,"nRun",TRUE); } // run
            else if (sS=="H") {nN=2;} // hide
            else if (sS=="S") { nN=3;} // search
            else if (sS=="C") { nN=4; } // search+hide
            else if (sS=="T") { nN=5; } // teleport
            else if (sS=="V") { nN=6; } // teleport w/ VFX
            else if (sS=="F") { nN=7; } // Fly out and back in
            else if (GetStringLeft(sS,1)=="E") // Effect Depart and arrive
            { // effect movement
              nN=8;
              sS2=GetStringRight(sS,GetStringLength(sS)-1);
              sS3=fnParse(sS2,"/");
              sS2=fnRemoveParsed(sS2,sS3,"/");
              SetLocalInt(oMe,"nGNBEDepart",StringToInt(sS3));
              SetLocalInt(oMe,"nGNBEAppear",StringToInt(sS2));
              if (bPreParse==TRUE)
              {
                SetLocalInt(oDest,"nGNBEDepart",StringToInt(sS3));
                SetLocalInt(oDest,"nGNBEAppear",StringToInt(sS2));
              }
            } // effect movement
            fnDebug("==PARSER MOVEMENT==:"+sS+" nGNBRun="+IntToString(nN),TRUE);
            SetLocalInt(oMe,"nGNBRun",nN);
            if (bPreParse==TRUE) SetLocalInt(oDest,"nGNBRun",nN);
            sName=fnRemoveParsed(sName,sS);
            sS=fnParse(sName); // hours of operation
            SetLocalString(oMe,"sGNBHours",sS);
            if (bPreParse==TRUE) SetLocalString(oDest,"sGNBHours",sS);
            sName=fnRemoveParsed(sName,sS);
            sS=fnParse(sName); // anti-stuck method @@@ opportunity
            sName=fnRemoveParsed(sName,sS); // remainder is actions
            nN=0;
            if (sS=="P") nN=1;
            else if (sS=="N") nN=2;
            else if (sS=="Q") nN=3;
            else if (sS=="S") nN=4;
            else if (sS=="L") nN=5;
            SetLocalInt(oMe,"nASMethod",nN);
            if (bPreParse==TRUE) SetLocalInt(oDest,"nASMethod",nN);
            SetLocalString(oMe,"sAct",sName);
            if (bPreParse==TRUE) SetLocalString(oDest,"sAct",sName);
            if (bPreParse==TRUE) SetLocalInt(oDest,"bParsed",TRUE);
          } // parse
          bOk=TRUE;
          // test for hours
          sS=GetLocalString(oMe,"sGNBHours");
          sS=GetStringUpperCase(sS);
          if (sS=="N"&&GetIsNight()==FALSE) bOk=FALSE;
          else if (sS=="D"&&GetIsDay()==FALSE) bOk=FALSE;
          else if (sS=="U"&&GetIsDusk()==FALSE) bOk=FALSE;
          else if (sS=="W"&&GetIsDawn()==FALSE) bOk=FALSE;
          else if (sS=="G"&&(!GetIsDawn()&&!GetIsDusk())) bOk=FALSE; // new Gloaming for sunrise/sunset activities - peak 5/10
          else if (GetStringLeft(sS,1)=="S")
          { // specific time
            sS=GetStringRight(sS,GetStringLength(sS)-1);
            nN=1;
            sS2="";
            sS3="";
            while(GetStringLength(sS)>0)
            { // parse
              sSS=GetStringLeft(sS,1);
              if (sSS!="T")
              { // found cut off point
                sS=GetStringRight(sS,GetStringLength(sS)-2);
                nN++;
              } // found cut off point
              else
              { // part
                if (nN==1) sS2=sS2+sSS;
                else { sS3=sS3+sSS; }
                sS=GetStringRight(sS,GetStringLength(sS)-1);
              } // part
            } // parse
            nStart=StringToInt(sS2);
            nEnd=StringToInt(sS2);
            nN=GetTimeHour();
            if (nStart<=nEnd)
            { // valid
             if (nN>=nStart&&nN<=nEnd) bOk=TRUE;
             else { bOk=FALSE; }
            } // valid
            else
            { // use start
              if (nN!=nStart) bOk=FALSE;
            } // use start
          } // specific time
          if (bOk)
          { // hours of operation okay
           SetLocalInt(oMe,"nGNBState",5);
          } // hours of operation okay
          else
          { // move
            SetLocalInt(oMe,"nGNBState",1);
          } // move
         } // process waypoint
        } // process waypoint
        case 5: { // interpret command
         if (nGNBState==5)
         { // interpret command
          sS=GetLocalString(oMe,"sAct");
          fnDebug(GetTag(oMe)+" interpret command '"+sS+"'",TRUE);
          if (GetStringLength(sS)>0&&fnCheckHoursOfOperation(GetLocalString(oMe,"sGNBHours")))
          { // there are commands and the hours of operation are okay
            SetLocalInt(oMe,"nGNBState",6);
            if (GetWaypointByTag("NPCACT_INTERP_FULL")!=OBJECT_INVALID||GetLocalInt(oMe,"NPCACT_INTERP_FULL")==TRUE)
            { // FULL INTERPRETER
              ExecuteScript("npcact_interp",oMe);
            } // FULL INTERPRETER
            else
            { // LITE INTERPRETER
              ExecuteScript("npcact_lite",oMe);
            } // LITE INTERPRETER
          } // there are commands and the hours of operation are okay
          else
          { // something is off
            if (GetLocalFloat(oMe,"fGNBPause")>0.0)
            { // pause
              SetLocalInt(oMe,"nGNBState",7);
              DelayCommand(GetLocalFloat(oMe,"fGNBPause"),SetLocalInt(oMe,"nGNBState",1));
            } // pause
            else
            { // done with this waypoint
              SetLocalInt(oMe,"nGNBState",1);
            } // done with this waypoint
          } // something is off
         } // interpret command
        } // interpret command
        case 6: { // wait for command to complete
          fnDebug("Wait for command to complete.",TRUE);
          break;
        } // wait for command to complete. No internal failsafe.
        case 7: { // pause before next waypoint
          fnDebug("Pause before next waypoint.",TRUE);
          break;
        } // pause before next waypoint
        default: {DeleteLocalInt(oMe,"nGNBState"); break; }
      } // main state switch-------------------
    } // let's process some information and handle the states----------
  } // not busy
  else {
    fnDebug("I am BUSY!",TRUE);
  }
  // begin cleanup
  // end cleanup
  // decay State Speed to Inherent State Speed - Peak 6/10/10
  nN=GetLocalInt(oMe,"nPKInherentStateSpeed");
  if(nN<1) nN=GetLocalInt(GetModule(),"nGNBStateSpeed");
  if(nGNBStateSpeed!=nN)
    if(nGNBStateSpeed>nN) SetLocalInt(oMe,"nGNBStateSpeed",nGNBStateSpeed-1);
    else SetLocalInt(oMe,"nGNBStateSpeed",nGNBStateSpeed+1);
  // call self
  if (nGNBStateSpeed<1) nGNBStateSpeed=6;
  if (nLagMethod==1) nGNBStateSpeed=nGNBStateSpeed*2;
  else if (nLagMethod==2) nGNBStateSpeed=nGNBStateSpeed*4;
  fnDebug("Delay call to next states="+IntToString(nGNBStateSpeed)+" nGNBState="+IntToString(nGNBState)+" nGNBDisabled="+IntToString(GetLocalInt(OBJECT_SELF,"nGNBDisabled")),TRUE);
  DelayCommand(IntToFloat(nGNBStateSpeed)+fDelay,ExecuteScript("npcact_states",oMe));
}
/////////////////////////////////////////////////////////////////////// MAIN

/////////////////////
// FUNCTIONS
/////////////////////
int fnCheckHoursOfOperation(string sHours) //returns T/F
{ // PURPOSE: Check to see if it is okay to process commands at this time
  // LAST MODIFIED BY: Deva Bryson Winblood   04/30/2004
  // corrected peak 5/10 added Gloaming 6/04/10
  int bRet=TRUE;
  string sStart;
  string sEnd;
  int nCur;
  sHours=GetStringUpperCase(sHours);
  if (sHours!="A")
  { // !Any
    if (sHours=="N"&&GetIsNight()==FALSE) bRet=FALSE;
    else if (sHours=="D"&&GetIsDay()==FALSE) bRet=FALSE;
    else if (sHours=="U"&&GetIsDusk()==FALSE) bRet=FALSE;
    else if (sHours=="W"&&GetIsDawn()==FALSE) bRet=FALSE;
    else if ((sHours=="G")&&(!GetIsDawn()&&!GetIsDusk())) bRet=FALSE; // new Gloaming for sunrise/sunset activities - peak 5/10
    else if (GetStringLeft(sHours,1)=="S")
    { // specific hours
      nCur=GetTimeHour();
      sHours=GetStringRight(sHours,GetStringLength(sHours)-1);
      sEnd=GetStringRight(sHours,2);
      sStart=GetStringLeft(sHours,2);
      if (nCur<StringToInt(sStart)||nCur>StringToInt(sEnd)) bRet=FALSE;
    } // specific hours
  } // !Any
  return bRet;
} // fnCheckHoursOfOperation()

/*object fnReturnDestinationObject(string sDestTag="") //returns oWP
/* extracts from 6.0 documentation:
## = # of next waypoint, from 00 to 99 (00 = POST or NIGHT depending on time of day)
R## = Random waypoint from 01 to ## (so POST/NIGHT is never chosen)
B#### = Bounded Random from ## to ## (e.g. 0010 = from 00 to 10) modPeak so POST can be in random mix
C_choice1/choice2/choice3 = Choose from a random choice of destinations:
  C_01/15/26 or C_SPECIFIC_WAYPOINT/R05/B0510
S<tag>_00 = Return to a shared waypoint POST_<tag> or NIGHT_<tag>
S<tag>_## = Go to Shared waypoint WP_<tag>_## or WN_<tag>_##
S<tag>_R## = Shared Random Waypoint
S<tag>_B#### = Shared Bounded Random Waypoint
S<tag>  = Shared Specific waypoint e.g. SSchool
 nGNBCloseMode variable on NPC, overridden by bGNBStayInArea on module (priority) or NPC:
 =0:NPC will seek waypoint specified anywhere in the module.
 =1:NPC will seek specified waypoint in same area currently in first.  If not
     found it will then look for it in the entire module.
 =2:NPC will ONLY seek specified waypoint in the same area they are
     currently in.  [Scripters' note: GetNearestObjectByTag searches area only;
     GetNearestObject searches module.]*/

object fnReturnDestinationObject(string sDestTag="") //returns oWP
  // PURPOSE: to return an object matching the sDestTag criteria
  // LAST MODIFIED BY: Deva Bryson Winblood  04/30/2004
  // corrected Obi-Won peak 5/26/09
  // rewritten by peak (Peter D. Busby) 5/10
{
  object oMe=OBJECT_SELF;
  object oWP=OBJECT_INVALID;
  fnDebug("fnReturnDestinationObject("+sDestTag+");",TRUE);
  string sTargetTag=GetStringRight(sDestTag,2);; // default target
  string sS;
  string sParse;
  int bSharedFlag=FALSE;
  string sL1=GetStringLeft(sDestTag,1);
  string sTag=fnGetNPCTag(oMe); //user
  if (sL1=="S")
  { //shared S<tag>_...
    fnDebug("   Shared waypoint",TRUE);
    sS=GetStringRight(sDestTag,GetStringLength(sDestTag)-1);
    sTag=fnParse(sS,"_");
    sDestTag=fnRemoveParsed(sS,sTag,"_");
    bSharedFlag=TRUE;
  } //shared
  int nNum;
  int nStart;
  int nEnd;
  int nNear=GetLocalInt(oMe,"nGNBCloseMode");
  int bStayInArea=GetLocalInt(GetModule(),"bGNBStayInArea");
  if (!bStayInArea) bStayInArea=GetLocalInt(oMe,"bGNBStayInArea");
  if (bStayInArea) nNear=2;
  // variables set
  if (GetStringLeft(sDestTag,2)=="C_")
  { // RANDOM CHOICE C_##/##/##
    nStart=0;
    sS=GetStringRight(sDestTag,GetStringLength(sDestTag)-2);
    sParse=fnParse(sS,"/");
    while(sS!="")
    { // parse and count
      if (sParse!="")
      { // choice found
        nStart++;
        SetLocalString(oMe,"sGNB_RC_"+IntToString(nStart),sParse);
      } // choice found
      sS=fnRemoveParsed(sS,sParse,"/");
      sParse=fnParse(sS,"/");
    } // parse and count
    if (nStart>0)
    { // choices were found
      nEnd=Random(nStart)+1;
      sS=GetLocalString(oMe,"sGNB_RC_"+IntToString(nEnd));
      // cleanup
      while(nStart>0)
      { // delete variables
        DeleteLocalString(oMe,"sGNB_RC_"+IntToString(nStart));
        nStart--;
      } // delete variables
    } // choices were found
    sDestTag=sS;
    sTargetTag=GetStringRight(sDestTag,2);; // default target
  } // random choice
  sL1=GetStringLeft(sDestTag,1);
  if (sL1=="B")
  { // bounded random waypoint B####
    sS=GetStringRight(sDestTag,GetStringLength(sDestTag)-1);
    sTargetTag=GetStringLeft(sS,2); // modPeak improper call default, if end=0 or end>start
    sS=GetStringRight(sS,2);
    nStart=StringToInt(sTargetTag);
    nEnd=StringToInt(sS);
    fnDebug("    Bounded Random:'"+sTargetTag+"' to '"+sS+"' ("+IntToString(nStart)+"->"+IntToString(nEnd)+")",TRUE);
    if (nEnd>0&&nEnd>nStart) // modified to allow 00 as first bound - allows random 00-##
    { // bounded random
      nNum=nEnd-nStart+1;
      nNum=Random(nNum)+nStart;
      sTargetTag=IntToString(nNum);
    } // bounded random
  } // bounded random waypoint
  else if (sL1=="R")
  { // random waypoint R##
    sTargetTag=GetStringRight(sDestTag,GetStringLength(sDestTag)-1); // modPeak failsafe: R00=POST/NIGHT
    nNum=StringToInt(sTargetTag);
    if (nNum>0) nNum=Random(nNum)+1;
    sTargetTag=IntToString(nNum); // so R## never selects 00 [POST/NIGHT]
  } // random waypoint
  fnDebug("  Waypoint BreakDown:sTag="+sTag+", sTargetTag="+sTargetTag);
  sS=sTargetTag;
  if (sS==""||sS=="00"||sS=="0")
  { // POST_ or NIGHT_
    if (GetIsNight()==TRUE)
    {
      if (nNear==1||nNear==2) oWP=GetNearestObjectByTag("NIGHT_"+sTag);
      if (nNear==0||(nNear==1&&oWP==OBJECT_INVALID)) oWP=GetObjectByTag("NIGHT_"+sTag);
    }
    if (oWP==OBJECT_INVALID)
    {
      if (nNear==1||nNear==2) oWP=GetNearestObjectByTag("POST_"+sTag);
      if (nNear==0||(nNear==1&&oWP==OBJECT_INVALID)) oWP=GetObjectByTag("POST_"+sTag);
    }
  } // POST_ or NIGHT_
  else if (StringToInt(sS)>0)
  { // numbered waypoint
    if (GetIsNight()==TRUE)
    { // night
      if (nNear==1||nNear==2) oWP=GetNearestObjectByTag("WN_"+sTag+"_"+fnPadTheNum(StringToInt(sS)));
      if (nNear==0||(nNear==1&&oWP==OBJECT_INVALID)) oWP=GetObjectByTag("WN_"+sTag+"_"+fnPadTheNum(StringToInt(sS)));
    } // night
    if (oWP==OBJECT_INVALID)
    { // day and other
      if (nNear==1||nNear==2) oWP=GetNearestObjectByTag("WP_"+sTag+"_"+fnPadTheNum(StringToInt(sS)));
      if (nNear==0||(nNear==1&&oWP==OBJECT_INVALID)) oWP=GetObjectByTag("WP_"+sTag+"_"+fnPadTheNum(StringToInt(sS)));
    } // day and other
  } // numbered waypoint
  if (bSharedFlag&&(sS==sTag||GetIsObjectValid(GetWaypointByTag(sS))))
  { // specific tag e.g. "school" or "school_01", backwards compat
    if (nNear==1||nNear==2) oWP=GetNearestObjectByTag(sS);
    if (nNear==0||(nNear==1&&oWP==OBJECT_INVALID)) oWP=GetObjectByTag(sS);
  } // specific tag
fnDebug("fnRDO returns "+GetTag(oWP)+" "+GetName(oWP));
  return oWP;
} // fnReturnDestinationObject()

void fnAddMeToAreaStack(string sRes,int nCHP,object oNPC)
{ // PURPOSE: Add the NPC to the area's stack for LAG4
  // LAST MODIFIED BY: Deva Bryson Winblood 06/22/2004
  struct StackHeader stStack=fnGetLocalStack("stLAG4");
  stStack=fnPushStack(stStack,sRes+"/"+IntToString(nCHP));
  fnSetLocalStack(stStack);
  if (DEBUG_NPCACT_ON) SendMessageToPC(GetFirstPC(),"  PUSHED onto LAG4 stack "+sRes+"/"+IntToString(nCHP)+" for area '"+GetName(OBJECT_SELF)+"'");
  DelayCommand(1.0,DestroyObject(oNPC));
} // fnAddMeToAreaStack()

void fnImplementLagMethod4()
{ // PURPOSE: To store NPCs via limited information when no PCs are present
  // LAST MODIFIED BY: Deva Bryson Winblood   06/22/2004
  object oMe=OBJECT_SELF;
  object oArea=GetArea(oMe);
  int nCHP=GetCurrentHitPoints(oMe);
  fnDebug("LAG4 MODE IMPLEMENTED-Sending me away");
  AssignCommand(oArea,fnAddMeToAreaStack(GetResRef(oMe),nCHP,oMe));
} // fnImplementLagMethod4()
