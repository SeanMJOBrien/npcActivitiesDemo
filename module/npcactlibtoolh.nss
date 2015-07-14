///////////////////////////////////////////////////////////////
// NPC ACTIVITIES 5.0 - Library Tool Header file
//============================================================
// By Deva Bryson Winblood.    02/2003      Also used with
// NPC ACTIVITIES 6.0 and did not require any modifications
// MODIFIED FOR NPC ACTIVITIES 6.1  2/4/2006
///////////////////////////////////////////////////////////////
/*

    These functions are to be used to help you make your
    own library scripts as per the documentation section
    Creating your own commands.

npcactlibtoolh:
--------------- List of functions for quick reference:
string DLL_ParseSlash(string sIn,string sDelim="/");
string DLL_RemoveParsed(string sOrig,string sRemove,string sDelim="/");
void DLL_TokenizeParameters(string sIn);
void DLL_FreeParameters();
void DLL_SetDestination(object oNPC,string sDestination);
void DLL_CompleteActions(object oNPC);
void DLL_AddCommand(object oNPC,string sCommand);
void DLL_SetProcessingFlag(object oNPC);
void DLL_SetNPCState(object oNPC,int nState);
int DLL_NPCIsBusy(object oNPC);
object DLL_GetRecentDestination(object oNPC);
void DLL_SetRecentDestination(object oNPC,object oDest);
void DLL_SetBlockedLockedDoorMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedDoorMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedAnimalMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedVerminMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedPrejudicedMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedMaleMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedFemaleMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedPCMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedNPCMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedCreatureMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedContainerMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockedPlaceableMessage(object oNPC,string sMessage,int bScript=FALSE);
void DLL_SetBlockingBehavior(object oNPC,int nMode=NPC_BLOCKING_DEFAULT);
void DLL_SetPerceptionNoEnemy(object oNPC,int bFlag=TRUE);
void DLL_SetPerceptionNoNeutral(object oNPC,int bFlag=TRUE);
void DLL_SetPerceptionNoFriend(object oNPC,int bFlag=TRUE);
void DLL_SetPerceptionNoNPC(object oNPC,int bFlag=TRUE);
void DLL_SetPerceptionNoPC(object oNPC,int bFlag=TRUE);
void DLL_SetConversationOnlyListenTo(object oNPC,object oTarget);
void DLL_SetConversationNoListenNPC(object oNPC,int bFlag=TRUE);
void DLL_SetConversationNoListenEnemy(object oNPC,int bFlag=TRUE);
void DLL_SetConversationNoListenNeutral(object oNPC,int bFlag=TRUE);
void DLL_SetConversationNoListenFriend(object oNPC,int bFlag=TRUE);
void DLL_SetConversationNoListenPC(object oNPC,int bFlag=TRUE);
void DLL_SetNPCDisabled(object oNPC,int bFlag=TRUE);
void DLL_SetProfessionsEnabled(object oNPC,int bFlag=TRUE);
void DLL_SetProfessionsFailureLevel(object oNPC,int nFailNumber=15);
void DLL_SetProfessionsProcessing(object oNPC);
string DLL_GetArgument(object oNPC,int nArgumentNumber);
int DLL_GetArgumentCount(object oNPC);
void DLL_SetCustomConversationOverride(object oNPC,string sDialog);
void DLL_SetCustomConversationNPCNode(object oNPC,int nNode,int nSubNode,string sText);
void DLL_SetCustomConversationPCResponseNode(object oNPC,int nNode,int nSubNode,int nOption,string sText);
void DLL_CleanCustomConversation(object oNPC);
void DLL_SetNPCStateSpeed(object oNPC,int nSpeed=6);
void DLL_SetRandomDelay(object oNPC,int nTenthsOfSecond=0);
void DLL_SetQuickMoveEnabled(object oNPC,int bFlag=FALSE);
void DLL_SetAccuratePathingEnabled(object oNPC,int bFlag=FALSE);
void DLL_SetStayInAreaEnabled(object oNPC,int bFlag=FALSE);
void DLL_SetCanOpenDoors(object oNPC,int bFlag=FALSE);
void DLL_SetVirtualTag(object oNPC,string sTag);
void DLL_SetCloseMode(object oNPC,int nMode=NPC_MODE_DEFAULT);
-------------                                                        */

