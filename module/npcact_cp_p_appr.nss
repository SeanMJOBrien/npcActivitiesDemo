///////////////////////////////////////////////////////////////////////
// npcact_cp_p_appr - NPC ACTIVITIES 6.0 Profession Merchant
// Appraise okay?
// By Deva Bryson Winblood. 07/15/2005
///////////////////////////////////////////////////////////////////////
int StartingConditional()
{
    object oMerchant=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    if (GetSkillRank(SKILL_APPRAISE,oPC)<1) return FALSE;
    if (GetLocalInt(oMerchant,"bProfMerchBarterOK")!=1) return FALSE;
    return TRUE;
}
