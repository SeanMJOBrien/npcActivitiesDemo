////////////////////////////////////////////////////////////////////////////////
// lib_nais_area - This is tools for tracking resources and needs of an area
// By Deva B. Winblood.  04/22/2007
////////////////////////////////////////////////////////////////////////////////
/*
    AREA INFORMATION IS TRACKED IN THE MODULE DATABASE
    Storage in an area will be stored in a placeable tagged AREA_STORAGE
    If an STORAGE_resourcename tagged object exists it will override the general
    storage.

*/
////////////////////////////////////////////////////////////////////////////////
#include "lib_nais_persist"
#include "lib_nais_tool"
#include "lib_nais_time"
#include "lib_nais_msg"

/////////////////////////////
// CONSTANTS
/////////////////////////////

const string MODULE_DATABASE = "NAIS1MOD";

const int RESOURCE_COUNT               = 52;

const int RESOURCE_FOOD                = 1;
const int RESOURCE_IRON_BAR            = 2;
const int RESOURCE_MITHRIL_BAR         = 3;
const int RESOURCE_ADMANTIUM_BAR       = 4;
const int RESOURCE_GOLD_BAR            = 5;
const int RESOURCE_IRON_ORE            = 6;
const int RESOURCE_MITHRIL_ORE         = 7;
const int RESOURCE_ADMANTIUM_ORE       = 8;
const int RESOURCE_COAL                = 9;
const int RESOURCE_WOOD                = 10;
const int RESOURCE_PORTAL_WOOD         = 11;
const int RESOURCE_GRAIN               = 12;
const int RESOURCE_HIDE                = 13;
const int RESOURCE_LEATHER             = 14;
const int RESOURCE_MANA_CRYSTAL        = 15;
const int RESOURCE_CORPSE              = 16;
const int RESOURCE_LIQUID_PAIN         = 17;
const int RESOURCE_LIQUID_EUPHORIA     = 18;
const int RESOURCE_WATER               = 19;
const int RESOURCE_ALE                 = 20;
const int RESOURCE_WINE                = 21;
const int RESOURCE_SPIRITS             = 22;
const int RESOURCE_GOLD_ORE            = 23;
const int RESOURCE_FISH                = 24;
const int RESOURCE_FRUIT               = 25;
const int RESOURCE_MEAT                = 26;
const int RESOURCE_FUNGUS              = 27;
const int RESOURCE_FLOUR               = 28;
const int RESOURCE_COMMON_HERB         = 29;
const int RESOURCE_UNCOMMON_HERB       = 30;
const int RESOURCE_RARE_HERB           = 31;
const int RESOURCE_ART                 = 32;
const int RESOURCE_DYE                 = 33;
const int RESOURCE_SOUL_GEM            = 34;
const int RESOURCE_BLOOD               = 35;
const int RESOURCE_SILK                = 36;
const int RESOURCE_SPICE               = 37;
const int RESOURCE_POISON_FUNGuS       = 38;
const int RESOURCE_MAIL                = 39;
const int RESOURCE_FEATHERS            = 40;
const int RESOURCE_DEMON_FLESH         = 41;
const int RESOURCE_HEART               = 42;
const int RESOURCE_HEAD                = 43;
const int RESOURCE_WOOD_PART           = 44;
const int RESOURCE_MITHRIL_PART        = 45;
const int RESOURCE_IRON_PART           = 46;
const int RESOURCE_ADMANTIUM_PART      = 47;
const int RESOURCE_DRAGON_BLOOD        = 48;
const int RESOURCE_SLAAD_TONGUE        = 49;
const int RESOURCE_FAERIE_DUST         = 50;
const int RESOURCE_BODAK_TOOTH         = 51;
const int RESOURCE_FIRE_BEETLE_BELLY   = 52;

/////////////////////////////
// PROTOTYPES
/////////////////////////////


// FILE: lib_nais_area                      FUNCTION: Area_GetStorageName()*
// This will return the string to use with the STORAGE_ object for this
// particular storage.  METALS, ORES, COAL, GRAIN, MEATS, FRUIT, LIQUOR,
// HIDES, LEATHER, WOOD, CORPSEPILE, WATER, FOOD, TREASURY.
string Area_GetStorageName(int nResource);


// FILE: lib_nais_area                      FUNCTION: Area_GetResourceVar()*
// This will return the string name for the resource you are requesting.
string Area_GetResourceVar(int nResource);


// FILE: lib_nais_area                      FUNCTION: Area_GetStorage()*
// This will return a handle to the object that should hold the specified
// resource.   If Global is set to TRUE then it will only return a specific
// STORAGE_ object anywhere in the game and will not use the AREA_STORAGE
// generic.  sTeamID will do STORAGE_teamid_RESOURCE
object Area_GetStorage(object oArea,int nResource,int bGlobal=FALSE,string sTeamID="");


// FILE: lib_nais_area                      FUNCTION: Area_GetResourceCode()*
// This will return the Resource # if this item is a particular resource type
// otherwise it will return 0.
int Area_GetResourceCode(object oItem);