///////////////////////////////////////////////////////////////////
// CONSTANTS
///////////////////////////////////////////////////////////////////
const int NPC_STATE_INITIALIZE              = 0;  // states in NPCACT_STATES
const int NPC_STATE_CHOOSE_DESTINATION      = 1;
const int NPC_STATE_MOVE_TO_DESTINATION     = 2;
const int NPC_STATE_WAIT_TO_GET_THERE       = 3;
const int NPC_STATE_PROCESS_WAYPOINT        = 4;
const int NPC_STATE_INTERPRET_COMMAND       = 5;
const int NPC_STATE_WAIT_FOR_COMMAND        = 6;
const int NPC_STATE_PAUSE_BEFORE_NEXT       = 7;
const int NPC_BLOCKING_DEFAULT              = 0; // Blocking Behaviors
const int NPC_BLOCKING_RUN_AWAY_SHORT       = 1;
const int NPC_BLOCKING_RUN_AWAY_LONG        = 2;
const int NPC_BLOCKING_MOVE_RANDOM          = 3;
const int NPC_MODE_DEFAULT                  = 0; // Destination choice modes
const int NPC_MODE_CLOSE_FIRST              = 1;
const int NPC_MODE_CLOSE_ONLY               = 2;

///////////////////////////////////////////////////////////////////
// PROTOTYPES
///////////////////////////////////////////////////////////////////

// FILE: npcactlibtoolh     FUNCTION: DLL_ParseSlash
// This function will parse until it encounters the specified
// delimiter.  This function is intended to support people who are
// designing custom libraries for NPC ACTIVITIES.
string DLL_ParseSlash(string sIn,string sDelim="/");

// FILE: npcactlibtoolh     FUNCTION: DLL_RemoveParsed
// This function will remove sRemove from sOrig and will also consult
// the delimiter that is specified to make sure any leading delimiter is
// removed.  This is a support function for people to create their own
// custom libraries for NPC ACTIVITIES.  It is typically used after
// the DLL_ParseSlash function.
string DLL_RemoveParsed(string sOrig,string sRemove,string sDelim="/");

// FILE: npcactlibtoolh     FUNCTION: DLL_TokenizeParameters
// This function will count how many parameters are passed and will store that
// number in nArgc on the NPC.  It will put each of the parameters in a string
// variable on the NPC stored as sArgv# where # begins with 1.   This function
// is provided to help people create custom libraries for NPC ACTIVITIES.
// Typically this function is called at the begining of the library to determine
// what was asked of the library.  Later DLL_FreeParameters can be called to
// free any memory used to store these parameters.
// So a typical library is setup similar to this
//  void main()
//  {
//    string sParmIn=GetLocalString(OBJECT_SELF,"sLIBParm");
//    Declare variables
//    DLL_TokenizeParameters(sParmIn);
//    Actions to be taken by the library
//    DLL_FreeParameters();
//   }
//
void DLL_TokenizeParameters(string sIn);

// FILE: npcactlibtoolh     FUNCTION: DLL_FreeParameters
// This function frees variables and memory allocated for use with the
// DLL_TokenizeParameters command.   See that command for complete details.
// This function is provided for people to create their own custom libraries
// for use with NPC ACTIVITIES.
void DLL_FreeParameters();

// FILE: npcactlibtoolh     FUNCTION: DLL_SetDestination
// This function will enable a person designing a custom library to set what
// the next destination should be.  This is intended for NPC ACTIVITIES
// custom library design.
void DLL_SetDestination(object oNPC,string sDestination);

// FILE: npcactlibtoolh     FUNCTION: DLL_CompleteActions
// This function will tell the NPC that they have completed ALL actions
// at this location.  It is a way to get the NPC to stop what they are
// doing and move onto the next waypoint.   This function is provided for
// people who are designing their own custom libraries for NPC ACTIVITIES.
void DLL_CompleteActions(object oNPC);

