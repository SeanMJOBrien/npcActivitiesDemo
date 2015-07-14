///////////////////////////////////////////////////////////////////////////////
// npcact_p_barmaid - NPC ACTIVITIES 6.0 Professions - BARMAID
// By Deva Bryson Winblood. 09/06/2004
// Modified by GuyDee Jan 4, 2005
// Modified by Deva Bryson Winblood: 2/02/2005
// modified to allow employees to sit with customers without ordering- peak 5/10
// Virtual Tags corrected peak 5/10
// NPC Action queue problems resolved peak 5/10
// Last modified 6/20/10 - Peak
//----------------------------------------------------------------------------
// This barmaid script is very complex and feature packed.  See the NPC
// ACTIVITIES documentation in the section on Professions for a complete
// description of all the things that you can get this script to do.
///////////////////////////////////////////////////////////////////////////////
#include "npcact_h_prof"
#include "npcact_h_cconv"
#include "npcact_h_money"
#include "npcact_h_core"
////////////////////////
// PROTOTYPES
////////////////////////

// PURPOSE: To cleanup all variables used by this script only
void fnBarmaidCleanup(object oNPC=OBJECT_SELF);

// PURPOSE: To handle the transaction where the NPC places the order
void fnNPCOrder(object oNPC,object oCustomer);

// PURPOSE: To handle the transaction where the PC places an order
void fnPCOrder(object oNPC,object oCustomer);

// PURPOSE: To handle the random moves of idle Barmaid
void fnIdleMove(object oDest);

