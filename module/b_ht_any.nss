int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    // Count how many tattoos the unit has
    int iTattoos = 0;

    if (GetCreatureBodyPart(CREATURE_PART_TORSO,oUnit)          == 2)   { iTattoos++; }
    if (GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,oUnit)     == 2)   { iTattoos++; }
    if (GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,oUnit)    == 2)   { iTattoos++; }
    if (GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,oUnit)   == 2)   { iTattoos++; }
    if (GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,oUnit)  == 2)   { iTattoos++; }
    if (GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,oUnit)     == 2)   { iTattoos++; }
    if (GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,oUnit)    == 2)   { iTattoos++; }
    if (GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,oUnit)      == 2)   { iTattoos++; }
    if (GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,oUnit)     == 2)   { iTattoos++; }

    if (iTattoos > 0)   return TRUE;
    else                return FALSE;
}
