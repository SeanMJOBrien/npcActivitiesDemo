////////////////////////////////////////////////////////////////////////////////
// npcact_ext_sgos - NPC ACTIVITIES 6.0  sgos external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"

void fnSetGossip(string sListen)
{
  SetListenPattern(OBJECT_SELF,sListen+"**",6132004);
  SetLocalString(OBJECT_SELF,"sGNBListen",sListen+"**");
}


void main()
{
  object oMe=OBJECT_SELF;
  string sParm=GetLocalString(oMe,"sParm");
  if (GetStringLeft(sParm,4)=="SGOS") sParm=GetStringRight(sParm,GetStringLength(sParm)-4);
  else { sParm=GetStringRight(sParm,GetStringLength(sParm)-2); }
  fnSetGossip(sParm);
  DeleteLocalString(oMe,"sParm");
  SetLocalFloat(oMe,"fDelay",0.1);
}
