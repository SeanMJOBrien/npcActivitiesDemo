////////////////////////////////////////////////////////////////////////////////
// npcact_ho_core - NPC ACTIVITIES 6.0 Core Functions for FULL version interpreter
//------------------------------------------------------------------------------
// by Deva Bryson Winblood.
//------------------------------------------------------------------------------
// Last Modified by: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
//////////////////////////
// PROTOTYPES
//////////////////////////

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_ATTK()
// This command will cause the NPC to approach the nearest placeable
// they can see and attack it.
float fnNPCACTF_ATTK();

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_CAST()
// This will cause the NPC to cast a spell passed to it as an
// abbreviation of that spell.
float fnNPCACTF_CAST(string sCommand);

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_CLEN()
// This function will cause the NPC to cleanup nearby non-plot items
// that are within 8 meters of it.
float fnNPCACTF_CLEN();

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_CLLD()
// This function IF IT ACTUALLY DOES ANYTHING will cause the NPC
// to close nearby containers that are open.  Within 8 meters.
// The command was supplied simply for backwards compatibility and
// I suspect it may actually do nothing since, containers tend to
// close themselves when someone is NOT looking at their inventory.
float fnNPCACTF_CLLD();


// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_CLO()
// This function will cause the NPC to change into clothing stored
// on the variable sNPCActCloth#.  If the resref stored on the variable
// is NONE then the NPC will remove clothing.  It is possible using
// the !S commands to set and initialize up to 9 clothing variables
// for use with this function.
float fnNPCACTF_CLO(string sParm);

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_DRD()
// To choose a nearby random door as the next destination.
float fnNPCACTF_DRD();

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_EAT()
// This will cause the NPC to look for food items within 8 meters.
// If found it will walk to one, pick it up, and destroy it.
// It tells if it is a food item by its tag.  Anything can be made
// a food item simply by making its tag equal to FOOD.
float fnNPCACTF_EAT();

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_Follow()
// This will handle all the following commands for the full interpeter.
float fnNPCACTF_Follow(int nParm);

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_KILL()
// This will cause the NPC to attack a nearby PC or NPC.
float fnNPCACTF_KILL();

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_PickLock()
// This will cause the NPC to pick the lock of a nearby door or container.
float fnNPCACTF_PickLock();

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_Taunt()
// This function will cause the NPC to taunt any nearby creature not of their
// faction.
float fnNPCACTF_Taunt();

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_Use()
// This function will enable an NPC to interact with an object within 8 meters
// that is useable.
float fnNPCACTF_Use();

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_Inn()
// Backwards compatibility in command
float fnNPCACTF_Inn();
// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_Proposition()
// Proposition for prostitution
float fnNPCACTF_Proposition();

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_Polymorph()
// Polymorph backwards compatibility.
float fnNPCACTF_Polymorph(string sPoly);

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_SummonCreature()
// Summon Creature backwards compatibility.
float fnNPCACTF_SummonCreature(string sParm);

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_SayPhrase()
// Backwards compatible SAY# command.
float fnNPCACTF_SayPhrase(string sParm);

// FILE: npcact_ho_core                  FUNCTION: fnNPCACTF_Wake();
// Backwards compatible WAKE command.
float fnNPCACTF_Wake();

//////////////////////////
// FUNCTIONS
//////////////////////////

float fnNPCACTF_ATTK()
{ // PURPOSE: To cause the NPC to attack the nearest placeable they
  // can see.
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE);
  float fDur;
  if (GetIsObjectValid(oOb))
  { // valid placeable
    if (GetObjectSeen(oOb))
    { // placeable can be seen
      fDur=12.0;
      if (GetDistanceBetween(OBJECT_SELF,oOb)>3.0)
      {
        fDur=fDur+6.0;
        ActionMoveToObject(oOb,TRUE,2.5);
      }
      ActionAttack(oOb,TRUE);
      return fDur;
    } // placeable can be seen
    else
    { return 0.0; }
  } // valid placeable
  else { return 0.0; }
} // fnNPCACTF_ATTK()

