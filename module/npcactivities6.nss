////////////////////////////////////////////////////////////////////////////////
// NPCACTIVITIES6 - Main heartbeat routine called by npcact_wrap1
//------------------------------------------------------------------------------
// By Deva Bryson Winblood.  04/27/2004
////////////////////////////////////////////////////////////////////////////////
// This simple script has a single purpose.  It will initially fire off the state
// process.  It will then monitor the nGNBProcessing variable and if it ever
// exceeds 20 it will know that npcact_states has failed to execute for awhile
// and it will fire it off again.  The number 20 is chosen because, the largest
// pause in NPC ACTIVITIES at a waypoint is 99 seconds which is approximately
// 16.5 heartbeats so, given a little flex room if npcact_states has not fired
// within 20 heartbeats there is probably a problem and this heartbeat script
// will kick start the process.
#include "npcactivitiesh"

void main()
{
    object oMe=OBJECT_SELF; // handle to NPC
    int nGNBProcessing=GetLocalInt(oMe,"nGNBProcessing");
    //SendMessageToPC(GetFirstPC(),"["+GetTag(oMe)+"] nGNBProcessing:"+IntToString(nGNBProcessing));
    if (GetLocalInt(GetModule(),"bNPCACTREPORT")!=TRUE)
    { // print to log the version of NPC ACTIVITIES
      SetLocalInt(GetModule(),"bNPCACTREPORT",TRUE);
      PrintString("+---------------------------------------+");
      PrintString("| This module is running NPC ACTIVITIES |");
      PrintString("|        By Deva Bryson Winblood.       |");
      PrintString("+--maintained by Peak (Peter D Busby)---+");
      PrintString("              [VERSION:"+NPCACT_VERSION+"]              ");
      PrintString("+---------------------------------------+");
      PrintString("| If you have not voted for this script |");
      PrintString("| please do so.  If you vote negatively |");
      PrintString("| please include comments to help me fix|");
      PrintString("| the script.   Thank you, Peter Busby  |");
      PrintString("+---------------------------------------+");
    } // print to log the version of NPC ACTIVITIES
    if (nGNBProcessing==0||nGNBProcessing>20)
    { // fire off the states script
      fnDebug(GetTag(oMe)+" [npcactivities6] fired npcact_states",TRUE);
      DelayCommand(0.1,ExecuteScript("npcact_states",oMe));
    } // fire off the states script
    nGNBProcessing++;
    SetLocalInt(oMe,"nGNBProcessing",nGNBProcessing);
}
