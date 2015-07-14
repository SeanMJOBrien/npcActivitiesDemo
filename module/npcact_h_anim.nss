////////////////////////////////////////////////////////////////////////////////
// npcact_h_anim - NPC ACTIVITIES 6.0 Animation Header
// By Deva Bryson Winblood.  09/08/2004
// additions 49-60, frozen animations, magic strings peak 4/15/09
//-----------------------------------------------------------------------------
// The Animation Magic Number system is used in several places in the scripts
// therefore, the portion that assigns those magic numbers needed its own
// header so, that adding numbers would be easier without having to search out
// individual portions of code.
////////////////////////////////////////////////////////////////////////////////

//////////////////////////////
// PROTOTYPES
//////////////////////////////

// FILE: npcact_h_anim              FUNCTION: fnNPCACTAnimMagicNumber()
// This file will return the actual Bioware animation number based on the
// magic number entered.  Instead of using magic numbers I could have simply
// gone with Bioware's numbers but, I needed to do this to remain 100%
// backwards compatible with older NPC ACTIVITIES scripts.
int fnNPCACTAnimMagicNumber(string sNum);

// FILE: npcact_h_anim              FUNCTION: fnNPCACTAnimFrozen()
// PURPOSE: To enable people to use words to represent the
// frozen animations instead of requiring library call #na/7
string fnNPCACTAnimFrozen(string sNum);

// FILE: npcact_h_anim              FUNCTION: fnNPCACTAnimMagicString()
// PURPOSE: To return the magic number based on the MagicAnimationNumber or
// based on the shorthand or on Frozen Animation call #<anim>/<freeze>/<dur>
string fnNPCACTAnimMagicString(string sNum);

//////////////////////////////
// FUNCTIONS
//////////////////////////////

int fnNPCACTAnimMagicNumberActual(int nNum)
{ // PURPOSE: To return the Bioware animation number from the
  // passed magic number
    int nAnim=0;
    if (nNum==1) nAnim=ANIMATION_FIREFORGET_BOW;
    else if (nNum==2) nAnim=ANIMATION_FIREFORGET_DRINK;
    else if (nNum==3) nAnim=ANIMATION_FIREFORGET_GREETING;
    else if (nNum==4) nAnim=ANIMATION_FIREFORGET_HEAD_TURN_LEFT;
    else if (nNum==5) nAnim=ANIMATION_FIREFORGET_HEAD_TURN_RIGHT;
    else if (nNum==6) nAnim=ANIMATION_FIREFORGET_PAUSE_BORED;
    else if (nNum==7) nAnim=ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD;
    else if (nNum==8) nAnim=ANIMATION_FIREFORGET_READ;
    else if (nNum==9) nAnim=ANIMATION_FIREFORGET_SALUTE;
    else if (nNum==10) nAnim=ANIMATION_FIREFORGET_STEAL;
    else if (nNum==11) nAnim=ANIMATION_FIREFORGET_TAUNT;
    else if (nNum==12) nAnim=ANIMATION_FIREFORGET_VICTORY1;
    else if (nNum==13) nAnim=ANIMATION_FIREFORGET_VICTORY2;
    else if (nNum==14) nAnim=ANIMATION_FIREFORGET_VICTORY3;
    else if (nNum==15) nAnim=ANIMATION_LOOPING_DEAD_FRONT;
    else if (nNum==16) nAnim=ANIMATION_LOOPING_GET_LOW;
    else if (nNum==17) nAnim=ANIMATION_LOOPING_GET_MID;
    else if (nNum==18) nAnim=ANIMATION_LOOPING_LISTEN;
    else if (nNum==19) nAnim=ANIMATION_LOOPING_LOOK_FAR;
    else if (nNum==20) nAnim=ANIMATION_LOOPING_MEDITATE;
    else if (nNum==21) nAnim=ANIMATION_LOOPING_PAUSE;
    else if (nNum==22) nAnim=ANIMATION_LOOPING_PAUSE_DRUNK;
    else if (nNum==23) nAnim=ANIMATION_LOOPING_PAUSE_TIRED;
    else if (nNum==24) nAnim=ANIMATION_LOOPING_PAUSE2;
    else if (nNum==25) nAnim=ANIMATION_LOOPING_SIT_CHAIR;
    else if (nNum==26) nAnim=ANIMATION_LOOPING_SIT_CROSS;
    else if (nNum==27) nAnim=ANIMATION_LOOPING_TALK_FORCEFUL;
    else if (nNum==28) nAnim=ANIMATION_LOOPING_TALK_LAUGHING;
    else if (nNum==29) nAnim=ANIMATION_LOOPING_TALK_NORMAL;
    else if (nNum==30) nAnim=ANIMATION_LOOPING_TALK_PLEADING;
    else if (nNum==31) nAnim=ANIMATION_LOOPING_WORSHIP;
    else if (nNum==32) nAnim=ANIMATION_FIREFORGET_DODGE_DUCK;
    else if (nNum==33) nAnim=ANIMATION_FIREFORGET_DODGE_SIDE;
    else if (nNum==34) nAnim=ANIMATION_FIREFORGET_SPASM;
    else if (nNum==35) nAnim=ANIMATION_LOOPING_CONJURE1;
    else if (nNum==36) nAnim=ANIMATION_LOOPING_CONJURE2;
    else if (nNum==37) nAnim=ANIMATION_LOOPING_CUSTOM1;
    else if (nNum==38) nAnim=ANIMATION_LOOPING_CUSTOM2;
    else if (nNum==39) nAnim=ANIMATION_LOOPING_DEAD_BACK;
    else if (nNum==40) nAnim=ANIMATION_LOOPING_SPASM;
    else if (nNum==41) nAnim=ANIMATION_LOOPING_CUSTOM3;
    else if (nNum==42) nAnim=ANIMATION_LOOPING_CUSTOM4;
    else if (nNum==43) nAnim=ANIMATION_LOOPING_CUSTOM5;
    else if (nNum==44) nAnim=ANIMATION_LOOPING_CUSTOM6;
    else if (nNum==45) nAnim=ANIMATION_LOOPING_CUSTOM7;
    else if (nNum==46) nAnim=ANIMATION_LOOPING_CUSTOM8;
    else if (nNum==47) nAnim=ANIMATION_LOOPING_CUSTOM9;
    else if (nNum==48) nAnim=ANIMATION_LOOPING_CUSTOM10;
    else if (nNum==49) nAnim=ANIMATION_LOOPING_CUSTOM11;
    else if (nNum==50) nAnim=ANIMATION_LOOPING_CUSTOM12;
    else if (nNum==51) nAnim=ANIMATION_LOOPING_CUSTOM13;
    else if (nNum==52) nAnim=ANIMATION_LOOPING_CUSTOM14;
    else if (nNum==53) nAnim=ANIMATION_LOOPING_CUSTOM15;
    else if (nNum==54) nAnim=ANIMATION_LOOPING_CUSTOM16;
    else if (nNum==55) nAnim=ANIMATION_LOOPING_CUSTOM17;
    else if (nNum==56) nAnim=ANIMATION_LOOPING_CUSTOM18;
    else if (nNum==57) nAnim=ANIMATION_LOOPING_CUSTOM19;
    else if (nNum==58) nAnim=ANIMATION_LOOPING_CUSTOM20;
    else if (nNum==59) nAnim=ANIMATION_MOUNT1;
    else if (nNum==60) nAnim=ANIMATION_DISMOUNT1;
    return nAnim;
} // fnNPCACTAnimMagicNumberActual()