float fnNPCACTF_CAST(string sCommand)
{ // PURPOSE: To enable NPC to cast a spell by a passed abbreviation
  // LAST MODIFIED BY: Deva Bryson Winblood
  int nSpell=0;
  string sSpell;
  if (GetStringLeft(sCommand,4)=="CAST") sSpell=GetStringRight(sCommand,GetStringLength(sCommand)-4);
  else { sSpell=GetStringRight(sCommand,GetStringLength(sCommand)-2); }
  if (sSpell=="AID") nSpell=SPELL_AID;
  else if (sSpell=="AURAOFVITALITY") nSpell=SPELL_AURA_OF_VITALITY;
  else if (sSpell=="BARKSKIN") nSpell=SPELL_BARKSKIN;
  else if (sSpell=="BLESS") nSpell=SPELL_BLESS;
  else if (sSpell=="BULLSSTRENGTH") nSpell=SPELL_BULLS_STRENGTH;
  else if (sSpell=="CATSGRACE") nSpell=SPELL_CATS_GRACE;
  else if (sSpell=="CIRCLEOFDEATH") nSpell=SPELL_CIRCLE_OF_DEATH;
  else if (sSpell=="CIRCLEOFDOOM") nSpell=SPELL_CIRCLE_OF_DOOM;
  else if (sSpell=="CLOAKOFCHAOS") nSpell=SPELL_CLOAK_OF_CHAOS;
  else if (sSpell=="CLARITY") nSpell=SPELL_CLARITY;
  else if (sSpell=="CURECRITICALWOUNDS") nSpell=SPELL_CURE_CRITICAL_WOUNDS;
  else if (sSpell=="CURELIGHTWOUNDS") nSpell=SPELL_CURE_LIGHT_WOUNDS;
  else if (sSpell=="CUREMINORWOUNDS") nSpell=SPELL_CURE_MINOR_WOUNDS;
  else if (sSpell=="CUREMODERATEWOUNDS") nSpell=SPELL_CURE_MODERATE_WOUNDS;
  else if (sSpell=="CURESERIOUSWOUNDS") nSpell=SPELL_CURE_SERIOUS_WOUNDS;
  else if (sSpell=="DARKNESS") nSpell=SPELL_DARKNESS;
  else if (sSpell=="DARKVISION") nSpell=SPELL_DARKVISION;
  else if (sSpell=="DEATHWARD") nSpell=SPELL_DEATH_WARD;
  else if (sSpell=="DIVINEPOWER") nSpell=SPELL_DIVINE_POWER;
  else if (sSpell=="EAGLESPLENDOR") nSpell=SPELL_EAGLE_SPLEDOR;
  else if (sSpell=="ELEMENTALSHIELD") nSpell=SPELL_ELEMENTAL_SHIELD;
  else if (sSpell=="ENDURANCE") nSpell=SPELL_ENDURANCE;
  else if (sSpell=="ENDUREELEMENTS") nSpell=SPELL_ENDURE_ELEMENTS;
  else if (sSpell=="ENERGYBUFFER") nSpell=SPELL_ENERGY_BUFFER;
  else if (sSpell=="ETHEREALVISAGE") nSpell=SPELL_ETHEREAL_VISAGE;
  else if (sSpell=="FINDTRAPS") nSpell=SPELL_FIND_TRAPS;
  else if (sSpell=="FOXSCUNNING") nSpell=SPELL_FOXS_CUNNING;
  else if (sSpell=="FREEDOMOFMOVEMENT") nSpell=SPELL_FREEDOM_OF_MOVEMENT;
  else if (sSpell=="GATE") nSpell=SPELL_GATE;
  else if (sSpell=="GHOSTLYVISAGE") nSpell=SPELL_GHOSTLY_VISAGE;
  else if (sSpell=="GLOBEOFINVULNERABILITY") nSpell=SPELL_GLOBE_OF_INVULNERABILITY;
  else if (sSpell=="GREATERBULLSSTRENGTH") nSpell=SPELL_GREATER_BULLS_STRENGTH;
  else if (sSpell=="GREATERCATSGRACE") nSpell=SPELL_GREATER_CATS_GRACE;
  else if (sSpell=="GREATEREAGLESPLENDOR") nSpell=SPELL_GREATER_EAGLE_SPLENDOR;
  else if (sSpell=="GREATERENDURANCE") nSpell=SPELL_GREATER_ENDURANCE;
  else if (sSpell=="GREATERFOXSCUNNING") nSpell=SPELL_GREATER_FOXS_CUNNING;
  else if (sSpell=="GREATEROWLSWISDOM") nSpell=SPELL_GREATER_OWLS_WISDOM;
  else if (sSpell=="GREATERRESTORATION") nSpell=SPELL_GREATER_RESTORATION;
  else if (sSpell=="GREATERSTONESKIN") nSpell=SPELL_GREATER_STONESKIN;
  else if (sSpell=="HASTE") nSpell=SPELL_HASTE;
  else if (sSpell=="HEAL") nSpell=SPELL_HEAL;
  else if (sSpell=="HEALINGCIRCLE") nSpell=SPELL_HEALING_CIRCLE;
  else if (sSpell=="HOLYAURA") nSpell=SPELL_HOLY_AURA;
  else if (sSpell=="HOLYSWORD") nSpell=SPELL_HOLY_SWORD;
  else if (sSpell=="IDENTIFY") nSpell=SPELL_IDENTIFY;
  else if (sSpell=="IMPROVEDINVISIBILITY") nSpell=SPELL_IMPROVED_INVISIBILITY;
  else if (sSpell=="INVISIBILITY") nSpell=SPELL_INVISIBILITY;
  else if (sSpell=="INVISIBILITYSPHERE") nSpell=SPELL_INVISIBILITY_SPHERE;
  else if (sSpell=="LEGENDLORE") nSpell=SPELL_LEGEND_LORE;
  else if (sSpell=="LIGHT") nSpell=SPELL_LIGHT;
  else if (sSpell=="MAGEARMOR") nSpell=SPELL_MAGE_ARMOR;
  else if (sSpell=="MAGICCIRCLEAGAINSTCHAOS") nSpell=SPELL_MAGIC_CIRCLE_AGAINST_CHAOS;
  else if (sSpell=="MAGICCIRCLEAGAINSTEVIL") nSpell=SPELL_MAGIC_CIRCLE_AGAINST_EVIL;
  else if (sSpell=="MAGICCIRCLEAGAINSTGOOD") nSpell=SPELL_MAGIC_CIRCLE_AGAINST_GOOD;
  else if (sSpell=="MAGICCIRCLEAGAINSTLAW") nSpell=SPELL_MAGIC_CIRCLE_AGAINST_LAW;
  else if (sSpell=="MAGICVESTMENT") nSpell=SPELL_MAGIC_VESTMENT;
  else if (sSpell=="MASSHEAL") nSpell=SPELL_MASS_HEAL;
  else if (sSpell=="MINORGLOBEOFINVULNERABILITY") nSpell=SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
  else if (sSpell=="MORDENKAINENSSWORD") nSpell=SPELL_MORDENKAINENS_SWORD;
  else if (sSpell=="NEGATIVEENERGYPROTECTION") nSpell=SPELL_NEGATIVE_ENERGY_PROTECTION;
  else if (sSpell=="NEUTRALIZEPOISON") nSpell=SPELL_NEUTRALIZE_POISON;
  else if (sSpell=="OWLSWISDOM") nSpell=SPELL_OWLS_WISDOM;
  else if (sSpell=="PRAYER") nSpell=SPELL_PRAYER;
  else if (sSpell=="PREMONITION") nSpell=SPELL_PREMONITION;
  else if (sSpell=="PROTECTIONFROMCHAOS") nSpell=SPELL_PROTECTION__FROM_CHAOS;
  else if (sSpell=="PROTECTIONFROMELEMENTS") nSpell=SPELL_PROTECTION_FROM_ELEMENTS;
  else if (sSpell=="PROTECTIONFROMEVIL") nSpell=SPELL_PROTECTION_FROM_EVIL;
  else if (sSpell=="PROTECTIONFROMGOOD") nSpell=SPELL_PROTECTION_FROM_GOOD;
  else if (sSpell=="PROTECTIONFROMLAW") nSpell=SPELL_PROTECTION_FROM_LAW;
  else if (sSpell=="PROTECTIONFROMSPELLS") nSpell=SPELL_PROTECTION_FROM_SPELLS;
  else if (sSpell=="REGENERATE") nSpell=SPELL_REGENERATE;
  else if (sSpell=="REMOVEBLINDNESSANDDEAFNESS") nSpell=SPELL_REMOVE_BLINDNESS_AND_DEAFNESS;
  else if (sSpell=="REMOVECURSE") nSpell=SPELL_REMOVE_CURSE;
  else if (sSpell=="REMOVEDISEASE") nSpell=SPELL_REMOVE_DISEASE;
  else if (sSpell=="REMOVEFEAR") nSpell=SPELL_REMOVE_FEAR;
  else if (sSpell=="REMOVEPARALYSIS") nSpell=SPELL_REMOVE_PARALYSIS;
  else if (sSpell=="RESISTELEMENTS") nSpell=SPELL_RESIST_ELEMENTS;
  else if (sSpell=="RESISTANCE") nSpell=SPELL_RESISTANCE;
  else if (sSpell=="RESTORATION") nSpell=SPELL_RESTORATION;
  else if (sSpell=="SANCTUARY") nSpell=SPELL_SANCTUARY;
  else if (sSpell=="SEEINVISIBILITY") nSpell=SPELL_SEE_INVISIBILITY;
  else if (sSpell=="SHAPECHANGE") nSpell=SPELL_SHAPECHANGE;
  else if (sSpell=="SHIELDOFLAW") nSpell=SPELL_SHIELD_OF_LAW;
  else if (sSpell=="SPELLMANTLE") nSpell=SPELL_SPELL_MANTLE;
  else if (sSpell=="SPELLRESISTANCE") nSpell=SPELL_SPELL_RESISTANCE;
  else if (sSpell=="SPHEREOFCHAOS") nSpell=SPELL_SPHERE_OF_CHAOS;
  else if (sSpell=="STONESKIN") nSpell=SPELL_STONESKIN;
  else if (sSpell=="SUMMONCREATUREI") nSpell=SPELL_SUMMON_CREATURE_I;
  else if (sSpell=="SUMMONCREATUREII") nSpell=SPELL_SUMMON_CREATURE_II;
  else if (sSpell=="SUMMONCREATUREIII") nSpell=SPELL_SUMMON_CREATURE_III;
  else if (sSpell=="SUMMONCREATUREIV") nSpell=SPELL_SUMMON_CREATURE_IV;
  else if (sSpell=="SUMMONCREATUREV") nSpell=SPELL_SUMMON_CREATURE_V;
  else if (sSpell=="SUMMONCREATUREVI") nSpell=SPELL_SUMMON_CREATURE_VI;
  else if (sSpell=="SUMMONCREATUREVII") nSpell=SPELL_SUMMON_CREATURE_VII;
  else if (sSpell=="SUMMONCREATUREVIII") nSpell=SPELL_SUMMON_CREATURE_VIII;
  else if (sSpell=="SUMMONCREATUREIX") nSpell=SPELL_SUMMON_CREATURE_IX;
  else if (sSpell=="TENSERSTRANSFORMATION") nSpell=SPELL_TENSERS_TRANSFORMATION;
  else if (sSpell=="TIMESTOP") nSpell=SPELL_TIME_STOP;
  else if (sSpell=="TRUESEEING") nSpell=SPELL_TRUE_SEEING;
  else if (sSpell=="UNHOLYAURA") nSpell=SPELL_UNHOLY_AURA;
  else if (sSpell=="VIRTUE") nSpell=SPELL_VIRTUE;
  else if (sSpell=="WORDOFFAITH") nSpell=SPELL_WORD_OF_FAITH;
  if (nSpell!=0)
  { // spell is okay
    /*if(GetHasSpell(nSpell,OBJECT_SELF)==TRUE)
    { // has the spell so cast it    */
      ActionCastSpellAtObject(nSpell,OBJECT_SELF);
   // } // has the spell so cast it
    return 12.0;
  } // spell is okay
  return 0.0;
} // fnNPCACTF_CAST()

