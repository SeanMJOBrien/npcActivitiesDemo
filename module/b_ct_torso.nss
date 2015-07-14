void main()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    // Add a tatto to the appropriate body part
    SetCreatureBodyPart(CREATURE_PART_TORSO, 2, oUnit);
}
