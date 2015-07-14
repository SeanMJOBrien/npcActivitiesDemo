// npcact_ext_clean         NPC ACTIVITIES 6.1
// By Deva Bryson Winblood.   02/13/2006
//=============================================================================
// This function is intended as an item cleanup script for an area.  The NPC
// will pickup any items within 10 meters of where this script is called and
// will walk to a placeable container with specified tag stored in
// sGNBStorageTag on this NPC.  It will place the items within there.  This
// script only works within a single area, so the items to cleanup and the
// placeable to put them in both need to be in the area this script is called
// from.  An important behavior to note is that if the item cannot be reached
// and is a plot item it will simply be instantly copied into the container. If
// it is not plot it will be destroyed.  WARNING: Do not use this in areas where
// you intentionally have placed items on the ground.  This script will cleanup
// those as well if it is fired within 10 meters of them.
#include "npcactlibtoolh"
#include "npcact_h_moving"
void main()
{
   object oMe=OBJECT_SELF;
   string sTag=GetLocalString(oMe,"sGNBStorageTag");
   object oChest=GetNearestObjectByTag(sTag,oMe);
   object oItem;
   object oCopy;
   int nN;
   int nState=GetLocalInt(oMe,"nDEMOState");
   DLL_SetProcessingFlag(oMe);
   DLL_SetNPCState(oMe,NPC_STATE_WAIT_FOR_COMMAND);
   if (!DLL_NPCIsBusy(oMe))
   { // not busy
   switch(nState)
   { // SWITCH
     case 0:
     { // Look For Things To Cleanup
       oItem=GetNearestObject(OBJECT_TYPE_ITEM,oMe,1);
       if (GetDistanceBetween(oMe,oItem)<10.0)
       { // within cleanup range
         if (GetItemPossessor(oItem)==oMe)
         { // I have the item
           SetLocalInt(oMe,"nDEMOState",1); // take item to chest
         } // I have the item
         else if (GetDistanceBetween(oMe,oItem)>1.5)
         { // move
           AssignCommand(oMe,ClearAllActions());
           nN=fnMoveToDestination(oMe,oItem,1.5);
           if (nN==-1)
           { // could not reach
             if(GetPlotFlag(oItem)!=TRUE)
             { // destroy it
               DestroyObject(oItem);
             } // destroy it
             else
             { // copy
               oCopy=CopyItem(oItem,oChest,TRUE);
               DestroyObject(oItem);
             } // copy
           } // could not reach
         } // move
         else if (oItem!=OBJECT_INVALID)
         { // pickup the item
           SetLocalObject(oMe,"oDemoItem",oItem);
           AssignCommand(oMe,ClearAllActions());
           AssignCommand(oMe,ActionPickUpItem(oItem));
         } // pickup the item
       } // within cleanup range
       else
       { // none within range
         SetLocalInt(oMe,"nDEMOState",4);
       } // none within range
       DelayCommand(6.0,ExecuteScript("npcact_ext_clean",oMe));
       break;
     } // Look For Things To Cleanup
     case 1:
     { // Move to chest
       if (GetDistanceBetween(oMe,oChest)>1.5)
       { // move
         nN=fnMoveToDestination(oMe,oChest,1.5);
         if (nN==-1)
         { // cannot reach
           AssignCommand(oMe,SpeakString("npcact_ext_clean error #1: I cannot reach the storage chest!"));
           SetLocalInt(oMe,"nDEMOState",4);
         } // cannot reach
       } // move
       else
       { // arrived
         SetLocalInt(oMe,"nDEMOState",2);
       } // arrived
       DelayCommand(3.0,ExecuteScript("npcact_ext_clean",oMe));
       break;
     } // Move to chest
     case 2:
     { // Put items in chest
       if (oChest!=OBJECT_INVALID)
       { // chest exists
         AssignCommand(oMe,ActionInteractObject(oChest));
         oItem=GetLocalObject(oMe,"oDemoItem");
         oCopy=CopyItem(oItem,oChest,TRUE);
         DestroyObject(oItem);
         DeleteLocalObject(oMe,"oDemoItem");
         SetLocalInt(oMe,"nDEMOState",3);
       } // chest exists
       else
       { // there is no chest
         AssignCommand(oMe,SpeakString("npcact_ext_clean error #2: The storage chest cannot be found for this NPC"));
         SetLocalInt(oMe,"nDEMOState",4);
       } // there is no chest
       DelayCommand(6.0,ExecuteScript("npcact_ext_clean",oMe));
       break;
     } // Put items in chest
     case 3:
     { // Return to location started
       oChest=DLL_GetRecentDestination(oMe);
       nN=fnMoveToDestination(oMe,oChest,1.5);
       if (nN==1)
       { // arrived
         SetLocalInt(oMe,"nDEMOState",0); // look for more items
       } // arrived
       else if (nN==-1)
       { // cannot reach
         SetLocalInt(oMe,"nDEMOState",4);
       } // cannot reach
       DelayCommand(4.0,ExecuteScript("npcact_ext_clean",oMe));
       break;
     } // Return to location started
     case 4:
     { // end custom script
       DLL_SetNPCState(oMe,NPC_STATE_INTERPRET_COMMAND);
       DeleteLocalInt(oMe,"nDEMOState");
       break;
     } // end custom script
   } // SWITCH
   } // not busy
}
