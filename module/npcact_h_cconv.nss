///////////////////////////////////////////////////////////////////////////////
// NPC ACTIVITIES 6.0 - Conversation Add-on  header file
// By Deva Bryson Winblood  08/31/2004
// Last Modified By: Deva Bryson Winblood  02/02/2005
//-----------------------------------------------------------------------------
// Purpose to provide functions used relating to conversation and speech add-on
// for NPC ACTIVITIES 6.0.
//-----------------------------------------------------------------------------
// Includes two functions to add DMFI Language support by request.
// DMFI is by Demetrius and Hahnsoo.  Thanks guys!!!
///////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
#include "npcact_h_anim"
#include "npcact_h_money"
#include "npcact_h_colors"
//////////////////////////////////////////-----------------------------------
// PROTOTYPES
//////////////////////////////////////////-----------------------------------

// FILE: npcact_h_cconv         FUNCTION: fnGetKnowsLanguage()
// This function will return TRUE if the PC in question speaks
// the language.  It simply returns the value of
// bNPCLanguage# where # is nLanguage.
int fnGetKnowsLanguage(object oPC,int nLanguage);

// FILE: npcact_h_cconv         FUNCTION: fnSetKnowsLanguage()
// This function will set the value of whether the PC knows
// the language in question.  It simply sets the value of
// bNPCLanguage# to either TRUE or FALSE
void fnSetKnowsLanguage(object oPC,int nLanguage,int bKnows=TRUE);

// FILE: npcact_h_cconv        FUNCTION: fnTranslateToLanguage()
// This function will take a language # and a string passed to it
// and it will translate the string into the specified language
// number and return the results.
string fnTranslateToLanguage(int nLanguage,string sTranslate);

// FILE: npcact_h_cconv        FUNCTION: fnConvTestConditional()
// This function will test for the specified conditional on the
// object that was passed to it and will return TRUE or FALSE
// depending on the results of the conditional.
int fnConvTestConditional(object oOb,string sCondition);

// FILE: npcact_h_cconv        FUNCTION: fnConvCompleted()
// This function will clean up variables used for the conversation and
// reset them to their normal defaults.
void fnConvCompleted(object oPC);

// FILE: npcact_h_cconv        FUNCTION: fnConvHandleTokens()
// This function will handle special tokens passed to the conversation
// that need to be processed.
string fnConvHandleTokens(object oMe,object oPC,string sSay);

// FILE: npcact_h_cconv        FUNCTION: fnConvActions()
// This function will process the ACTION portion of a conversation node
// as passed to it via a variable.
void fnConvActions(object oMe,object oPC,string sAct);

// FILE: npcact_h_cconv        FUNCTION: fnConvDebug()
// Debug messages for custom conversation
void fnConvDebug(object oPC,string sMsg);

// FILE: npcact_h_cconv        FUNCTION: fnConvClearConv()
// This function will destroy the conversation and reset any depth settings
void fnConvClearConv(object oMe,object oPC,int nDepth=0,int nConsecutive=0);

//////////////////////////////////////////-----------------------------------
// FUNCTIONS
//////////////////////////////////////////-----------------------------------

void fnConvDebug(object oPC,string sMsg)
{ // conversation debug
  if (DEBUG_NPCCONV_ON)
  { // okay
    SendMessageToPC(oPC,sMsg);
  } // okay
} // fnConvDebug()

