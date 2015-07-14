// npcact_cms_tplac
int StartingConditional()
{
    object oPC=GetPCSpeaker();
    object oTarget=GetLocalObject(oPC,"oCMSTarget");
    if (GetObjectType(oTarget)==OBJECT_TYPE_PLACEABLE)
    { // test 1
      if (GetHasInventory(oTarget)) return TRUE;
    } // test 1
    return FALSE;
}