int fnNPCACTAnimMagicShorthand(string sNum)
{ // PURPOSE: To enable people to use words to represent the
  // animations instead of requiring numbers
  int nAnim=0;
  if (sNum=="BOW"||sNum=="BW") nAnim=1;
  else if (sNum=="DRIN"||sNum=="DR") nAnim=2;
  else if (sNum=="GRET"||sNum=="GR") nAnim=3;
  else if (sNum=="HTL") nAnim=4;
  else if (sNum=="HTR") nAnim=5;
  else if (sNum=="BORD"||sNum=="BO") nAnim=6;
  else if (sNum=="SCRT"||sNum=="SH") nAnim=7;
  else if (sNum=="READ"||sNum=="RD") nAnim=8;
  else if (sNum=="SALT"||sNum=="SA") nAnim=9;
  else if (sNum=="STEAL") nAnim=10;
  else if (sNum=="TAUNT") nAnim=11;
  else if (sNum=="VIC1"||sNum=="V1") nAnim=12;
  else if (sNum=="VIC2"||sNum=="V2") nAnim=13;
  else if (sNum=="VIC3"||sNum=="V3") nAnim=14;
  else if (sNum=="DEADF") nAnim=15;
  else if (sNum=="LOW"||sNum=="LW") nAnim=16;
  else if (sNum=="MID"||sNum=="MD") nAnim=17;
  else if (sNum=="LIST"||sNum=="LI") nAnim=18;
  else if (sNum=="LOOK"||sNum=="LK") nAnim=19;
  else if (sNum=="MEDI"||sNum=="ME") nAnim=20;
  else if (sNum=="PAU1"||sNum=="P1") nAnim=21;
  else if (sNum=="DRUN"||sNum=="DK") nAnim=22;
  else if (sNum=="TIRD"||sNum=="TI") nAnim=23;
  else if (sNum=="PAU2"||sNum=="P2") nAnim=24;
  else if (sNum=="SIT"||sNum=="SI") nAnim=25;
  else if (sNum=="SITC"||sNum=="SC") nAnim=26;
  else if (sNum=="TAFO"||sNum=="TF") nAnim=27;
  else if (sNum=="TALA"||sNum=="TL") nAnim=28;
  else if (sNum=="TANM"||sNum=="TN") nAnim=29;
  else if (sNum=="TAPL"||sNum=="TP") nAnim=30;
  else if (sNum=="WORS"||sNum=="WS") nAnim=31;
  else if (sNum=="DUCK") nAnim=32;
  else if (sNum=="SIDE") nAnim=33;
  else if (sNum=="FFSPASM") nAnim=34;
  else if (sNum=="CONJ1") nAnim=35;
  else if (sNum=="CONJ2") nAnim=36;
  else if (sNum=="CUST1") nAnim=37;
  else if (sNum=="CUST2") nAnim=38;
  else if (sNum=="DEADB") nAnim=39;
  else if (sNum=="SPASM") nAnim=40;
  else if (sNum=="CUST3") nAnim=41;
  else if (sNum=="CUST4") nAnim=42;
  else if (sNum=="CUST5") nAnim=43;
  else if (sNum=="CUST6") nAnim=44;
  else if (sNum=="CUST7") nAnim=45;
  else if (sNum=="CUST8") nAnim=46;
  else if (sNum=="CUST9") nAnim=47;
  else if (sNum=="CUST10") nAnim=48;
  else if (sNum=="CUST11") nAnim=49;
  else if (sNum=="CUST12") nAnim=50;
  else if (sNum=="CUST13") nAnim=51;
  else if (sNum=="CUST14") nAnim=52;
  else if (sNum=="CUST15") nAnim=53;
  else if (sNum=="CUST16") nAnim=54;
  else if (sNum=="CUST17") nAnim=55;
  else if (sNum=="CUST18") nAnim=56;
  else if (sNum=="CUST19") nAnim=57;
  else if (sNum=="CUST20") nAnim=58;
  else if (sNum=="MNT") nAnim=59;
  else if (sNum=="DMNT") nAnim=60;
  return nAnim;
} // fnNPCACTAnimMagicShorthand()
//used pairs:BO BW DK DR GR LI LW MD ME P1 P2 RD SA SC SG SH SI TF TI TL TN TP V1 V2 V3 WS

