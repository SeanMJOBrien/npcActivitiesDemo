// npcact_cms_tloc
int StartingConditional()
{
    object oTarget=GetLocalObject(GetPCSpeaker(),"oCMSTarget");
    int nOT=GetObjectType(oTarget);
    if (nOT!=OBJECT_TYPE_CREATURE&&nOT!=OBJECT_TYPE_ITEM&&nOT!=OBJECT_TYPE_PLACEABLE&&nOT!=OBJECT_TYPE_DOOR) return TRUE;
    return FALSE;
}