////////////////////////////////////////////////////////////////////// MAIN
void main()
{
   object oMe=OBJECT_SELF;
   string sMyVirtualTag=fnGetNPCTag(oMe);
   object oWork=GetWaypointByTag(sMyVirtualTag+"_work_serve");
   object oBar=GetWaypointByTag(sMyVirtualTag+"_work_bar");
   object oKitchen=GetWaypointByTag(sMyVirtualTag+"_work_kitchen");
   object oCellar=GetWaypointByTag(sMyVirtualTag+"_work_cellar");
   object oWaitressTray=GetObjectByTag("WaitressTray");
   int nArgC=GetLocalInt(oMe,"nArgC");
   int nShift=GetLocalInt(oMe,"nProfBarShift");
   int nState=GetLocalInt(oMe,"nProfBarState");
   fnDebugInt("ProfBarState ",nState);
   int nSpeed=GetLocalInt(oMe,"nGNBStateSpeed");
   if(!nSpeed) nSpeed=GetLocalInt(GetModule(),"nGNBStateSpeed"); // 6/06/10 Peak
   if (nSpeed<1) nSpeed=6;
   int nN;
   int nCost;
   int nWhere;
   string sS;
   object oOb;
   object oCustomer;
   float fDelay; // for sits
   int bNoNPC=GetLocalInt(oMe,"bProfBarNONPC");
   int bNoPC=GetLocalInt(oMe,"bProfBarNOPC");
   int nCurrency=GetLocalInt(oMe,"nCurrency");
   int bCompleted=FALSE;
   int bProfBarCustomMenu=GetLocalInt(oMe,"bProfBarCustomMenu");

   // gd variables
   float fSpeed = IntToFloat(nSpeed);
   int bProfBarNoOldEnglish = GetLocalInt(oMe,"bProfBarNoOldEnglish");
   int bProfBarUseDefaultShoutAlso = GetLocalInt(oMe,"bProfBarUseDefaultShoutAlso"); //changed from ShoutToo peak 5/10
   int nProfBarShoutBar = GetLocalInt(oMe,"nProfBarShoutBar");
   int nProfBarShoutKitchen = GetLocalInt(oMe,"nProfBarShoutKitchen");
   int nProfBarShoutCellar = GetLocalInt(oMe,"nProfBarShoutCellar");
   int nProfBarRespBar = GetLocalInt(oMe,"nProfBarRespBar");
   int nProfBarRespKitchen = GetLocalInt(oMe,"nProfBarRespKitchen");
   int nProfBarRespCellar = GetLocalInt(oMe,"nProfBarRespCellar");
   string sProfBarTalkToBar = GetLocalString(oMe,"sProfBarTalkToBar");            // to identify employees if sitting peak 5/10
   string sProfBarTalkToKitchen = GetLocalString(oMe,"sProfBarTalkToKitchen");
   string sProfBarTalkToCellar = GetLocalString(oMe,"sProfBarTalkToCellar");
   // gd variables

   SetLocalInt(oMe,"bGNBProfessions",TRUE);
   SetLocalInt(oMe,"nGNBProfProc",1);
   SetLocalInt(oMe,"nGNBProfFail",3+nSpeed);


   fnDebug("npcact_p_barmaid entered");
   if (nArgC==1&&oWork!=OBJECT_INVALID)
   { // proper arguments were passed
     nN=StringToInt(GetLocalString(oMe,"sArgV1"));
     if (nShift<=nN)
     { // still have shifts left
       if (IsInConversation(oMe)==FALSE&&GetIsInCombat(oMe)==FALSE)
       { // not talking or fighting
         switch(nState)
         { // Barmaid state switch
           case 0: { // seek work area
            if (GetArea(oMe)!=GetArea(oWork)||GetDistanceBetween(oWork,oMe)>3.0)
            { // move to work area
              nN=fnMoveToDestination(oMe,oWork);
            } // move to work area
            else { SetLocalInt(oMe,"nProfBarState",1); }
            break;
           } // seek work area


           case 1: { // look for people sitting
             nN=1;
             oOb=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nN,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
             oCustomer=OBJECT_INVALID;
             while(oCustomer==OBJECT_INVALID&&oOb!=OBJECT_INVALID)
             { // check people
               if (GetIsPC(oOb)==TRUE&&bNoPC!=TRUE&&GetLocalInt(oOb,"bProfBarHasOrdered"+sMyVirtualTag)!=TRUE&&GetCurrentAction(oOb)==ACTION_SIT&&IsInConversation(oOb)==FALSE&&GetIsInCombat(oOb)==FALSE)
               { oCustomer=oOb; }
               else if (GetIsPC(oOb)==FALSE&&bNoNPC!=TRUE&&GetLocalInt(oOb,"bProfBarHasOrdered"+sMyVirtualTag)!=TRUE&&GetCurrentAction(oOb)==ACTION_SIT&&IsInConversation(oOb)==FALSE&&GetIsInCombat(oOb)==FALSE)
               { oCustomer=oOb; }
               sS=GetTag(oCustomer);//added so that designated barkeep, cook, cellarer or other barmaid may sit and not be customers - peak 5/10
               if ((oCustomer==OBJECT_INVALID)||(sS==sProfBarTalkToBar)||(sS==sProfBarTalkToKitchen)||(sS==sProfBarTalkToCellar)||(fnGetNPCTag(oCustomer)==fnGetNPCTag(oMe))) // original if (oCustomer==OBJECT_INVALID)
               { // next person
                 oCustomer=OBJECT_INVALID;   //invalidate employees
                 nN++;
                 oOb=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nN,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
               } // next person
             } // check people
             if (oCustomer!=OBJECT_INVALID)
             { // found customer
               SetLocalObject(oMe,"oProfBarCustomer",oCustomer);
               SetLocalInt(oMe,"nProfBarState",2);
             } // found customer
             else
             { // did not see anyone
               nN=d6();
               if (nN==1)
               { // wander gd changes for more variety and stick with heartbeat ie fSpeed
                 oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oMe,d8());
                 if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oMe,d4());
                 if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,oMe,d4());
                 if (oOb!=OBJECT_INVALID)
                 { // move to
                   fnDebug("Barmaid moving to "+GetTag(oOb));  //5/10 etc
                   /*AssignCommand(oMe,ActionMoveToObject(oOb,FALSE));
                   DelayCommand((fSpeed - 0.5),AssignCommand(oMe,ClearAllActions()));
                   DelayCommand((fSpeed - 0.4),AssignCommand(oMe,ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT,1.0,3.0)));
                   DelayCommand((fSpeed - 0.3),AssignCommand(oMe,ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT,1.0,3.0))); */
                   fnIdleMove(oOb);
                 } // move to
               } // wander
               else if (nN==2)
               { // wander
                 oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,oMe,d8());
                 if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,oMe,d4());
                 if (oOb==OBJECT_INVALID) oOb=GetNearestObject(OBJECT_TYPE_WAYPOINT,oMe,d4());
                 if (oOb!=OBJECT_INVALID)
                 { // move to
                   fnDebug("Barmaid moving to "+GetTag(oOb));
                   fnIdleMove(oOb);
                 } // move to
               }
               else if (nN==3)
               { // laugh
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0,5.0));
               } // laugh
               else if (nN==4)
               { // scratch head
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD,1.0,3.0));
               } // scratch head
               else if (nN==5&&d2()==1)   // MODIFY d# to reduce chance of sitting, higher#=fewer times
               { // sits with customers
                 fDelay=fnNPCACTSitForSpecified("SITS-05"); // added action peak 5/10
               } // sits
               else
               { // back to state 0
                 SetLocalInt(oMe,"nProfBarState",0);
               } // back to state 0
             } // did not see anyone
             break;
           } // look for people sitting



           case 2: { // approach person
             oCustomer=GetLocalObject(oMe,"oProfBarCustomer");
             if (GetDistanceBetween(oMe,oCustomer)>2.5&&GetArea(oCustomer)==GetArea(oMe))
             { // move towards customer
               nN=fnMoveToDestination(oMe,oCustomer);
             } // move towards customer
             else if (GetArea(oCustomer)!=GetArea(oMe))
             { // customer left
               SetLocalInt(oMe,"nProfBarState",1);
             } // customer left
             else
             { // time to place order
               if (GetIsPC(oCustomer)==TRUE) { SetLocalInt(oMe,"nProfBarState",4); }
               else { SetLocalInt(oMe,"nProfBarState",3); }
               AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,8.0));
             } // time to place order
             break;
           } // approach person



           case 3: { // handle NPC order
             oCustomer=GetLocalObject(oMe,"oProfBarCustomer");
             if (GetLocalInt(oCustomer,"bProfBarHasOrdered"+sMyVirtualTag)!=TRUE)
             { // order not placed
               nSpeed=6;
               fnNPCOrder(oMe,oCustomer);
               AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,8.0));
             } // order not placed
             else
             { // order placed
               if (GetStringLength(GetLocalString(oMe,"sProfBarOrderName"))>0)
               { // an order was given
                 nN=GetLocalInt(oMe,"nProfBarOrderWhere");
                 if (nN==0)
                 { // has the item
                   SetLocalInt(oMe,"nProfBarState",13);
                 } // has the item
                 else if (nN==1)
                 { // kitchen
                   SetLocalInt(oMe,"nProfBarState",6);
                 } // kitchen
                 else if (nN==2)
                 { // bar
                   SetLocalInt(oMe,"nProfBarState",5);
                 } // bar
                 else if (nN==3)
                 { // cellar
                   SetLocalInt(oMe,"nProfBarState",7);
                 } // cellar
               } // an order was given
               else
               { // no order placed
                 nShift++;
                 SetLocalInt(oMe,"nProfBarShift",nShift);
                 SetLocalInt(oMe,"nProfBarState",1);
               } // no order placed
             } // order placed
             break;
           } // handle NPC order



           case 4: { // handle PC order
             oCustomer=GetLocalObject(oMe,"oProfBarCustomer");
             if (GetLocalInt(oCustomer,"bProfBarHasOrdered"+sMyVirtualTag)!=TRUE)
             { // order not placed
               fnPCOrder(oMe,oCustomer);
               AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,8.0));
             } // order not placed
             else
             { // order placed
               if (GetStringLength(GetLocalString(oMe,"sProfBarOrderName"))>0)
               { // an order was given
                 nN=GetLocalInt(oMe,"nProfBarOrderWhere");
                 if (nN==0)
                 { // has the item
                   SetLocalInt(oMe,"nProfBarState",13);
                 } // has the item
                 else if (nN==1)
                 { // kitchen
                   SetLocalInt(oMe,"nProfBarState",6);
                 } // kitchen
                 else if (nN==2)
                 { // bar
                   SetLocalInt(oMe,"nProfBarState",5);
                 } // bar
                 else if (nN==3)
                 { // cellar
                   SetLocalInt(oMe,"nProfBarState",7);
                 } // cellar
                 TakeCoins(oCustomer,GetLocalInt(oMe,"nProfBarOrderCost"),"ANY",nCurrency,TRUE);
               } // an order was given
               else
               { // no order placed
                 nShift++;
                 SetLocalInt(oMe,"nProfBarShift",nShift);
               } // no order placed
             } // order placed
             break;
           } // handle PC order



           case 5: { // go to bar
             if (oBar!=OBJECT_INVALID)
             { // there is a bar waypoint
               if (GetArea(oBar)!=GetArea(oMe)||GetDistanceBetween(oBar,oMe)>3.0)
               { // move
                 nN=fnMoveToDestination(oMe,oBar);
               } // move
               else { // arrived
                 SetLocalInt(oMe,"nProfBarState",8);
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,8.0));
               } // arrived
             } // there is a bar waypoint
             else
             { // error
               AssignCommand(oMe,SpeakString("ERROR: I cannot find the bar waypoint for *barmaid profession!"));
               SetLocalInt(oMe,"nProfBarState",11);
             } // error
             break;
           } // go to bar



           case 6: { // go to kitchen
             if (oKitchen!=OBJECT_INVALID)
             { // there is a kitchen waypoint
               if (GetArea(oKitchen)!=GetArea(oMe)||GetDistanceBetween(oKitchen,oMe)>3.0)
               { // move
                 nN=fnMoveToDestination(oMe,oKitchen);
               } // move
               else { // arrived
                 SetLocalInt(oMe,"nProfBarState",9);
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,12.0));
               } // arrived
             } // there is a kitchen waypoint
             else
             { // error
               AssignCommand(oMe,SpeakString("ERROR: I cannot find the kitchen waypoint for *barmaid profession!"));
               SetLocalInt(oMe,"nProfBarState",11);
             } // error
             break;
           } // go to kitchen



           case 7: { // go to cellar
             if (oCellar!=OBJECT_INVALID)
             { // there is a cellar waypoint
               if (GetArea(oCellar)!=GetArea(oMe)||GetDistanceBetween(oCellar,oMe)>3.0)
               { // move
                 nN=fnMoveToDestination(oMe,oCellar);
               } // move
               else
               { // arrived
                 SetLocalInt(oMe,"nProfBarState",10);
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,12.0));
               } // arrived
             } // there is a cellar waypoint
             else
             { // error
               AssignCommand(oMe,SpeakString("ERROR: I cannot find the cellar waypoint for *barmaid profession!"));
               SetLocalInt(oMe,"nProfBarState",11);
             } // error
             break;
           } // go to cellar



           case 8: { // shout order bar
             if (GetStringLength(sProfBarTalkToBar)>0)     //now not local string on oMe peak 5/10
             { // someone to talk to gd added sight check and distance check
               oOb=GetNearestObjectByTag(sProfBarTalkToBar,oMe,1);
               if (oOb!=OBJECT_INVALID&&!GetIsDead(oOb)&&GetObjectSeen(oOb,oMe)&&GetDistanceBetween(oOb,oMe) < 12.0)
               { // person to talk to found
                 AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING,1.0,3.0));

                 // gd added multiple custom shouts with or without the defaults
                 sS=GetLocalString(oMe,"sProfBarShoutBar" + IntToString(Random(nProfBarShoutBar)+1));
                 if (nProfBarShoutBar < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultShoutAlso && (Random(nProfBarShoutBar+5) > nProfBarShoutBar)))
                 { // no shout string specified or we may use defaults as well
                   nN=d8();
                   if (nN==1) sS="<FN>!  I have an order for"; //corPeak
                   else if (nN==2) sS="Wake up "+GetName(oOb)+"! There is an order for";
                   else if (nN==3) sS="<FN>, could you give me an order of";
                   else if (nN==4) sS="I need an order of";
                   else if (nN==5 || nN==6) sS="One order of";
                   else sS="An order of";
                 } // no shout string specified or we may use defaults as well

                 sS=sS+" "+GetLocalString(oMe,"sProfBarOrderName")+".";
                 sS=fnConvHandleTokens(oMe,oOb,sS);
                 if (GetLocalInt(oMe,"nSpeakLanguage")>0)
                 { // speak odd language
                   fnConvClearConv(oMe,oOb);
                   sS=IntToString(GetLocalInt(oMe,"nSpeakLanguage"))+".NA.NA."+sS;
                   AssignCommand(oMe,ActionStartConversation(oOb,"npcact_custom",FALSE,FALSE));
                 } // speak odd language
                 else
                 { // normal shout
                   AssignCommand(oMe,SpeakString(sS));
                 } // normal shout


                 sS=GetLocalString(oMe,"sProfBarRespBar" + IntToString(Random(nProfBarRespBar)+1));
                 if (nProfBarRespBar < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultShoutAlso && (Random(nProfBarRespBar+5) > nProfBarRespBar)))
                 { // no custom bar response or we may use defaults as well
                   nN=d8();
                   if (nN==1) sS="Okay, I'm getting it!";
                   else if (nN==2) sS="You take your job too seriously "+GetName(oMe)+".";
                   else if (nN==3) sS="I heard you already!";
                   else if (nN==4) sS="Give me just a minute.";
                   else if (nN==5) sS="Here you go!";
                   else if (nN==6) sS="<MFN>! Here you go.";
                   else sS="Coming up!";
                 } // no custom bar response or we may use defaults as well

                 sS=fnConvHandleTokens(oMe,oOb,sS);
                 DelayCommand(3.0,AssignCommand(oOb,SpeakString(sS)));
               } // person to talk to found
             } // someone to talk to
             AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,0.5,8.0));
             SetLocalInt(oMe,"nProfBarState",11);
             break;
           } // shout order bar



           case 9: { // shout order kitchen
             if (GetStringLength(sProfBarTalkToKitchen)>0)
             { // someone to talk to
               oOb=GetNearestObjectByTag(sProfBarTalkToKitchen,oMe,1);
               if (oOb!=OBJECT_INVALID&&!GetIsDead(oOb)&&GetObjectSeen(oOb,oMe)&&GetDistanceBetween(oOb,oMe) < 8.0)
               { // person to talk to found
                 AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING,1.0,3.0));

                 // gd added multiple custom shouts with or without the defaults
                 sS=GetLocalString(oMe,"sProfBarShoutKitchen" + IntToString(Random(nProfBarShoutKitchen)+1));
                 if (nProfBarShoutKitchen < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultShoutAlso && (Random(nProfBarShoutKitchen+5) > nProfBarShoutKitchen)))
                 { // no shout string specified or we may use defaults as well
                   nN=d8();
                   if (nN==1) sS="<FN>!  I have an order for";  //corPeak
                   else if (nN==2) sS="Wake up "+GetName(oOb)+"! There is an order for";
                   else if (nN==3) sS="<FN>, could you give me an order of";
                   else if (nN==4) sS="I need an order of";
                   else if (nN==5 || nN==6) sS="One order of";
                   else sS="An order of";
                 } // no shout string specified or we may use defaults as well

                 sS=sS+" "+GetLocalString(oMe,"sProfBarOrderName")+".";
                 sS=fnConvHandleTokens(oMe,oOb,sS);
                 if (GetLocalInt(oMe,"nSpeakLanguage")>0)
                 { // speak odd language
                   fnConvClearConv(oMe,oOb);
                   sS=IntToString(GetLocalInt(oMe,"nSpeakLanguage"))+".NA.NA."+sS;
                   AssignCommand(oMe,ActionStartConversation(oOb,"npcact_custom",FALSE,FALSE));
                 } // speak odd language
                 else
                 { // normal shout
                   AssignCommand(oMe,SpeakString(sS));
                 } // normal shout

                 sS=GetLocalString(oMe,"sProfBarRespKitchen" + IntToString(Random(nProfBarRespKitchen)+1));
                 if (nProfBarRespKitchen < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultShoutAlso && (Random(nProfBarRespKitchen+5) > nProfBarRespKitchen)))
                 { // no custom kitchen response or we may use defaults as well
                   nN=d8();
                   if (nN==1) sS="Okay, I'm getting it!";
                   else if (nN==2) sS="You take your job too seriously "+GetName(oMe)+".";
                   else if (nN==3) sS="I heard you already!";
                   else if (nN==4) sS="Give me just a minute.";
                   else if (nN==5) sS="Here you go!";
                   else if (nN==6) sS="Here you go.";
                   else sS="Coming up!";
                 } // no custom kitchen response or we may use defaults as well

                 sS=fnConvHandleTokens(oMe,oOb,sS);
                 DelayCommand(3.0,AssignCommand(oOb,SpeakString(sS)));
               } // person to talk to found
             } // someone to talk to
             AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,0.5,12.0));
             SetLocalInt(oMe,"nProfBarState",11);
             break;
           } // shout order kitchen


           case 10: { // shout order cellar
             if (GetStringLength(sProfBarTalkToCellar)>0)
             { // someone to talk to
               oOb=GetNearestObjectByTag(sProfBarTalkToCellar,oMe,1);
               if (oOb!=OBJECT_INVALID&&!GetIsDead(oOb)&&GetObjectSeen(oOb,oMe)&&GetDistanceBetween(oOb,oMe) < 12.0)
               { // person to talk to found
                 AssignCommand(oMe,SetFacingPoint(GetPosition(oOb)));
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING,1.0,3.0));

                 // gd added multiple custom shouts with or without the defaults
                 sS=GetLocalString(oMe,"sProfBarShoutCellar" + IntToString(Random(nProfBarShoutCellar)+1));
                 if (nProfBarShoutCellar < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultShoutAlso && (Random(nProfBarShoutCellar+5) > nProfBarShoutCellar)))
                 { // no shout string specified or we may use defaults as well
                   nN=d8();
                   if (nN==1) sS="<FN>!  I have an order for";  //corPeak
                   else if (nN==2) sS="Wake up "+GetName(oOb)+"! There is an order for";
                   else if (nN==3) sS="<FN>, could you give me an order of";
                   else if (nN==4) sS="I need an order of";
                   else if (nN==5 || nN==6) sS="One order of";
                   else sS="An order of";
                 } // no shout string specified or we may use defaults as well

                 sS=sS+" "+GetLocalString(oMe,"sProfBarOrderName")+".";
                 sS=fnConvHandleTokens(oMe,oOb,sS);
                 if (GetLocalInt(oMe,"nSpeakLanguage")>0)
                 { // speak odd language
                   fnConvClearConv(oMe,oOb);
                   sS=IntToString(GetLocalInt(oMe,"nSpeakLanguage"))+".NA.NA."+sS;
                   AssignCommand(oMe,ActionStartConversation(oOb,"npcact_custom",FALSE,FALSE));
                 } // speak odd language
                 else
                 { // normal shout
                   AssignCommand(oMe,SpeakString(sS));
                 } // normal shout

                 sS=GetLocalString(oMe,"sProfBarRespCellar" + IntToString(Random(nProfBarRespCellar)+1));
                 if (nProfBarRespCellar < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultShoutAlso && (Random(nProfBarRespCellar+5) > nProfBarRespCellar)))
                 { // no custom Cellar response or we may use defaults as well
                   nN=d8();
                   if (nN==1) sS="Okay, I'm getting it!";
                   else if (nN==2) sS="You take your job too seriously "+GetName(oMe)+".";
                   else if (nN==3) sS="I heard you already!";
                   else if (nN==4) sS="Give me just a minute.";
                   else if (nN==5) sS="Here you go!";
                   else if (nN==6) sS="Here you go.";
                   else sS="Coming up!";
                 } // no custom Cellar response or we may use defaults as well

                 sS=fnConvHandleTokens(oMe,oOb,sS);
                 DelayCommand(3.0,AssignCommand(oOb,SpeakString(sS)));
               } // person to talk to found
             } // someone to talk to
             AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,0.5,8.0));
             SetLocalInt(oMe,"nProfBarState",11);
             break;
           } // shout order cellar

           case 11: { //equip tray
             ActionEquipItem(oWaitressTray,INVENTORY_SLOT_LEFTHAND);
             SetLocalInt(oMe,"nProfBarState",12);
             break;
           } //equip tray

           case 12: { // return to customer
             oCustomer=GetLocalObject(oMe,"oProfBarCustomer");
             if (GetIsObjectValid(oCustomer)==FALSE||GetIsDead(oCustomer)==TRUE)
             { // customer no longer valid
               DeleteLocalInt(oMe,"oCustomer");
               DeleteLocalInt(oMe,"nProfBarOrderCost");
               DeleteLocalInt(oMe,"nProfBarOrderWhere");
               DeleteLocalString(oMe,"sProfBarOrderName");
               DeleteLocalString(oMe,"sProfBarOrderRes");
               SetLocalInt(oMe,"nProfBarState",1);
               oCustomer=OBJECT_INVALID;
             } // customer no longer valid
             if (GetArea(oMe)!=GetArea(oCustomer)||GetDistanceBetween(oMe,oCustomer)>2.5)
             { // return to customer
               nN=fnMoveToDestination(oMe,oCustomer);
             } // return to customer
             else if (oCustomer!=OBJECT_INVALID) { SetLocalInt(oMe,"nProfBarState",13); }
             break;
           } // return to customer



           case 13: { // give customer their order
             oCustomer=GetLocalObject(oMe,"oProfBarCustomer");
             AssignCommand(oMe,SetFacingPoint(GetPosition(oCustomer)));
             AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,0.5,4.0));
             if (GetIsPC(oCustomer)==FALSE)
             { // NPC Customer
               sS="Here is your order of "+GetLocalString(oMe,"sProfBarOrderName")+" <#psir/ma'am>.";
               sS=fnConvHandleTokens(oMe,oCustomer,sS);
               TakeCoins(oCustomer,GetLocalInt(oMe,"nProfBarOrderCost"),"ANY",nCurrency,TRUE);
               if (GetLocalInt(oMe,"nSpeakLanguage")>0)
               { // speak in an alternate language
                 fnConvClearConv(oMe,oCustomer);
                 sS=IntToString(GetLocalInt(oMe,"nSpeakLanguage"))+".NA.!29_3."+sS;
                 AssignCommand(oMe,ActionStartConversation(oCustomer,"npcact_custom",FALSE,FALSE));
               } // speak in an alternate language
               else
               { // speak normal
                 AssignCommand(oMe,SpeakString(sS));
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,3.0));
               } // speak normal
               if (GetLocalInt(oMe,"nProfBarGiveItemNPC")==TRUE)
               { // give the NPC the item
                 oOb=CreateItemOnObject(GetLocalString(oMe,"sProfBarOrderRes"),oCustomer,1);
               } // give the NPC the item
               nN=d4();
               sS="";
               if (nN==3){
                   if (bProfBarNoOldEnglish) sS="Why, I kindly thank you, <#psir/ma'am>.";
                   else sS="Why, thank thee kindly, <#plad/lass>.";
               }
               else if (nN==4) {
                    if (bProfBarNoOldEnglish) sS="Thank you.";
                    else sS="Thank thee.";
               }
               if (nN>2)
               { // speak thank you
                 sS=fnConvHandleTokens(oCustomer,oMe,sS);
                 DelayCommand(3.0,AssignCommand(oCustomer,SpeakString(sS)));
               } // speak thank you
               if (GetLocalInt(oMe,"nProfBarOrderWhere")==2)
               { // drink
                 DelayCommand(8.0,AssignCommand(oCustomer,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0,3.0)));
               } // drink
             } // NPC Customer
             else
             { // PC Customer
               sS="Here is your order of "+GetLocalString(oMe,"sProfBarOrderName")+" <#psir/madam>.";
               sS=fnConvHandleTokens(oMe,oCustomer,sS);
               if (GetLocalInt(oMe,"nSpeakLanguage")>0)
               { // speak in an alternate language
                 fnConvClearConv(oMe,oCustomer);
                 sS=IntToString(GetLocalInt(oMe,"nSpeakLanguage"))+".NA.!29_3."+sS;
                 AssignCommand(oMe,ActionStartConversation(oCustomer,"npcact_custom",FALSE,FALSE));
               } // speak in an alternate language
               else
               { // speak normal
                 AssignCommand(oMe,SpeakString(sS));
                 AssignCommand(oMe,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,3.0));
               } // speak normal
               sS=GetLocalString(oMe,"sProfBarOrderRes");
               if (GetStringLeft(sS,1)!="@"&&GetStringLeft(sS,1)!="$")
               { // good old fashioned item
                 oOb=CreateItemOnObject(sS,oCustomer);
               } // good old fashioned item
               else if (GetStringLeft(sS,1)=="@")
               { // execute script
                 ExecuteScript(GetStringRight(sS,GetStringLength(sS)-1),oMe); // npc executes script
               } // execute script
               else if (GetStringLeft(sS,1)=="$")
               { // open store
                 sS=GetStringRight(sS,GetStringLength(sS)-1);
                 oOb=GetNearestObjectByTag(sS,oMe,1);
                 if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_STORE)
                 { // open store
                   OpenStore(oOb,oCustomer);
                 } // open store
               } // open store
             } // PC Customer
             nN=GetLocalInt(oMe,"nProfBarGold"); // what to do with gold
             nCost=GetLocalInt(oMe,"nProfBarOrderCost"); // how much did it cost
             nWhere=GetLocalInt(oMe,"nProfBarOrderWhere"); // where get order from
             if (nN==1&&nCost>0)
             { // give gold to cook, barkeep, or cellar
               if (nWhere==1)
               { // cook
                 sS=GetLocalString(oMe,"sProfBarTalkToKitchen");
                 oOb=GetObjectByTag(sS);
                 if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
                 { // valid person
                   GiveCoins(oOb,nCost,"ANY",nCurrency);
                 } // valid person
               } // cook
               else if (nWhere==2)
               { // bar
                 sS=GetLocalString(oMe,"sProfBarTalkToBar");
                 oOb=GetObjectByTag(sS);
                 if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
                 { // valid person
                   GiveCoins(oOb,nCost,"ANY",nCurrency);
                 } // valid person
               } // bar
               else if (nWhere==3)
               { // cellar
                 sS=GetLocalString(oMe,"sProfBarTalkToCellar");
                 oOb=GetObjectByTag(sS);
                 if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
                 { // valid person
                   GiveCoins(oOb,nCost,"ANY",nCurrency);
                 } // valid person
               } // cellar
             } // give gold to cook, barkeep, or cellar
             else if (nN==2&&nCost>0)
             { // keep 1 gold
               GiveCoins(oMe,1,"ANY",nCurrency);
             } // keep 1 gold
             else if (nN==3&&nCost>0)
             { // keep all gold
               GiveCoins(oMe,nCost,"ANY",nCurrency);
             } // keep all gold
             else if (nN==4&&nCost>0)
             { // keep 1 and give rest to cook, barkeep, or cellar
               GiveCoins(oMe,1,"ANY",nCurrency);
               nCost=nCost-1;
               if (nWhere==1)
               { // cook
                 sS=GetLocalString(oMe,"sProfBarTalkToKitchen");
                 oOb=GetObjectByTag(sS);
                 if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
                 { // valid person
                   GiveCoins(oOb,nCost,"ANY",nCurrency);
                 } // valid person
               } // cook
               else if (nWhere==2)
               { // bar
                 sS=GetLocalString(oMe,"sProfBarTalkToBar");
                 oOb=GetObjectByTag(sS);
                 if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
                 { // valid person
                   GiveCoins(oOb,nCost,"ANY",nCurrency);
                 } // valid person
               } // bar
               else if (nWhere==3)
               { // cellar
                 sS=GetLocalString(oMe,"sProfBarTalkToCellar");
                 oOb=GetObjectByTag(sS);
                 if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_CREATURE)
                 { // valid person
                   GiveCoins(oOb,nCost,"ANY",nCurrency);
                 } // valid person
               } // cellar
             } // keep 1 and give rest to cook, barkeep, or cellar
             else if (nN==5&&nCost>0)
             { // place gold in a chest
               sS=GetLocalString(oMe,"sProfBarGoldChest");
               oOb=GetObjectByTag(sS);
               if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_PLACEABLE)
               { // valid chest
                 CreateItemOnObject("nw_it_gold001",oOb,nCost);
               } // valid chest
             } // place gold in a chest
             else if (nN==6&&nCost>0)
             { // keep 1 and place the rest in a chest
               GiveCoins(oMe,1,"ANY",nCurrency);
               nCost=nCost-1;
               sS=GetLocalString(oMe,"sProfBarGoldChest");
               oOb=GetObjectByTag(sS);
               if (GetIsObjectValid(oOb)&&GetObjectType(oOb)==OBJECT_TYPE_PLACEABLE&&nCost>0)
               { // valid chest
                 CreateItemOnObject("nw_it_gold001",oOb,nCost);
               } // valid chest
             } // keep 1 and place the rest in a chest
             DeleteLocalObject(oMe,"oProfBarCustomer");
             DeleteLocalInt(oMe,"nProfBarOrderCost");
             DeleteLocalInt(oMe,"nProfBarOrderWhere");
             DeleteLocalString(oMe,"sProfBarOrderName");
             DeleteLocalString(oMe,"sProfBarOrderRes");
             SetLocalInt(oMe,"nProfBarState",1);
             nShift++;
             SetLocalInt(oMe,"nProfBarShift",nShift);
             ActionUnequipItem(oWaitressTray);
             break;
           } // give customer their order


           case 14: { // pause state
             break;
           } // pause state


           default: { SetLocalInt(oMe,"nProfBarState",0); break; }
         } // barmaid state switch
       } // not talking or fighting
     } // still have shifts left
     else
     { // completed shift
       bCompleted=TRUE;
       if (GetLocalInt(oMe,"nProfBarPay")>0)
       { // pay the barmaid
         GiveCoins(oMe,GetLocalInt(oMe,"nProfBarPay"),"ANY",nCurrency);
       } // pay the barmaid
     } // completed shift
   } // proper arguments were passed
   else if (nArgC!=1)
   { // improper number of arguments
     AssignCommand(oMe,SpeakString("ERROR: improper arguments *barmaid/#shifts"));
     bCompleted=TRUE;
   } // improper number of arguments
   else
   { // missing work waypoint
     AssignCommand(oMe,SpeakString("ERROR: barmaid profession requires '"+sMyVirtualTag+"_work_serve' waypoint at a minimum!"));
     bCompleted=TRUE;
   } // missing work waypoint
   fnDebug("  p_barmaid state:"+IntToString(nState));
   if (bCompleted)
   { // this profession is done
     fnDebug("  p_barmaid has completed.");
     fnPROFCleanupArgs(oMe);
     SetLocalInt(oMe,"bGNBProfessions",FALSE);
     fnBarmaidCleanup(oMe);
   } // this profession is done
   else
   { // delay for next round
     fnDebug("  call next p_barmaid "+IntToString(nSpeed));
     DelayCommand(IntToFloat(nSpeed),ExecuteScript("npcact_p_barmaid",oMe));
   } // delay for next round
   fnDebug("npcact_p_barmaid exit");
}
////////////////////////////////////////////////////////////////////// MAIN







