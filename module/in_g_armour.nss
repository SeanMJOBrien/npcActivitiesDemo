#include "in_g_version"

object oDesk = GetObjectByTag("brief_desk");

const int bDebug = FALSE;

const int HORSE_TYPE                        = 1;
const int HORSE_EQUIPMENT                   = 2;

const int ITEM_APPR_WEAPON_MODEL_SIMPLE     = 3;

const int ITEM_APPR_ARMOR_MODEL_HELMET      = 20;
const int ITEM_APPR_ARMOR_MODEL_SHIELD      = 21;
const int ITEM_APPR_ARMOR_MODEL_CLOAK       = 22;
const int ITEM_APPR_ARMOR_MODEL_GLOVES      = 23;
const int ITEM_APPR_ARMOR_MODEL_BRACER      = 24;
const int ITEM_APPR_ARMOR_MODEL_REAL_BELT   = 25;
const int ITEM_APPR_ARMOR_MODEL_NECKLACE    = 26;
const int ITEM_APPR_ARMOR_MODEL_RINGL       = 27;
const int ITEM_APPR_ARMOR_MODEL_RINGR       = 28;
const int ITEM_APPR_ARMOR_MODEL_BOOT_TOP    = 29;
const int ITEM_APPR_ARMOR_MODEL_BOOT_MIDDLE = 30;
const int ITEM_APPR_ARMOR_MODEL_BOOT_BOTTOM = 31;
const int ITEM_APPR_ARMOR_MODEL_SKIN        = 32;
const int ITEM_APPR_ARMOR_MODEL_HAIR        = 33;
const int ITEM_APPR_ARMOR_MODEL_TATTOO1     = 34;
const int ITEM_APPR_ARMOR_MODEL_TATTOO2     = 35;

int BASE_ITEM_SAVED         = BASE_ITEM_INVALID + 1;

const int COLOUR_UNUSED     = 0;
const int COLOUR_GOLD       = 1;
const int COLOUR_SILVER     = 2;
const int COLOUR_BRONZE     = 3;
const int COLOUR_SPECIAL    = 4;
const int COLOUR_RED        = 5;
const int COLOUR_ORANGE     = 6;
const int COLOUR_YELLOW     = 7;
const int COLOUR_GREEN      = 8;
const int COLOUR_BLUE       = 9;
const int COLOUR_PURPLE     = 10;
const int COLOUR_BROWN      = 11;
const int COLOUR_BLACK      = 12;
const int COLOUR_GREY       = 13;
const int COLOUR_FLESH      = 14;

object ModifyItem(object oItem, int nType, int nIndex, int nNewValue);
void PutOnItem(object oArmour, object oPC, object oWearer = OBJECT_INVALID);
void EquipItem(object oArmour, object oPC, object oWearer = OBJECT_INVALID);
int GetNextPiece(object oPC, int iPart, object oArmour, int iChange, object oWearer = OBJECT_INVALID);
int GetNextSimplePiece(int iPart, object oArmour, int iChange, int iColour = 0);
int GetNextArmourPiece(int iPart, object oArmour, int iChange, object oPC, object oWearer = OBJECT_INVALID);
int GetNextCloakPiece(int iPart, object oArmour, int iChange, object oWearer);
object GetNextWeaponPiece(object oPC, object oWeapon, int iPart, int iChange, object oUser = OBJECT_INVALID);



// Simple wrapper function to only display text if debug option is enabled
void DebugSpeakString(string sMsg)
{
    if (bDebug) { SpeakString(sMsg, TALKVOLUME_SHOUT); }
}



string GetColourName(int iShade)
{
    string sColour;

    switch (iShade)
        {
        case COLOUR_UNUSED:     sColour = "an invalid colour";      break;
        case COLOUR_RED:        sColour = "red";                    break;
        case COLOUR_ORANGE:     sColour = "orange";                 break;
        case COLOUR_YELLOW:     sColour = "yellow";                 break;
        case COLOUR_GREEN:      sColour = "green";                  break;
        case COLOUR_BLUE:       sColour = "blue";                   break;
        case COLOUR_PURPLE:     sColour = "purple";                 break;
        case COLOUR_BROWN:      sColour = "brown";                  break;
        case COLOUR_BLACK:      sColour = "grey";                   break;
        case COLOUR_BRONZE:     sColour = "bronze";                 break;
        case COLOUR_SILVER:     sColour = "silver";                 break;
        case COLOUR_GOLD:       sColour = "gold";                   break;
        case COLOUR_SPECIAL:    sColour = "a special colour";       break;
        case COLOUR_FLESH:      sColour = "flesh coloured";         break;
        case COLOUR_GREY:       sColour = "black, grey or white";   break;
        }

    return sColour;
}



int GetDefaultShade(int iPart, int iColour)
{
    int iShade = 0;

    if (iPart == ITEM_APPR_ARMOR_COLOR_METAL1
     || iPart == ITEM_APPR_ARMOR_COLOR_METAL2)
        {
        switch (iColour)
            {
            case COLOUR_RED:        iShade = 25;        break;
            case COLOUR_GREEN:      iShade = 41;        break;
            case COLOUR_BLUE:       iShade = 33;        break;
            case COLOUR_PURPLE:     iShade = 29;        break;
            case COLOUR_BRONZE:     iShade = 17;        break;
            case COLOUR_SILVER:     iShade = 2;         break;
            case COLOUR_GOLD:       iShade = 8;         break;
            case COLOUR_SPECIAL:    iShade = 50;        break;
            }
        }

    else if (iPart == ITEM_APPR_ARMOR_MODEL_SKIN)
        {
        switch (iColour)
            {
            case COLOUR_FLESH:      iShade = 1;         break;
            case COLOUR_GREEN:      iShade = 25;        break;
            case COLOUR_GREY:       iShade = 16;        break;
            case COLOUR_BLUE:       iShade = 21;        break;
            case COLOUR_RED:        iShade = 101;       break;
            case COLOUR_PURPLE:     iShade = 146;       break;
            case COLOUR_YELLOW:     iShade = 93;        break;
            case COLOUR_SPECIAL:    iShade = 56;        break;
            }
        }

    else if (iPart == ITEM_APPR_ARMOR_MODEL_HAIR)
        {
        switch (iColour)
            {
            case COLOUR_BROWN:      iShade = 2;         break;
            case COLOUR_YELLOW:     iShade = 9;         break;
            case COLOUR_RED:        iShade = 5;         break;
            case COLOUR_GREY:       iShade = 22;        break;
            case COLOUR_GREEN:      iShade = 41;        break;
            case COLOUR_BLUE:       iShade = 29;        break;
            case COLOUR_PURPLE:     iShade = 145;       break;
            case COLOUR_SPECIAL:    iShade = 56;        break;
            }
        }

    else
        {
        switch (iColour)
            {
            case COLOUR_RED:        iShade = 91;        break;
            case COLOUR_ORANGE:     iShade = 35;        break;
            case COLOUR_YELLOW:     iShade = 32;        break;
            case COLOUR_GREEN:      iShade = 18;        break;
            case COLOUR_BLUE:       iShade = 24;        break;
            case COLOUR_PURPLE:     iShade = 39;        break;
            case COLOUR_BROWN:      iShade = 3;         break;
            case COLOUR_BLACK:      iShade = 20;        break;
            case COLOUR_SPECIAL:    iShade = 57;        break;
            }
        }

    return iShade;
}



