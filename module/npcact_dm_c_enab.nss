int StartingConditional()
{
    object oTarget=GetLocalObject(GetPCSpeaker(),"oDMTarget");
    if (GetLocalInt(oTarget,"nGNBDisabled")!=FALSE) return TRUE;
    return FALSE;
}