void fnConvActions(object oMe,object oPC,string sAct)
{ // PURPOSE: To process the ACTION portion of conversation node
  string sType;
  string sParams;
  int nN;
  int nNN;
  string sActions=sAct;
  string sParse;
  object oOb;
  object oNew;
  int nB4Depth=GetLocalInt(oPC,"nGNBConvDepth");
  int nB4Consec=GetLocalInt(oPC,"nGNBConvConsec");
  int nCurrency=GetLocalInt(oMe,"nCurrency");
  fnConvDebug(oPC,"fnConvActions("+GetName(oMe)+","+GetName(oPC)+","+sAct+");");
  while(GetStringLength(sActions)>0)
  { // process action parameters
    sParse=fnParse(sActions,"/");
    sActions=fnRemoveParsed(sActions,sParse,"/");
    sType=GetStringLeft(sParse,1);
    sParams=GetStringRight(sParse,GetStringLength(sParse)-1);
    if (sType=="@")
    { // execute script
      fnConvDebug(oPC,"  ExecuteScript("+sParams+");");
      ExecuteScript(sParams,oMe);
    } // execute script
    else if (sType=="!")
    { // play animation
      nN=ANIMATION_FIREFORGET_BOW;
      sType=fnParse(sParams,"_");
      sParams=fnRemoveParsed(sParams,sType,"_");
      fnConvDebug(oPC,"  Play Animation #"+sType+" for "+sParams+" seconds.");
      nN=fnNPCACTAnimMagicNumber(sType);
      AssignCommand(oMe,ActionPlayAnimation(nN,1.0,IntToFloat(StringToInt(sParams))*0.2));
    } // play animation
    else if (sType=="*")
    { // play sound by string ref
      AssignCommand(oMe,PlaySoundByStrRef(StringToInt(sParams),FALSE));
    } // play sound by string reg
    else if (sType=="^")
    { // play sound
      AssignCommand(oMe,PlaySound(sParams));
    } // play sound
    else if (sType=="$")
    { // open store
      oOb=GetNearestObjectByTag(sParams,oMe,1);
      fnConvDebug(oPC,"  OpenStore("+GetTag(oOb)+");");
      if (GetObjectType(oOb)==OBJECT_TYPE_STORE)
      { // okay
        OpenStore(oOb,oPC);
      } // okay
    } // open store
    else if (sType=="~")
    { // specify node
      sParse=fnParse(sParams,"_");
      sParams=fnRemoveParsed(sParams,sParse,"_");
      fnConvDebug(oPC,"  Specify Node("+sParse+","+sParams+");");
      SetLocalInt(oPC,"nGNBConvDepth",StringToInt(sParse));
      SetLocalInt(oPC,"nGNBConvConsec",StringToInt(sParse));
    } // specify node
    else if (sType==":")
    { // set string variable
      sParse=GetStringLeft(sParams,1);
      sParams=GetStringRight(sParams,GetStringLength(sParams)-1);
      fnConvDebug(oPC,"  SetStringVariable");
      oOb=oMe;
      if (sParse=="P") { oOb=oPC; }
      else if (sParse=="M") { oOb=GetModule(); }
      else if (sParse=="A") { oOb=GetArea(oMe); }
      if (TestStringAgainstPattern("**|**",sParams))
      { // set to specific
        sParse=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sParse,"|");
        if (GetStringLeft(sParams,1)!="!")
        {
          SetLocalString(oOb,sParse,sParams);
          fnConvDebug(oPC,"    "+sParse+"="+sParams);
        }
        else { SetLocalString(oOb,sParse,GetLocalString(oPC,GetStringRight(sParams,GetStringLength(sParams)-1)));
          fnConvDebug(oPC,"  ! "+sParse+"="+GetLocalString(oPC,GetStringRight(sParams,GetStringLength(sParams)-1)));
          }
      } // set to specific
    } // set string variable
    else if (sType=="&")
    { // set a variable
      sParse=GetStringLeft(sParams,1);
      sParams=GetStringRight(sParams,GetStringLength(sParams)-1);
      fnConvDebug(oPC,"  SetVariable");
      oOb=oMe;
      if (sParse=="P") { oOb=oPC; }
      else if (sParse=="M") { oOb=GetModule(); }
      else if (sParse=="A") { oOb=GetArea(oMe); }
      if (TestStringAgainstPattern("**|**",sParams))
      { // set to specific
        sParse=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sParse,"|");
        if (GetStringLeft(sParams,1)!="!")
        {
          SetLocalInt(oOb,sParse,StringToInt(sParams));
          fnConvDebug(oPC,"    "+sParse+"="+sParams);
        }
        else { SetLocalInt(oOb,sParse,GetLocalInt(oPC,GetStringRight(sParams,GetStringLength(sParams)-1)));
          fnConvDebug(oPC,"  ! "+sParse+"="+IntToString(GetLocalInt(oPC,GetStringRight(sParams,GetStringLength(sParams)-1))));
          }
      } // set to specific
      else if (TestStringAgainstPattern("**+**",sParams))
      { // add to variable
        sParse=fnParse(sParams,"+");
        sParams=fnRemoveParsed(sParams,sParse,"+");
        nN=GetLocalInt(oOb,sParse);
        if (GetStringLeft(sParams,1)!="!")
        {
           fnConvDebug(oPC,"     "+sParse+"+"+sParams);
           nN=nN+StringToInt(sParams);
        }
        else { nN=nN+GetLocalInt(oPC,GetStringRight(sParams,GetStringLength(sParams)-1));
          fnConvDebug(oPC,"  ! "+sParse+"+"+IntToString(GetLocalInt(oPC,GetStringRight(sParams,GetStringLength(sParams)-1))));
        }
        SetLocalInt(oOb,sParse,nN);
      } // add to variable
    } // set a variable
    else if (sType=="+")
    { // give gold or XP or item or journal
      sParse=GetStringLeft(sParams,1);
      sParams=GetStringRight(sParams,GetStringLength(sParams)-1);
      fnConvDebug(oPC,"  Add Type:"+sParse);
      if (sParse=="G")
      { // gold
        if (GetStringLeft(sParams,1)!="!")
        {
          GiveCoins(oPC,StringToInt(sParams),"ANY",nCurrency);
          fnConvDebug(oPC,"   !  Give Gold:"+sParams);
        }
        else {
           sParams=GetStringRight(sParams,GetStringLength(sParams)-1);
           nN=GetLocalInt(oPC,sParams);
           fnConvDebug(oPC,"  !  Give Gold:"+sParams);
           GiveCoins(oPC,nN,"ANY",nCurrency);
        }
      } // gold
      else if (sParse=="X")
      { // experience
        if (GetStringLeft(sParams,1)!="!")
        {
          GiveXPToCreature(oPC,StringToInt(sParams));
        }
        else {
           sParams=GetStringRight(sParams,GetStringLength(sParams)-1);
           nN=GetLocalInt(oPC,sParams);
           GiveXPToCreature(oPC,nN);
        }
      } // experience
      else if (sParse=="I")
      { // item
        sParse=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sParse,"|");
        oOb=CreateItemOnObject(sParse,oPC,StringToInt(sParams));
      } // item
      else if (sParse=="J")
      { // journal
        sType=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sType,"|");
        sParse=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sType,"|");
        if (sParams=="T"||sParams=="t"||sParams=="TRUE")
        { // add party wide
          AddJournalQuestEntry(sType,StringToInt(sParse),oPC,TRUE);
        } // add party wide
        else
        { // add to PC only
          AddJournalQuestEntry(sType,StringToInt(sParse),oPC,FALSE);
        } // add to PC only
      } // journal
    } // give gold or XP or item or journal
    else if (sType=="-")
    { // take gold or XP or item
      sParse=GetStringLeft(sParams,1);
      sParams=GetStringRight(sParams,GetStringLength(sParams)-1);
      fnConvDebug(oPC,"  Subtract Type:"+sParse);
      if (sParse=="G")
      { // gold
        TakeCoins(oPC,StringToInt(sParams),"ANY",nCurrency,TRUE);
      } // gold
      else if (sParse=="X")
      { // experience
        nN=GetXP(oPC);
        nN=nN-StringToInt(sParams);
        if (nN<1) nN=0;
        SetXP(oPC,nN);
      } // experience
      else if (sParse=="I")
      { // item
        sType=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sType,"|");
        if (GetItemPossessedBy(oPC,sType)!=OBJECT_INVALID)
        { // has such an item
          nN=StringToInt(sParams);
          oOb=GetFirstItemInInventory(oPC);
          while(nN>0&&oOb!=OBJECT_INVALID)
          { // get item
            if (GetTag(oOb)==sType)
            { // correct item type
              if (GetItemStackSize(oOb)>nN)
              { // plenty of items in this stack
                SetItemStackSize(oOb,GetItemStackSize(oOb)-nN);
              } // plenty of items in this stack
              else
              { // some of the items are in this stack
                nN=nN-GetItemStackSize(oOb);
                DelayCommand(1.0,DestroyObject(oOb));
              } // some of the items are in this stack
            } // correct item type
            oOb=GetNextItemInInventory(oPC);
          } // get item
        } // has such an item
      } // item
    } // take gold or XP or item
    else if (sType=="#")
    { // special actions
      sParse=GetStringLeft(sParams,1);
      sParams=GetStringRight(sParams,GetStringLength(sParams)-1);
      fnConvDebug(oPC,"  Special Action:"+sParse);
      if (sParse=="J")
      { // jump
        oOb=GetWaypointByTag(sParams);
        if (GetIsObjectValid(oOb))
        { // jump okay
          AssignCommand(oPC,JumpToObject(oOb));
        } // jump okay
      } // jump
      else if (sParse=="H")
      { // heal PC
        AssignCommand(oMe,ActionCastSpellAtObject(SPELL_GREATER_RESTORATION,oPC,METAMAGIC_ANY,TRUE));
        AssignCommand(oMe,ActionCastSpellAtObject(SPELL_HEAL,oPC,METAMAGIC_ANY,TRUE));
      } // heal PC
      else if (sParse=="A")
      { // alignment shift
        sType=GetStringLeft(sParams,1);
        sParams=GetStringRight(sParams,GetStringLength(sParams)-1);
        if (sType=="L")
        { // law
          AdjustAlignment(oPC,ALIGNMENT_LAWFUL,StringToInt(sParams));
        } // law
        else if (sType=="C")
        { // chaos
          AdjustAlignment(oPC,ALIGNMENT_CHAOTIC,StringToInt(sParams));
        } // chaos
        else if (sType=="G")
        { // good
          AdjustAlignment(oPC,ALIGNMENT_GOOD,StringToInt(sParams));
        } // good
        else if (sType=="E")
        { // evil
          AdjustAlignment(oPC,ALIGNMENT_EVIL,StringToInt(sParams));
        } // evil
      } // alignment shift
      else if (sParse=="R")
      { // reputation shift
        AdjustReputation(oPC,oMe,StringToInt(sParams));
      } // reputation shift
      else if (sParse=="C")
      { // conversation
        sType=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sType,"|");
        sParse=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sParse,"|");
        oOb=GetNearestObjectByTag(sParse,oPC,1);
        if (sParse=="PC") oOb=oPC;
        oNew=GetNearestObjectByTag(sParams,oPC,1);
        if (sParams=="PC") oNew=oPC;
        if (GetIsObjectValid(oOb)&&GetIsObjectValid(oNew))
        { // valid targets
          AssignCommand(oOb,ActionStartConversation(oNew,sType,FALSE,FALSE));
        } // valid targets
      } // conversation
      else if (sParse=="U")
      { // custom conversation
        sType=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sType,"|");
        sParse=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sParse,"|");
        oOb=GetNearestObjectByTag(sParse,oPC,1);
        if (sParse=="PC") oOb=oPC;
        oNew=GetNearestObjectByTag(sParams,oPC,1);
        if (sParams=="PC") oNew=oPC;
        if (GetIsObjectValid(oOb)&&GetIsObjectValid(oNew))
        { // valid targets
          SetLocalInt(oPC,"nGNBConvDepth",StringToInt(sType));
          SetLocalInt(oPC,"nGNBConvConsec",0);
          AssignCommand(oOb,ActionStartConversation(oNew,"npcact_custom",FALSE,FALSE));
        } // valid targets
      } // custom conversation
      else if (sParse=="N")
      { // next node
        nN=nB4Depth+1;
        SetLocalInt(oPC,"nGNBConvDepth",nN);
        SetLocalInt(oPC,"nGNBConvConsec",0);
      } // next node
      else if (sParse=="B")
      { // backup a node
        nN=nB4Depth-1;
        if (nN<1) nN=0;
        SetLocalInt(oPC,"nGNBConvDepth",nN);
        SetLocalInt(oPC,"nGNBConvConsec",0);
      } // backup a node
      else if (sParse=="G")
      { // go to node
        sType=fnParse(sParams,"|");
        sParams=fnRemoveParsed(sParams,sType,"|");
        SetLocalInt(oPC,"nGNBConvDepth",StringToInt(sType));
        SetLocalInt(oPC,"nGNBConvConsec",StringToInt(sParams));
      } // go to node
      else if (sParse=="K")
      { // terminate conversation and combat PC
        ExecuteScript("nw_d1_attonend02",oMe);
      } // terminate conversation and combat PC
    } // special actions
  } // process action parameters
  /*if (GetLocalInt(oPC,"nGNBConvDepth")!=nB4Depth||GetLocalInt(oPC,"nGNBConvConsec")!=nB4Consec)
  { // continue conversation
    AssignCommand(oMe,ClearAllActions());
    AssignCommand(oMe,ActionStartConversation(oPC,"npcact_custom",FALSE,FALSE));
  } // continue conversation */
} // fnConvActions()


