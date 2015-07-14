////////////////////////////////////////////////////////////////////////////////
// npcact_h_vfx - NPC ACTIVITIES 6.0 Visual Effects Functions
//------------------------------------------------------------------------------
// by Deva Bryson Winblood.
//------------------------------------------------------------------------------
// Last Modified by: Deva Bryson Winblood
// Last Modified Date: 05/31/2004
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
////////////////////////////////
// PROTOTYPES
////////////////////////////////

// FILE: npcact_h_vfx                  FUNCTION: fnNPCACTBeamEffect()
// This will apply the specified beam effect from the NPC to the specified
// object.
float fnNPCACTBeamEffect(string sCom);

// FILE: npcact_h_vfx                  FUNCTION: fnNPCACTEffects()
// This will apply visual effects for specified duration.  If duration is
// 0.0 it will apply it as instant other wise the integer duration is assumed
// to be a temporary duration interval of 0.2 seconds.  For example: 3 = 3x0.2
// or 0.6 seconds.
float fnNPCACTEffects(string sCom);

// FILE: npcact_h_vfx                  FUNCTION: fnNPCACTPlaceableVFX()
// This function will apply an effect using duration type temporary to
// a specified object with a duration of 5 seconds.
float fnNPCACTPlaceableVFX(string sCom);

// FILE: npcact_h_vfx                  FUNCTION: fnNPCACTPersistentVFX()
// This function will apply a temporary visual effect every specified amount
// of seconds and the visual effect will continue to be updated.  This function
// applies effects with a 30 second duration.  Yes, some effects have a preset
// length so, by using this function those effects can be made to appear persistent.
// In NPC ACTIVITIES it has been modified to not fire off if there are no PCs
// in the area.  It needs someone who can actually see it before it fires off.
// This reduces some of the CPU load of these effects.
float fnNPCACTPersistentVFX(string sCom);

// FILE: npcact_h_vfx                  FUNCTION: fnNPCACT4Visual()
// This function will allows adding or removing of visual effects
// to the NPC and is the method used in NPC ACTIVITIES 4.0.  If nState
// is 0 then it will attempt to remove the effect.  If it is 1 then it
// will attempt to add the effect.   Effect durations are 5 seconds.
float fnNPCACT4Visual(int nState, string sVFX);

////////////////////////////////
// FUNCTIONS
////////////////////////////////

float fnNPCACTBeamEffect(string sCom)
{ // PURPOSE: To apply beam effect to object from NPC
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sEffNum=GetSubString(sCom,2,3);
  string sTarget=GetStringRight(sCom,GetStringLength(sCom)-5);
  object oTarget=GetNearestObjectByTag(sTarget);
  effect eBeam;
  if (GetIsObjectValid(oTarget))
  { // valid target
    eBeam=EffectBeam(StringToInt(sEffNum),OBJECT_SELF,BODY_NODE_HAND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,5.5);
    return 6.0;
  } // valid target
  return 0.0;
} // fnNPCACTBeamEffect()

float fnNPCACTEffects(string sCom)
{ // PURPOSE: To apply visual effects to the NPC
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sParm=GetStringRight(sCom,GetStringLength(sCom)-3);
  string sVFX=fnParse(sParm,"/");
  effect eEffect;
  int nVFX=StringToInt(sVFX);
  float fDur;
  sParm=fnRemoveParsed(sParm,sVFX,"/");
  if (nVFX!=0)
  { // effect # entered
    eEffect=EffectVisualEffect(nVFX);
    fDur=IntToFloat(StringToInt(sParm))*0.2;
    if (fDur==0.0)
    { // instant effect
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffect,OBJECT_SELF,1.0);
    } // instant effect
    else
    { // temporary effect
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eEffect,OBJECT_SELF,fDur);
    } // temporary effect
  } // effect # entered
  return 0.0;
} // fnNPCACTEffects()

