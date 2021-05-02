//::///////////////////////////////////////////////
//:: FileName henchmanequip      v1.8
//:://////////////////////////////////////////////
//:: This script will store all the objects possessed by the PC
//:: in an object array. It will then delete the Bag of Holding
//:: given the PC by the henchman. All objects in the bag of
//:: holding will be in limbo, useful for identifying them as
//:: having been inside a bag of holding. The script then ends,
//:: waiting for the conversation to call "henchmanfinish" so
//:: that the henchman will actually start putting on the items.
//:://////////////////////////////////////////////
//:: Created By: Pausanias (c) 2002
//:: Modified By: 69MEH69 JAN2003
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"
#include "PAUS_I0_ARRAY"

void main()
{
    object oBag, oItem, oPC, oSelf, oNew;
    int    i, iIdent;

    oSelf = OBJECT_SELF;
    oPC = GetPCSpeaker();

    // This is the bag created by the henchmanmanage script.
    oBag = GetLocalObject(OBJECT_SELF,"HenchBag");

    SetAssociateState(NW_ASC_IS_BUSY,TRUE);
    if (oBag != OBJECT_INVALID) {

        // Go through all of PC's items

        oItem = GetFirstItemInInventory(oPC);

        int iInd = 0;
        while (oItem != OBJECT_INVALID) {

            ++iInd;

            // Store them in an array. Remember the identified status
            // of the objects as well, so that we can tell the henchman
            // later in case he doesn't know the items himself.
            iIdent = GetIdentified(oItem);
            MySetObjectArray(oPC,"ItemArr",iInd,oItem);
            MySetIntArray(oPC,"ItemCnt",iInd,GetNumStackedItems(oItem));
            MySetIntArray(oPC,"IdentArr",iInd,iIdent);

            oItem = GetNextItemInInventory(oPC);
        }

        // Store the total number of items on the PC as well as
        // the actual PC as an objects.
        SetLocalInt(oPC,"NItem",iInd);
        SetLocalObject(OBJECT_SELF,"MyPC",oPC);

        // And why do we not simply equip the items here instead of in another
        // script? Very simply, because it takes time for the object to be
        // destroyed. It's not instantenous!
    }
}
