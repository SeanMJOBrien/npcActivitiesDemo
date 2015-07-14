void main()
{
    object oUnit = GetPCSpeaker();

    // Remove local ints
    DeleteLocalInt(oUnit,"mirror_head");
    DeleteLocalInt(oUnit,"mirror_hair");
    DeleteLocalInt(oUnit,"mirror_skin");
    DeleteLocalInt(oUnit,"mirror_tail");
    DeleteLocalInt(oUnit,"mirror_wing");
    DeleteLocalInt(oUnit,"mirror_phys");
    DeleteLocalInt(OBJECT_SELF, "invalidcloak");
    DeleteLocalInt(OBJECT_SELF, "invalidarmour");
}