float fnNPCACTF_CLEN()
{ // PURPOSE: Cleanup non-plot items lying around
  // LAST MODIFIED BY: Deva Bryson Winblood
  int nFound=FALSE;
  int nC=1;
  object oItem=GetNearestObject(OBJECT_TYPE_ITEM,OBJECT_SELF,nC);
  float fDist=GetDistanceBetween(OBJECT_SELF,oItem);
  float fDur=0.2;
  while(GetIsObjectValid(oItem)&&!nFound&&fDist<=8.0)
  { // look for item
    if (GetPlotFlag(oItem)==FALSE) nFound=TRUE;
    else
    {
     nC++;
     oItem=GetNearestObject(OBJECT_TYPE_ITEM,OBJECT_SELF,nC);
    }
  } // look for item
  if (nFound)
  {
    ActionMoveToObject(oItem);
    ActionPickUpItem(oItem);
    ActionDoCommand(DestroyObject(oItem));
    fDur=18.0;
  }
  return fDur;
} // fnNPCACTF_CLEN()

float fnNPCACTF_CLLD()
{ // PURPOSE: To close any open containers
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oOb;
  int nC=1;
  float fDist;
  float fDur=0.0;
  int bFound=FALSE;
  oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,OBJECT_SELF,nC);
  fDist=GetDistanceBetween(OBJECT_SELF,oOb);
  while(GetIsObjectValid(oOb)&&!bFound&&fDist<=8.0)
  { // look for containers
    if (GetHasInventory(oOb)&&GetIsOpen(oOb))
    {
      bFound=TRUE;
    }
    else
    {
      nC++;
      oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,OBJECT_SELF,nC);
      fDist=GetDistanceBetween(OBJECT_SELF,oOb);
    }
  } // look for containers
  if (bFound)
  { // container found
    ActionMoveToObject(oOb);
    ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,1.0,2.0);
    ActionDoCommand(AssignCommand(oOb,ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE,1.0,4.0)));
    fDur=12.0;
  } // container found
  return fDur;
} // fnNPCACTF_CLLD()

