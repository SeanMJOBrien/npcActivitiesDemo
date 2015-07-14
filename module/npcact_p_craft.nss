////////////////////////////////////////////////////////////////////////////////
// npcact_p_craft - NPC ACTIVITIES 6.0 Professions - Craftsman
// By Deva Bryson Winblood.  09/16/2004
// Last Modified By: Peak (Peter D Busby)  06/18/10
// modified for W1, W2, W3 Peak 6/24/10
////////////////////////////////////////////////////////////////////////////////
#include "npcact_h_prof"
#include "npcact_h_time"
#include "npcact_h_money"
///////////////////////////////
// PROTOTYPES
///////////////////////////////

// FILE: npcact_p_craft               FUNCTION: fnChooseRecipe()
// This function will look at the recipes for this NPC and will return a
// a number 1 or higher representing the recipe number if it is something
// the NPC can currently craft based on resources they are carrying, and
// other conditions of the recipe.  If it returns zero then no recipe can
// currently be crafted.  nPos is an integer indicating the current position
// of the recipe and should not be messed with by the scripter.  Also, when
// this function is called it sets a variable bProfCraftRecipeSearch to TRUE
// when it is completed it sets it to FALSE.  The recipe chosen is returned
// in the local integer nProfCraftRecipe.
void fnChooseRecipe(object oMe=OBJECT_SELF,int nSelect=0);

// FILE: npcact_p_craft               FUNCTION: fnProcessRecipe()
// This function will consume the items that were used, handle time issues,
// do additional wear on the tool, etc.
void fnProcessRecipe(object oMe,string sRecipe);

