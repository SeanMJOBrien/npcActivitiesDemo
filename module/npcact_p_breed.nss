///////////////////////////////////////////////////////////////////////////////
// npcact_p_breed - NPC ACTIVITIES 6.0 Profession: BREED
// By Deva Bryson Winblood.  09/06/2004
// Last Modified By: Deva Bryson Winblood.  02/02/2005
// modified for Virtual Tag - peak 5/10
// modified for hours of operation - peak 5/10
// what about more than one breeder, store variables at site?
//----------------------------------------------------------------------------
// # of parameters passed: 5    ALL REQUIRED: Yes
// Parameters:
// ResRef, Tag, Max Population, Delay, Count Area
// Max Population
//      number = fixed numeric quantity
//      #<variable> = determined by contents of variable on module object
//      !<variable> = determined by contents of variable on area object
// Count Area
//    M = All creatures in module with this tag
//    A = All creatures in this area with this tag
// Optional variables on calling NPC: nProfBreedTimeBegin & ..End = hours of activity
///////////////////////////////////////////////////////////////////////////////
#include "npcact_h_prof"
/////////////////////////
// PROTOTYPES
/////////////////////////

////////////////////////////////////////////////////////////////////// MAIN
void main()
{
   object oMe=OBJECT_SELF;
   object oArea=GetArea(oMe);
   object oMod=GetModule();
   int bCompleted=TRUE; //peak
   int nDelay;
   string sRes;
   object oOb;
   string sTag;
   string sMax;
   int nMax;
   string sCountWhere;
   int nTimeBegin=0; //to allow breeding hours of operation
   int nTimeEnd=23;  //peak 5/10
   int nCount=0;
   int nLoop;
   int nN;
   nN=GetLocalInt(oMe,"nProfBreedTimeBegin"); //optional variables for breeding hours of operation
   if((nN>0)&&(nN<23)) nTimeBegin=nN;         //variables are stored on breeder
   nN=GetLocalInt(oMe,"nProfBreedTimeEnd");   //
   if((nN>nTimeBegin)&&(nN<23)) nTimeEnd=nN;  //
   nN=GetTimeHour();                          //
   if((nN>=nTimeBegin)&&(nN<=nTimeEnd))       //peak 5/10
     { //within breeding hours
     int bCompleted=FALSE; //peak
     string sItem=GetLocalString(oMe,"sProfBreedItemReq");
     object oItem;
     int bRequiresItem=FALSE;
     if (GetStringLength(sItem)>0)
     { // find item
       bRequiresItem=TRUE;
       oItem=GetItemPossessedBy(oMe,sItem);
     } // find item
     SetLocalInt(oMe,"bGNBProfessions",TRUE);
     fnDebug("npcact_p_breed ENTER");
     if (GetLocalInt(oMe,"nArgC")==5)
     { // sufficient variables were passed
       sRes=GetLocalString(oMe,"sArgV1");
       sTag=GetLocalString(oMe,"sArgV2");
       sMax=GetLocalString(oMe,"sArgV3");
       nDelay=StringToInt(GetLocalString(oMe,"sArgV4"));
       if (nDelay<1) nDelay=5;
       sCountWhere=GetLocalString(oMe,"sArgV5");
       if (GetStringLeft(sMax,1)=="#")
       { // module variable
         sMax=GetStringRight(sMax,GetStringLength(sMax)-1);
         nMax=GetLocalInt(oMod,sMax);
       } // module variable
       else if (GetStringLeft(sMax,1)=="!")
       { // area variable
         sMax=GetStringRight(sMax,GetStringLength(sMax)-1);
         nMax=GetLocalInt(oArea,sMax);
       } // area variable
       else { nMax=StringToInt(sMax); }
       if (sCountWhere=="M")
       { // count module
         nLoop=0;
         oOb=GetObjectByTag(sTag,nLoop);
         while(oOb!=OBJECT_INVALID)
         { // count
           if (GetObjectType(oOb)==OBJECT_TYPE_CREATURE) nCount++;
           nLoop++;
           oOb=GetObjectByTag(sTag,nLoop);
         } // count
       } // count module
       else
       { // count area
         if (fnGetNPCTag(oMe)==sTag) nCount=1;    //modified for Virtual Tag peak 5/10
         nLoop=1;
         oOb=GetNearestObjectByTag(sTag,oMe,nLoop);
         while(oOb!=OBJECT_INVALID)
         { // count
           if (GetObjectType(oOb)==OBJECT_TYPE_CREATURE) nCount++;
           nLoop++;
           oOb=GetNearestObjectByTag(sTag,oMe,nLoop);
         } // count
       } // count area
       if (nCount>=nMax)
       { // done
         bCompleted=TRUE;
       } // done
       else
       { // spawn
         if (bRequiresItem==FALSE||GetIsObjectValid(oItem))
         { // has item or it is not needed
           if (bRequiresItem)
           { // handle required item
             nN=GetItemStackSize(oItem);
             if (nN>1)
             { // multi-stack
               SetItemStackSize(oItem,nN-1);
             } // multi-stack
             else
             { // single item
               DestroyObject(oItem);
             } // single item
           } // handle required item
           oOb=CreateObject(OBJECT_TYPE_CREATURE,sRes,GetLocation(oMe));
           nCount++;
           if (nCount>=nMax) { bCompleted=TRUE; }
         } // has item or it is not needed
         else if (bRequiresItem)
         { // don't have item
           bCompleted=TRUE;
         } // don't have item
       } // spawn
     } // sufficient variables were passed
     else
     { // insufficient variables
       AssignCommand(oMe,SpeakString("ERROR: Not enough parameters *breed/res/tag/max/delay/count !!"));
       bCompleted=TRUE;
     } // insufficient variables
   } // within breeding hours
   if (bCompleted||GetIsInCombat(oMe)||IsInConversation(oMe))
   { // done with profession
     fnPROFCleanupArgs(oMe);
     DeleteLocalInt(oMe,"bGNBProfessions"); // return control to NPC ACTIVITIES
     fnDebug("npcact_p_breed  EXIT");
   } // done with profession
   else
   { // not done... do a delay call
     SetLocalInt(oMe,"nGNBProfProc",1); // reset fail safe
     SetLocalInt(oMe,"nGNBProfFail",nDelay*2); // set fail safe length
     DelayCommand(IntToFloat(nDelay),ExecuteScript("npcact_p_breed",oMe));
   } // not done... do a delay call
}
////////////////////////////////////////////////////////////////////// MAIN

/////////////////////////
// FUNCTIONS
/////////////////////////