int GetArmourColour(int iPart, int iShade)
{
    int iColour = COLOUR_UNUSED;

    if (iPart == ITEM_APPR_ARMOR_COLOR_METAL1
     || iPart == ITEM_APPR_ARMOR_COLOR_METAL2)
        {
        switch (iShade)
            {
            case 0:     iColour = COLOUR_SILVER;        break;
            case 1:     iColour = COLOUR_SILVER;        break;
            case 2:     iColour = COLOUR_SILVER;        break;
            case 3:     iColour = COLOUR_SILVER;        break;
            case 4:     iColour = COLOUR_SILVER;        break;
            case 5:     iColour = COLOUR_SILVER;        break;
            case 6:     iColour = COLOUR_SILVER;        break;
            case 7:     iColour = COLOUR_SILVER;        break;
            case 8:     iColour = COLOUR_GOLD;          break;
            case 9:     iColour = COLOUR_GOLD;          break;
            case 10:    iColour = COLOUR_GOLD;          break;
            case 11:    iColour = COLOUR_GOLD;          break;
            case 12:    iColour = COLOUR_GOLD;          break;
            case 13:    iColour = COLOUR_GOLD;          break;
            case 14:    iColour = COLOUR_GOLD;          break;
            case 15:    iColour = COLOUR_GOLD;          break;
            case 16:    iColour = COLOUR_BRONZE;        break;
            case 17:    iColour = COLOUR_BRONZE;        break;
            case 18:    iColour = COLOUR_BRONZE;        break;
            case 19:    iColour = COLOUR_BRONZE;        break;
            case 20:    iColour = COLOUR_BRONZE;        break;
            case 21:    iColour = COLOUR_BRONZE;        break;
            case 22:    iColour = COLOUR_BRONZE;        break;
            case 23:    iColour = COLOUR_BRONZE;        break;
            case 24:    iColour = COLOUR_RED;           break;
            case 25:    iColour = COLOUR_RED;           break;
            case 26:    iColour = COLOUR_RED;           break;
            case 27:    iColour = COLOUR_RED;           break;
            case 28:    iColour = COLOUR_PURPLE;        break;
            case 29:    iColour = COLOUR_PURPLE;        break;
            case 30:    iColour = COLOUR_PURPLE;        break;
            case 31:    iColour = COLOUR_PURPLE;        break;
            case 32:    iColour = COLOUR_BLUE;          break;
            case 33:    iColour = COLOUR_BLUE;          break;
            case 34:    iColour = COLOUR_BLUE;          break;
            case 35:    iColour = COLOUR_BLUE;          break;
            case 36:    iColour = COLOUR_BLUE;          break;
            case 37:    iColour = COLOUR_BLUE;          break;
            case 38:    iColour = COLOUR_BLUE;          break;
            case 39:    iColour = COLOUR_BLUE;          break;
            case 40:    iColour = COLOUR_GREEN;         break;
            case 41:    iColour = COLOUR_GREEN;         break;
            case 42:    iColour = COLOUR_GREEN;         break;
            case 43:    iColour = COLOUR_GREEN;         break;
            case 44:    iColour = COLOUR_GREEN;         break;
            case 45:    iColour = COLOUR_GREEN;         break;
            case 46:    iColour = COLOUR_GREEN;         break;
            case 47:    iColour = COLOUR_GREEN;         break;
            case 48:    iColour = COLOUR_SPECIAL;       break;
            case 49:    iColour = COLOUR_SPECIAL;       break;
            case 50:    iColour = COLOUR_SPECIAL;       break;
            case 51:    iColour = COLOUR_SPECIAL;       break;
            case 52:    iColour = COLOUR_SPECIAL;       break;
            case 53:    iColour = COLOUR_SPECIAL;       break;
            case 54:    iColour = COLOUR_SILVER;        break;
            case 55:    iColour = COLOUR_SILVER;        break;
            case 56:    iColour = COLOUR_SILVER;        break;
            case 57:    iColour = COLOUR_SILVER;        break;
            case 58:    iColour = COLOUR_GOLD;          break;
            case 59:    iColour = COLOUR_BRONZE;        break;
            case 60:    iColour = COLOUR_SILVER;        break;
            case 61:    iColour = COLOUR_SILVER;        break;
            case 62:    iColour = COLOUR_SPECIAL;       break;
            case 63:    iColour = COLOUR_SPECIAL;       break;
            case 64:    iColour = COLOUR_PURPLE;        break;
            case 65:    iColour = COLOUR_SILVER;        break;
            case 66:    iColour = COLOUR_GOLD;          break;
            case 67:    iColour = COLOUR_GREEN;         break;
            case 68:    iColour = COLOUR_GREEN;         break;
            case 69:    iColour = COLOUR_GREEN;         break;
            case 70:    iColour = COLOUR_PURPLE;        break;
            case 71:    iColour = COLOUR_PURPLE;        break;
            case 72:    iColour = COLOUR_PURPLE;        break;
            case 73:    iColour = COLOUR_PURPLE;        break;
            case 74:    iColour = COLOUR_BRONZE;        break;
            case 75:    iColour = COLOUR_SILVER;        break;
            case 76:    iColour = COLOUR_GREEN;         break;
            case 77:    iColour = COLOUR_GREEN;         break;
            case 78:    iColour = COLOUR_BLUE;          break;
            case 79:    iColour = COLOUR_BLUE;          break;
            case 80:    iColour = COLOUR_GREEN;         break;
            case 81:    iColour = COLOUR_GREEN;         break;
            case 82:    iColour = COLOUR_BLUE;          break;
            case 83:    iColour = COLOUR_BLUE;          break;
            case 84:    iColour = COLOUR_GREEN;         break;
            case 85:    iColour = COLOUR_SILVER;        break;
            case 86:    iColour = COLOUR_BLUE;          break;
            case 87:    iColour = COLOUR_GREEN;         break;
            case 88:    iColour = COLOUR_RED;           break;
            case 89:    iColour = COLOUR_RED;           break;
            case 90:    iColour = COLOUR_RED;           break;
            case 91:    iColour = COLOUR_RED;           break;
            case 92:    iColour = COLOUR_GOLD;          break;
            case 93:    iColour = COLOUR_GOLD;          break;
            case 94:    iColour = COLOUR_GOLD;          break;
            case 95:    iColour = COLOUR_GOLD;          break;
            case 96:    iColour = COLOUR_PURPLE;        break;
            case 97:    iColour = COLOUR_PURPLE;        break;
            case 98:    iColour = COLOUR_PURPLE;        break;
            case 99:    iColour = COLOUR_PURPLE;        break;
            case 100:   iColour = COLOUR_RED;           break;
            case 101:   iColour = COLOUR_RED;           break;
            case 102:   iColour = COLOUR_RED;           break;
            case 103:   iColour = COLOUR_RED;           break;
            case 104:   iColour = COLOUR_GREEN;         break;
            case 105:   iColour = COLOUR_GREEN;         break;
            case 106:   iColour = COLOUR_GREEN;         break;
            case 107:   iColour = COLOUR_GREEN;         break;
            case 108:   iColour = COLOUR_GREEN;         break;
            case 109:   iColour = COLOUR_GREEN;         break;
            case 110:   iColour = COLOUR_GREEN;         break;
            case 111:   iColour = COLOUR_GREEN;         break;
            case 112:   iColour = COLOUR_GREEN;         break;
            case 113:   iColour = COLOUR_GREEN;         break;
            case 114:   iColour = COLOUR_GREEN;         break;
            case 115:   iColour = COLOUR_GREEN;         break;
            case 116:   iColour = COLOUR_RED;           break;
            case 117:   iColour = COLOUR_RED;           break;
            case 118:   iColour = COLOUR_RED;           break;
            case 119:   iColour = COLOUR_RED;           break;
            case 120:   iColour = COLOUR_BRONZE;        break;
            case 121:   iColour = COLOUR_BRONZE;        break;
            case 122:   iColour = COLOUR_BRONZE;        break;
            case 123:   iColour = COLOUR_BRONZE;        break;
            case 124:   iColour = COLOUR_SILVER;        break;
            case 125:   iColour = COLOUR_SILVER;        break;
            case 126:   iColour = COLOUR_SILVER;        break;
            case 127:   iColour = COLOUR_SILVER;        break;
            case 128:   iColour = COLOUR_GOLD;          break;
            case 129:   iColour = COLOUR_GOLD;          break;
            case 130:   iColour = COLOUR_GOLD;          break;
            case 131:   iColour = COLOUR_GOLD;          break;
            case 132:   iColour = COLOUR_BLUE;          break;
            case 133:   iColour = COLOUR_BLUE;          break;
            case 134:   iColour = COLOUR_BLUE;          break;
            case 135:   iColour = COLOUR_BLUE;          break;
            case 136:   iColour = COLOUR_BLUE;          break;
            case 137:   iColour = COLOUR_BLUE;          break;
            case 138:   iColour = COLOUR_BLUE;          break;
            case 139:   iColour = COLOUR_BLUE;          break;
            case 140:   iColour = COLOUR_GREEN;         break;
            case 141:   iColour = COLOUR_GREEN;         break;
            case 142:   iColour = COLOUR_GREEN;         break;
            case 143:   iColour = COLOUR_GREEN;         break;
            case 144:   iColour = COLOUR_PURPLE;        break;
            case 145:   iColour = COLOUR_PURPLE;        break;
            case 146:   iColour = COLOUR_PURPLE;        break;
            case 147:   iColour = COLOUR_PURPLE;        break;
            case 148:   iColour = COLOUR_BLUE;          break;
            case 149:   iColour = COLOUR_BLUE;          break;
            case 150:   iColour = COLOUR_BLUE;          break;
            case 151:   iColour = COLOUR_BLUE;          break;
            case 152:   iColour = COLOUR_GREEN;         break;
            case 153:   iColour = COLOUR_GREEN;         break;
            case 154:   iColour = COLOUR_GOLD;          break;
            case 155:   iColour = COLOUR_GOLD;          break;
            case 156:   iColour = COLOUR_BRONZE;        break;
            case 157:   iColour = COLOUR_BRONZE;        break;
            case 158:   iColour = COLOUR_PURPLE;        break;
            case 159:   iColour = COLOUR_PURPLE;        break;
            case 160:   iColour = COLOUR_PURPLE;        break;
            case 161:   iColour = COLOUR_PURPLE;        break;
            case 162:   iColour = COLOUR_RED;           break;
            case 163:   iColour = COLOUR_PURPLE;        break;
            case 164:   iColour = COLOUR_BLUE;          break;
            case 165:   iColour = COLOUR_BLUE;          break;
            case 166:   iColour = COLOUR_SILVER;        break;
            case 167:   iColour = COLOUR_GREEN;         break;
            case 168:   iColour = COLOUR_GREEN;         break;
            case 169:   iColour = COLOUR_GREEN;         break;
            case 170:   iColour = COLOUR_BLUE;          break;
            case 171:   iColour = COLOUR_BLUE;          break;
            case 172:   iColour = COLOUR_GREEN;         break;
            case 173:   iColour = COLOUR_PURPLE;        break;
            case 174:   iColour = COLOUR_BRONZE;        break;
            case 175:   iColour = COLOUR_SPECIAL;       break;
            }
        }

    else if (iPart == ITEM_APPR_ARMOR_MODEL_SKIN)
        {
        switch (iShade)
            {
            case 0:     iColour = COLOUR_FLESH;         break;
            case 1:     iColour = COLOUR_FLESH;         break;
            case 2:     iColour = COLOUR_FLESH;         break;
            case 3:     iColour = COLOUR_FLESH;         break;
            case 4:     iColour = COLOUR_FLESH;         break;
            case 5:     iColour = COLOUR_FLESH;         break;
            case 6:     iColour = COLOUR_FLESH;         break;
            case 7:     iColour = COLOUR_FLESH;         break;
            case 8:     iColour = COLOUR_FLESH;         break;
            case 9:     iColour = COLOUR_FLESH;         break;
            case 10:    iColour = COLOUR_FLESH;         break;
            case 11:    iColour = COLOUR_FLESH;         break;
            case 12:    iColour = COLOUR_FLESH;         break;
            case 13:    iColour = COLOUR_FLESH;         break;
            case 14:    iColour = COLOUR_FLESH;         break;
            case 15:    iColour = COLOUR_FLESH;         break;
            case 16:    iColour = COLOUR_GREY;          break;
            case 17:    iColour = COLOUR_GREY;          break;
            case 18:    iColour = COLOUR_GREY;          break;
            case 19:    iColour = COLOUR_GREY;          break;
            case 20:    iColour = COLOUR_BLUE;          break;
            case 21:    iColour = COLOUR_BLUE;          break;
            case 22:    iColour = COLOUR_BLUE;          break;
            case 23:    iColour = COLOUR_BLUE;          break;
            case 24:    iColour = COLOUR_FLESH;         break;
            case 25:    iColour = COLOUR_FLESH;         break;
            case 26:    iColour = COLOUR_FLESH;         break;
            case 27:    iColour = COLOUR_FLESH;         break;
            case 28:    iColour = COLOUR_BLUE;          break;
            case 29:    iColour = COLOUR_BLUE;          break;
            case 30:    iColour = COLOUR_BLUE;          break;
            case 31:    iColour = COLOUR_BLUE;          break;
            case 32:    iColour = COLOUR_GREEN;         break;
            case 33:    iColour = COLOUR_GREEN;         break;
            case 34:    iColour = COLOUR_GREEN;         break;
            case 35:    iColour = COLOUR_GREEN;         break;
            case 36:    iColour = COLOUR_GREEN;         break;
            case 37:    iColour = COLOUR_GREEN;         break;
            case 38:    iColour = COLOUR_GREEN;         break;
            case 39:    iColour = COLOUR_GREEN;         break;
            case 40:    iColour = COLOUR_GREY;          break;
            case 41:    iColour = COLOUR_GREY;          break;
            case 42:    iColour = COLOUR_GREY;          break;
            case 43:    iColour = COLOUR_GREY;          break;
            case 44:    iColour = COLOUR_RED;           break;
            case 45:    iColour = COLOUR_RED;           break;
            case 46:    iColour = COLOUR_PURPLE;        break;
            case 47:    iColour = COLOUR_PURPLE;        break;
            case 48:    iColour = COLOUR_BLUE;          break;
            case 49:    iColour = COLOUR_BLUE;          break;
            case 50:    iColour = COLOUR_BLUE;          break;
            case 51:    iColour = COLOUR_BLUE;          break;
            case 52:    iColour = COLOUR_GREEN;         break;
            case 53:    iColour = COLOUR_GREEN;         break;
            case 54:    iColour = COLOUR_GREEN;         break;
            case 55:    iColour = COLOUR_GREEN;         break;
            case 56:    iColour = COLOUR_SPECIAL;       break;
            case 57:    iColour = COLOUR_SPECIAL;       break;
            case 58:    iColour = COLOUR_SPECIAL;       break;
            case 59:    iColour = COLOUR_SPECIAL;       break;
            case 60:    iColour = COLOUR_SPECIAL;       break;
            case 61:    iColour = COLOUR_SPECIAL;       break;
            case 62:    iColour = COLOUR_GREY;          break;
            case 63:    iColour = COLOUR_GREY;          break;
            case 64:    iColour = COLOUR_RED;           break;
            case 65:    iColour = COLOUR_RED;           break;
            case 66:    iColour = COLOUR_YELLOW;        break;
            case 67:    iColour = COLOUR_GREEN;         break;
            case 68:    iColour = COLOUR_GREEN;         break;
            case 69:    iColour = COLOUR_GREEN;         break;
            case 70:    iColour = COLOUR_PURPLE;        break;
            case 71:    iColour = COLOUR_PURPLE;        break;
            case 72:    iColour = COLOUR_PURPLE;        break;
            case 73:    iColour = COLOUR_PURPLE;        break;
            case 74:    iColour = COLOUR_FLESH;         break;
            case 75:    iColour = COLOUR_GREY;          break;
            case 76:    iColour = COLOUR_GREEN;         break;
            case 77:    iColour = COLOUR_GREEN;         break;
            case 78:    iColour = COLOUR_BLUE;          break;
            case 79:    iColour = COLOUR_BLUE;          break;
            case 80:    iColour = COLOUR_GREEN;         break;
            case 81:    iColour = COLOUR_GREEN;         break;
            case 82:    iColour = COLOUR_BLUE;          break;
            case 83:    iColour = COLOUR_BLUE;          break;
            case 84:    iColour = COLOUR_GREEN;         break;
            case 85:    iColour = COLOUR_GREEN;         break;
            case 86:    iColour = COLOUR_BLUE;          break;
            case 87:    iColour = COLOUR_GREEN;         break;
            case 88:    iColour = COLOUR_RED;           break;
            case 89:    iColour = COLOUR_RED;           break;
            case 90:    iColour = COLOUR_RED;           break;
            case 91:    iColour = COLOUR_RED;           break;
            case 92:    iColour = COLOUR_YELLOW;        break;
            case 93:    iColour = COLOUR_YELLOW;        break;
            case 94:    iColour = COLOUR_YELLOW;        break;
            case 95:    iColour = COLOUR_YELLOW;        break;
            case 96:    iColour = COLOUR_PURPLE;        break;
            case 97:    iColour = COLOUR_PURPLE;        break;
            case 98:    iColour = COLOUR_PURPLE;        break;
            case 99:    iColour = COLOUR_PURPLE;        break;
            case 100:   iColour = COLOUR_RED;           break;
            case 101:   iColour = COLOUR_RED;           break;
            case 102:   iColour = COLOUR_RED;           break;
            case 103:   iColour = COLOUR_RED;           break;
            case 104:   iColour = COLOUR_GREEN;         break;
            case 105:   iColour = COLOUR_GREEN;         break;
            case 106:   iColour = COLOUR_GREEN;         break;
            case 107:   iColour = COLOUR_GREEN;         break;
            case 108:   iColour = COLOUR_GREEN;         break;
            case 109:   iColour = COLOUR_GREEN;         break;
            case 110:   iColour = COLOUR_GREEN;         break;
            case 111:   iColour = COLOUR_GREEN;         break;
            case 112:   iColour = COLOUR_GREY;          break;
            case 113:   iColour = COLOUR_GREY;          break;
            case 114:   iColour = COLOUR_GREY;          break;
            case 115:   iColour = COLOUR_GREY;          break;
            case 116:   iColour = COLOUR_FLESH;         break;
            case 117:   iColour = COLOUR_FLESH;         break;
            case 118:   iColour = COLOUR_FLESH;         break;
            case 119:   iColour = COLOUR_FLESH;         break;
            case 120:   iColour = COLOUR_FLESH;         break;
            case 121:   iColour = COLOUR_FLESH;         break;
            case 122:   iColour = COLOUR_FLESH;         break;
            case 123:   iColour = COLOUR_FLESH;         break;
            case 124:   iColour = COLOUR_GREY;          break;
            case 125:   iColour = COLOUR_GREY;          break;
            case 126:   iColour = COLOUR_GREY;          break;
            case 127:   iColour = COLOUR_GREY;          break;
            case 128:   iColour = COLOUR_FLESH;         break;
            case 129:   iColour = COLOUR_FLESH;         break;
            case 130:   iColour = COLOUR_FLESH;         break;
            case 131:   iColour = COLOUR_FLESH;         break;
            case 132:   iColour = COLOUR_BLUE;          break;
            case 133:   iColour = COLOUR_BLUE;          break;
            case 134:   iColour = COLOUR_BLUE;          break;
            case 135:   iColour = COLOUR_BLUE;          break;
            case 136:   iColour = COLOUR_BLUE;          break;
            case 137:   iColour = COLOUR_BLUE;          break;
            case 138:   iColour = COLOUR_BLUE;          break;
            case 139:   iColour = COLOUR_BLUE;          break;
            case 140:   iColour = COLOUR_BLUE;          break;
            case 141:   iColour = COLOUR_BLUE;          break;
            case 142:   iColour = COLOUR_BLUE;          break;
            case 143:   iColour = COLOUR_BLUE;          break;
            case 144:   iColour = COLOUR_PURPLE;        break;
            case 145:   iColour = COLOUR_PURPLE;        break;
            case 146:   iColour = COLOUR_PURPLE;        break;
            case 147:   iColour = COLOUR_PURPLE;        break;
            case 148:   iColour = COLOUR_BLUE;          break;
            case 149:   iColour = COLOUR_BLUE;          break;
            case 150:   iColour = COLOUR_BLUE;          break;
            case 151:   iColour = COLOUR_BLUE;          break;
            case 152:   iColour = COLOUR_GREEN;         break;
            case 153:   iColour = COLOUR_GREEN;         break;
            case 154:   iColour = COLOUR_YELLOW;        break;
            case 155:   iColour = COLOUR_YELLOW;        break;
            case 156:   iColour = COLOUR_FLESH;         break;
            case 157:   iColour = COLOUR_FLESH;         break;
            case 158:   iColour = COLOUR_FLESH;         break;
            case 159:   iColour = COLOUR_FLESH;         break;
            case 160:   iColour = COLOUR_PURPLE;        break;
            case 161:   iColour = COLOUR_PURPLE;        break;
            case 162:   iColour = COLOUR_FLESH;         break;
            case 163:   iColour = COLOUR_PURPLE;        break;
            case 164:   iColour = COLOUR_BLUE;          break;
            case 165:   iColour = COLOUR_BLUE;          break;
            case 166:   iColour = COLOUR_GREY;          break;
            case 167:   iColour = COLOUR_GREEN;         break;
            case 168:   iColour = COLOUR_GREEN;         break;
            case 169:   iColour = COLOUR_GREEN;         break;
            case 170:   iColour = COLOUR_PURPLE;        break;
            case 171:   iColour = COLOUR_BLUE;          break;
            case 172:   iColour = COLOUR_GREEN;         break;
            case 173:   iColour = COLOUR_FLESH;         break;
            case 174:   iColour = COLOUR_FLESH;         break;
            case 175:   iColour = COLOUR_SPECIAL;       break;
            }
        }

    else if (iPart == ITEM_APPR_ARMOR_MODEL_HAIR)
        {
        switch (iShade)
            {
            case 0:     iColour = COLOUR_BROWN;         break;
            case 1:     iColour = COLOUR_BROWN;         break;
            case 2:     iColour = COLOUR_BROWN;         break;
            case 3:     iColour = COLOUR_BROWN;         break;
            case 4:     iColour = COLOUR_RED;           break;
            case 5:     iColour = COLOUR_RED;           break;
            case 6:     iColour = COLOUR_RED;           break;
            case 7:     iColour = COLOUR_RED;           break;
            case 8:     iColour = COLOUR_YELLOW;        break;
            case 9:     iColour = COLOUR_YELLOW;        break;
            case 10:    iColour = COLOUR_YELLOW;        break;
            case 11:    iColour = COLOUR_YELLOW;        break;
            case 12:    iColour = COLOUR_BROWN;         break;
            case 13:    iColour = COLOUR_BROWN;         break;
            case 14:    iColour = COLOUR_BROWN;         break;
            case 15:    iColour = COLOUR_BROWN;         break;
            case 16:    iColour = COLOUR_GREY;          break;
            case 17:    iColour = COLOUR_GREY;          break;
            case 18:    iColour = COLOUR_GREY;          break;
            case 19:    iColour = COLOUR_GREY;          break;
            case 20:    iColour = COLOUR_GREY;          break;
            case 21:    iColour = COLOUR_GREY;          break;
            case 22:    iColour = COLOUR_GREY;          break;
            case 23:    iColour = COLOUR_GREY;          break;
            case 24:    iColour = COLOUR_PURPLE;        break;
            case 25:    iColour = COLOUR_PURPLE;        break;
            case 26:    iColour = COLOUR_PURPLE;        break;
            case 27:    iColour = COLOUR_PURPLE;        break;
            case 28:    iColour = COLOUR_BLUE;          break;
            case 29:    iColour = COLOUR_BLUE;          break;
            case 30:    iColour = COLOUR_BLUE;          break;
            case 31:    iColour = COLOUR_BLUE;          break;
            case 32:    iColour = COLOUR_BLUE;          break;
            case 33:    iColour = COLOUR_BLUE;          break;
            case 34:    iColour = COLOUR_BLUE;          break;
            case 35:    iColour = COLOUR_BLUE;          break;
            case 36:    iColour = COLOUR_GREEN;         break;
            case 37:    iColour = COLOUR_GREEN;         break;
            case 38:    iColour = COLOUR_GREEN;         break;
            case 39:    iColour = COLOUR_GREEN;         break;
            case 40:    iColour = COLOUR_GREEN;         break;
            case 41:    iColour = COLOUR_GREEN;         break;
            case 42:    iColour = COLOUR_GREEN;         break;
            case 43:    iColour = COLOUR_GREEN;         break;
            case 44:    iColour = COLOUR_YELLOW;        break;
            case 45:    iColour = COLOUR_YELLOW;        break;
            case 46:    iColour = COLOUR_YELLOW;        break;
            case 47:    iColour = COLOUR_YELLOW;        break;
            case 48:    iColour = COLOUR_BROWN;         break;
            case 49:    iColour = COLOUR_BROWN;         break;
            case 50:    iColour = COLOUR_BROWN;         break;
            case 51:    iColour = COLOUR_BROWN;         break;
            case 52:    iColour = COLOUR_RED;           break;
            case 53:    iColour = COLOUR_RED;           break;
            case 54:    iColour = COLOUR_RED;           break;
            case 55:    iColour = COLOUR_RED;           break;
            case 56:    iColour = COLOUR_SPECIAL;       break;
            case 57:    iColour = COLOUR_SPECIAL;       break;
            case 58:    iColour = COLOUR_SPECIAL;       break;
            case 59:    iColour = COLOUR_SPECIAL;       break;
            case 60:    iColour = COLOUR_SPECIAL;       break;
            case 61:    iColour = COLOUR_SPECIAL;       break;
            case 62:    iColour = COLOUR_GREY;          break;
            case 63:    iColour = COLOUR_GREY;          break;
            case 64:    iColour = COLOUR_RED;           break;
            case 65:    iColour = COLOUR_RED;           break;
            case 66:    iColour = COLOUR_YELLOW;        break;
            case 67:    iColour = COLOUR_GREEN;         break;
            case 68:    iColour = COLOUR_GREEN;         break;
            case 69:    iColour = COLOUR_GREEN;         break;
            case 70:    iColour = COLOUR_PURPLE;        break;
            case 71:    iColour = COLOUR_PURPLE;        break;
            case 72:    iColour = COLOUR_PURPLE;        break;
            case 73:    iColour = COLOUR_PURPLE;        break;
            case 74:    iColour = COLOUR_BROWN;         break;
            case 75:    iColour = COLOUR_GREY;          break;
            case 76:    iColour = COLOUR_GREEN;         break;
            case 77:    iColour = COLOUR_GREEN;         break;
            case 78:    iColour = COLOUR_BLUE;          break;
            case 79:    iColour = COLOUR_BLUE;          break;
            case 80:    iColour = COLOUR_GREEN;         break;
            case 81:    iColour = COLOUR_GREEN;         break;
            case 82:    iColour = COLOUR_BLUE;          break;
            case 83:    iColour = COLOUR_BLUE;          break;
            case 84:    iColour = COLOUR_GREEN;         break;
            case 85:    iColour = COLOUR_GREEN;         break;
            case 86:    iColour = COLOUR_BLUE;          break;
            case 87:    iColour = COLOUR_GREEN;         break;
            case 88:    iColour = COLOUR_RED;           break;
            case 89:    iColour = COLOUR_RED;           break;
            case 90:    iColour = COLOUR_RED;           break;
            case 91:    iColour = COLOUR_RED;           break;
            case 92:    iColour = COLOUR_YELLOW;        break;
            case 93:    iColour = COLOUR_YELLOW;        break;
            case 94:    iColour = COLOUR_YELLOW;        break;
            case 95:    iColour = COLOUR_YELLOW;        break;
            case 96:    iColour = COLOUR_PURPLE;        break;
            case 97:    iColour = COLOUR_PURPLE;        break;
            case 98:    iColour = COLOUR_PURPLE;        break;
            case 99:    iColour = COLOUR_PURPLE;        break;
            case 100:   iColour = COLOUR_RED;           break;
            case 101:   iColour = COLOUR_RED;           break;
            case 102:   iColour = COLOUR_RED;           break;
            case 103:   iColour = COLOUR_RED;           break;
            case 104:   iColour = COLOUR_GREEN;         break;
            case 105:   iColour = COLOUR_GREEN;         break;
            case 106:   iColour = COLOUR_GREEN;         break;
            case 107:   iColour = COLOUR_GREEN;         break;
            case 108:   iColour = COLOUR_GREEN;         break;
            case 109:   iColour = COLOUR_GREEN;         break;
            case 110:   iColour = COLOUR_GREEN;         break;
            case 111:   iColour = COLOUR_GREEN;         break;
            case 112:   iColour = COLOUR_GREY;          break;
            case 113:   iColour = COLOUR_GREY;          break;
            case 114:   iColour = COLOUR_GREY;          break;
            case 115:   iColour = COLOUR_GREY;          break;
            case 116:   iColour = COLOUR_BROWN;         break;
            case 117:   iColour = COLOUR_BROWN;         break;
            case 118:   iColour = COLOUR_BROWN;         break;
            case 119:   iColour = COLOUR_BROWN;         break;
            case 120:   iColour = COLOUR_BROWN;         break;
            case 121:   iColour = COLOUR_BROWN;         break;
            case 122:   iColour = COLOUR_BROWN;         break;
            case 123:   iColour = COLOUR_BROWN;         break;
            case 124:   iColour = COLOUR_GREY;          break;
            case 125:   iColour = COLOUR_GREY;          break;
            case 126:   iColour = COLOUR_GREY;          break;
            case 127:   iColour = COLOUR_GREY;          break;
            case 128:   iColour = COLOUR_BROWN;         break;
            case 129:   iColour = COLOUR_BROWN;         break;
            case 130:   iColour = COLOUR_BROWN;         break;
            case 131:   iColour = COLOUR_BROWN;         break;
            case 132:   iColour = COLOUR_BLUE;          break;
            case 133:   iColour = COLOUR_BLUE;          break;
            case 134:   iColour = COLOUR_BLUE;          break;
            case 135:   iColour = COLOUR_BLUE;          break;
            case 136:   iColour = COLOUR_BLUE;          break;
            case 137:   iColour = COLOUR_BLUE;          break;
            case 138:   iColour = COLOUR_BLUE;          break;
            case 139:   iColour = COLOUR_BLUE;          break;
            case 140:   iColour = COLOUR_BLUE;          break;
            case 141:   iColour = COLOUR_BLUE;          break;
            case 142:   iColour = COLOUR_BLUE;          break;
            case 143:   iColour = COLOUR_BLUE;          break;
            case 144:   iColour = COLOUR_PURPLE;        break;
            case 145:   iColour = COLOUR_PURPLE;        break;
            case 146:   iColour = COLOUR_PURPLE;        break;
            case 147:   iColour = COLOUR_PURPLE;        break;
            case 148:   iColour = COLOUR_BLUE;          break;
            case 149:   iColour = COLOUR_BLUE;          break;
            case 150:   iColour = COLOUR_BLUE;          break;
            case 151:   iColour = COLOUR_BLUE;          break;
            case 152:   iColour = COLOUR_GREEN;         break;
            case 153:   iColour = COLOUR_GREEN;         break;
            case 154:   iColour = COLOUR_YELLOW;        break;
            case 155:   iColour = COLOUR_YELLOW;        break;
            case 156:   iColour = COLOUR_RED;           break;
            case 157:   iColour = COLOUR_RED;           break;
            case 158:   iColour = COLOUR_PURPLE;        break;
            case 159:   iColour = COLOUR_PURPLE;        break;
            case 160:   iColour = COLOUR_PURPLE;        break;
            case 161:   iColour = COLOUR_PURPLE;        break;
            case 162:   iColour = COLOUR_PURPLE;        break;
            case 163:   iColour = COLOUR_PURPLE;        break;
            case 164:   iColour = COLOUR_BLUE;          break;
            case 165:   iColour = COLOUR_BLUE;          break;
            case 166:   iColour = COLOUR_GREY;          break;
            case 167:   iColour = COLOUR_GREEN;         break;
            case 168:   iColour = COLOUR_GREEN;         break;
            case 169:   iColour = COLOUR_GREEN;         break;
            case 170:   iColour = COLOUR_PURPLE;        break;
            case 171:   iColour = COLOUR_BLUE;          break;
            case 172:   iColour = COLOUR_GREEN;         break;
            case 173:   iColour = COLOUR_BROWN;         break;
            case 174:   iColour = COLOUR_BROWN;         break;
            case 175:   iColour = COLOUR_SPECIAL;       break;
                }
        }

    else
        {
        switch (iShade)
            {
            case 0:     iColour = COLOUR_BROWN;         break;
            case 1:     iColour = COLOUR_BROWN;         break;
            case 2:     iColour = COLOUR_BROWN;         break;
            case 3:     iColour = COLOUR_BROWN;         break;
            case 4:     iColour = COLOUR_RED;           break;
            case 5:     iColour = COLOUR_RED;           break;
            case 6:     iColour = COLOUR_RED;           break;
            case 7:     iColour = COLOUR_RED;           break;
            case 8:     iColour = COLOUR_BROWN;         break;
            case 9:     iColour = COLOUR_BROWN;         break;
            case 10:    iColour = COLOUR_BROWN;         break;
            case 11:    iColour = COLOUR_BROWN;         break;
            case 12:    iColour = COLOUR_BROWN;         break;
            case 13:    iColour = COLOUR_BROWN;         break;
            case 14:    iColour = COLOUR_BROWN;         break;
            case 15:    iColour = COLOUR_BROWN;         break;
            case 16:    iColour = COLOUR_GREEN;         break;
            case 17:    iColour = COLOUR_GREEN;         break;
            case 18:    iColour = COLOUR_GREEN;         break;
            case 19:    iColour = COLOUR_GREEN;         break;
            case 20:    iColour = COLOUR_BLACK;         break;
            case 21:    iColour = COLOUR_BLACK;         break;
            case 22:    iColour = COLOUR_BLACK;         break;
            case 23:    iColour = COLOUR_BLACK;         break;
            case 24:    iColour = COLOUR_BLUE;          break;
            case 25:    iColour = COLOUR_BLUE;          break;
            case 26:    iColour = COLOUR_BLUE;          break;
            case 27:    iColour = COLOUR_BLUE;          break;
            case 28:    iColour = COLOUR_BLUE;          break;
            case 29:    iColour = COLOUR_BLUE;          break;
            case 30:    iColour = COLOUR_GREEN;         break;
            case 31:    iColour = COLOUR_GREEN;         break;
            case 32:    iColour = COLOUR_YELLOW;        break;
            case 33:    iColour = COLOUR_YELLOW;        break;
            case 34:    iColour = COLOUR_ORANGE;        break;
            case 35:    iColour = COLOUR_ORANGE;        break;
            case 36:    iColour = COLOUR_RED;           break;
            case 37:    iColour = COLOUR_RED;           break;
            case 38:    iColour = COLOUR_PURPLE;        break;
            case 39:    iColour = COLOUR_PURPLE;        break;
            case 40:    iColour = COLOUR_PURPLE;        break;
            case 41:    iColour = COLOUR_PURPLE;        break;
            case 42:    iColour = COLOUR_PURPLE;        break;
            case 43:    iColour = COLOUR_PURPLE;        break;
            case 44:    iColour = COLOUR_BLACK;         break;
            case 45:    iColour = COLOUR_BLACK;         break;
            case 46:    iColour = COLOUR_BLUE;          break;
            case 47:    iColour = COLOUR_BLUE;          break;
            case 48:    iColour = COLOUR_BLUE;          break;
            case 49:    iColour = COLOUR_GREEN;         break;
            case 50:    iColour = COLOUR_YELLOW;        break;
            case 51:    iColour = COLOUR_ORANGE;        break;
            case 52:    iColour = COLOUR_RED;           break;
            case 53:    iColour = COLOUR_PURPLE;        break;
            case 54:    iColour = COLOUR_PURPLE;        break;
            case 55:    iColour = COLOUR_PURPLE;        break;
            case 56:    iColour = COLOUR_SPECIAL;       break;
            case 57:    iColour = COLOUR_SPECIAL;       break;
            case 58:    iColour = COLOUR_SPECIAL;       break;
            case 59:    iColour = COLOUR_SPECIAL;       break;
            case 60:    iColour = COLOUR_BLACK;         break;
            case 61:    iColour = COLOUR_SPECIAL;       break;
            case 62:    iColour = COLOUR_SPECIAL;       break;
            case 63:    iColour = COLOUR_SPECIAL;       break;
            case 64:    iColour = COLOUR_PURPLE;        break;
            case 65:    iColour = COLOUR_BROWN;         break;
            case 66:    iColour = COLOUR_YELLOW;        break;
            case 67:    iColour = COLOUR_GREEN;         break;
            case 68:    iColour = COLOUR_GREEN;         break;
            case 69:    iColour = COLOUR_GREEN;         break;
            case 70:    iColour = COLOUR_PURPLE;        break;
            case 71:    iColour = COLOUR_BLACK;         break;
            case 72:    iColour = COLOUR_PURPLE;        break;
            case 73:    iColour = COLOUR_PURPLE;        break;
            case 74:    iColour = COLOUR_BROWN;         break;
            case 75:    iColour = COLOUR_BROWN;         break;
            case 76:    iColour = COLOUR_BLUE;          break;
            case 77:    iColour = COLOUR_BLUE;          break;
            case 78:    iColour = COLOUR_BLUE;          break;
            case 79:    iColour = COLOUR_BLUE;          break;
            case 80:    iColour = COLOUR_GREEN;         break;
            case 81:    iColour = COLOUR_GREEN;         break;
            case 82:    iColour = COLOUR_BLUE;          break;
            case 83:    iColour = COLOUR_BLUE;          break;
            case 84:    iColour = COLOUR_GREEN;         break;
            case 85:    iColour = COLOUR_BLUE;          break;
            case 86:    iColour = COLOUR_BROWN;         break;
            case 87:    iColour = COLOUR_GREEN;         break;
            case 88:    iColour = COLOUR_RED;           break;
            case 89:    iColour = COLOUR_RED;           break;
            case 90:    iColour = COLOUR_RED;           break;
            case 91:    iColour = COLOUR_RED;           break;
            case 92:    iColour = COLOUR_YELLOW;        break;
            case 93:    iColour = COLOUR_YELLOW;        break;
            case 94:    iColour = COLOUR_YELLOW;        break;
            case 95:    iColour = COLOUR_YELLOW;        break;
            case 96:    iColour = COLOUR_PURPLE;        break;
            case 97:    iColour = COLOUR_PURPLE;        break;
            case 98:    iColour = COLOUR_PURPLE;        break;
            case 99:    iColour = COLOUR_PURPLE;        break;
            case 100:   iColour = COLOUR_RED;           break;
            case 101:   iColour = COLOUR_RED;           break;
            case 102:   iColour = COLOUR_RED;           break;
            case 103:   iColour = COLOUR_RED;           break;
            case 104:   iColour = COLOUR_GREEN;         break;
            case 105:   iColour = COLOUR_GREEN;         break;
            case 106:   iColour = COLOUR_GREEN;         break;
            case 107:   iColour = COLOUR_GREEN;         break;
            case 108:   iColour = COLOUR_GREEN;         break;
            case 109:   iColour = COLOUR_GREEN;         break;
            case 110:   iColour = COLOUR_GREEN;         break;
            case 111:   iColour = COLOUR_GREEN;         break;
            case 112:   iColour = COLOUR_BROWN;         break;
            case 113:   iColour = COLOUR_BROWN;         break;
            case 114:   iColour = COLOUR_BROWN;         break;
            case 115:   iColour = COLOUR_BROWN;         break;
            case 116:   iColour = COLOUR_RED;           break;
            case 117:   iColour = COLOUR_RED;           break;
            case 118:   iColour = COLOUR_RED;           break;
            case 119:   iColour = COLOUR_RED;           break;
            case 120:   iColour = COLOUR_BROWN;         break;
            case 121:   iColour = COLOUR_BROWN;         break;
            case 122:   iColour = COLOUR_BROWN;         break;
            case 123:   iColour = COLOUR_BROWN;         break;
            case 124:   iColour = COLOUR_BROWN;         break;
            case 125:   iColour = COLOUR_BROWN;         break;
            case 126:   iColour = COLOUR_BROWN;         break;
            case 127:   iColour = COLOUR_BROWN;         break;
            case 128:   iColour = COLOUR_BROWN;         break;
            case 129:   iColour = COLOUR_BROWN;         break;
            case 130:   iColour = COLOUR_BROWN;         break;
            case 131:   iColour = COLOUR_BROWN;         break;
            case 132:   iColour = COLOUR_BLUE;          break;
            case 133:   iColour = COLOUR_BLUE;          break;
            case 134:   iColour = COLOUR_BLUE;          break;
            case 135:   iColour = COLOUR_BLUE;          break;
            case 136:   iColour = COLOUR_BLUE;          break;
            case 137:   iColour = COLOUR_BLUE;          break;
            case 138:   iColour = COLOUR_BLUE;          break;
            case 139:   iColour = COLOUR_BLUE;          break;
            case 140:   iColour = COLOUR_BLUE;          break;
            case 141:   iColour = COLOUR_BLUE;          break;
            case 142:   iColour = COLOUR_BLUE;          break;
            case 143:   iColour = COLOUR_BLUE;          break;
            case 144:   iColour = COLOUR_PURPLE;        break;
            case 145:   iColour = COLOUR_PURPLE;        break;
            case 146:   iColour = COLOUR_PURPLE;        break;
            case 147:   iColour = COLOUR_PURPLE;        break;
            case 148:   iColour = COLOUR_BLUE;          break;
            case 149:   iColour = COLOUR_BLUE;          break;
            case 150:   iColour = COLOUR_BLUE;          break;
            case 151:   iColour = COLOUR_BLUE;          break;
            case 152:   iColour = COLOUR_GREEN;         break;
            case 153:   iColour = COLOUR_GREEN;         break;
            case 154:   iColour = COLOUR_BROWN;         break;
            case 155:   iColour = COLOUR_BROWN;         break;
            case 156:   iColour = COLOUR_ORANGE;        break;
            case 157:   iColour = COLOUR_ORANGE;        break;
            case 158:   iColour = COLOUR_PURPLE;        break;
            case 159:   iColour = COLOUR_PURPLE;        break;
            case 160:   iColour = COLOUR_PURPLE;        break;
            case 161:   iColour = COLOUR_PURPLE;        break;
            case 162:   iColour = COLOUR_PURPLE;        break;
            case 163:   iColour = COLOUR_PURPLE;        break;
            case 164:   iColour = COLOUR_BLACK;         break;
            case 165:   iColour = COLOUR_BLUE;          break;
            case 166:   iColour = COLOUR_BLACK;         break;
            case 167:   iColour = COLOUR_GREEN;         break;
            case 168:   iColour = COLOUR_GREEN;         break;
            case 169:   iColour = COLOUR_GREEN;         break;
            case 170:   iColour = COLOUR_BLUE;          break;
            case 171:   iColour = COLOUR_BLUE;          break;
            case 172:   iColour = COLOUR_GREEN;         break;
            case 173:   iColour = COLOUR_BROWN;         break;
            case 174:   iColour = COLOUR_BROWN;         break;
            case 175:   iColour = COLOUR_SPECIAL;       break;
            }
        }

    return iColour;
}



