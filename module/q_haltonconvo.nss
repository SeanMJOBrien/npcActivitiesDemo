void main()
{
    object oNPC = OBJECT_SELF;
    AssignCommand(oNPC,ClearAllActions());
    SetLocalFloat(oNPC,"fGNBPause",0.0);
}
