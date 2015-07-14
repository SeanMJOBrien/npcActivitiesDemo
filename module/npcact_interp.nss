////////////////////////////////////////////////////////////////////////////////
// npcact_interp - NPC ACTIVITIES 6.0  Full version Interpretter
//------------------------------------------------------------------------------
// By Deva Bryson Winblood             04/30/2004
//------------------------------------------------------------------------------
// Last Modified By: Deva Bryson Winblood
// Last Modified Date: 06/03/2004
// modified for ~ anim peak 4/15/09
////////////////////////////////////////////////////////////////////////////////
#include "npcactivitiesh"
#include "npcact_h_cust"   // customization
#include "npcact_h_core"   // core commands
#include "npcact_h_logic"  // logic commands
#include "npcact_h_make"   // creation commands
#include "npcact_h_var"    // variable initialization and setting commands
#include "npcact_h_vfx"    // visual effect commands
#include "npcact_h_speak"  // Speaking and singing related commands
#include "npcact_ho_core"  // Core commands for FULL interpreter
/////////////////////////
// PROTOTYPES
/////////////////////////

void fnDoPauseThenEnd();

///////////////////////////////////////////////////////////////////////// MAIN
void main()
{
   object oMe=OBJECT_SELF;
   string sAct=GetLocalString(oMe,"sAct");
   float fDelay=0.2; // default delay
   string sCommand=fnParse(sAct);
   string sL1=GetStringLeft(sAct,1);
   string sL2=GetStringLeft(sAct,2);
   string sL3=GetStringLeft(sAct,3);
   string sL4=GetStringLeft(sAct,4);
   string sS;
   int nR;
   int nGNBDisabled=GetLocalInt(oMe,"nGNBDisabled");
   effect eE;
   fnDebug(GetTag(oMe)+" FULL INTERPRETER ("+sCommand+")",TRUE);
   if (nGNBDisabled!=TRUE&&fnGetIsBusy(oMe)==FALSE&&GetStringLength(sAct)>0)
   { // okay to deal with commands
     fnDebug("   sAct Before='"+sAct+"' LEN:"+IntToString(GetStringLength(sAct)),TRUE);
     sAct=fnRemoveParsed(sAct,sCommand);
     fnDebug("   sAct After='"+sAct+"' LEN:"+IntToString(GetStringLength(sAct)),TRUE);
     SetLocalString(oMe,"sAct",sAct);
     SetLocalInt(oMe,"nGNBInterpActivity",0); // used as fail safe
     /// begin the big if/else if
     if (sL1=="@")
     { // custom script
       fnDebug("["+GetTag(oMe)+"]Custom Script("+sCommand+")",TRUE);
       fDelay=fnNPCACTAtScript(sCommand);
     } // custom script
     else if (sL1=="'")
     { // Quick speak
       fDelay=0.1;
       AssignCommand(oMe,SpeakString(GetStringRight(sCommand,GetStringLength(sCommand)-1)));
     } // Quick Speak
     else if (sL1=="#")
     { // library call
       fnDebug("["+GetTag(oMe)+"]Library Call("+sCommand+")",TRUE);
       fDelay=fnNPCACTLibCall(sCommand);
     } // library call
     else if (sL1=="*")
     { // professions call
       fnDebug("["+GetTag(oMe)+"]Professions Call("+sCommand+")",TRUE);
       fDelay=fnNPCACTProfCall(sCommand);
     } // professions call
     else if (sL1=="&")
     { // IF logic
       fDelay=fnNPCACTLogicCore(sCommand);
     } // IF logic
     else if (sL1=="!")
     { // Set variable
       fDelay=fnNPCACTSetVariable(sCommand);
     } // Set variable
     else if (sL1=="+"||sL1=="-")
     { // variable addition and subtraction
       fDelay=fnNPCACTAddSubtract(sCommand);
     } // variable addition and subtraction
     else if (sL1=="$")
     { // custom event script assign
       fDelay=fnNPCACTScriptSet(sCommand);
     } // custom event script assign
     else if (sL1=="^")
     { // non-visual effect
       fDelay=fnNPCACTNonVFX(sCommand);
     } // non-visual effect
     else if (sL1=="]")
     { // Set Appearance
       fDelay=fnNPCACTSetAppearance(sCommand);
     } // Set Appearance
     else if (sL1=="[")
     { // Set Mode
       fDelay=fnNPCACTModeSet(sCommand);
     } // Set Mode
     else if (sL1==">")
     { // Set timed event
       fDelay=fnNPCACTInsertTimedEvent(sCommand);
     } // Set timed event
     else if (sL1=="~"||sL4=="ANIM")
     { // animation command
       fDelay=fnNPCACTAnimate(sCommand);
     } // animation command
     else if (sL2=="TT")
     { // Talk to
       fDelay=fnNPCACTTalkTo(sCommand);
     } // Talk to
     else if (sL3=="RWL"||(sL2=="RW"&&GetStringLength(sCommand)>2))
     { // random word list
       fDelay=fnNPCACTRandomSpeak(sCommand);
     } // random word list
     else if (sL4=="LYRI"||sL2=="LY")
     { // sing song
       fDelay=fnNPCACTLyrical(sCommand);
     } // sing song
     else if (sL2=="RC")
     { // random command
       fDelay=fnNPCACTRandomCommand(sCommand);
     } // random command
     else if (sL2=="WP")
     { // set new destination
       sCommand=GetStringRight(sCommand,GetStringLength(sCommand)-2);
       SetLocalString(OBJECT_SELF,"sGNBDTag",sCommand);
     } // set new destination
     else if (sL1==":")
     { // create creature
       fDelay=fnNPCACTMakeCreature(sCommand);
     } // create creature
     else if (sL2=="AO")
     { // attack object by tag
       fDelay=fnNPCACTAttackObject(sCommand);
     } // attack object by tag
     else if (sL2=="CB")
     { // enter combat with person with specific tag
       fDelay=fnNPCACTEnterCombat(sCommand);
     } // enter combat with person with specific tag
     else if (sL2=="Cc")
     { // change clothing
       fDelay=fnNPCACTChangeClothes(sCommand);
     } // change clothing
     else if (sL2=="DO")
     { // Destroy Object by tag
       fDelay=fnNPCACTDestroyObject(sCommand);
     } // Destroy Object by tag
     else if (sL2=="EQ")
     { // Equip Weapons
       fDelay=fnNPCACTEquipWeapons();
     } // Equip Weapons
     else if (sL2=="UE")
     { // Unequip Weapons
       fDelay=fnNPCACTUnequipWeapons();
     } // Unequip Weapons
     else if (sCommand=="REST"||sCommand=="RS")
     { // rest
       fDelay=fnNPCACTRest();
     } // rest
     else if (sCommand=="SLEP"||sCommand=="SL")
     { // sleep
       fDelay=fnNPCACTSleep();
     } // sleep
     else if (sL4=="SITS")
     { // sits
       fDelay=fnNPCACTSitForSpecified(sCommand);
     } // sits
     else if (sL2=="CO"&&GetStringLength(sCommand)>2)
     { // create item
       fDelay=fnNPCACTMakeItem(sCommand);
     } // create item
     else if (sL2=="CP")
     { // create placeable
       fDelay=fnNPCACTMakePlaceable(sCommand);
     } // create placeable
     else if (sL4=="FOTG"||sL2=="FT")
     { // follow specific tag
       fDelay=fnNPCACTFollowByTag(sCommand);
     } // follow specific tag
     else if (sCommand=="RAND"||sCommand=="RW")
     { // random walk
       fDelay=fnNPCACTRandomWalk();
     } // random walk
     else if (sL4=="TAKE"||sL2=="TK")
     { // take item by tag
       fDelay=fnNPCACTTakeItem(sCommand);
     } // take item by tag
     else if (sL4=="WAIT"||sL2=="WT")
     { // wait
       fDelay=fnNPCACTWait(sCommand);
     } // wait
     else if (sL4=="SFAC"||sL2=="SF")
     { // Set Facing
       fDelay=fnNPCACTSetFacing(sCommand);
     } // Set Facing
     else if (sCommand=="LOCK"||sCommand=="lk")
     { // lock doors or container
       fDelay=fnNPCACTLockThings();
     } // lock doors or container
     else if (sCommand=="UNLOCK"||sCommand=="ul")
     { // unlock
       fDelay=fnNPCACTUnlock();
     } // unlock
     else if (sCommand=="CLOS"||sCommand=="CD")
     { // close door
       fDelay=fnNPCACTCloseDoors();
     } // close door
     else if (sL3=="LAG"||(sL1=="L"&&GetStringLength(sCommand)==2))
     { // lag commands
       sL1=GetStringRight(sCommand,1);
       if (sL1=="1") SetLocalInt(OBJECT_SELF,"nGNBLagMeth",1);
       else if (sL1=="2") SetLocalInt(OBJECT_SELF,"nGNBLagMeth",2);
       else if (sL1=="3") SetLocalInt(OBJECT_SELF,"nGNBLagMeth",3);
       else if (sL1=="4") SetLocalInt(OBJECT_SELF,"nGNBLagMeth",4);
     } // lag commands
     else if (sCommand=="NONP"||sCommand=="NN")
     { // no NPC interaction
       SetLocalInt(OBJECT_SELF,"nNN",TRUE);
       fDelay=0.1;
     } // no NPC interaction
     else if (sCommand=="YSNP"||sCommand=="YN")
     { // yes NPC interaction
       DeleteLocalInt(OBJECT_SELF,"nNN");
       fDelay=0.1;
     } // yes NPC interaction
     else if (sL2=="BS")
     { // base script set
       fDelay=fnNPCACTSetBaseScripts(sCommand);
     } // base script set
     else if (sL2=="BM")
     { // beam effect
       fDelay=fnNPCACTBeamEffect(sCommand);
     } // beam effect
     else if (sL3=="EFF")
     { // Effect
       fDelay=fnNPCACTEffects(sCommand);
     } // Effect
     else if (sL2=="FX")
     { // FX area
       fDelay=fnNPCACTPlaceableVFX(sCommand);
     } // FX area
     else if (sL2=="PF")
     { // persistent visual effect
       fDelay=fnNPCACTPersistentVFX(sCommand);
     } // persistent visual effect
     else if (sL2=="RV")
     { // remove visual effect
       fDelay=fnNPCACT4Visual(0,sCommand);
     } // remove visual effect
     else if (sL2=="VF")
     { // add visual effect
       fDelay=fnNPCACT4Visual(1,sCommand);
     } // add visual effect
     else if (sL2=="YP"||sL4=="YSPC")
     { // enable PC interaction
       DeleteLocalInt(OBJECT_SELF,"bNPCACTNOPC");
     } // enable PC interaction
     else if (sL2=="NP"||sL4=="NOPC")
     { // disable PC interaction
       SetLocalInt(OBJECT_SELF,"bNPCACTNOPC",TRUE);
     } // disable PC interaction
     else if (sCommand=="BORD"||sCommand=="BD")
     { // BORD Animation
       fDelay=fnNPCACTAnimate("ANIM6/30");
     } // BORD Animation
     else if (sCommand=="BOW"||sCommand=="BW")
     { // BOW Animation
       fDelay=fnNPCACTAnimate("ANIM1/20");
     } // BOW Animation
     else if (sCommand=="DRIN"||sCommand=="DR")
     { // DRINK Animation
       fDelay=fnNPCACTAnimate("ANIM2/20");
     } // DRINK Animation
     else if (sCommand=="DRUN"||sCommand=="DK")
     { // DRUNK Animation
       fDelay=fnNPCACTAnimate("ANIM22/60");
     } // DRUNK Animation
     else if (sCommand=="GRET"||sCommand=="GR")
     { // GRET Animation
       fDelay=fnNPCACTAnimate("ANIM3/20");
     } // GRET Animation
     else if (sCommand=="GRET"||sCommand=="GR")
     { // GRET Animation
       fDelay=fnNPCACTAnimate("ANIM3/20");
     } // GRET Animation
     else if (sCommand=="LIST"||sCommand=="LI")
     { // LIST Animation
       fDelay=fnNPCACTAnimate("ANIM18/20");
     } // LIST Animation
     else if (sCommand=="LOOK"||sCommand=="LK")
     { // LOOK Animation
       fDelay=fnNPCACTAnimate("ANIM19/30");
     } // LOOK Animation
     else if (sCommand=="LOW"||sCommand=="LW")
     { // LOW Animation
       fDelay=fnNPCACTAnimate("ANIM16/60");
     } // LOW Animation
     else if (sCommand=="MEDI"||sCommand=="ME")
     { // MEDI Animation
       fDelay=fnNPCACTAnimate("ANIM20/60");
     } // MEDI Animation
     else if (sCommand=="MID"||sCommand=="MD")
     { // MID Animation
       fDelay=fnNPCACTAnimate("ANIM17/60");
     } // MID Animation
     else if (sCommand=="PAU1"||sCommand=="P1")
     { // PAU1 Animation
       fDelay=fnNPCACTAnimate("ANIM21/30");
     } // PAU1 Animation
     else if (sCommand=="PAU2"||sCommand=="P2")
     { // PAU2 Animation
       fDelay=fnNPCACTAnimate("ANIM24/30");
     } // PAU2 Animation
     else if (sCommand=="READ"||sCommand=="RD")
     { // READ Animation
       fDelay=fnNPCACTAnimate("ANIM8/30");
     } // READ Animation
     else if (sCommand=="SALT"||sCommand=="SA")
     { // SALT Animation
       fDelay=fnNPCACTAnimate("ANIM9/20");
     } // SALT Animation
     else if (sCommand=="SCRT"||sCommand=="SH")
     { // SCRT Animation
       fDelay=fnNPCACTAnimate("ANIM7/30");
     } // SCRT Animation
     else if (sCommand=="SITC"||sCommand=="SC")
     { // SITC Animation
       fDelay=fnNPCACTAnimate("ANIM26/300");
     } // SITC Animation
     else if (sCommand=="TIRD"||sCommand=="TI")
     { // TIRD Animation
       fDelay=fnNPCACTAnimate("ANIM23/60");
     } // TIRD Animation
     else if (sCommand=="VIC1"||sCommand=="V1")
     { // VIC1 Animation
       fDelay=fnNPCACTAnimate("ANIM12/20");
     } // VIC1 Animation
     else if (sCommand=="VIC2"||sCommand=="V2")
     { // VIC2 Animation
       fDelay=fnNPCACTAnimate("ANIM13/20");
     } // VIC2 Animation
     else if (sCommand=="VIC3"||sCommand=="V3")
     { // VIC3 Animation
       fDelay=fnNPCACTAnimate("ANIM14/20");
     } // VIC3 Animation
     else if (sCommand=="WORS"||sCommand=="WS")
     { // WORS Animation
       fDelay=fnNPCACTAnimate("ANIM31/60");
     } // WORS Animation
     else if (sCommand=="ATTK"||sCommand=="AT")
     { // Attack nearby placeable
       fDelay=fnNPCACTF_ATTK();
     } // Attack nearby placeable
     else if (sL4=="CAST"||sL2=="C/")
     { // CAST SPELL by abbreviation
       fDelay=fnNPCACTF_CAST(sCommand);
     } // CAST SPELL by abbreviation
     else if (sCommand=="CLAC"||sCommand=="Ca")
     { // Clear all Actions
       fDelay=0.0; AssignCommand(oMe,ClearAllActions());
     } // Clear all Actions
     else if (sCommand=="CLEN"||sCommand=="CL")
     { // Clean nearby non plot items
       fDelay=fnNPCACTF_CLEN();
     } // Clean nearby non plot items
     else if (sCommand=="CLLD"||sCommand=="CC")
     { // Close nearby containers
       fDelay=fnNPCACTF_CLLD();
     } // Close nearby containers
     else if (sL3=="CLO"||(sL1=="W"&&StringToInt(GetStringRight(sCommand,1))>0))
     { // Change clothing
       fDelay=fnNPCACTF_CLO(sCommand);
     } // Change clothing
     else if (sCommand=="DIE"||sCommand=="DI")
     { // Apply death effect
       eE=EffectDeath();
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eE,oMe,1.0);
     } // Apply death effect
     else if (sCommand=="DISA"||sCommand=="DS")
     { // Apply disappear effect
       eE=EffectDisappear();
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eE,oMe,1.0);
     } // Apply disappear effect
     else if (sCommand=="DRD"||sCommand=="DD")
     { // Choose a nearby random door
       fDelay=fnNPCACTF_DRD();
     } // Choose a nearby random door
     else if (sCommand=="EAT"||sCommand=="EA")
     { // EAT
       fDelay=fnNPCACTF_EAT();
     } // EAT
     else if (sCommand=="FOAN"||sCommand=="FA")
     { // Follow any
       fDelay=fnNPCACTF_Follow(2);
     } // Follow any
     else if (sCommand=="FOFM"||sCommand=="FF")
     { // Follow Female
       fDelay=fnNPCACTF_Follow(0);
     } // Follow Female
     else if (sCommand=="FOFP"||sCommand=="Ff")
     { // Follow Female PC
       fDelay=fnNPCACTF_Follow(4);
     } // Follow Female PC
     else if (sCommand=="FOMA"||sCommand=="FM")
     { // Follow Male
       fDelay=fnNPCACTF_Follow(1);
     } // Follow Male
     else if (sCommand=="FOMP"||sCommand=="Fm")
     { // Follow Male PC
       fDelay=fnNPCACTF_Follow(5);
     } // Follow Male PC
     else if (sCommand=="FOPC"||sCommand=="FP")
     { // Follow any PC
       fDelay=fnNPCACTF_Follow(3);
     } // Follow any PC
     else if (sCommand=="KNOC"||sCommand=="KN")
     { // cast knock spell
       fDelay=12.0;
       AssignCommand(oMe,ActionCastSpellAtLocation(SPELL_KNOCK,GetLocation(oMe),METAMAGIC_ANY,TRUE));
     } // cast knock spell
     else if (sCommand=="ALE"||sCommand=="C3")
     { // Create ALE
       fDelay=fnNPCACTMakeItem("COnw_it_mpotion021");
     } // Create ALE
     else if (sCommand=="FISH"||sCommand=="C2")
     { // Create FISH
       fDelay=fnNPCACTMakeItem("COnw_it_msmlmisc20");
     } // Create FISH
     else if (sCommand=="SPRT"||sCommand=="C5")
     { // Create Spirits
       fDelay=fnNPCACTMakeItem("COnw_it_mpotion022");
     } // Create Spirits
     else if (sCommand=="MEAT"||sCommand=="C1")
     { // Create Meat
       fDelay=fnNPCACTMakeItem("COnw_it_mmidmisc05");
     } // Create Meat
     else if (sCommand=="WINE"||sCommand=="C4")
     { // Create Wine
       fDelay=fnNPCACTMakeItem("COnw_it_mpotion023");
     } // Create Wine
     else if (sCommand=="CAMP"||sCommand=="CF")
     { // Create Campfire
       fDelay=1.0;
       CreateObject(OBJECT_TYPE_PLACEABLE,"plc_campfr",GetLocation(oMe));
     } // Create Campfire
     else if (sCommand=="TAFO"||sCommand=="TF")
     { // Talk Forceful
       fDelay=fnNPCACTTalkTo("TTANY/F");
     } // Talk Forceful
     else if (sCommand=="TALA"||sCommand=="TL")
     { // Talk Laughing
       fDelay=fnNPCACTTalkTo("TTANY/L");
     } // Talk Laughing
     else if (sCommand=="TANM"||sCommand=="TN")
     { // Talk Normal
       fDelay=fnNPCACTTalkTo("TTANY/N");
     } // Talk Normal
     else if (sCommand=="TAPL"||sCommand=="TP")
     { // Talk Pleading
       fDelay=fnNPCACTTalkTo("TTANY/P");
     } // Talk Pleading
     else if (sCommand=="TALK"||sCommand=="TA")
     { // Talk Random Talk Method
       nR=d4();
       if (nR==1) sS="N";
       else if (nR==2) sS="L";
       else if (nR==3) sS="F";
       else { sS="P"; }
       fDelay=fnNPCACTTalkTo("TTANY/"+sS);
     } // Talk Random Talk Method
     else if (sCommand=="MAG1"||sCommand=="M1")
     { // Magic effect 1
       fDelay=fnNPCACTEffects("EFF74/0");
     } // Magic effect 1
     else if (sCommand=="MAG2"||sCommand=="M2")
     { // Magic effect 2
       fDelay=fnNPCACTEffects("EFF195/0");
     } // Magic effect 2
     else if (sCommand=="MAG3"||sCommand=="M3")
     { // Magic effect 3
       fDelay=fnNPCACTEffects("EFF71/0");
     } // Magic effect 3
     else if (sCommand=="REAP"||sCommand=="Ra")
     { // reappear
       eE=EffectAppear();
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eE,oMe);
       fDelay=4.0;
     } // reappear
     else if (sCommand=="POIS"||sCommand=="PO")
     { // Poison effect
      eE=EffectPoison(POISON_TINY_SPIDER_VENOM);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eE,oMe,30.0);
      fDelay=1.0;
     } // Poison effect
     else if (sCommand=="RNS0"||sCommand=="R0")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("Thisss sho' isss a nice place/One moresss drinksss sho to help me walk!  Hic!/Thatsss a mighty fine barrel you havess! Hicup!/Who took my drink? Hic!/Itsss a bad day I need a drink!/[SINGING] Grannies in the cellar, lordy can't ya smell her/My bottle looksss shorter than before!/Spirits is the breakfast of champions!! Let me have some!  Hicup!/Uggghhhh--- I don't feel too goodss!  Hic!",1);
     } // random speak
     else if (sCommand=="RNS1"||sCommand=="R1")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("Don't it beat all! That merchant took forever to get here/I just done my sword cleanin' fo' the day/I seen an ogre once that'd shrivel yo' privates if he took to lookin' at ya/Some of the walkin' all day wears me down/A nice ale usually settles me stomach/Once I had to fight off a dozen bandits comin' fo' the merchant I was workin' wif/I need to find me a bed warmer! Harhar/I think spirits is a stronger drink! That'd be what I needs/I have a big scar on me arse too!  Damn badger bit it",1);
     } // random speak
     else if (sCommand=="RNS2"||sCommand=="R2")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("Come look at my goods/I'm looking to trade/Fresh in!  Goods from around the world/Come one, Come all!  Incredible bargains here/Do you need to lighten your load? I'm buying goods of all kinds/Quick! Get them before they are gone!  I am selling them like they are jewels!  Maybe they are!/I have money just waiting to be spent on your goods you wish to sell/Buy something for a special occasion!/Did you forget something? You better talk to me to make sure you didn't",1);
     } // random speak
     else if (sCommand=="RNS3"||sCommand=="R3")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("Ode to the beggar!A tale of woe/O'to travel the world/Too many words tangle the tongue! A well placed word, that can win wars/If booglytoosome would fondangle the biddyswitch twould ever so simply perdobel/It twas a dark and stormy- Too cliche/So many stories, so many songs, and far too little time/The orphan dwarf and his adoptive troll parents- Nah, too stupid/Time pursues us all! It follows and cuddles! It waits for to fall! Our bodies form as puddles-That is just awful/A song or two to lighten the day!",1);
     } // random speak
     else if (sCommand=="RNS4"||sCommand=="R4")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("Me findem food! Is good?/Me needs me mate!  Is good?/Me bash things! Is good?/Smell man flesh!/No like rain!/Needs more blood!/Time for bash!/Me say NOW!/Shiny things good!  Man flesh trap!",1);
     } // random speak
     else if (sCommand=="RNS5"||sCommand=="R5")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("I really don't like this outfit/Today is depressing/I think I need to work on my hair/I wonder who that is?/Did you hear who slept over at you know who's last night?/My man will support me well/I need some new clothes/It's just not my day!/Damn the fates!",1);
     } // random speak
     else if (sCommand=="RNS6"||sCommand=="R6")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("Did you see her mellons? Whoa!/She has a nice arse!  I'm talking about her donkey either!/I got a new tool last week/Some weather we're having/I hate work!/I bet I can belch longer!/No pain, no gain!/A fool and his money are soon parted!/If it don't hurt nothin' do what you want!",1);
     } // random speak
     else if (sCommand=="RNS7"||sCommand=="R7")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("A well placed grease spell often works wonders/What spell would you use in that situation?/I almost am done with that new spell/What do I NEED an invisible stalker for?/The usual spell does fine for me/---and then I put the bat guano in with the other powder and---/---the explosion was quite magnificent!  It only singed my hair a bit!/It worked last time I cast it/I'm not sure the situation calls for an answer to that!",1);
     } // random speak
     else if (sCommand=="RNS8"||sCommand=="R8")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("and so what is the universe really?/---does not preclude the existence of other gods!/Yes, but that in itself was a contradiction!/For the love of the gods! Read the book!  It's all in there!/I'm telling you it is a hidden truth!/How can you ask such silly questions?/That is blasphemy if I ever heard it before!/---might be the reason why---/---could of been a miracle---",1);
     } // random speak
     else if (sCommand=="RNS9"||sCommand=="R9")
     { // random speak
       fDelay=fnNPCACTRandomSpeak("What do you think of the weather?/I don't give it much thought really/How has your day been?/The same as usual/That's what she wanted to know!/I don't know/You win some!  Others you lose!/What did they give you?/I think something special",1);
     } // random speak
     else if (sCommand=="SNG1"||sCommand=="r1")
     { // sing song
       fDelay=fnNPCACTLyrical("10/[SINGING]One bright and kindly summers morning/I perchance passed the field of my toils/There I saw my hearts definate warning/I happened to see my woman's donkey/My lass has a very fine ass/Don't you know it works all day/My lass has a very fine ass/It works and doesn't get pay/So next time your at the market/Make sure its a donkey you buy/For prideful they may be/But, to work their pay is just right/My lass has a very fine ass!",1);
     } // sing song
     else if (sCommand=="SNG2"||sCommand=="r2")
     { // sing song
       fDelay=fnNPCACTLyrical("9/[SINGING] Raise your cup high and proud: Sing with me/Stomp your feet, shake the ground/Greet your chums round 'bout/Show them what drinkings all 'bout/DRINK THEM UNDER THE TABLE/SLAM THAT ALE DOWN AND DOWN/DRINK THEM UNDER THE TABLE/WATCH THEIR PRIDE FALLIN' DOWN/DRINK THEM UNDER THE TABLE/SLAM THAT ALE DOWN AND DOWN/DRINK THEM UNDER THE TABLE/WATCH THEIR PRIDE FALLIN' DOWN",1);
     } // sing song
     else if (sCommand=="SNG3"||sCommand=="r3")
     { // sing song
       fDelay=fnNPCACTLyrical("9/[SINGING] The sea is my larder---/It is where the fish grow/The sea provides my staples---/As you all surely know/The sea provides shelter---/to the wise man they will show/The sea is as stable---/as the time honored know/The sea is my roadway---/Whereever the winds blow",1);
     } // sing song
     else if (sCommand=="SNG4"||sCommand=="r4")
     { // sing song
       fDelay=fnNPCACTLyrical("8/[SINGING] Why are your eyes so blue all the time---/Why are your eyes always looking into mine---/Where did you come from, and where will you go---/Find my hand and take me where you go---/If I love you, will you love me too/Will you be there, whenever I need you",1);
     } // sing song
     else if (sCommand=="SNG5"||sCommand=="r5")
     { // sing song
       fDelay=fnNPCACTLyrical("10/[SINGING] See them run, see them crawl/That's what makes it worth it all/Hear them scream, hear them weep/That's what helps me sleep a wink/Rape and Pillage/Burn the village/Rape and Pillage/Rape and Pillage/We don't need the pay/We just need some prey/We don't need friends/We prefer bone snapping trends/Rape and Pillage/Burn the village/Rape and pillage/RAPE AND PILLAGE!!",1);
     } // sing song
     else if (sCommand=="SNG6"||sCommand=="r6")
     { // sing song
       fDelay=fnNPCACTLyrical("12/[SINGING] T'wards the mountains went the bodies---/of those the monster had taken/T'wards the caverns went the fighters/Never seen or heard again/The fear was gripping hearts/The pride had fallen low/Then came the hero/The one that was unknown/T'wards the mountains he wandered/N'er turning to look back/T'wards the caverns he stumbled/N'er considering what was there/And there he did battle/And there he did fall",1);
     } // sing song
     else if (sCommand=="SNG7"||sCommand=="r7")
     { // sing song
       fDelay=fnNPCACTLyrical("11/[SINGING] Find the barrel/Bolt and Arrow/Grow the crops/Tend your shops/Sail the ships/Sway your hips/Kiss the Lass/Swat her arse/Grab a Potion/Forbidden Lotion/Swim the River/Love your giver/Taste the ale/Drain it well/Close the bin/Let's sing again",1);
     } // sing song
     else if (sCommand=="SIT"||sCommand=="SI")
     { // sit on chair
       fDelay=fnNPCACTSitForSpecified("SITS10");
     } // sit on chair
     else if (sL4=="POLY"||sL2=="PY")
     { // Polymorph
       fDelay=fnNPCACTF_Polymorph(sCommand);
     } // Polymorph
     else if (sCommand=="HELT"||sCommand=="HS")
     { // heal self
       eE=EffectHeal(GetMaxHitPoints(oMe)-GetCurrentHitPoints(oMe));
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eE,oMe,1.0);
       fDelay=1.0;
     } // heal self
     else if (sCommand=="KILL"||sCommand=="KI")
     { // KILL
       fDelay=fnNPCACTF_KILL();
     } // KILL
     else if (sCommand=="PKLK"||sCommand=="PL")
     { // pick lock
       fDelay=fnNPCACTF_PickLock();
     } // pick lock
     else if (sCommand=="TAUN"||sCommand=="TU")
     { // Taunt
       fDelay=fnNPCACTF_Taunt();
     } // Taunt
     else if (sCommand=="USE"||sCommand=="US")
     { // USE
       fDelay=fnNPCACTF_Use();
     } // USE
     else if (sCommand=="WOPC"||sCommand=="WO")
     { // worship PC
       SetLocalInt(oMe,"nNPCParm",0);
       ExecuteScript("npcact_ext_wors",oMe);
     } // worship PC
     else if (sCommand=="WOCR"||sCommand=="WC")
     { // worship NPC
       SetLocalInt(oMe,"nNPCParm",1);
       ExecuteScript("npcact_ext_wors",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // worship NPC
     else if (sCommand=="BULL"||sCommand=="BU")
     { // BULLY
       ExecuteScript("npcact_ext_bull",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // BULLY
     else if (sCommand=="FLEE"||sCommand=="FL")
     { // FLEE
       ExecuteScript("npcact_ext_flee",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // FLEE
     else if (sCommand=="HEAL"||sCommand=="HE")
     { // HEAL
       ExecuteScript("npcact_ext_heal",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // HEAL
     else if (sCommand=="PICK"||sCommand=="PP")
     { // PICK POCKETS
       ExecuteScript("npcact_ext_pick",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // PICK POCKETS
     else if (sCommand=="TURN"||sCommand=="TR")
     { // TURN UNDEAD
       ExecuteScript("npcact_ext_turn",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // TURN UNDEAD
     else if (sCommand=="REACT"||sCommand=="RT")
     { // REACT
       ExecuteScript("npcact_ext_react",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // REACT
     else if (sCommand=="RMTR")
     { // Remove Trap
       ExecuteScript("npcact_ext_rmtr",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // Remove Trap
     else if (sCommand=="STTR"||sCommand=="ST")
     { // Set Trap
       ExecuteScript("npcact_ext_sttr",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // Set Trap
     else if (sCommand=="GOSSIP"||sCommand=="GO")
     { // Gossip
       ExecuteScript("npcact_ext_goss",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // Gossip
     else if (sCommand=="SLIS"||sCommand=="sl")
     { // Set Listen
       ExecuteScript("npcact_ext_slis",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // Set Listen
     else if (sCommand=="SGOS"||sCommand=="sg")
     { // Set Gossip
       SetLocalString(oMe,"sParm",sCommand);
       ExecuteScript("npcact_ext_sgos",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // Set Gossip
     else if (sCommand=="LTON"||sCommand=="LO"||sCommand=="LTOF"||sCommand=="Lo")
     { // lights on/off
       SetLocalString(oMe,"sParm",sCommand);
       ExecuteScript("npcact_ext_light",oMe);
       fDelay=GetLocalFloat(oMe,"fDelay");
     } // lights on/off
     else if (sCommand=="INN"||sCommand=="IN")
     { // Inn backwards compatibility
       fDelay=fnNPCACTF_Inn();
     } // Inn backwards compatibility
     else if (sCommand=="PROP"||sCommand=="PR")
     { // Proposition
       fDelay=fnNPCACTF_Proposition();
     } // Proposition
     else if (sL3=="SUM"||sL1=="m")
     { // summon
       fDelay=fnNPCACTF_SummonCreature(sCommand);
     } // Summon
     else if (sL3=="SAY"||(sL1=="S"&&GetStringLength(sCommand)>1))
     { // SAY#
       fDelay=fnNPCACTF_SayPhrase(sCommand);
     } // SAY#
     else if (sCommand=="WAKE"||sCommand=="WK")
     { // WAKE
       fDelay=fnNPCACTF_Wake();
     } // WAKE
     else if (sL1=="A"&&GetStringLength(sCommand)==4)
     { // old style add
       fDelay=fnNPCACTAddSubtract("+InNPCActionVar"+GetSubString(sCommand,1,1)+"/"+GetStringRight(sCommand,2));
     } // old style add
     else if (sL1=="S"&&GetStringLength(sCommand)==4)
     { // old style subtract
       fDelay=fnNPCACTAddSubtract("-InNPCActionVar"+GetSubString(sCommand,1,1)+"/"+GetStringRight(sCommand,2));
     } // old style subtract
     else if (sL1=="V"&&GetStringLength(sCommand)==4)
     { // old style variable set
       fDelay=fnNPCACTSetVariable("!InNPCActionVar"+GetSubString(sCommand,1,1)+"/"+GetStringRight(sCommand,2));
     } // old style variable set
     else if (sL1=="I"&&GetStringLength(sCommand)==4)
     { // IF old style
       fDelay=fnNPCACTLogicCore("&IEnNPCActionVar"+GetSubString(sCommand,1,1)+"/"+GetStringRight(sCommand,2));
     } // IF old style
     else if ((sL3=="COP"&&GetStringLength(sCommand)==4)||(sL1=="c"&&GetStringLength(sCommand)==2))
     { // old COPY
       fDelay=fnNPCACTF_CopyVar(sCommand);
     } // old COPY
     /// end the big if/else if
     sAct=GetLocalString(oMe,"sAct"); // see if changed
     nGNBDisabled=GetLocalInt(oMe,"nGNBDisabled");
     if (fDelay<0.2) fDelay=0.1;
     if (GetStringLength(sAct)>0&&fDelay>0.0) { DelayCommand(fDelay,ExecuteScript("npcact_interp",oMe));   }
     else if (!nGNBDisabled) { DelayCommand(fDelay,fnDoPauseThenEnd()); }
     else { DelayCommand(2.0,ExecuteScript("npcact_interp",oMe)); }
   } // okay to deal with commands
   else if (!nGNBDisabled)
   {
     fnDoPauseThenEnd();
   }
   else { DelayCommand(2.0,ExecuteScript("npcact_interp",oMe)); }
}
///////////////////////////////////////////////////////////////////////// MAIN

/////////////////////////
// FUNCTIONS
/////////////////////////

void fnState1Required()
{ // PURPOSE: Make sure not stuck in a bad state
  // LAST MODIFIED BY: Deva Bryson Winblood
  if (GetLocalInt(OBJECT_SELF,"nGNBState")!=1) { SetLocalInt(OBJECT_SELF,"nGNBState",1); DelayCommand(0.3,fnState1Required()); }
} // fnState1Required()

void fnDoPauseThenEnd()
{ // PURPOSE: To check for a pause and handle that
  // and switch to state 1 when done with pause
  // LAST MODIFIED BY: Deva Bryson Winblood
  float fGNBPause=GetLocalFloat(OBJECT_SELF,"fGNBPause");
  if(GetLocalInt(OBJECT_SELF,"nASMethod")==6) fGNBPause=IntToFloat(Random(FloatToInt(fGNBPause))+1);
  SetLocalInt(OBJECT_SELF,"nGNBState",7);
  if (fGNBPause>0.0) { DelayCommand(fGNBPause,fnState1Required()); }
  else { fnState1Required(); }
} // fnDoPauseThenEnd()
