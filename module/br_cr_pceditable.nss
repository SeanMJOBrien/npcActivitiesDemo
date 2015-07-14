int StartingConditional()
{
    object oUnit = GetPCSpeaker();

    int iRace = GetRacialType(oUnit);

    if (iRace == RACIAL_TYPE_DWARF
     || iRace == RACIAL_TYPE_ELF
     || iRace == RACIAL_TYPE_GNOME
     || iRace == RACIAL_TYPE_HALFELF
     || iRace == RACIAL_TYPE_HALFLING
     || iRace == RACIAL_TYPE_HALFORC
     || iRace == RACIAL_TYPE_HUMAN)
        return TRUE;

    return FALSE;
}
