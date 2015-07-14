#include "in_g_armour"

void main()
{
    object oPC = GetPCSpeaker();
    int iPart = GetLocalInt(oPC,"fittingcolour");

    object oOldArmour = GetLocalObject(oPC,"fittingarmour");
    int iShade = GetItemAppearance(oOldArmour,ITEM_APPR_TYPE_ARMOR_COLOR,iPart);
    SetCustomToken(699,GetColourName(GetArmourColour(iPart,iShade)));
}
