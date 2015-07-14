////////////////////////////////////////////////////////////////////////////////
// npcact_h_consume  -  NPC ACTIVITIES 6.0 Professions Consumer
// by Peter D Busby from Converter by Deva.  06/23/10
//------------------------------------------------------------------------------
// This profession will Consume one item type.  This is useful for
// housekeepers, cooks and other similar customers, and fodder consumption.
// The call is: *Consume/<shift length>
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
  fnDebugInt("ProfConsState ",nState);
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
        SetLocalInt(oMe,"nProfConsumShiftStart",nN);
        // check for errors
        sS = "";
        if (GetStringLength(GetLocalString(oMe,"sProfConsumResLoc"))<1) sS="sProfConsumResLoc must define a location to find resources I am to Consume!";
        else if (GetStringLength(GetLocalString(oMe,"sProfConsumResTag"))<1) sS="sProfConsumResTag must be the tag of the item types I am to Consume!";
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
        nN=nN-GetLocalInt(oMe,"nProfConsumShiftStart");
        if (nN>=StringToInt(GetLocalString(oMe,"sArgV1")))
        { // end of shift
          SetLocalInt(oMe,"nProfState",14);
        } // end of shift
        else
        { // shift continues is a tool needed
          sS=GetLocalString(oMe,"sProfConsumToolTag");
          if (GetLocalInt(oMe,"bProfConsumTool")!=0&&GetItemPossessedBy(oMe,sS)==OBJECT_INVALID)
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
        sS=GetLocalString(oMe,"sProfConsumToolLoc");
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
            AssignCommand(oMe,SpeakString("ERROR: The object with tag '"+sS+"' defined in sProfConsumToolLoc cannot be found!"));
            SetLocalInt(oMe,"nProfState",14);
          } // error
        } // place to get tool is specified
        else
        { // error
          AssignCommand(oMe,SpeakString("ERROR: The place defined to get a tool in sProfConsumToolLoc must exist if you demand I use a tool!"));
          SetLocalInt(oMe,"nProfState",14);
        } // error
        break;
      } // go to get tool
      case 3: { // purchase tool
        sS=GetLocalString(oMe,"sProfConsumToolFrom");
        if (GetStringLength(sS)>0)
        { // buy from is defined
          oOb=GetNearestObjectByTag(sS,oMe,1);
          if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
          if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
          { // valid person to buy from
            nN=GetLocalInt(oMe,"nProfConsumToolCost");
            if (nN<=GetWealth(oMe,nCurrency))
            { // have enough gold
              AssignCommand(oOb,TakeCoins(oMe,nN,"ANY",nCurrency));
              sS=GetLocalString(oMe,"sProfConsumToolSay");
              AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
              if (GetStringLength(sS)>0)
              { // say something
                AssignCommand(oMe,SpeakString(sS));
                AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,4.0));
              } // say something
              AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0,2.0));
              sS=GetLocalString(oMe,"sProfConsumToolMerch");
              if (GetStringLength(sS)>0)
              { // merchant has something to say
                DelayCommand(3.0,AssignCommand(oOb,SpeakString(sS)));
              } // merchant has something to say
              sS=GetLocalString(oMe,"sProfConsumToolRes");
              oOb=CreateItemOnObject(sS,oMe);
              if (GetIsObjectValid(oOb))
              { // tool created
                sS=GetLocalString(oMe,"sProfConsumToolTag");
                if (sS==fnGetNPCTag(oOb))
                { // tool tag is okay
                  AssignCommand(oMe,ActionEquipItem(oOb,INVENTORY_SLOT_RIGHTHAND));
                  SetLocalInt(oMe,"nProfState",4);
                } // tool tag is okay
                else
                { // error
                  DelayCommand(4.0,AssignCommand(oMe,SpeakString("ERROR: The tag of tool produced was '"+GetTag(oOb)+"' which does not match '"+sS+"' stored on sProfConsumToolTag !")));
                  DestroyObject(oOb);
                  SetLocalInt(oMe,"nProfState",14);
                } // error
              } // tool created
              else
              { // error
                DelayCommand(4.0,AssignCommand(oMe,SpeakString("ERROR: The resref '"+sS+"' in sProfConsumToolRes did not produce an item!")));
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
            AssignCommand(oMe,SpeakString("ERROR: The person's tag '"+sS+"' in sProfConsumToolFrom is either invalid or is not a CREATURE type object!"));
            SetLocalInt(oMe,"nProfState",14);
          } // error
        } // buy from is defined
        else
        { // error
          AssignCommand(oMe,SpeakString("ERROR: The person to buy a tool from needs their tag defined in sProfConsumToolFrom!"));
          SetLocalInt(oMe,"nProfState",14);
        } // error
        break;
      } // purchase tool
      case 4: { // go to resource pile
        sS=GetLocalString(oMe,"sProfConsumResLoc");
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
          AssignCommand(oMe,SpeakString("ERROR: The value '"+sS+"' on sProfConsumResLoc is supposed to identify the tag of the resource location.  No object can be found!!"));
          SetLocalInt(oMe,"nProfState",14);
        } // error
        break;
      } // go to resource pile
      case 5: { // pickup resource
        SetLocalInt(oMe,"nProfState",6);
        sS=GetLocalString(oMe,"sProfConsumResLoc");
        oOb=GetNearestObjectByTag(sS,oMe,1);
        if (GetIsObjectValid(oOb)==FALSE) oOb=GetObjectByTag(sS);
        nN=GetObjectType(oOb);
        sS=GetLocalString(oMe,"sProfConsumResTag");
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
        sS=GetLocalString(oMe,"sProfConsumWObject1");
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
            AssignCommand(oMe,SpeakString("ERROR: I cannot find Interact Object with tag '"+sS+"' defined in variable sProfConsumWobject1!"));
            SetLocalInt(oMe,"nProfState",8);
          } // error
        } // interact object 1 defined
        else { SetLocalInt(oMe,"nProfState",8); }
        break;
      } // go to interact object 1
      case 7: { // do interact with object 1
        oOb=OBJECT_INVALID;
        sS=GetLocalString(oMe,"sProfConsumToolTag");
        oOb=GetItemPossessedBy(oMe,sS);
        sS=GetLocalString(oMe,"sProfConsumWObject1AM");
        if (GetStringLength(sS)>0)
        { // action method defined
          fnPROFActionMethod(sS,oOb,oMe,GetLocalString(oMe,"sProfConsumWObject1"));
          SetLocalInt(oMe,"nProfState",15);
        } // action method defined
        else
        { // no action method
          SetLocalInt(oMe,"nProfState",8);
        } // no action method
        break;
      } // do interact with object 1
      case 8: { // go to interact object 2
        sS=GetLocalString(oMe,"sProfConsumWObject2");
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
            AssignCommand(oMe,SpeakString("ERROR: I cannot find Interact Object with tag '"+sS+"' defined in variable sProfConsumWobject2!"));
            SetLocalInt(oMe,"nProfState",10);
          } // error
        } // interact object 2 defined
        else { SetLocalInt(oMe,"nProfState",10); }
        break;
      } // go to interact object 2
      case 9: { // do interact with object 2
        oOb=OBJECT_INVALID;
        sS=GetLocalString(oMe,"sProfConsumToolTag");
        oOb=GetItemPossessedBy(oMe,sS);
        sS=GetLocalString(oMe,"sProfConsumWObject2AM");
        if (GetStringLength(sS)>0)
        { // action method defined
          fnPROFActionMethod(sS,oOb,oMe,GetLocalString(oMe,"sProfConsumWObject2"));
          SetLocalInt(oMe,"nProfState",16);
        } // action method defined
        else
        { // no action method
          SetLocalInt(oMe,"nProfState",10);
        } // no action method
        break;
      } // do interact with object 2
      case 10: { // Consume item
        sS=GetLocalString(oMe,"sProfConsumResTag");
        oOb=GetItemPossessedBy(oMe,sS);
        DestroyObject(oOb);
        // deal with tool fatigue
        nN=GetLocalInt(oMe,"nProfConsumToolFR");
        if (nN>0)
        { // tool fatigue needs to be defined
          sS=GetLocalString(oMe,"sProfConsumToolTag");
          oItem=GetItemPossessedBy(oMe,sS);
          nN=GetLocalInt(oItem,"nWearing")+nN;
          if (nN>99)
          { // tool breaks
            AssignCommand(oMe,SpeakString("*tool breaks*"));
            DestroyObject(oItem);
          } // tool breaks
          else { SetLocalInt(oItem,"nWearing",nN); }
        } // tool fatigue needs to be defined
        SetLocalInt(oMe,"nProfState",14);
        break;
      } // Consume item
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
        DeleteLocalInt(oMe,"nProfConsumShiftStart");
        DeleteLocalInt(oMe,"nProfState");
        DeleteLocalInt(oMe,"bGNBProfessions");
        sS=GetLocalString(oMe,"sProfConsumToolTag");
        oItem=GetItemPossessedBy(oMe,sS);
        if (GetIsObjectValid(oItem)) AssignCommand(oMe,ActionUnequipItem(oItem));
        nN=GetLocalInt(oMe,"nProfConsumWage");
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
    if (nState!=14) DelayCommand(IntToFloat(nSpeed),ExecuteScript("npcact_p_consume",oMe));
  } // correct arguments were passed
  else { // error
    AssignCommand(oMe,SpeakString("ERROR: Consumer profession requires 1 and only 1 parameter which is the shift length!"));
  } // error
}
///////////////////////////////////////////////////////////////////////// MAIN

///////////////////////////
// FUNCTIONS
///////////////////////////
