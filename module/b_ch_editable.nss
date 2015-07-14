int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    if (GetCreatureBodyPart(CREATURE_PART_HEAD,oUnit) > 0
    && !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_HEAD,oUnit)))
        return TRUE;

    return FALSE;
}