int GetNextTail(object oUnit, int iChange)
{
    int iMax = GetLocalInt(oDesk, "maxpiecetail");
    int iPiece = GetCreatureTailType(oUnit);
    int bValid = FALSE;

    while (!bValid)
        {
        // Get the next piece
        iPiece += iChange;

        // Wrap around if necessary
        if      (iPiece < 0)    { iPiece = iMax; }
        else if (iPiece > iMax) { iPiece = 0;    }

        string sTest = Get2DAString("tailmodel", "valid", iPiece);

        if (sTest == "1")       { bValid = TRUE; }
        }

    return iPiece;
}



int GetNextWing(object oUnit, int iChange)
{
    int iMax = GetLocalInt(oDesk, "maxpiecetail");
    int iPiece = GetCreatureWingType(oUnit);
    int bValid = FALSE;

    while (!bValid)
        {
        // Get the next piece
        iPiece += iChange;

        // Wrap around if necessary
        if      (iPiece < 0)    { iPiece = iMax; }
        else if (iPiece > iMax) { iPiece = 0;    }

        string sTest = Get2DAString("tailmodel", "valid", iPiece);

        if (sTest == "1")       { bValid = TRUE; }
        }

    return iPiece;
}



int GetNextHead(object oUnit, int iChange)
{
    int iPiece = GetCreatureBodyPart(CREATURE_PART_HEAD,oUnit);
    int iRace = GetRacialType(oUnit);
    int iPheno = GetPhenoType(oUnit);
    int iGender = GetGender(oUnit);

    // Half-Elf and Human pieces identical
    if (iRace == 6)     { iRace = 4; }

    // Find the right column in the 2da file
    string sColumn = "RACE" + IntToString(iRace) + IntToString(iGender);

    int bValid = FALSE;

    while (!bValid)
        {
        // Get the next piece
        iPiece += iChange;

        // Wrap around if necessary
        if      (iPiece < 0)    { iPiece = 199; }
        else if (iPiece > 199)  { iPiece = 0;   }

        string sPheno = Get2DAString("parts_head", sColumn, iPiece);

        DebugSpeakString("Head " + IntToString(iPiece) + " registers as requiring phenotype " + sPheno + ", and wearer is gender " + IntToString(iPheno));

        if (sPheno == "3"
        || (StringToInt(sPheno) == 1 && iPheno == PHENOTYPE_NORMAL)
        || (StringToInt(sPheno) == 2 && iPheno == PHENOTYPE_BIG))
            { bValid = TRUE; }
        }

    return iPiece;
}



