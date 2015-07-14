////////////////////////////////////////////////////////////////////////////////
// npcact_ext_SLIS - NPC ACTIVITIES 6.0  Set Listen external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////

void main()
{
     SetListening(OBJECT_SELF,TRUE);
     SetListenPattern(OBJECT_SELF,"Did you hear**",6132004);
     SetLocalString(OBJECT_SELF,"sGNBListen","Did you hear**");
     SetLocalString(OBJECT_SELF,"sCRSPUser","npcact_ud_list");
     SetLocalFloat(OBJECT_SELF,"fDelay",0.1);
} // NPCAct4SetListen()