// FILE: npcactlibtoolh     FUNCTION: DLL_AddCommand
// This function will enable someone designing their own custom library
// to insert additional commands in NPC ACTIVITIES format at the end of the
// command queue for this waypoint.
void DLL_AddCommand(object oNPC,string sCommand);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetProcessingFlag
// This function is to be used with custom libraries and scripts to let master
// NPC ACTIVITIES know that something is successfully running.  If your script
// will need to run for awhile then you will want to use this function to keep
// npc activities from thinking something is not working and taking over.
void DLL_SetProcessingFlag(object oNPC);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetNPCState
// This function will set the state of the NPC in terms of how processing is
// handled.   This is used to create custom libraries and scripts.
void DLL_SetNPCState(object oNPC,int nState);

// FILE: npcactlibtoolh     FUNCTION: DLL_NPCIsBusy
// This function will return TRUE if the NPC is in conversation, in combat,
// nGNBDisabled is set to TRUE, or the NPC is DM Possessed
int DLL_NPCIsBusy(object oNPC);

// FILE: npcactlibtoolh     FUNCTION: DLL_GetRecentDestination
// This function returns the most recent destination object for NPC ACTIVITIES
// pathing that was reached by the NPC.
object DLL_GetRecentDestination(object oNPC);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetRecentDestination
// This sets the recent destination reached by the NPC.  It is provided for
// custom library and script design.  It should not be used without good reason.
void DLL_SetRecentDestination(object oNPC,object oDest);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedLockedDoorMessage
// This function will set the message that this NPC will speak when they
// encounter a locked door.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when encountering a locked door.
// This set's the variable sGNBLockedBlock
void DLL_SetBlockedLockedDoorMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedDoorMessage
// This function will set the random message that the NPC will say when they
// encounter a door.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when encountering a door.
// This set's the variable sGNBDoorBlock
void DLL_SetBlockedDoorMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedAnimalMessage
// This function will set the random message that the NPC will say when they
// are blocked by an animal.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by an animal.
// This set's the variable sGNBAnimalBlock
void DLL_SetBlockedAnimalMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedVerminMessage
// This function will set the random message that the NPC will say when they
// are blocked by a vermin.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by a vermin.
// This set's the variable sGNBVerminBlock
void DLL_SetBlockedVerminMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedPrejudicedMessage
// This function will set the random message that the NPC will say when they
// are blocked by a race other than their own or an animal or vermin.
// The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by a inferior race.
// This set's the variable sGNBPrejudicedBlock
void DLL_SetBlockedPrejudicedMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedMaleMessage
// This function will set the random message that the NPC will say when they
// are blocked by a male target.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by a male.
// This set's the variable sGNBMaleBlock
void DLL_SetBlockedMaleMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedFemaleMessage
// This function will set the random message that the NPC will say when they
// are blocked by a female target.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by a female.
// This set's the variable sGNBFemaleBlock
void DLL_SetBlockedFemaleMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedPCMessage
// This function will set the random message that the NPC will say when they
// are blocked by a PC target.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by a pc.
// This set's the variable sGNBPCBlock
void DLL_SetBlockedPCMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedNPCMessage
// This function will set the random message that the NPC will say when they
// are blocked by a NPC target.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by a NPC.
// This set's the variable sGNBNPCBlock
void DLL_SetBlockedNPCMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedCreatureMessage
// This function will set the random message that the NPC will say when they
// are blocked by a PC or NPC.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by a PC or NPC.
// This set's the variable sGNBCreatureBlock
void DLL_SetBlockedCreatureMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedContainerMessage
// This function will set the random message that the NPC will say when they
// are blocked by a container.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by a container.
// This set's the variable sGNBContainerBlock
void DLL_SetBlockedContainerMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockedPlaceableMessage
// This function will set the random message that the NPC will say when they
// are blocked by a placeable.  The sMessage variable must be setup in the format
// #/statement1/statement2/..   # is the number of statements.   This will
// support random statements when being blocked by a placeable.
// This set's the variable sGNBPlaceableBlock
void DLL_SetBlockedPlaceableMessage(object oNPC,string sMessage,int bScript=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetBlockingNehavior
// This function will set how this NPC behaves to objects blocking it.
// Valid settings are NPC_BLOCKING_DEFAULT, NPC_BLOCKING_RUN_AWAY_SHORT,
// NPC_BLOCKING_RUN_AWAY_LONG, or NPC_BLOCKING_MOVE_RANDOM.
// These values are stored on the nGNBBlockingBehavior variable.
void DLL_SetBlockingBehavior(object oNPC,int nMode=NPC_BLOCKING_DEFAULT);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetPerceptionNoEnemy
// This function will set whether the perception event should ignore enemies.
// This sets the variable bGNBNoPerceiveEnemy
void DLL_SetPerceptionNoEnemy(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetPerceptionNoNeutral
// This function will set whether the perception event should ignore neutrals.
// This sets the variable bGNBNoPerceiveNeutral
void DLL_SetPerceptionNoNeutral(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetPerceptionNoFriend
// This function will set whether the perception event should ignore friends.
// This sets the variable bGNBNoPerceiveFriend
void DLL_SetPerceptionNoFriend(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetPerceptionNoNPC
// This function will set whether the perception event should ignore NPCs.
// This sets the variable bGNBNoPerceiveNPC
void DLL_SetPerceptionNoNPC(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetPerceptionNoPC
// This function will set whether the perception event should ignore PCs.
// This sets the variable bGNBNoPerceivePC
void DLL_SetPerceptionNoPC(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetConversationOnlyListenTo
// This function will set a single target that this NPC should listen to.  If
// this value is not set the NPC will listen to all targets.  This function sets
// the variable oGNBListenOnlyTo
void DLL_SetConversationOnlyListenTo(object oNPC,object oTarget);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetConversationNoListenNPC
// This will make this NPC not listen to other NPCs.   This sets the variable
// bGNBNoListenNPC
void DLL_SetConversationNoListenNPC(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetConversationNoListenEnemy
// This will make this NPC not listen to enemies.  This sets the variable
// bGNBNoListenEnemy
void DLL_SetConversationNoListenEnemy(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetConversationNoListenNeutral
// This will make this NPC not listen to neutrals.  This sets the variable
// bGNBNoListenNeutral
void DLL_SetConversationNoListenNeutral(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetConversationNoListenFriend
// This will make this NPC not listen to friends.  This sets the variable
// bGNBNoListenFriend
void DLL_SetConversationNoListenFriend(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetConversationNoListenPC
// This will make this NPC not listen to PCs.  This sets the variable
// bGNBNoListenPC
void DLL_SetConversationNoListenPC(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetNPCDisabled
// This function will set the variable nGNBDisabled
void DLL_SetNPCDisabled(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetProfessionsEnabled
// This sets the variable nGNBProfessions
void DLL_SetProfessionsEnabled(object oNPC,int bFlag=TRUE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetProfessionsFailureLevel
// This sets the variable nGNBProfFail which is documented in the NPC ACTIVITIES
// documentation on designing your own profession.
void DLL_SetProfessionsFailureLevel(object oNPC,int nFailNumber=15);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetProfessionsProcessing
// This function will set the variable nGNBProfProc to 1 which must be used
// periodically within a profession to make NPC ACTIVITIES realize the function
// has not failed.  See NPC ACTIVITIES documentation for further information.
void DLL_SetProfessionsProcessing(object oNPC);

// FILE: npcactlibtoolh     FUNCTION: DLL_GetArgument
// This function will retrieve the sArgv# variable stored on the NPC.
string DLL_GetArgument(object oNPC,int nArgumentNumber);

// FILE: npcactlibtoolh     FUNCTION: DLL_GetArgumentCount
// This function will retrieve the number of arguments which are available to
// be retrieved using DLL_GetArgument.  This is from the nArgc variable stored
// on the NPC.
int DLL_GetArgumentCount(object oNPC);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetCustomConversationOverride
// This function will set the dialog this NPC should use.  The dialog on the
// NPC must be set to npcact_custom for this to work. This function sets the
// sNPCConvOverride variable
void DLL_SetCustomConversationOverride(object oNPC,string sDialog);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetCustomConvesationNPCNode
// This function will set the statements of the NPC in a dynamic conversation
// It should be noted that the root node is nNode=0 and nSubNode=0
// nNode represents depth.  nSubNode = portion of that node.  This will set
// the variable sNPCConvNode#_# where # = nNode and _# = nSubNode
void DLL_SetCustomConversationNPCNode(object oNPC,int nNode,int nSubNode,string sText);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetCustomConversationPCResponseNode
// This function will set responses allowed for PCs.  See the function
// DLL_SetCustomConversationNPCNode for more information.  This sets the
// variable sNPCConvResp#_#_#
void DLL_SetCustomConversationPCResponseNode(object oNPC,int nNode,int nSubNode,int nOption,string sText);

// FILE: npcactlibtoolh     FUNCTION: DLL_CleanCustomConversation
// This function will delete variables used to define custom/dynamic
// conversations.
void DLL_CleanCustomConversation(object oNPC);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetNPCStateSpeed
// This function will set the nGNBStateSpeed variable
void DLL_SetNPCStateSpeed(object oNPC,int nSpeed=6);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetRandomDelay
// This function will set the nGNBRandomizeDelay variable
void DLL_SetRandomDelay(object oNPC,int nTenthsOfSecond=0);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetQuickMoveEnabled
// This will set the bGNBQuickMove variable
void DLL_SetQuickMoveEnabled(object oNPC,int bFlag=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetAccuratePathingEnabled
// This will set the bGNBAccuratePathing variable
void DLL_SetAccuratePathingEnabled(object oNPC,int bFlag=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetStayInAreaEnabled
// This will set the bGNBStayInArea variable
void DLL_SetStayInAreaEnabled(object oNPC,int bFlag=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetCanOpenDoors
// This will set the variable bGNBOpenDoors.   If this is TRUE this NPC
// will be able to open doors even if they are not the typical type of NPC
// to be able to do this.
void DLL_SetCanOpenDoors(object oNPC,int bFlag=FALSE);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetVirtualTag
// This will set the sGNBVirtualTag variable
void DLL_SetVirtualTag(object oNPC,string sTag);

// FILE: npcactlibtoolh     FUNCTION: DLL_SetCloseMode
// This will set the movement mode of the NPC.  The valid settings
// are NPC_MODE_DEFAULT, NPC_MODE_CLOSE_FIRST, and NPC_MODE_CLOSE_ONLY
void DLL_SetCloseMode(object oNPC,int nMode=NPC_MODE_DEFAULT);

// FILE: npcactlibtoolh     FUNCTION: fake function - tutorial
// This is a tutorial and is not an actual useable function.
//==============================================================================
// HOW TO MAKE CUSTOM DYNAMIC CONVERSATIONS
//==============================================================================
// STEP #1: the dialog for the NPC must be set to npcact_custom
// STEP #2: - call DLL_CleanCustomConversation first to clean any existing
// dynamic conversation
// STEP #3: - Call DLL_SetCustomConversationNPCNode(oNPC,0,0,text) where text
// is the very first conversation option.  See later on what text should be set
// to.
// STEP #4: - Call DLL_SetCustomConversationPCResponseNode(oNPC,0,0,1,text) for
// valid PC responses.  You should increment 1 as needed.
// STEP #5: - repeat steps #3 through #4 until the entire dialog tree is
// constructed... simply increment the nodes, subnodes, and options as needed
// to properly construct the conversation.
// =============================================================================
// TEXT - This section explains the text portion of the functions
// =============================================================================
// The text portion is broken into a string that has the following parts:
// language #
// text appears when
// actions
// what should be said
// Each of these sections is delimited by a period.  In standard notation it
// is represented in documenation similar to this.
// <language #>.<text appears when>.<actions>.<what should be said>
// Each of these sections will be explained.
//==============================================================================
// language #
//==============================================================================
// Language # would be the spoken language that it is using if languages are
// enabled.  However, this value if set to 0 will indicate no specific language
//==============================================================================
// Text Appears When
//==============================================================================
// If there is no special condition then set this to NA.  Otherwise, you can
// use the following criteria delimited by slashes /
// @<script> = execute a test script.  Results must be passed from the script
// in the variable bNPCConvReturn
// &<conditional> = is a set of conditions that can be tested without requiring
// a custom script.
//      CONDITIONALS
//      I<integer name>|<comparison>|<value> = will test an integer on the PC
//        and valid COMPARISONS are E for equal to, N for Not equal to, G for
//        greater than, or L for less than.
//      S<string name>|<comparison>|<value> = will rest a string on the PC
//      T<tag value>|<comparison> = will test the tag of the NPC
//      R<resref value>|<comparison> = will test the resref of the NPC
//      G<gender>|<comparison> = will test the PC for a gender.  Valid genders
//         are M for male, F for female, B for both, N for none, or O for Other.
//      r<race>|<comparison> = will test the PC to see if they are the specified
//         race.  Valid races are H = Human, h = Halfling, E = Elf,
//         e = Half-elf, G = Gnome, O = Orc, D = Dwarf, U = Undead, A = Animal,
//         o = Outsider, C = Construct, B = Beast, a = Aberration, g = Giant,
//         S = Shape Changer, M = Magical Beast, F = Fey, d = Dragon
//      C<class>|<comparison> = will test the PC for a specific class
//         Valid classes are AA = Arcane Archer, A = Assassin,
//         B = Barbarian, b = Bard, BG = Black Guard, C = Cleric, c = Commoner,
//         DC = Divine Champion, DD = Dragon Disciple, D = Druid,
//         DWD  = Dwarven Defender, F = Fighter, H = Harper, M = Monk,
//         P = Paladin, PM = Pale Master, R = Ranger, ROG = Rogue,
//         SD = Shadow Dancer, SH = Shifter, S = Sorcerer, WM = Weapon Master,
//         W = Wizard
//      H<tag> = if PC is carrying item with specified tag
//      N<tag> = if PC is NOT carrying item with specified tag
//      A<alignment>|<comparison> = will test the PC to see if their alignment
//         compares with a specific alignment.  Valid alignments are
//         LG, LN, LE, NG, TN, NE, CG, CN, or CE
//      $<amount>|<comparison> = will test the PC to see how much gold they
//         are carrying
//      !<level>|<comparison> = will test the PC speaker to see if their level
//         compares to the level specified. All comparison types are allowed.
//      ?<weather>|<comparison> = Will test the current weather with the valid
//         types as follows: C = Clear,  R = Raining, S = Snowing
//      %<time>|<comparison> = will test the current time based on the following
//          criteria. D = Day, N = Night, U = Dusk, W = Dawn.
//==============================================================================
// ACTIONS
//==============================================================================
// Valid actions as with the text appears when must be separated by slashes
// @<script>
// !<#_#>  = play animation # for # seconds
// $<store tag> = open nearby store with specified tag
// &P<integer name>|<value> = will set an integer value on the PC
// &N<integer name>|<value> = will set an integer value on the NPC
// &M<integer name>|<value> = will set an integer value on the MODULE object
// &A<integer name>|<value> = will set an integer value on the AREA
// &P<integer name>+<value> = will allow to increment an integer on the PC
// &N<integer name>+<value> = will allow to increment an integer on the NPC
// &M<integer name>+<value> = will allow to increment an integer on the MODULE
// &A<integer name>+<value> = will allow to increment an integer on the AREA
// :<P,N,M,A><string name>|<value> = will set the string value
// +G<amount> = will give amount of gold to the PC
// -G<amount> = will take an amount of gold from the PC
// +X<amount> = will give the PC an amount of experience
// -X<amount> = will take an amount of experience from the PC
// +I<resref>|<quantity> = will give a quantity of items with specified resref
//      to the PC.
// -I<tag>|<quantity> = will take a quantity of items with specified tag from
//      the PC.
// +J<journal>|<position #>|<party wide T F> = will set a journal entry on the
//      PC.
// *<sound stringref> = will tell the NPC to play the specified sound
// ^<sound name> = will tell the NPC to play the specified sound
// #J<waypoint tag> = will jump the NPC to a waypoint with the specified tag
// #A<alignment portion><shift> = will shift the alignment of the PC
//    ALIGNMENT PORTION
//    L = Lawful, C = Chaotic, G = Good, E = Evil
//    SHIFT
//    This will indicate how much to shift the alignment value
// #R<shift> = Will shift the reputation of the PC with respect to the NPC
// #K = will cause the NPC to attack when the conversation ends
// #C<dialog>|<who tag>|<to tag> = will cause a standard Bioware dialog to be
//    initiated between two NPCs.  If a tag is PC then it will use the current
//    PC.
// #U<node>|<who tag>|<to tag> = works the same as #C above but, starts the
//    dialog at the specific node within a dynamic conversation.
// ~<node number> = indicates what the next node should be
// #N = go to the next node
// #B = go back one node
// #G<node>|<subnode> = indicates it should jump to the specified node and
//     subnode within the conversation.
//==============================================================================
// CUSTOM TOKENS - What should be said
//==============================================================================
// The what should be said section can have custom tokens that will be replaced
// by a value that is retrieved based upon the token.  Valid custom tokens are
// <+Atext to highlight> = will action highlight text
// <+Htext to highlight> = will highlight text
// <+Stext to highlight> = will skill check highlight text
// <+R###text to highlight> = will highlight with RGB text highlight where
//    rgb values are from 0 to 6 for each R,G,B digit.
// <$Sstring variable> = will say the contents of the string variable on the NPC
// <$Iinteger variable> = will say contents of integer variable on the NPC
// <$Ffloat variable> = will say contents of float variable on the NPC
// <FN> = will say PCs first name
// <LN> = will say PCs last name
// <N> = will say PCs name
// <MFN> = will say NPCs first name
// <MLN> = will say NPCs last name
// <MN> = will say NPCs name
// <R> = will say PCs race
// <G> = will say PCs gender
// <C> = will say PCs class (uses first class)
// <MR> = will say NPCs race
// <MG> = will say NPCs gender
// <MC> = will say NPCs class
// For the remainder of the tokens you the beginning pm should either be
// P for the PC or M for the NPC.
// <pmLL> = Lord/Lady
// <pmSM> = Sir/Madam
// <pmMM> = Mr/Mrs
// <pmGB> = girl/boy
// <pmWM> = woman/man
// <pmI1> = bastard/bitch
// <pmI2> = dog/whore
// <pmI3> = dolt/wench
// <pmI4> = fool/strumpet
// <pmI5> = ogre/hag
// <#pmMALE/FEMALE> = say custom MALE/FEMALE statement
// <%> = gossip
// <~> = can be used to substitute a period in the conversation since periods
//     are parsed out of what is said.  You need this to use period punctuation
//     in what is said.
//
void HOWTO_CUSTOM_CONVERSATION();

///////////////////////////////////////////////////////////////////
// FUNCTIONS
///////////////////////////////////////////////////////////////////

object DLL_GetRecentDestination(object oNPC)
{ // PURPOSE: To return most recent destination reached
  return GetLocalObject(oNPC,"oGNBArrived");
} // DLL_GetRecentDestination()

void DLL_SetRecentDestination(object oNPC,object oDest)
{ // PURPOSE: To provide a wrapper for setting oGNBArrived
  SetLocalObject(oNPC,"oGNBArrived",oDest);
} // DLL_SetRecentDestination()

int DLL_NPCIsBusy(object oNPC)
{ // PURPOSE: Determine if NPC is busy
  object oMe=OBJECT_SELF;
  if (GetLocalInt(oMe,"nGNBDisabled")) return TRUE;
  else if (GetIsDMPossessed(oNPC)) return TRUE;
  else if (GetIsInCombat(oNPC)) return TRUE;
  else if (IsInConversation(oNPC)) return TRUE;
  return FALSE;
} // DLL_NPCIsBusy()

void DLL_SetProcessingFlag(object oNPC)
{ // PURPOSE: Set the flag indicating the function is at work
  SetLocalInt(oNPC,"nGNBProcessing",1);
} // DLL_SetProcessingFlag()

void DLL_SetNPCState(object oNPC,int nState)
{ // PURPOSE: Set the state of the NPC
  if (nState>0)
  { // set state
    SetLocalInt(oNPC,"nGNBState",nState);
  } // set state
  else
  { // delete
    DeleteLocalInt(oNPC,"nGNBState");
  } // delete
} // DLL_SetNPCState()

string fnParseSlash(string sIn,string sDelim="/")
{ // Parse based on Slash and return the resulting string
  string sString=sIn;
  string sRet="";
  while(GetStringLength(sString)>0&&GetStringLeft(sString,1)!=sDelim)
  { // build return string
    sRet=sRet+GetStringLeft(sString,1);
    sString=GetStringRight(sString,GetStringLength(sString)-1);
  } // build return string
  return sRet;
} // fnParseSlash()

string DLL_ParseSlash(string sIn,string sDelim="/")
{ // place holder for 6.1
  return fnParseSlash(sIn,sDelim);
} // DLL_ParseSlasg()

string fnStringRemainder(string sOrig,string sRemove,string sDelim="/")
{ // removes the size of sRemove from the front of sOrig
  string sRet="";
  if (GetStringLength(sOrig)>=GetStringLength(sRemove))
  { // robustness
   sRet=GetStringRight(sOrig,GetStringLength(sOrig)-GetStringLength(sRemove));
   if (GetStringLeft(sRet,1)==sDelim) sRet=GetStringRight(sRet,GetStringLength(sRet)-1);
  } // robustness
  return sRet;
} // fnStringRemainder()

string DLL_RemoveParsed(string sOrig,string sRemove,string sDelim="/")
{ // place holder for 6.1
  return fnStringRemainder(sOrig,sRemove,sDelim);
} // DLL_RemoveParsed()

void fnTokenizeParameters(string sIn)
{ // build nArgc and sArgv#
  int nCount=0;
  string sParms=sIn;
  string sP;
  while(GetStringLength(sParms)>0)
  {
    nCount++;
    sP=fnParseSlash(sParms);
    sParms=fnStringRemainder(sParms,sP);
    SetLocalString(OBJECT_SELF,"sArgv"+IntToString(nCount),sP);
  }
  SetLocalInt(OBJECT_SELF,"nArgc",nCount);
} // fnTokenizeParameters()

void DLL_TokenizeParameters(string sIn)
{ // place holder for 6.1
  fnTokenizeParameters(sIn);
} // DLL_TokenizeParameters()

void fnFreeParms()
{ // this deallocates memory for the parameters
     DeleteLocalString(OBJECT_SELF,"sLIBParm");
} // fnFreeParms()

void DLL_FreeParameters()
{ // Place holder for 6.1
  fnFreeParms();
} // DLL_FreeParameters()

void DLL_SetDestination(object oNPC,string sDestination)
{ // PURPOSE: Set next destination
  SetLocalString(oNPC,"sGNBDTag",sDestination);
} // DLL_SetDestination()

void DLL_CompleteActions(object oNPC)
{ // PURPOSE: Clear actions not yet completed and call ClearAllActions
  DeleteLocalString(oNPC,"sGNBActions");
  AssignCommand(oNPC,ClearAllActions());
} // DLL_CompleteActions()

void DLL_AddCommand(object oNPC,string sCommand)
{ // PURPOSE: Add sCommand to the command queue
  string sAct=GetLocalString(oNPC,"sGNBActions");
  sAct=sAct+"."+sCommand;
  SetLocalString(oNPC,"sGNBActions",sAct);
} // DLL_AddCommand()

//void main(){} // comment out after compile, then save
