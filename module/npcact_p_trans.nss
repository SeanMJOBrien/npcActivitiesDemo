///////////////////////////////////////////////////////////////////////////////
// npcact_p_trans - NPC ACTIVITIES 6.0 Professions - Transporter
// By Deva Bryson Winblood.  09/12/2004
// Last Modified By: Peter D. Busby 7/01/2010 to test end after full cycle
// modified for Virtual Tag peak 5/10
// modified for variables on POST_<VirtTag> - Peak 6/30/10
//-----------------------------------------------------------------------------
// This profession carries goods from one location to another and back
///////////////////////////////////////////////////////////////////////////////
//
// Configuration by peak 042709
//
/*
TRANSPORTER(npcact_p_trans): is a profession that causes an NPC to move items found
on the ground within 8 meters of point A and move them to point B and vice versa.
Each item will only be transported one time.  The profession can be setup so that a
pack animal or similar following NPC can be created to handle this situation.

bInheritVPostVariables set to 1 on NPC causes following to come from
    POST_<Virtual Tag> instead - Peak 6/30/10

sProfTXLocation1 – This is the waypoint tag for transport area 1
sProfTXLocation2 – This is the waypoint tag for transport area 2
sProfTXItemRestrict# - This allows you to give tags of items this transporter will not carry
bProfTXHasPackAnimal – If set to TRUE then the NPC will be followed by a pack animal.
sProfTXGetPackAnimal – Location to get Pack Animal at
sProfTXReturnPackAnimal – Location to return Pack Animal
sProfTXPayForPackAnimal – Whom to pay for Pack Animal… if NA then no one… gold just spent.
nProfTXPackAnimalCost – Cost to rent the pack animal/ or house the pack animal
sProfTXPackAnimalRes – ResRef of pack animal type
sProfTXSayGetPackAnimal – What the NPC should say when getting the pack animal
sProfTXSayReturnPackAnimal – What the NPC should say when returning the pack animal
sProfTXSayNeedPackAnimal – What the NPC should say when they need a pack animal
sProfTXSayDeliver – What the NPC should say when dropping off a delivery
sProfTXSayTransport – What the NPC should say when leaving to take a delivery
nProfTXWage – How much gold to pay the NPC at the end of the deliveries
nProfTXWagePerDelivery – What the NPC should be paid each time a delivery is made
nProfTXNumDeliveries – How many deliveries should be completed in a shift

This NPC type can be used to carry raw resources dropped at a location to another
location such as a processing plant.  For example:  You could have an NPC carry raw
iron ore from an ore pile location and take it to the smelter area.  The smelter area
ore could be picked up by a converter who works and converts the resource into steel.
The steel could be placed in a different pile or the same pile.  If it is placed in the
same pile then you’d want the transporter to have a restriction for steel so, he did not
inadvertently carry the steel out to the ore pile.   You could use a second transporter
if you need the steel to be carried elsewhere.

*/
//
#include "npcact_h_prof"
#include "npcact_h_money"
/////////////////////////////
// PROTOTYPES
/////////////////////////////


// PURPOSE: check to see if oMe requires a pack animal.  If it does require
// a pack animal and it does not have one it will return 0.  If it has one it
// will return 1.  If it returns -1 then that means it does not need one.
int fnProfCheckForPackAnimal(object oMy, object oMe=OBJECT_SELF);

// PURPOSE: calls the follow the master function for the pack animal
void fnFollowMaster(object oMaster);

// PURPOSE: To check for droppable items marked as transported and drop them
// it returns TRUE if an item was dropped
int fnProfDropItems(object oMe=OBJECT_SELF);

// PURPOSE: To pickup items for transport
int fnProfPickupItems(object oMe=OBJECT_SELF);

