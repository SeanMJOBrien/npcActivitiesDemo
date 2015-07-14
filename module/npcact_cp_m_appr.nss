///////////////////////////////////////////////////////////////////////
// npcact_cp_m_appr - NPC ACTIVITIES 6.0 Professions Merchant
// Appraise item value
// By Deva Bryson Winblood. 07/23/2005
///////////////////////////////////////////////////////////////////////
#include "npcact_h_merch"
#include "npcact_h_colors"

int StartingConditional()
{
   object oMerchant=OBJECT_SELF;
   object oPC=GetPCSpeaker();
   int nCurrency=GetLocalInt(oMerchant,"nProfMerchCurrency");
   object oItem=GetLocalObject(oPC,"oMerchItem");
   int nV;
   int nDC;
   int nR;
   float fPrice;
   float fMarkup;
   int nGV=GetLocalInt(GetModule(),"nMSCoinGoldValue");
   string sS;
   string sComment;
   if (nGV<1) nGV=1;
   nV=GetPrice(GetResRef(oItem),oMerchant,100,GetItemStackSize(oItem));
   nDC=10;
   nR=nV/(nGV*500);
   if (nR>0) nDC=nDC+nR;
   if (GetIdentified(oItem)==FALSE) nDC=nDC+15;
   nR=GetSkillRank(SKILL_APPRAISE,oPC)+d20()+GetSkillRank(SKILL_LORE,oPC);
   sS=ColorRGBString("[appraise = appraise+lore+d20()] ",6,2,2);
   sS=sS+"Score: "+ColorRGBString(IntToString(nR),2,2,6);
   SendMessageToPC(oPC,sS);
   nR=nR-nDC;
   if (nR>4)
   { // exact price
     sS=MoneyToString(nV,nCurrency,TRUE);
     nR=d4();
     if (nR<3) sComment=" and you feel confident about the appraisal.";
     else if (nR==3) sComment=" and you are certain of it.";
     else if (nR==4) sComment=" and you'd stake your life on it.";
   } // exact price
   else if (nR>=0)
   { // price is close
     nR=d4();
     if (nR>2)
     { // too high
       nR=100+d6();
       fMarkup=IntToFloat(nR)/100.0;
       fPrice=IntToFloat(nV)*fMarkup;
       nV=FloatToInt(fPrice);
     } // too high
     else
     { // too low
       nR=100-d6();
       fMarkup=IntToFloat(nR)/100.0;
       fPrice=IntToFloat(nV)*fMarkup;
       nV=FloatToInt(fPrice);
     } // too low
     sS=MoneyToString(nV,nCurrency,TRUE);
     nR=d4();
     if (nR<3) sComment=" and you are fairly confident of it.";
     else if (nR==3) sComment=" and you think you are accurate.";
     else if (nR==4) sComment=" and the appraisal feels right.";
   } // price is close
   else if (nR<0)
   { // price is off
     nR=d4();
     if (nR>2)
     { // too high
       nR=110+d12();
       fMarkup=IntToFloat(nR)/100.0;
       fPrice=IntToFloat(nV)*fMarkup;
       nV=FloatToInt(fPrice);
     } // too high
     else
     { // too low
       nR=110-d12();
       fMarkup=IntToFloat(nR)/100.0;
       fPrice=IntToFloat(nV)*fMarkup;
       nV=FloatToInt(fPrice);
     } // too low
     sS=MoneyToString(nV,nCurrency,TRUE);
     nR=d4();
     if (nR<3) sComment=" but, you wouldn't stake your life on it.";
     else if (nR==3) sComment=" but, it is a tough decision.";
     else if (nR==4) sComment=" but, you'd recommend a second opinion.";
   } // price is off
   else
   { // price is way off
     nR=d4();
     if (nR>2)
     { // too high
       nR=150+d20();
       fMarkup=IntToFloat(nR)/100.0;
       fPrice=IntToFloat(nV)*fMarkup;
       nV=FloatToInt(fPrice);
     } // too high
     else
     { // too low
       nR=150-d20();
       fMarkup=IntToFloat(nR)/100.0;
       fPrice=IntToFloat(nV)*fMarkup;
       nV=FloatToInt(fPrice);
     } // too low
     sS=MoneyToString(nV,nCurrency,TRUE);
     nR=d4();
     if (nR<3) sComment=" but, in this case you are unsure.";
     else if (nR==3) sComment=" but, you think you're likely wrong.";
     else if (nR==4) sComment=" but, it was extremely difficult to decide.";
   } // price is way off
   sS=GetStringLeft(sS,GetStringLength(sS)-1);
   sS=ColorRGBString(sS,0,4,0);
   SetCustomToken(99063,sS+sComment);
   return TRUE;
}
