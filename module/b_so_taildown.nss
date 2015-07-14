#include "in_g_armour"

void main()
{
    object oUnit = GetLocalObject(OBJECT_SELF,"editunit");

    int iTail = GetNextTail(oUnit,-1);
    SetCreatureTailType(iTail,oUnit);
}
