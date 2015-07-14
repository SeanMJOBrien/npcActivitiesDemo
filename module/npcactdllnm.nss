/////////////////////////////////////////////////////////////////////////
// NPC ACTIVITIES 5.0 - MOVEMENT LIBRARY
// Version: 1.0
// Library name: NM
// Also used with NPC ACTIVITIES 6.0 but, did not require modification
//=======================================================================
// Author: Deva Bryson Winblood
// Date  : 02/19/2003
// modified for Virtual Tag peak 5/10
// added #7/nRate/nDur movement rate reduction
// added #8/nDur immunity to reduced movement rate
//=======================================================================
// This library handles movement commands that are time sensitive and will
// also be used to store any new movement commands that are added after the
// core command set has been frozen.
//////////////////////////////////////////////////////////////////////////
#include "npcactlibtoolh"
#include "npcactivitiesh"
// #Parm1   FUNCTION                   PARAMETERS
//------------------------------------------------------------------------
// 1        Walk circuit with no pause Start Point, End Point
// 2        Run circuit with no pause  Start Point, End Point
// 3        Walk Circuit # times       Start, End, Number Circuits (0=infinite)
// 4        Run circuit # times        Start, End, Number Circuits (0=infinite)
// 5        Bizarre Random Walk        Duration in seconds
// 6        Bizarre Random Run         Duration in seconds
// 7        Reduced movement rate      Duration in seconds, 0=Permanent - peak 5/10
// 8        Immunity to Reduced rate   Duration in seconds, 0=Permanent - peak 5/10

///////////////////////////////// PROTOTYPES //////////////////////////////
void MoveAroundCircuit(int nStartP,int nEndP,int nMode=FALSE);
void LIB3and4(int nStart,int nEnd,int nTimes,int nRun=FALSE);
void LIB5and6(int nRun=FALSE);
void LIB7(int nRate, int nDur);
void LIB8(int nDur);

//=============================================[ M A I N ]=================
void main()
{
  string sParmIn=GetLocalString(OBJECT_SELF,"sLIBParm");
  DeleteLocalString(OBJECT_SELF,"sLIBParm");
  fnTokenizeParameters(sParmIn);
  int nArgC=GetLocalInt(OBJECT_SELF,"nArgc");
  string sParm;
  int nParm1;
  int nParm2;
  int nParm3;
  int nParm4;
  if (nArgC>0)
  { // parameters were passed
    SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE); // no interference
    sParm=GetLocalString(OBJECT_SELF,"sArgv1");
    nParm1=StringToInt(sParm);
    switch (nParm1)
    { // function call switch
      case 1: { // Walk circuit old style
       sParm=GetLocalString(OBJECT_SELF,"sArgv2");
       nParm2=StringToInt(sParm);
       sParm=GetLocalString(OBJECT_SELF,"sArgv3");
       nParm3=StringToInt(sParm);
       MoveAroundCircuit(nParm2,nParm3);
       ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
       break;
      } // walk Circuit old style
      case 2: { // Run circuit old style
       sParm=GetLocalString(OBJECT_SELF,"sArgv2");
       nParm2=StringToInt(sParm);
       sParm=GetLocalString(OBJECT_SELF,"sArgv3");
       nParm3=StringToInt(sParm);
       MoveAroundCircuit(nParm2,nParm3,TRUE);
       ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
       break;
      } // Run circuit old style
      case 3: { // Walk circuit # times
       sParm=GetLocalString(OBJECT_SELF,"sArgv2");
       nParm2=StringToInt(sParm);
       sParm=GetLocalString(OBJECT_SELF,"sArgv3");
       nParm3=StringToInt(sParm);
       sParm=GetLocalString(OBJECT_SELF,"sArgv4");
       nParm4=StringToInt(sParm);
       LIB3and4(nParm2,nParm3,nParm4);
       break;
      } // Walk circuit # times
      case 4: { // Run circuit # times
       sParm=GetLocalString(OBJECT_SELF,"sArgv2");
       nParm2=StringToInt(sParm);
       sParm=GetLocalString(OBJECT_SELF,"sArgv3");
       nParm3=StringToInt(sParm);
       sParm=GetLocalString(OBJECT_SELF,"sArgv4");
       nParm4=StringToInt(sParm);
       LIB3and4(nParm2,nParm3,nParm4,TRUE);
       break;
      } // Run circuit # times
      case 5: { // Bizarre Random Walk
       sParm=GetLocalString(OBJECT_SELF,"sArgv2");
       nParm2=StringToInt(sParm);
       DelayCommand(IntToFloat(nParm2)*1.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE)); // return control
       LIB5and6();
       break;
      } // Bizarre Random Walk
      case 6: { // Bizarre Random Run
       sParm=GetLocalString(OBJECT_SELF,"sArgv2");
       nParm2=StringToInt(sParm);
       DelayCommand(IntToFloat(nParm2)*1.0,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE)); // return control
       LIB5and6(TRUE);
       break;
      } // Bizarre Random Run
      case 7: { // Reduced movement rate
       sParm=GetLocalString(OBJECT_SELF,"sArgv2");
       nParm2=StringToInt(sParm);
       sParm=GetLocalString(OBJECT_SELF,"sArgv3");
       nParm3=StringToInt(sParm);
       DelayCommand(0.2,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE)); // return control
       LIB7(nParm2, nParm3);
       break;
      } // Bizarre Random Run
      case 8: { // Reduced movement rate
       sParm=GetLocalString(OBJECT_SELF,"sArgv2");
       nParm2=StringToInt(sParm);
       DelayCommand(0.2,SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE)); // return control
       LIB8(nParm3);
       break;
      } // Reduced movement rate
      default: { SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE); break; }
    } // function call switch
  } // parameters were passed
}
//=============================================[ M A I N ]=================


