////////////////////////////////////////////////////////////////////////////////
// npcact_ext_react - NPC ACTIVITIES 6.0  React external command
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             06/13/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/13/2004
////////////////////////////////////////////////////////////////////////////////

void main()
{
  int nLoop=1;
  int nFound=FALSE;
  int nReact=0; // reaction type
  int nWork1;
  int nWork2;
  float fDelay=0.5;
  string sMsg;
  object oCreature=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
  while (nLoop<10&&oCreature!=OBJECT_INVALID)
  { // while
    nWork1=GetHitDice(OBJECT_SELF);
    nWork2=GetHitDice(oCreature);
    if (nWork1<(nWork2-5))
    { // powerful character
      nReact=1;
      nLoop=20; // exit loop
    } // powerful character
    else
    { // wounded
      nWork1=GetMaxHitPoints(oCreature);
      nWork2=GetCurrentHitPoints(oCreature);
      if (nWork2<(nWork1/2))
      { // wounded character
        nReact=2;
        nLoop=20;
      } // wounded character
      else
      { // Large creature
        nWork1=GetCreatureSize(oCreature);
        if (nWork1==CREATURE_SIZE_HUGE||nWork1==CREATURE_SIZE_LARGE)
        { // big
          nReact=3;
          nLoop=20;
        } // big
        else
        { // faction not too liked
         nWork1=GetFactionAverageReputation(OBJECT_SELF,oCreature);
         if (nWork1<50)
         { // not liked
           nReact=4;
           nLoop=20;
         } // not liked
        } // faction not too liked
      } // Large creature
    } // wounded
    if(!nFound)
    { //!Found
     nLoop++;
     oCreature=GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE,OBJECT_SELF,nLoop,CREATURE_TYPE_PERCEPTION,PERCEPTION_SEEN);
    } //!Found
  } // while
  if(nFound)
  { // act on the person
   fDelay=6.0;
   nWork1=Random(3)+1;
   sMsg="";
   switch(nReact)
   {// switch
    case 1: { // powerful character
     if (nWork1==1) sMsg="Wow! That guy looks formidable.";
     else if (nWork1==2) sMsg="Whoa, I wouldn't want to be in a dark alley along with that one.";
     else if (nWork1==3) sMsg="I'm sorry.  I didn't do anything but, I'll get it out of the way before I do.";
     SetFacing(GetFacing(oCreature));
     ActionSpeakString(sMsg);
     break;
    } // powerful character
    case 2: { // wounded
     if (nWork1==1) sMsg="Oh gosh, you need healing.";
     else if (nWork1==2) sMsg="Ummm... you're bleeding.";
     else if (nWork1==3) sMsg="You need to seek out a healer.  I would if I were you.";
     SetFacing(GetFacing(oCreature));
     ActionSpeakString(sMsg);
     break;
    } // wounded
    case 3: { // big
     if (nWork1==1) sMsg="BIG!!!!!!";
     else if (nWork1==2) sMsg="Wow!  I better watch where that steps.";
     else if (nWork1==3) sMsg="An earthquake?  No it's that big thing.";
     ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1,1.0,2.0);
     ActionSpeakString(sMsg);
     ActionMoveAwayFromObject(oCreature,TRUE,8.0);
     fDelay=18.0;
    } // big
    case 4: { // not liked
     if (nWork1==1) sMsg="Ughhh... there is a foul smell on the wind.";
     else if (nWork1==2) sMsg="They'll let anyone come here these days.";
     else if (nWork1==3) sMsg="Look what came in.  Better hide your orc piss or they might drink it.";
     ActionSpeakString(sMsg);
     ActionMoveAwayFromObject(oCreature,FALSE,25.0);
     fDelay=24.0;
     break;
    } // not liked
    default: break;
   } // switch
  } // act on the person
  SetLocalFloat(OBJECT_SELF,"fDelay",fDelay);
} // NPCAct4React()