////////////////////////
// FUNCTIONS
////////////////////////

void fnBarmaidCleanup(object oNPC=OBJECT_SELF)
{ // PURPOSE: To cleanup all variables used by this script only
  DeleteLocalInt(oNPC,"nProfBarShift");
  DeleteLocalInt(oNPC,"nProfBarState");
  DeleteLocalObject(oNPC,"oProfBarCustomer");
  fnPROFCleanupArgs();
} // fnBarmaidCleanup()

void fnIdleMove(object oDest)
{ // PURPOSE: To handle idle movement of Barmaid
    ActionMoveToObject(oDest);
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT,1.0,3.0);
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT,1.0,3.0);
    DelayCommand(12.0,SetCommandable(TRUE));
    SetCommandable(FALSE);
} //fnIdleMove

void fnNPCOrder(object oNPC,object oCustomer)
{ // PURPOSE: To handle the order transaction with an NPC
  int nCurrency=GetLocalInt(oNPC,"nCurrency");
  int nGold=GetWealth(oCustomer,nCurrency);
  int nR;
  string sS;
  string sOrder="";
  int nCost=0;
  int nCheapest=1000;
  int nCount=0;
  int nWhere=0;
  string sRes;
  SetLocalInt(oCustomer,"bProfBarHasOrdered"+fnGetNPCTag(oNPC),TRUE);    //corPeak
  DelayCommand(240.0,DeleteLocalInt(oCustomer,"bProfBarHasOrdered"+fnGetNPCTag(oNPC)));  //corPeak
  AssignCommand(oNPC,SetFacingPoint(GetPosition(oCustomer)));

  //gd header setup //////////////////////////
  int nProfBarMenuHeader = GetLocalInt(oNPC,"nProfBarMenuHeader");
  int nProfBarGreetTag = GetLocalInt(oCustomer,"nProfBarGreet" + GetTag(oNPC));   //orig prestored value, can't be Virtual Tag
  int bProfBarUseDefaultHeaderAlso = GetLocalInt(oNPC,"bProfBarUseDefaultHeaderAlso");
  int bProfBarNoOldEnglish = GetLocalInt(oNPC,"bProfBarNoOldEnglish");
  fnDebug("   nProfBarGreetTag " + IntToString(nProfBarGreetTag) + " for " + GetName(oCustomer)
          + " nProfBarGreet" + GetTag(oNPC));   //orig

  // First time welcome
  if(!GetLocalInt(oCustomer,"bProfBarDidGreet"+fnGetNPCTag(oNPC))&&GetStringLength(GetLocalString(oNPC,"sProfBarMenuFirst"))>0)  //corPeak
  {
        sS= GetLocalString(oNPC,"sProfBarMenuFirst");
        SetLocalInt(oCustomer, "bProfBarDidGreet" + fnGetNPCTag(oNPC), TRUE);  //corPeak
  }
  // Custom or default welcome on Customer
  else if (nProfBarGreetTag > 0)
  {
        sS=GetLocalString(oCustomer,"sProfBarGreet" + GetTag(oNPC)+ IntToString(Random(nProfBarGreetTag)+1));  //orig
        fnDebug("Possible Custom Customer Greeting: " + sS);
        if (GetStringLength(sS)<1 || (bProfBarUseDefaultHeaderAlso && (Random(nProfBarGreetTag+1) == nProfBarGreetTag)))
        {
            fnDebug("No Custom Customer Greet");
            sS=GetLocalString(oNPC,"sProfBarMenuHeader" + IntToString(Random(nProfBarMenuHeader)+1));
            if (nProfBarMenuHeader < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultHeaderAlso && (Random(nProfBarMenuHeader+1) == nProfBarMenuHeader)))
            { // no custom header provided or we may use defaults as well
                if (nGold<5 && d2()==1)
                {
                    if (bProfBarNoOldEnglish) sS="Well, is there anythin' I CAN get you!";
                    else sS="Well, is there anythin' thou needst?";
                }
                else
                {
                    if (bProfBarNoOldEnglish) sS="<pSM>, can I be gettin' anythin' for you?";
                    else sS="<pSM>, can I be gettin' anythin' for thee?";
                }
            } // no custom header provided or we may use defaults as well
        }
   }
  // Custom or default welcome on Waitress
  else
  {
        sS=GetLocalString(oNPC,"sProfBarMenuHeader" + IntToString(Random(nProfBarMenuHeader)+1));
        if (nProfBarMenuHeader < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultHeaderAlso && (Random(nProfBarMenuHeader+1) == nProfBarMenuHeader)))
        { // no custom header provided or we may use defaults as well
                if (nGold<5 && d2()==1)
                {
                    if (bProfBarNoOldEnglish) sS="Well <#pdolt/witch> is there anythin' I CAN get you!";
                    else sS="Well <pI3>, is there anythin' thou needst?";
                }
                else
                {
                    if (bProfBarNoOldEnglish) sS="<pSM>, can I be gettin' anythin' for you?";
                    else sS="<pSM>, can I be gettin' anythin' for thee?";
                }
        } // no custom header provided or we may use defaults as well
   }
    sS=fnConvHandleTokens(oNPC,oCustomer,sS);
    if (GetLocalInt(oNPC,"nSpeakLanguage")>0)
    { // speak another language
      fnConvClearConv(oNPC,oCustomer);
      sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+".NA.!29_3."+sS;
      AssignCommand(oNPC,ActionStartConversation(oCustomer,"npcact_custom",FALSE,FALSE));
    } // speak another language
    else
    { // speak normal language
      AssignCommand(oNPC,SpeakString(sS));
      AssignCommand(oNPC,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,4.0));
    } // speak normal language

 //gd end //////////


  if (GetLocalInt(oNPC,"bProfBarCustomMenu")==FALSE)
  { // standard menu--------------------------------------------------------
    sS="";
    if (nGold<2) { // not enough gold
      nR=d4();
      if (bProfBarNoOldEnglish)
      {
        if (nR==1) sS="Nah, I thank you kindly <#psir/ma'am> but, I'm just fine at the moment.";
        else if (nR==2) sS="I don't think ya operate on credit and my gold is a bit low at the moment.";
        else if (nR==3) sS="Not now.";
        else if (nR==4) sS="Nothin' from the menu but, a <pWM> like you, surely has a story or two to share.";
      }
      else
      {
        if (nR==1) sS="Nah, thank'e kindly <#plad/lass> but, I be just fine at the moment.";
        else if (nR==2) sS="I don't thinks ye operates on credit and me gold is a might bit low at the moment.";
        else if (nR==3) sS="Not now.";
        else if (nR==4) sS="Nothin' from the menu but, a <pWM> like'e surely has a story or two to share.";
      }
    } // not enough gold
    else if (nGold<4)
    { // fish or ale only
      nR=d4();
      if (bProfBarNoOldEnglish)
      {
        if (nR==1) { sS="I'll have a bit of fish if you would be so kind."; sOrder="fish"; nCost=2; nWhere=1; sRes="nw_it_msmlmisc20"; }
        else { sS="I'd like some ale <#psir/ma'am>."; sOrder="ale"; nCost=2; nWhere=2; sRes="nw_it_mpotion021"; }
      }
      else
      {
        if (nR==1) { sS="I'll have a bit of fish if ye would be so kind."; sOrder="fish"; nCost=2; nWhere=1; sRes="nw_it_msmlmisc20"; }
        else { sS="I'd like some ale <#plad/lass>."; sOrder="ale"; nCost=2; nWhere=2; sRes="nw_it_mpotion021"; }
      }
    } // fish or ale only
    else if (nGold<5)
    { // fish, ale, or wine
      nR=d4();
      if (bProfBarNoOldEnglish)
      {
        if (nR==1) { sS="I'll have a bit of fish if you would be so kind."; sOrder="fish"; nCost=2; nWhere=1; sRes="nw_it_msmlmisc20"; }
        else if (nR==2) { sS="I'd like a bottle of wine.  Thank you."; sOrder="wine"; nCost=4; nWhere=2; sRes="nw_it_mpotion023"; }
        else { sS="I'd like some ale <#psir/ma'am>."; sOrder="ale"; nCost=2; nWhere=2; sRes="nw_it_mpotion021"; }
      }
      else
      {
        if (nR==1) { sS="I'll have a bit of fish if ye would be so kind."; sOrder="fish"; nCost=2; nWhere=1; sRes="nw_it_msmlmisc20"; }
        else if (nR==2) { sS="I'd like a bottle of wine.  Thank you."; sOrder="wine"; nCost=4; nWhere=2; sRes="nw_it_mpotion023"; }
        else { sS="I'd like some ale <#plad/lass>."; sOrder="ale"; nCost=2; nWhere=2; sRes="nw_it_mpotion021"; }
      }
    } // fish, ale, or wine
    else if (nGold<6)
    { // fish, ale, wine, or meat
      nR=d6();
      if (bProfBarNoOldEnglish)
      {
        if (nR==1) { sS="I'll have a bit of fish if you would be so kind."; sOrder="fish"; nCost=2; nWhere=1; sRes="nw_it_msmlmisc20"; }
        else if (nR==2) { sS="I'd like a bottle of wine.  Thank you."; sOrder="wine"; nCost=4; nWhere=2; sRes="nw_it_mpotion023"; }
        else if (nR==3) { sS="I've been dreamin' of a bit of that meat you have cookin'."; sOrder="meat"; nCost=4; nWhere=1; sRes="nw_it_mmidmisc05"; }
        else { sS="I'd like some ale <#psir/ma'am>."; sOrder="ale"; nCost=2; nWhere=2; sRes="nw_it_mpotion021"; }
      }
      else
      {
        if (nR==1) { sS="I'll have a bit of fish if ye would be so kind."; sOrder="fish"; nCost=2; nWhere=1; sRes="nw_it_msmlmisc20"; }
        else if (nR==2) { sS="I'd like a bottle of wine.  Thank you."; sOrder="wine"; nCost=4; nWhere=2; sRes="nw_it_mpotion023"; }
        else if (nR==3) { sS="I've been dreamin' of a bit of that meat ye have cookin'."; sOrder="meat"; nCost=4; nWhere=1; sRes="nw_it_mmidmisc05"; }
        else { sS="I'd like some ale <#plad/lass>."; sOrder="ale"; nCost=2; nWhere=2; sRes="nw_it_mpotion021"; }
      }
    } // fish, ale, wine, or meat
    else if (nGold>5)
    { // anything on the menu
      nR=d6();
      if (bProfBarNoOldEnglish)
      {
        if (nR==1) { sS="I'll have a bit of fish if you would be so kind."; sOrder="fish"; nCost=2; nWhere=1; sRes="nw_it_msmlmisc20"; }
        else if (nR==2) { sS="I'd like a bottle of wine.  Thank you."; sOrder="wine"; nCost=4; nWhere=2; sRes="nw_it_mpotion023"; }
        else if (nR==3) { sS="I've been dreamin' of a bit of that meat you have cookin'."; sOrder="meat"; nCost=4; nWhere=1; sRes="nw_it_mmidmisc05"; }
        else if (nR==4) { sS="I need a bit o' the spirits to lift my spirits."; sOrder="spirits"; nCost=6; nWhere=2; sRes="nw_it_mpotion022"; }
        else { sS="I'd like some ale <#psir/ma'am>."; sOrder="ale"; nCost=2; nWhere=2; sRes="nw_it_mpotion021"; }
      }
      else
      {
        if (nR==1) { sS="I'll have a bit of fish if ye would be so kind."; sOrder="fish"; nCost=2; nWhere=1; sRes="nw_it_msmlmisc20"; }
        else if (nR==2) { sS="I'd like a bottle of wine.  Thank you."; sOrder="wine"; nCost=4; nWhere=2; sRes="nw_it_mpotion023"; }
        else if (nR==3) { sS="I've been dreamin' of a bit of that meat ye have cookin'."; sOrder="meat"; nCost=4; nWhere=1; sRes="nw_it_mmidmisc05"; }
        else if (nR==4) { sS="I need a bit o' the spirits to lift me own."; sOrder="spirits"; nCost=6; nWhere=2; sRes="nw_it_mpotion022"; }
        else { sS="I'd like some ale <#plad/lass>."; sOrder="ale"; nCost=2; nWhere=2; sRes="nw_it_mpotion021"; }
      }
    } // anything on the menu
    sS=fnConvHandleTokens(oCustomer,oNPC,sS);
    DelayCommand(3.0,AssignCommand(oCustomer,SpeakString(sS)));
    DelayCommand(3.1,AssignCommand(oCustomer,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,3.0)));
  } // standard menu---------------------------------------------------------
  else
  { // custom menu-----------------------------------------------------------
    nR=1;
    while(nR<=12)
    { // count items and check cheapest
      sS=GetLocalString(oNPC,"sProfBarMenuItemName"+IntToString(nR));
      if (GetStringLength(sS)>0)
      { // item
        nCount=nR;
        if (GetLocalInt(oNPC,"nProfBarMenuItemCost"+IntToString(nR))<nCheapest)
           nCheapest=GetLocalInt(oNPC,"nProfBarMenuItemCost"+IntToString(nR));
      } // item
      else { nR=13; }
      nR++;
    } // count items and check cheapest
    if (nCount==0||nGold<nCheapest)
    {
      nR=d4();
      if (bProfBarNoOldEnglish)
      {
        if (nR==1) sS="Nah, I thank you kindly <#psir/ma'am> but, I'm just fine at the moment.";
        else if (nR==2) sS="I don't think you operate on credit and my gold is a bit low at the moment.";
        else if (nR==3) sS="Not now.";
        else if (nR==4) sS="Nothin' from the menu but, a <pWM> like you, surely has a story or two to share.";
      }
      else
      {
        if (nR==1) sS="Nah, thank'e kindly <#plad/lass> but, I be just fine at the moment.";
        else if (nR==2) sS="I don't thinks ye operates on credit and me gold is a might bit low at the moment.";
        else if (nR==3) sS="Not now.";
        else if (nR==4) sS="Nothin' from the menu but, a <pWM> like'e surely has a story or two to share.";
      }
    } // not enough gold
    else
    { // pick order
      nR=Random(nCount)+1;
      nCount=0;
      while(GetLocalInt(oNPC,"nProfBarMenuItemCost"+IntToString(nR))>nGold&&nCount<10)
      { // find order
        nCount++;
        nR=Random(nCount)+1;
      } // find order
      if (GetLocalInt(oNPC,"nProfBarMenuItemCost"+IntToString(nR))<=nGold)
      { // valid order
        nCost=GetLocalInt(oNPC,"nProfBarMenuItemCost"+IntToString(nR));
        sOrder=GetLocalString(oNPC,"sProfBarMenuItemName"+IntToString(nR));
        nWhere=GetLocalInt(oNPC,"nProfBarMenuItemWhere"+IntToString(nR));
        sRes=GetLocalString(oNPC,"sProfBarMenuItemRes"+IntToString(nR));
        nR=d4();
        if (bProfBarNoOldEnglish)
        {
            if (nR==1) sS="Well, <#psir/ma'am>, I think I want some "+sOrder+".";
            else if (nR==2) sS="How about some "+sOrder+"?";
            else if (nR==3) sS="Thank you.  I'd appreciate some "+sOrder+".";
            else if (nR==4) sS="Sure, bring me some "+sOrder+".";
        }
        else
        {
            if (nR==1) sS="Well, <#plad/lass>, I think I want some "+sOrder+".";
            else if (nR==2) sS="How about some "+sOrder+"?";
            else if (nR==3) sS="Thank you <pWM>.  I'd appreciate some "+sOrder+".";
            else if (nR==4) sS="Sure, bring me some "+sOrder+".";
        }
      } // valid order
      else
      { // nothing
        nR=d4();
        if (nR==1) sS="I don't think I need a thing now.  Check with me again in a bit.";
        else if (nR==2) sS="Maybe some company but, nothing else at this time.";
        else if (nR==3) sS="Nah, I'm satisfied at the moment.";
        else if (nR==4) sS="No thanks.";
      } // nothing
    } // pick order
    sS=fnConvHandleTokens(oCustomer,oNPC,sS);
    DelayCommand(3.0,AssignCommand(oCustomer,SpeakString(sS)));
    DelayCommand(3.1,AssignCommand(oCustomer,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,3.0)));
  } // custom menu-----------------------------------------------------------
  if (nCost>0&&GetStringLength(sOrder)>0)
  { // an order was placed
    sS="Good, I'll be back with your "+sOrder+".";
    if (GetLocalInt(oNPC,"nSpeakLanguage")>0)
    { // speak another language
      fnConvClearConv(oNPC,oCustomer);
      sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+".NA.!29_3."+sS;
      DelayCommand(5.0,AssignCommand(oNPC,ActionStartConversation(oCustomer,"npcact_custom",FALSE,FALSE)));
    } // speak another language
    else
    { // speak normal language
      DelayCommand(5.0,AssignCommand(oNPC,SpeakString(sS)));
      DelayCommand(5.1,AssignCommand(oNPC,ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,4.0)));
    } // speak normal language
    SetLocalInt(oNPC,"nProfBarOrderCost",nCost);
    SetLocalInt(oNPC,"nProfBarOrderWhere",nWhere);
    SetLocalString(oNPC,"sProfBarOrderName",sOrder);
    SetLocalString(oNPC,"sProfBarOrderRes",sRes);
  } // an order was placed
  else
  { // make sure deleted
    DeleteLocalInt(oNPC,"nProfBarOrderCost");
    DeleteLocalInt(oNPC,"nProfBarOrderWhere");
    DeleteLocalString(oNPC,"sProfBarOrderName");
    DeleteLocalString(oNPC,"sProfBarOrderRes");
  } // make sure deleted
} // fnNPCOrder()