float fnNPCACTF_CLO(string sParm)
{ // PURPOSE: To cause the NPC to change into clothes with resref stored
  // on variable sNPCActCloth#.
  // LAST MODIFIED BY: Deva Bryson Winblood
  string sClothVar="sNPCActCloth"+GetStringRight(sParm,1);
  string sClothResRef=GetLocalString(OBJECT_SELF,sClothVar);
  if (GetStringLength(sClothResRef)>2)
  { // we have clothing
    object oClothing=GetItemInSlot(INVENTORY_SLOT_CHEST); // currently wearing
    //SendMessageToPC(GetFirstPC(),"WEARING:"+GetTag(oClothing));
    if (sClothResRef!="NONE")
    { // create new clothing
     object oNewCloth=CreateItemOnObject(sClothResRef);
     if (oNewCloth!=OBJECT_INVALID)
     { //!OI
       ActionEquipItem(oNewCloth,INVENTORY_SLOT_CHEST);
       //SendMessageToPC(GetFirstPC(),"CHANGED:"+GetTag(oNewCloth));
       ActionDoCommand(DestroyObject(oClothing)); // destroy old clothing
     } //!OI
    } // create new clothing
    else if (sClothResRef=="NONE")
      ActionDoCommand(DestroyObject(oClothing)); // destroy old clothing
    return 4.0;
  } // we have clothing
  else { return 0.0; }
}// fnNPCACTF_CLO()

float fnNPCACTF_DRD()
{ // PURPOSE: To choose a random nearby door as the NPCs next destination
  // LAST MODIFIED BY: Deva Bryson Winblood
  int nLoop=1;
  int nCount=0;
  object oDoor=GetNearestObject(OBJECT_TYPE_DOOR,OBJECT_SELF,nLoop);
  while(nCount<10&&oDoor!=OBJECT_INVALID)
  { // door
    nCount++;
    nLoop++;
    oDoor=GetNearestObject(OBJECT_TYPE_DOOR,OBJECT_SELF,nLoop);
  } // door
  nLoop=Random(nCount)+1;
  oDoor=GetNearestObject(OBJECT_TYPE_DOOR,OBJECT_SELF,nLoop);
  SetLocalString(OBJECT_SELF,"sGNBDTag",GetTag(oDoor));
  return 0.4;
} // fnNPCACTF_DRD()

float fnNPCACTF_EAT()
{ // PURPOSE: To look for nearby food items and eat it
  // LAST MODIFIED BY: Deva Bryson Winblood
  int bFound=FALSE;
  float fDur=0.0;
  int nC=1;
  float fDist;
  object oItem;
  string sTag;
  oItem=GetNearestObject(OBJECT_TYPE_ITEM,OBJECT_SELF,nC);
  fDist=GetDistanceBetween(OBJECT_SELF,oItem);
  while(!bFound&&GetIsObjectValid(oItem)&&fDist<=8.0)
  { // find food
    sTag=GetTag(oItem);
    if (sTag=="FOOD"||sTag=="NW_IT_MSMLMISC20"||sTag=="NW_IT_MMIDMISC05")
    { // found
      bFound=TRUE;
    } // found
    else
    { // next
      nC++;
      oItem=GetNearestObject(OBJECT_TYPE_ITEM,OBJECT_SELF,nC);
      fDist=GetDistanceBetween(OBJECT_SELF,oItem);
    } // next
  } // find food
  if (bFound)
  { // found food
    fDur=18.0;
    ActionMoveToObject(oItem);
    ActionPickUpItem(oItem);
    ActionDoCommand(DestroyObject(oItem));
  } // found food
  return fDur;
} // fnNPCACTF_EAT()

