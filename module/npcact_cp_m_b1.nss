////////////////////////////////////////////////////////////////////////
// npcact_cp_m_b1 - NPC ACTIVITIES 6.0 Profession Merchant - Buy 1
// By Deva Bryson Winblood.  07/09/2005
////////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"
//////////////////////////////////////
// PROTOTYPES
//////////////////////////////////////


///////////////////////////////////////////////////// MAIN
void main()
{
    object oPC=GetPCSpeaker();
    object oMerchant=OBJECT_SELF;
    object oStore=MerchantCreateStore(oMerchant,oPC,0);
}
///////////////////////////////////////////////////// MAIN

///////////////////////////
// FUNCTIONS
///////////////////////////