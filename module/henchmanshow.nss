//::///////////////////////////////////////////////
//:: FileName henchmanshow
//:://////////////////////////////////////////////
//:: This script will cause the henchman to tell the PC
//:: the full contents of his inventory.
//:://////////////////////////////////////////////
//:: Created By: Pausanias
//:: Created On: 6/28/2002 20:43:15
//:://////////////////////////////////////////////


// The identify code is by Magic

// Pausanias's modification: correct for bard lore.

int TalentIdentify(object oItem) {
    SetIdentified(oItem,TRUE);
    int nLore = GetSkillRank(SKILL_LORE)+GetLevelByClass(CLASS_TYPE_BARD);
    int nValue = GetGoldPieceValue(oItem);
    if (nLore>=1 && nValue<=10 || nLore>=2 && nValue<=50
      || nLore>=3 && nValue<=100 || nLore>=4 && nValue<=150
      || nLore>=5 && nValue<=200 || nLore>=6 && nValue<=300
      || nLore>=7 && nValue<=400 || nLore>=8 && nValue<=500
      || nLore>=9 && nValue<=1000 || nLore>=10 && nValue<=2500
      || nLore>=11 && nValue<=3750 || nLore>=12 && nValue<=4800
      || nLore>=13 && nValue<=6500 || nLore>=14 && nValue<=9500
      || nLore>=15 && nValue<=13000 || nLore>=16 && nValue<=17000
      || nLore>=17 && nValue<=20000 || nLore>=18 && nValue<=30000
      || nLore>=19 && nValue<=40000 || nLore>=20 && nValue<=50000
      || nLore>=21 && nValue<=60000 || nLore>=22 && nValue<=80000
      || nLore>=23 && nValue<=100000 || nLore>=24 && nValue<=150000
      || nLore>=25 && nValue<=200000 || nLore>=26 && nValue<=250000
      || nLore>=27 && nValue<=300000 || nLore>=28 && nValue<=350000
      || nLore>=29 && nValue<=400000 || nLore>=30 && nValue<=500000
      || nLore>=31 && nValue<=100000*nLore-2500000) {
        return TRUE;
    }
    SetIdentified(oItem,FALSE);
    return FALSE;
}

void main()
{
    int    i, nItem=0;
    object oItem;


    // First go through all the equipped slots
    for (i = 0; i < NUM_INVENTORY_SLOTS; ++i) {
        oItem = GetItemInSlot(i);
       if (oItem != OBJECT_INVALID)

         //We don't want to report any creature items; that would be odd
         switch (GetBaseItemType(oItem)) {
            case BASE_ITEM_CREATUREITEM:
            case BASE_ITEM_CBLUDGWEAPON:
            case BASE_ITEM_CSLASHWEAPON:
            case BASE_ITEM_CSLSHPRCWEAP:
            case BASE_ITEM_CPIERCWEAPON: break;

            default:
              if (GetBaseItemType(oItem) != BASE_ITEM_CREATUREITEM) {

              // GetName doesn't care whether the object is identified, so
              // we have to check ourselves.

                if (!GetIdentified(oItem)) TalentIdentify(oItem);
                if(GetIdentified(oItem))
                SpeakString(GetName(oItem)+": equipped. Qty: "+
                            IntToString(GetNumStackedItems(oItem)));
                else
                SpeakString("Unidentified object: equipped. Qty: "+
                            IntToString(GetNumStackedItems(oItem)));
                ++nItem;
                break;
              }
         }
    }

    // Now loop through the items in the backpack.
    oItem = GetFirstItemInInventory();

    while (oItem != OBJECT_INVALID) {
        if (!GetIdentified(oItem)) TalentIdentify(oItem);
        if(GetIdentified(oItem))
           SpeakString(GetName(oItem)+": in backpack. Qty: "+
                       IntToString(GetNumStackedItems(oItem)));
        else
           SpeakString("Unidentified object: in backpack. Qty: "+
                       IntToString(GetNumStackedItems(oItem)));
        oItem = GetNextItemInInventory();
        ++nItem;
    }
    if (nItem == 0) SpeakString("I don't have anything!");
}