// FILE: lib_nais_area                      FUNCTION: Area_GetResourceResRef()*
// This will return the resref to use for this resource.
string Area_GetResourceResRef(int nResource);


// FILE: lib_nais_area                      FUNCTION: Area_PopulateBox()*
// This will create the resources for the area in a box so, they can be accessed
// by a PC.
void Area_PopulateBox(object oBox,int nResource);


// FILE: lib_nais_area                      FUNCTION: Area_StoreBox()*
// This will store specified resources that are found in the box and will
// destroy the items.
void Area_StoreBox(object oBox,int nResource);


// FILE: lib_nais_area                      FUNCTION: Area_GetResourceAmount()*
// This will return the amount of the specified resource in the area.
int Area_GetResourceAmount(object oArea,int nResource);


// FILE: lib_nais_area                      FUNCTION: Area_PopulateBoxMisc()*
// This will recover any miscellaneous items that should be in this box.
void Area_PopulateBoxMisc(object oBox);


// FILE: lib_nais_area                      FUNCTION: Area_StoreBoxMisc()*
// This will store miscellaneous non-resource items that are in the box
// and destroy them.
void Area_StoreBoxMisc(object oBox);


// FILE: lib_nais_area                      FUNCTION: Area_SetResourceAmount()*
// This will set the specified resource amount to the specified nAmount.
void Area_SetResourceAmount(object oArea,int nResource,int nAmount);


// FILE: lib_nais_area                      FUNCTION: Area_DoManaUpdate()*
// This will update all the mana in an area so, that it goes back up to the
// max amount for the current phase.
void Area_DoManaUpdate(object oArea);


// FILE: lib_nais_area                      FUNCTION: Area_GetManaMax()*
// This gets what the maximum mana for this area should be each update.
int Area_GetManaMax(object oArea);


// FILE: lib_nais_area                      FUNCTION: Area_GetCurrentMana()*
// This will set what the current mana for the area is.
int Area_GetCurrentMana(object oArea);


// FILE: lib_nais_area                      FUNCTION: Area_SetCurrentMana()*
// This will set the mana for the area to nAmount.
void Area_SetCurrentMana(object oArea,int nAmount);


// FILE: lib_nais_area                      FUNCTION: Area_SetManaMax()*
// This will set the mana max for the area to nAmount.
void Area_SetManaMax(object oArea,int nAmount);


// FILE: lib_nais_area                      FUNCTION: Area_GetResourceName()
// This will return the name of the specified resource.
string Area_GetResourceName(int nResource);


// FILE: lib_nais_area                      FUNCTION: Area_ChangeController()
// This will change oArea's controller to specific sTeamID.   If the TeamID
// is set to "" it is the default controller.
void Area_ChangeController(object oArea,string sTeamID="");


// FILE: lib_nais_area                      FUNCTION: Area_GetController()
// This will return the team ID of whatever team currently controls the area.
string Area_GetController(object oArea);

/////////////////////////////
// FUNCTIONS
/////////////////////////////




void fnArea_DeleteMemoryOf(object oArea,object oWP,string sTeamID="")
{ // PURPOSE: This will delete any memory of the team sTeamID stored in
  // relation to this area in the database
    string sMaster=GetLocalString(oWP,"sPop_"+sTeamID);
    string sParse;
    string sTag;
    int nN;
    int nNext;
    string sList=GetTag(oArea)+"_";
    if (GetStringLength(sMaster)<1) sMaster=GetLocalString(oWP,"sPop_default");
    sParse=lib_ParseString(sMaster,".");
    while(GetStringLength(sMaster)>0)
    { // remove reference to each type
        sMaster=lib_RemoveParsed(sMaster,sParse,".");
        sTag=lib_ParseString(sParse,"/");
        sParse=lib_RemoveParsed(sParse,sTag,"/");
        sTag=lib_ParseString(sParse,"/");
        if (GetStringLength(sTag)>0)
        { // unit type identified
            nNext=List_GetFirstMember("NAIS1MOD",sList+sTag);
            while(nNext>0)
            { // list member found
                nN=List_GetMemberInt("NAIS1MOD",sList+sTag,"nUID",nNext);
                if (nN>0) NPC_DestroyNPC(OBJECT_INVALID,nN);
                DelayCommand(1.0,List_DeleteMember("NAIS1MOD",sList+sTag,nNext));
                nNext=List_GetNextMember("NAIS1MOD",sList+sTag);
            } // list member found
        } // unit type identified
        sParse=lib_ParseString(sMaster,".");
    } // remove reference to each type
} // fnArea_DeleteMemoryOf()



