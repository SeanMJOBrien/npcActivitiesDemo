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
if (GetGold(oPC) > (nRate - 1)) return TRUE;
return FALSE;
}
