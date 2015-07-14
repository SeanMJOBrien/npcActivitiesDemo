//////////////////////////////////////////////////////////////////////////////
// NPC ACTIVITIES 6.0 DM Wand Script - By Deva Bryson Winblood
//////////////////////////////////////////////////////////////////////////////
void main()
{
   object oItem=GetItemActivated();
   object oPC=GetItemActivator();
   object oTarget=GetItemActivatedTarget();
   int nGNB;
   if (GetIsDM(oPC)==TRUE)
   { // DM
     if (GetIsObjectValid(oTarget)&&GetObjectType(oTarget)==OBJECT_TYPE_CREATURE&&!GetIsPC(oTarget))
     { // valid target
       SetLocalObject(oPC,"oDMTarget",oTarget);
       AssignCommand(oPC,ClearAllActions(TRUE));
       AssignCommand(oPC,ActionStartConversation(oPC,"npcact_dm",TRUE,FALSE));
     } // valid target
     else
     { // bad target
       SendMessageToPC(oPC,"Not a valid target for this wand.");
     } // bad target
   } // DM
   else
   {
      SendMessageToPC(oPC,"You are not a DM!");
      DestroyObject(oItem);
   }
}
