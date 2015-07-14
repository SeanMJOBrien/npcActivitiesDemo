////////////////////////////////////////////////////////////////////////////////
// npcact_ext_flee - NPC ACTIVITIES 6.0  Flee external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////

void main()
{
    object oMe=OBJECT_SELF;
    object oEnemy=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,oMe,1,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN,CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);
    if (GetIsObjectValid(oEnemy))
    { // see enemy
      SetLocalFloat(oMe,"fDelay",12.0);
      AssignCommand(oMe,ClearAllActions(TRUE));
      AssignCommand(oMe,ActionMoveAwayFromObject(oEnemy,TRUE));
    } // see enemy
    else { DeleteLocalFloat(oMe,"fDelay"); }
}
