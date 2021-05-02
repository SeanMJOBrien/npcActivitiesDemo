//:: FileName henchman_joins
// Henchman joins PC, booting other henchman if necessary

#include "nw_i0_henchman"

void main()
{
 if (GetIsObjectValid(GetHenchman(GetPCSpeaker())) == TRUE)
 {  SetFormerMaster(GetPCSpeaker(), GetHenchman(GetPCSpeaker()));
    object oHench =   GetHenchman(GetPCSpeaker());
    RemoveHenchman(GetPCSpeaker(), GetHenchman(GetPCSpeaker()));
    AssignCommand(oHench, ClearAllActions());
 }

 SetWorkingForPlayer(GetPCSpeaker());
 SetBeenHired();

 ExecuteScript("NW_CH_JOIN", OBJECT_SELF);
}
