void main()
{
    object oUnit = GetPCSpeaker();

    // Remember their current appearance, so it can be restored if they change their mind
    SetCreatureBodyPart(CREATURE_PART_HEAD,GetLocalInt(oUnit,"mirror_head"),oUnit);
    SetColor(oUnit,COLOR_CHANNEL_HAIR,GetLocalInt(oUnit,"mirror_hair"));
    SetColor(oUnit,COLOR_CHANNEL_SKIN,GetLocalInt(oUnit,"mirror_skin"));
    SetCreatureTailType(GetLocalInt(oUnit,"mirror_tail"),oUnit);
    SetCreatureWingType(GetLocalInt(oUnit,"mirror_wing"),oUnit);
    SetPhenoType(GetLocalInt(oUnit,"mirror_phys"),oUnit);
}
