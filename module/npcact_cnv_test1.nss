//////////////////////////////////////////////////////////////////////////////
// NPCACT_CNV_TEST# - NPC ACTIVITIES 6.0 Conversation Add-On
// Main Conversation node test
// By Deva Bryson Winblood.  08/31/2004
/////////////////////////////////////////////////////////////////////////////
// Purpose to setup the custom tokens... to determine which custom token
// bank to use.
/////////////////////////////////////////////////////////////////////////////
#include "npcact_h_cconv"
#include "npcact_h_colors"
///////////////////////////////////////
// CONSTANTS
///////////////////////////////////////
const int CTEST_NUM = 1;

///////////////////////////////////////
// PROTOTYPES
///////////////////////////////////////

void fnNearbyListeners(object oMe,object oPC,string sSay,string sLang);

//////////////////////////////////////////////////////////////////////// MAIN
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
    string sSS;
    int bSpoke=FALSE;
    object oOb=GetLocalObject(oMod,"oGNBConvLocker"+IntToString(CTEST_NUM));
    if (GetStringLength(GetLocalString(oMe,"sNPCConvOverride"))<1)
    { // no conversation override
      fnConvDebug(oPC,"npcact_cnv_test"+IntToString(CTEST_NUM));
      if (!GetIsObjectValid(oOb)||IsInConversation(oOb)==FALSE)
      { // current locker is not present
        fnConvDebug(oPC,"   FREE UP LOCK:"+IntToString(CTEST_NUM));
        DeleteLocalObject(oMod,"oGNBConvLocker"+IntToString(CTEST_NUM));
        DeleteLocalInt(oMod,"oGNBConvLocked"+IntToString(CTEST_NUM));
      } // current locker is not present
      if ((GetLocalInt(oPC,"nGNBConvNum")==0&&GetLocalInt(oMod,"bGNBConvLocked"+IntToString(CTEST_NUM))!=TRUE)||GetLocalInt(oPC,"nGNBConvNum")==CTEST_NUM)
      { // okay to use this conversation thread
        // lock the variables to this PC
        fnConvDebug(oPC,"   SECURE LOCK:"+IntToString(CTEST_NUM));
        SetLocalInt(oMod,"bGNBConvLocked"+IntToString(CTEST_NUM),TRUE);
        SetLocalObject(oMod,"oGNBConvLocker"+IntToString(CTEST_NUM),oPC);
        SetLocalInt(oPC,"nGNBConvNum",CTEST_NUM);
        //SendMessageToPC(oPC,"Locked Conv1");
        // sentinel variables locked
        // determine location in conversation
        nDepth=GetLocalInt(oPC,"nGNBConvDepth");
        nConsecutive=GetLocalInt(oPC,"nGNBConvConsec");
        // Process variable for testing
        sS=GetLocalString(oMe,"sNPCConvNode"+IntToString(nDepth)+"_"+IntToString(nConsecutive));
        while(GetStringLength(sS)>0)
        { // there is speech
          sLang=fnParse(sS,".");
          sS=fnRemoveParsed(sS,sLang,".");
          sTest=fnParse(sS,".");
          sS=fnRemoveParsed(sS,sTest,".");
          sAct=fnParse(sS,".");
          sSay=fnRemoveParsed(sS,sAct,".");
          //SendMessageToPC(oPC," PARTS:"+sLang+", "+sTest+", "+sAct+", "+sSay);
          if (sTest=="NA"||sTest=="na") bRet=TRUE;
          else
          { // test
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
          } // test
          if (bRet==TRUE)
          { // this speech will be displayed so, handle the rest
            nBase=99000+((CTEST_NUM-1)*20);
            sSay=fnConvHandleTokens(oMe,oPC,sSay);
            if (sLang!="0"&&sLang!="NA"&&sLang!="na")
            { // a language was specified
              //SendMessageToPC(oPC,"Do translation");
              sTrans=fnTranslateToLanguage(StringToInt(sLang),sSay);
            } // a language was specified
            else { sTrans=sSay; }
            SetCustomToken(nBase,sTrans);
            if (GetLocalInt(oPC,"bNPCLanguage"+sLang)==TRUE)
            { // translate to PC
              sSS=GetName(oMe)+" said,'"+sSay+"'";
              sSS=ColorString(sSS,COLOR_WHITE);
              SendMessageToPC(oPC,sSS);
            } // translate to PC
            if (sTrans!=sSay) { fnNearbyListeners(oMe,oPC,sSay,sLang); }
            sS="";
            bSpoke=TRUE;
          } // this speech will be displayed so, handle the rest
          if (bRet==FALSE) { // check for alternate consecutive conversation threads
            nConsecutive++;
            sS=GetLocalString(oMe,"sNPCConvNode"+IntToString(nDepth)+"_"+IntToString(nConsecutive));
            SetLocalInt(oPC,"nGNBConvConsec",nConsecutive);
          } // check for alternate consecutive conversation threads
        } // there is speech
        if (bSpoke==FALSE) fnConvCompleted(oPC);
      } // okay to use this conversation thread
    } // no override coversaation
    else
    { // conversation override
      sS=GetLocalString(oMe,"sNPCConvOverride");
      AssignCommand(oMe,ClearAllActions());
      AssignCommand(oMe,ActionStartConversation(oPC,sS,FALSE,FALSE));
    } // conversation override
    return bRet;
}
/////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////
// FUNCTIONS
///////////////////////////////////////
void fnNearbyListeners(object oMe,object oPC,string sSay,string sLang)
{ // PURPOSE: To make sure people nearby that speak the language
  // can translate what was said
  int nN=1;
  string sS;
  object oOb=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oPC,nN,CREATURE_TYPE_IS_ALIVE,TRUE);
  while(GetIsObjectValid(oOb)&&GetDistanceBetween(oOb,oPC)<20.1)
  { // in range to translate
    if (GetLocalInt(oOb,"bNPCLanguage"+sLang)==TRUE)
    { // translate
      sS=GetName(oMe)+" said,'"+sSay+"' to "+GetName(oPC)+".";
      sS=ColorString(sS,COLOR_WHITE);
      SendMessageToPC(oPC,sS);
    } // translate
    nN++;
    oOb=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oPC,nN,CREATURE_TYPE_IS_ALIVE,TRUE);
  } // in range to translate
} // fnNearbyListeners()
