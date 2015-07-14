#include "in_g_armour"

void main()
{
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    int iWing = GetNextWing(oUnit,1);
    SetCreatureWingType(iWing,oUnit);
}
