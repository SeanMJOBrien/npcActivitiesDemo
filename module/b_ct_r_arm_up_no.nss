void main()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    // Add a tatto to the appropriate body part
    SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, 1, oUnit);
}
