////////////////////////////////////////////////////////////////////////////////
// npcact_ext_goss - NPC ACTIVITIES 6.0  Gossip external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/16/2004
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"

void main()
{
  int nHeard=GetLocalInt(OBJECT_SELF,"nDBWSStackGossipNum");
  string sPhrase;
  string sSay;
  string sListen=GetLocalString(OBJECT_SELF,"sGNBListen");
  int nRnd;
  sListen=GetStringLeft(sListen,GetStringLength(sListen)-2);
  fnDebug(" npcact_ext_goss: nHeard:"+IntToString(nHeard),TRUE);
  if (nHeard==0)
  { // nothing to say
    nRnd=d4();
    if (nRnd==1)
      ActionSpeakString("I don't know anything of interest.");
    else if (nRnd==2)  ActionSpeakString("I wonder what happened to the good old '"+sListen+"' phrases?");
    else if (nRnd==3)  ActionSpeakString("I have not heard any decent gossip.");
    else if (nRnd==4)  ActionSpeakString("I have been listening but, have not heard any good gossip.");
  } // nothing to say
  else
  { // do gossip
    nHeard=Random(nHeard)+1;
    sSay="Gossip"+IntToString(nHeard);
    sPhrase=GetLocalString(OBJECT_SELF,sSay);
    fnDebug("  sPhrase:"+sPhrase,TRUE);
    ActionSpeakString(sListen+sPhrase);
  } // do gossip
} // NPCAct4Gossip()
