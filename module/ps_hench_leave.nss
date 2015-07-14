#include "x0_i0_henchman"
#include "ps_timestamp"

void ProcessItem(object oItem,object oBag,object oHenchman)
{
if (GetDroppableFlag(oItem) == TRUE)
AssignCommand(oBag, ActionTakeItem(oItem,oHenchman));
}
void PS_RemoveHenchman(object oHenchman,object oPC)
{
    AssignCommand(oHenchman,QuitHenchman(oPC));
    DeleteTimeStamp(oHenchman,1);
    object oBag = CreateObject(OBJECT_TYPE_PLACEABLE,"ps_hench_bag",GetLocation(oHenchman));

ProcessItem(GetItemInSlot(INVENTORY_SLOT_ARMS,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_ARROWS,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_BELT,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_BOLTS,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_BOOTS,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_CARMOUR,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_BULLETS,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_CARMOUR,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_CHEST,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_CLOAK,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_HEAD,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_LEFTRING,oHenchman),oBag,oHenchman);
ProcessItem(GetItemInSlot(INVENTORY_SLOT_NECK,oHenchman),oBag,oHenchman);

AssignCommand(oBag, TakeGold(GetGold(oHenchman),oHenchman,FALSE));
object oScan = GetFirstItemInInventory(oHenchman);
while (oScan != OBJECT_INVALID)
    {
    ProcessItem(oScan,oBag,oHenchman);
    oScan = GetNextItemInInventory(oHenchman);
    }
//string sResRef = GetResRef(oHenchman);
//int nCurrentHP = GetCurrentHitPoints(oHenchman);
string sReturnTo = GetTag(oHenchman) + "_HOME";
object oReturnTo = GetWaypointByTag(sReturnTo);
//int nDamage = abs(nCurrentHP - GetMaxHitPoints(oHenchman));
AssignCommand(oHenchman,ClearAllActions());
//SetPlotFlag(oHenchman,FALSE);
//SetImmortal(oHenchman, FALSE);
//AssignCommand(oHenchman,SetIsDestroyable(TRUE, FALSE, FALSE));
AssignCommand(oHenchman,ActionJumpToLocation(GetLocation(oReturnTo)));
//DestroyObject(oHenchman, 1.0);
//object oNew = CreateObject(OBJECT_TYPE_CREATURE,sResRef,GetLocation(oReturnTo));
//ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(nDamage),oNew);

}