float fnNPCACTF_Follow(int nParm)
{ // PURPOSE: Follow a target
  // LAST MODIFIED BY: Deva Bryson Winblood
  int nFound=FALSE;
  int nLoop=1;
  object oTarget;
  while(!nFound)
  { // look for someone to follow
    oTarget=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
    nLoop++;
    if (GetIsObjectValid(oTarget))
    { // !OI
      if((nParm==0)&&(GetGender(oTarget)==GENDER_FEMALE))
        nFound=TRUE;
      else if ((nParm==1)&&(GetGender(oTarget)==GENDER_MALE))
        nFound=TRUE;
      else if (nParm==2)
        nFound=TRUE;
      else if ((nParm==3)&&(GetIsPC(oTarget)))
        nFound=TRUE;
      else if ((nParm==4)&&(GetIsPC(oTarget))&&(GetGender(oTarget)==GENDER_FEMALE))
        nFound=TRUE;
      else if ((nParm==5)&&(GetIsPC(oTarget))&&(GetGender(oTarget)==GENDER_MALE))
        nFound=TRUE;
    } // !OI
    else
      nFound=TRUE; // end of objects
  } // look for someone to follow
  if (GetIsObjectValid(oTarget))
  { // follow them
   ActionMoveToObject(oTarget,FALSE,1.5);
   ActionForceFollowObject(oTarget,1.5);
   return 300.0;
  } // follow them
  else
  { return 0.4; }
} // fnNPCACTF_Follow()

float fnNPCACTF_KILL()
{ // PURPOSE: To attack a nearby PC or NPC
  // LAST MODIFIED BY: Deva Bryson Winblood
  object oCr=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,1,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  if (GetIsObjectValid(oCr))
  { // found target
    SetIsTemporaryEnemy(oCr);
    AssignCommand(OBJECT_SELF,ActionAttack(oCr));
    return 20.0;
  } // found target
  else { return 0.0; }
} // fnNPCACTF_KILL()

void NPCACTPKLK(object oLock)
{ // PURPOSE: Pick lock support function
  // LAST MODIFIED BY: Deva Bryson Winblood
  if (!GetLocked(oLock))
   AssignCommand(oLock,ActionSpeakString("*click*"));
} // NPCACTPKLK support function

//------------------------------------------------------[ PKLK ]------------
float fnNPCACTF_PickLock()
{ // PURPOSE: NPC will attempt to pick lock of nearby locked door
  // LAST MODIFIED BY: Deva Bryson Winblood
  if(GetHasSkill(SKILL_OPEN_LOCK,OBJECT_SELF)==TRUE)
  { // has the skill
    int nLoop=1;
    object oDoor=GetNearestObject(OBJECT_TYPE_DOOR,OBJECT_SELF,nLoop);
    while (oDoor!=OBJECT_INVALID&&nLoop<5&&!GetLocked(oDoor)&&GetDistanceBetween(oDoor,OBJECT_SELF)<=6.0)
    { // look for door
      nLoop++;
      oDoor=GetNearestObject(OBJECT_TYPE_DOOR,OBJECT_SELF,nLoop);
    } // look for door
    if (oDoor==OBJECT_INVALID)
    { // look for container
      nLoop=1;
      oDoor=GetNearestObject(OBJECT_TYPE_PLACEABLE,OBJECT_SELF,nLoop);
      while(oDoor!=OBJECT_INVALID&&nLoop<5&&!GetLocked(oDoor)&&GetDistanceBetween(oDoor,OBJECT_SELF)<=6.0)
      { // check containers
        nLoop++;
        oDoor=GetNearestObject(OBJECT_TYPE_PLACEABLE,OBJECT_SELF,nLoop);
      } // check containers
    } // look for container
    if (oDoor!=OBJECT_INVALID&&GetLocked(oDoor))
    { // this is the one
      ActionMoveToObject(oDoor,FALSE,1.0);
      ActionUseSkill(SKILL_OPEN_LOCK,oDoor);
      DelayCommand(5.0,AssignCommand(OBJECT_SELF,NPCACTPKLK(oDoor)));
      return 12.0;
    } // this is the one
    else { return 0.2; }
  } // has the skill
  else { return 0.0; }
}// fnNPCACTF_PickLock()


float fnNPCACTF_Taunt()
{ // PURPOSE: look for someone not of your faction or a PC to taunt
  // LAST MODIFIED BY: Deva Bryson Winblood
 int nLoop=1;
 int nFound=FALSE;
 object oVictim;
 while(!nFound)
 { // look for a victim
   oVictim=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
   nLoop++;
   if (oVictim!=OBJECT_INVALID)
   { // !OI
    if ((GetIsPC(oVictim))||(!GetFactionEqual(oVictim)&&GetLocalInt(OBJECT_SELF,"nGNBNN")==FALSE))
     nFound=TRUE;
   } // !OI
   else
    nFound=TRUE; // hit end of objects
 } // look for a victim
 if (oVictim!=OBJECT_INVALID)
 { // a victim was found
  ActionMoveToObject(oVictim,FALSE,0.8);
  ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT,1.0,2.0);
  if (GetHasSkill(SKILL_TAUNT))
   ActionUseSkill(SKILL_TAUNT,oVictim);
  return 12.0;
 } // a victim was found
 else { return 0.2; }
} //fnNPCACTF_Taunt()

float fnNPCACTF_Use()
{ // PURPOSE:  TO enable the NPC to use an object within 8 meters
  // LAST MODIFIED BY: Deva Bryson Winblood
  int nC=1;
  float fDur=0.2;
  float fDist;
  object oOb;
  int bFound=FALSE;
  oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,OBJECT_SELF,nC);
  fDist=GetDistanceBetween(OBJECT_SELF,oOb);
  while(!bFound&&GetIsObjectValid(oOb)&&fDist<=8.0)
  { // find target
    if (GetUseableFlag(oOb))
    {
      bFound=TRUE;
    }
    else
    {
      nC++;
      oOb=GetNearestObject(OBJECT_TYPE_PLACEABLE,OBJECT_SELF,nC);
      fDist=GetDistanceBetween(OBJECT_SELF,oOb);
    }
  } // find target
  if (bFound)
  {
    fDur=12.0;
    ActionMoveToObject(oOb);
    ActionInteractObject(oOb);
  }
  return fDur;
} // fnNPCACTF_Use()