///////////////////////////////////////////////////////////////////////// MAIN
void main()
{
   object oMe=OBJECT_SELF;
   object oMy=oMe;
   if(GetLocalInt(oMe,"bInheritVPostVariables")) oMy=GetObjectByTag("POST_"+fnGetNPCTag(oMe));
   object oOb;
   string sS;
   int nN, bLatch;
   int nState=GetLocalInt(oMe,"nProfState");
   fnDebugInt("ProfTransState ",nState);
   int nSpeed=GetLocalInt(oMe,"nGNBStateSpeed");
   if(!nSpeed) nSpeed=GetLocalInt(GetModule(),"nGNBStateSpeed"); // 6/06/10 Peak
   if (nSpeed<1) nSpeed=6;
   int nCurrency=GetLocalInt(oMe,"nCurrency");
   if (GetObjectType(oMe)==OBJECT_TYPE_CREATURE)
   { // is a creature
     SetLocalInt(oMe,"bGNBProfessions",TRUE);
     SetLocalInt(oMe,"nGNBProfFail",nSpeed+3);
     SetLocalInt(oMe,"nGNBProfProc",1);
     switch(nState)
     { // main transporter state
       case 0: { // check for pack animal
         nN=fnProfCheckForPackAnimal(oMy);
         if (nN==1||nN==-1) { SetLocalInt(oMe,"nProfState",4); }
         else {
          sS=GetLocalString(oMy,"sProfTXSayNeedPackAnimal");
          if (GetStringLength(sS)>0) AssignCommand(oMe,SpeakString(sS));
          SetLocalInt(oMe,"nProfState",1);
         }
         break;
       } // check for pack animal
       case 1: { // Go to get pack animal location
         sS=GetLocalString(oMy,"sProfTXGetPackAnimal");
         if (GetStringLength(sS)>0)
         { // location info entered
           oOb=GetNearestObjectByTag(sS,oMe,1);
           if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
           if (GetIsObjectValid(oOb))
           { // valid destination
             if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
             { // move to destination
               fnMoveToDestination(oMe,oOb);
             } // move to destination
             else { SetLocalInt(oMe,"nProfState",2); } // corPeak
           } // valid destination
           else { // error
             AssignCommand(oMe,SpeakString("ERROR: I cannot find destination '"+sS+"' in variable sProfTXGetPackAnimal!"));
             SetLocalInt(oMe,"nProfState",2);
           } // error
         } // location info entered
         else { SetLocalInt(oMe,"nProfState",2); }
         break;
       } // go to get pack animal location
       case 2: { // pay for pack animal
         if (GetLocalInt(oMy,"nProfTXPackAnimalCost")>0)
         { // Pack Animal costs
           nN=GetLocalInt(oMy,"nProfTXPackAnimalCost");
           if (GetWealth(oMe,nCurrency)>=nN)
           { // have enough gold
             sS=GetLocalString(oMy,"sProfTXPayForPackAnimal");
             if (GetStringLength(sS)>0)
             { // person to pay specified
               oOb=GetNearestObjectByTag(sS,oMe,1);
               if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
               if (GetIsObjectValid(oOb))
               { // person found
                 AssignCommand(oOb,TakeCoins(oMe,nN,"ANY",nCurrency));
                 SetLocalInt(oMe,"nProfState",3);
               } // person found
               else
               { // error
                 AssignCommand(oMe,SpeakString("ERROR: The object with tag '"+sS+"' does not exist as defined on sProfTXPayForPackAnimal."));
                 SetLocalInt(oMe,"nProfState",3);
                 AssignCommand(oMe,TakeCoins(oMe,nN,"ANY",nCurrency,TRUE));
               } // error
             } // person to pay specified
             else
             { // no specific target
               AssignCommand(oMe,TakeCoins(oMe,nN,"ANY",nCurrency,TRUE));
               SetLocalInt(oMe,"nProfState",3);
             } // no specific target
           } // have enough gold
           else
           { // not enough gold
             nN=d4();
             if (nN<3) AssignCommand(oMe,SpeakString("I canna' work.  I have no gold for a pack animal."));
             else { AssignCommand(oMe,SpeakString("I need more gold for a pack animal."));   }
             SetLocalInt(oMe,"nProfState",15);
           } // not enough gold
         } // Pack animal costs
         else { SetLocalInt(oMe,"nProfState",3); }
         break;
       } // pay for pack animal
       case 3: { // create pack animal
         sS=GetLocalString(oMy,"sProfTXPackAnimalRes");
         if (sS!="")
         { // res ref exists
           oOb=CreateObject(OBJECT_TYPE_CREATURE,sS,GetLocation(oMe));
           if (GetIsObjectValid(oOb))
           { // pack animal created
             SetLocalObject(oMe,"oProfTXPackAnimal",oOb);
             AssignCommand(oOb,fnFollowMaster(oMe));
             SetLocalInt(oMe,"nProfState",4);
             sS=GetLocalString(oMy,"sProfTXSayGetPackAnimal");
             if (GetStringLength(sS)>0) AssignCommand(oMe,SpeakString(sS));
           } // pack animal created
           else
           { // error
             AssignCommand(oMe,SpeakString("ERROR: Pack animal was not created with ResRef '"+sS+"' on variable sProfTXPackAnimalRes."));
             SetLocalInt(oMe,"nProfState",15);
           } // error
         } // res ref exists
         else
         { // error
           AssignCommand(oMe,SpeakString("ERROR: The sProfTXPackAnimalRes variable is NOT defined.  It requires a value to create a pack animal."));
           SetLocalInt(oMe,"nProfState",15);
         } // error
         break;
       } // create pack animal
       case 4: { // go to transport location 1
         sS=GetLocalString(oMy,"sProfTXLocation1");
         if (GetStringLength(sS)>0)
         { // location specified
           oOb=GetNearestObjectByTag(sS,oMe,1);
           if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
           if (GetIsObjectValid(oOb))
           { // valid destination
             if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
             { // move
               fnMoveToDestination(oMe,oOb);
             } // move
             else
             { // arrived
               SetLocalInt(oMe,"nProfState",5);
             } // arrived
           } // valid destination
           else
           { // error
             AssignCommand(oMe,SpeakString("ERROR: I cannot find '"+sS+"' as specified in sProfTXLocation1!"));
             SetLocalInt(oMe,"nProfState",15);
           } // error
         } // location specified
         else
         { // error
           AssignCommand(oMe,SpeakString("ERROR: sProfTXLocation1 MUST be defined for the Transport profession."));
           SetLocalInt(oMe,"nProfState",15);
         } // error
         break;
       } // go to transport location 1
       case 5: { // if carrying items for transport drop them off
         bLatch=FALSE;
         nN=fnProfDropItems(oMe);
         if (nN==TRUE) bLatch=TRUE;
         if(bLatch&&!nN)
         { // items were dropped
           sS=GetLocalString(oMy,"sProfTXSayDeliver");
           if (GetStringLength(sS)>0) AssignCommand(oMe,SpeakString(sS));
           nN=GetLocalInt(oMy,"nProfTXWagePerDelivery");
           if (nN>0)
           { // award wage
             GiveCoins(oMe,nN,"ANY",nCurrency);
           } // award wage
           bLatch=FALSE;
         } // items were dropped
         if(!nN&&!bLatch) SetLocalInt(oMe,"nProfState",6);
         break;
       } // if carrying items for transport drop them off
       case 6: { // check for end of shift
         nN=GetLocalInt(oMe,"nProfTXShift");
         if (nN<GetLocalInt(oMy,"nProfTXNumDeliveries"))
         { // still more to do
           SetLocalInt(oMe,"nProfState",7);
           SetLocalInt(oMe,"nProfTXShift",nN+1);
         } // still more to do
         else { if (fnProfCheckForPackAnimal(oMy)==1)
                   SetLocalInt(oMe,"nProfState",13);
                else { SetLocalInt(oMe,"nProfState",15); }
         }
         break;
       } // check for end of shift
       case 7: { // check for pack animal
         nN=fnProfCheckForPackAnimal(oMy);
         if (nN==1||nN==-1) { SetLocalInt(oMe,"nProfState",8); }
         else {
          sS=GetLocalString(oMy,"sProfTXSayNeedPackAnimal");
          if (GetStringLength(sS)>0) AssignCommand(oMe,SpeakString(sS));
          SetLocalInt(oMe,"nProfState",1);
         }
         break;
       } // check for pack animal
       case 8: { // pickup items for transport
         fnProfPickupItems(oMe);
         if (GetLocalInt(oMe,"bPickup"))
         { SetLocalInt(oMe,"nProfState",16); }
         else { SetLocalInt(oMe,"nProfState",9); }
         break;
       } // pickup items for transport
       case 9: { // go to transport location 2
         sS=GetLocalString(oMy,"sProfTXLocation2");
         if (GetStringLength(sS)>0)
         { // location specified
           oOb=GetNearestObjectByTag(sS,oMe,1);
           if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
           if (GetIsObjectValid(oOb))
           { // valid destination
             if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
             { // move
               fnMoveToDestination(oMe,oOb);
             } // move
             else
             { // arrived
               SetLocalInt(oMe,"nProfState",10);
             } // arrived
           } // valid destination
           else
           { // error
             AssignCommand(oMe,SpeakString("ERROR: I cannot find '"+sS+"' as specified in sProfTXLocation2!"));
             SetLocalInt(oMe,"nProfState",15);
           } // error
         } // location specified
         else
         { // error
           AssignCommand(oMe,SpeakString("ERROR: sProfTXLocation2 MUST be defined for the Transport profession."));
           SetLocalInt(oMe,"nProfState",15);
         } // erro
         break;
       } // go to transport location 2
       case 10: { // if carrying items for transport drop them off
         bLatch=FALSE;
         nN=fnProfDropItems(oMe);
         if (nN==TRUE) bLatch=TRUE;
         if(bLatch&&!nN)
         { // items were dropped
           sS=GetLocalString(oMy,"sProfTXSayDeliver");
           if (GetStringLength(sS)>0) AssignCommand(oMe,SpeakString(sS));
           nN=GetLocalInt(oMy,"nProfTXWagePerDelivery");
           if (nN>0)
           { // award wage
             GiveCoins(oMe,nN,"ANY",nCurrency);
           } // award wage
           bLatch=FALSE;
         } // items were dropped
         if(!nN&&!bLatch) SetLocalInt(oMe,"nProfState",6);
         break;
       } // if carrying items for transport drop them off
       case 11: { // check for pack animal
         nN=fnProfCheckForPackAnimal(oMy);
         if (nN==1||nN==-1) { SetLocalInt(oMe,"nProfState",12); }
         else {
          sS=GetLocalString(oMy,"sProfTXSayNeedPackAnimal");
          if (GetStringLength(sS)>0) AssignCommand(oMe,SpeakString(sS));
          SetLocalInt(oMe,"nProfState",1);
         }
         break;
       } // check for pack animal
       case 12: { // pickup items for transport
         fnProfPickupItems(oMe);
         if (GetLocalInt(oMe,"bPickup"))
         { SetLocalInt(oMe,"nProfState",17);
           fnDebug("ProfTXPickup2",TRUE); }
         else { SetLocalInt(oMe,"nProfState",4); }
         break;
       } // pickup items for transport
       case 13: { // Go to Pack animal return location
         sS=GetLocalString(oMy,"sProfTXReturnPackAnimal");
         if (GetStringLength(sS)>0)
         { // return location specified
           oOb=GetNearestObjectByTag(sS,oMe,1);
           if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
           if (GetIsObjectValid(oOb))
           { // valid destination
             if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
             { // move
               fnMoveToDestination(oMe,oOb);
             } // move
             else
             { // arrived
               SetLocalInt(oMe,"nProfState",14);
             } // arrived
           } // valid destination
           else
           { // error
             AssignCommand(oMe,SpeakString("ERROR: I cannot find '"+sS+"' as specified in sProfTXReturnPackAnimal!"));
             SetLocalInt(oMe,"nProfState",14);
           } // error
         } // return location specified
         else { SetLocalInt(oMe,"nProfState",14); }
         break;
       } // Go to Pack Animal return location
       case 14: { // return pack animal
         sS=GetLocalString(oMy,"sProfTXSayReturnPackAnimal");
         if (GetStringLength(sS)>0) { AssignCommand(oMe,SpeakString(sS)); }
         oOb=GetLocalObject(oMe,"oProfTXPackAnimal");
         DelayCommand(3.0,DestroyObject(oOb));
         SetLocalInt(oMe,"nProfState",15);
         break;
       } // return pack animal
       case 15: { // end shift and cleanup
         DeleteLocalInt(oMe,"nProfState");
         DeleteLocalInt(oMe,"bPickup");
         DeleteLocalInt(oMe,"nProfTXShift");
         DeleteLocalObject(oMe,"oProfTXPackAnimal");
         nN=GetLocalInt(oMy,"nProfTXWage");
         if (nN>0)
         { // pay wage
           GiveGoldToCreature(oMe,nN);
           SetLocalInt(oMe,"bGNBProfessions",FALSE);
         } // pay wage
         break;
       } // end shift and cleanup
       case 16: { // wait state
         sS=GetLocalString(oMy,"sProfTXSayTransport");
         fnProfPickupItems(oMe);
         if (GetLocalInt(oMe,"bPickup")==FALSE) {
           SetLocalInt(oMe,"nProfState",9);
           if (sS!="") AssignCommand(oMe,SpeakString(sS));
         }
         break;
       } // wait state
       case 17: { // wait state
         sS=GetLocalString(oMy,"sProfTXSayTransport");
         fnProfPickupItems(oMe);
         if (GetLocalInt(oMe,"bPickup")==FALSE) {
           SetLocalInt(oMe,"nProfState",4);
           if (sS!="") AssignCommand(oMe,SpeakString(sS));
         }
         break;
       } // wait state
       default: { SetLocalInt(oMe,"nProfState",0); break; }
     } // main transporter state
     if (nState!=15) { DelayCommand(IntToFloat(nSpeed),ExecuteScript("npcact_p_trans",oMe)); }
   } // is a creature
}
///////////////////////////////////////////////////////////////////////// MAIN