void Area_ChangeController(object oArea,string sTeamID="")
{ // PURPOSE: Change the areas controller
    int nN;
    object oPLC;
    object oOb;
    object oWP=GetWaypointByTag("AREA_"+GetTag(oArea));
    string sCur=NBDE_GetCampaignString("NAIS1MOD","sAreaC_"+GetTag(oArea));
    if (sCur!=GetTag(oArea))
    { // notify people they lost an area
        Msg_Team(GetModule(),"You have lost control of the area '"+GetName(oArea)+"'!","266","as_cv_lute1b",sCur,FALSE);
    } // notify people they lost an area
    if (GetIsObjectValid(oWP))
    { // waypoint found
        DelayCommand(4.0,fnArea_DeleteMemoryOf(oArea,oWP,sCur));
    } // waypoint found
    NBDE_SetCampaignString("NAIS1MOD","sAreaC_"+GetTag(oArea),sTeamID);
    NBDE_SetCampaignString("NAIS1MOD","sSavedModuleTime",Time_GetStringTime());
    Msg_Team(GetModule(),"You have gained control of the area '"+GetName(oArea)+"'!","266","as_cv_lute1",sTeamID,FALSE);
    DelayCommand(1.0,NBDE_FlushCampaignDatabase("NAIS1MOD"));
    DelayCommand(2.0,NBDE_FlushCampaignDatabase("NAIS1PLC"));
    DelayCommand(3.0,NBDE_FlushCampaignDatabase("NAIS1NPC"));
    DelayCommand(4.0,NBDE_FlushCampaignDatabase("NAIS1TEAM"));
    DelayCommand(5.0,NBDE_FlushCampaignDatabase("NAIS1PC"));
    DelayCommand(6.0,NBDE_FlushCampaignDatabase("NAIS1ITEM"));
} // Area_ChangeController()


string Area_GetController(object oArea)
{ // PURPOSE: Return the team ID of the team controlling the area
    return NBDE_GetCampaignString("NAIS1MOD","sAreaC_"+GetTag(oArea));
} // Area_GetController()




string Area_GetResourceName(int nResource)
{ // PURPOSE: Return the name of the resource
    if (nResource==RESOURCE_ADMANTIUM_BAR) return "Admantium Bar";
    else if (nResource==RESOURCE_ADMANTIUM_ORE) return "Admantium Ore";
    else if (nResource==RESOURCE_ADMANTIUM_PART) return "Admantium Part";
    else if (nResource==RESOURCE_ALE) return "Ale";
    else if (nResource==RESOURCE_ART) return "Art";
    else if (nResource==RESOURCE_BLOOD) return "Blood";
    else if (nResource==RESOURCE_BODAK_TOOTH) return "Bodak Tooth";
    else if (nResource==RESOURCE_COAL) return "Coal";
    else if (nResource==RESOURCE_COMMON_HERB) return "Common Herb";
    else if (nResource==RESOURCE_CORPSE) return "Corpse";
    else if (nResource==RESOURCE_DEMON_FLESH) return "Demon Flesh";
    else if (nResource==RESOURCE_DRAGON_BLOOD) return "Dragon Blood";
    else if (nResource==RESOURCE_DYE) return "Dye";
    else if (nResource==RESOURCE_FAERIE_DUST) return "Faerie Dust";
    else if (nResource==RESOURCE_FEATHERS) return "Feathers";
    else if (nResource==RESOURCE_FIRE_BEETLE_BELLY) return "Fire Beetle Belly";
    else if (nResource==RESOURCE_FISH) return "Fish";
    else if (nResource==RESOURCE_FLOUR) return "Flour";
    else if (nResource==RESOURCE_FOOD) return "Food";
    else if (nResource==RESOURCE_FRUIT) return "Fruit";
    else if (nResource==RESOURCE_FUNGUS) return "Fungus";
    else if (nResource==RESOURCE_GOLD_BAR) return "Gold Bar";
    else if (nResource==RESOURCE_GOLD_ORE) return "Gold Ore";
    else if (nResource==RESOURCE_GRAIN) return "Grain";
    else if (nResource==RESOURCE_HEAD) return "Head";
    else if (nResource==RESOURCE_HEART) return "Heart";
    else if (nResource==RESOURCE_HIDE) return "Hide";
    else if (nResource==RESOURCE_IRON_BAR) return "Iron Bar";
    else if (nResource==RESOURCE_IRON_ORE) return "Iron Ore";
    else if (nResource==RESOURCE_IRON_PART) return "Iron Part";
    else if (nResource==RESOURCE_LEATHER) return "Leather";
    else if (nResource==RESOURCE_LIQUID_EUPHORIA) return "Liquid Euphoria";
    else if (nResource==RESOURCE_LIQUID_PAIN) return "Liquid Pain";
    else if (nResource==RESOURCE_MAIL) return "Mail";
    else if (nResource==RESOURCE_MANA_CRYSTAL) return "Mana Crystal";
    else if (nResource==RESOURCE_MEAT) return "Meat";
    else if (nResource==RESOURCE_MITHRIL_BAR) return "Mithril Bar";
    else if (nResource==RESOURCE_MITHRIL_ORE) return "Mithril Ore";
    else if (nResource==RESOURCE_MITHRIL_PART) return "Mithril Part";
    else if (nResource==RESOURCE_POISON_FUNGuS) return "Poison Fungus";
    else if (nResource==RESOURCE_PORTAL_WOOD) return "Portal Wood";
    else if (nResource==RESOURCE_RARE_HERB) return "Rare Herb";
    else if (nResource==RESOURCE_SILK) return "Silk";
    else if (nResource==RESOURCE_SLAAD_TONGUE) return "Slaad Tongue";
    else if (nResource==RESOURCE_SOUL_GEM) return "Soul Gem";
    else if (nResource==RESOURCE_SPICE) return "Spice";
    else if (nResource==RESOURCE_SPIRITS) return "Spirits";
    else if (nResource==RESOURCE_UNCOMMON_HERB) return "Uncommon Herb";
    else if (nResource==RESOURCE_WATER) return "Water";
    else if (nResource==RESOURCE_WINE) return "Wine";
    else if (nResource==RESOURCE_WOOD) return "Wood";
    else if (nResource==RESOURCE_WOOD_PART) return "Wood Part";
    return "";
} // Area_GetResourceName()


