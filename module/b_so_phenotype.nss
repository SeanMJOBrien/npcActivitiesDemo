#include "in_g_armour"

void main()
{
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");
    object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oUnit);
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oUnit);

    int iRace = GetRacialType(oUnit);
    int iPheno = GetPhenoType(oUnit);
    int iGender = GetGender(oUnit);

    int bInvalidCloak = FALSE;
    int bInvalidArmour = FALSE;

    // Find unit's new phenotype (+3 phenos are mounted)
    if      (GetPhenoType(oUnit) == PHENOTYPE_NORMAL)       { iPheno = PHENOTYPE_BIG;           }
    else if (GetPhenoType(oUnit) == PHENOTYPE_NORMAL + 3)   { iPheno = PHENOTYPE_BIG + 3;       }
    else if (GetPhenoType(oUnit) == PHENOTYPE_BIG)          { iPheno = PHENOTYPE_NORMAL;        }
    else if (GetPhenoType(oUnit) == PHENOTYPE_BIG + 3)      { iPheno = PHENOTYPE_NORMAL + 3;    }

    // If the unit is wearing a cloak, and it's not valid for the new phenotype, and they haven't chosen to ignore that...
    if (!GetLocalInt(OBJECT_SELF, "invalidcloak") && GetIsObjectValid(oCloak) && !IsCloakValidForCharacter(oCloak, iGender, iRace, iPheno))
        { bInvalidCloak = TRUE; }

    // If the unit is wearing clothes, and they're not valid for the new phenotype, and they haven't chosen to ignore that...
    if (!GetLocalInt(OBJECT_SELF, "invalidarmour") && GetIsObjectValid(oArmour) && !IsArmourValidForCharacter(oArmour, iGender, iRace, iPheno))
        { bInvalidArmour = TRUE; }

    // Otherwise update the character's phenotype
    if (!bInvalidCloak && !bInvalidArmour)
        {
        SetPhenoType(iPheno, oUnit);

        // If the player has agreed to adjust their cloak to fit their new build, and are still wearing it...
        if (GetLocalInt(OBJECT_SELF, "invalidcloak") && GetIsObjectValid(oCloak))
            { MakeCloakValidForCharacter(oCloak, oUnit); }

        // If the player has agreed to adjust their clothing to fit their new build, and are still wearing them...
        if (GetLocalInt(OBJECT_SELF, "invalidarmour") && GetIsObjectValid(oArmour))
            { MakeArmourValidForCharacter(oArmour, oUnit); }
        }

    // Update whether the player needs to change their cloak or armour
    SetLocalInt(OBJECT_SELF, "invalidcloak",  bInvalidCloak);
    SetLocalInt(OBJECT_SELF, "invalidarmour", bInvalidArmour);
}
