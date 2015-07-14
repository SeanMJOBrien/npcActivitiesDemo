// This conditional determines if this henchman is currently
// not actively hired by anyone.

#include "x0_i0_henchman"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nBargain = GetLocalInt(oPC,GetTag(OBJECT_SELF)+"_BARGAIN");
if (nBargain == FALSE)
    {
    nBargain = d20() + GetSkillRank(SKILL_PERSUADE,oPC) + GetAbilityModifier(ABILITY_CHARISMA,oPC);
    SetLocalInt(oPC,GetTag(OBJECT_SELF)+"_BARGAIN",nBargain);
    }
int nRate = (15 - nBargain) + (GetHitDice(OBJECT_SELF) * 6);
if (nRate < 1) nRate = 1;
SetCustomToken(920,IntToString(nRate));
    if (!GetIsHired() && (GetHenchman(GetPCSpeaker()) == OBJECT_INVALID))
        return TRUE;

    return FALSE;
}