float fnNPCACTF_Inn()
{  // backwards compatibility
  int nAct=Random(5)+1;
  object oDest;
  string sMsg;
  string sTag="INN_";
  int nTest;
  float fDelay=0.5;
  switch(nAct)
  { // nAct
    case 1: sTag=sTag+"BARTENDER"; break;
    case 2: sTag=sTag+"BAR"; break;
    case 3: sTag=sTag+"TABLE"; break;
    case 4: sTag=sTag+"BARMAID"; break;
    case 5:
    default: sTag=sTag+"GROUP"; break;
  } // nAct
  oDest=GetNearestObjectByTag(sTag,OBJECT_SELF,1);
  if (oDest!=OBJECT_INVALID)
  { // !OI
    ActionMoveToObject(oDest,FALSE,1.0);
    switch(nAct)
    { // action
      case 1: {
        nTest=d6();
        if (nTest==1) sMsg="Haha you have some mighty fine drinks.";
        else if (nTest==2) sMsg="I'll have another ale down here!";
        else if (nTest==3) sMsg="This is the life.  It beats workin'.";
        else if (nTest==4) sMsg="It's spirits that I'll be drinkin'";
        else if (nTest==5) sMsg="I saysh itsss mines... gets back. Go getsss yourss own.";
        else if (nTest==6) sMsg="I betsss I kin drink yousss into unconciousness.";
        ActionSpeakString(sMsg);
        break;
      } // Bartender
      case 2: {
       nTest=d4();
       if (nTest==1) sMsg="Give me a spirtsssssss.  Haha didss you hear how many sssssssss essss I said.  Haha";
       else if (nTest==2) sMsg="A little meat here for my drink to cling to if you please.";
       else if (nTest==3) sMsg="Kin I'sss haves another drinkssss on credit?";
       else sMsg="That is good stuff.";
       ActionSpeakString(sMsg);
       break;
      } // BAR
      case 3: {
       nTest=d4();
       sMsg="hic";
       if (nTest==1) ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,1.0,8.0);
       else if (nTest==2) ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD,1.0,3.0);
       else if (nTest==3) sMsg="I might need another drink.";
       else if (nTest==4) sMsg="Tis' a good night for drinking with my friends.";
       ActionSpeakString(sMsg);
       break;
      } // TABLE
      case 4: {
       nTest=d6();
       sMsg="Your a fine wench. Hic.";
       if (nTest==1) ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,1.0,5.0);
       else if (nTest==2) ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0,4.0);
       else if (nTest==3) sMsg="Hoy!!!! I need a drink!";
       else if (nTest==4) sMsg="Your not watering this down are ya?";
       else if (nTest==5) sMsg="A drink today, will save the day!!";
       else if (nTest==6) sMsg="What do you mean I've been cut off? The nigh is still young! Hic.";
       ActionSpeakString(sMsg);
       break;
      } // BARMAID
      case 5: {
       nTest=d6();
       sMsg="I tell you it is true!!";
       if (nTest==1) ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,1.0,5.0);
       else if (nTest==2) ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1,1.0,3.0);
       else if (nTest==3) ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,3.0);
       else if (nTest==4) sMsg="That's what they always say.";
       else if (nTest==5) sMsg="Go on drink some more.";
       else if (nTest==6) sMsg="This beats work don't it?";
       ActionSpeakString(sMsg);
      break;
      } // GROUP
    } // action
  } // !OI
  return fDelay;
} // fnNPCACTF_Inn()

float fnNPCACTF_Proposition()
{
  string sProp="Why don't you come sit with me for awhile.";
  object oTarget;
  int nLoop=1;
  int nFound=FALSE;
  float fDelay=0.1;
  switch(Random(3))
  { // random statement
   case 0: sProp="Are you looking for a good time?";
    break;
   case 1: sProp="Would you like some company tonight?";
   default: break;
  } // random statement
  while(!nFound&&nLoop<10)
  { // look for client
   oTarget=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
   nLoop++;
   if(oTarget!=OBJECT_INVALID)
   { // !OI
    if(GetGender(oTarget)!=GetGender(OBJECT_SELF))
     nFound=TRUE;
   } // !OI
   else
    nFound=TRUE; // end of objects
  } // look for client
  if (oTarget!=OBJECT_INVALID)
  { // client found
    fDelay=12.0;
    ActionMoveToObject(oTarget,FALSE,0.8);
    SetFacingPoint(GetPosition(oTarget));
    ActionSpeakString(sProp);
    ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,1.0,3.0);
  } // client found
  return fDelay;
} // fnNPCACTF_Proposition()