///////////////////////////////////////////////////////////////////
//                     F U N C T I O N S
///////////////////////////////////////////////////////////////////
void MoveAroundCircuit(int nStartP,int nEndP,int nMode=FALSE)
{ // MoveAroundCircuit (from the old npcactdllmove library)
  string sName="WP_"+fnGetNPCTag(OBJECT_SELF)+"_";  //mod for VT peak 5/10
  object oDest;
  string sTag;
  int nLoop=nStartP;
  //SendMessageToPC(GetFirstPC(),"DLL("+IntToString(nStartP)+","+IntToString(nEndP)+","+IntToString(nMode)+")");
  while(nLoop<nEndP+1)
  { // run circuit
    if(nLoop<10) sTag=sName+"0"+IntToString(nLoop);
    else sTag=sName+IntToString(nLoop);
    oDest=GetObjectByTag(sTag);
    if (oDest!=OBJECT_INVALID)
    { // !OI
     ActionForceMoveToObject(oDest,nMode,1.0,30.0);
    } // !OI
    nLoop++;
  } // run circuit
} // MoveAroundCircuit()

//------------------------------------------------------------------------
void LIB3and4(int nStart,int nEnd,int nTimes,int nRun=FALSE)
{ // Move around circuit nTimes 0 = infinite
  string sName="WP_"+fnGetNPCTag(OBJECT_SELF)+"_";   //mod for VT peak 5/10
  object oDest;
  string sTag;
  int nLoop=nStart;
  while (nLoop<nEnd+1)
  { // do circuit
    if (nLoop<10) sTag=sName+"0"+IntToString(nLoop);
    else sTag=sName+IntToString(nLoop);
    oDest=GetObjectByTag(sTag);
    if (oDest!=OBJECT_INVALID)
    { // !OI
      ActionForceMoveToObject(oDest,nRun,1.0,30.0);
    } // !OI
    nLoop++;
  } // do circuit
  if (nTimes==1)
  { // done- return control to NPC ACTIVITIES
     ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
  } // done- return control to NPC ACTIVITIES
  else if (nTimes>1)
  {
    ActionDoCommand(LIB3and4(nStart,nEnd,nTimes-1,nRun));
  }
  else // infinite
  {
    ActionDoCommand(LIB3and4(nStart,nEnd,nTimes,nRun));
  }
} // LIB3and4()

//-------------------------------------------------------------------------
void LIB5and6(int nRun=FALSE)
{ // Bizarre Random Walk/Run
  object oDest;
  float fRange;
  int nRnd;
  nRnd=d4();
  switch(nRnd)
  { // behavior
    case 1: { // do weird facing actions
     nRnd=Random(360);
     ActionDoCommand(SetFacing(IntToFloat(nRnd)));
     ActionWait(0.5);
     nRnd=Random(360);
     ActionDoCommand(SetFacing(IntToFloat(nRnd)));
     ActionWait(0.5);
     nRnd=Random(360);
     ActionDoCommand(SetFacing(IntToFloat(nRnd)));
     ActionWait(0.5);
     break;
    } // do weird facing actions
    default: { // move towards location
     nRnd=d10();
     oDest=GetNearestObject(OBJECT_TYPE_ALL,OBJECT_SELF,nRnd);
     if (oDest!=OBJECT_INVALID)
     { // find object
       fRange=GetDistanceBetween(OBJECT_SELF,oDest);
       nRnd=Random(FloatToInt(fRange))+1;
       fRange=IntToFloat(nRnd)+0.5;
       ActionMoveToObject(oDest,nRun,fRange);
     } // find object
     break;
    } // move towards location
  } // behavior
  ActionDoCommand(LIB5and6(nRun)); // recursion until NPC activities takes over
} // LIB5and6()

void LIB7(int nRate, int nDur)
{ // Reduced movement rate
  // This is the Object to apply the effect to.
  object oTarget = OBJECT_SELF;
  // Create the effect to apply
  effect eSlowDown = EffectMovementSpeedDecrease(nRate);
  // Apply the effect to the object
  if(nDur=0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlowDown, oTarget);
  else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlowDown, oTarget, IntToFloat(nDur*10));
}// LIB7

void LIB8(int nDur)
{ // Immunity to reduced movement rate
  // This is the Object to apply the effect to.
  object oTarget = OBJECT_SELF;
  // Create the effect to apply
  effect eImmunity = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
  // Apply the effect to the object
  if(nDur=0) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmunity, oTarget);
  else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmunity, oTarget, IntToFloat(nDur*10));
}// LIB7

