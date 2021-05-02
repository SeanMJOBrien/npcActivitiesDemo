void main()
{
    object oNPC = OBJECT_SELF;
    DeleteLocalInt(oNPC,"nMASCount");
    DeleteLocalInt(oNPC,"nMASReset");
    DeleteLocalFloat(oNPC,"fMLastDist");
    DeleteLocalInt(oNPC,"nCurrMState");
    DeleteLocalInt(oNPC,"nFinalMState");
    DeleteLocalObject(oNPC,"oFinalDest");
    DeleteLocalObject(oNPC,"oCurrDest");
    SetLocalInt(oNPC,"nGNBState",0);
    AssignCommand(oNPC,ActionDoCommand(ClearAllActions(FALSE)));
    AssignCommand(oNPC,ClearAllActions(FALSE));
    ActionForceFollowObject(GetPCSpeaker(),5.0f);
}
