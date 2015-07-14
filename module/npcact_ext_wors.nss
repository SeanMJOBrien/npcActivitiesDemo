////////////////////////////////////////////////////////////////////////////////
// npcact_ext_wors - NPC ACTIVITIES 6.0  Worship external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/03/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/03/2004
////////////////////////////////////////////////////////////////////////////////

void main()
{
   object oMe=OBJECT_SELF;
   object oTarget=OBJECT_INVALID;
   float fDist;
   int nParm=GetLocalInt(oMe,"nNPCParm");
   if (nParm==0)
   { // PC
     oTarget=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,oMe,1,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
   } // PC
   else if (nParm==1)
   { // NPC
     oTarget=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_NOT_PC,oMe,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_IS_ALIVE,TRUE);
   } // NPC
   if (GetIsObjectValid(oTarget))
   { // valid target
     SetLocalFloat(oMe,"fDelay",10.0);
     ActionMoveToObject(oTarget,TRUE,2.0);
     ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP,1.0,6.0);
   } // valid target
   DeleteLocalInt(oMe,"nNPCParm");
}
