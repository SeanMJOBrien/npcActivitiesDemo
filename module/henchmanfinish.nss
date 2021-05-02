//::///////////////////////////////////////////////
//:: FileName henchmanfinish      v 0.9
//:://////////////////////////////////////////////
//:: This script will cause the henchman to get the items
//:: from the master's bag of holding (via henchmanxfer)
//::
//:://////////////////////////////////////////////
//:: Created By: Pausanias
//:: Created On: 6/28/2002 20:43:15
//:://////////////////////////////////////////////

#include "nw_i0_generic"

// Destroy the decency robe unless we're still wearing it.
void DestroyDecency()
{
     object oDecency = GetLocalObject(OBJECT_SELF,"Decency");

     if (GetItemInSlot(INVENTORY_SLOT_CHEST) != oDecency)
     {
        DestroyObject(oDecency);
        DeleteLocalObject(OBJECT_SELF,"Decency");
     }
}

void main()
{
    object oBag, oItem;
    int    i;

    // This is the bag created by the henchmanmanage or henchmanmng* scripts.
    oBag = GetLocalObject(OBJECT_SELF,"HenchBag");

    if (GetIsObjectValid(oBag)) {
            SetLocalObject(oBag,"TransferTo",OBJECT_SELF);

            // Execute the transferring/equipping script.
            ExecuteScript("henchmanxfer",oBag);

            // This tells the dialogue tree that the PC no longer has the
            // henchman's inventory
            SetLocalInt(OBJECT_SELF,"HenchmanInv",0);

            // Destroy the monk's robe if it's there.
            DelayCommand(3.0,DestroyDecency());

            // Destroy the bag of holding, with enough delay to allow smooth
            // transfer of the objects.
            // As of v0.9, this is now done by EquipItems.
            //DestroyObject(oBag,5.);
    }

  DelayCommand(5.,EquipAppropriateWeapons(OBJECT_SELF));
}


