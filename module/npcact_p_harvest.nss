///////////////////////////////////////////////////////////////////////////////
// npcact_p_harvest - NPC ACTIVITIES 6.0 Profession "Harvester"
// By Deva Bryson Winblood.  09/08/2004 & 01/17/2006 Modified 6/16/10 Peak
//-----------------------------------------------------------------------------
// PURPOSE: This profession handles harvesting natural resources.  It is good
// for Lumberjacks, farmers, miners, etc.
//-----------------------------------------------------------------------------
// bInheritVPostVariables set to 1 on NPC causes following to come from
//    POST_<Virtual Tag> instead - Peak 6/16/10
// sProfHarvestLoc - Location to Harvest
// sProfHarvestPlace - Placeable or Waypoint to use for Harvesting @@@
// sProfHarvestTool - Tool Required when Harvesting
// sProfHarvestToolRes - ResRef for Tool
// nProfHarvestToolFR - Tool Fatigue Rate // not used @@@
// sProfHarvestToolLoc - Location to go to to purchase tool
// sProfHarvestToolFrom - Person to by the tool from
// nProfHarvestToolCost - Cost for the tool
// sProfHarvestMethod - Method used to harvest
// sProfHarvestRes - Type of resource produced ResRef @@@ item?
// sProfHarvestDeliverLoc - Location to deliver resource
// sProfHarvestTag - Tag of Resource Type
// nProfHarvestStack - Stack Size of resource produced
// nProfHarvestShift - How many units of resource produced per shift
// nProfHarvestWage - Wage paid at the end of the shift
// nProfHarvestWear - Tool wear per resource harvested
///////////////////////////////////////////////////////////////////////////////
#include "npcact_h_prof"
#include "npcact_h_money"
////////////////////////////////
// PROTOTYPES
////////////////////////////////

