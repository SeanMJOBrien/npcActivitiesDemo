/*   Script generated by
Lilac Soul's NWN Script Generator, v. 2.3

For download info, please visit:
http://nwvault.ign.com/View.php?view=Other.Detail&id=4683&id=625    */

//Put this on action taken in the conversation editor
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
    SetLocalString(oNPC, "sGNBVirtualTag", "archer8");
    SetLocalString(oNPC,"sGNBDTag","archer8");
    SetLocalInt(oNPC,"nGNBState",0);
    AssignCommand(oNPC,ActionDoCommand(ClearAllActions(FALSE)));
    AssignCommand(oNPC,ClearAllActions(FALSE));
}