string fnNPCACTAnimFrozen(string sNum)
{ //added peak 4/15/09
  // PURPOSE: To enable people to use words to represent the
  // frozen animations instead of requiring library call #na/7
  string sAnim="";
  if (sNum=="LOUNGE") sAnim="#17/14"; //emulates #na/7/17/14/##
  if (sNum=="SITGRD"||sNum=="SG") sAnim="#17/22"; //emulates #na/7/17/22/##
  return sAnim;
} // fnNPCACTAnimFrozen()

string fnNPCACTAnimMagicString(string sNum)
{ // PURPOSE: To return the magic number based on the # or
  // based on the shorthand including the new frozen anims, as a string
  string sAnim="";
  int nAnim=0;
  if (StringToInt(sNum)>0) //valid - does not include "#..." or alphas "A..."
    nAnim=fnNPCACTAnimMagicNumberActual(StringToInt(sNum)); //called anim by magicnumber
  else
  { // possibly shorthand
    nAnim=fnNPCACTAnimMagicShorthand(sNum);  //get anim number by shorthand
    if(nAnim==0) sAnim=fnNPCACTAnimFrozen(sNum); // possibly frozen animation
  } // possibly shorthand
  if(nAnim>0) sAnim=IntToString(nAnim); //direct or shorthand found; frozen already returned sAnim
  return sAnim;
} // fnNPCACTAnimMagicString() - called by string to allow passing parameter eg #17/14, maybe #17/H14 to hide initial anim


int fnNPCACTAnimMagicNumber(string sNum)  //maintained for other anim calls
{ // PURPOSE: To return the magic number based on the # or
  // based on the shorthand
  int nAnim=0;
  int nN=0;
  if (StringToInt(sNum)>0) nAnim=fnNPCACTAnimMagicNumberActual(StringToInt(sNum));
  else { // possibly shorthand
    nN=fnNPCACTAnimMagicShorthand(sNum);
    if (nN>0) nAnim=fnNPCACTAnimMagicNumberActual(nN);
  } // possibly shorthand
  return nAnim;
} // fnNPCACTAnimMagicNumber()

//void main(){} //notes on fake void: uncomment to allow compilation and errortrapping, then recomment and straight save
