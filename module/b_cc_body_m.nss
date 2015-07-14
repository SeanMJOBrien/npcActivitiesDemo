#include "in_g_armour"

void main()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");
    int iPart = GetLocalInt(oPC,"fittingcolour");
    int iChannel;

    if (iPart == ITEM_APPR_ARMOR_MODEL_SKIN)
        {
        iChannel = COLOR_CHANNEL_SKIN;
        }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_HAIR)
        {
        iChannel = COLOR_CHANNEL_HAIR;
        }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_TATTOO1)
        {
        iChannel = COLOR_CHANNEL_TATTOO_1;
        }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_TATTOO2)
        {
        iChannel = COLOR_CHANNEL_TATTOO_2;
        }

    int iShade = GetColor(oUnit,iChannel);
    int iColour = GetArmourColour(iPart,iShade);

    iShade--;

    while (GetArmourColour(iPart,iShade) != iColour)
        {
        iShade--;

        // Cycle round if we reached the end of the colour chart
        if (iShade < 0)                         { iShade = 175; }
        }

    SetColor(oUnit,iChannel,iShade);
}
