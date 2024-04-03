void main()
{
    object oNPC=OBJECT_SELF;
    SetLocalInt(oNPC,"noheart",1);
    AssignCommand(oNPC, ActionSpeakString("STOP!", TALKVOLUME_SHOUT));
    AssignCommand(oNPC,ActionDoCommand(ClearAllActions(FALSE)));
    AssignCommand(oNPC,ClearAllActions(FALSE));
    DeleteLocalInt(oNPC,"nMASCount");
    DeleteLocalInt(oNPC,"nMASReset");
    DeleteLocalFloat(oNPC,"fMLastDist");
    DeleteLocalInt(oNPC,"nCurrMState");
    DeleteLocalInt(oNPC,"nFinalMState");
    DeleteLocalObject(oNPC,"oFinalDest");
    DeleteLocalObject(oNPC,"oCurrDest");
    SetLocalString(oNPC, "sGNBVirtualTag", "archer9");
    SetLocalString(oNPC,"sGNBDTag","archer9");
    SetLocalInt(oNPC,"nGNBState",0);
    AssignCommand(oNPC,ActionDoCommand(ClearAllActions(FALSE)));
    AssignCommand(oNPC,ClearAllActions(FALSE));
}
