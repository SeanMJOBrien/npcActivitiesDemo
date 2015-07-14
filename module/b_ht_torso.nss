int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    if (GetCreatureBodyPart(CREATURE_PART_TORSO,oUnit) == 2)
        return TRUE;
    else
        return FALSE;
}