/////////////////////////////
// FUNCTIONS
/////////////////////////////

void fnPickItUp(object oItem)
{ // PURPOSE: pickup the item
  object oMe=OBJECT_SELF;
  int nN;
  if (GetItemPossessor(oItem)!=oMe&&GetObjectType(GetItemPossessor(oItem))!=OBJECT_TYPE_CREATURE)
  { // pick it up
    AssignCommand(oMe,ActionPickUpItem(oItem));
    SetLocalInt(oItem,"bTransported"+fnGetNPCTag(oMe)+GetName(oMe),TRUE);
  } // pick it up
/*  else
  { // picked it up
    SetLocalInt(oMe,"bPickup",FALSE);
  } // picked it up */
} // fnPickItUp()

int fnProfItemRestriction(object oItem)
{ // PURPOSE: return TRUE if this item is on the restriction list
  int bRet=FALSE;
  string sS;
  int nC=1;
  string sTag=GetTag(oItem);
  sS=GetLocalString(OBJECT_SELF,"sProfTXItemRestrict1");
  while(sS!=""&&!bRet)
  { // check for restrictions
    if (sTag==sS) bRet=TRUE;
    nC++;
    sS=GetLocalString(OBJECT_SELF,"sProfTXItemRestrict"+IntToString(nC));
  } // check for restrictions
  return bRet;
} // fnProfItemRestriction()