int GetNextHorse(object oUnit, int iChangeType, int iChange)
{
    // Get the current mount and determine its type
    int iPiece = GetCreatureTailType(oUnit);
    string sType = Get2DAString("tailmodel", "VALID", iPiece);

    int iMax = GetLocalInt(oDesk, "maxpiecetail");
    int bValid = FALSE;

    // If we're changing our horse's equipment
    if (iChangeType == HORSE_EQUIPMENT)
        {
        while (!bValid)
            {
            // Get the next piece
            iPiece += iChange;

            // Wrap around if necessary
            if      (iPiece < 0)    { iPiece = iMax; }
            else if (iPiece > iMax) { iPiece = 0;    }

            string sTest = Get2DAString("tailmodel", "valid", iPiece);

            if (sTest == sType)     { bValid = TRUE; }
            }
        }

    // If we're changing our horse's type
    else if (iChangeType == HORSE_TYPE)
        {
        // Find the next and last valid horse type
        int iNewType = StringToInt(sType) + iChange;
        int iMaxType = GetLocalInt(oDesk, "maxpiecehorse");

        // Cycle round if we go below 2 (first horse) or above max valid horse type
        if      (iNewType < 2)          { iNewType = iMaxType; }
        else if (iNewType > iMaxType)   { iNewType = 2; }

        string sNewType = IntToString(iNewType);

        while (!bValid)
            {
            // Get the next piece
            iPiece += iChange;

            // Wrap around if necessary
            if      (iPiece < 0)        { iPiece = iMax; }
            else if (iPiece > iMax)     { iPiece = 0;    }

            string sTest = Get2DAString("tailmodel", "valid", iPiece);

            // If we've found the right horse type...
            if (sTest == sNewType)      { bValid = TRUE; }
            }
        }

    return iPiece;
}



