///////////////////////////////////////////////////////////////////////
// npcact_cp_m_pchk - NPC ACTIVITIES 6.0 Professions Merchant
// Persuasion Check
// Store Amount of check missed by as
// nPersuasionCheck on PC.  If number is negative then that is how
// much it succeeded by.  If it is positive then that is how much it
// fails by.  sPersuasionSay on PC is what the merchant will say.
//---------------------------------------------------------------------
// By Deva Bryson Winblood. 07/21/2005
///////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"
#include "npcact_h_colors"
void main()
{
    object oMerchant=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    int nPDC=GetLocalInt(oMerchant,"nProfMerchBarterPDC");
    int nPSC=GetLocalInt(oMerchant,"nProfMerchBarterPSC");
    int nPMF=GetLocalInt(oMerchant,"nProfMerchBarterPMF");
    int nPCF=GetLocalInt(oMerchant,"nProfMerchBarterPCF");
    string sSay;
    string sPMF=GetLocalString(oMerchant,"sProfMerchBarterPMF");
    string sPCF=GetLocalString(oMerchant,"sProfMerchBarterPCF");
    string sPYS=GetLocalString(oMerchant,"sProfMerchBarterPYS");
    int nDC;
    int nR;
    int nSkill=GetSkillRank(SKILL_PERSUADE,oPC);
    int nCurrentPrice=GetLocalInt(oPC,"nProfMerchPrice");
    object oItem=GetLocalObject(oPC,"oMerchItem");
    int nV;
    float fPrice;
    float fMarkup;
    string sPID=fnGeneratePID(oPC);
    int nPCount=GetLocalInt(oMerchant,"nPCount_"+sPID);
    int nMaxPrice;
    int nMinPrice;
    int nN;
    int bStolen=GetStolenFlag(oItem);
    string sS;
    string sCost;
    int nCurrency=GetLocalInt(oMerchant,"nProfMerchCurrency");
    if (nPDC==0) nPDC=10;
    if (nPSC==0) nPSC=4+d4();
    nDC=GetSkillRank(SKILL_PERSUADE,oMerchant)+nPDC;
    nV=GetPrice(GetResRef(oItem),oMerchant,100,GetItemStackSize(oItem));
    nMaxPrice=GetLocalInt(oMerchant,"nProfMerchBarterMSN");
    if (nMaxPrice==0) nMaxPrice=125;
    nMinPrice=GetLocalInt(oMerchant,"nProfMerchBarterLSN");
    if (nMinPrice==0) nMinPrice=100;
    if (bStolen)
    { // stolen items
      nMaxPrice=GetLocalInt(oMerchant,"nProfMerchBarterMSS");
      if (nMaxPrice==0) nMaxPrice=150;
      nMinPrice=GetLocalInt(oMerchant,"nProfMerchBarterLSS");
      if (nMaxPrice==0) nMinPrice=100;
    } // stolen items
    fPrice=IntToFloat(nV);
    fMarkup=IntToFloat(nMaxPrice)/100.0;
    fPrice=fPrice*fMarkup;
    nMaxPrice=FloatToInt(fPrice); // determine maximum price
    fPrice=IntToFloat(nV);
    fMarkup=IntToFloat(nMinPrice)/100.0;
    fPrice=fPrice*fMarkup;
    nMinPrice=FloatToInt(fPrice);  // determine minimum price
    nR=d20()+nSkill; // skill check
    sS=ColorRGBString("[persuade attempt]",6,2,2);
    sS=sS+" ROLL: "+ColorRGBString(IntToString(nR),2,2,6);
    nDC=nDC-nR;
    SetLocalInt(oPC,"nPersuasionCheck",nDC);
    if (nDC<1)
    { // success
      sS=sS+ColorRGBString(" [success]",0,6,0);
    } // success
    else
    { // fail
      sS=sS+ColorRGBString(" [failure]",6,0,0);
    } // fail
    SendMessageToPC(oPC,sS);
    sS="";
    if (nDC<1&&nPCount<nPSC)
    { // success
      nV=100-abs(nDC)-2;
      fMarkup=IntToFloat(nV)/100.0;
      //SendMessageToPC(oPC,"nV: "+IntToString(nV)+" nDC: "+IntToString(nDC)+" fMarkup: "+FloatToString(fMarkup));
      fPrice=IntToFloat(nCurrentPrice)*fMarkup;
      nV=FloatToInt(fPrice);
      //SendMessageToPC(oPC,"nCurrentPrice: "+IntToString(nCurrentPrice)+"  fPrice: "+FloatToString(fPrice)+" New nV: "+IntToString(nV));
      if (nV<nMinPrice) nV=nMinPrice;
      //SendMessageToPC(oPC,"nMinPrice: "+IntToString(nMinPrice)+"  nV: "+IntToString(nV));
      nR=d4();
      sCost=MoneyToString(nV,nCurrency,TRUE);
      if (nR==1) sSay="Well, I might settle for "+sCost;
      else if (nR==2) sSay="How about "+sCost;
      else if (nR==3) sSay="I think a fair price is "+sCost;
      else if (nR==4) sSay="I see.  I can accept "+sCost;
      if (GetStringLength(sPYS)>0) sSay=sPYS+" "+sCost;
      SetLocalString(oPC,"sProfMerchSays",sSay);
      SetLocalInt(oPC,"nProfMerchPrice",nV);
      AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",FALSE,FALSE));
    } // success
    else if (nDC<5&&nPCount<nPSC)
    { // minor failure
      if (nPMF==0)
      { // no reaction
        sCost=MoneyToString(nCurrentPrice,nCurrency,TRUE);
        nR=d4();
        if (nR==1) sSay="I'm afraid the best I have to offer is "+sCost;
        else if (nR==2) sSay="I think I'll stick with "+sCost;
        else if (nR==3) sSay="I believe the price I offered is good.  That price is "+sCost;
        else if (nR==4) sSay="I am sure the price is fair.  It was "+sCost;
        if (GetStringLength(sPMF)>0) sSay=sPMF+" "+sCost;
        SetLocalString(oPC,"sProfMerchSays",sSay);
        AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",FALSE,FALSE));
      } // no reaction
      else if (nPMF==1)
      { // Increase price by 10%
        fPrice=IntToFloat(nCurrentPrice)*1.1;
        nV=FloatToInt(fPrice);
        if (nV>nMaxPrice) nV=nMaxPrice;
        sCost=MoneyToString(nV,nCurrency,TRUE);
        nR=d4();
        if (nR==1) sSay="Perhaps, I should be asking more.  The price is "+sCost;
        else if (nR==2) sSay="Well, I suppose a better price is "+sCost;
        else if (nR==3) sSay="You are wrong this item is worth "+sCost;
        else if (nR==4) sSay="I think the item is worth more than I thought.  How about "+sCost;
        if (GetStringLength(sPMF)>0) sSay=sPMF+" "+sCost;
        SetLocalString(oPC,"sProfMerchSays",sSay);
        SetLocalInt(oPC,"nProfMerchPrice",nV);
        AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",FALSE,FALSE));
      } // Increase price by 10%
      else if (nPMF==2)
      { // change to worst price
        nV=nMaxPrice;
        sCost=MoneyToString(nV,nCurrency,TRUE);
        nR=d4();
        if (nR==1) sSay="Perhaps, I should be asking more.  The price is "+sCost;
        else if (nR==2) sSay="Well, I suppose a better price is "+sCost;
        else if (nR==3) sSay="You are wrong this item is worth "+sCost;
        else if (nR==4) sSay="I think the item is worth more than I thought.  How about "+sCost;
        if (GetStringLength(sPMF)>0) sSay=sPMF+" "+sCost;
        SetLocalString(oPC,"sProfMerchSays",sSay);
        SetLocalInt(oPC,"nProfMerchPrice",nV);
        AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",FALSE,FALSE));
      } // change to worst price
      else if (nPMF==3)
      { // 4 hour ban
        SetMerchantBan(oMerchant,oPC,4);
        nR=d4();
        if (nR==1) sSay="I think I am done speaking with you for awhile!";
        else if (nR==2) sSay="I've had enough of you!";
        else if (nR==3) sSay="Go bother someone else!";
        else if (nR==4) sSay="I am tired of talking to you!";
        if (GetStringLength(sPMF)>0) sSay=sPMF;
        AssignCommand(oMerchant,SpeakString(sSay));
        AssignCommand(oPC,fnPurgeInvalids());
      } // 4 hour ban
      else if (nPMF==4)
      { // 8 hour ban
        SetMerchantBan(oMerchant,oPC,8);
        nR=d4();
        if (nR==1) sSay="I think I am done speaking with you for awhile!";
        else if (nR==2) sSay="I've had enough of you!";
        else if (nR==3) sSay="Go bother someone else!";
        else if (nR==4) sSay="I am tired of talking to you!";
        if (GetStringLength(sPMF)>0) sSay=sPMF;
        AssignCommand(oMerchant,SpeakString(sSay));
        AssignCommand(oPC,fnPurgeInvalids());
      } // 8 hour ban
      else if (nPMF==5)
      { // 48 hour ban
        SetMerchantBan(oMerchant,oPC,48);
        nR=d4();
        if (nR==1) sSay="I think I am done speaking with you for awhile!";
        else if (nR==2) sSay="I've had enough of you!";
        else if (nR==3) sSay="Go bother someone else!";
        else if (nR==4) sSay="I am tired of talking to you!";
        if (GetStringLength(sPMF)>0) sSay=sPMF;
        AssignCommand(oMerchant,SpeakString(sSay));
        AssignCommand(oPC,fnPurgeInvalids());
      } // 48 hour ban
      else if (nPMF==6)
      { // permanent ban
        SetMerchantBan(oMerchant,oPC,-1);
        nR=d4();
        if (nR==1) sSay="I think I am done speaking with you for awhile!";
        else if (nR==2) sSay="I've had enough of you!";
        else if (nR==3) sSay="Go bother someone else!";
        else if (nR==4) sSay="I am tired of talking to you!";
        if (GetStringLength(sPMF)>0) sSay=sPMF;
        AssignCommand(oMerchant,SpeakString(sSay));
        AssignCommand(oPC,fnPurgeInvalids());
      } // permanent ban
      else if (nPMF==7)
      { // attack player
        SetIsTemporaryEnemy(oPC,oMerchant,TRUE,360.0);
        AssignCommand(oMerchant,ActionAttack(oPC));
        AssignCommand(oPC,fnPurgeInvalids());
      } // attack player
      else if (nPMF==8)
      { // custom script
        sS=GetLocalString(oMerchant,"sProfMerchBarterPMFScr");
        if (GetStringLength(sS)>0) ExecuteScript(sS,oMerchant);
      } // custom script
    } // minor failure
    else
    { // critical failure
      if (nPCF==0)
      { // no reaction
        sCost=MoneyToString(nCurrentPrice,nCurrency,TRUE);
        nR=d4();
        if (nR==1) sSay="I'm afraid the best I have to offer is "+sCost;
        else if (nR==2) sSay="I think I'll stick with "+sCost;
        else if (nR==3) sSay="I believe the price I offered is good.  That price is "+sCost;
        else if (nR==4) sSay="I am sure the price is fair.  It was "+sCost;
        if (GetStringLength(sPCF)>0) sSay=sPCF+" "+sCost;
        SetLocalString(oPC,"sProfMerchSays",sSay);
        AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",FALSE,FALSE));
      } // no reaction
      else if (nPCF==1)
      { // Increase price by 10%
        fPrice=IntToFloat(nCurrentPrice)*1.1;
        nV=FloatToInt(fPrice);
        if (nV>nMaxPrice) nV=nMaxPrice;
        sCost=MoneyToString(nV,nCurrency,TRUE);
        nR=d4();
        if (nR==1) sSay="Perhaps, I should be asking more.  The price is "+sCost;
        else if (nR==2) sSay="Well, I suppose a better price is "+sCost;
        else if (nR==3) sSay="You are wrong this item is worth "+sCost;
        else if (nR==4) sSay="I think the item is worth more than I thought.  How about "+sCost;
        if (GetStringLength(sPCF)>0) sSay=sPCF+" "+sCost;
        SetLocalString(oPC,"sProfMerchSays",sSay);
        SetLocalInt(oPC,"nProfMerchPrice",nV);
        AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",FALSE,FALSE));
      } // Increase price by 10%
      else if (nPCF==2)
      { // change to worst price
        nV=nMaxPrice;
        sCost=MoneyToString(nV,nCurrency,TRUE);
        nR=d4();
        if (nR==1) sSay="Perhaps, I should be asking more.  The price is "+sCost;
        else if (nR==2) sSay="Well, I suppose a better price is "+sCost;
        else if (nR==3) sSay="You are wrong this item is worth "+sCost;
        else if (nR==4) sSay="I think the item is worth more than I thought.  How about "+sCost;
        if (GetStringLength(sPCF)>0) sSay=sPCF+" "+sCost;
        SetLocalString(oPC,"sProfMerchSays",sSay);
        SetLocalInt(oPC,"nProfMerchPrice",nV);
        AssignCommand(oPC,ActionStartConversation(oMerchant,"npcact_merchant",FALSE,FALSE));
      } // change to worst price
      else if (nPCF==3)
      { // 4 hour ban
        SetMerchantBan(oMerchant,oPC,4);
        nR=d4();
        if (nR==1) sSay="I think I am done speaking with you for awhile!";
        else if (nR==2) sSay="I've had enough of you!";
        else if (nR==3) sSay="Go bother someone else!";
        else if (nR==4) sSay="I am tired of talking to you!";
        if (GetStringLength(sPCF)>0) sSay=sPCF;
        AssignCommand(oMerchant,SpeakString(sSay));
        AssignCommand(oPC,fnPurgeInvalids());
      } // 4 hour ban
      else if (nPCF==4)
      { // 8 hour ban
        SetMerchantBan(oMerchant,oPC,8);
        nR=d4();
        if (nR==1) sSay="I think I am done speaking with you for awhile!";
        else if (nR==2) sSay="I've had enough of you!";
        else if (nR==3) sSay="Go bother someone else!";
        else if (nR==4) sSay="I am tired of talking to you!";
        if (GetStringLength(sPCF)>0) sSay=sPCF;
        AssignCommand(oMerchant,SpeakString(sSay));
        AssignCommand(oPC,fnPurgeInvalids());
      } // 8 hour ban
      else if (nPCF==5)
      { // 48 hour ban
        SetMerchantBan(oMerchant,oPC,48);
        nR=d4();
        if (nR==1) sSay="I think I am done speaking with you for awhile!";
        else if (nR==2) sSay="I've had enough of you!";
        else if (nR==3) sSay="Go bother someone else!";
        else if (nR==4) sSay="I am tired of talking to you!";
        if (GetStringLength(sPCF)>0) sSay=sPCF;
        AssignCommand(oMerchant,SpeakString(sSay));
        AssignCommand(oPC,fnPurgeInvalids());
      } // 48 hour ban
      else if (nPCF==6)
      { // permanent ban
        SetMerchantBan(oMerchant,oPC,-1);
        nR=d4();
        if (nR==1) sSay="I think I am done speaking with you for awhile!";
        else if (nR==2) sSay="I've had enough of you!";
        else if (nR==3) sSay="Go bother someone else!";
        else if (nR==4) sSay="I am tired of talking to you!";
        if (GetStringLength(sPCF)>0) sSay=sPCF;
        AssignCommand(oMerchant,SpeakString(sSay));
        AssignCommand(oPC,fnPurgeInvalids());
      } // permanent ban
      else if (nPCF==7)
      { // attack player
        SetIsTemporaryEnemy(oPC,oMerchant,TRUE,360.0);
        AssignCommand(oMerchant,ActionAttack(oPC));
        AssignCommand(oPC,fnPurgeInvalids());
      } // attack player
      else if (nPCF==8)
      { // custom script
        sS=GetLocalString(oMerchant,"sProfMerchBarterPCFScr");
        if (GetStringLength(sS)>0) ExecuteScript(sS,oMerchant);
      } // custom script
    } // critical failure
    nPCount++;
    SetLocalInt(oMerchant,"nPCount_"+sPID,nPCount);
}
