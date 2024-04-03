void main()
{
    object oNPC=OBJECT_SELF;
    SetLocalInt(oNPC,"noheart",0);
    AssignCommand(oNPC, ActionSpeakString("GO!", TALKVOLUME_SHOUT));
    AssignCommand(oNPC,ActionDoCommand(ClearAllActions(FALSE)));
    AssignCommand(oNPC,ClearAllActions(FALSE));
}
