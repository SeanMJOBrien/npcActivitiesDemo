///////////////////////////////////////////////////////////////////////
// npcact_cms_gpcon - NPC ACTIVITIES 6.0 - Custom Monetary System
// OnAcquire Execute Script for converting gold
// By Deva Bryson Winblood.  02/23/2005
///////////////////////////////////////////////////////////////////////
#include "x2_inc_switches"
#include "npcact_h_money"

void main()
{
     object oItem = GetModuleItemAcquired();
     int bCap=FALSE;
     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     bCap=AcquireCoins(oItem,GetModuleItemAcquiredBy());
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE&&!bCap)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACQUIRE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }

     }

}
