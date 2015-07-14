////////////////////////////////////////////////////////////////////////////////
// npcact_ext_light - NPC ACTIVITIES 6.0  Turn Lights On Off external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////


object fnLightObject(int nLoop)
{ // return light object
  object oMe=OBJECT_SELF;
  object oRet=OBJECT_INVALID;
  string sTag;
  object oOb;
  int nC;
  int nLO;
  float fDist=0.0;
  nC=1;
  nLO=0;
  oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,oOb,nC);
  fDist=GetDistanceBetween(oOb,oMe);
  while(oRet==OBJECT_INVALID&&oOb!=OBJECT_INVALID&&fDist<=5.0)
  { // find object
    sTag=GetTag(oOb);
    if (TestStringAgainstPattern("(LampPost|Brazier|Campfire|CampfireCauldron|CampfirewithSpit|PillarStyle1|Candelabra)",sTag))
    { // valid
      nLO++;
      if (nLO==nLoop) oRet=oOb;
    } // valid
    nC++;
    oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,oOb,nC);
    fDist=GetDistanceBetween(oOb,oMe);
  } // find object
  return oRet;
} // fnLightObject()

void fnLights(int nParm)
{
  int nLoop=1;
  int nOnOff=0;
  int nFlag=FALSE;
  object oArea=GetArea(OBJECT_SELF);
  object oLight=fnLightObject(nLoop);
  while(oLight!=OBJECT_INVALID)
  { // !OI
   if (nParm==0) {nOnOff=1; nFlag=TRUE;}
     ActionMoveToObject(oLight,FALSE,0.5);
     SetLocalInt(OBJECT_SELF,"nOffOn",nOnOff);
     ActionInteractObject(oLight);
     SetPlaceableIllumination(oLight, nFlag);
   nLoop++;
   oLight=fnLightObject(nLoop);
  } // !OI
  RecomputeStaticLighting(oArea);
} // NPCActionLights()

void main()
{
  string sParm=GetLocalString(OBJECT_SELF,"sParm");
  DeleteLocalString(OBJECT_SELF,"sParm");
  if (sParm=="LTON"||sParm=="LO") fnLights(0);
  else { fnLights(1); }
  SetLocalFloat(OBJECT_SELF,"fDelay",8.0);
}

