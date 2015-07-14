////////////////////////////////////////////////////////////////
// NPC ACTIVITIES 5.0 - OnUserDefined Script
////////////////////////////////////////////////////////////////
// By Deva Bryson Winblood.  01/2003
//==============================================================
// Required for SLIS, and GOSSIP commands
//==============================================================
// SCRIPT: npcact_ud_list
////////////////////////////////////////////////////////////////
// Do not assign this manually to an NPC it will be assigned by
// the CRSP functions of NPC ACTIVITIES if necessary
////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
#include "npcactstackh"

void main()
{
   int nUserEvent=GetUserDefinedEventNumber();
   int nLisNum;
   string sPatternNPC=GetLocalString(OBJECT_SELF,"sGNBListen");
   string sHeard;
   string sWork;
   int nRnd;
   struct StackHeader stack;
   //SendMessageToPC(GetFirstPC(),GetTag(OBJECT_SELF)+" UserDef called.");
   if (nUserEvent==1004)
   { // gossip phrase was heard
     nLisNum=GetListenPatternNumber();
     if (nLisNum==6132004)
     { // the gossip pattern
       sHeard=GetMatchedSubstring(0);
       fnDebug("   Heard something: GetMatchedSubstring(0)='"+sHeard+"'",TRUE);
       //SendMessageToPC(GetFirstPC(),GetTag(OBJECT_SELF)+" HEARD:"+sHeard);
       if (TestStringAgainstPattern(sPatternNPC,sHeard)==TRUE)
       { // gossip trigger was heard
          //sHeard=GetStringRight(sHeard,GetStringLength(sHeard)-(GetStringLength(sPatternNPC)-2));
          sHeard=GetMatchedSubstring(1);
          fnDebug("    What heard '"+sHeard+"'",TRUE);
          stack=fnGetLocalStack("Gossip");
          if(!fnAlreadyOnStack(stack,sHeard))
          { // it is something new
            nRnd=d4();
            if (nRnd==1) ActionSpeakString("I had not heard that.");
            else if (nRnd==2) ActionSpeakString("That is interesting.");
            else if (nRnd==3) ActionSpeakString("Really?");
            else ActionSpeakString("That is quite extraordinary.");
            stack = fnPushStack(stack,sHeard);
            fnSetLocalStack(stack);
          } // it is something new
          else { ActionSpeakString("Yes, I had already heard that."); }
       } // gossip trigger was heard
     } // the gossip pattern
   } // gossip phrase was heard
}
