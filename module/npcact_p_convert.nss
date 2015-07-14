////////////////////////////////////////////////////////////////////////////////
// npcact_h_convert  -  NPC ACTIVITIES 6.0 Professions Converter
// By Deva Bryson Winblood.  09/15/2004
// Last Modified By: Deva Bryson Winblood  02/02/2005
//------------------------------------------------------------------------------
// This profession will convert one item type into another.  This is useful for
// smelters, millers and other similar professions.
////////////////////////////////////////////////////////////////////////////////
#include "npcact_h_prof"
#include "npcact_h_time"
#include "npcact_h_money"
///////////////////////////
// PROTOTYPES
///////////////////////////

///////////////////////////////////////////////////////////////////////// MAIN
void main()
{
  object oMe=OBJECT_SELF;
   int nSpeed=GetLocalInt(oMe,"nGNBStateSpeed");
   if(!nSpeed) nSpeed=GetLocalInt(GetModule(),"nGNBStateSpeed"); // 6/06/10 Peak
   if (nSpeed<1) nSpeed=6;
  int nState=GetLocalInt(oMe,"nProfState");
  fnDebugInt("ProfConvState ",nState);
  string sS;
  object oOb;
  object oItem;
  int nCurrency=GetLocalInt(oMe,"nCurrency");
  int nN;
  if (GetLocalInt(oMe,"nArgC")==1)
  { // correct arguments were passed
    SetLocalInt(oMe,"bGNBProfessions",TRUE);
    SetLocalInt(oMe,"nGNBProfProc",1);
    SetLocalInt(oMe,"nGNBProfFail",3+nSpeed);
    switch(nState)
    { // main switch
      case 0: { // set start time
        nN=fnGetAbsoluteHour();
        SetLocalInt(oMe,"nProfConvShiftStart",nN);
        // check for errors
        sS = "";
        if (GetStringLength(GetLocalString(oMe,"sProfConvResLoc"))<1) sS="sProfConvResLoc must define a location to find resources I am to convert!";
        else if (GetStringLength(GetLocalString(oMe,"sProfConvDropLoc"))<1) sS="sProfConvDropLoc must define a location I am to drop off converted items!";
        else if (GetStringLength(GetLocalString(oMe,"sProfConvResTag"))<1) sS="sProfConvResTag must be the tag of the item types I am to convert!";
        else if (GetStringLength(GetLocalString(oMe,"sProfConvToRes"))<1) sS="sProfConvToRes must be the resref of the item I am to create from the resource!";
        else if (StringToInt(GetLocalString(oMe,"sArgV1"))<1) sS="The shift length parameter passed to this profession must be at least 1!";
        if (GetStringLength(sS)>0)
        { // error
          AssignCommand(oMe,SpeakString("ERROR: "+sS));
          SetLocalInt(oMe,"nProfState",14);
        } // error
        SetLocalInt(oMe,"nProfState",1);
        break;
      } // set start time
      case 1: { // Check for Tool and end of shift time
        nN=fnGetAbsoluteHour();
        nN=nN-GetLocalInt(oMe,"nProfConvShiftStart");
        if (nN>=StringToInt(GetLocalString(oMe,"sArgV1")))
        { // end of shift
          SetLocalInt(oMe,"nProfState",14);
        } // end of shift
        else
        { // shift continues is a tool needed
          sS=GetLocalString(oMe,"sProfConvToolTag");
          if (GetLocalInt(oMe,"bProfConvTool")!=0&&GetItemPossessedBy(oMe,sS)==OBJECT_INVALID)
          { // tool is required
            SetLocalInt(oMe,"nProfState",2);
          } // tool is required
          else
          { // no tool required
            SetLocalInt(oMe,"nProfState",4);
          } // no tool required
        } // shift continues is a tool needed
        break;
      } // Check for Tool and end of shift tim
      case 2: { // go to get tool
        sS=GetLocalString(oMe,"sProfConvToolLoc");
        if (GetStringLength(sS)>0)
        { // place to get tool is specified
          oOb=GetNearestObjectByTag(sS,oMe,1);
          if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
          if (GetIsObjectValid(oOb))
          { // object is valid
            if (GetArea(oOb)!=GetArea(oMe)||GetDistanceBetween(oMe,oOb)>2.5)
            { // move to object
              fnMoveToDestination(oMe,oOb);
            } // move to object
            else
            { // arrived
              SetLocalInt(oMe,"nProfState",3);
            } // arrived
          } // object is valid
          else
          { // error
            AssignCommand(oMe,SpeakString("ERROR: The object with tag '"+sS+"' defined in sProfConvToolLoc cannot be found!"));
            SetLocalInt(oMe,"nProfState",14);
          } // error
        } // place to get tool is specified
        else
        { // error
          AssignCommand(oMe,SpeakString("ERROR: The place defined to get a tool in sProfConvToolLoc must exist if you demand I use a tool!"));
          SetLocalInt(oMe,"nProfState",14);
        } // error
        break;
      } // go to get tool
      case 3: { // purchase tool
        sS=GetLocalString(oMe,"sProfConvToolFrom");
        if (GetStringLength(sS)>0)
        { // buy from is defined
          oOb=GetNearestObjectByTag(sS,oMe,1);
          if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
          if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
          { // valid person to buy from
            nN=GetLocalInt(oMe,"nProfConvToolCost");
            if (nN<=GetWealth(oMe,nCurrency))
            { // have enough gold
              AssignCommand(oOb,TakeCoins(oMe,nN,"ANY",nCurrency));
              sS=GetLocalString(oMe,"sProfConvToolSay");
              AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
              if (GetStringLength(sS)>0)
              { // say something
                AssignCommand(oMe,SpeakString(sS));
                AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,4.0));
              } // say something
              AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0,2.0));
              sS=GetLocalString(oMe,"sProfConvToolMerch");
              if (GetStringLength(sS)>0)
              { // merchant has something to say
                DelayCommand(3.0,AssignCommand(oOb,SpeakString(sS)));
              } // merchant has something to say
              sS=GetLocalString(oMe,"sProfConvToolRes");
              oOb=CreateItemOnObject(sS,oMe);
              if (GetIsObjectValid(oOb))
              { // tool created
                sS=GetLocalString(oMe,"sProfConvToolTag");
                if (sS==fnGetNPCTag(oOb))
                { // tool tag is okay
                  AssignCommand(oMe,ActionEquipItem(oOb,INVENTORY_SLOT_RIGHTHAND));
                  SetLocalInt(oMe,"nProfState",4);
                } // tool tag is okay
                else
                { // error
                  DelayCommand(4.0,AssignCommand(oMe,SpeakString("ERROR: The tag of tool produced was '"+GetTag(oOb)+"' which does not match '"+sS+"' stored on sProfConvToolTag !")));
                  DestroyObject(oOb);
                  SetLocalInt(oMe,"nProfState",14);
                } // error
              } // tool created
              else
              { // error
                DelayCommand(4.0,AssignCommand(oMe,SpeakString("ERROR: The resref '"+sS+"' in sProfConvToolRes did not produce an item!")));
                SetLocalInt(oMe,"nProfState",14);
              } // error
            } // have enough gold
            else
            { // not enough gold
              AssignCommand(oMe,SpeakString("I do not have the gold to buy a tool from ye."));
              DelayCommand(3.0,AssignCommand(oOb,SpeakString("Well come back when ye do.")));
              SetLocalInt(oMe,"nProfState",14);
            } // not enough gold
          } // valid person to buy from
          else
          { // error
            AssignCommand(oMe,SpeakString("ERROR: The person's tag '"+sS+"' in sProfConvToolFrom is either invalid or is not a CREATURE type object!"));
            SetLocalInt(oMe,"nProfState",14);
          } // error
        } // buy from is defined
        else
        { // error
          AssignCommand(oMe,SpeakString("ERROR: The person to buy a tool from needs their tag defined in sProfConvToolFrom!"));
          SetLocalInt(oMe,"nProfState",14);
        } // error
        break;
      } // purchase tool
      case 4: { // go to resource pile
        sS=GetLocalString(oMe,"sProfConvResLoc");
        oOb=GetNearestObjectByTag(sS,oMe,1);
        if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
        if (GetIsObjectValid(oOb))
        { // resource pile identified
          if (GetArea(oOb)!=GetArea(oMe)||GetDistanceBetween(oMe,oOb)>2.5)
          { // move
            fnMoveToDestination(oMe,oOb);
          } // move
          else
          { // arrived
            SetLocalInt(oMe,"nProfState",5);
          } // arrived
        } // resource pile identified
        else
        { // error
          AssignCommand(oMe,SpeakString("ERROR: The value '"+sS+"' on sProfConvResLoc is supposed to identify the tag of the resource location.  No object can be found!!"));
          SetLocalInt(oMe,"nProfState",14);
        } // error
        break;
      } // go to resource pile
      case 5: { // pickup resource
        SetLocalInt(oMe,"nProfState",6);
        sS=GetLocalString(oMe,"sProfConvResLoc");
        oOb=GetNearestObjectByTag(sS,oMe,1);
        if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
        nN=GetObjectType(oOb);
        sS=GetLocalString(oMe,"sProfConvResTag");
        if (GetItemPossessedBy(oMe,sS)==OBJECT_INVALID)
        { // try to find resources
          if (nN!=OBJECT_TYPE_STORE&&GetHasInventory(oOb)==FALSE)
          { // not a container
            oItem=GetNearestObjectByTag(sS,oMe,1);
            if (GetIsObjectValid(oItem)&&GetDistanceBetween(oItem,oMe)<8.0)
            { // item found
              nN=GetItemStackSize(oItem);
              if (nN>1)
              { // stack
                AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,3.0));
                SetItemStackSize(oItem,nN-1);
                oItem=CreateItemOnObject(GetResRef(oItem),oMe,1);
              } // stack
              else
              { // not stacked
                AssignCommand(oMe,ActionPickUpItem(oItem));
              } // not stacked
            } // item found
          } // not a container
          else
          { // container or creature
            if (nN==OBJECT_TYPE_CREATURE) oItem=GetItemPossessedBy(oOb,sS);
            else
            { // container
              oItem=fnPROFContainerHasItem(oOb,sS);
            } // container
            if (GetIsObjectValid(oItem))
            { // item found
              nN=GetItemStackSize(oItem);
              AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
              AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0,4.0));
              AssignCommand(oOb,ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN,1.0,4.0));
              if (nN>1)
              { // stacked item
                SetItemStackSize(oItem,nN-1);
                oItem=CreateItemOnObject(GetResRef(oItem),oMe,1);
              } // stacked item
              else
              { // single item
                oOb=CreateItemOnObject(GetResRef(oItem),oMe,1);
                DestroyObject(oItem);
              } // single item
            } // item found
          } // container or creature
          if (oItem==OBJECT_INVALID) SetLocalInt(oMe,"nProfState",13);
        } // try to find resources
        break;
      } // pickup resource
      case 6: { // go to interact object 1
        sS=GetLocalString(oMe,"sProfConvWObject1");
        if (GetStringLength(sS)>0)
        { // interact object 1 defined
          oOb=GetNearestObjectByTag(sS,oMe,1);
          if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
          if (GetIsObjectValid(oOb))
          { // interact object found
            if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
            { // move
              fnMoveToDestination(oMe,oOb);
            } // move
            else
            { // arrived
              SetLocalInt(oMe,"nProfState",7);
            } // arrived
          } // interact object found
          else
          { // error
            AssignCommand(oMe,SpeakString("ERROR: I cannot find Interact Object with tag '"+sS+"' defined in variable sProfConvWobject1!"));
            SetLocalInt(oMe,"nProfState",8);
          } // error
        } // interact object 1 defined
        else { SetLocalInt(oMe,"nProfState",8); }
        break;
      } // go to interact object 1
      case 7: { // do interact with object 1
        oOb=OBJECT_INVALID;
        sS=GetLocalString(oMe,"sProfConvToolTag");
        oOb=GetItemPossessedBy(oMe,sS);
        sS=GetLocalString(oMe,"sProfConvWObject1AM");
        if (GetStringLength(sS)>0)
        { // action method defined
          fnPROFActionMethod(sS,oOb,oMe,GetLocalString(oMe,"sProfConvWObject1"));
          SetLocalInt(oMe,"nProfState",15);
        } // action method defined
        else
        { // no action method
          SetLocalInt(oMe,"nProfState",8);
        } // no action method
        break;
      } // do interact with object 1
      case 8: { // go to interact object 2
        sS=GetLocalString(oMe,"sProfConvWObject2");
        if (GetStringLength(sS)>0)
        { // interact object 2 defined
          oOb=GetNearestObjectByTag(sS,oMe,1);
          if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
          if (GetIsObjectValid(oOb))
          { // interact object found
            if (GetArea(oMe)!=GetArea(oOb)||GetDistanceBetween(oMe,oOb)>2.5)
            { // move
              fnMoveToDestination(oMe,oOb);
            } // move
            else
            { // arrived
              SetLocalInt(oMe,"nProfState",9);
            } // arrived
          } // interact object found
          else
          { // error
            AssignCommand(oMe,SpeakString("ERROR: I cannot find Interact Object with tag '"+sS+"' defined in variable sProfConvWobject2!"));
            SetLocalInt(oMe,"nProfState",10);
          } // error
        } // interact object 2 defined
        else { SetLocalInt(oMe,"nProfState",10); }
        break;
      } // go to interact object 2
      case 9: { // do interact with object 2
        oOb=OBJECT_INVALID;
        sS=GetLocalString(oMe,"sProfConvToolTag");
        oOb=GetItemPossessedBy(oMe,sS);
        sS=GetLocalString(oMe,"sProfConvWObject2AM");
        if (GetStringLength(sS)>0)
        { // action method defined
          fnPROFActionMethod(sS,oOb,oMe,GetLocalString(oMe,"sProfConvWObject2"));
          SetLocalInt(oMe,"nProfState",16);
        } // action method defined
        else
        { // no action method
          SetLocalInt(oMe,"nProfState",10);
        } // no action method
        break;
      } // do interact with object 2
      case 10: { // Produce converted item
        sS=GetLocalString(oMe,"sProfConvResTag");
        oOb=GetItemPossessedBy(oMe,sS);
        DestroyObject(oOb);
        sS=GetLocalString(oMe,"sProfConvToRes");
        oItem=CreateItemOnObject(sS,oMe,1);
        if (GetIsObjectValid(oItem))
        { // created converted item
          sS=GetLocalString(oMe,"sProfConvToTag");
          if (GetTag(oItem)==sS)
          { // tags match
            // deal with tool fatigue
            nN=GetLocalInt(oMe,"nProfConvToolFR");
            if (nN>0)
            { // tool fatigue needs to be defined
              sS=GetLocalString(oMe,"sProfConvToolTag");
              oItem=GetItemPossessedBy(oMe,sS);
              nN=GetLocalInt(oItem,"nWearing")+nN;
              if (nN>99)
              { // tool breaks
                AssignCommand(oMe,SpeakString("*tool breaks*"));
                DestroyObject(oItem);
              } // tool breaks
              else { SetLocalInt(oItem,"nWearing",nN); }
            } // tool fatigue needs to be defined
            SetLocalInt(oMe,"nProfState",11);
          } // tags match
          else
          { // error
            AssignCommand(oMe,SpeakString("ERROR: The tag of the item converted '"+GetTag(oItem)+"' does not match tag '"+sS+"' on variable sProfConvToTag!"));
            DestroyObject(oItem);
            SetLocalInt(oMe,"nProfState",14);
          } // error
        } // created converted item
        else
        { // error
          AssignCommand(oMe,SpeakString("ERROR: The ResRef '"+sS+"' on sProfConvToRes did not produce an item!"));
          SetLocalInt(oMe,"nProfState",14);
        } // error
        break;
      } // Produce converted item
      case 11: { // go to deliver converted item location
        sS=GetLocalString(oMe,"sProfConvDropLoc");
        oOb=GetNearestObjectByTag(sS,oMe,1);
        if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
        if (GetIsObjectValid(oOb))
        { // drop location exists
          if (GetArea(oOb)!=GetArea(oMe)||GetDistanceBetween(oMe,oOb)>2.5)
          { // move
            fnMoveToDestination(oMe,oOb);
          } // move
          else
          { // arrived
            SetLocalInt(oMe,"nProfState",12);
          } // arrived
        } // drop location exists
        else
        { // error
          AssignCommand(oMe,SpeakString("ERROR: The deliver location with tag '"+sS+"' stored on sProfConvDropLoc does not exist!!"));
          SetLocalInt(oMe,"nProfState",14);
        } // error
        break;
      } // go to deliver converted item location
      case 12: { // deliver converted item
        sS=GetLocalString(oMe,"sProfConvDropLoc");
        oOb=GetNearestObjectByTag(sS,oMe,1);
        if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
        nN=GetObjectType(oOb);
        if (nN!=OBJECT_TYPE_STORE&&GetHasInventory(oOb)==FALSE)
        { // not an inventory object - put on ground
          sS=GetLocalString(oMe,"sProfConvToTag");
          oItem=GetItemPossessedBy(oMe,sS);
          if (GetIsObjectValid(oItem))
          { // put down item
            AssignCommand(oMe,ActionPutDownItem(oItem));
          } // put down item
          else
          { // done
            SetLocalInt(oMe,"nProfState",1);
          } // none
        } // not an inventory object - put on ground
        else
        { // inventory object
          sS=GetLocalString(oMe,"sProfConvToTag");
          oItem=GetItemPossessedBy(oMe,sS);
          AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
          oOb=CreateItemOnObject(GetResRef(oItem),oOb);
          DestroyObject(oItem);
          AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0,3.0));
          SetLocalInt(oMe,"nProfState",1);
        } // inventory object
        break;
      } // deliver converted item
      case 13: { // Bored Ambient Animations sub-sequence
        nN=d6();
        if (nN==1) AssignCommand(oMe,ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED,1.0,6.0));
        else if (nN==2) AssignCommand(oMe,ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD,1.0,6.0));
        else if (nN==3) AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR,1.0,6.0));
        SetLocalInt(oMe,"nProfState",1);
        break;
      } // Bored Ambient Animations Sub-Sequence
      case 14: { // End of Shift
        fnPROFCleanupArgs();
        DeleteLocalInt(oMe,"nProfConvShiftStart");
        DeleteLocalInt(oMe,"nProfState");
        DeleteLocalInt(oMe,"bGNBProfessions");
        sS=GetLocalString(oMe,"sProfConvToolTag");
        oItem=GetItemPossessedBy(oMe,sS);
        if (GetIsObjectValid(oItem)) AssignCommand(oMe,ActionUnequipItem(oItem));
        nN=GetLocalInt(oMe,"nProfConvWage");
        if (nN>0)
        { // give wage
          GiveCoins(oMe,nN,"ANY",nCurrency);
        } // give wage
        break;
      } // End of Shift
      case 15: { // wait state 1
        if (GetLocalInt(oMe,"bPROFActDone")==TRUE)
        { // done waiting
          SetLocalInt(oMe,"nProfState",8);
          DeleteLocalInt(oMe,"bPROFActDone");
        } // done waiting
        break;
      } // wait state 1
      case 16: { // wait state 2
        if (GetLocalInt(oMe,"bPROFActDone")==TRUE)
        { // done waiting
          SetLocalInt(oMe,"nProfState",10);
          DeleteLocalInt(oMe,"bPROFActDone");
        } // done waiting
        break;
      } // wait state 2
      default : { SetLocalInt(oMe,"nProfState",1); }
    } // main switch
    if (nState!=14) DelayCommand(IntToFloat(nSpeed),ExecuteScript("npcact_p_convert",oMe));
  } // correct arguments were passed
  else { // error
    AssignCommand(oMe,SpeakString("ERROR: Converter profession requires 1 and only 1 parameter which is the shift length!"));
  } // error
}
///////////////////////////////////////////////////////////////////////// MAIN

///////////////////////////
// FUNCTIONS
///////////////////////////
