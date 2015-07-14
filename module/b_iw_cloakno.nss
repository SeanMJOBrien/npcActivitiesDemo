int StartingConditional()
{
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");
    object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK,oUnit);

    // If the character is wearing a cloak...
    if (GetIsObjectValid(oCloak))
        {
        // Check if the cloak hides the character's wings
        int iPiece = GetItemAppearance(oCloak,ITEM_APPR_TYPE_SIMPLE_MODEL,0);
        string sHide = Get2DAString("cloakmodel", "HIDEWING", iPiece);

        // If so, return false
        if (sHide == "1")   { return FALSE; }
        }

    return TRUE;
}
