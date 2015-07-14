///////////////////////////////////////////////////////////////////////
// npcact_cp_m_tp - NPC ACTIVITIES 6.0 Professions Merchant
// Test if Persuasion is okay
// By Deva Bryson Winblood.  07/15/2005        // 99063
///////////////////////////////////////////////////////////////////////

int StartingConditional()
{
    object oMerchant=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    int nR;
    string sSay="Surely, you can do better than that.";
    int nGender=GetGender(oPC);
    if (GetSkillRank(SKILL_PERSUADE,oPC)<1) return FALSE;
    if (GetLocalInt(oMerchant,"bProfMerchBarterOK")!=1) return FALSE;
    nR=d6();
    if (nGender==GENDER_FEMALE)
    { // female
      if (nR==1) sSay="Would you be kind to a lady and perhaps give me a slightly better deal?";
      else if (nR==2) sSay="Come now, I have barely enough money to feed myself.  Can you give me perhaps a better price?";
      else if (nR==3) sSay="My children are starving and yet that is the best you have to offer?";
      else if (nR==4) sSay="I might be especially kind if you would lower the price a bit.";
      else if (nR==5) sSay="How can I afford a new dress if you want all of my coin?";
      else if (nR==6) sSay="If you are kind to me, I might be kind to you.";
    } // female
    else
    { // not female
      if (nR==1) sSay="Please, is that the best you can do?";
      else if (nR==2) sSay="Sir, surely you jest! I could do better than that elsewhere.";
      else if (nR==3) sSay="Come now, you must be able to do a little better than that.";
      else if (nR==4) sSay="I'd surely appreciate it if you could do better than that.";
      else if (nR==5) sSay="I am certain that there is another shop with a better price.";
      else if (nR==6) sSay="I haven't eaten for days and now I have to give you all that I have?";
    } // not female
    SetCustomToken(99063,sSay);
    return TRUE;
}