string Area_GetStorageName(int nResource)
{ // PURPOSE: This would return the resource tag container portion.
    if (nResource==RESOURCE_ADMANTIUM_BAR) return "METALS";
    else if (nResource==RESOURCE_IRON_BAR) return "METALS";
    else if (nResource==RESOURCE_MITHRIL_BAR) return "METALS";
    else if (nResource==RESOURCE_GOLD_BAR) return "TREASURY";
    else if (nResource==RESOURCE_ADMANTIUM_ORE) return "ORES";
    else if (nResource==RESOURCE_COAL) return "COAL";
    else if (nResource==RESOURCE_IRON_ORE) return "ORES";
    else if (nResource==RESOURCE_MITHRIL_ORE) return "ORES";
    else if (nResource==RESOURCE_GOLD_ORE) return "ORES";
    else if (nResource==RESOURCE_GRAIN) return "GRAIN";
    else if (nResource==RESOURCE_FISH) return "MEATS";
    else if (nResource==RESOURCE_MEAT) return "MEATS";
    else if (nResource==RESOURCE_FRUIT) return "FRUIT";
    else if (nResource==RESOURCE_ALE) return "LIQUOR";
    else if (nResource==RESOURCE_HIDE) return "HIDES";
    else if (nResource==RESOURCE_LEATHER) return "LEATHER";
    else if (nResource==RESOURCE_WOOD) return "WOOD";
    else if (nResource==RESOURCE_PORTAL_WOOD) return "WOOD";
    else if (nResource==RESOURCE_CORPSE) return "CORPSEPILE";
    else if (nResource==RESOURCE_LIQUID_EUPHORIA) return "LIQUOR";
    else if (nResource==RESOURCE_LIQUID_PAIN) return "LIQUOR";
    else if (nResource==RESOURCE_SPIRITS) return "LIQUOR";
    else if (nResource==RESOURCE_WINE) return "LIQUOR";
    else if (nResource==RESOURCE_WATER) return "WATER";
    else if (nResource==RESOURCE_MANA_CRYSTAL) return "TREASURY";
    else if (nResource==RESOURCE_FOOD) return "FOOD";
    else if (nResource==RESOURCE_FUNGUS) return "GRAIN";
    else if (nResource==RESOURCE_ADMANTIUM_PART) return "MISC";
    else if (nResource==RESOURCE_ART) return "TREASURY";
    else if (nResource==RESOURCE_BLOOD) return "MISC";
    else if (nResource==RESOURCE_BODAK_TOOTH) return "MISC";
    else if (nResource==RESOURCE_COMMON_HERB) return "MISC";
    else if (nResource==RESOURCE_DEMON_FLESH) return "MISC";
    else if (nResource==RESOURCE_DRAGON_BLOOD) return "MISC";
    else if (nResource==RESOURCE_DYE) return "MISC";
    else if (nResource==RESOURCE_FAERIE_DUST) return "MISC";
    else if (nResource==RESOURCE_FEATHERS) return "MISC";
    else if (nResource==RESOURCE_FIRE_BEETLE_BELLY) return "MISC";
    else if (nResource==RESOURCE_FLOUR) return "GRAIN";
    else if (nResource==RESOURCE_HEAD) return "MISC";
    else if (nResource==RESOURCE_HEART) return "MISC";
    else if (nResource==RESOURCE_IRON_PART) return "MISC";
    else if (nResource==RESOURCE_MAIL) return "MISC";
    else if (nResource==RESOURCE_POISON_FUNGuS) return "MISC";
    else if (nResource==RESOURCE_RARE_HERB) return "MISC";
    else if (nResource==RESOURCE_SILK) return "TREASURY";
    else if (nResource==RESOURCE_SLAAD_TONGUE) return "MISC";
    else if (nResource==RESOURCE_SOUL_GEM) return "TREASURY";
    else if (nResource==RESOURCE_SPICE) return "MISC";
    else if (nResource==RESOURCE_UNCOMMON_HERB) return "MISC";
    else if (nResource==RESOURCE_WOOD_PART) return "MISC";
    return "";
} // Area_GetStorageName()


