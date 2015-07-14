#include "in_g_armour"

void main()
{
    object oPC = GetPCSpeaker();
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    // What colour are we trying to change?
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

    SetColor(oUnit,iChannel,GetDefaultShade(iPart,COLOUR_GREEN));
}