int GetACByChestPiece(int iPiece)
{
    int iAC = -1;
    string sAC = Get2DAString("PARTS_CHEST", "ACBONUS", iPiece);

    DebugSpeakString("AC of chest piece " + IntToString(iPiece) + " is " + sAC);

    if (sAC != "" && sAC != "****")                     iAC = StringToInt(sAC);

    return iAC;
}



string GetFileForPart(int iPart)
{
    string sPart = "";

    switch (iPart)
        {
        case ITEM_APPR_ARMOR_MODEL_LBICEP:      sPart = "PARTS_BICEP";          break;
        case ITEM_APPR_ARMOR_MODEL_LFOOT:       sPart = "PARTS_FOOT";           break;
        case ITEM_APPR_ARMOR_MODEL_LFOREARM:    sPart = "PARTS_FOREARM";        break;
        case ITEM_APPR_ARMOR_MODEL_LHAND:       sPart = "PARTS_HAND";           break;
        case ITEM_APPR_ARMOR_MODEL_LSHIN:       sPart = "PARTS_SHIN";           break;
        case ITEM_APPR_ARMOR_MODEL_LSHOULDER:   sPart = "PARTS_SHOULDER";       break;
        case ITEM_APPR_ARMOR_MODEL_LTHIGH:      sPart = "PARTS_LEGS";           break;
        case ITEM_APPR_ARMOR_MODEL_RBICEP:      sPart = "PARTS_BICEP";          break;
        case ITEM_APPR_ARMOR_MODEL_RFOOT:       sPart = "PARTS_FOOT";           break;
        case ITEM_APPR_ARMOR_MODEL_RFOREARM:    sPart = "PARTS_FOREARM";        break;
        case ITEM_APPR_ARMOR_MODEL_RHAND:       sPart = "PARTS_HAND";           break;
        case ITEM_APPR_ARMOR_MODEL_RSHIN:       sPart = "PARTS_SHIN";           break;
        case ITEM_APPR_ARMOR_MODEL_RSHOULDER:   sPart = "PARTS_SHOULDER";       break;
        case ITEM_APPR_ARMOR_MODEL_RTHIGH:      sPart = "PARTS_LEGS";           break;
        case ITEM_APPR_ARMOR_MODEL_BELT:        sPart = "PARTS_BELT";           break;
        case ITEM_APPR_ARMOR_MODEL_NECK:        sPart = "PARTS_NECK";           break;
        case ITEM_APPR_ARMOR_MODEL_PELVIS:      sPart = "PARTS_PELVIS";         break;
        case ITEM_APPR_ARMOR_MODEL_ROBE:        sPart = "PARTS_ROBE";           break;
        case ITEM_APPR_ARMOR_MODEL_TORSO:       sPart = "PARTS_CHEST";          break;
        case ITEM_APPR_ARMOR_MODEL_CLOAK:       sPart = "CLOAKMODEL";           break;
        }

    return sPart;
}




int IsPieceValidForGender(string sFile, int iPiece, int iGender)
{
    // CHECK GENDER SUITABILITY
        // 0 = male, 1 = female, 2 = both

    string sGender = Get2DAString(sFile, "GENDER", iPiece);

    DebugSpeakString(sFile + " piece " + IntToString(iPiece) + " registers as requiring gender " + sGender + ", and wearer is gender " + IntToString(iGender));

    int bValid = FALSE;

    if (sGender == "2" || StringToInt(sGender) == iGender)
        { bValid = TRUE; }

    return bValid;
}



int IsPieceValidForType(string sFile, int iPiece, int iRace, int iPheno)
{
    // CHECK RACE / PHENOTYPE SUITABILITY
        // 0 = dwarf, 1 = elf, 2 = gnome, 3 = halfling, 4 = half-elf, 5 = half-orc, 6 = human
        // 0 = neither, 1 = normal, 2 = large, 3 = both

    // Half-Elf and Human pieces identical
    if (iRace == 6)     { iRace = 4; }

    string sPheno = Get2DAString(sFile, "RACE" + IntToString(iRace), iPiece);

    DebugSpeakString(sFile + " piece " + IntToString(iPiece) + " registers as requiring pheno " + sPheno + " for race " + IntToString(iRace) + ", and wearer is pheno " + IntToString(iPheno));

    int bValid = FALSE;

    if  (sPheno == "3"
    || ((iPheno == PHENOTYPE_NORMAL || iPheno == PHENOTYPE_NORMAL + 3) && sPheno == "1")
    || ((iPheno == PHENOTYPE_BIG    || iPheno == PHENOTYPE_BIG    + 3) && sPheno == "2"))
        { bValid = TRUE; }

    return bValid;
}



object SetCloakTransparency(object oPC, object oNewArmour, object oOldArmour)
{
    string sNew = Get2DAString("cloakmodel","TRANSPARENT",GetItemAppearance(oNewArmour,ITEM_APPR_TYPE_SIMPLE_MODEL,0));
    string sOld = Get2DAString("cloakmodel","TRANSPARENT",GetItemAppearance(oOldArmour,ITEM_APPR_TYPE_SIMPLE_MODEL,0));
    int iNew = StringToInt(sNew);
    int iOld = StringToInt(sOld);

    DebugSpeakString("New cloak is " + IntToString(GetItemAppearance(oNewArmour,ITEM_APPR_TYPE_SIMPLE_MODEL,0)) + ", transparent = " + sNew);
    DebugSpeakString("Old cloak is " + IntToString(GetItemAppearance(oOldArmour,ITEM_APPR_TYPE_SIMPLE_MODEL,0)) + ", transparent = " + sOld);

    // If the new cloak is transparent on a different channel to the old one
    if (sNew != sOld)
        {
        if (sNew != "")
            {
            DebugSpeakString("Making cloak invisible on channel " + sNew);
            SetLocalInt(oPC,"tempcloakcolour" + sNew,GetItemAppearance(oNewArmour,ITEM_APPR_TYPE_ARMOR_COLOR,iNew));

            object oNewNewArmour = ModifyItem(oNewArmour,ITEM_APPR_TYPE_ARMOR_COLOR,iNew,61);
            DestroyObject(oNewArmour);
            oNewArmour = oNewNewArmour;
            }

        if (sOld != "")
            {
            DebugSpeakString("Making cloak visible on channel " + sOld);
            int iColour = GetLocalInt(oPC,"tempcloakcolour" + sOld);

            object oNewNewArmour = ModifyItem(oNewArmour,ITEM_APPR_TYPE_ARMOR_COLOR,iOld,iColour);
            DestroyObject(oNewArmour);
            oNewArmour = oNewNewArmour;
            }
        }

    return oNewArmour;
}



void MakeCloakValidForCharacter(object oCloak, object oWearer)
{
    int iGender = GetGender(oWearer);
    int iPheno = GetPhenoType(oWearer);
    int iRace = GetRacialType(oWearer);
    int iPart;

    object oNewCloak;

    int iPiece = GetItemAppearance(oCloak,ITEM_APPR_TYPE_SIMPLE_MODEL,0);
    string sFile = "CLOAKMODEL";

    // If this piece isn't valid for some reason
    if (!(IsPieceValidForGender(sFile, iPiece, iGender)
       && IsPieceValidForType(sFile, iPiece, iRace, iPheno)))
        {
        // Find the next valid piece
        iPiece = GetNextCloakPiece(ITEM_APPR_ARMOR_MODEL_CLOAK, oCloak, 1, oWearer);

        oNewCloak = ModifyItem(oCloak,ITEM_APPR_TYPE_ARMOR_MODEL,iPart,iPiece);
        DestroyObject(oCloak);
        oCloak = oNewCloak;
        }

    // Put the new cloak on
    EquipItem(oCloak,oWearer);
}



int IsCloakValidForCharacter(object oCloak, int iGender, int iRace, int iPheno)
{
    int iPiece = GetItemAppearance(oCloak,ITEM_APPR_TYPE_SIMPLE_MODEL,0);
    string sFile = "CLOAKMODEL";

    int bValid = FALSE;

    if (IsPieceValidForGender(sFile, iPiece, iGender)
    &&  IsPieceValidForType(sFile, iPiece, iRace, iPheno))
        {
        bValid = TRUE;
        }

    return bValid;
}



void MakeArmourValidForCharacter(object oArmour, object oWearer)
{
    int iGender = GetGender(oWearer);
    int iPheno = GetPhenoType(oWearer);
    int iRace = GetRacialType(oWearer);
    int iPart;

    object oNewArmour;

    // Cycle through every piece of the character's armour
    for (iPart = ITEM_APPR_ARMOR_MODEL_RFOOT; iPart <= ITEM_APPR_ARMOR_MODEL_ROBE; iPart++)
        {
        int iPiece = GetItemAppearance(oArmour,ITEM_APPR_TYPE_ARMOR_MODEL,iPart);
        string sFile = GetFileForPart(iPart);

        // If this piece isn't valid for some reason
        if (!IsPieceValidForGender(sFile, iPiece, iGender)
        ||  !IsPieceValidForType(sFile, iPiece, iRace, iPheno))
            {
            // Find the next valid piece
            iPiece = GetNextPiece(oWearer,iPart,oArmour,1);

            oNewArmour = ModifyItem(oArmour,ITEM_APPR_TYPE_ARMOR_MODEL,iPart,iPiece);
            DestroyObject(oArmour);
            oArmour = oNewArmour;
            }
        }

    // Put the new armour on
    EquipItem(oArmour,oWearer);
}



int IsArmourValidForCharacter(object oArmour, int iGender, int iRace, int iPheno)
{
    int bValid = TRUE;
    int iPart;

    // Cycle through every piece of the character's armour
    for (iPart = ITEM_APPR_ARMOR_MODEL_RFOOT; iPart <= ITEM_APPR_ARMOR_MODEL_ROBE; iPart++)
        {
        int iPiece = GetItemAppearance(oArmour,ITEM_APPR_TYPE_ARMOR_MODEL,iPart);
        string sFile = GetFileForPart(iPart);

        if (!(IsPieceValidForGender(sFile, iPiece, iGender)
          && IsPieceValidForType(sFile, iPiece, iRace, iPheno)))
            {
            bValid = FALSE;
            break;
            }
        }

    return bValid;
}



int IsPieceValidForCharacter(string sFile, int iPiece, object oPC)
{
    int bValid = FALSE;

    if (IsPieceValidForGender(sFile, iPiece, GetGender(oPC))
    &&  IsPieceValidForType(sFile, iPiece, GetRacialType(oPC), GetPhenoType(oPC)))
        { bValid = TRUE; }

    return bValid;
}


int GetACByPiece(string sFile, int iPiece, object oPC)
{
    int iAC = -1;
    string sAC = Get2DAString(sFile, "ACBONUS", iPiece);

    if (sAC != "" && sAC != "****")
        {
        if (IsPieceValidForCharacter(sFile,iPiece,oPC))
            {
            iAC = StringToInt(sAC);
            DebugSpeakString("AC for this piece is " + IntToString(iAC));
            }
        }

    return iAC;
}



int IsRobeValid(string sArmourType, int iPiece, object oPC)
{
    int bValid = FALSE;
    int iAC = GetACByPiece("PARTS_ROBE", iPiece, oPC);

    DebugSpeakString("sArmourType is " + sArmourType);

    // If the armour is missing or not suitable for this character, return invalid
    if (iAC <  0)                                       bValid = FALSE;

    // If the robe doesn't hide the chest, just make sure its AC isn't too high
    else if (StringToInt(Get2DAString("PARTS_ROBE", "HIDECHEST", iPiece)) == 0)
        {
        if      (sArmourType == "ac0c" && iAC <= 0)     bValid = TRUE;
        else if (sArmourType == "ac0r" && iAC <= 0)     bValid = TRUE;
        else if (sArmourType == "ac0"  && iAC <= 0)     bValid = TRUE;
        else if (sArmourType == "ac1"  && iAC <= 1)     bValid = TRUE;
        else if (sArmourType == "ac2"  && iAC <= 2)     bValid = TRUE;
        else if (sArmourType == "ac3"  && iAC <= 3)     bValid = TRUE;
        else if (sArmourType == "ac4"  && iAC <= 4)     bValid = TRUE;
        else if (sArmourType == "ac5"  && iAC <= 5)     bValid = TRUE;
        else if (sArmourType == "ac6"  && iAC <= 6)     bValid = TRUE;
        else if (sArmourType == "ac7"  && iAC <= 7)     bValid = TRUE;
        else if (sArmourType == "ac8"  && iAC <= 8)     bValid = TRUE;
        }

    // Otherwise check the AC is exactly correct
    else if (sArmourType == "ac0c" && iAC == 0)         bValid = TRUE;
    else if (sArmourType == "ac0r" && iAC == 0)         bValid = TRUE;
    else if (sArmourType == "ac0"  && iAC == 0)         bValid = TRUE;
    else if (sArmourType == "ac1"  && iAC == 1)         bValid = TRUE;
    else if (sArmourType == "ac2"  && iAC == 2)         bValid = TRUE;
    else if (sArmourType == "ac3"  && iAC == 3)         bValid = TRUE;
    else if (sArmourType == "ac4"  && iAC == 4)         bValid = TRUE;
    else if (sArmourType == "ac5"  && iAC == 5)         bValid = TRUE;
    else if (sArmourType == "ac6"  && iAC == 6)         bValid = TRUE;
    else if (sArmourType == "ac7"  && iAC == 7)         bValid = TRUE;
    else if (sArmourType == "ac8"  && iAC == 8)         bValid = TRUE;

    return bValid;
}