string Area_GetResourceVar(int nResource)
{ // PURPOSE: Return the specific Resource variable
    return "nRes"+GetStringLeft(Area_GetStorageName(nResource),3)+IntToString(nResource);
} // Area_GetResourceVar()


object Area_GetStorage(object oArea,int nResource,int bGlobal=FALSE,string sTeamID="")
{ // PURPOSE: Get Resource Storage
    string sTag=GetTag(oArea);
    object oOb=OBJECT_INVALID;
    object oWP=GetWaypointByTag("AREA_"+sTag);
    string sS;
    if (GetIsObjectValid(oArea)&&GetIsObjectValid(oWP))
    { // exists
        sS=Area_GetStorageName(nResource);
        if (GetStringLength(sS)>0)
        { // name
            oOb=GetNearestObjectByTag("STORAGE_"+sS,oWP);
            if (!GetIsObjectValid(oOb)) oOb=GetNearestObjectByTag("STORAGE_"+sTeamID+"_"+sS,oWP);
            if (!GetIsObjectValid(oOb)&&bGlobal) oOb=GetObjectByTag("STORAGE_"+sTeamID+"_"+sS);
        } // name
        if (!GetIsObjectValid(oOb)) oOb=GetNearestObjectByTag("AREA_STORAGE",oWP);
    } // exists
    return oOb;
} // Area_GetStorage()


int Area_GetResourceCode(object oItem)
{ // PURPOSE: return resource code
    string sTag;
    if (GetIsObjectValid(oItem)&&GetObjectType(oItem)==OBJECT_TYPE_ITEM)
    { // valid
        sTag=GetTag(oItem);
        if (sTag=="res_coal") return RESOURCE_COAL;
        else if (sTag=="res_wood_portal") return RESOURCE_PORTAL_WOOD;
        else if (sTag=="res_abar") return RESOURCE_ADMANTIUM_BAR;
        else if (sTag=="res_aore") return RESOURCE_ADMANTIUM_ORE;
        else if (sTag=="res_gbar") return RESOURCE_GOLD_BAR;
        else if (sTag=="res_gore") return RESOURCE_GOLD_ORE;
        else if (sTag=="res_ibar") return RESOURCE_IRON_BAR;
        else if (sTag=="res_iore") return RESOURCE_IRON_ORE;
        else if (sTag=="res_mbar") return RESOURCE_MITHRIL_BAR;
        else if (sTag=="res_more") return RESOURCE_MITHRIL_ORE;
        else if (sTag=="res_wood") return RESOURCE_WOOD;
        else if (sTag=="res_hide") return RESOURCE_HIDE;
        else if (sTag=="res_leather") return RESOURCE_LEATHER;
        else if (sTag=="res_fish") return RESOURCE_FISH;
        else if (sTag=="res_food") return RESOURCE_FOOD;
        else if (sTag=="res_fruit") return RESOURCE_FRUIT;
        else if (sTag=="res_fungus") return RESOURCE_FUNGUS;
        else if (sTag=="res_grain") return RESOURCE_GRAIN;
        else if (sTag=="res_water") return RESOURCE_WATER;
        else if (sTag=="res_meat") return RESOURCE_MEAT;
        else if (sTag=="res_manac") return RESOURCE_MANA_CRYSTAL;
        else if (sTag=="res_lpain") return RESOURCE_LIQUID_PAIN;
        else if (sTag=="res_leuph") return RESOURCE_LIQUID_EUPHORIA;
        else if (sTag=="res_corpse") return RESOURCE_CORPSE;
        else if (sTag=="NW_IT_MPOTION021") return RESOURCE_ALE;
        else if (sTag=="NW_IT_MPOTION022") return RESOURCE_SPIRITS;
        else if (sTag=="NW_IT_MPOTION023") return RESOURCE_WINE;
        else if (sTag=="res_flour") return RESOURCE_FLOUR;
        else if (sTag=="res_cherb") return RESOURCE_COMMON_HERB;
        else if (sTag=="res_uherb") return RESOURCE_UNCOMMON_HERB;
        else if (sTag=="res_rherb") return RESOURCE_RARE_HERB;
        else if (sTag=="res_art") return RESOURCE_ART;
        else if (sTag=="res_dye") return RESOURCE_DYE;
        else if (sTag=="res_soul") return RESOURCE_SOUL_GEM;
        else if (sTag=="res_blood") return RESOURCE_BLOOD;
        else if (sTag=="res_silk") return RESOURCE_SILK;
        else if (sTag=="res_spice") return RESOURCE_SPICE;
        else if (sTag=="res_pfungus") return RESOURCE_POISON_FUNGuS;
        else if (sTag=="res_mail") return RESOURCE_MAIL;
        else if (sTag=="res_feather") return RESOURCE_FEATHERS;
        else if (sTag=="NW_IT_MSMLMISC17") return RESOURCE_DRAGON_BLOOD;
        else if (sTag=="NW_IT_MSMLMISC10") return RESOURCE_SLAAD_TONGUE;
        else if (sTag=="NW_IT_MSMLMISC19") return RESOURCE_FAERIE_DUST;
        else if (sTag=="NW_IT_MSMLMISC06") return RESOURCE_BODAK_TOOTH;
        else if (sTag=="NW_IT_MSMLMISC08") return RESOURCE_FIRE_BEETLE_BELLY;
        else if (sTag=="res_demonf") return RESOURCE_DEMON_FLESH;
        else if (sTag=="res_heart") return RESOURCE_HEART;
        else if (sTag=="res_head") return RESOURCE_HEAD;
        else if (sTag=="res_wpart") return RESOURCE_WOOD_PART;
        else if (sTag=="res_mpart") return RESOURCE_MITHRIL_PART;
        else if (sTag=="res_ipart") return RESOURCE_IRON_PART;
        else if (sTag=="res_apart") return RESOURCE_ADMANTIUM_PART;
    } // valid
    return 0;
} // Area_GetResourceCode()


