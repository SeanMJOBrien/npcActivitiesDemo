// npcact_cms_cthf - Thieving
#include "npcact_h_money"

int StartingConditional()
{
    object oPC=GetPCSpeaker();
    object oTarget=GetLocalObject(oPC,"oCMSTarget");
    object oItem=GetLocalObject(oPC,"oCMSItem");
    if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE&&oTarget!=oPC)
    { // self target
      if (GetLocalInt(oPC,"bCMSDoThief")==TRUE) return TRUE;
    } // self target
    return FALSE;
}