int IsTorsoValid(string sArmourType, int iPiece, object oPC)
{
    int bValid = FALSE;
    int iAC = GetACByPiece("PARTS_CHEST", iPiece, oPC);

    DebugSpeakString("AC needed for this piece is " + sArmourType);

    if                               (iAC <  0)         bValid = FALSE;
    else if (sArmourType == "ac0c" && iAC == 0)         bValid = TRUE;
    else if (sArmourType == "ac0r" && iAC == 0)         bValid = TRUE;
    else if (sArmourType == "ac1"  && iAC == 1)         bValid = TRUE;
    else if (sArmourType == "ac2"  && iAC == 2)         bValid = TRUE;
    else if (sArmourType == "ac3"  && iAC == 3)         bValid = TRUE;
    else if (sArmourType == "ac4"  && iAC == 4)         bValid = TRUE;
    else if (sArmourType == "ac5"  && iAC == 5)         bValid = TRUE;
    else if (sArmourType == "ac6"  && iAC == 6)         bValid = TRUE;
    else if (sArmourType == "ac7"  && iAC == 7)         bValid = TRUE;
    else if (sArmourType == "ac8"  && iAC == 8)         bValid = TRUE;

    return bValid;
}



int IsPieceValid(string sFile, int iPiece, object oPC)
{
    int bValid = TRUE;

    string sPiece = Get2DAString(sFile, "ACBONUS", iPiece);

    if      (sPiece == "")                                              { bValid = FALSE; }
    else if (sPiece == "****")                                          { bValid = FALSE; }
    else if (!IsPieceValidForCharacter(sFile,iPiece,oPC))               { bValid = FALSE; }

    return bValid;
}



int IsArmourPieceValid(int iPart, int iPiece, string sArmourType, object oPC)
{
    int bValid = TRUE;

    switch (iPart)
        {
        case ITEM_APPR_ARMOR_MODEL_ROBE:    bValid = IsRobeValid (sArmourType,          iPiece,     oPC);   break;
        case ITEM_APPR_ARMOR_MODEL_TORSO:   bValid = IsTorsoValid(sArmourType,          iPiece,     oPC);   break;
        default:                            bValid = IsPieceValid(GetFileForPart(iPart),iPiece,     oPC);   break;
        }

    return bValid;
}



int GetNextArmourPiece(int iPart, object oArmour, int iChange, object oPC, object oWearer)
{
    int iPiece = GetItemAppearance(oArmour,ITEM_APPR_TYPE_ARMOR_MODEL,iPart);
    string sArmourType = GetLocalString(oPC,"fittingarmour");

    // If no armour type has been specified, figure it out!
    if (sArmourType == "")
        {
        int iChestPiece = GetItemAppearance(oArmour,ITEM_APPR_TYPE_ARMOR_MODEL,ITEM_APPR_ARMOR_MODEL_TORSO);
        int iAC = GetACByChestPiece(iChestPiece);
        sArmourType = "ac" + IntToString(iAC);
        }

    // If no wearer is specified, it must be the PC
    if (oWearer == OBJECT_INVALID)  { oWearer = oPC; }

    int iMax = GetLocalInt(GetObjectByTag("brief_desk"), "maxpiece" + IntToString(iPart));
    int iMin = 0;

    int bValidPieceFound = FALSE;

    DebugSpeakString("Character " + GetName(oWearer) + " is race " + IntToString(GetRacialType(oWearer)) + ", gender " + IntToString(GetGender(oWearer)) + ", pheno " + IntToString(GetPhenoType(oWearer)));

    while (!bValidPieceFound)
        {
        // Get the next piece
        iPiece += iChange;

        // Cycle round if necessary
        if      (iPiece > iMax)     { iPiece = iMin; }
        else if (iPiece < iMin)     { iPiece = iMax; }

        // Check if this piece is valid for the armour type selected
        bValidPieceFound = IsArmourPieceValid(iPart,iPiece,sArmourType,oWearer);
        }

    return iPiece;
}



int GetNextCloakPiece(int iPart, object oArmour, int iChange, object oWearer)
{
    int iPiece = GetItemAppearance(oArmour,ITEM_APPR_TYPE_SIMPLE_MODEL,0);
    int iMax = GetLocalInt(GetObjectByTag("brief_desk"), "maxpiece" + IntToString(iPart));
    int iMin = 0;
    int bValidPieceFound = FALSE;

    DebugSpeakString("Character " + GetName(oWearer) + " is race " + IntToString(GetRacialType(oWearer)) + ", gender " + IntToString(GetGender(oWearer)) + ", pheno " + IntToString(GetPhenoType(oWearer)));

    while (!bValidPieceFound)
        {
        // Get the next piece
        iPiece += iChange;

        // Cycle round if necessary
        if      (iPiece > iMax)     { iPiece = iMin; }
        else if (iPiece < iMin)     { iPiece = iMax; }

        // Check if this piece is valid for the armour type selected
        bValidPieceFound = IsPieceValidForCharacter("CLOAKMODEL",iPiece,oWearer);
        }

    return iPiece;
}



int GetNextSimplePiece(int iPart, object oArmour, int iChange, int iColour)
{
    int iPiece = GetItemAppearance(oArmour,ITEM_APPR_TYPE_SIMPLE_MODEL,iPart);
    int iType = GetBaseItemType(oArmour);
    int bValidPieceFound = FALSE;

    string sColour = IntToString(iColour);

    // If no colour was specified, default to current one, and use 1 if none is found
    if (sColour == "0")             { sColour = Get2DAString("accessoryparts", IntToString(iType), iPiece); }
    if (sColour == "")              { sColour = "1"; }

    while (!bValidPieceFound)
        {
        // Get the next piece
        iPiece += iChange;

        DebugSpeakString("GetNextSimplePiece found piece on row " + IntToString(iPiece) + " with colour " + Get2DAString("accessoryparts", IntToString(iType), iPiece));

        // Cycle round if necessary
        if      (iPiece > 255)      { iPiece = 0; }
        else if (iPiece < 0)        { iPiece = 255; }

        // Check if this piece is valid for the armour type selected
        if (Get2DAString("accessoryparts", IntToString(iType), iPiece) == sColour)
            { bValidPieceFound = TRUE; }
        }

    DebugSpeakString("GetNextSimplePiece found valid piece with colour " + sColour + " at row " + IntToString(iPiece));

    return iPiece;
}



int GetIPBrightness(int iBonus)
{
    int iBright;

    switch(iBonus)
    {
        case 1:                                         iBright = IP_CONST_LIGHTBRIGHTNESS_DIM;         break;
        case 2:                                         iBright = IP_CONST_LIGHTBRIGHTNESS_LOW;         break;
        case 3:                                         iBright = IP_CONST_LIGHTBRIGHTNESS_NORMAL;      break;
        case 4:                                         iBright = IP_CONST_LIGHTBRIGHTNESS_BRIGHT;      break;
    }

    return iBright;
}



int GetIPWeightReduction(int iBonus)
{
    int iWeight;

    switch(iBonus)
    {
        case 1:                                         iWeight = IP_CONST_REDUCEDWEIGHT_80_PERCENT;    break;
        case 2:                                         iWeight = IP_CONST_REDUCEDWEIGHT_60_PERCENT;    break;
        case 3:                                         iWeight = IP_CONST_REDUCEDWEIGHT_40_PERCENT;    break;
        case 4:                                         iWeight = IP_CONST_REDUCEDWEIGHT_20_PERCENT;    break;
        case 5:                                         iWeight = IP_CONST_REDUCEDWEIGHT_10_PERCENT;    break;
    }

    return iWeight;
}



int GetIPSpellResistance(int iBonus)
{
    int iResist;

    switch(iBonus)
    {
        case 1:                                         iResist = IP_CONST_SPELLRESISTANCEBONUS_10;     break;
        case 2:                                         iResist = IP_CONST_SPELLRESISTANCEBONUS_12;     break;
        case 3:                                         iResist = IP_CONST_SPELLRESISTANCEBONUS_14;     break;
        case 4:                                         iResist = IP_CONST_SPELLRESISTANCEBONUS_16;     break;
        case 5:                                         iResist = IP_CONST_SPELLRESISTANCEBONUS_18;     break;
        case 6:                                         iResist = IP_CONST_SPELLRESISTANCEBONUS_20;     break;
        case 7:                                         iResist = IP_CONST_SPELLRESISTANCEBONUS_22;     break;
        case 8:                                         iResist = IP_CONST_SPELLRESISTANCEBONUS_24;     break;
        case 9:                                         iResist = IP_CONST_SPELLRESISTANCEBONUS_26;     break;
        case 10:                                        iResist = IP_CONST_SPELLRESISTANCEBONUS_28;     break;
    }

    return iResist;
}


int GetDamageBonus(int iBonus)
{
    int iDamage = 0;

    switch (iBonus)
    {
        case 1:                                         iDamage = IP_CONST_DAMAGEBONUS_1;               break;
        case 2:                                         iDamage = IP_CONST_DAMAGEBONUS_2;               break;
        case 3:                                         iDamage = IP_CONST_DAMAGEBONUS_3;               break;
        case 4:                                         iDamage = IP_CONST_DAMAGEBONUS_4;               break;
        case 5:                                         iDamage = IP_CONST_DAMAGEBONUS_5;               break;
        case 6:                                         iDamage = IP_CONST_DAMAGEBONUS_6;               break;
        case 7:                                         iDamage = IP_CONST_DAMAGEBONUS_7;               break;
        case 8:                                         iDamage = IP_CONST_DAMAGEBONUS_8;               break;
        case 9:                                         iDamage = IP_CONST_DAMAGEBONUS_9;               break;
        case 10:                                        iDamage = IP_CONST_DAMAGEBONUS_10;              break;
        case 11:                                        iDamage = IP_CONST_DAMAGEBONUS_1d4;             break;
        case 12:                                        iDamage = IP_CONST_DAMAGEBONUS_1d6;             break;
        case 13:                                        iDamage = IP_CONST_DAMAGEBONUS_1d8;             break;
        case 14:                                        iDamage = IP_CONST_DAMAGEBONUS_1d10;            break;
        case 15:                                        iDamage = IP_CONST_DAMAGEBONUS_1d12;            break;
        case 16:                                        iDamage = IP_CONST_DAMAGEBONUS_2d8;             break;
        case 17:                                        iDamage = IP_CONST_DAMAGEBONUS_2d10;            break;
        case 18:                                        iDamage = IP_CONST_DAMAGEBONUS_2d12;            break;
    }

    return iDamage;
}



void ChangeName(object oItem, int iBonus)
{
    string sName = GetName(oItem);
    int iPosition = FindSubString(sName,"+");

    // Item doesn't have a bonus in its name yet, so add one to it
    if (iPosition == -1)
    {
        sName = sName + " +" + IntToString(iBonus);
    }
    // Item does have a bonus in its name, so change it
    // Note this will remove anything after the + sign, which is fine for all standard NWN and GvE items
        // but may cause problems for custom items imported from other mods if they have unusual names
    else
    {
        string sPrefix = GetSubString(sName,0,iPosition);
        sName = sPrefix + "+" + IntToString(iBonus);
    }

    SetName(oItem,sName);
}



int GetIsRangedWeapon(object oItem)
{
    int bRanged = FALSE;
    int iType = GetBaseItemType(oItem);

    if (iType == BASE_ITEM_HEAVYCROSSBOW
     || iType == BASE_ITEM_LIGHTCROSSBOW
     || iType == BASE_ITEM_LONGBOW
     || iType == BASE_ITEM_SHORTBOW
     || iType == BASE_ITEM_SLING)
        { bRanged = TRUE; }

    return bRanged;
}



itemproperty GestaltEnhanceBonus(object oItem, int iBonus)
{
    itemproperty ipBonus;

    if (GetBaseItemType(oItem) == BASE_ITEM_GLOVES)     { ipBonus = ItemPropertyAttackBonus(iBonus); }
    else if (GetIsRangedWeapon(oItem))                  { ipBonus = ItemPropertyAttackBonus(iBonus); }
    else                                                { ipBonus = ItemPropertyEnhancementBonus(iBonus); }

    return ipBonus;
}



void GestaltRemoveItemProperty(object oItem, itemproperty ipRemove, int bCheckSubType)
{
    // Get rid of similar properties first
    itemproperty ipTest = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ipTest))
    {
        if (GetItemPropertyType(ipTest) == GetItemPropertyType(ipRemove))
        {
            if (!bCheckSubType || GetItemPropertySubType(ipTest) == GetItemPropertySubType(ipRemove))
                { RemoveItemProperty(oItem,ipTest); }
        }

        ipTest = GetNextItemProperty(oItem);
    }
}