string fnConvHandleTokens(object oMe,object oPC,string sSay)
{ // PURPOSE: To process tokens in say string identified by
  // <token>
  string sRet;
  string sMaster=sSay;
  string sParse1;
  string sParse2;
  string sPortion;
  string sType;
  string sMyFirstName;
  string sMyLastName;
  string sFirstName;
  string sLastName;
  int nR,nG,nB;
  int nN;
  fnConvDebug(oPC,"fnConvHandleTokens("+sSay+");");
  while(GetStringLength(sMaster)>0)
  { // build return string
    sParse1=fnParse(sMaster,"<");
    if (GetStringLength(sParse1)!=GetStringLength(sMaster))
    { // token found
      sRet=sRet+sParse1;
      fnConvDebug(oPC,"   "+sRet);
      sMaster=fnRemoveParsed(sMaster,sParse1,"<");
      sParse2=fnParse(sMaster,">");
      sMaster=fnRemoveParsed(sMaster,sParse2,">");
      sMyFirstName=fnParse(GetName(oMe)," ");
      sMyLastName=fnRemoveParsed(GetName(oMe),sMyFirstName," ");
      sFirstName=fnParse(GetName(oPC)," ");
      sLastName=fnRemoveParsed(GetName(oPC),sFirstName," ");
      if (GetStringLength(sParse2)>0)
      { // token extracted
        sType=GetStringLeft(sParse2,1);
        if (sType=="p") sType="P";
        else if (sType=="m") sType="M";
        if (sType=="$")
        { // variable contents
          sParse1=GetStringRight(sParse2,GetStringLength(sParse2)-2);
          sType=GetSubString(sParse2,1,1);
          if (sType=="S") { sRet=sRet+GetLocalString(oMe,sParse1); }
          else if (sType=="I") { sRet=sRet+IntToString(GetLocalInt(oMe,sParse1)); }
          else if (sType=="F") { sRet=sRet+FloatToString(GetLocalFloat(oMe,sParse1)); }
        } // variable contents
        else if (sType=="+")
        { // highlight type
          if (GetStringLeft(sParse2,1)=="A") {
            sParse2=GetStringRight(sParse2,GetStringLength(sParse2)-1);
            sParse2=ColorRGBString(sParse2,0,4,0);
            sRet=sRet+sParse2; }// Green
          else if (GetStringLeft(sParse2,1)=="H") {
            sParse2=GetStringRight(sParse2,GetStringLength(sParse2)-1);
            sParse2=ColorRGBString(sParse2,0,0,4);
            sRet=sRet+sParse2; } // Blue
          else if (GetStringLeft(sParse2,1)=="S") {
            sParse2=GetStringRight(sParse2,GetStringLength(sParse2)-1);
            sParse2=ColorRGBString(sParse2,4,0,0);
            sRet=sRet+sParse2; } // Red
          else if (GetStringLeft(sParse2,1)=="R") {
            sParse2=GetStringRight(sParse2,GetStringLength(sParse2)-1);
            nR=StringToInt(GetStringLeft(sParse2,1));
            sParse2=GetStringRight(sParse2,GetStringLength(sParse2)-1);
            nG=StringToInt(GetStringLeft(sParse2,1));
            sParse2=GetStringRight(sParse2,GetStringLength(sParse2)-1);
            nB=StringToInt(GetStringLeft(sParse2,1));
            sParse2=GetStringRight(sParse2,GetStringLength(sParse2)-1);
            sParse2=ColorRGBString(sParse2,nR,nG,nB);
            sRet=sRet+sParse2;
          } // RGB
        } // highlight type
        else if (sType=="~")
        { // period
          sRet=sRet+".";
        } // period
        else if (sType=="#")
        { // custom gender replacement
          if (GetSubString(sParse2,1,1)=="P"||GetSubString(sParse2,1,1)=="p") { nN=GetGender(oPC); }
          else { nN=GetGender(oMe); }
          sType=GetStringRight(sParse2,GetStringLength(sParse2)-2);
          sParse1=fnParse(sType,"/");
          sParse2=fnRemoveParsed(sType,sParse1,"/");
          if (nN!=GENDER_FEMALE) sRet=sRet+sParse1;
          else { sRet=sRet+sParse2; }
        } // custom gender replacement
        else if (sType=="%")
        { // tell some gossip
        } // tell some gossip
        else if (sParse2=="FN") { sRet=sRet+sFirstName; }
        else if (sParse2=="LN") { sRet=sRet+sLastName; }
        else if (sParse2=="N") { sRet=sRet+GetName(oPC); }
        else if (sParse2=="MFN") { sRet=sRet+sMyFirstName; }
        else if (sParse2=="MLN") { sRet=sRet+sMyLastName; }
        else if (sParse2=="MN") { sRet=sRet+GetName(oMe); }
        else if (sParse2=="MG"||sParse2=="G")
        { // gender
          if (sParse2=="MG") nN=GetGender(oMe);
          else { nN=GetGender(oPC); }
          if (nN==GENDER_MALE) sRet=sRet+"male";
          else if (nN==GENDER_FEMALE) sRet=sRet+"female";
          else if (nN==GENDER_BOTH) sRet=sRet+"both genders";
          else if (nN==GENDER_NONE) sRet=sRet+"no gender";
          else if (nN==GENDER_OTHER) sRet=sRet+"other gender";
        } // gender
        else if (sParse2=="MR"||sParse2=="R")
        { // Race
          if (sParse2=="MR") nN=GetRacialType(oMe);
          else { nN=GetRacialType(oPC); }
          if (nN==RACIAL_TYPE_ABERRATION) sRet=sRet+"aberration";
          else if (nN==RACIAL_TYPE_ALL) sRet=sRet+"all";
          else if (nN==RACIAL_TYPE_ANIMAL) sRet=sRet+"animal";
          else if (nN==RACIAL_TYPE_BEAST) sRet=sRet+"beast";
          else if (nN==RACIAL_TYPE_CONSTRUCT) sRet=sRet+"construct";
          else if (nN==RACIAL_TYPE_DRAGON) sRet=sRet+"dragon";
          else if (nN==RACIAL_TYPE_DWARF) sRet=sRet+"dwarf";
          else if (nN==RACIAL_TYPE_ELEMENTAL) sRet=sRet+"elemental";
          else if (nN==RACIAL_TYPE_ELF) sRet=sRet+"elf";
          else if (nN==RACIAL_TYPE_FEY) sRet=sRet+"fey";
          else if (nN==RACIAL_TYPE_GIANT) sRet=sRet+"giant";
          else if (nN==RACIAL_TYPE_GNOME) sRet=sRet+"gnome";
          else if (nN==RACIAL_TYPE_HALFELF) sRet=sRet+"halfelf";
          else if (nN==RACIAL_TYPE_HALFLING) sRet=sRet+"halfling";
          else if (nN==RACIAL_TYPE_HALFORC) sRet=sRet+"halforc";
          else if (nN==RACIAL_TYPE_HUMAN) sRet=sRet+"human";
          else if (nN==RACIAL_TYPE_HUMANOID_GOBLINOID) sRet=sRet+"goblin";
          else if (nN==RACIAL_TYPE_HUMANOID_MONSTROUS) sRet=sRet+"monster";
          else if (nN==RACIAL_TYPE_HUMANOID_ORC) sRet=sRet+"orc";
          else if (nN==RACIAL_TYPE_HUMANOID_REPTILIAN) sRet=sRet+"reptilian";
          else if (nN==RACIAL_TYPE_INVALID) sRet=sRet+"invalid";
          else if (nN==RACIAL_TYPE_MAGICAL_BEAST) sRet=sRet+"magical beast";
          else if (nN==RACIAL_TYPE_OOZE) sRet=sRet+"ooze";
          else if (nN==RACIAL_TYPE_OUTSIDER) sRet=sRet+"outsider";
          else if (nN==RACIAL_TYPE_SHAPECHANGER) sRet=sRet+"shape changer";
          else if (nN==RACIAL_TYPE_UNDEAD) sRet=sRet+"undead";
          else if (nN==RACIAL_TYPE_VERMIN) sRet=sRet+"vermin";
        } // Race
        else if (sParse2=="MC"||sParse2=="C")
        { // class - uses the slot 1 class
          if (sParse2=="MC") nN=GetClassByPosition(1,oMe);
          else { nN=GetClassByPosition(1,oPC); }
          if (nN==CLASS_TYPE_ABERRATION) sRet=sRet+"aberration";
          else if (nN==CLASS_TYPE_ANIMAL) sRet=sRet+"animal";
          else if (nN==CLASS_TYPE_ARCANE_ARCHER) sRet=sRet+"arcane archer";
          else if (nN==CLASS_TYPE_ASSASSIN) sRet=sRet+"assassin";
          else if (nN==CLASS_TYPE_BARBARIAN) sRet=sRet+"barbarian";
          else if (nN==CLASS_TYPE_BARD) sRet=sRet+"bard";
          else if (nN==CLASS_TYPE_BEAST) sRet=sRet+"beast";
          else if (nN==CLASS_TYPE_BLACKGUARD) sRet=sRet+"black guard";
          else if (nN==CLASS_TYPE_CLERIC) sRet=sRet+"cleric";
          else if (nN==CLASS_TYPE_COMMONER) sRet=sRet+"commoner";
          else if (nN==CLASS_TYPE_CONSTRUCT) sRet=sRet+"construct";
          else if (nN==CLASS_TYPE_DIVINECHAMPION) sRet=sRet+"divine champion";
          else if (nN==CLASS_TYPE_DRAGON) sRet=sRet+"dragon";
          else if (nN==CLASS_TYPE_DRAGONDISCIPLE) sRet=sRet+"dragon disciple";
          else if (nN==CLASS_TYPE_DRUID) sRet=sRet+"druid";
          else if (nN==CLASS_TYPE_DWARVENDEFENDER) sRet=sRet+"dwarven defender";
          else if (nN==CLASS_TYPE_ELEMENTAL) sRet=sRet+"elemental";
          else if (nN==CLASS_TYPE_FEY) sRet=sRet+"fey";
          else if (nN==CLASS_TYPE_FIGHTER) sRet=sRet+"fighter";
          else if (nN==CLASS_TYPE_GIANT) sRet=sRet+"giant";
          else if (nN==CLASS_TYPE_HARPER) sRet=sRet+"harper";
          else if (nN==CLASS_TYPE_HUMANOID) sRet=sRet+"humanoid";
          else if (nN==CLASS_TYPE_INVALID) sRet=sRet+"invalid";
          else if (nN==CLASS_TYPE_MAGICAL_BEAST) sRet=sRet+"magical beast";
          else if (nN==CLASS_TYPE_MONK) sRet=sRet+"monk";
          else if (nN==CLASS_TYPE_MONSTROUS) sRet=sRet+"monster";
          else if (nN==CLASS_TYPE_OOZE) sRet=sRet+"ooze";
          else if (nN==CLASS_TYPE_OUTSIDER) sRet=sRet+"outsider";
          else if (nN==CLASS_TYPE_PALADIN) sRet=sRet+"paladin";
          else if (nN==CLASS_TYPE_PALEMASTER) sRet=sRet+"pale master";
          else if (nN==CLASS_TYPE_RANGER) sRet=sRet+"ranger";
          else if (nN==CLASS_TYPE_ROGUE) sRet=sRet+"rogue";
          else if (nN==CLASS_TYPE_SHADOWDANCER) sRet=sRet+"shadow dancer";
          else if (nN==CLASS_TYPE_SHAPECHANGER) sRet=sRet+"shape changer";
          else if (nN==CLASS_TYPE_SHIFTER) sRet=sRet+"shifter";
          else if (nN==CLASS_TYPE_SORCERER) sRet=sRet+"sorcerer";
          else if (nN==CLASS_TYPE_UNDEAD) sRet=sRet+"undead";
          else if (nN==CLASS_TYPE_VERMIN) sRet=sRet+"vermin";
          else if (nN==CLASS_TYPE_WEAPON_MASTER) sRet=sRet+"weapon master";
          else if (nN==CLASS_TYPE_WIZARD) sRet=sRet+"wizard";
        } // class - uses the slot 1 class
        else if (sParse2=="AN") { sRet=sRet+GetName(GetArea(oMe)); }
        else if (sType=="P"||sType=="M")
        { // gender hard coded
          sParse2=GetStringRight(sParse2,GetStringLength(sParse2)-1);
          if (sType=="P") { nN=GetGender(oPC); }
          else { nN=GetGender(oMe); }
          if (sParse2=="LL")
          { // lord/lady
            if (nN==GENDER_FEMALE) { sRet=sRet+"Lady"; }
            else { sRet=sRet+"Lord"; }
          } // lord/lady
          else if (sParse2=="SM")
          { // sir/madam
            if (nN==GENDER_FEMALE) { sRet=sRet+"Madam"; }
            else { sRet=sRet+"Sir"; }
          } // sir/madam
          else if (sParse2=="MM")
          { // Mr/Mrs
            if (nN==GENDER_FEMALE) { sRet=sRet+"Mrs"; }
            else { sRet=sRet+"Mr"; }
          } // Mr/Mrs
          else if (sParse2=="GB")
          { // girl/boy
            if (nN==GENDER_FEMALE) { sRet=sRet+"girl"; }
            else { sRet=sRet+"boy"; }
          } // girl/boy
          else if (sParse2=="WM")
          { // woman/man
            if (nN==GENDER_FEMALE) { sRet=sRet+"woman"; }
            else { sRet=sRet+"man"; }
          } // woman/man
          else if (sParse2=="I1")
          { // bastard/bitch
            if (nN==GENDER_FEMALE) { sRet=sRet+"bitch"; }
            else { sRet=sRet+"bastard"; }
          } // bastard/bitch
          else if (sParse2=="I2")
          { // dog/whore
            if (nN==GENDER_FEMALE) { sRet=sRet+"whore"; }
            else { sRet=sRet+"dog"; }
          } // dog/whore
          else if (sParse2=="I3")
          { // dolt/wench
            if (nN==GENDER_FEMALE) { sRet=sRet+"wench"; }
            else { sRet=sRet+"dolt"; }
          } // dolt/wench
          else if (sParse2=="I4")
          { // fool/strumpet
            if (nN==GENDER_FEMALE) { sRet=sRet+"strumpet"; }
            else { sRet=sRet+"fool"; }
          } // fool/strumpet
          else if (sParse2=="I5")
          { // ogre/hag
            if (nN==GENDER_FEMALE) { sRet=sRet+"hag"; }
            else { sRet=sRet+"ogre"; }
          } // ogre/hag
        } // gender hard coded
      } // token extracted
      fnConvDebug(oPC,"   "+sRet);
    } // token found
    else { sRet=sRet+sParse1; sMaster=""; } // end of say
  } // build return string
  return sRet;
} // fnConvHandleTokens()


