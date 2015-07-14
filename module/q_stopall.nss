/* Qlippoth - Current behavior:
1. Delay (longer than heartbeat), where the creature will continue their pathway.
2. Usually, after several to 15 second the creature will head towards an ADD
and start pathing back to their new vTag assignment.

??? HOW do we halt the NPC, reinitialize the new vTag/pathway and get them going
again mthe most efficiently???

I THINK I need to cause a PAUSE (fnPAUSE??) to halt the creatures "progress"
which I think continues even if the creature is stopped.
Add to the start of the convo? Needs to be x fF seconds?

Have time limit for NPCs in convo, if after 30 second or 60 no thing is going on
close convo and continue on their way.

IS ther a setting to turn off this anti-stuck code so that they don't "continue"
while stopped in dialog? */

// Default test script, compare to "assigntagfoe" (control test script).

#include "npcactlibtoolh"

void main()
{
    object oNPC = OBJECT_SELF;
    AssignCommand(oNPC,ClearAllActions());
    DeleteLocalInt(oNPC,"nMASCount");
    DeleteLocalInt(oNPC,"nMASReset");
    DeleteLocalFloat(oNPC,"fMLastDist");
    DeleteLocalInt(oNPC,"nCurrMState");
    DeleteLocalInt(oNPC,"nFinalMState");
    DeleteLocalObject(oNPC,"oFinalDest");
    DeleteLocalObject(oNPC,"oCurrDest");
    AssignCommand(oNPC,ClearAllActions());
    DLL_CompleteActions(oNPC);
    SetLocalString(oNPC, "sGNBVirtualTag", "guardcastle");
    SetLocalString(oNPC,"sGNBDTag","guardcastle");
    SetLocalInt(oNPC,"nGNBState",0);
    AssignCommand(oNPC,ActionDoCommand(ClearAllActions(FALSE)));
    AssignCommand(oNPC,ClearAllActions(FALSE));
}
