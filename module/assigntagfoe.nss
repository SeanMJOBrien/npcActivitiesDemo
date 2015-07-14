/* Qlippoth - Current behavior:
1. Delay (longer than heartbeat), where the creature will continue their pathway.
2. Usually, after several to 15 second the creature will head towards an ADD
and start pathing back to their new vTag assignment.

3. Seems that the creature WILL start towards the nearest ADD, but then some
heartbeat overrides it and they continue for a ways, THEN come to their senses
and approach the ADD as expected.

??? HOW do we halt the NPC, reinitialize the new vTag/pathway and get them going
again mthe most efficiently??? */

// CONTROL test script, compare against test in prgress script "q_stopall"

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
    SetLocalString(oNPC, "sGNBVirtualTag", "foe");
    SetLocalString(oNPC,"sGNBDTag","foe");
    SetLocalInt(oNPC,"nGNBState",0);
    AssignCommand(oNPC,ActionDoCommand(ClearAllActions(FALSE)));
    AssignCommand(oNPC,ClearAllActions(FALSE));
}
