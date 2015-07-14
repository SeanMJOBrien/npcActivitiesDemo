int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    // Start at 9 and count off every limb that has a tattoo or is missing
    int iTattoos = 9;

    if (GetCreatureBodyPart(CREATURE_PART_TORSO,oUnit)          == 1)   { iTattoos--; }
    if (GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,oUnit)     == 1)   { iTattoos--; }
    if (GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,oUnit)    == 1)   { iTattoos--; }
    if (GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,oUnit)   == 1)   { iTattoos--; }
    if (GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,oUnit)  == 1)   { iTattoos--; }
    if (GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,oUnit)     == 1)   { iTattoos--; }
    if (GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,oUnit)    == 1)   { iTattoos--; }
    if (GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,oUnit)      == 1)   { iTattoos--; }
    if (GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,oUnit)     == 1)   { iTattoos--; }

    if (iTattoos == 9)  return FALSE;
    else                return TRUE;
}