int fnProfPickupItems(object oMe=OBJECT_SELF)
{ // PURPOSE: To pickup items
  SetLocalInt(oMe,"nGNBStateSpeed",4);
  SetLocalInt(oMe,"bPickup",FALSE);
  int nC=1;
  int bB=FALSE;
  object oItem=GetNearestObject(OBJECT_TYPE_ITEM,oMe,1);
  while (oItem!=OBJECT_INVALID&&GetDistanceBetween(oMe,oItem)<6.0)
  { // found a pile of items
    if (GetLocalInt(oItem,"bTransported"+fnGetNPCTag(oMe)+GetName(oMe))!=TRUE) //mod for VT peak 5/10
    { // not an item I (by VT) have transported before
      if (fnProfItemRestriction(oItem)!=TRUE)
      { // not a restricted item
        SetLocalInt(oMe,"bPickup",TRUE);
        bB=TRUE;
        DelayCommand(2.0,fnPickItUp(oItem)); // a TMI preventer - pk
      } // not a restricted item
    } // not an item I have transported before
    nC++;
    oItem=GetNearestObject(OBJECT_TYPE_ITEM,oMe,nC);
  } // found a pile of items
  return bB;
} // fnProfPickupItems()

void fnDropIt(object oItem)
{ // PURPOSE: make sure the NPC drops the item
  if (GetItemPossessor(oItem)==OBJECT_SELF)
  { // drop it
    AssignCommand(OBJECT_SELF,ActionPutDownItem(oItem));
    DelayCommand(2.0,fnDropIt(oItem));
  } // drop it
} // fnDropIt()

