///////////////////////////////////////////////////////////////////////
// npcact_cp_m_ti - NPC ACTIVITIES 6.0 Professions Merchant
// Test if Intimidate is okay
// By Deva Bryson Winblood.  07/21/2005        // 99063
///////////////////////////////////////////////////////////////////////

int StartingConditional()
{
    object oMerchant=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    int nR;
    string sSay="I suggest you do better than that!";
    if (GetSkillRank(SKILL_INTIMIDATE,oPC)<1) return FALSE;
    if (GetLocalInt(oMerchant,"bProfMerchBarterOK")!=1) return FALSE;
    nR=d6();
    if (nR==1) sSay="I assume that if I were to cause you pain you could offer a better price.";
    else if (nR==2) sSay="I might have to report you as a thief if you continue to say prices like that!";
    else if (nR==3) sSay="Do better than that!";
    else if (nR==4) sSay="The last person that tried to cheat me like that came to regret their decision!";
    else if (nR==5) sSay="Pain is something that when applied properly usually causes people like you to offer better prices!";
    else if (nR==6) sSay="I will hurt you if you continue to try to cheat me!";
    SetCustomToken(99064,sSay);
    return TRUE;
}