int fnGetKnowsLanguage(object oPC,int nLanguage)//---------------------------
{ // PURPOSE: Return whether PC knows nLanguage
  int bRet=GetLocalInt(oPC,"bNPCLanguage"+IntToString(nLanguage));
  return bRet;
} // fnGetKnowsLanguage()

void fnSetKnowsLanguage(object oPC,int nLanguage,int bKnows=TRUE)//----------
{ // PURPOSE: Set the variable that indicates PC knows the language
  SetLocalInt(oPC,"bNPCLanguage"+IntToString(nLanguage),bKnows);
} // fnSetKnowsLanguage()

string fnDMFILangReturn(int nLang,int iTrans,string sLetter)
{ // PURPOSE: return DMFI value
  string sRet=sLetter;
  switch(nLang)
      { // match language
        case 1: { // drow
          switch (iTrans)
            {
              case 0: return "il";
              case 26: return "Il";
              case 1: return "f";
              case 2: return "st";
              case 28: return "St";
              case 3: return "w";
              case 4: return "a";
              case 5: return "o";
              case 6: return "v";
              case 7: return "ir";
              case 33: return "Ir";
              case 8: return "e";
              case 9: return "vi";
              case 35: return "Vi";
              case 10: return "go";
              case 11: return "c";
              case 12: return "li";
              case 13: return "l";
              case 14: return "e";
              case 15: return "ty";
              case 41: return "Ty";
              case 16: return "r";
              case 17: return "m";
              case 18: return "la";
              case 44: return "La";
              case 19: return "an";
              case 45: return "An";
              case 20: return "y";
              case 21: return "el";
              case 47: return "El";
              case 22: return "ky";
              case 48: return "Ky";
              case 23: return "'";
              case 24: return "a";
              case 25: return "p'";
              case 27: return "F";
              case 29: return "W";
              case 30: return "A";
              case 31: return "O";
              case 32: return "V";
              case 34: return "E";
              case 36: return "Go";
              case 37: return "C";
              case 38: return "Li";
              case 39: return "L";
              case 40: return "E";
              case 42: return "R";
              case 43: return "M";
              case 46: return "Y";
              case 49: return "'";
              case 50: return "A";
              case 51: return "P'";
            default: return sLetter;
            }
          break;
        } // drow
        case 2: { // leetspeak
          switch (iTrans)
             {
                case 0: return "4";
                case 26: return "4";
                case 1: return "8";
                case 27: return "8";
                case 2: return "(";
                case 28: return "(";
                case 3: return "|)";
                case 29: return "|)";
                case 4: return "3";
                case 30: return "3";
                case 5: return "f";
                case 31: return "F";
                case 6: return "9";
                case 32: return "9";
                case 7: return "h";
                case 33: return "H";
                case 8: return "!";
                case 34: return "!";
                case 9: return "j";
                case 35: return "J";
                case 10: return "|<";
                case 36: return "|<";
                case 11: return "1";
                case 37: return "1";
                case 12: return "/\\/\\";
                case 38: return "/\\/\\";
                case 13: return "|\|";
                case 39: return "|\|";
                case 14: return "0";
                case 40: return "0";
                case 15: return "p";
                case 41: return "P";
                case 16: return "Q";
                case 42: return "Q";
                case 17: return "R";
                case 43: return "R";
                case 18: return "5";
                case 44: return "5";
                case 19: return "7";
                case 45: return "7";
                case 20: return "u";
                case 46: return "U";
                case 21: return "\/";
                case 47: return "\/";
                case 22: return "\/\/";
                case 48: return "\/\/";
                case 23: return "x";
                case 49: return "X";
                case 24: return "y";
                case 50: return "Y";
                case 25: return "2";
                case 51: return "2";
                default: return sLetter;
          }
          break;
        } // leetspeak
        case 3: { // infernal
          switch (iTrans)
            {
                case 0: return "o";
                case 1: return "c";
                case 2: return "r";
                case 3: return "j";
                case 4: return "a";
                case 5: return "v";
                case 6: return "k";
                case 7: return "r";
                case 8: return "y";
                case 9: return "z";
                case 10: return "g";
                case 11: return "m";
                case 12: return "z";
                case 13: return "r";
                case 14: return "y";
                case 15: return "k";
                case 16: return "r";
                case 17: return "n";
                case 18: return "k";
                case 19: return "d";
                case 20: return "'";
                case 21: return "r";
                case 22: return "'";
                case 23: return "k";
                case 24: return "i";
                case 25: return "g";
                case 26: return "O";
                case 27: return "C";
                case 28: return "R";
                case 29: return "J";
                case 30: return "A";
                case 31: return "V";
                case 32: return "K";
                case 33: return "R";
                case 34: return "Y";
                case 35: return "Z";
                case 36: return "G";
                case 37: return "M";
                case 38: return "Z";
                case 39: return "R";
                case 40: return "Y";
                case 41: return "K";
                case 42: return "R";
                case 43: return "N";
                case 44: return "K";
                case 45: return "D";
                case 46: return "'";
                case 47: return "R";
                case 48: return "'";
                case 49: return "K";
                case 50: return "I";
                case 51: return "G";
                default: return sLetter;
            }
          break;
        } // infernal
        case 4: { // abyssal
          switch (iTrans)
            {
                case 27: return "N";
                case 28: return "M";
                case 29: return "G";
                case 30: return "A";
                case 31: return "K";
                case 32: return "S";
                case 33: return "D";
                case 35: return "H";
                case 36: return "B";
                case 37: return "L";
                case 38: return "P";
                case 39: return "T";
                case 40: return "E";
                case 41: return "B";
                case 43: return "N";
                case 44: return "M";
                case 45: return "G";
                case 48: return "B";
                case 51: return "T";
                case 0: return "oo";
                case 26: return "OO";
                case 1: return "n";
                case 2: return "m";
                case 3: return "g";
                case 4: return "a";
                case 5: return "k";
                case 6: return "s";
                case 7: return "d";
                case 8: return "oo";
                case 34: return "OO";
                case 9: return "h";
                case 10: return "b";
                case 11: return "l";
                case 12: return "p";
                case 13: return "t";
                case 14: return "e";
                case 15: return "b";
                case 16: return "ch";
                case 42: return "Ch";
                case 17: return "n";
                case 18: return "m";
                case 19: return "g";
                case 20: return  "ae";
                case 46: return  "Ae";
                case 21: return  "ts";
                case 47: return  "Ts";
                case 22: return "b";
                case 23: return  "bb";
                case 49: return  "Bb";
                case 24: return  "ee";
                case 50: return  "Ee";
                case 25: return "t";
                default: return sLetter;
            }
          break;
        } // abyssal
        case 5: { // celestial
          switch (iTrans)
             {
                case 0: return "a";
                case 1: return "p";
                case 2: return "v";
                case 3: return "t";
                case 4: return "el";
                case 5: return "b";
                case 6: return "w";
                case 7: return "r";
                case 8: return "i";
                case 9: return "m";
                case 10: return "x";
                case 11: return "h";
                case 12: return "s";
                case 13: return "c";
                case 14: return "u";
                case 15: return "q";
                case 16: return "d";
                case 17: return "n";
                case 18: return "l";
                case 19: return "y";
                case 20: return "o";
                case 21: return "j";
                case 22: return "f";
                case 23: return "g";
                case 24: return "z";
                case 25: return "k";
                case 26: return "A";
                case 27: return "P";
                case 28: return "V";
                case 29: return "T";
                case 30: return "El";
                case 31: return "B";
                case 32: return "W";
                case 33: return "R";
                case 34: return "I";
                case 35: return "M";
                case 36: return "X";
                case 37: return "H";
                case 38: return "S";
                case 39: return "C";
                case 40: return "U";
                case 41: return "Q";
                case 42: return "D";
                case 43: return "N";
                case 44: return "L";
                case 45: return "Y";
                case 46: return "O";
                case 47: return "J";
                case 48: return "F";
                case 49: return "G";
                case 50: return "Z";
                case 51: return "K";
                default: return sLetter;
            }
          break;
        } // celestial
        case 6: { // goblin
          switch (iTrans)
            {
                case 0: return "u";
                case 1: return "p";
                case 2: return "";
                case 3: return "t";
                case 4: return "'";
                case 5: return "v";
                case 6: return "k";
                case 7: return "r";
                case 8: return "o";
                case 9: return "z";
                case 10: return "g";
                case 11: return "m";
                case 12: return "s";
                case 13: return "";
                case 14: return "u";
                case 15: return "b";
                case 16: return "";
                case 17: return "n";
                case 18: return "k";
                case 19: return "d";
                case 20: return "u";
                case 21: return "";
                case 22: return "'";
                case 23: return "";
                case 24: return "o";
                case 25: return "w";
                case 26: return "U";
                case 27: return "P";
                case 28: return "";
                case 29: return "T";
                case 30: return "'";
                case 31: return "V";
                case 32: return "K";
                case 33: return "R";
                case 34: return "O";
                case 35: return "Z";
                case 36: return "G";
                case 37: return "M";
                case 38: return "S";
                case 39: return "";
                case 40: return "U";
                case 41: return "B";
                case 42: return "";
                case 43: return "N";
                case 44: return "K";
                case 45: return "D";
                case 46: return "U";
                case 47: return "";
                case 48: return "'";
                case 49: return "";
                case 50: return "O";
                case 51: return "W";
                default: return sLetter;
            }
          break;
        } // goblin
        case 7: { // draconic
          switch (iTrans)
          {
            case 0: return "e";
            case 26: return "E";
            case 1: return "po";
            case 27: return "Po";
            case 2: return "st";
            case 28: return "St";
            case 3: return "ty";
            case 29: return "Ty";
            case 4: return "i";
            case 5: return "w";
            case 6: return "k";
            case 7: return "ni";
            case 33: return "Ni";
            case 8: return "un";
            case 34: return "Un";
            case 9: return "vi";
            case 35: return "Vi";
            case 10: return "go";
            case 36: return "Go";
            case 11: return "ch";
            case 37: return "Ch";
            case 12: return "li";
            case 38: return "Li";
            case 13: return "ra";
            case 39: return "Ra";
            case 14: return "y";
            case 15: return "ba";
            case 41: return "Ba";
            case 16: return "x";
            case 17: return "hu";
            case 43: return "Hu";
            case 18: return "my";
            case 44: return "My";
            case 19: return "dr";
            case 45: return "Dr";
            case 20: return "on";
            case 46: return "On";
            case 21: return "fi";
            case 47: return "Fi";
            case 22: return "zi";
            case 48: return "Zi";
            case 23: return "qu";
            case 49: return "Qu";
            case 24: return "an";
            case 50: return "An";
            case 25: return "ji";
            case 51: return "Ji";
            case 30: return "I";
            case 31: return "W";
            case 32: return "K";
            case 40: return "Y";
            case 42: return "X";
            default: return sLetter;
           }
          break;
        } // draconic
        case 8: { // dwarf
          switch (iTrans)
            {
                case 0: return "az";
                case 26: return "Az";
                case 1: return "po";
                case 27: return "Po";
                case 2: return "zi";
                case 28: return "Zi";
                case 3: return "t";
                case 4: return "a";
                case 5: return "wa";
                case 31: return "Wa";
                case 6: return "k";
                case 7: return "'";
                case 8: return "a";
                case 9: return "dr";
                case 35: return "Dr";
                case 10: return "g";
                case 11: return "n";
                case 12: return "l";
                case 13: return "r";
                case 14: return "ur";
                case 40: return "Ur";
                case 15: return "rh";
                case 41: return "Rh";
                case 16: return "k";
                case 17: return "h";
                case 18: return "th";
                case 44: return "Th";
                case 19: return "k";
                case 20: return "'";
                case 21: return "g";
                case 22: return "zh";
                case 48: return "Zh";
                case 23: return "q";
                case 24: return "o";
                case 25: return "j";
                case 29: return "T";
                case 30: return "A";
                case 32: return "K";
                case 33: return "'";
                case 34: return "A";
                case 36: return "G";
                case 37: return "N";
                case 38: return "L";
                case 39: return "R";
                case 42: return "K";
                case 43: return "H";
                case 45: return "K";
                case 46: return "'";
                case 47: return "G";
                case 49: return "Q";
                case 50: return "O";
                case 51: return "J";
                default: return sLetter;
              }
           break;
        } // dwarf
        case 9: { // elven
          switch (iTrans)
            {
                case 0: return "il";
                case 26: return "Il";
                case 1: return "f";
                case 2: return "ny";
                case 28: return "Ny";
                case 3: return "w";
                case 4: return "a";
                case 5: return "o";
                case 6: return "v";
                case 7: return "ir";
                case 33: return "Ir";
                case 8: return "e";
                case 9: return "qu";
                case 35: return "Qu";
                case 10: return "n";
                case 11: return "c";
                case 12: return "s";
                case 13: return "l";
                case 14: return "e";
                case 15: return "ty";
                case 41: return "Ty";
                case 16: return "h";
                case 17: return "m";
                case 18: return "la";
                case 44: return "La";
                case 19: return "an";
                case 45: return "An";
                case 20: return "y";
                case 21: return "el";
                case 47: return "El";
                case 22: return "am";
                case 48: return "Am";
                case 23: return "'";
                case 24: return "a";
                case 25: return "j";
                case 27: return "F";
                case 29: return "W";
                case 30: return "A";
                case 31: return "O";
                case 32: return "V";
                case 34: return "E";
                case 36: return "N";
                case 37: return "C";
                case 38: return "S";
                case 39: return "L";
                case 40: return "E";
                case 42: return "H";
                case 43: return "M";
                case 46: return "Y";
                case 49: return "'";
                case 50: return "A";
                case 51: return "J";
                default: return sLetter;
            }
          break;
        } // elven
        case 10: { // gnome
          switch (iTrans)
            {
            //cipher based on English -> Al Baed
                case 0: return "y";
                case 1: return "p";
                case 2: return "l";
                case 3: return "t";
                case 4: return "a";
                case 5: return "v";
                case 6: return "k";
                case 7: return "r";
                case 8: return "e";
                case 9: return "z";
                case 10: return "g";
                case 11: return "m";
                case 12: return "s";
                case 13: return "h";
                case 14: return "u";
                case 15: return "b";
                case 16: return "x";
                case 17: return "n";
                case 18: return "c";
                case 19: return "d";
                case 20: return "i";
                case 21: return "j";
                case 22: return "f";
                case 23: return "q";
                case 24: return "o";
                case 25: return "w";
                case 26: return "Y";
                case 27: return "P";
                case 28: return "L";
                case 29: return "T";
                case 30: return "A";
                case 31: return "V";
                case 32: return "K";
                case 33: return "R";
                case 34: return "E";
                case 35: return "Z";
                case 36: return "G";
                case 37: return "M";
                case 38: return "S";
                case 39: return "H";
                case 40: return "U";
                case 41: return "B";
                case 42: return "X";
                case 43: return "N";
                case 44: return "C";
                case 45: return "D";
                case 46: return "I";
                case 47: return "J";
                case 48: return "F";
                case 49: return "Q";
                case 50: return "O";
                case 51: return "W";
                default: return sLetter;
           }
          break;
        } // gnome
        case 11: { // halfling
          switch (iTrans)
            {
            //cipher based on Al Baed -> English
                case 0: return "e";
                case 1: return "p";
                case 2: return "s";
                case 3: return "t";
                case 4: return "i";
                case 5: return "w";
                case 6: return "k";
                case 7: return "n";
                case 8: return "u";
                case 9: return "v";
                case 10: return "g";
                case 11: return "c";
                case 12: return "l";
                case 13: return "r";
                case 14: return "y";
                case 15: return "b";
                case 16: return "x";
                case 17: return "h";
                case 18: return "m";
                case 19: return "d";
                case 20: return "o";
                case 21: return "f";
                case 22: return "z";
                case 23: return "q";
                case 24: return "a";
                case 25: return "j";
                case 26: return "E";
                case 27: return "P";
                case 28: return "S";
                case 29: return "T";
                case 30: return "I";
                case 31: return "W";
                case 32: return "K";
                case 33: return "N";
                case 34: return "U";
                case 35: return "V";
                case 36: return "G";
                case 37: return "C";
                case 38: return "L";
                case 39: return "R";
                case 40: return "Y";
                case 41: return "B";
                case 42: return "X";
                case 43: return "H";
                case 44: return "M";
                case 45: return "D";
                case 46: return "O";
                case 47: return "F";
                case 48: return "Z";
                case 49: return "Q";
                case 50: return "A";
                case 51: return "J";
                default: return sLetter;
            }
          break;
        } // halfling
        case 12: { // orc
          switch (iTrans)
            {
                case 0: return "ha";
                case 26: return "Ha";
                case 1: return "p";
                case 2: return "z";
                case 3: return "t";
                case 4: return "o";
                case 5: return "";
                case 6: return "k";
                case 7: return "r";
                case 8: return "a";
                case 9: return "m";
                case 10: return "g";
                case 11: return "h";
                case 12: return "r";
                case 13: return "k";
                case 14: return "u";
                case 15: return "b";
                case 16: return "k";
                case 17: return "h";
                case 18: return "g";
                case 19: return "n";
                case 20: return "";
                case 21: return "g";
                case 22: return "r";
                case 23: return "r";
                case 24: return "'";
                case 25: return "m";
                case 27: return "P";
                case 28: return "Z";
                case 29: return "T";
                case 30: return "O";
                case 31: return "";
                case 32: return "K";
                case 33: return "R";
                case 34: return "A";
                case 35: return "M";
                case 36: return "G";
                case 37: return "H";
                case 38: return "R";
                case 39: return "K";
                case 40: return "U";
                case 41: return "B";
                case 42: return "K";
                case 43: return "H";
                case 44: return "G";
                case 45: return "N";
                case 46: return "";
                case 47: return "G";
                case 48: return "R";
                case 49: return "R";
                case 50: return "'";
                case 51: return "M";
                default: return sLetter;
              }
          break;
        } // orc
        case 13: { // animal
          switch (iTrans)
            {
                case 0: return "'";
                case 1: return "'";
                case 2: return "'";
                case 3: return "'";
                case 4: return "'";
                case 5: return "'";
                case 6: return "'";
                case 7: return "'";
                case 8: return "'";
                case 9: return "'";
                case 10: return "'";
                case 11: return "'";
                case 12: return "'";
                case 13: return "'";
                case 14: return "'";
                case 15: return "'";
                case 16: return "'";
                case 17: return "'";
                case 18: return "'";
                case 19: return "'";
                case 20: return "'";
                case 21: return "'";
                case 22: return "'";
                case 23: return "'";
                case 24: return "'";
                case 25: return "'";
                case 26: return "'";
                case 27: return "'";
                case 28: return "'";
                case 29: return "'";
                case 30: return "'";
                case 31: return "'";
                case 32: return "'";
                case 33: return "'";
                case 34: return "'";
                case 35: return "'";
                case 36: return "'";
                case 37: return "'";
                case 38: return "'";
                case 39: return "'";
                case 40: return "'";
                case 41: return "'";
                case 42: return "'";
                case 43: return "'";
                case 44: return "'";
                case 45: return "'";
                case 46: return "'";
                case 47: return "'";
                case 48: return "'";
                case 49: return "'";
                case 50: return "'";
                case 51: return "'";
                default: return sLetter;
              }
          break;
        } // animal
        default: { sRet=sRet+sLetter; break; }
      } // match language
      return sLetter;
} // fnDMFILangReturn()

