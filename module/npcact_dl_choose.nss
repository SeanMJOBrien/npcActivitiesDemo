////////////////////////////////////////////////////////////////////////////////
// npcact_dl_choose - NPC ACTIVITIES Dynamic Lairs - Choose Path Script
//------------------------------------------------------------------------------
// Original Scripter: Deva B. Winblood    Scripted Date:  13-Nov-2006
//------------------------------------------------------------------------------
// This script will consult the waypoint that this script was executed from and
// will look at the following values:
// nVTags = The # of virtual tags
// sVTag_# = virtual tag
// It will randomly pick one of these tags and assign it to the NPC
////////////////////////////////////////////////////////////////////////////////
#include "npcact_h_dynamic"


void main()
{
   object oNPC=OBJECT_SELF;
   object oWP=GetLocalObject(oNPC,"oGNBArrived");
   int nTags=GetLocalInt(oWP,"nVTags");
   string sTag;
   int nRoll;
   if (nTags>0)
   { // pick VTag
       nRoll=Random(nTags)+1;
       sTag=GetLocalString(oWP,"sVTag_"+IntToString(nRoll));
       NPCACT_DL_DEBUG("Choose random VTAG #:"+IntToString(nRoll)+" Tag:"+sTag);
       SetLocalString(oNPC,"sGNBVirtualTag",sTag);
   } // pick VTag
}
