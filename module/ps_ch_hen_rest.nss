#include "x0_i0_henchman"
#include "ps_timestamp"

void main()
{

    object oPC = GetLastMaster();
    object oSelf = OBJECT_SELF;
int nLevel = GetLevelByPosition(1,oSelf) + GetLevelByPosition(2,oSelf) + GetLevelByPosition(3,oSelf);
int nHeal = nLevel + GetAbilityModifier(ABILITY_CONSTITUTION,oSelf);
int nMaxHP = GetMaxHitPoints(oSelf);
int nCurrentHP = GetCurrentHitPoints(oSelf);
int nTargetHP;
int nDayBuffer;
int nBestFood = 0; // tagged BESTFOOD
int nGoodFood = 0; // tagged GOODFOOD
int nFood = 0; // tagged FOOD
        int nNumber = FALSE; // TRUE if any food present after scanning.
        object oScan = GetFirstItemInInventory(oSelf);
        while (oScan != OBJECT_INVALID)
            {
            if (GetTag(oScan) == "BESTFOOD")
                {
                if (GetIsLaterThan(oScan) == 1)
                    {
                    SendMessageToPC(oPC,"Your hireling's "+GetName(oScan)+" has spoiled.");
                    DestroyObject(oScan);
                    //CreateItemOnObject("ps_spoiledfood",oPC);
                    }
                    else
                        {
                        nBestFood ++;
                        nNumber = TRUE;
                        }
                }
            oScan = GetNextItemInInventory(oSelf);
            } // while ...
        oScan = GetFirstItemInInventory(oSelf);
        while (oScan != OBJECT_INVALID)
            {
            if (GetTag(oScan) == "GOODFOOD")
                {
                if (GetIsLaterThan(oScan) == 1)
                    {
                    SendMessageToPC(oPC,"Your hireling's "+GetName(oScan)+" has spoiled.");
                    DestroyObject(oScan);
                    //CreateItemOnObject("ps_spoiledfood",oPC);
                    }
                    else
                        {
                        nGoodFood ++;
                        nNumber = TRUE;
                        }
                }
            oScan = GetNextItemInInventory(oSelf);
            } // while ...
        oScan = GetFirstItemInInventory(oSelf);
        while (oScan != OBJECT_INVALID)
            {
            if (GetTag(oScan) == "FOOD")
                {
                nFood ++;
                nNumber = TRUE;
                }
            oScan = GetNextItemInInventory(oSelf);
            } // while ...

        if (nNumber == FALSE) // PC has no food!
            {
            AssignCommand(oSelf,ClearAllActions());
            SendMessageToPC(oPC,"Your henchman/hireling doesn't have any food.");
            return;
            }
        else if (((nMaxHP - nCurrentHP) > (nHeal * 2)) && (nBestFood > 0))
            {
            // PC has best food and could use it
            SetLocalObject(oSelf,"RestFood",GetItemPossessedBy(oSelf,"BESTFOOD"));
            }
        else if (((nMaxHP - nCurrentHP) > (nHeal)) && (nGoodFood > 0))
            {
            // PC has good food and could use it.
            SetLocalObject(oSelf,"RestFood",GetItemPossessedBy(oSelf,"GOODFOOD"));
            }
        else if (nFood > 0)
            {
            SetLocalObject(oSelf,"RestFood",GetItemPossessedBy(oSelf,"FOOD"));
            }
        else if (nGoodFood > 0)
            {
            SetLocalObject(oSelf,"RestFood",GetItemPossessedBy(oSelf,"GOODFOOD"));
            }
        else if (nBestFood > 0)
            { // PC doesn't need best food but that's what's available
            SetLocalObject(oSelf,"RestFood",GetItemPossessedBy(oSelf,"BESTFOOD"));
            }
        SetLocalInt(oSelf,"RestHP",nCurrentHP);
    DeleteLocalInt(oSelf,"HoursTraveled");
    oScan = GetLocalObject(oSelf,"RestFood");
    if (GetTag(oScan) == "BESTFOOD") nNumber = nHeal * 3;
    if (GetTag(oScan) == "GOODFOOD") nNumber = nHeal * 2;
    if (GetTag(oScan) == "FOOD") nNumber = nHeal;
//    SendMessageToPC(oPC,"You've consumed "+GetName(oScan)+".");
    DestroyObject(oScan);
    nTargetHP = GetLocalInt(oSelf,"RestHP") + nNumber;
    int nHealBonus = GetLocalInt(oSelf,"HealBonus");
    if (nHealBonus > 0)
        {
        SendMessageToPC(oPC,"Your hireling benfits from a prior application of healing balm.");
        nTargetHP += nHealBonus;
        DeleteLocalInt(oSelf,"HealBonus");
        }
    nNumber = GetCurrentHitPoints(oSelf) - nTargetHP;
    effect eHPAdjust = EffectDamage(nNumber,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_ENERGY);
    if (nNumber > 0) ApplyEffectToObject(DURATION_TYPE_INSTANT,eHPAdjust,oSelf);
//    FadeFromBlack(oPC,FADE_SPEED_SLOW);
    DeleteLocalObject(oSelf,"RestFood");
    DeleteLocalInt(oSelf,"RestHP");


}