string fnDMFIStyleLanguage(string sTrans,string sLang)
{ // PURPOSE: To simulate the language technique used in the DMFI
  // scripts.   This was requested by people
  string sAlphaNumeric="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  string sRet="";
  string sMain=sTrans;
  string sLetter;
  int nN;
  int nLangNumber=0;
  if (sLang=="Drow"||sLang=="drow") nLangNumber=1;
  else if (sLang=="Leetspeak"||sLang=="leetspeak") nLangNumber=2;
  else if (sLang=="Infernal"||sLang=="infernal") nLangNumber=3;
  else if (sLang=="Abyssal"||sLang=="abyssal") nLangNumber=4;
  else if (sLang=="Celestial"||sLang=="celestial") nLangNumber=5;
  else if (sLang=="Goblin"||sLang=="goblin") nLangNumber=6;
  else if (sLang=="Draconic"||sLang=="draconic") nLangNumber=7;
  else if (sLang=="Dwarf"||sLang=="dwarf") nLangNumber=8;
  else if (sLang=="Elven"||sLang=="elven") nLangNumber=9;
  else if (sLang=="Gnome"||sLang=="gnome") nLangNumber=10;
  else if (sLang=="Halfling"||sLang=="halfling") nLangNumber=11;
  else if (sLang=="Orc"||sLang=="orc") nLangNumber=12;
  else if (sLang=="Animal"||sLang=="animal") nLangNumber=13;
  if (nLangNumber>0)
  { // language match
    while(GetStringLength(sMain)>0)
    { // build return string
      sLetter=GetStringLeft(sMain,1);
      nN=FindSubString(sAlphaNumeric,sLetter);
      sLetter=fnDMFILangReturn(nLangNumber,nN,sLetter);
      sMain=GetStringRight(sMain,GetStringLength(sMain)-1);
    } // build return string
  } // language match
  else { sRet=sTrans; }
  return sRet;
} // fnDMFIStyleLanguage()