float fnNPCACTF_Polymorph(string sPoly)
{
  string sRem=sPoly;
  int nPoly=0;
  if (GetStringLeft(sPoly,4)=="POLY") sRem=GetStringRight(sPoly,GetStringLength(sPoly)-4);
  if (GetStringLeft(sPoly,2)=="PY") sRem=GetStringRight(sPoly,GetStringLength(sPoly)-2);
  nPoly=StringToInt(sRem);
  fnDebug("fnNPCACTF_Polymorph("+sPoly+") nPoly:"+IntToString(nPoly),TRUE);
  int nPolySug=POLYMORPH_TYPE_BADGER;
  if (nPoly==1) nPolySug=POLYMORPH_TYPE_BALOR;
  else if (nPoly==2) nPolySug=POLYMORPH_TYPE_BOAR;
  else if (nPoly==3) nPolySug=POLYMORPH_TYPE_BROWN_BEAR;
  else if (nPoly==4) nPolySug=POLYMORPH_TYPE_COW;
  else if (nPoly==5) nPolySug=POLYMORPH_TYPE_DEATH_SLAAD;
  else if (nPoly==6) nPolySug=POLYMORPH_TYPE_DIRE_BADGER;
  else if (nPoly==7) nPolySug=POLYMORPH_TYPE_DIRE_BOAR;
  else if (nPoly==8) nPolySug=POLYMORPH_TYPE_DIRE_BROWN_BEAR;
  else if (nPoly==9) nPolySug=POLYMORPH_TYPE_DIRE_PANTHER;
  else if (nPoly==10) nPolySug=POLYMORPH_TYPE_DIRE_WOLF;
  else if (nPoly==11) nPolySug=POLYMORPH_TYPE_DOOM_KNIGHT;
  else if (nPoly==12) nPolySug=POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL;
  else if (nPoly==13) nPolySug=POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL;
  else if (nPoly==14) nPolySug=POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL;
  else if (nPoly==15) nPolySug=POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL;
  else if (nPoly==16) nPolySug=POLYMORPH_TYPE_FIRE_GIANT;
  else if (nPoly==17) nPolySug=POLYMORPH_TYPE_GIANT_SPIDER;
  else if (nPoly==18) nPolySug=POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL;
  else if (nPoly==19) nPolySug=POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL;
  else if (nPoly==20) nPolySug=POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL;
  else if (nPoly==21) nPolySug=POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL;
  else if (nPoly==22) nPolySug=POLYMORPH_TYPE_IMP;
  else if (nPoly==23) nPolySug=POLYMORPH_TYPE_IRON_GOLEM;
  else if (nPoly==24) nPolySug=POLYMORPH_TYPE_PANTHER;
  else if (nPoly==25) nPolySug=POLYMORPH_TYPE_PENGUIN;
  else if (nPoly==26) nPolySug=POLYMORPH_TYPE_PIXIE;
  else if (nPoly==27) nPolySug=POLYMORPH_TYPE_QUASIT;
  else if (nPoly==28) nPolySug=POLYMORPH_TYPE_RED_DRAGON;
  else if (nPoly==29) nPolySug=POLYMORPH_TYPE_SUCCUBUS;
  else if (nPoly==30) nPolySug=POLYMORPH_TYPE_TROLL;
  else if (nPoly==31) nPolySug=POLYMORPH_TYPE_UMBER_HULK;
  else if (nPoly==32) nPolySug=POLYMORPH_TYPE_WERECAT;
  else if (nPoly==33) nPolySug=POLYMORPH_TYPE_WERERAT;
  else if (nPoly==34) nPolySug=POLYMORPH_TYPE_WEREWOLF;
  else if (nPoly==35) nPolySug=POLYMORPH_TYPE_WOLF;
  else if (nPoly==36) nPolySug=POLYMORPH_TYPE_YUANTI;
  else if (nPoly==37) nPolySug=POLYMORPH_TYPE_ZOMBIE;
  effect ePoly=EffectPolymorph(nPolySug);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY,ePoly,OBJECT_SELF,30.0);
  return 2.0;
} // fnNPCACTF_Polymorph()

float fnNPCACTF_SummonCreature(string sParm)
{
  string sSC=GetStringRight(sParm,1);
  string sMonResRef="";
  if (sSC=="0")
  { // 0 level
    switch (d4())
    { // 0 level
      case 1: sMonResRef="nw_badger"; break;
      case 2: sMonResRef="nw_bat"; break;
      case 3: sMonResRef="nw_btlfire"; break;
      case 4: sMonResRef="nw_goblina"; break;
    } // 0 level
  } // 0 level
  else if (sSC=="1")
  { // 1 Level
    switch (d4())
    { // Level 1
      case 1: sMonResRef="nw_dog"; break;
      case 2: sMonResRef="nw_nixie"; break;
      case 3: sMonResRef="nw_wolf"; break;
      case 4: sMonResRef="nw_dog"; break;
    } // Level 1
  } // 1 Level
  else if (sSC=="2")
  { // 2 Level
    switch(d4())
    { // Level 2
      case 1: sMonResRef="nw_pixie"; break;
      case 2: sMonResRef="nw_bearblck"; break;
      case 3: sMonResRef="nw_mepdust"; break;
      case 4: sMonResRef="nw_btlfire02"; break;
    } // Level 2
  } // 2 Level
  else if (sSC=="3")
  { // 3 Level
    switch(d4())
    { // Level 3
      case 1: sMonResRef="nw_nymph"; break;
      case 2: sMonResRef="nw_imp"; break;
      case 3: sMonResRef="nw_worg"; break;
      case 4: sMonResRef="nw_spidgiant"; break;
    } // Level 3
  } // 3 Level
  else if (sSC=="4")
  { // 4 Level
    switch(d4())
    { // Level 4
      case 1: sMonResRef="nw_lion"; break;
      case 2: sMonResRef="nw_fenhound"; break;
      case 3: sMonResRef="nw_ettercap"; break;
      case 4: sMonResRef="nw_minotaur"; break;
    } // Level 4
  } // 4 Level
  else if (sSC=="5")
  { // 5 Level
    switch(d4())
    { // Level 5
      case 1: sMonResRef="nw_bearbrwn"; break;
      case 2: sMonResRef="nw_direwolf"; break;
      case 3: sMonResRef="nw_boardire"; break;
      case 4: sMonResRef="nw_troll"; break;
    } // Level 5
  } // 5 Level
  else if (sSC=="6")
  { // 6 Level
    switch(d6())
    { // Level 6
      case 1: sMonResRef="nw_air"; break;
      case 2: sMonResRef="nw_earth"; break;
      case 3: sMonResRef="nw_fire"; break;
      case 4: sMonResRef="nw_water"; break;
      case 5: sMonResRef="nw_bearkodiak"; break;
      case 6: sMonResRef="nw_wolfwint"; break;
    } // Level 6
  } // 6 Level
  else if (sSC=="7")
  { // 7 Level
    switch(d4())
    { // Level 7
      case 1: sMonResRef="nw_umberhulk"; break;
      case 2: sMonResRef="nw_devour"; break;
      case 3: sMonResRef="nw_slaadbl"; break;
      case 4: sMonResRef="nw_shadow"; break;
    } // Level 7
  } // 7 Level
  else if (sSC=="8")
  { // 8 Level
    switch(d4())
    { // Level 8
      case 1: sMonResRef="nw_chound01"; break;
      case 2: sMonResRef="nw_allip"; break;
      case 3: sMonResRef="nw_grayrend"; break;
      case 4: sMonResRef="nw_minchief"; break;
    } // Level 8
  } // 8 Level
  else if (sSC=="9")
  { // 9 Level
    switch(d4())
    { // Level 9
      case 1: sMonResRef="nw_dmsucubus"; break;
      case 2: sMonResRef="nw_slaadgrn"; break;
      case 3: sMonResRef="nw_beardire"; break;
      case 4: sMonResRef="nw_minwiz"; break;
    } // Level 9
  } // 9 Level
  if (GetStringLength(sMonResRef)>4)
  { // conjure
    effect eSummon=EffectSummonCreature(sMonResRef,VFX_FNF_SUMMON_MONSTER_1,2.0);
    vector vSummon;
    location lSelf=GetLocation(OBJECT_SELF);
    vSummon=GetPosition(OBJECT_SELF);
    vSummon.x=vSummon.x+1.0;
    vSummon.y=vSummon.y+1.0;
    location lSummon=Location(GetArea(OBJECT_SELF),vSummon,GetFacing(OBJECT_SELF));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eSummon,lSummon,2.0);
    object oCreature=CreateObject(OBJECT_TYPE_CREATURE,sMonResRef,lSummon,TRUE);
    ChangeFaction(oCreature,OBJECT_SELF);
  } // conjure
 return 2.0;
}// fnNPCACTF_SummonCreature()

