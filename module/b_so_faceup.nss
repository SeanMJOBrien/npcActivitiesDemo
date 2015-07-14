#include "in_g_armour"

void main()
{
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    int iPheno = GetPhenoType(oUnit);
    int bRemount = FALSE;

    // If unit is mounted, can't change their head without dismounting them (grr)
    if (iPheno == PHENOTYPE_NORMAL + 3)
        {
        SetPhenoType(PHENOTYPE_NORMAL,oUnit);
        bRemount = TRUE;
        }
    else if (iPheno == PHENOTYPE_BIG + 3)
        {
        SetPhenoType(PHENOTYPE_BIG,oUnit);
        bRemount = TRUE;
        }

    int iHead = GetNextHead(oUnit, 1);

    SetCreatureBodyPart(CREATURE_PART_HEAD,iHead,oUnit);

    // Remount unit if necessary
    if (bRemount)
        {
        SetPhenoType(GetPhenoType(oUnit) + 3, oUnit);
        }
}