float fnNPCACTPlaceableVFX(string sCom)
{ // PURPOSE: This will apply a 5 second visual effect to a location
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sWork;
  string sVFX;
  string sTarget;
  object oTarget;
  int nVFX;
  effect eVFX;
  if (GetStringLeft(sCom,4)=="FXAR") sWork=GetStringRight(sCom,GetStringLength(sCom)-4);
  else { sWork=GetStringRight(sCom,GetStringLength(sCom)-2); }
  sVFX=GetStringLeft(sWork,3);
  sTarget=GetStringRight(sWork,GetStringLength(sWork)-3);
  nVFX=StringToInt(sVFX);
  oTarget=GetNearestObjectByTag(sTarget);
  if (nVFX!=0&&GetIsObjectValid(oTarget))
  { // good target and VFX
    eVFX=EffectVisualEffect(nVFX);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eVFX,GetLocation(oTarget),5.0);
  } // good target and VFX
  return 0.0;
} // fnNPCACTPlaceableVFX()


void NPCACTPersistentSupportFunction(int nVFX,int nDelay)
{ // PURPOSE: This handles the reoccuring portion of the persistent VFX
  // LAST MODIFIED BY: Deva Bryson Winblood
  effect eVFX=EffectVisualEffect(nVFX);
  object oPC=GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC,OBJECT_SELF,1);
  if (GetIsObjectValid(oPC))
  { // there is a PC in my area
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,OBJECT_SELF,30.0);
  } // there is a PC in my area
  DelayCommand(IntToFloat(nDelay),NPCACTPersistentSupportFunction(nVFX,nDelay));
} // NPCACTPersistentSupportFunction()

float fnNPCACTPersistentVFX(string sCom)
{ // PURPOSE: To apply a persistent visual effect to the NPC even with effects
  // that normally have a limited duration
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sWork;
  string sVFX;
  string sDelay;
  int nVFX;
  int nDelay;
  if (GetStringLeft(sCom,3)=="PFX") sWork=GetStringRight(sCom,GetStringLength(sCom)-3);
  else { sWork=GetStringRight(sCom,GetStringLength(sCom)-2); }
  sVFX=fnParse(sWork,"/");
  sDelay=fnRemoveParsed(sWork,sVFX,"/");
  if (GetLocalInt(OBJECT_SELF,"bNPCACTPFX"+sVFX)!=TRUE)
  { // effect not already present
    nVFX=StringToInt(sVFX);
    nDelay=StringToInt(sDelay);
    if (nDelay<1) nDelay=1;
    if (nVFX!=0)
    { // valid visual effect
      NPCACTPersistentSupportFunction(nVFX,nDelay);
      SetLocalInt(OBJECT_SELF,"bNPCACTPFX"+sVFX,TRUE);
    } // valid visual effect
  } // effect not already present
  return 0.0;
} // fnNPCACTPersistentVFX()

float fnNPCACT4Visual(int nState, string sVFX)
{
  // PURPOSE: To add or remove visual effects on the NPC per the old
  // NPC ACTIVITIES 4.0 method.
  // LAST MODIFIED BY: Deva Bryson Winbloood
  // 0 = remove  1= apply
  string sParm="";
  if (GetStringLeft(sVFX,3)=="VFX") sParm=GetStringRight(sVFX,GetStringLength(sVFX)-3);
  else if (GetStringLeft(sVFX,4)=="RVFX") sParm=GetStringRight(sVFX,GetStringLength(sVFX)-4);
  else if (GetStringLeft(sVFX,2)=="VF"||GetStringLeft(sVFX,2)=="RV")
  { sParm=GetStringRight(sVFX,GetStringLength(sVFX)-2); }
  int nVFX=StringToInt(sParm);
  effect eVFX=EffectVisualEffect(nVFX);
  if (GetIsEffectValid(eVFX))
  { // valid effect
    if (nState==0)
    { // remove effect
     effect eTest=GetFirstEffect(OBJECT_SELF);
     while(GetIsEffectValid(eVFX))
     { // test
       eTest=GetNextEffect(OBJECT_SELF);
       if (eTest==eVFX) RemoveEffect(OBJECT_SELF,eTest);
     } // test
    } // remove effect
    else
    { // apply effect
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,OBJECT_SELF,5.0);
    } // apply effect
  } // valid effect
  return 0.0;
} // fnNPCACT4Visual()

//void main(){}