void GestaltAddItemProperty(object oItem, object oPC, int iBonus)
{
    int iProperty = GetLocalInt(oPC,"fittingproperty");
    int iSubType = GetLocalInt(oPC,"fittingpropertysubtype");
    int iCharges;

    itemproperty ipBonus;
    int bCheckSubType = FALSE;

    switch(iProperty)
    {
        case ITEM_PROPERTY_AC_BONUS:                    ipBonus = ItemPropertyACBonus(iBonus);
                                                        ChangeName(oItem,iBonus);                                                   break;
        case ITEM_PROPERTY_ABILITY_BONUS:               ipBonus = ItemPropertyAbilityBonus(iSubType,iBonus);
                                                        bCheckSubType = TRUE;                                                       break;
        case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N: ipBonus = ItemPropertyBonusLevelSpell(iSubType, iBonus - 1);                break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:           ipBonus = GestaltEnhanceBonus(oItem,iBonus);
                                                        ChangeName(oItem,iBonus);                                                   break;
        case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:  ipBonus = ItemPropertyWeightReduction(GetIPWeightReduction(iBonus));        break;
        case ITEM_PROPERTY_CAST_SPELL:                  iCharges = GetLocalInt(oPC,"fittingpropertyspellcharges");
                                                        ipBonus = ItemPropertyCastSpell(iSubType,iCharges);
                                                        bCheckSubType = TRUE;                                                       break;
        case ITEM_PROPERTY_DAMAGE_BONUS:                ipBonus = ItemPropertyDamageBonus(iSubType,GetDamageBonus(iBonus + 10));
                                                        bCheckSubType = TRUE;                                                       break;
        case ITEM_PROPERTY_DAMAGE_RESISTANCE:           ipBonus = ItemPropertyDamageResistance(iSubType,iBonus);                    break;
        case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:         ipBonus = ItemPropertyFreeAction();                                         break;
        case ITEM_PROPERTY_HOLY_AVENGER:                ipBonus = ItemPropertyHolyAvenger();                                        break;
        case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:      ipBonus = ItemPropertyImmunityMisc(iSubType);                               break;
        case ITEM_PROPERTY_IMPROVED_EVASION:            ipBonus = ItemPropertyImprovedEvasion();                                    break;
        case ITEM_PROPERTY_KEEN:                        ipBonus = ItemPropertyKeen();                                               break;
        case ITEM_PROPERTY_LIGHT:                       ipBonus = ItemPropertyLight(GetIPBrightness(iBonus),iSubType);              break;
        case ITEM_PROPERTY_MASSIVE_CRITICALS:           ipBonus = ItemPropertyMassiveCritical(GetDamageBonus(iBonus + 10));         break;
        case ITEM_PROPERTY_MIGHTY:                      ipBonus = ItemPropertyMaxRangeStrengthMod(iBonus);                          break;
        case ITEM_PROPERTY_REGENERATION:                ipBonus = ItemPropertyRegeneration(iBonus);                                 break;
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:       ipBonus = ItemPropertyVampiricRegeneration(iBonus);                         break;
        case ITEM_PROPERTY_SAVING_THROW_BONUS:          ipBonus = ItemPropertyBonusSavingThrow(iSubType,iBonus);
                                                        bCheckSubType = TRUE;                                                       break;
        case ITEM_PROPERTY_SKILL_BONUS:                 ipBonus = ItemPropertySkillBonus(iSubType, iBonus * 2);                     break;
        case ITEM_PROPERTY_SPELL_RESISTANCE:            ipBonus = ItemPropertyBonusSpellResistance(GetIPSpellResistance(iBonus));   break;
    }

    // Get rid of similar properties first
    GestaltRemoveItemProperty(oItem,ipBonus,bCheckSubType);

    // Then add the new one
    AddItemProperty(DURATION_TYPE_PERMANENT,ipBonus,oItem);
}



void PutOnItem(object oArmour, object oPC, object oWearer)
{
    if (oWearer == OBJECT_INVALID)
        { oWearer = oPC; }

    string sArmourType = GetLocalString(oPC,"fittingarmour");

    if (sArmourType == "ach")
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_HEAD)); }
    else if (sArmourType == "acb")
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_ARMS)); }
    else if (sArmourType == "acg")
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_ARMS)); }
    else if (sArmourType == "acc")
        {
        if (oWearer == oPC)
            {
            AssignCommand(oPC,ActionWait(1.0));
            AssignCommand(oPC,ActionEquipItem(oArmour,INVENTORY_SLOT_CLOAK));
            }
        else
            {
            AssignCommand(oPC,ActionWait(1.0));
            DelayCommand(1.0,AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_CLOAK)));
            }
        }
    else if (sArmourType == "acss" || sArmourType == "acsl" || sArmourType == "acst")
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_LEFTHAND)); }
    else if (sArmourType == "belt")
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_BELT)); }
    else if (sArmourType == "boot")
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_BOOTS)); }
    else if (sArmourType == "neck")
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_NECK)); }
    else if (sArmourType == "ringl")
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_LEFTRING)); }
    else if (sArmourType == "ringr")
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_RIGHTRING)); }
    else
        { AssignCommand(oWearer,ActionEquipItem(oArmour,INVENTORY_SLOT_CHEST)); }
}



void CheckOldItem(object oPC, object oArmour)
{
    object oOldArmour = GetLocalObject(oPC,"fittingoldarmour");

    // If we didn't have room in the inventory and dropped our old armour
    if (GetIsObjectValid(oOldArmour) && GetItemPossessor(oOldArmour) != oPC)
    {
        // Copy the old armour back into the player's inventory and remove the one from the floor
        object oNewOldArmour = CopyItem(oOldArmour,oPC);
        SetLocalObject(oPC,"fittingoldarmour",oNewOldArmour);
        DestroyObject(oOldArmour);
        PutOnItem(oNewOldArmour, oPC);

        // Remove the new armour, which will cause the fitting to end
        DestroyObject(oArmour);
    }
    else
    {
        SetItemCursedFlag(oArmour,TRUE);

        // Store the new armour so we can find it again
        SetLocalObject(oPC,"fittingarmour",oArmour);

        // Save it so we can recreate it later if necessary
        StoreCampaignObject(dbItem,"armour",oArmour,oPC);
        SetCampaignInt(dbItem,"fittingarmour",1,oPC);
        SetCampaignInt(dbItem,"fittingarmourcost",GetGoldPieceValue(oArmour),oPC);
    }
}



void EquipItem(object oArmour, object oPC, object oWearer)
{
    if (oWearer == OBJECT_INVALID)
        { oWearer = oPC; }

    AssignCommand(oPC,ActionPauseConversation());

    PutOnItem(oArmour,oPC,oWearer);

    // If object is being put on a PC, make sure their inventory wasn't full!
    if (oWearer == oPC)
        {
        AssignCommand(oPC,ActionDoCommand(CheckOldItem(oPC,oArmour)));
        }

    // If object is being put on an NPC, make sure they don't drop it when they die!
    else
        {
        SetDroppableFlag(oArmour,FALSE);
        }

    AssignCommand(oPC,ActionResumeConversation());
}



string GetWeaponName(int iType)
{
    string sDescription = "an unrecognised object";

    switch (iType)
    {
        case BASE_ITEM_BASTARDSWORD:    sDescription = "a bastard sword";       break;
        case BASE_ITEM_BATTLEAXE:       sDescription = "a battle axe";          break;
        case BASE_ITEM_CLUB:            sDescription = "a club";                break;
        case BASE_ITEM_DAGGER:          sDescription = "a dagger";              break;
        case BASE_ITEM_DART:            sDescription = "a dart";                break;
        case BASE_ITEM_DIREMACE:        sDescription = "a dire mace";           break;
        case BASE_ITEM_DOUBLEAXE:       sDescription = "a double axe";          break;
        case BASE_ITEM_DWARVENWARAXE:   sDescription = "a dwarven axe";         break;
        case BASE_ITEM_GREATAXE:        sDescription = "a greataxe";            break;
        case BASE_ITEM_GREATSWORD:      sDescription = "a greatsword";          break;
        case BASE_ITEM_HALBERD:         sDescription = "a halberd";             break;
        case BASE_ITEM_HANDAXE:         sDescription = "a hand axe";            break;
        case BASE_ITEM_HEAVYCROSSBOW:   sDescription = "a heavy crossbow";      break;
        case BASE_ITEM_HEAVYFLAIL:      sDescription = "a heavy flail";         break;
        case BASE_ITEM_KAMA:            sDescription = "a kama";                break;
        case BASE_ITEM_KATANA:          sDescription = "a katana";              break;
        case BASE_ITEM_KUKRI:           sDescription = "a kukri";               break;
        case BASE_ITEM_LIGHTCROSSBOW:   sDescription = "a light crossbow";      break;
        case BASE_ITEM_LIGHTFLAIL:      sDescription = "a light flail";         break;
        case BASE_ITEM_LIGHTHAMMER:     sDescription = "a light hammer";        break;
        case BASE_ITEM_LIGHTMACE:       sDescription = "a mace";                break;
        case BASE_ITEM_LONGBOW:         sDescription = "a longbow";             break;
        case BASE_ITEM_LONGSWORD:       sDescription = "a longsword";           break;
        case BASE_ITEM_MORNINGSTAR:     sDescription = "a morningstar";         break;
        case BASE_ITEM_QUARTERSTAFF:    sDescription = "a quarterstaff";        break;
        case BASE_ITEM_RAPIER:          sDescription = "a rapier";              break;
        case BASE_ITEM_SCIMITAR:        sDescription = "a scimitar";            break;
        case BASE_ITEM_SCYTHE:          sDescription = "a scythe";              break;
        case BASE_ITEM_SHORTBOW:        sDescription = "a shortbow";            break;
        case BASE_ITEM_SHORTSPEAR:      sDescription = "a spear";               break;
        case BASE_ITEM_SHORTSWORD:      sDescription = "a shortsword";          break;
        case BASE_ITEM_SHURIKEN:        sDescription = "a shuriken";            break;
        case BASE_ITEM_SICKLE:          sDescription = "a sickle";              break;
        case BASE_ITEM_SLING:           sDescription = "a sling";               break;
        case BASE_ITEM_THROWINGAXE:     sDescription = "a throwing axe";        break;
        case BASE_ITEM_TRIDENT:         sDescription = "a trident";             break;
        case BASE_ITEM_TWOBLADEDSWORD:  sDescription = "a two bladed sword";    break;
        case BASE_ITEM_WARHAMMER:       sDescription = "a warhammer";           break;
        case BASE_ITEM_WHIP:            sDescription = "a whip";                break;
    }

    return sDescription;
}



int IsWeaponPieceValid(int iRow, int iPiece)
{
    string sTest = Get2DAString("weaponparts", IntToString(iPiece), iRow);
    return StringToInt(sTest);
}



object GetNextSimpleWeaponPiece(object oPC, object oWeapon, int iChange, object oUser)
{
    int iPiece = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_SIMPLE_MODEL,0);
    int iType = GetBaseItemType(oWeapon);
    int bValidPieceFound = FALSE;

    DebugSpeakString("Weapon piece number - before change - " + IntToString(iPiece));

    while (!bValidPieceFound)
        {
        // Get the next piece
        iPiece += iChange;

        // Cycle round if necessary
        if      (iPiece > 255)      { iPiece = 0; }
        else if (iPiece < 0)        { iPiece = 255; }

        // Check for valid piece
        if (Get2DAString("accessoryparts", IntToString(iType), iPiece) == "1")
                                    { bValidPieceFound = TRUE; }
        }

    DebugSpeakString("Weapon piece number - after change - " + IntToString(iPiece));

    // Create new weapon
    object oNewWeapon = ModifyItem(oWeapon,ITEM_APPR_TYPE_SIMPLE_MODEL,0,iPiece);

    // Store new weapon and remove original weapon
    SetLocalObject(oPC,"forgingweapon",oNewWeapon);
    DestroyObject(oWeapon);

    return oNewWeapon;
}



object SafeWeaponColourChange(object oOldWeapon, int iPart, int iColourRequired)
{
    // To be safe, change the model to 1 first, as that always works with all colours
    object oTempWeapon = ModifyItem(oOldWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,iPart,1);
    DestroyObject(oOldWeapon);
    oOldWeapon = oTempWeapon;

    // Then change the colour
    oTempWeapon = ModifyItem(oOldWeapon,ITEM_APPR_TYPE_WEAPON_COLOR,iPart,iColourRequired);
    DestroyObject(oOldWeapon);
    return oTempWeapon;
}



