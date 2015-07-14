#include "hench_i0_assoc"


void main()
{
    object oRealMaster = GetRealMaster();
    object oClosest =  GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                        oRealMaster, 1);
    if (GetIsObjectValid(oClosest) && GetDistanceBetween(oClosest, oRealMaster) <= henchMaxScoutDistance)
    {
        SetLocalInt(OBJECT_SELF, "Scouting", TRUE);
        SetLocalObject(OBJECT_SELF, "ScoutTarget", oClosest);
        ClearAllActions();
        if (CheckStealth())
        {
            SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
        }
        ActionMoveToObject(oClosest, FALSE, 1.0);
        ActionMoveToObject(oClosest, FALSE, 1.0);
        ActionMoveToObject(oClosest, FALSE, 1.0);
    }
    else
    {
        SetLocalInt(OBJECT_SELF,"Scouting", FALSE);
    }
}