string fnLangRepLetter(string sTranslate,string sParm)
{ // PURPOSE: replace letters specified in parm within sTranslate
  // and return the value
  string sRet;
  string sL1=GetStringLeft(sParm,1);
  string sL2=GetStringRight(sParm,1);
  int nPos=0;
  string sL;
  while(nPos<GetStringLength(sTranslate))
  { // build return string
    sL=GetSubString(sTranslate,nPos,1);
    if (sL==sL1) { sRet=sRet+sL2; }
    else { sRet=sRet+sL; }
    nPos++;
  } // build return string
  return sRet;
} // fnLangRepLetter()


string fnLangRepPhrase(string sTranslate,string sParm)
{ // PURPOSE: to replace phrase1 with phrase2 in sTranslate
  string sRet;
  string sP1=fnParse(sParm,"/");
  string sP2=fnRemoveParsed(sTranslate,sP1,"/");
  int nPos=0;
  string sC;
  while(nPos<(GetStringLength(sTranslate)-(GetStringLength(sP1)-1)))
  { // build return string
    sC=GetSubString(sTranslate,nPos,GetStringLength(sP1));
    if (sC==sP1)
    { // same phrase
      nPos=nPos+GetStringLength(sP1);
      sRet=sRet+sP2;
    } // same phrase
    else
    { // not phrase
      sRet=sRet+GetSubString(sTranslate,nPos,1);
      nPos++;
    } // not phrase
  } // build return string
  return sRet;
} // fnLangRepPhrase()

