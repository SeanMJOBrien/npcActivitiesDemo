////////////////////////////////////////////////////////////////////////////////
// npcact_dl_settle - NPC ACTIVITIES Dynamic Lairs - If this area is empty then
// make it this NPC's lair.
//------------------------------------------------------------------------------
// Original Scripter: Deva B. Winblood.    Scripted On: 13-Nov-2006
//------------------------------------------------------------------------------
// PURPOSE: To see if any creatures or PCs are present in this lair and if
// neither are present set this creatures Virtual Tag so, that they turn this
// area into their lair.
////////////////////////////////////////////////////////////////////////////////
#include "npcact_h_dynamic"

void main()
{
   object oNPC=OBJECT_SELF;
   object oWP=GetLocalObject(oNPC,"oGNBArrived");
   string sVTag=GetLocalString(oWP,"sLairVTag");
   string sNoSettle=GetLocalString(oWP,"sNoSettleTag");
   string sSettle=GetLocalString(oNPC,"sNPCDL_Settle");
   object oOb;
   if (GetStringLength(sVTag)>0)
   { // virtual tag
       NPCACT_DL_DEBUG("npcact_dl_settle");
       oOb=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,oNPC,1);
       if (!GetIsObjectValid(oOb))
       { // okay to settle
           NPCACT_DL_DEBUG("  Okay to settle with VTag:"+sVTag);
           oOb=CopyObject(oNPC,GetLocation(oNPC),OBJECT_INVALID,sVTag);
           SetLocalString(oOb,"sGNBVirtualTag",sVTag);
           oWP=GetArea(oOb);
           if (GetLocalInt(oNPC,"bNPCDL_Possess")) ExecuteScript("npcact_dl_pos",oOb);
           SetAILevel(oOb,GetAILevel(oNPC));
           DestroyObject(oNPC);
           NPCACT_DL_List_Add(oWP,oOb);
           SetLocalString(oOb,"sNPCDL_Settle",sSettle);
       } // okay to settle
       else if (GetStringLength(sNoSettle)>0)
       { // no settle
           NPCACT_DL_DEBUG("  cannot settle VTAG:"+sNoSettle);
           SetLocalString(oNPC,"sGNBVirtualTag",sNoSettle);
       } // no settle
   } // virtual tag
}
