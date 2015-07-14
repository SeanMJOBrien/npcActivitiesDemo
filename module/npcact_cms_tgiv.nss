// npcact_cms_tgiv
int StartingConditional()
{
    object oPC=GetPCSpeaker();
    object oTarget=GetLocalObject(oPC,"oCMSTarget");
    if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE||GetIsPC(oTarget))
    { // test 1
      if (oTarget!=oPC) return TRUE;
    } // test 1
    return FALSE;
}