string Area_GetResourceResRef(int nResource)
{ // PURPOSE: To return the resref for the resource
    if (nResource==RESOURCE_COAL) return "res_coal";
    else if (nResource==RESOURCE_ADMANTIUM_BAR) return "res_abar";
    else if (nResource==RESOURCE_ADMANTIUM_ORE) return "res_aore";
    else if (nResource==RESOURCE_PORTAL_WOOD) return "res_wood_portal";
    else if (nResource==RESOURCE_GOLD_BAR) return "res_gbar";
    else if (nResource==RESOURCE_GOLD_ORE) return "res_gore";
    else if (nResource==RESOURCE_IRON_BAR) return "res_ibar";
    else if (nResource==RESOURCE_IRON_ORE) return "res_iore";
    else if (nResource==RESOURCE_MITHRIL_BAR) return "res_mbar";
    else if (nResource==RESOURCE_MITHRIL_ORE) return "res_more";
    else if (nResource==RESOURCE_WOOD) return "res_wood";
    else if (nResource==RESOURCE_HIDE) return "res_hide";
    else if (nResource==RESOURCE_LEATHER) return "res_leather";
    else if (nResource==RESOURCE_FISH) return "res_fish";
    else if (nResource==RESOURCE_FOOD) return "res_food";
    else if (nResource==RESOURCE_FRUIT) return "res_fruit";
    else if (nResource==RESOURCE_FUNGUS) return "res_fungus";
    else if (nResource==RESOURCE_GRAIN) return "res_grain";
    else if (nResource==RESOURCE_WATER) return "res_water";
    else if (nResource==RESOURCE_MEAT) return "res_meat";
    else if (nResource==RESOURCE_MANA_CRYSTAL) return "res_manac";
    else if (nResource==RESOURCE_LIQUID_PAIN) return "res_lpain";
    else if (nResource==RESOURCE_LIQUID_EUPHORIA) return "res_leuph";
    else if (nResource==RESOURCE_CORPSE) return "res_corpse";
    else if (nResource==RESOURCE_ALE) return "nw_it_mpotion021";
    else if (nResource==RESOURCE_SPIRITS) return "nw_it_mpotion022";
    else if (nResource==RESOURCE_WINE) return "nw_it_mpotion023";
    else if (nResource==RESOURCE_ADMANTIUM_PART) return "res_apart";
    else if (nResource==RESOURCE_ART) return "res_art";
    else if (nResource==RESOURCE_BLOOD) return "res_blood";
    else if (nResource==RESOURCE_BODAK_TOOTH) return "nw_it_msmlmisc06";
    else if (nResource==RESOURCE_COMMON_HERB) return "res_cherb";
    else if (nResource==RESOURCE_DEMON_FLESH) return "res_demonf";
    else if (nResource==RESOURCE_DRAGON_BLOOD) return "nw_it_msmlmisc17";
    else if (nResource==RESOURCE_DYE) return "res_dye";
    else if (nResource==RESOURCE_FAERIE_DUST) return "nw_it_msmlmisc19";
    else if (nResource==RESOURCE_FEATHERS) return "res_feather";
    else if (nResource==RESOURCE_FIRE_BEETLE_BELLY) return "nw_it_msmlmisc08";
    else if (nResource==RESOURCE_FLOUR) return "res_flour";
    else if (nResource==RESOURCE_HEAD) return "res_head";
    else if (nResource==RESOURCE_HEART) return "res_heart";
    else if (nResource==RESOURCE_IRON_PART) return "res_ipart";
    else if (nResource==RESOURCE_MAIL) return "res_mail";
    else if (nResource==RESOURCE_MITHRIL_PART) return "res_mpart";
    else if (nResource==RESOURCE_POISON_FUNGuS) return "res_pfungus";
    else if (nResource==RESOURCE_RARE_HERB) return "res_rherb";
    else if (nResource==RESOURCE_SILK) return "res_silk";
    else if (nResource==RESOURCE_SLAAD_TONGUE) return "nw_it_msmlmisc10";
    else if (nResource==RESOURCE_SOUL_GEM) return "res_soul";
    else if (nResource==RESOURCE_SPICE) return "res_spice";
    else if (nResource==RESOURCE_UNCOMMON_HERB) return "res_uherb";
    else if (nResource==RESOURCE_WOOD_PART) return "res_wpart";
    return "";
} // Area_GetResourceResRef()