//////////////////////////////////////////////////////////////////////// MAIN
void main()
{
   object oNPC=OBJECT_SELF;
   object oMy=OBJECT_SELF;
   if(GetLocalInt(oMy,"bInheritVPostVariables")) oMy=GetObjectByTag("POST_"+fnGetNPCTag(oMy));
   object oOb;
   int nN;
   string sS;
   int nState=GetLocalInt(oNPC,"nProfState");
   fnDebugInt("ProfHarvState ",nState);
   int nSpeed=GetLocalInt(oNPC,"nGNBStateSpeed");
   if(!nSpeed) nSpeed=GetLocalInt(GetModule(),"nGNBStateSpeed"); // 6/06/10 Peak
   if (nSpeed<1) nSpeed=6;
   string sHarvLoc=GetLocalString(oMy,"sProfHarvestLoc");
   string sHarvPlc=GetLocalString(oMy,"sProfHarvestPlace");
   string sHarvPlc1, sHarvPlc2, sHarvPlc3; // peak 5/10..
         oOb=GetNearestObjectByTag(sHarvPlc+"1",oNPC,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sHarvPlc+"1");
         if (GetIsObjectValid(oOb)) { sHarvPlc1=GetTag(oOb); } //for W1
         oOb=GetNearestObjectByTag(sHarvPlc+"2",oNPC,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sHarvPlc+"2");
         if (GetIsObjectValid(oOb)) { sHarvPlc2=GetTag(oOb); } //for W2
         oOb=GetNearestObjectByTag(sHarvPlc+"3",oNPC,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sHarvPlc+"3");
         if (GetIsObjectValid(oOb)) { sHarvPlc3=GetTag(oOb); } //for W3 ..peak
   string sToolTag=GetLocalString(oMy,"sProfHarvestTool");
   string sToolRes=GetLocalString(oMy,"sProfHarvestToolRes");
   string sToolLoc=GetLocalString(oMy,"sProfHarvestToolLoc");
   string sToolFrom=GetLocalString(oMy,"sProfHarvestToolFrom");
   int nToolCost=GetLocalInt(oMy,"nProfHarvestToolCost");
   string sHarvMeth=GetLocalString(oMy,"sProfHarvestMethod");
   string sHarvRes=GetLocalString(oMy,"sProfHarvestRes");
   string sDeliverLoc=GetLocalString(oMy,"sProfHarvestDeliverLoc");
   string sHarvTag=GetLocalString(oMy,"sProfHarvestTag");
   int nShiftLen=GetLocalInt(oMy,"nProfHarvestShift");
   int nWage=GetLocalInt(oMy,"nProfHarvestWage");
   int nShiftCount=GetLocalInt(oNPC,"nProfHarvestShiftCount");
   int nStack=GetLocalInt(oMy,"nProfHarvestStack");
   int nWear=GetLocalInt(oMy,"nProfHarvestWear");
   int nCurrency=GetLocalInt(oNPC,"nCurrency");
   object oItem;
   if (nStack<1) nStack=1;
   SetLocalInt(oNPC,"bGNBProfessions",TRUE); // professions controls
   if (GetStringLength(sHarvLoc)>0&&GetStringLength(sHarvRes)>0&&nShiftLen>=nShiftCount)
   { // some critical information exists
     SetLocalInt(oNPC,"nGNBProfProc",1);
     SetLocalInt(oNPC,"nGNBProfFail",nSpeed+16); //finetune @@@
     switch(nState)
     {
       case 0: { // choose head to location or get tool
         if (GetStringLength(sToolTag)>0)
         { // should have a tool
           oOb=GetItemPossessedBy(oNPC,sToolTag);
           if (GetIsObjectValid(oOb))
           { // has tool
             SetLocalInt(oNPC,"nProfState",1); // go to work
           } // has tool
           else
           { // go get tool
             SetLocalInt(oNPC,"nProfState",7); // go get tool
           } // go get tool
         } // should have a tool
         else
         { // no tool
           SetLocalInt(oNPC,"nProfState",1); // go to work
         } // no tool
         break;
       } // choose head to location or get tool
       case 1: { // head to work location
         oOb=GetNearestObjectByTag(sHarvLoc,oNPC,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sHarvLoc);
         if (GetIsObjectValid(oOb))
         { // location exists
           if (GetArea(oOb)!=GetArea(oNPC)||GetDistanceBetween(oNPC,oOb)>2.5)
           { // move to destination
             fnMoveToDestination(oNPC,oOb);
           } // move to destination
           else
           { // arrived
             if (GetStringLength(sHarvPlc)>0) { SetLocalInt(oNPC,"nProfState",2); }
             else { SetLocalInt(oNPC,"nProfState",3); }
           } // arrived
         } // location exists
         else
         { // error
           AssignCommand(oNPC,SpeakString("ERROR: I am missing my sProfHarvestLoc variable or the destination does not exist!"));
           SetLocalInt(oNPC,"nProfState",9);
         } // error
         break;
       } // head to work location
       case 2: { // move to placeable or location
         oOb=GetNearestObjectByTag(sHarvPlc,oNPC,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sHarvPlc);
         if (GetIsObjectValid(oOb))
         { // placeable exists
           if (GetArea(oOb)!=GetArea(oNPC)||GetDistanceBetween(oNPC,oOb)>2.5)
           { // move to destination
             nN=fnMoveToDestination(oNPC,oOb);
           } // move to destination
           if(nN=1)
           { // arrived
             SetLocalInt(oNPC,"nProfState",3);
             break;
           } // arrived
           else if(nN=-1)
           { // failed
             fnDebug("Failed to arrive",TRUE);
             SetLocalInt(oNPC,"nProfState",9);
             break;
           } // failed
         } // placeable exists
         else
           { // no place
             SetLocalInt(oNPC,"nProfState",3);
           } // no place
         break;
       } // move to placeable or location
       case 3: { // do harvest method
         oOb=OBJECT_INVALID; //peak
         if (GetStringLength(sHarvMeth)>0)
         { // harvest method exists
           DeleteLocalInt(oNPC,"bPROFActDone");
           SetLocalInt(oNPC,"nProfState",4);
           if (GetStringLength(sToolTag)>0) { oOb=GetItemPossessedBy(oNPC,sToolTag); }
           fnPROFActionMethod(sHarvMeth,oOb,oNPC,sHarvPlc1,sHarvPlc2,sHarvPlc3); //peak
         } // harvest method exists
         else
         { // no harvest method
           AssignCommand(oNPC,SpeakString("ERROR: The value sProfHarvestMethod is not defined!  A method is needed."));
           SetLocalInt(oNPC,"nProfState",9);
         } // no harvest method
         break;
       } // do harvest method
       case 4: { // limbo waiting state
         if (GetLocalInt(oNPC,"bPROFActDone")) { SetLocalInt(oNPC,"nProfState",5); }
         break;
       } // limbo waiting state
       case 5: { // produce resource and wear on tool
         oOb=CreateItemOnObject(sHarvRes,oNPC,nStack,sHarvTag);
         fnDebug("Tag of created object: "+GetTag(oOb),TRUE);
         if (GetIsObjectValid(oOb)==TRUE)
         { // valid
           if (nWear>0)
           { // wearing of tools is possible
             oOb=GetItemPossessedBy(oNPC,sToolTag);
             if (GetIsObjectValid(oOb))
             { // tool exists
               nN=GetLocalInt(oOb,"nWearing");
               nN=nN+nWear;
               SetLocalInt(oOb,"nWearing",nN);
               if (nN>99)
               { // tool breaks
                 AssignCommand(oNPC,SpeakString("My "+GetName(oOb)+" has broken."));
                 DestroyObject(oOb);
               } // tool breaks
             } // tool exists
           } // wearing of tools is possible
           SetLocalInt(oNPC,"nProfState",6);
           break;
         } // valid
         else
         { // error
           AssignCommand(oNPC,SpeakString("ERROR: The resref stored in sProfHarvestRes does not actually correspond to an item!"));
           SetLocalInt(oNPC,"nProfState",9);
         } // error
         break;
       } // produce resource and wear on tool
       case 6: { // deliver resources
         oOb=GetNearestObjectByTag(sDeliverLoc,oNPC,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sDeliverLoc);
         if (GetIsObjectValid(oOb))
         { // deliver location exists
           if (GetArea(oOb)!=GetArea(oNPC)||GetDistanceBetween(oOb,oNPC)>2.5)
           { // move to deliver location
             fnMoveToDestination(oNPC,oOb);
           } // move to deliver location
           else
           { // arrived
             AssignCommand(oNPC,SetFacingPoint(GetPosition(oOb)));
             if ((GetObjectType(oOb)==OBJECT_TYPE_PLACEABLE&&GetHasInventory(oOb)==TRUE)||GetObjectType(oOb)==OBJECT_TYPE_STORE)
             { // container or store
               oItem=GetItemPossessedBy(oNPC,sHarvTag);
               if (GetIsObjectValid(oItem))
               { // items to place
                 AssignCommand(oNPC,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0,3.0));
                 sS=GetResRef(oItem);
                 nN=GetItemStackSize(oItem);
                 DestroyObject(oItem);
                 CreateItemOnObject(sS,oOb,nN);
               } // items to place
               else
               { // no more items
                 nShiftCount++;
                 SetLocalInt(oNPC,"nProfHarvestShiftCount",nShiftCount);
                 if (nShiftCount==nShiftLen) { SetLocalInt(oNPC,"nProfState",9); }
                 else { DeleteLocalInt(oNPC,"nProfState"); }
               } // no more items
             } // container or store
             else
             { // drop stuff
               oOb=GetItemPossessedBy(oNPC,sHarvTag);
               if (GetIsObjectValid(oOb))
               { // drop it
                 AssignCommand(oNPC,ActionPutDownItem(oOb));
               } // drop it
               else
               { // no more items
                 nShiftCount++;
                 SetLocalInt(oNPC,"nProfHarvestShiftCount",nShiftCount);
                 if (nShiftCount==nShiftLen) { SetLocalInt(oNPC,"nProfState",9); }
                 else { DeleteLocalInt(oNPC,"nProfState"); }
               } // no more items
             } // drop stuff
           } // arrived
         } // deliver location exists
         else
         { // drop the stuff where I stand
           oOb=GetItemPossessedBy(oNPC,sHarvTag);
           if (GetIsObjectValid(oOb))
           { // drop it
             AssignCommand(oNPC,ActionPutDownItem(oOb));
           } // drop it
           else
           { // no more items
             nShiftCount++;
             SetLocalInt(oNPC,"nProfHarvestShiftCount",nShiftCount);
             if (nShiftCount==nShiftLen) { SetLocalInt(oNPC,"nProfState",9); }
             else { DeleteLocalInt(oNPC,"nProfState"); }
           } // no more items
         } // drop the stuff where I stand
         break;
       } // deliver ActionJumpToObjects
       case 7: { // go to tool purchase location
         oOb=GetNearestObjectByTag(sToolLoc,oNPC,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sToolLoc);
         if (GetIsObjectValid(oOb))
         { // tool location exists
           if (GetArea(oOb)!=GetArea(oNPC)||GetDistanceBetween(oNPC,oOb)>2.5)
           { // move
             fnMoveToDestination(oNPC,oOb);
           } // move
           else
           { // arrived
             SetLocalInt(oNPC,"nProfState",8);
           } // arrived
         } // tool location exists
         else
         { // error
           AssignCommand(oNPC,SpeakString("ERROR: The value in sProfHarvestToolLoc does not produce an actual destination!"));
           SetLocalInt(oNPC,"nProfState",9);
         } // error
         break;
       } // go to tool purchase location
       case 8: { // purchase tool
         oOb=GetNearestObjectByTag(sToolFrom,oNPC,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sToolFrom);
         if (GetIsObjectValid(oOb))
         { // tool purchase from valid
           if (GetArea(oNPC)!=GetArea(oOb)||GetDistanceBetween(oNPC,oOb)>2.5)
           { // move
             fnMoveToDestination(oNPC,oOb);
           } // move
           else
           { // arrived
             if (nToolCost>0&&nToolCost<=GetWealth(oNPC,nCurrency))
             { // have the gold to buy the tool
               if (GetObjectType(oOb)==OBJECT_TYPE_STORE)
               { // store
                 nN=GetStoreGold(oOb);
                 nN=nN+nToolCost;
                 SetStoreGold(oOb,nN);
                 TakeCoins(oNPC,nToolCost,"ANY",nCurrency,TRUE);
                 oOb=CreateItemOnObject(sToolRes,oNPC);
                 SetLocalInt(oNPC,"nProfState",1);
               } // store
               else if (GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
               { // creature
                 AssignCommand(oOb,TakeCoins(oNPC,nToolCost,"ANY",nCurrency));
                 AssignCommand(oNPC,SpeakString("I'd like to make a purchase."));
                 DelayCommand(3.0,AssignCommand(oOb,SpeakString("Thank ye for the purchase.")));
                 oOb=CreateItemOnObject(sToolRes,oNPC);
                 SetLocalInt(oNPC,"nProfState",1);
               } // creature
               else
               { // instant create
                 TakeCoins(oNPC,nToolCost,"ANY",nCurrency,TRUE);
                 oOb=CreateItemOnObject(sToolRes,oNPC);
                 SetLocalInt(oNPC,"nProfState",1);
               } // instant create
             } // have the gold to buy the tool
             else if (nToolCost==0)
             { // free tool
               oOb=CreateItemOnObject(sToolRes,oNPC);
               SetLocalInt(oNPC,"nProfState",1);
             } // free tool
             else
             { // cannot afford the tool
               AssignCommand(oNPC,SpeakString("I don't have enough gold to buy a tool!"));
               SetLocalInt(oNPC,"nProfState",9);
             } // cannot afford the tool
           } // arrived
         } // tool purchase from valid
         else
         { // error
           AssignCommand(oNPC,SpeakString("ERROR: The value of sProfHarvestToolFrom does not actually correspond to a store or creature!"));
           SetLocalInt(oNPC,"nProfState",9);
         } // error
         break;
       } // purchase tool
       case 9: { // end of shift
         if (nWage>0&&(GetItemPossessedBy(oNPC,sToolTag)!=OBJECT_INVALID)||(GetStringLength(sToolTag)==0)) // modPeak for no tool required
         { // pay wage
           GiveCoins(oNPC,nWage,"ANY",nCurrency);
         } // pay wage
         nShiftCount=nShiftLen+10;
         SetLocalInt(oNPC,"nProfHarvestShiftCount",nShiftCount);
         break;
       } // end of shift
       default: { DeleteLocalInt(oNPC,"nProfState"); break; }
     }
     DelayCommand(IntToFloat(nSpeed),ExecuteScript("npcact_p_harvest",oNPC));
     SetLocalInt(oNPC,"nGNBProfFail",nSpeed+3);
     SetLocalInt(oNPC,"nGNBProfProc",1);
   } // some critical information exists
   else
   { // end
     DeleteLocalInt(oNPC,"bGNBProfessions");
     DeleteLocalInt(oNPC,"nProfHarvestShiftCount");
     DeleteLocalInt(oNPC,"nProfState");
   } // end
}
//////////////////////////////////////////////////////////////////////// MAIN

////////////////////////////////
// FUNCTIONS
////////////////////////////////