string fnLangRepSwapLoc(string sTranslate,string sParm)
{ // PURPOSE: swap word locations
  string sRet;
  string sP1=fnParse(sParm,"/");
  string sP2=fnRemoveParsed(sParm,sP1,"/");
  string sWord;
  string sBeforeW1;
  string sAfterW1B4W2;
  string sAfterW2;
  string sW1;
  string sW2;
  int nPos=0;
  int nWC=1;
  string sL;
  int nV1=StringToInt(sP1);
  int nV2=StringToInt(sP2);
  while(nPos<GetStringLength(sTranslate))
  { // build return string
    sL=GetSubString(sTranslate,nPos,1);
    if (sL==" "||sL=="."||sL=="!"||sL=="?"||sL==","||sL==":"||sL==";"||sL=="("||sL==")")
    { // end of word
      if (nWC<nV1)
      { // before word 1
        sBeforeW1=sBeforeW1+sL;
      } // before word 1
      else if (nWC<nV2&&nWC>nV1)
      { // between words
        sAfterW1B4W2=sAfterW1B4W2+sL;
      } // between words
      else if (nWC>nV2)
      { // after word 2
        sAfterW2=sAfterW2+sL;
      } // after word 2
      else if (nWC==nV1)
      { // end of word 1
        sAfterW1B4W2=sL;
      } // end of word 1
      else if (nWC==nV2)
      { // end of word 2
        sAfterW2=sL;
      } // end of word 2
      nWC++;
    } // end of word
    else
    { // build parts
      if (nWC<nV1)
      { // before word 1
        sBeforeW1=sBeforeW1+sL;
      } // before word 1
      else if (nWC<nV2&&nWC>nV1)
      { // between words
        sAfterW1B4W2=sAfterW1B4W2+sL;
      } // between words
      else if (nWC>nV2)
      { // after word 2
        sAfterW2=sAfterW2+sL;
      } // after word 2
      else if (nWC==nV1)
      { // end of word 1
        sW1=sW1+sL;
      } // end of word 1
      else if (nWC==nV2)
      { // end of word 2
        sW2=sW2+sL;
      } // end of word 2
    } // build parts
    nPos++;
  } // build return string
  sRet=sBeforeW1+sW1+sAfterW1B4W2+sW2+sAfterW2;  // build return string
  return sRet;
} // fnLangRepSwapLoc()


string fnTranslateToLanguage(int nLanguage,string sTranslate)//---------------
{ // PURPOSE: translate sTranslate to language # nLanguage and return the
  // results.
  string sRet=sTranslate;
  object oMod=GetModule();
  string sLang=GetLocalString(oMod,"sNPCLanguage"+IntToString(nLanguage));
  string sRule;
  string sParms;
  if (GetStringLength(sLang)>2)
  { // translate
    if (GetStringLeft(sLang,1)!="&")
    { // not a DMFI language
      while(GetStringLength(sLang)>0)
      { // process translation rules
        sRule=fnParse(sLang,".");
        sLang=fnRemoveParsed(sLang,sRule,".");
        sParms=GetStringRight(sRule,GetStringLength(sRule)-1);
        if (GetStringLeft(sRule,1)=="!")
        { // replace letter
          sRet=fnLangRepLetter(sRet,sParms);
        } // replace letter
        else if (GetStringLeft(sRule,1)=="$")
        { // replace phrase
          sRet=fnLangRepPhrase(sRet,sParms);
        } // replace phrase
        else if (GetStringLeft(sRule,1)=="#")
        { // swap word locations
          sRet=fnLangRepSwapLoc(sRet,sParms);
        } // swap word locations
      } // process translation rules
    } // not a DMFI language
    else
    { // DMFI language
      sLang=GetStringRight(sLang,GetStringLength(sLang)-1);
      sRet=fnDMFIStyleLanguage(sTranslate,sLang);
    } // DMFI language
  } // translate
  return sRet;
} // fnTranslateToLanguage()

