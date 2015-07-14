////////////////////////////////////////////////////////////////////////////////
// npc_ex_ondeath - NPC OnDeath Experience managing
// By Deva B. Winblood. 03/27/2007
////////////////////////////////////////////////////////////////////////////////

#include "lib_nais_xp"

void main()
{
   object oDied=OBJECT_SELF;
   object oKiller=GetLastKiller();
   object oDamager=GetLastDamager();
   if (!GetIsObjectValid(oKiller)&&GetIsObjectValid(oDamager)&&GetDistanceBetween(oDied,oDamager)<40.0&&GetArea(oDamager)==GetArea(oDied)) oKiller=oDamager;
   if (NBDE_GetCampaignInt("NAIS1MOD","bNoLevelUpLair")&&GetObjectType(oKiller)==OBJECT_TYPE_CREATURE)
   { // not in lair
       XP_AwardVirtual(oKiller,oDied);
       XP_TransferVirtualXP(oKiller);
   } // not in lair
   else
   { // in lair only
       if (GetObjectType(oKiller)==OBJECT_TYPE_CREATURE) XP_AwardVirtual(oKiller,oDied,"",TRUE);
   } // in lair only
}