float fnNPCACTF_SayPhrase(string sParm)
{
  int nPhrase=StringToInt(GetStringRight(sParm,1));
  string sName="sSayString"+IntToString(nPhrase);
  string sToSay=GetLocalString(OBJECT_SELF,sName);
  if (GetStringLength(sToSay)<1)
  { // look for way points with the phrase
   sName="VAR_"+GetTag(OBJECT_SELF)+"_"+IntToString(nPhrase);
   object oWP=GetObjectByTag(sName);
   if (oWP!=OBJECT_INVALID)
   { // !OI
    sToSay=GetName(oWP);
   } // !OI
  } // look for way points with the phrase
  ActionSpeakString(sToSay);
  return 0.1;
}// fnNPCACTF_SayPhrase()

void GNBRemoveEffect(int nEffectType, object oTarget=OBJECT_SELF)
{
  effect eCheck=GetFirstEffect(oTarget);
  while(GetIsEffectValid(eCheck))
  { //
    if (GetEffectType(eCheck)==nEffectType)
      AssignCommand(oTarget,RemoveEffect(oTarget,eCheck));
    eCheck=GetNextEffect(oTarget);
  } //
} // GNBRemoveEffect()

float fnNPCACTF_Wake()
{
  int nFound=FALSE;
  int nLoop=1;
  object oTarget;
  float fDelay=0.2;
  while(!nFound)
  { // Find target
   oTarget=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop);
   if (oTarget!=OBJECT_INVALID&&GetDistanceBetween(oTarget,OBJECT_SELF)<=10.0)
   { // !OI
    if (GetLocalInt(oTarget,"nGNBSleeping")==TRUE)
     nFound=TRUE; // this is the one
   } // !OI
   nLoop++;
   if(nLoop>5||oTarget==OBJECT_INVALID) nFound=TRUE; // exit loop
  } // Find Target
  if (oTarget!=OBJECT_INVALID)
  { // wake
    fDelay=12.0;
    ActionMoveToObject(oTarget,FALSE,0.5);
    ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,1.0,3.0);
    ActionSpeakString("Awaken you.");
    AssignCommand(oTarget,ClearAllActions());
    DelayCommand(2.0,GNBRemoveEffect(EFFECT_TYPE_SLEEP, oTarget));
    SetLocalInt(oTarget,"nGNBMaxHB",0);
    SetLocalInt(oTarget,"nGNBSleeping",FALSE);
  } // wake
  return fDelay;
}// fnNPCACTF_Wake()

float fnNPCACTF_CopyVar(string sParm)
{
  int nVarNum=StringToInt(GetStringRight(sParm,1));
  string sName="nNPCActionVar"+IntToString(nVarNum);
  int nLoop=1;
  int nValue=GetLocalInt(OBJECT_SELF,sName);
  int nCopy=0;
  object oPerson=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop);
  while(oPerson!=OBJECT_INVALID&&GetDistanceBetween(OBJECT_SELF,oPerson)<=5.0)
  { // !OI
   if(GetLocalInt(oPerson,sName)>nCopy) nCopy=GetLocalInt(oPerson,sName);
   nLoop++;
   oPerson=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop);
  } // !OI
  if (nCopy>nValue)
   SetLocalInt(OBJECT_SELF,sName,nCopy);
  return 0.5;
}// fnNPCACTF_CopyVar()

//void main(){}
