/////////////////////////////////////////////////////////////////////////////
// NPCACT_CNV_T# - NPC ACTIVITIES 6.0 Custom Conversation add-on
// By Deva Bryson Winblood.
/////////////////////////////////////////////////////////////////////////////
#include "npcact_h_cconv"
////////////////////////////
// CONSTANTS
////////////////////////////
const int CTEST_NUM = 1;

////////////////////////////
// PROTOTYPES
////////////////////////////

int StartingConditional()
{
    int bRet=FALSE;
    object oPC=GetPCSpeaker();
    object oMe=OBJECT_SELF;
    object oMod=GetModule();
    int nN;
    int nBase;
    int nDepth; // depth within conversation tree
    int nConsecutive; // consecutives
    string sS;
    string sTest;
    string sAct;
    string sSay;
    string sLang;
    string sTrans;
    int bSpoke=FALSE;
    //////////////////
    nDepth=GetLocalInt(oPC,"nGNBConvDepth");
    nConsecutive=GetLocalInt(oPC,"nGNBConvConsec");
    sS=GetLocalString(oMe,"sNPCConvResp"+IntToString(nDepth)+"_"+IntToString(nConsecutive)+"_"+IntToString(CTEST_NUM));
    if (GetStringLength(sS)>0)
    { // a response for this portion is available
      sLang=fnParse(sS,".");
      sS=fnRemoveParsed(sS,sLang,".");
      sTest=fnParse(sS,".");
      sS=fnRemoveParsed(sS,sTest,".");
      sAct=fnParse(sS,".");
      sSay=fnRemoveParsed(sS,sAct,".");
      if (sTest=="NA"||sTest=="na") bRet=TRUE;
      else
      { // check test conditions
        bRet=TRUE;
          while(bRet&&GetStringLength(sTest)>0)
          { // test conditions
            sS=fnParse(sTest,"/");
            sTest=fnRemoveParsed(sTest,sS,"/");
            if (GetStringLeft(sS,1)=="@")
            { // custom script
              sS=GetStringRight(sS,GetStringLength(sS)-1);
              ExecuteScript(sS,OBJECT_SELF);
              if (GetLocalInt(oPC,"bNPCConvReturn")==FALSE) bRet=FALSE;
              DeleteLocalInt(oPC,"bNPCConvReturn");
            } // custom script
            else
            { // test conditional
              bRet=fnConvTestConditional(OBJECT_SELF,sS);
            } // test conditional
          } // test conditions
      } // check test conditions
      if (bRet==TRUE)
      { // setup custom tokens
        sSay=fnConvHandleTokens(oMe,oPC,sSay);
        nN=GetLocalInt(oPC,"nGNBConvNum");
        nBase=99000+((nN-1)*20);
        nBase=nBase+CTEST_NUM;
        SetCustomToken(nBase,sSay);
      } // setup custom tokens
    } // a response for this portion is available
    return bRet;
}
////////////////////////////
// FUNCTIONS
////////////////////////////