void fnPCOrder(object oNPC,object oCustomer)
{ // PURPOSE: To handle the order transaction with a PC
  int nR;
  string sS;
  string sOrder="";
  int nCost=0;
  int nCount=0;
  int nWhere=0;
  string sRes;
  int nCurrency=GetLocalInt(oNPC,"nCurrency");
  string sWork;
  int nWork=0;
  string sPre=GetLocalString(oNPC,"sProfBarMenuPreItem");
  SetLocalInt(oCustomer,"bProfBarHasOrdered"+fnGetNPCTag(oNPC),TRUE);   //corPeak
  DelayCommand(240.0,DeleteLocalInt(oCustomer,"bProfBarHasOrdered"+fnGetNPCTag(oNPC)));   //corPeak
  fnConvClearConv(oNPC,oCustomer);

  // build the custom conversation
  //gd header setup //////////////////////////
  int nProfBarMenuHeader = GetLocalInt(oNPC,"nProfBarMenuHeader");
  int nProfBarGreetTag = GetLocalInt(oCustomer,"nProfBarGreet" + GetTag(oNPC));  //orig
  int bProfBarUseDefaultHeaderAlso = GetLocalInt(oNPC,"bProfBarUseDefaultHeaderAlso");
  int bProfBarNoOldEnglish = GetLocalInt(oNPC,"bProfBarNoOldEnglish");
  fnDebug("   nProfBarGreetTag " + IntToString(nProfBarGreetTag) + " for " + GetName(oCustomer));

  // First time welcome
  if (!GetLocalInt(oCustomer, "bProfBarDidGreet" + fnGetNPCTag(oNPC)) && GetStringLength(GetLocalString(oNPC,"sProfBarMenuFirst"))>0)   //corPeak
  {
        sS= GetLocalString(oNPC,"sProfBarMenuFirst");
        SetLocalInt(oCustomer, "bProfBarDidGreet" + fnGetNPCTag(oNPC), TRUE);   //corPeak
  }
  // Custom or default welcome on Customer
  else if (nProfBarGreetTag > 0)
  {
        sS=GetLocalString(oCustomer,"sProfBarGreet" + GetTag(oNPC)+ IntToString(Random(nProfBarGreetTag)+1));  //orig
        fnDebug("Possible Custom Customer Greeting: " + sS);
        if (GetStringLength(sS)<1 || (bProfBarUseDefaultHeaderAlso && (Random(nProfBarGreetTag+1) == nProfBarGreetTag)))
        {
            fnDebug("No Custom Customer Greet");
            sS=GetLocalString(oNPC,"sProfBarMenuHeader" + IntToString(Random(nProfBarMenuHeader)+1));
            if (nProfBarMenuHeader < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultHeaderAlso && (Random(nProfBarMenuHeader+1) == nProfBarMenuHeader)))
            { // no custom header provided or we may use defaults as well
                nR = d4();
                if (d100()==1)
                {
                    if (bProfBarNoOldEnglish) sS="Well <#pdolt/witch> is there anythin' I CAN get you!";
                    else sS="Well <pI3>, is there anythin' thou needst?";
                }
                else
                {
                    if (bProfBarNoOldEnglish)
                    {
                        if (nR==1) sS="<pSM>, can I get you anythin'?";
                        else if (nR==2) sS="<pSM>, I thought I'd check to see if you needs anythin'.  Do you?";
                        else if (nR==3) sS="You looked like you wanted somethin' <pSM>.  Can I get you somethin'?";
                        else if (nR==4) sS="Often a <G> <R> needs things.  Do you need anythin' <pSM>?";
                    }
                    else
                    {
                        if (nR==1) sS="<pSM>, can I get ye anythin'?";
                        else if (nR==2) sS="<pLL>, I thought I'd check to see if ye needs anythin'.  Do ye?";
                        else if (nR==3) sS="Ye looked like ye wanted somethin' <pSM>.  Can I get ye somethin'?";
                        else if (nR==4) sS="Often a <G> <R> needs things.  Do ye need anythin' <pSM>?";
                    }
                }
            } // no custom header provided or we may use defaults as well
        }
   }
  // Custom or default welcome on Waitress
  else
  {
        sS=GetLocalString(oNPC,"sProfBarMenuHeader" + IntToString(Random(nProfBarMenuHeader)+1));
        if (nProfBarMenuHeader < 1 || GetStringLength(sS)<1 || (bProfBarUseDefaultHeaderAlso && (Random(nProfBarMenuHeader+1) == nProfBarMenuHeader)))
        { // no custom header provided or we may use defaults as well
                nR = d4();
                if (d100()==1)
                {
                    if (bProfBarNoOldEnglish) sS="Well <#pdolt/witch> is there anythin' I CAN get you!";
                    else sS="Well <pI3>, is there anythin' thou needst?";
                }
                else
                {
                    if (bProfBarNoOldEnglish)
                    {
                        if (nR==1) sS="<pSM>, can I get you anythin'?";
                        else if (nR==2) sS="<pSM>, I thought I'd check to see if you need anythin'.  Do you?";
                        else if (nR==3) sS="You looked like you wanted somethin' <pSM>.  Can I get you somethin'?";
                        else if (nR==4) sS="Often a <G> <R> needs things.  Do you need anythin' <pSM>?";
                    }
                    else
                    {
                        if (nR==1) sS="<pSM>, can I get ye anythin'?";
                        else if (nR==2) sS="<pLL>, I thought I'd check to see if ye needs anythin'.  Do ye?";
                        else if (nR==3) sS="Ye looked like ye wanted somethin' <pSM>.  Can I get ye somethin'?";
                        else if (nR==4) sS="Often a <G> <R> needs things.  Do ye need anythin' <pSM>?";
                    }
                }
        } // no custom header provided or we may use defaults as well
   }

    sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+".NA.NA."+sS;
    SetLocalString(oNPC,"sNPCConvNode0_0",sS);

  SetLocalString(oNPC,"sNPCConvResp0_0_13","0.NA.&PbProfBarHasOrdered"+fnGetNPCTag(oNPC)+"|1.I do not need anything."); // footer //corPeak
  // build the menu
  if (GetLocalInt(oNPC,"bProfBarCustomMenu")==TRUE)
  { // custom menu
    nR=1;
    while(nR<13)
    { // build the menu
      sS=GetLocalString(oNPC,"sProfBarMenuItemName"+IntToString(nR));
      if (GetStringLength(sS)>0)
      { // there is an item
        sRes=GetLocalString(oNPC,"sProfBarMenuItemRes"+IntToString(nR));
        nCost=GetLocalInt(oNPC,"nProfBarMenuItemCost"+IntToString(nR));
        nWhere=GetLocalInt(oNPC,"nProfBarMenuItemWhere"+IntToString(nR));
        if (GetStringLength(sPre)>0) { sS=sPre+" "+sS+" for "+MoneyToString(nCost,nCurrency,FALSE); }
        else { sS="I'd like a "+sS+" for "+MoneyToString(nCost,nCurrency,FALSE); }
        sWork="&PnPBAC|"+IntToString(nCost)+"/:PsPBR|"+sRes+"/:PsPBO|"+GetLocalString(oNPC,"sProfBarMenuItemName"+IntToString(nR))+"/&PnPBW|"+IntToString(nWhere)+"/#N";
        // nPBAC = actual cost
        // sPBR = ResRef
        // sPBO = Order Name gd changed from sS
        // nPBW = Where
        if (GetStringRight(sS,1)==".") sS=GetStringLeft(sS,GetStringLength(sS)-1);
        sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+".NA."+sWork+"."+sS;
        SetLocalString(oNPC,"sNPCConvResp0_0_"+IntToString(nR),sS);
      } // there is an item
      nR++;
    } // build the menu
  } // custom menu
  else
  { // standard menu
    sS="I'd like an ale for only "+MoneyToString(2,nCurrency,FALSE);
    if (GetStringRight(sS,1)==".") sS=GetStringLeft(sS,GetStringLength(sS)-1);
    sWork="&PnPBAC|2/:PsPBR|nw_it_mpotion021/:PsPBO|ale/&PnPBW|2/#N";
    sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+".NA."+sWork+"."+sS;
    SetLocalString(oNPC,"sNPCConvResp0_0_1",sS);
    sS="I'd like a fish for only "+MoneyToString(2,nCurrency,FALSE);
    if (GetStringRight(sS,1)==".") sS=GetStringLeft(sS,GetStringLength(sS)-1);
    sWork="&PnPBAC|2/:PsPBR|nw_it_msmlmisc20/:PsPBO|fish/&PnPBW|1/#N";
    sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+".NA."+sWork+"."+sS;
    SetLocalString(oNPC,"sNPCConvResp0_0_2",sS);
    sS="I'd like some wine for only "+MoneyToString(4,nCurrency,FALSE);
    if (GetStringRight(sS,1)==".") sS=GetStringLeft(sS,GetStringLength(sS)-1);
    sWork="&PnPBAC|4/:PsPBR|nw_it_mpotion022/:PsPBO|wine/&PnPBW|2/#N";
    sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+".NA."+sWork+"."+sS;
    SetLocalString(oNPC,"sNPCConvResp0_0_3",sS);
    sS="I'd like some meat for only "+MoneyToString(5,nCurrency,FALSE);
    if (GetStringRight(sS,1)==".") sS=GetStringLeft(sS,GetStringLength(sS)-1);
    sWork="&PnPBAC|5/:PsPBR|nw_it_mmidmisc05/:PsPBO|meat/&PnPBW|1/#N";
    sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+".NA."+sWork+"."+sS;
    SetLocalString(oNPC,"sNPCConvResp0_0_4",sS);
    sS="I'd like some spirits for only "+MoneyToString(6,nCurrency,FALSE);
    if (GetStringRight(sS,1)==".") sS=GetStringLeft(sS,GetStringLength(sS)-1);
    sWork="&PnPBAC|6/:PsPBR|nw_it_mpotion022/:PsPBO|spirits/&PnPBW|2/#N";
    sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+".NA."+sWork+"."+sS;
    SetLocalString(oNPC,"sNPCConvResp0_0_5",sS);
  } // standard menu
  sS="Thee hast not enough wealth for that.";
  if (bProfBarNoOldEnglish) sS="You do not have enough wealth for that.";
  sWork="$!nPBAC|L.#N";
  sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+"."+sWork+"."+sS;
  SetLocalString(oNPC,"sNPCConvNode1_0",sS);
  sS="Excellent.  I shall get that for thee right away <pSM>.";
  if (bProfBarNoOldEnglish) sS="Excellent.  I shall get that for you right away <pSM>.";
  sWork=".NA.&NnProfBarOrderCost|!nPBAC/&NnProfBarOrderWhere|!nPBW/:NsProfBarOrderName|!sPBO/:NsProfBarOrderRes|!sPBR/&PbProfBarHasOrdered"+fnGetNPCTag(oNPC)+"|1";  //corPeak
  sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+sWork+"."+sS;
  SetLocalString(oNPC,"sNPCConvNode1_1",sS);
  // handle reseating PC
  sS="I thank thee";
  if (bProfBarNoOldEnglish) sS="Thank you";
  sWork=".NA.@sit_again.";
  sS=IntToString(GetLocalInt(oNPC,"nSpeakLanguage"))+sWork+sS;
  SetLocalString(oNPC,"sNPCConvResp1_1_1",sS);
  // initiate the conversation
  AssignCommand(oNPC,ActionStartConversation(oCustomer,"npcact_custom",FALSE,TRUE));
} // fnPCOrder()

