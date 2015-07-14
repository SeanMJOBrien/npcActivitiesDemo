int StartingConditional()
{
    object oTarget=GetLocalObject(GetPCSpeaker(),"oDMTarget");
    if (GetLocalInt(oTarget,"nGNBDisabled")!=TRUE) return TRUE;
    return FALSE;
}
