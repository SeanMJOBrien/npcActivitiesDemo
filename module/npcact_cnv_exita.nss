///////////////////////////////////////////////////////////////////////////////
// NPCACT_CNV_EXITA - NPC ACTIVITIES 6.0 Conversation add-on
// Exit conversation - abort
// By Deva Bryson Winblood.  09/03/2004
///////////////////////////////////////////////////////////////////////////////
#include "npcact_h_cconv"

void fnTestForEnd(object oPC)
{ // see if okay to end
  object oMod;
  if (!IsInConversation(oPC))
  { // okay to terminate
    fnConvCompleted(oPC);
  } // okay to terminate
} // fnTestForEnd()


void main()
{
   object oPC=GetPCSpeaker();
   object oMe=OBJECT_SELF;
   DelayCommand(1.0,fnTestForEnd(oPC));
   ExecuteScript("npcact_wrapca",oMe);
}