////////////////////////////////////////////////////////////////////// MAIN
void main()
{
   object oMe=OBJECT_SELF;
   object oOb;
   object oItem;
   string sS;
   int nN;
   int nSpeed=GetLocalInt(oMe,"nGNBStateSpeed");
   if(!nSpeed) nSpeed=GetLocalInt(GetModule(),"nGNBStateSpeed"); // 6/06/10 Peak
   if (nSpeed<1) nSpeed=6;
   int nState=GetLocalInt(oMe,"nProfState");
   fnDebugInt("ProfCraftState ",nState);
   int nCurrency=GetLocalInt(oMe,"nCurrency");
   SetLocalInt(oMe,"bGNBProfessions",TRUE);
   SetLocalInt(oMe,"nGNBProfFail",nSpeed+2);
   SetLocalInt(oMe,"nGNBProfProc",1);
   fnDebugInt("NProfCraftState: ",nState);
   switch(nState)
   { // Main Switch-------------------------------------------
     case 0: { // initialize and check for critical errors
       nN=fnGetAbsoluteHour();
       SetLocalInt(oMe,"nProfCraftShiftStart",nN);
       sS="";
       if(GetStringLength(GetLocalString(oMe,"sProfCraftResLoc"))<1) sS="A location to obtain raw resources from is required in sProfCraftResLoc!";
       else if(GetStringLength(GetLocalString(oMe,"sProfCraftDeliverLoc"))<1) sS="A location to place the crafted items is required in sProfCraftDeliverLoc!";
       else if(GetStringLength(GetLocalString(oMe,"sProfCraftWorkLoc"))<1) sS="A location to do the crafting is required in sProfCraftWorkLoc!";
       if (GetStringLength(sS)>0)
       { // error
         AssignCommand(oMe,SpeakString("ERROR: "+sS));
         SetLocalInt(oMe,"nProfState",14);
       } // error
       else
       { // no error
         SetLocalInt(oMe,"nProfState",1);
       } // no error
       break;
     } // initialize and check for critical errors
     case 1: { // check for tool and check shift end time
       nN=fnGetAbsoluteHour()-GetLocalInt(oMe,"nProfCraftShiftStart");
       if (nN>=GetLocalInt(oMe,"nProfCraftShift"))
       { // end of shift
         SetLocalInt(oMe,"nProfState",14);
       } // end of shift
       else
       { // check for tool requirements
         if (GetLocalInt(oMe,"bProfCraftTool")!=0)
         { // tool is required
           sS=GetLocalString(oMe,"sProfCraftToolTag");
           if (GetStringLength(sS)>0)
           { // valid string
             oOb=GetItemPossessedBy(oMe,sS);
             if (GetIsObjectValid(oOb))
             { // has tool
               SetLocalInt(oMe,"nProfState",4);
             } // has tool
             else
             { // needs tool
               SetLocalInt(oMe,"nProfState",2);
             } // needs tool
           } // valid string
           else
           { // error
             AssignCommand(oMe,SpeakString("ERROR: The tag of the tool item needs to be stored in sProfCraftToolTag!"));
             SetLocalInt(oMe,"nProfState",14);
           } // error
         } // tool is required
         else
         { // no tool is required
           SetLocalInt(oMe,"nProfState",4);
         } // no tool is required
       } // check for tool requirements
       break;
     } // check for tool and check shift end time
     case 2: { // go to tool location
       sS=GetLocalString(oMe,"sProfCraftToolLoc");
       oOb=GetNearestObjectByTag(sS,oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
       if (GetIsObjectValid(oOb))
       { // tool location found
         if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
         { // move
           fnMoveToDestination(oMe,oOb);
         } // move
         else
         { // arrived
           SetLocalInt(oMe,"nProfState",3);
         } // arrived
       } // tool location found
       else
       { // error
         AssignCommand(oMe,SpeakString("ERROR: The location specified in sProfCraftToolLoc does not exist!"));
         SetLocalInt(oMe,"nProfState",14);
       } // error
       break;
     } // go to tool location
     case 3: { // purchase tool
       sS=GetLocalString(oMe,"sProfCraftToolFrom");
       oOb=GetNearestObjectByTag(sS,oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
       if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
       { // valid
         if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
         { // move
           fnMoveToDestination(oMe,oOb);
         } // move
         else
         { // near to tool person
           nN=GetLocalInt(oMe,"nProfCraftToolCost");
           if (GetWealth(oMe,nCurrency)>=nN)
           { // have enough gold
             AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
             sS=GetLocalString(oMe,"sProfCraftSayTool");
             if (GetStringLength(sS)>0) AssignCommand(oMe,SpeakString(sS));
             AssignCommand(oOb,TakeCoins(oMe,nN,"ANY",nCurrency));
             sS=GetLocalString(oMe,"sProfCraftSayMerch");
             if (GetStringLength(sS)>0) DelayCommand(3.0,AssignCommand(oOb,SpeakString(sS)));
             sS=GetLocalString(oMe,"sProfCraftToolRes");
             oItem=CreateItemOnObject(sS,oMe);
             if (GetIsObjectValid(oItem))
             { // tool was created
               sS=GetLocalString(oMe,"sProfCraftToolTag");
               if (sS==GetTag(oItem))
               { // tags match
                 SetLocalInt(oMe,"nProfState",4);
               } // tags match
               else
               { // error
                 AssignCommand(oMe,SpeakString("ERROR: The tag of the created tool '"+GetTag(oItem)+"' does not match tag '"+sS+"' stored on sProfCraftToolTag!"));
                 SetLocalInt(oMe,"nProfState",14);
                 DestroyObject(oItem);
               } // error
             } // tool was created
             else
             { // error
               AssignCommand(oMe,SpeakString("ERROR: The ResRef '"+sS+"' defined on sProfCraftToolRes did not produce and item!"));
               SetLocalInt(oMe,"nProfState",14);
             } // error
           } // have enough gold
           else
           { // not enough gold
             AssignCommand(oMe,SpeakString("I can not afford a tool now."));
             SetLocalInt(oMe,"nProfState",14);
           } // not enough gold
         } // near to tool person
       } // valid
       else
       { // error
         AssignCommand(oMe,SpeakString("ERROR: The person specified in sProfCraftToolFrom either does not exist or is not a creature!"));
         SetLocalInt(oMe,"nProfState",14);
       } // error
       break;
     } // purchase tool
     case 4: { // decide on recipe
       SetLocalInt(oMe,"bProfCraftRecipeSearch",TRUE);
       SetLocalInt(oMe,"nProfState",15);
       fnChooseRecipe();
       break;
     } // decide on recipe
     case 5: { // go to resource location
       sS=GetLocalString(oMe,"sProfCraftResLoc");
       oOb=GetNearestObjectByTag(sS,oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
       if (GetIsObjectValid(oOb))
       { // resource location exists
         if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
         { // move
           fnMoveToDestination(oMe,oOb);
         } // move
         else
         { // arrived
           SetLocalInt(oMe,"nProfState",6);
         } // arrived
       } // resource location exists
       else
       { // error
         AssignCommand(oMe,SpeakString("ERROR: The location '"+sS+"' defined in sProfCraftResLoc does not exist!"));
         SetLocalInt(oMe,"nProfState",14);
       } // error
       break;
     } // go to resource location
     case 6: { // pickup resources
       int nLatch=FALSE;
       SetLocalInt(oMe,"nGNBStateSpeed",6);
       sS=GetLocalString(oMe,"sProfCraftResLoc");
       oOb=GetNearestObjectByTag(sS,oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
       nN=GetObjectType(oOb);
       if (nN==OBJECT_TYPE_STORE||nN==OBJECT_TYPE_CREATURE||GetHasInventory(oOb))
       { // container
         AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
         AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0,3.0));
         AssignCommand(oOb,ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN,1.0,3.0));
         oItem=GetFirstItemInInventory(oOb);
         while(oItem!=OBJECT_INVALID)
         { // traverse inventory
           CreateItemOnObject(GetResRef(oItem),oMe,GetItemStackSize(oItem));
           DelayCommand(1.0,DestroyObject(oItem));
           nLatch=TRUE;
           oItem=GetNextItemInInventory(oOb);
         } // traverse inventory
         SetLocalInt(oMe,"nProfState",1);
       } // container
       else
       { // not a container
         oItem=GetNearestObject(OBJECT_TYPE_ITEM,oOb,1);
         if (oItem!=OBJECT_INVALID&&GetDistanceBetween(oOb,oItem)<8.0)
         { // valid object
           if (GetDistanceBetween(oMe,oItem)>2.0) AssignCommand(oMe,ActionMoveToObject(oItem));
           AssignCommand(oMe,ActionPickUpItem(oItem));
           nLatch=TRUE;
         } // valid object
         else
         { SetLocalInt(oMe,"nProfState",1); }
       } // not a container
       if(nLatch&&GetLocalInt(oMe,"nProfCraftSayInventory"))
       { // reveal inventory
         string sSay="";
         oOb=GetFirstItemInInventory(oMe);
         while(oOb!=OBJECT_INVALID)
         { // go through inventory
           sSay=sSay+" "+GetName(oOb);
           oOb=GetNextItemInInventory(oMe);
         } // go through inventory
         if(sSay!="")
           sSay="I have"+sSay+".";
         AssignCommand(oMe,SpeakString(sSay));
       } // reveal inventory
       break;
     } // pickup resources
     case 7: { // go to work location
       sS=GetLocalString(oMe,"sProfCraftWorkLoc");
       oOb=GetNearestObjectByTag(sS,oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
       if (GetIsObjectValid(oOb))
       { // work location is known
         if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
         { // move
           fnMoveToDestination(oMe,oOb);
         } // move
         else
         { // arrived
           SetLocalInt(oMe,"nProfState",8);
         } // arrived
       } // work location is known
       else
       { // error
         AssignCommand(oMe,SpeakString("ERROR: Work location '"+sS+"' as defined on sProfCraftWorkLoc cannot be found!"));
         SetLocalInt(oMe,"nProfState",14);
       } // error
       break;
     } // go to work location
     case 8: { // do work action method
       object oMy=oMe;
       sS=GetLocalString(oMe,"sProfCraftToolTag");
       if (GetStringLength(sS)>0)
       { // tool
         oItem=GetItemPossessedBy(oMe,sS);
       } // tool
       sS=GetLocalString(oMe,"sProfCraftInherit");
       nN=GetLocalInt(oMe,"nProfCraftRecipe");
       if (GetStringLength(sS)>0)
       { // inherit from object
         oOb=GetNearestObjectByTag(sS,oMe,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
         if (GetIsObjectValid(oOb))
         { // inherit object found
           sS=GetLocalString(oOb,"sProfCraftMethod"+IntToString(nN));
           if (GetStringLength(sS)<1)
           { // not defined on inherit object
             sS=GetLocalString(oMe,"sProfCraftMethod"+IntToString(nN));
             if (GetStringLength(sS)<1) sS=GetLocalString(oMe,"sProfCraftWorkMethod");
           } // not defined on inherit object
           oMy=oOb;
         } // inherit object found
         else
         { // standard
           sS=GetLocalString(oMe,"sProfCraftMethod"+IntToString(nN));
           if (GetStringLength(sS)<1) sS=GetLocalString(oMe,"sProfCraftWorkMethod");
         } // standard
       } // inherit from object
       else
       { // standard
         sS=GetLocalString(oMe,"sProfCraftMethod"+IntToString(nN));
         if (GetStringLength(sS)<1) sS=GetLocalString(oMe,"sProfCraftWorkMethod");
       } // standard
       string sCraftPlc=GetLocalString(oMy,"sProfCraftPlace"+IntToString(nN)); // peak 5/10..
       if (GetStringLength(sCraftPlc)<1) sCraftPlc=GetLocalString(oMe,"sProfCraftPlace");
       string sCraftPlc1, sCraftPlc2, sCraftPlc3;
       oOb=GetNearestObjectByTag(sCraftPlc+"1",oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sCraftPlc+"1");
       if (GetIsObjectValid(oOb)) { sCraftPlc1=GetTag(oOb); } //for W1
       else sCraftPlc1=sCraftPlc;
       oOb=GetNearestObjectByTag(sCraftPlc+"2",oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sCraftPlc+"2");
       if (GetIsObjectValid(oOb)) { sCraftPlc2=GetTag(oOb); } //for W2
       oOb=GetNearestObjectByTag(sCraftPlc+"3",oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sCraftPlc+"3");
       if (GetIsObjectValid(oOb)) { sCraftPlc3=GetTag(oOb); } //for W3 ..peak
       SetLocalString(oMe,"sProfCraftPlaces",sCraftPlc1+"."+sCraftPlc2+"."+sCraftPlc3);
       SetLocalInt(oMe,"nProfState",9);
       fnPROFActionMethod(sS,oItem,oMe,sCraftPlc1,sCraftPlc2,sCraftPlc3);// Peak 6/18/10
       break;
     } // do work action method
     case 9: { // wait for action method completion
       SetLocalInt(oMe,"nGNBStateSpeed",6);
       if (GetLocalInt(oMe,"bPROFActDone"))
       { // done
         DeleteLocalInt(oMe,"bPROFActDone");
         SetLocalInt(oMe,"nProfState",10);
       } // done
       break;
     } // wait for action method completion
     case 10: { // process recipe
       nN=GetLocalInt(oMe,"nProfCraftRecipe");
       sS=GetLocalString(oMe,"sProfCraftInherit");
       if (GetStringLength(sS)>0)
       { // inherit from
         oOb=GetNearestObjectByTag(sS,oMe,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
         sS=GetLocalString(oOb,"sProfCraftRecipe"+IntToString(nN)); // corPeak
       } // inherit from
       else
       { // personal
         sS=GetLocalString(oMe,"sProfCraftRecipe"+IntToString(nN));
       } // personal
       if (GetStringLength(sS)>0)
       { // process recipe
         fnProcessRecipe(oMe,sS);
       } // process recipe
       nN=GetTimeHour()*60+GetTimeMinute();
       if (GetLocalInt(oMe,"nProfCraftTime")<nN) SetLocalInt(oMe,"nProfState",11);
       else
       {
         SetLocalInt(oMe,"bPROFActDone",1);
         SetLocalInt(oMe,"nProfState",16);
       }
       break;
     } // process recipe
     case 11: { // Create Crafted Item
       DeleteLocalString(oMe,"sProfCraftPlaces");
       nN=GetLocalInt(oMe,"nProfCraftRecipe");
       sS=GetLocalString(oMe,"sProfCraftInherit");
       if (GetStringLength(sS)>0)
       { // inherit recipes
         oOb=GetNearestObjectByTag(sS,oMe,1);
         if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
         if (GetIsObjectValid(oOb))
         { // valid
           sS=GetLocalString(oOb,"sProfCraftItemR"+IntToString(nN));
           oItem=CreateItemOnObject(sS,oMe,GetLocalInt(oOb,"nProfCraftItemS"+IntToString(nN)));
           if (GetIsObjectValid(oItem))
           { // continue
             SetLocalObject(oMe,"oProfCraftItem",oItem);
             if (GetLocalInt(oMe,"bProfCraftAnnounce")) AssignCommand(oMe,SpeakString("*crafted "+GetName(oItem)+"*"));
             SetLocalInt(oMe,"nProfState",12);
           } // continue
           else
           { // error
             AssignCommand(oMe,SpeakString("ERROR: Inherit object '"+GetTag(oOb)+"' did not successfully produce item with ResRef '"+sS+"' as defined on sProfCraftItemR"+IntToString(nN)+"!"));
             SetLocalInt(oMe,"nProfState",14);
           } // error
         } // valid
         else
         { // error
           AssignCommand(oMe,SpeakString("ERROR: Inherit object '"+sS+"' does not exist as defined on sProfCraftInherit!"));
           SetLocalInt(oMe,"nProfState",14);
         } // error
       } // inherit recipes
       else
       { // not inherited
         sS=GetLocalString(oMe,"sProfCraftItemR"+IntToString(nN));
         oItem=CreateItemOnObject(sS,oMe,GetLocalInt(oMe,"nProfCraftItemS"+IntToString(nN)));
         if (GetIsObjectValid(oItem))
         { // continue
           SetLocalObject(oMe,"oProfCraftItem",oItem);
           if (GetLocalInt(oMe,"bProfCraftAnnounce")) AssignCommand(oMe,SpeakString("*crafted "+GetName(oItem)+"*"));
           SetLocalInt(oMe,"nProfState",12);
         } // continue
         else
         { // error
           AssignCommand(oMe,SpeakString("ERROR: The ResRef '"+sS+"' stored on variable sProfCraftItemR"+IntToString(nN)+" did not produce an item!"));
           SetLocalInt(oMe,"nProfState",14);
         } // error
       } // not inherited
       // item wearing
       sS=GetLocalString(oMe,"sProfCraftToolTag");
       if (GetStringLength(sS)>0)
       { // tools exist
         oOb=GetItemPossessedBy(oMe,sS);
         if (GetIsObjectValid(oOb))
         { // tool exists
           nN=GetLocalInt(oOb,"nWearing");
           sS=GetName(oOb);
           if (GetLocalInt(oMe,"nProfCraftToolFR")>0) nN=nN+GetLocalInt(oMe,"nProfCraftToolFR");
           if (nN>99)
           { // tool breaks
             DestroyObject(oOb);
             AssignCommand(oMe,SpeakString("*"+sS+" breaks*"));
           } // tool breaks
           else { SetLocalInt(oOb,"nWearing",nN); }
         } // tool exists
       } // tools exist
       break;
     } // Create Crafted Item
     case 12: { // go to Deliver location
       sS=GetLocalString(oMe,"sProfCraftDeliverLoc");
       oOb=GetNearestObjectByTag(sS,oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
       if (GetIsObjectValid(oOb))
       { // work location is known
         if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
         { // move
           fnMoveToDestination(oMe,oOb);
         } // move
         else
         { // arrived
           SetLocalInt(oMe,"nProfState",13);
         } // arrived
       } // work location is known
       else
       { // error
         AssignCommand(oMe,SpeakString("ERROR: Work location '"+sS+"' as defined on sProfCraftDeliverLoc cannot be found!"));
         SetLocalInt(oMe,"nProfState",14);
       } // error
       break;
     } // go to Deliver Location
     case 13: { // Deliver item
       sS=GetLocalString(oMe,"sProfCraftDeliverLoc");
       oOb=GetNearestObjectByTag(sS,oMe,1);
       if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
       nN=GetObjectType(oOb);
       if (nN==OBJECT_TYPE_STORE||nN==OBJECT_TYPE_CREATURE||GetHasInventory(oOb))
       { // container type
         AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
         AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0,3.0));
         AssignCommand(oOb,ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN,1.0,3.0));
         oItem=GetLocalObject(oMe,"oProfCraftItem");
         CreateItemOnObject(GetResRef(oItem),oOb,GetItemStackSize(oItem));
         DelayCommand(1.0,DestroyObject(oItem));
       } // container type
       else
       { // non-container
         oItem=GetLocalObject(oMe,"oProfCraftItem");
         AssignCommand(oMe,ActionPutDownItem(oItem));
       } // non-container
       nN=FALSE;
       sS=GetTag(GetLocalObject(oMe,"oProfCraftItem"));
       oOb=GetFirstItemInInventory(oMe);
       while(oOb!=OBJECT_INVALID)
       { // traverse inventory
         if (GetTag(oOb)==sS) nN=TRUE;
         oOb=GetNextItemInInventory(oOb);
       } // traverse inventory
       if(!nN)
       { // item destroyed
         DeleteLocalObject(oMe,"oProfCraftItem");
         SetLocalInt(oMe,"nProfState",1);
         nN=0;
         sS=GetLocalString(oMe,"sProfCraftInherit");
         if (GetStringLength(sS)>0)
         { // inherit object exists
           oOb=GetNearestObjectByTag(sS,oMe,1);
           if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
           if (GetIsObjectValid(oOb))
           { // valid
             nN=GetLocalInt(oOb,"nProfCraftWage"+IntToString(GetLocalInt(oMe,"nProfCraftRecipe")));
             if (nN<1)
             { // check person
               nN=GetLocalInt(oMe,"nProfCraftWage"+IntToString(GetLocalInt(oMe,"nProfCraftRecipe")));
             } // check person
           } // valid
         } // inherit object exists
         else
         { // does not exist
           nN=GetLocalInt(oMe,"nProfCraftWage"+IntToString(GetLocalInt(oMe,"nProfCraftRecipe")));
         } // does not exist
         if (nN>0)
         { // pay wage
           GiveCoins(oMe,nN,"ANY",nCurrency);
         } // pay wage
         DeleteLocalInt(oMe,"nProfCraftRecipe");
       } // item destroyed
       break;
     } // Deliver Item
     case 14: { // end of shift
       fnPROFCleanupArgs();
       DeleteLocalInt(oMe,"nProfCraftShiftStart");
       DeleteLocalInt(oMe,"nProfState");
       DeleteLocalInt(oMe,"bGNBProfessions");
       nN=GetLocalInt(oMe,"nProfCraftWage");
       if (nN>0)
       { // pay wage
         GiveCoins(oMe,nN,"ANY",nCurrency);
       } // pay wage
       break;
     } // end of shift
     case 15: { // wait for done picking recipe
       if (GetLocalInt(oMe,"bProfCraftRecipeSearch")==FALSE)
       { // done searching
         if (GetLocalInt(oMe,"nProfCraftRecipe")<1)
         { // no recipe found
           SetLocalInt(oMe,"nProfState",5);
         } // no recipe found
         else
         { // make recipe
           SetLocalInt(oMe,"nProfState",7);
         } // make recipe
       } // done searching
       break;
     } // wait for done picking recipe
     case 16: { // crafting delay per recipe
       if(GetLocalInt(oMe,"nPROFInAction")==0)
         if(GetLocalInt(oMe,"nProfCraftTime")>(GetTimeHour()*60+GetTimeMinute()))
         { // do crafting delay activities
           SetLocalInt(oMe,"nGNBStateSpeed",6);
           string sPlc1,sPlc2,sPlc3;
           sPlc3=GetLocalString(oMe,"sProfCraftPlaces");
           sPlc1=fnParse(sPlc3);
           sPlc3=fnRemoveParsed(sPlc3,sPlc1);
           sPlc2=fnParse(sPlc3);
           sPlc3=fnRemoveParsed(sPlc3,sPlc2);
           sS=GetLocalString(oMe,"sProfCraftToolTag");
           oItem=GetItemPossessedBy(oMe,sS);
           sS=GetLocalString(oMe,"sProfCraftWaiting");
           if (GetStringLength(sS)>0)
           { // actions
fnDebug("calling AM from 16");
             fnPROFActionMethod(sS,oItem,oMe,sPlc1,sPlc2,sPlc3);
           } // actions
         } // do crafting delay activities
         else
         { // done
           DeleteLocalString(oMe,"sActs");
           AssignCommand(oMe,ClearAllActions());
           DeleteLocalInt(oMe,"bPROFActDone");
           SetLocalInt(oMe,"nProfState",11);
         } // done
       break;
     } // crafting delay per recipe
     default: { SetLocalInt(oMe,"nProfState",0); }
   } // Main Switch-------------------------------------------
   if (nState!=14) DelayCommand(IntToFloat(nSpeed),ExecuteScript("npcact_p_craft",oMe));
}
////////////////////////////////////////////////////////////////////// MAIN

//////////////////////////////
// FUNCTIONS
//////////////////////////////


/*int fnCountItems(object oOb,string sTag)
{ // PURPOSE: This function returns the number of items with that
  // tag that are in the container or within 8 meters of the object
  int nRet=0;
  int nLoop;
  object oInv;
  int nOT=GetObjectType(oOb);
  if (nOT==OBJECT_TYPE_STORE||nOT==OBJECT_TYPE_CREATURE||GetHasInventory(oOb)==TRUE)
  { // container
    oInv=GetFirstItemInInventory(oOb);
    while(oInv!=OBJECT_INVALID)
    { // traverse inventory
      if (GetTag(oInv)==sTag) nRet++;
      oInv=GetNextItemInInventory(oOb);
    } // traverse inventory
  } // container
  else
  { // non-container
    nLoop=1;
    oInv=GetNearestObjectByTag(sTag,oOb,nLoop);
    while(oInv!=OBJECT_INVALID&&GetDistanceBetween(oOb,oInv)<8.0)
    { // look at nearby objects
      if (GetObjectType(oInv)==OBJECT_TYPE_ITEM) nRet++;
      nLoop++;
      oInv=GetNearestObjectByTag(sTag,oOb,nLoop);
    } // look at nearby objects
  } // non-container
  if(GetLocalInt(oMe,"nProfCraftSayInventory")==2)
  { // say inv
    SetLocalInt(oMe,"nProfCraftSayInventory",1);
    sS="";
    if(nRet>1) sS="s";
    AssignCommand(oMe,SpeakString("I have "+IntToString(nRet)+" "+GetName(GetObjectByTag(sTag))+sS));
  } // say inv
  return nRet;
} // fnCountItems()
  */
int fnHasItems(object oOb,string sTag,int nQty)
{ // PURPOSE: Returns TRUE if the object in question has at least nQty
  // of items with the specified sTag.
//fnDebug("in fnhasitems");
  int bRet=FALSE;
  int nCount;
  int nLoop;
  object oInv;
  int nOT=GetObjectType(oOb);
  if (nOT==OBJECT_TYPE_STORE||nOT==OBJECT_TYPE_CREATURE||GetHasInventory(oOb)==TRUE)
  { // container type
    oInv=GetFirstItemInInventory(oOb);
    while(oInv!=OBJECT_INVALID&&nCount<nQty)
    { // traverse inventory
      fnDebug("Crafter inventory item: "+GetTag(oInv),TRUE);
      if (GetTag(oInv)==sTag) nCount++;
      oInv=GetNextItemInInventory(oOb);
    } // traverse inventory
  } // container type
  else
  { // non-container
    nLoop=1;
    oInv=GetNearestObjectByTag(sTag,oOb,nLoop);
    while(oInv!=OBJECT_INVALID&&GetDistanceBetween(oOb,oInv)<8.0&&nCount<nQty)
    { // count objects on ground
      if (GetObjectType(oInv)==OBJECT_TYPE_ITEM) nCount++;
      nLoop++;
      oInv=GetNearestObjectByTag(sTag,oOb,nLoop);
    } // count objects on ground
  } // non-container
  if (nCount>=nQty) bRet=TRUE;
  return bRet;
} // fnHasItems()

int fnCanDoRecipe(object oMe,string sRecipe,int nPos)
{ // PURPOSE: Checks to see if the NPC can do this recipe
//fnDebug("in fncandorecipe");
  int bRet=TRUE;
  string sParse, sL1, sS;
  string sRemain=sRecipe;
  string sRecipeWaypoint=GetLocalString(oMe,"sProfCraftInherit");
  object oOb;
  int nN;
  object oWP=GetNearestObjectByTag(sRecipeWaypoint,oMe,1);
  if (GetIsObjectValid(oWP)==FALSE) oWP=GetObjectByTag(sRecipeWaypoint);
  if (GetIsObjectValid(oWP)==FALSE) oWP=oMe;
  while(GetStringLength(sRemain)>0&&bRet)
  { // check parameters
    sParse=fnParse(sRemain,".");
    sRemain=fnRemoveParsed(sRemain,sParse,".");
    sL1=GetStringLeft(sParse,1);
    if (sL1=="!")
    { // Item required
      sParse=GetStringRight(sParse,GetStringLength(sParse)-1);
      sL1=fnParse(sParse,"/");
      sParse=fnRemoveParsed(sParse,sL1,"/");
      sS=GetLocalString(oMe,"sProfCraftDeliverLoc");
      oOb=GetNearestObjectByTag(sS,oMe,1);
      if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
      if (GetIsObjectValid(oOb))
      { // storage loc found
        bRet=fnHasItems(oMe,sL1,StringToInt(sParse));
      } // storage loc found
      else
      {
        bRet=FALSE;
        AssignCommand(oMe,SpeakString("ERROR: I cannot find the delivery object with tag '"+sS+"' as stored on sProfCraftDeliverLoc!"));
      }
    } // Item required
    else if (sL1=="&")
    { // time of day
      sL1=GetStringRight(sParse,1);
      if (sL1=="D"&&GetIsDay()==FALSE) bRet=FALSE;
      else if (sL1=="N"&&GetIsNight()==FALSE) bRet=FALSE;
      else if (sL1=="U"&&GetIsDusk()==FALSE) bRet=FALSE;
      else if (sL1=="W"&&GetIsDawn()==FALSE) bRet=FALSE;
      else if (sL1=="G"&&GetIsDawn()==FALSE&&GetIsDusk()==FALSE) bRet=FALSE;
    } // time of day
    else if (sL1=="^")
    { // weather
      sL1=GetStringRight(sParse,1);
      if (sL1=="C"&&GetWeather(GetArea(oMe))!=WEATHER_CLEAR) bRet=FALSE;
      else if (sL1=="R"&&GetWeather(GetArea(oMe))!=WEATHER_RAIN) bRet=FALSE;
      else if (sL1=="S"&&GetWeather(GetArea(oMe))!=WEATHER_SNOW) bRet=FALSE;
    } // weather
    else if (sL1=="@")
    { // certain day of the month
      sL1=GetStringRight(sParse,GetStringLength(sParse)-1);
      if (StringToInt(sL1)!=GetCalendarDay()) bRet=FALSE;
    } // certain day of the month
  } // check parameters
  if (bRet==TRUE)
  { // check max conditions
    nN=GetLocalInt(oWP,"nProfCraftMax"+IntToString(nPos));
    if (nN<1) nN=3;
    sS=GetLocalString(oWP,"sProfCraftItemT"+IntToString(nPos));
    if (GetStringLength(sS)>0)
    { // tag of recipe defined
      if (fnHasItems(oOb,sS,nN)) bRet=FALSE;
    } // tag of recipe defined
    else
    { // error
      SendMessageToPC(GetFirstPC(),"PROFESSIONS ERROR: Object with tag '"+GetTag(oOb)+"' has improper recipe number "+IntToString(nPos)+"!");
    } // error
  } // check max conditions
  return bRet;
} // fnCanDoRecipe()

void fnChooseRecipe(object oMe=OBJECT_SELF,int nSelect=0)
{ // PURPOSE: To return the number of an available recipe that can be crafted
  // nSelect=0 (default), choose recipe to test at random, else lowest #'d valid recipe will be chosen
//fnDebug("infnchooserecipe");
  int nRecipe=nSelect;
  string sRecipeWaypoint=GetLocalString(oMe,"sProfCraftInherit");
  object oWP;
  string sRecipe=" ";
  fnDebugInt("If #, testing Recipe #",nSelect);
  if (GetStringLength(sRecipeWaypoint)>0)
  { // inherits the craft list
    oWP=GetNearestObjectByTag(sRecipeWaypoint,oMe,1);
    if (GetIsObjectValid(oWP)==FALSE) oWP=GetObjectByTag(sRecipeWaypoint);
    if (GetIsObjectValid(oWP)==FALSE)
    { // not found error
      AssignCommand(oMe,SpeakString("ERROR: The waypoint specified in sProfCraftInherit cannot be found!"));
    } // not found error
  } // inherits the craft list
  else
  { // self
    oWP=oMe;
  } // self
  if (GetIsObjectValid(oWP))
  { // object to get recipes from exists
    if(!nSelect)
    { // count recipes
      while(sRecipe!="")
      { // get recipes
        nRecipe++;
        sRecipe=GetLocalString(oWP,"sProfCraftRecipe"+IntToString(nRecipe));
      } // get recipes
//fnDebugInt("# recipes =",nRecipe);
      nRecipe=Random(nRecipe)+1;
    } // count recipes
//fnDebugInt("chose recipe ",nRecipe);
    sRecipe=GetLocalString(oWP,"sProfCraftRecipe"+IntToString(nRecipe));
    if (GetStringLength(sRecipe)>0)
    { // recipe found
//      if(nPos=1&&GetLocalInt(oMe,"nProfCraftSayInventory")) SetLocalInt(oMe,"nProfCraftSayInventory",2);
      if (fnCanDoRecipe(oMe,sRecipe,nRecipe))
      { // I can make this recipe
        SetLocalInt(oMe,"nProfCraftRecipe",nRecipe);
        DeleteLocalInt(oMe,"bProfCraftRecipeSearch");
      } // I can make this recipe
      else
      { // cannot make that recipe
        DelayCommand(0.3,fnChooseRecipe(oMe,nSelect+1*(nSelect>0)));  // helps prevent TMIs
      } // cannot make that recipe
//      SetLocalInt(oMe,"nProfCraftSayInventory",1);
    } // recipe found
    else
    { // end of recipes
      SetLocalInt(oMe,"nProfCraftRecipe",0);
      DeleteLocalInt(oMe,"bProfCraftRecipeSearch");
    } // end of recipes
  } // object to get recipes from exists
  else
  { // end
    SetLocalInt(oMe,"nProfCraftRecipe",0);
    DeleteLocalInt(oMe,"bProfCraftRecipeSearch");
  } // end
} // fnChooseRecipe()


void fnConsumeItems(object oMe,string sTag,int nQty)
{ // PURPOSE: To consume items in inventory
  int nConsumeCount=nQty;
  object oInv;
  int nN;
  oInv=GetFirstItemInInventory(oMe);
  while(GetIsObjectValid(oInv)&&nConsumeCount>0)
  { // consume
    if (GetTag(oInv)==sTag)
    { // consume it
      nN=GetItemStackSize(oInv);
      if (nN>nConsumeCount)
      { // don't need entire stack
        nN=nN-nConsumeCount;
        nConsumeCount=0;
        SetItemStackSize(oInv,nN);
      } // don't need entire stack
      else
      { // entire stack
        nConsumeCount=nConsumeCount-nN;
        DelayCommand(1.0,DestroyObject(oInv));
      } // entire stack
    } // consume it
    oInv=GetNextItemInInventory(oMe);
  } // consume
} // fnConsumeItems()

void fnProcessRecipe(object oMe,string sRecipe)
{ // PURPOSE: to handle actable portions of the recipe
  object oItem;
  string sParse;
  string sL1;
  string sRemains=sRecipe;
  float fF;
  string sS;
  int nN;
  while (GetStringLength(sRemains)>0)
  { // process parameters
    sParse=fnParse(sRemains,".");
    sRemains=fnRemoveParsed(sRemains,sParse,".");
    sL1=GetStringLeft(sParse,1);
    if (sL1=="!")
    { // consume items
      sParse=GetStringRight(sParse,GetStringLength(sParse)-1);
      sL1=fnParse(sParse,"/");
      sParse=fnRemoveParsed(sParse,sL1,"/");
      nN=StringToInt(sParse);
      fnConsumeItems(oMe,sL1,nN);
    } // consume items
    else if (sL1=="*")
    { // tool wear
      sL1=GetStringRight(sParse,GetStringLength(sParse)-1);
      sS=GetLocalString(oMe,"sProfCraftToolTag");
      oItem=GetItemPossessedBy(oMe,sS);
      if (GetIsObjectValid(oItem))
      { // wearing
        nN=GetLocalInt(oItem,"nWearing");
        nN=nN+StringToInt(sL1);
        SetLocalInt(oItem,"nWearing",nN);
      } // wearing
    } // tool wear
    else if (sL1=="#")
    { // time
      sL1=GetStringRight(sParse,GetStringLength(sParse)-1);
      nN=StringToInt(sL1)*30+GetTimeMinute()+GetTimeHour()*60;
      SetLocalInt(oMe,"nProfCraftTime",nN);
    } // time
  } // process parameters
} // fnProcessRecipe()