int fnProfDropItems(object oMe=OBJECT_SELF)
{ // PURPOSE: Drop items
  SetLocalInt(oMe,"nGNBStateSpeed",4);
  int bRet=FALSE;
  object oItem=GetFirstItemInInventory(oMe);
  while(oItem!=OBJECT_INVALID)
  { // look at inventory
    if (GetLocalInt(oItem,"bTransported"+fnGetNPCTag(oMe)+GetName(oMe))==TRUE)//mod for VT peak 5/10
    { // drop this item
      DelayCommand(1.0,fnDropIt(oItem));
      bRet=TRUE;
    } // drop this item
    oItem=GetNextItemInInventory(oMe);
  } // look at inventory
  return bRet;
} // fnProfDropItems()

void fnFollowMaster(object oMaster)
{ // PURPOSE: Pack animal follow
  object oMe=OBJECT_SELF;
  SetAILevel(oMe,AI_LEVEL_NORMAL);
  if (GetIsObjectValid(oMaster))
  { // master is valid
    if (GetArea(oMe)!=GetArea(oMaster))
    { // TELEPORT
      AssignCommand(oMe,JumpToObject(oMaster));
    } // TELEPORT
    else if (GetDistanceBetween(oMe,oMaster)>3.0)
    { // move
      ActionMoveToObject(oMaster,TRUE,2.0);
    } // move
    DelayCommand(5.0,fnFollowMaster(oMaster));
  } // master is valid
  else { DestroyObject(oMe); }
} // fnFollowMaster()

int fnProfCheckForPackAnimal(object oMy, object oMe=OBJECT_SELF)
{ // PURPOSE: Check for pack animal needs
  // 0 = need one, 1 = have one, -1 = do not need one
  int nRet=-1;
  if(GetLocalInt(oMy,"bProfTXHasPackAnimal")==TRUE)
  { // requires pack animal
    if (GetLocalObject(oMe,"oProfTXPackAnimal")!=OBJECT_INVALID) nRet=1;
    else { nRet=0; }
  } // requires pack animal
  return nRet;
} // fnProfCheckForPackAnimal()
