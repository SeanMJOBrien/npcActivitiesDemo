//////////////////////////////////////////////////////////////////////
// npcact_pl_m_pop - NPC ACTIVITIES 6.0 Professions Merchant
// OnOpen Sell To merchant invisible placeable
// By Deva Bryson Winblood. 07/24/2005
//////////////////////////////////////////////////////////////////////
void main()
{
   object oMe=OBJECT_SELF;
   object oPlayer=GetLocalObject(oMe,"oPlayer");
   object oPC=GetLastOpenedBy();
   if (oPC!=oPlayer)
   { // someone trying to open
     SendMessageToPC(oPC,"You are not allowed to open that!");
     AssignCommand(oPC,ClearAllActions(TRUE));
     AssignCommand(oPC,ActionMoveAwayFromObject(oMe,TRUE,20.0));
   } // someone trying to open
}
