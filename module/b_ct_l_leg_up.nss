void main()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    // Add a tatto to the appropriate body part
    SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, 2, oUnit);
}