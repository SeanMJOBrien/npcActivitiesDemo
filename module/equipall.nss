object GetSLot(object oEquip, int iType)
{
    object oRing=OBJECT_INVALID;
    object oItem;

    oItem = GetFirstItemInInventory(oEquip);

    while (oItem != OBJECT_INVALID)
    {
        if (GetBaseItemType(oItem) == iType)
        {
            oRing = oItem;
            oItem = OBJECT_INVALID;
        }else oItem = GetNextItemInInventory(oEquip);
    }

    return oRing;
}

void EquipItem(object oDude, object oLoot, int iSlot)
{
        AssignCommand(oDude, ActionEquipItem(oLoot, iSlot));
}

void main()
{
/* This script is very rudimentry and serves to try and find the best AC
   and equip the best weapon on the spawned creature.  It is not perfect due to
   limitations in the bioware functions used.  I have tried to work around it
   where possible.

    It does not necessarily get the best item, but it will get the first one in inventory.
*/
    object oEquip;
    int iInSlot;

    //always equip the best armour
    ActionEquipMostEffectiveArmor();

//equip shield
iInSlot =INVENTORY_SLOT_LEFTHAND;
if (GetItemInSlot(iInSlot,OBJECT_SELF) == OBJECT_INVALID)
{
    oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_TOWERSHIELD);
    if (oEquip == OBJECT_INVALID) oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_LARGESHIELD);
    if (oEquip == OBJECT_INVALID) oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_SMALLSHIELD);
    if (oEquip != OBJECT_INVALID) EquipItem(OBJECT_SELF,oEquip,iInSlot);
}


int Equip = GetLocalInt(OBJECT_SELF,"ss_t_autoequip");

//EQUIP CLOTHING FIRST, if naked
if (GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF) == OBJECT_INVALID)
{
    oEquip = GetFirstItemInInventory(OBJECT_SELF);
    while (oEquip != OBJECT_INVALID)
    {
        if (GetItemACValue(oEquip) == 0)
        {
            //it's clothing
            if (GetBaseItemType(oEquip) == BASE_ITEM_ARMOR)
            {
              AssignCommand(OBJECT_SELF, ActionEquipItem(oEquip, INVENTORY_SLOT_CHEST));
              oEquip = OBJECT_INVALID;  //kick out of loop
            }else oEquip=GetNextItemInInventory(OBJECT_SELF);
        }else oEquip=GetNextItemInInventory(OBJECT_SELF);
    }
}





switch (Equip)
{
    case 0:
        return;  //kick out if not set
        break;
    case 1:  //ranged dude
        AssignCommand(OBJECT_SELF, ActionEquipMostDamagingRanged());
        return; //kick out of script
        break;
    case 2: //melee dude
        AssignCommand(OBJECT_SELF, ActionEquipMostDamagingMelee());
        return;
        break;
    case 3: //ranged dude with other equipment
        AssignCommand(OBJECT_SELF, ActionEquipMostDamagingRanged());
        break;
    case 4: //melee dude with other equipment
        AssignCommand(OBJECT_SELF, ActionEquipMostDamagingMelee());
        break;
}


//right ring
iInSlot =INVENTORY_SLOT_RIGHTRING;
if (GetItemInSlot(iInSlot,OBJECT_SELF) == OBJECT_INVALID)
{
    oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_RING);
    if (oEquip != OBJECT_INVALID) EquipItem(OBJECT_SELF,oEquip,iInSlot);
}

//left ring
iInSlot =INVENTORY_SLOT_LEFTRING;
if (GetItemInSlot(iInSlot,OBJECT_SELF) == OBJECT_INVALID)
{
    oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_RING);
    if (oEquip != OBJECT_INVALID) EquipItem(OBJECT_SELF,oEquip,iInSlot);
}

//amulet
iInSlot =INVENTORY_SLOT_NECK;
if (GetItemInSlot(iInSlot,OBJECT_SELF) == OBJECT_INVALID)
{
    oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_AMULET);
    if (oEquip != OBJECT_INVALID) EquipItem(OBJECT_SELF,oEquip,iInSlot);
}


//belt
iInSlot =INVENTORY_SLOT_BELT;
if (GetItemInSlot(iInSlot,OBJECT_SELF) == OBJECT_INVALID)
{
    oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_BELT);
    if (oEquip != OBJECT_INVALID) EquipItem(OBJECT_SELF,oEquip,iInSlot);
}

//helmets
iInSlot = INVENTORY_SLOT_HEAD;
if (GetItemInSlot(iInSlot,OBJECT_SELF) == OBJECT_INVALID)
{
    oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_HELMET);
    if (oEquip != OBJECT_INVALID) EquipItem(OBJECT_SELF,oEquip,iInSlot);
}

//cloak
iInSlot =INVENTORY_SLOT_CLOAK;
if (GetItemInSlot(iInSlot,OBJECT_SELF) == OBJECT_INVALID)
{
    oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_CLOAK);
    if (oEquip != OBJECT_INVALID) EquipItem(OBJECT_SELF,oEquip,iInSlot);
}

//gauntlets
iInSlot =INVENTORY_SLOT_ARMS;
if (GetItemInSlot(iInSlot,OBJECT_SELF) == OBJECT_INVALID)
{
    oEquip = GetSLot(OBJECT_SELF, BASE_ITEM_BRACER);
    if (oEquip != OBJECT_INVALID) EquipItem(OBJECT_SELF,oEquip,iInSlot);
}



}