object GetNextWeaponPiece(object oPC, object oWeapon, int iPart, int iChange, object oUser)
{
    // Handle boots
    if      (iPart == ITEM_APPR_ARMOR_MODEL_BOOT_TOP)       { iPart = ITEM_APPR_WEAPON_MODEL_TOP; }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_BOOT_MIDDLE)    { iPart = ITEM_APPR_WEAPON_MODEL_MIDDLE; }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_BOOT_BOTTOM)    { iPart = ITEM_APPR_WEAPON_MODEL_BOTTOM; }

    int iType = GetBaseItemType(oWeapon);
    int iValidPieceFound = 0;
    int iPiece;

    // Icon-based weapons use a different function
    if (iType == BASE_ITEM_DART
     || iType == BASE_ITEM_SHURIKEN
     || iType == BASE_ITEM_SLING)                           { return GetNextSimpleWeaponPiece(oPC,oWeapon,iChange,oUser); }
    else                                                    { iPiece = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,iPart); }

    // If no user is specified, it must be the PC
    if (oUser == OBJECT_INVALID)  { oUser = oPC; }

    DebugSpeakString("Weapon piece number - before change - " + IntToString(iPiece));

    int iRow = GetLocalInt(oDesk, "weapon" + IntToString(iType) + IntToString(iPart));

    DebugSpeakString("Checking 2DA file entry for " + Get2DAString("weaponparts", "DESCRIPTION", iRow));

    while (iValidPieceFound == 0)
        {
        // Get the next piece
        iPiece += iChange;

        // Cycle round if necessary
        if      (iPiece > 25)     { iPiece = 0;  }
        else if (iPiece < 0)      { iPiece = 25; }

        // Check if this piece is valid for the weapon type selected
        iValidPieceFound = IsWeaponPieceValid(iRow,iPiece);
        }

    // If we had to change colour or other parts to match a set on the last change
    if (GetLocalInt(oPC,"tempweaponsave") > 0)
        {
        // Check which part we changed (offset by 1, because bottom piece is 0)
        int iLastPart = GetLocalInt(oPC,"tempweaponsave") - 1;

        // If we're still editing the same part of the object we were when we saved this temp weapon...
        if (iLastPart == iPart)
            {
            DebugSpeakString("Retrieving temporary saved weapon - last edit must have changed colour or other weapon parts automatically");

            // Just replace the current object with the old one
            DestroyObject(oWeapon);
            oWeapon = RetrieveCampaignObject(dbItem,"tempweaponsave",GetLocation(oUser),oUser,oPC);
            }

        // Otherwise...
        else
            {
            DebugSpeakString("Checking temporary saved weapon - last edit must have changed colour or other weapon parts automatically");

            // Check if the last bit we edited only works as part of a set and making this change will break it...
            int iLastRow = GetLocalInt(oDesk, "weapon" + IntToString(iType) + IntToString(iLastPart));
            int iLastPiece = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,iLastPart);
            int iCheck = IsWeaponPieceValid(iLastRow,iLastPiece);

            // If this piece only ModifyItemworks as part of a set
            if (iCheck >= 20)
                {
                DebugSpeakString("Retrieving temporary saved weapon - last edit changed other weapon parts");

                // Just replace the current object with the old one
                DestroyObject(oWeapon);
                oWeapon = RetrieveCampaignObject(dbItem,"tempweaponsave",GetLocation(oUser),oUser,oPC);
                }

            // If we only changed the colour
            else
                {
                DebugSpeakString("Discarding temporary saved weapon - last edit only changed colour");
                }
            }
        }

    DebugSpeakString("Weapon piece number - after change - " + IntToString(iPiece));

    object oOldWeapon = oWeapon;

    // If we're going to change the colour or other parts of the weapon to fit a set...
    if (iValidPieceFound > 10)
        {
        DebugSpeakString("Saving temporary weapon - must have changed colour or other weapon parts automatically");

        // Store the previous weapon so we can restore those settings on the next change
        StoreCampaignObject(dbItem,"tempweaponsave",oWeapon,oPC);

        // Remember which part we changed (offset by 1, because bottom piece is 0)
        SetLocalInt(oPC,"tempweaponsave",iPart + 1);
        }
    else
        {
        SetLocalInt(oPC,"tempweaponsave",0);
        }

    // Once we have a valid weapon piece, create the weapon
    object oNewWeapon;

    // If we need to change the colour to a particular value, do it before changing the model
    // Otherwise the model can disappear, causing the weapon to cease to exist!
    if (iValidPieceFound > 10 && iValidPieceFound < 15)
        {
        // Copy the item into our inventory to prevent multiple lost/acquired item msgs on player
        object oTempWeapon = CopyItem(oOldWeapon,OBJECT_SELF);
        DestroyObject(oOldWeapon);
        oOldWeapon = oTempWeapon;

        // Then modify the weapon
        oOldWeapon = SafeWeaponColourChange(oOldWeapon,iPart,iValidPieceFound - 10);
        oNewWeapon = ModifyItem(oOldWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,iPart,iPiece);

        // And finally copy it back to the player
        oTempWeapon = CopyItem(oNewWeapon,oUser);
        DestroyObject(oNewWeapon);
        DestroyObject(oOldWeapon);
        oNewWeapon = oTempWeapon;
        }

    // Weapon pieces that only work as sets are marked as 20 or higher in the 2da file
    else if (iValidPieceFound >= 20)
        {
        int iTest;

        // Copy the item into our inventory to prevent multiple lost/acquired item msgs on player
        object oTempWeapon = CopyItem(oOldWeapon,OBJECT_SELF);
        DestroyObject(oOldWeapon);
        oOldWeapon = oTempWeapon;

        // Cycle through all the weapon's parts
        for (iTest = ITEM_APPR_WEAPON_MODEL_BOTTOM; iTest <= ITEM_APPR_WEAPON_MODEL_TOP; iTest++)
            {
            int iTestRow = GetLocalInt(oDesk, "weapon" + IntToString(iType) + IntToString(iTest));
            int iTestValid = IsWeaponPieceValid(iTestRow,iPiece);

            // First check if we need to change the colour to a particular value
            if (iTestValid > 30 && iTestValid < 35)
                {
                oOldWeapon = SafeWeaponColourChange(oOldWeapon,iTest,iTestValid - 30);
                }

            // If this part needs to use a different numbered piece to match the set
            if (iValidPieceFound > 100 && iTestValid < 100)
                {
                oNewWeapon = ModifyItem(oOldWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,iTest,iValidPieceFound - 100);
                }

            // Otherwise, use the matching piece
            else
                {
                oNewWeapon = ModifyItem(oOldWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,iTest,iPiece);
                }

            // Clear the old weapon and reset for next loop
            DestroyObject(oOldWeapon);
            oOldWeapon = oNewWeapon;

            // Make the colours match as a set if necessary
            if (iTestValid == 35)
                {
                int iColourToMatch = GetItemAppearance(oNewWeapon,ITEM_APPR_TYPE_WEAPON_COLOR,iPart);
                oNewWeapon = ModifyItem(oOldWeapon,ITEM_APPR_TYPE_WEAPON_COLOR,iTest,iColourToMatch);
                DestroyObject(oOldWeapon);
                oOldWeapon = oNewWeapon;
                }
            }

        // And finally copy it back to the player
        oTempWeapon = CopyItem(oNewWeapon,oUser);
        DestroyObject(oNewWeapon);
        oNewWeapon = oTempWeapon;
        }

    // Otherwise just do a straight replace
    else
        {
        oNewWeapon = ModifyItem(oOldWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,iPart,iPiece);
        DestroyObject(oOldWeapon);
        }

    // Store new weapon and remove original weapon
    SetLocalObject(oPC,"forgingweapon",oNewWeapon);
    DestroyObject(oWeapon);

    return oNewWeapon;
}


int GetNextPiece(object oPC, int iPart, object oArmour, int iChange, object oWearer)
{
    // Wearer defaults to being the PC we're speaking to, if none other is specified
    if (!GetIsObjectValid(oWearer))                     { oWearer = oPC; }

    int iPiece;

    DebugSpeakString("Looking for next piece of part " + IntToString(iPart));

    if      (iPart == ITEM_APPR_ARMOR_MODEL_REAL_BELT)  { iPiece = GetNextSimplePiece(iPart,oArmour,iChange); }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_BRACER)     { iPiece = GetNextSimplePiece(iPart,oArmour,iChange); }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_CLOAK)      { iPiece = GetNextCloakPiece (iPart,oArmour,iChange, oWearer); }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_GLOVES)     { iPiece = GetNextSimplePiece(iPart,oArmour,iChange); }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_HELMET)     { iPiece = GetNextSimplePiece(iPart,oArmour,iChange); }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_NECKLACE)   { iPiece = GetNextSimplePiece(iPart,oArmour,iChange); }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_RINGL)      { iPiece = GetNextSimplePiece(iPart,oArmour,iChange); }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_RINGR)      { iPiece = GetNextSimplePiece(iPart,oArmour,iChange); }
    else if (iPart == ITEM_APPR_ARMOR_MODEL_SHIELD)     { iPiece = GetNextSimplePiece(iPart,oArmour,iChange); }
    else                                                { iPiece = GetNextArmourPiece(iPart,oArmour,iChange,oPC,oWearer); }

    // Once we have a valid piece of armour, return it
    return iPiece;
}



int GetIsStackable(int iType)
{
    if (iType == BASE_ITEM_DART
     || iType == BASE_ITEM_SHURIKEN
     || iType == BASE_ITEM_THROWINGAXE )
            return TRUE;

    return FALSE;
}



object MatchItem(object oItem, object oDonor, int nType, int nIndex)
{
    int nValue = GetItemAppearance(oDonor,nType,nIndex);
    object oNew = CopyItemAndModify(oItem,nType,nIndex,nValue);

    DestroyObject(oItem);
    return oNew;
}



object ReplaceTemporaryWeapon(object oPC, object oWeapon, int iStack)
{
    // Create the real weapon and set its name
    string sTag = GetSubString(GetTag(oWeapon),0,7);
    object oCopyWeapon = CreateItemOnObject(sTag,OBJECT_SELF);
    SetName(oCopyWeapon,GetName(oWeapon));
    SetDescription(oCopyWeapon,GetDescription(oWeapon));

    // Now copy across all the enhancements we've added to it
    itemproperty iProp = GetFirstItemProperty(oWeapon);

    while (GetIsItemPropertyValid(iProp))
        {
        if (GetItemPropertyDurationType(iProp) == DURATION_TYPE_PERMANENT)
            {
            AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oCopyWeapon);
            iProp = GetNextItemProperty(oWeapon);
            }
        }

    // Set its appearance to match the dummy object's
        // (only needed for throwing axes - darts and shurikens don't have separate appearances)
    if (GetBaseItemType(oCopyWeapon) == BASE_ITEM_THROWINGAXE)
        {
        oCopyWeapon = MatchItem(oCopyWeapon,oWeapon,ITEM_APPR_TYPE_WEAPON_COLOR,ITEM_APPR_WEAPON_COLOR_BOTTOM);
        oCopyWeapon = MatchItem(oCopyWeapon,oWeapon,ITEM_APPR_TYPE_WEAPON_COLOR,ITEM_APPR_WEAPON_COLOR_MIDDLE);
        oCopyWeapon = MatchItem(oCopyWeapon,oWeapon,ITEM_APPR_TYPE_WEAPON_COLOR,ITEM_APPR_WEAPON_COLOR_TOP);
        oCopyWeapon = MatchItem(oCopyWeapon,oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,ITEM_APPR_WEAPON_MODEL_BOTTOM);
        oCopyWeapon = MatchItem(oCopyWeapon,oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,ITEM_APPR_WEAPON_MODEL_MIDDLE);
        oCopyWeapon = MatchItem(oCopyWeapon,oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,ITEM_APPR_WEAPON_MODEL_TOP);
        }

    // Set the stack size according to how many the player is buying
    SetItemStackSize(oCopyWeapon,iStack);

    // Replace the dummy weapon with the real one we've just created
    DestroyObject(oWeapon);
    object oNewWeapon = CopyObject(oCopyWeapon,GetLocation(oPC),oPC);
    AssignCommand(oPC,ActionEquipItem(oNewWeapon,GetLocalInt(oPC,"forginghand")));
    DestroyObject(oCopyWeapon);

    return oNewWeapon;
}



object ModifyItem(object oItem, int nType, int nIndex, int nNewValue)
{
    // Copy old item
    object oNewItem = CopyItemAndModify(oItem,nType,nIndex,nNewValue);

    if (!GetIsObjectValid(oNewItem))
        {
        SpeakString("ERROR! Item lost while changing item class " + IntToString(GetBaseItemType(oItem)) + ", type " + IntToString(nType) + ", part " + IntToString(nIndex) + " to piece number " + IntToString(nNewValue),TALKVOLUME_TALK);
        SpeakString("Please report this error. Item will now revert to previous appearance.",TALKVOLUME_TALK);
        oNewItem = CopyItem(oItem,GetItemPossessor(oItem));
        }

    // Set the copy as cursed, to make sure players can't get rid of it
    SetItemCursedFlag(oNewItem,TRUE);

    // Set the copy as non-droppable, to make sure AI soldiers don't leave remains
    SetDroppableFlag(oNewItem,FALSE);

    return oNewItem;
}



object ChangeColour(object oPC, int iColour)
{
    // Find the old armour, and declare a variable for the new armour
    object oOldArmour = GetLocalObject(oPC,"fittingarmour");
    object oNewArmour;

    // What colour are we trying to change?
    int iPart = GetLocalInt(oPC,"fittingcolour");
    int iType = GetBaseItemType(oOldArmour);

    // The following items are "simple" - ie, they only have one part
    if (iType == BASE_ITEM_BELT
     || iType == BASE_ITEM_BRACER
     || iType == BASE_ITEM_GLOVES
     || iType == BASE_ITEM_AMULET
     || iType == BASE_ITEM_RING)
        { oNewArmour = ModifyItem(oOldArmour,ITEM_APPR_TYPE_SIMPLE_MODEL,0,GetNextSimplePiece(iPart,oOldArmour,1,iColour)); }

    // Create a new suit of armour with the new colour
    else
        { oNewArmour = ModifyItem(oOldArmour,ITEM_APPR_TYPE_ARMOR_COLOR,iPart,GetDefaultShade(iPart,iColour)); }

    // Remove the old armour
    DestroyObject(oOldArmour);

    // Store the new armour
    SetLocalObject(oPC,"fittingarmour",oNewArmour);

    return oNewArmour;
}



int IsColourAvailable(object oPC, int iColour)
{
    // Find the old item and what type it is
    object oItem = GetLocalObject(oPC,"fittingarmour");
    int iType = GetBaseItemType(oItem);

    // What colour are we looking for?
    string sColour = IntToString(iColour);

    // NOTE: colours available for each item are setup in brief_oe_area
    return GetLocalInt(GetObjectByTag("brief_desk"), "accessory" + IntToString(iType) + "colour" + sColour);
}