void Area_StoreBox(object oBox,int nResource)
{ // PURPOSE: This will store the specified resource.
    int nC;
    object oItem;
    string sTag=GetTag(GetArea(oBox));
    oItem=GetFirstItemInInventory();
    while(GetIsObjectValid(oItem))
    { // store
        if (Area_GetResourceCode(oItem)==nResource)
        { // found
            nC=nC+GetItemStackSize(oItem);
            DelayCommand(0.02,DestroyObject(oItem));
        } // found
        oItem=GetNextItemInInventory();
    } // store
    if (nC>0) NBDE_SetCampaignInt(MODULE_DATABASE,"nResStore_"+sTag+"_"+IntToString(nResource),nC);
    else { NBDE_DeleteCampaignInt(MODULE_DATABASE,"nResStore_"+sTag+"_"+IntToString(nResource)); }
} // Area_StoreBox()


void Area_PopulateBox(object oBox,int nResource)
{ // PURPOSE: Make items on box
    int nC;
    object oItem;
    string sTag;
    string sRes;
    if (GetIsObjectValid(oBox)&&nResource>0)
    { // exists
        sRes=Area_GetResourceResRef(nResource);
        sTag=GetTag(GetArea(oBox));
        nC=NBDE_GetCampaignInt(MODULE_DATABASE,"nResStore_"+sTag+"_"+IntToString(nResource));
        while(nC>0)
        { // create items
            oItem=CreateItemOnObject(sRes,oBox,nC);
            nC=nC-GetItemStackSize(oItem);
        } // create items
    } // exists
} // Area_PopulateBox()


int Area_GetResourceAmount(object oArea,int nResource)
{ // PURPOSE: Return the resource amount
    string sTag=GetTag(oArea);
    if (GetStringLength(GetLocalString(oArea,"sLair"))>0) sTag="L_"+GetLocalString(oArea,"sLair");
    return NBDE_GetCampaignInt(MODULE_DATABASE,"nResStore_"+sTag+"_"+IntToString(nResource));
} // Area_GetResourceAmount()


void Area_SetResourceAmount(object oArea,int nResource,int nAmount)
{ // PURPOSE: This will set the resource amount
    string sTag=GetTag(oArea);
    if (GetStringLength(GetLocalString(oArea,"sLair"))>0) sTag="L_"+GetLocalString(oArea,"sLair");
    NBDE_SetCampaignInt(MODULE_DATABASE,"nResStore_"+sTag+"_"+IntToString(nResource),nAmount);
} // Area_SetResourceAmount()


void Area_StoreBoxMisc(object oBox)
{ // PURPOSE: This will store non-resource items
    object oItem;
    int nR;
    int nC;
    int nPID=GetLocalInt(oBox,"nPID");
    string sPrefix;
    string sR;
    //SendMessageToPC(GetFirstPC(),"Area_StoreBoxMisc("+GetName(oBox)+")");
    if (GetIsObjectValid(oBox)&&nPID>0)
    { // box is valid
        sPrefix="BoxInv_"+IntToString(nPID)+"_";
        //SendMessageToPC(GetFirstPC()," sPrefix='"+sPrefix+"'");
        oItem=GetFirstItemInInventory(oBox);
        while(GetIsObjectValid(oItem))
        { // store
            nR=Area_GetResourceCode(oItem);
            if (nR==0)
            { // not a resource
                nC=GetItemStackSize(oItem);
                nR=List_AddMember(MODULE_DATABASE,sPrefix);
                sR=GetResRef(oItem);
                //SendMessageToPC(GetFirstPC(),"  Store:nR="+IntToString(nR)+"  Count:"+IntToString(nC)+"  Name:'"+GetName(oItem)+"' sRes='"+sR+"'");
                List_SetMemberString(MODULE_DATABASE,sPrefix,"sRes",nR,sR);
                List_SetMemberString(MODULE_DATABASE,sPrefix,"sTag",nR,GetTag(oItem));
                List_SetMemberString(MODULE_DATABASE,sPrefix,"sName",nR,GetName(oItem));
                List_SetMemberInt(MODULE_DATABASE,sPrefix,"nQty",nR,nC);
                DelayCommand(0.02,DestroyObject(oItem));
            } // not a resource
            oItem=GetNextItemInInventory(oBox);
        } // store
    } // box is valid
} // Area_StoreBoxMisc()


