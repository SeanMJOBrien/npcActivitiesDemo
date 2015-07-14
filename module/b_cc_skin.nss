#include "in_g_armour"

void main()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    SetLocalInt(oPC,"fittingcolour",ITEM_APPR_ARMOR_MODEL_SKIN);

    int iShade = GetColor(oUnit,COLOR_CHANNEL_SKIN);
    SetCustomToken(7000,GetColourName(GetArmourColour(ITEM_APPR_ARMOR_MODEL_SKIN,iShade)));
}
