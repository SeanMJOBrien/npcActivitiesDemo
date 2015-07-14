//::///////////////////////////////////////////////
//:: Name NPCACTDLLMOVE
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Deva Bryson Winblood
//:: Created On: 10/24/2002
//:://////////////////////////////////////////////

// NPC ACTIVITIES Link Library
// nParm = Library function to call
// nParm1 = variable passed to function
// nParm2 = variable passed to function

// LIBRARY COMMANDS
// # = COMMAND
// 1 = walk circuit with no pause from nParm1 waypoint # to nParm2
// 2 = run circuit with no pause

/* NOTICE:  This library is included only for backwards compatibility
   the new npcactdllnm library replaces this one and has more features */


////////////////////////////////// FUNCTIONS //////////////////////////////
void MoveAroundCircuit(int nStartP,int nEndP,int nMode=FALSE)
{ // MoveAroundCircuit
  string sName="WP_"+GetTag(OBJECT_SELF)+"_";
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


///////////////////////////// MAIN ////////////////////////////////////////
void main()
{
  int nParm=GetLocalInt(OBJECT_SELF,"nParm");
  int nParm1=GetLocalInt(OBJECT_SELF,"nParm1");
  int nParm2=GetLocalInt(OBJECT_SELF,"nParm2");
  string sParm=GetLocalString(OBJECT_SELF,"sLIBParm");
  if (GetStringLength(sParm)>0)
  {
    SendMessageToPC(GetFirstPC(),"ERROR: npcactdllmove - is not yet converted to use with the # lib call");
    DeleteLocalString(OBJECT_SELF,"sLIBParm");
  }
  SetLocalInt(OBJECT_SELF,"nGNBDisabled",TRUE);
  SetLocalInt(OBJECT_SELF,"nGNBMaxHB",1);
  //SendMessageToPC(GetFirstPC(),"======NPCACTDLLMOVE===:"+IntToString(nParm));
  // call functions here
  switch(nParm)
  { // switch
    case 1: MoveAroundCircuit(nParm1,nParm2); break;
    case 2: MoveAroundCircuit(nParm1,nParm2,TRUE); break;
    default: break;
  } // switch
  // end call functions
  ActionDoCommand(SetLocalInt(OBJECT_SELF,"nGNBDisabled",FALSE));
}