void fnArea_PopBoxMiscRecurse(object oBox,int nR,string sPrefix)
{ // PURPOSE: Fill the box and avoid TMI errors
    object oItem;
    int nN;
    int nC;
    string sR;
    string sT;
    string sN;
    nN=List_GetNextMember(MODULE_DATABASE,sPrefix);
    nC=List_GetMemberInt(MODULE_DATABASE,sPrefix,"nQty",nR);
    sR=List_GetMemberString(MODULE_DATABASE,sPrefix,"sRes",nR);
    sT=List_GetMemberString(MODULE_DATABASE,sPrefix,"sTag",nR);
    sN=List_GetMemberString(MODULE_DATABASE,sPrefix,"sName",nR);
    if (GetStringLength(sR)<1) sR=sT;
    oItem=CreateItemOnObject(sR,oBox,nC,sT);
    SetName(oItem,sN);
    //SendMessageToPC(GetFirstPC(),"  fnArea_PopBoxMiscRecurse("+IntToString(nR)+")");
    //SendMessageToPC(GetFirstPC(),"    sR='"+sR+"' sT='"+sT+"' sN='"+sN+"' nC="+IntToString(nC)+"  nNext="+IntToString(nN));
    List_DeleteMember(MODULE_DATABASE,sPrefix,nR);
    if (nN>0) DelayCommand(0.05,fnArea_PopBoxMiscRecurse(oBox,nN,sPrefix));
} // fnArea_PopBoxMiscRecurse()


void Area_PopulateBoxMisc(object oBox)
{ // PURPOSE: This will retrieve non-resource items in this container
    int nR;
    int nPID=GetLocalInt(oBox,"nPID");
    string sPrefix;
    //SendMessageToPC(GetFirstPC(),"Area_PopulateBoxMisc("+GetName(oBox)+")");
    if (GetIsObjectValid(oBox)&&nPID>0)
    { // box is valid
        sPrefix="BoxInv_"+IntToString(nPID)+"_";
        nR=List_GetFirstMember(MODULE_DATABASE,sPrefix);
        //SendMessageToPC(GetFirstPC(),"  sPrefix='"+sPrefix+"' nR="+IntToString(nR));
        if (nR>0)
        { // list exists
            fnArea_PopBoxMiscRecurse(oBox,nR,sPrefix);
        } // list exists
    } // box is valid
} // Area_PopulateBoxMisc()


int Area_GetManaMax(object oArea)
{ // PURPOSE: Get Max Mana
    string sLair=GetLocalString(oArea,"sLair");
    string sTag=GetTag(oArea);
    int nMana;
    if (GetStringLength(sLair)>0) sTag=sLair;
    nMana=NBDE_GetCampaignInt(MODULE_DATABASE,"nMaxMana_"+GetTag(oArea));
    if (nMana==0)
    { // check default
        nMana=GetLocalInt(oArea,"nMaxMana");
        if (nMana==0)
        { // calculate
            if (GetStringLength(sLair)>0) nMana=5;
            else if (GetIsAreaNatural(oArea)&&GetIsAreaAboveGround(oArea)) nMana=3;
            else if (!GetIsAreaAboveGround(oArea)) nMana=2;
            else { nMana=1; }
            return nMana;
        } // calculate
    } // calculate
    if (nMana==-1) return 0;
    return 1;
} // Area_GetManaMax()


int Area_GetCurrentMana(object oArea)
{ // PURPOSE: Get Current Mana
    string sLair=GetLocalString(oArea,"sLair");
    string sTag=GetTag(oArea);
    if (GetStringLength(sLair)>0) sTag=sLair;
    return NBDE_GetCampaignInt(MODULE_DATABASE,"nCurrentMana_"+sTag);
} // Area_GetCurrentMana()


void Area_SetCurrentMana(object oArea,int nAmount)
{ // PURPOSE: Set Current Mana
    string sLair=GetLocalString(oArea,"sLair");
    string sTag=GetTag(oArea);
    if (GetStringLength(sLair)>0) sTag=sLair;
    NBDE_SetCampaignInt(MODULE_DATABASE,"nCurrentMana_"+sTag,nAmount);
} // Area_SetCurrentMana()


void Area_SetManaMax(object oArea,int nAmount)
{ // PURPOSE: Set Mana Max
    string sLair=GetLocalString(oArea,"sLair");
    string sTag=GetTag(oArea);
    if (GetStringLength(sLair)>0) sTag=sLair;
    NBDE_SetCampaignInt(MODULE_DATABASE,"nMaxMana_"+sTag,nAmount);
} // Area_SetManaMax()


void Area_DoManaUpdate(object oArea)
{ // PURPOSE: Do Mana Update
    int nMax=Area_GetManaMax(oArea);
    Area_SetCurrentMana(oArea,nMax);
} // Area_DoManaUpdate()

//void main(){}
