void main()
{
    // We're editing the PC!
    object oUnit = GetPCSpeaker();
    SetLocalObject(OBJECT_SELF,"editunit",oUnit);

    // Remember their current appearance, so it can be restored if they change their mind
    SetLocalInt(oUnit,"mirror_head",GetCreatureBodyPart(CREATURE_PART_HEAD,oUnit));
    SetLocalInt(oUnit,"mirror_hair",GetColor(oUnit,COLOR_CHANNEL_HAIR));
    SetLocalInt(oUnit,"mirror_skin",GetColor(oUnit,COLOR_CHANNEL_SKIN));
    SetLocalInt(oUnit,"mirror_tail",GetCreatureTailType(oUnit));
    SetLocalInt(oUnit,"mirror_wing",GetCreatureWingType(oUnit));
    SetLocalInt(oUnit,"mirror_phys",GetPhenoType(oUnit));
}
