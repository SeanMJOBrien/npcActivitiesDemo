// npcact_cms_amrg - merge piles
#include "npcact_h_money"
void main()
{
    object oPC=GetPCSpeaker();
    object oItem=GetLocalObject(oPC,"oCMSItem");
    object oTarget=GetLocalObject(oPC,"oCMSTarget");
    MergeCoins(oPC,oItem,oTarget);
}
