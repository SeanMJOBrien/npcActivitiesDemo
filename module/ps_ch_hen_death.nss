#include "x0_i0_henchman"

void main()
{
    object oPC = GetLastMaster();
    object oSelf = OBJECT_SELF;

object oRemains = CreateObject(OBJECT_TYPE_PLACEABLE,"ps_hnchrem",GetLocation(oSelf),FALSE);
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oSelf),oSelf));
//AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_CHEST,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_ARMS,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_ARROWS,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_BELT,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_BOLTS,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_BOOTS,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_BULLETS,oSelf),oSelf));
//AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_CARMOUR,oSelf),oSelf));
//AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_CLOAK,oSelf),oSelf));
//AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oSelf),oSelf));
//AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_LEFTRING,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_NECK,oSelf),oSelf));
AssignCommand(oRemains, ActionTakeItem(GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oSelf),oSelf));

AssignCommand(oRemains, TakeGold(GetGold(oSelf),oSelf,FALSE));
object oScan = GetFirstItemInInventory(oSelf);
while (oScan != OBJECT_INVALID)
    {
    AssignCommand(oRemains, ActionTakeItem(oScan,oSelf));
    oScan = GetNextItemInInventory(oSelf);
    }
        SetPlotFlag(OBJECT_SELF,FALSE);
        SetImmortal(OBJECT_SELF, FALSE);
        SetIsDestroyable(TRUE, FALSE, FALSE);
        DestroyObject(OBJECT_SELF, 6.0);
//DestroyObject(oSelf);
}
