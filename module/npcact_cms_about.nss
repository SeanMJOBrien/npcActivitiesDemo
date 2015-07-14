// npcact_cms_about
int StartingConditional()
{
    object oMod=GetModule();
    int nN;
    object oItem=GetLocalObject(GetPCSpeaker(),"oCMSItem");
    int nCurrency=GetLocalInt(oItem,"nCurrency");
    int nV;
    string sFinal="";
    string sS;
    sS=GetLocalString(oMod,"sMSCurrencyName"+IntToString(nCurrency));
    sFinal=sS+"      ";
    nN=1;
    sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
    while(GetStringLength(sS)>0)
    { // monetary system
      sFinal=sFinal+sS+" (abbreviation: ";
      sS=GetLocalString(oMod,"sMSCoinAbbr"+IntToString(nCurrency)+"_"+IntToString(nN));
      sFinal=sFinal+sS+") Value:";
      nV=GetLocalInt(oMod,"nMSCoinValue"+IntToString(nCurrency)+"_"+IntToString(nN));
      sFinal=sFinal+IntToString(nV)+" MUs, ";
      nN++;
      sS=GetLocalString(oMod,"sMSCoinName"+IntToString(nCurrency)+"_"+IntToString(nN));
    } // monetary system
    sFinal=GetStringLeft(sFinal,GetStringLength(sFinal)-2);
    sFinal=sFinal+".";
    SetCustomToken(999994,sFinal);
    return TRUE;
}