int fnConvTestConditional(object oOb,string sCondition)//---------------------
{ // PURPOSE to test a preconversation node conditional
  int bRet=FALSE;
  object oOb=OBJECT_INVALID;
  string sL1=GetStringLeft(sCondition,1);
  string sCon=GetStringRight(sCondition,GetStringLength(sCondition)-1);
  string sS1;
  string sS2;
  string sS3;
  string sC;
  int nN1;
  int nN2;
  int nCurrency;
  if (sL1=="&") oOb=GetPCSpeaker();
  else if (sL1=="#") oOb=OBJECT_SELF;
  else if (sL1=="!") oOb=GetModule();
  else if (sL1=="$") oOb=GetArea(OBJECT_SELF);
  nCurrency=GetLocalInt(oOb,"nCurrency");
  if (GetIsObjectValid(oOb))
  { // test for conditional target found
    if (sCon=="PC"||sCon=="pc") { bRet=GetIsPC(oOb); }
    else if ((sCon=="NPC"||sCon=="npc")&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE) { bRet=!GetIsPC(oOb); }
    else if (sCon=="NA"||sCon=="na") { bRet=TRUE; }
    else
    { // fractured multi-parameter conditional
      sC=GetStringLeft(sCon,1);
      sCon=GetStringRight(sCon,GetStringLength(sCon)-1);
      sS1=fnParse(sCon,"|");
      sCon=fnRemoveParsed(sCon,sS1,"|");
      sS2=fnParse(sCon,"|");
      sS3=fnRemoveParsed(sCon,sS2,"|");
      if (sC=="I")
      { // integer
        if (GetStringLeft(sS3,1)=="!")
        { // retrieve value first
          nN1=GetLocalInt(GetPCSpeaker(),GetStringRight(sS3,GetStringLength(sS3)-1));
          sS3=IntToString(nN1);
        } // retrieve value firse
        if (sS2=="E"&&GetLocalInt(oOb,sS1)==StringToInt(sS3)) bRet=TRUE;
        else if (sS2=="N"&&GetLocalInt(oOb,sS1)!=StringToInt(sS3)) bRet=TRUE;
        else if (sS2=="L"&&GetLocalInt(oOb,sS1)<StringToInt(sS3)) bRet=TRUE;
        else if (sS2=="G"&&GetLocalInt(oOb,sS1)>StringToInt(sS3)) bRet=TRUE;
      } // integer
      else if (sC=="S")
      { // string
        if (GetStringLeft(sS3,1)=="!")
        { // retrieve value first
          sS3=GetLocalString(GetPCSpeaker(),GetStringRight(sS3,GetStringLength(sS3)-1));
        } // retrieve value firse
        if (sS2=="E"&&GetLocalString(oOb,sS1)==sS3) bRet=TRUE;
        else if (sS2=="N"&&GetLocalString(oOb,sS1)!=sS3) bRet=TRUE;
      } // string
      else if (sC=="T")
      { // tag
        if (sS2=="E"&&fnGetNPCTag(oOb)==sS1) bRet=TRUE;
        else if (sS2=="N"&&fnGetNPCTag(oOb)!=sS1) bRet=TRUE;
      } // tag
      else if (sC=="R")
      { // resref
        if (sS2=="E"&&GetResRef(oOb)==sS1) bRet=TRUE;
        else if (sS2=="N"&&GetResRef(oOb)!=sS1) bRet=TRUE;
      } // resref
      else if (sC=="G")
      { // gender
        if (sS1=="O"||sS1=="o") nN1=GENDER_OTHER;
        else if (sS1=="M"||sS1=="m") nN1=GENDER_MALE;
        else if (sS1=="F"||sS1=="f") nN1=GENDER_FEMALE;
        else if (sS1=="N"||sS1=="n") nN1=GENDER_NONE;
        else if (sS1=="B"||sS1=="b") nN1=GENDER_BOTH;
        if (sS2=="E"&&GetGender(oOb)==nN1) bRet=TRUE;
        else if (sS2=="N"&&GetGender(oOb)!=nN1) bRet=TRUE;
      } // gender
      else if (sC=="r")
      { // race
        if (sS1=="H") nN1=RACIAL_TYPE_HUMAN;
        else if (sS1=="h") nN1=RACIAL_TYPE_HALFLING;
        else if (sS1=="E") nN1=RACIAL_TYPE_ELF;
        else if (sS1=="e") nN1=RACIAL_TYPE_HALFELF;
        else if (sS1=="O") nN1=RACIAL_TYPE_HALFORC;
        else if (sS1=="D") nN1=RACIAL_TYPE_DWARF;
        else if (sS1=="A") nN1=RACIAL_TYPE_ANIMAL;
        else if (sS1=="C") nN1=RACIAL_TYPE_CONSTRUCT;
        else if (sS1=="G") nN1=RACIAL_TYPE_GNOME;
        else if (sS1=="U") nN1=RACIAL_TYPE_UNDEAD;
        else if (sS1=="o") nN1=RACIAL_TYPE_OUTSIDER;
        else if (sS1=="B") nN1=RACIAL_TYPE_BEAST;
        else if (sS1=="a") nN1=RACIAL_TYPE_ABERRATION;
        else if (sS1=="g") nN1=RACIAL_TYPE_GIANT;
        else if (sS1=="S") nN1=RACIAL_TYPE_SHAPECHANGER;
        else if (sS1=="M") nN1=RACIAL_TYPE_MAGICAL_BEAST;
        else if (sS1=="F") nN1=RACIAL_TYPE_FEY;
        else if (sS1=="d") nN1=RACIAL_TYPE_DRAGON;
        if (sS2=="E"&&GetRacialType(oOb)==nN1) bRet=TRUE;
        else if (sS2=="N"&&GetRacialType(oOb)!=nN1) bRet=TRUE;
      } // race
      else if (sC=="C")
      { // class
        if (sS1=="AA") nN1=CLASS_TYPE_ARCANE_ARCHER;
        else if (sS1=="A") nN1=CLASS_TYPE_ASSASSIN;
        else if (sS1=="B") nN1=CLASS_TYPE_BARBARIAN;
        else if (sS1=="b") nN1=CLASS_TYPE_BARD;
        else if (sS1=="BG") nN1=CLASS_TYPE_BLACKGUARD;
        else if (sS1=="C") nN1=CLASS_TYPE_CLERIC;
        else if (sS1=="c") nN1=CLASS_TYPE_COMMONER;
        else if (sS1=="DC") nN1=CLASS_TYPE_DIVINECHAMPION;
        else if (sS1=="DD") nN1=CLASS_TYPE_DRAGONDISCIPLE;
        else if (sS1=="D") nN1=CLASS_TYPE_DRUID;
        else if (sS1=="DWD") nN1=CLASS_TYPE_DWARVENDEFENDER;
        else if (sS1=="F") nN1=CLASS_TYPE_FIGHTER;
        else if (sS1=="H") nN1=CLASS_TYPE_HARPER;
        else if (sS1=="M") nN1=CLASS_TYPE_MONK;
        else if (sS1=="P") nN1=CLASS_TYPE_PALADIN;
        else if (sS1=="PM") nN1=CLASS_TYPE_PALEMASTER;
        else if (sS1=="R") nN1=CLASS_TYPE_RANGER;
        else if (sS1=="ROG") nN1=CLASS_TYPE_ROGUE;
        else if (sS1=="SD") nN1=CLASS_TYPE_SHADOWDANCER;
        else if (sS1=="SH") nN1=CLASS_TYPE_SHIFTER;
        else if (sS1=="S") nN1=CLASS_TYPE_SORCERER;
        else if (sS1=="WM") nN1=CLASS_TYPE_WEAPON_MASTER;
        else if (sS1=="W") nN1=CLASS_TYPE_WIZARD;
        if (sS2=="E"&&GetLevelByClass(nN1,oOb)>0) bRet=TRUE;
        else if (sS2=="N"&&GetLevelByClass(nN1,oOb)==0) bRet=TRUE;
      } // class
      else if (sC=="H")
      { // has item
        if (GetItemPossessedBy(oOb,sS1)!=OBJECT_INVALID) bRet=TRUE;
      } // has item
      else if (sC=="N")
      { // does not have item
        if (GetItemPossessedBy(oOb,sS1)==OBJECT_INVALID) bRet=TRUE;
      } // does not have item
      else if (sC=="?")
      { // weather
        nN1=GetWeather(GetArea(oOb));
        nN2=WEATHER_CLEAR;
        if (sS1=="R") nN2=WEATHER_RAIN;
        else if (sS1=="S") nN2=WEATHER_SNOW;
        if (sS2=="E"&&nN1==nN2) bRet=TRUE;
        else if (sS2=="N"&&nN1!=nN2) bRet=TRUE;
      } // weather
      else if (sC=="%")
      { // time
        if (sS1=="D"&&GetIsDay()&&sS2=="E") bRet=TRUE;
        else if (sS1=="D"&&!GetIsDay()&&sS2=="N") bRet=TRUE;
        else if (sS1=="N"&&GetIsNight()&&sS2=="E") bRet=TRUE;
        else if (sS1=="N"&&!GetIsNight()&&sS2=="N") bRet=TRUE;
        else if (sS1=="U"&&GetIsDusk()&&sS2=="E") bRet=TRUE;
        else if (sS1=="U"&&!GetIsDusk()&&sS2=="N") bRet=TRUE;
        else if (sS1=="W"&&GetIsDawn()&&sS2=="E") bRet=TRUE;
        else if (sS1=="W"&&!GetIsDawn()&&sS2=="N") bRet=TRUE;
      } // time
      else if (sC=="A")
      { // alignment
        nN1=FALSE;
        if (sS1=="LG"&&GetAlignmentLawChaos(oOb)==ALIGNMENT_LAWFUL&&GetAlignmentGoodEvil(oOb)==ALIGNMENT_GOOD) nN1=TRUE;
        else if (sS1=="NG"&&GetAlignmentLawChaos(oOb)==ALIGNMENT_NEUTRAL&&GetAlignmentGoodEvil(oOb)==ALIGNMENT_GOOD) nN1=TRUE;
        else if (sS1=="CG"&&GetAlignmentLawChaos(oOb)==ALIGNMENT_CHAOTIC&&GetAlignmentGoodEvil(oOb)==ALIGNMENT_GOOD) nN1=TRUE;
        else if (sS1=="LN"&&GetAlignmentLawChaos(oOb)==ALIGNMENT_LAWFUL&&GetAlignmentGoodEvil(oOb)==ALIGNMENT_NEUTRAL) nN1=TRUE;
        else if (sS1=="TN"&&GetAlignmentLawChaos(oOb)==ALIGNMENT_NEUTRAL&&GetAlignmentGoodEvil(oOb)==ALIGNMENT_NEUTRAL) nN1=TRUE;
        else if (sS1=="CN"&&GetAlignmentLawChaos(oOb)==ALIGNMENT_CHAOTIC&&GetAlignmentGoodEvil(oOb)==ALIGNMENT_NEUTRAL) nN1=TRUE;
        else if (sS1=="LE"&&GetAlignmentLawChaos(oOb)==ALIGNMENT_LAWFUL&&GetAlignmentGoodEvil(oOb)==ALIGNMENT_EVIL) nN1=TRUE;
        else if (sS1=="NE"&&GetAlignmentLawChaos(oOb)==ALIGNMENT_NEUTRAL&&GetAlignmentGoodEvil(oOb)==ALIGNMENT_EVIL) nN1=TRUE;
        else if (sS1=="CE"&&GetAlignmentLawChaos(oOb)==ALIGNMENT_CHAOTIC&&GetAlignmentGoodEvil(oOb)==ALIGNMENT_EVIL) nN1=TRUE;
        if (sS2=="E"&&nN1==TRUE) bRet=TRUE;
        else if (sS2=="N"&&nN1==FALSE) bRet=TRUE;
      } // alignment
      else if (sC=="$")
      { // has amount of gold
        if (GetStringLeft(sS1,1)=="!")
        { // retrieve value
          nN1=GetLocalInt(GetPCSpeaker(),GetStringRight(sS1,GetStringLength(sS1)-1));
          sS1=IntToString(nN1);
        } // retrieve value
        nN1=StringToInt(sS1);
        nN2=GetWealth(oOb,nCurrency);
        if (sS2=="E"&&nN2==nN1) bRet=TRUE;
        else if (sS2=="N"&&nN2!=nN1) bRet=TRUE;
        else if (sS2=="L"&&nN2<nN1) bRet=TRUE;
        else if (sS2=="G"&&nN2>nN1) bRet=TRUE;
      } // has amount of gold
      else if (sC=="!")
      { // level
        nN1=GetLevelByPosition(1,oOb)+GetLevelByPosition(2,oOb)+GetLevelByPosition(3,oOb);
        if (sS2=="E"&&nN1==StringToInt(sS1)) bRet=TRUE;
        else if (sS2=="N"&&nN1!=StringToInt(sS1)) bRet=TRUE;
        else if (sS2=="L"&&nN1<StringToInt(sS1)) bRet=TRUE;
        else if (sS2=="G"&&nN1>StringToInt(sS1)) bRet=TRUE;
      } // level
    } // fractured multi-parameter conditional
  } // test for conditional target found
  return bRet;
} // fnConvTestConditional()


void fnConvCompleted(object oPC)
{ // PURPOSE: This sets variables used during conversation back to
  // default levels
  object oMod=GetModule();
  int nNum=GetLocalInt(oPC,"nGNBConvNum");
  fnConvDebug(oPC,"fnConvCompleted()");
  DeleteLocalInt(oPC,"nGNBConvDepth");
  DeleteLocalInt(oPC,"nGNBConvConsec");
  DeleteLocalInt(oPC,"nGNBConvNum");
  DeleteLocalInt(oMod,"bGNBConvLocked"+IntToString(nNum));
  DeleteLocalObject(oMod,"oGNBConvLocker"+IntToString(nNum));
} // fnConvCompleted()

void fnConvClearConv(object oMe,object oPC,int nDepth=0,int nConsecutive=0)
{ // PURPOSE: to clear the base conversations
  int nLoop=0;
  int nSubLoop;
  string sS;
  DeleteLocalInt(oPC,"nGNBConvDepth");
  DeleteLocalInt(oPC,"nGNBConvConsec");
  DeleteLocalInt(oMe,"nGNBConvDepth");
  DeleteLocalInt(oMe,"nGNBConvConsec");
  sS=GetLocalString(oMe,"sNPCConvNode"+IntToString(nDepth)+"_"+IntToString(nLoop));
  while(GetStringLength(sS)>0)
  { // delete main nodes
    DeleteLocalString(oMe,"sNPCConvNode"+IntToString(nDepth)+"_"+IntToString(nLoop));
    nSubLoop=1;
    sS=GetLocalString(oMe,"sNPCConvResp"+IntToString(nDepth)+"_"+IntToString(nLoop)+"_"+IntToString(nSubLoop));
    while(GetStringLength(sS)>0)
    { // responses
      DeleteLocalString(oMe,"sNPCConvResp"+IntToString(nDepth)+"_"+IntToString(nLoop)+"_"+IntToString(nSubLoop));
      nSubLoop++;
      sS=GetLocalString(oMe,"sNPCConvResp"+IntToString(nDepth)+"_"+IntToString(nLoop)+"_"+IntToString(nSubLoop));
    } // responses
    nLoop++;
    sS=GetLocalString(oMe,"sNPCConvNode"+IntToString(nDepth)+"_"+IntToString(nLoop));
  } // delete main nodes
} // fnConvClearConv()

//void main(){}
