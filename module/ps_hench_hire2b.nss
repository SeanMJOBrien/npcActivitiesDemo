#include "ps_timestamp"
#include "x0_i0_henchman"

void main()
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
int nDaysToHire = 2;
    SetPlotFlag(OBJECT_SELF, FALSE);
    SetImmortal(OBJECT_SELF, FALSE);
int nDebitHour = GetLocalInt(oPC,"DebitHour");
TakeGoldFromCreature((nRate*nDaysToHire),oPC,TRUE);
int nHoursToHire = nDaysToHire * 23;
//if (nDebitHour > 0)
//    {
//    nHoursToHire += nDebitHour;
//    SendMessageToPC(oPC,"Your debited time has been added to your new hireling's commissioned time. You are no longer debited time.");
//    DeleteLocalInt(oPC, "DebitHour");
//    }
AdvanceTimeStamp(OBJECT_SELF,0,0,0,nHoursToHire,1);

    HireHenchman(oPC);

}
