#include "in_g_armour"

void main()
{
    // Find the unit we're editing
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    // Remember which colour we're changing
    int iPart = ITEM_APPR_ARMOR_MODEL_TATTOO1;
    SetLocalInt(oPC,"fittingcolour",iPart);

    // Find what colour the tattoo is at the moment
    int iShade = GetColor(oUnit,COLOR_CHANNEL_TATTOO_1);
    SetCustomToken(698,GetColourName(GetArmourColour(iPart,iShade)));
}
