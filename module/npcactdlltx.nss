////////////////////////////////////////////////////////////////////////////////
// NPC ACTIVITIES 6.1 - Transition movement library
// Version: 1.0
// Library name: TX
//=======================================================================
// Author: Deva Bryson Winblood
// Date  : 2/4/2006
//=======================================================================
// This library provides a way to make an NPC use a specific transition instead
// of relying upon Accurate Pathing in NPC ACTIVITIES. With this library results
// are guaranteed and require less CPU time to produce the results.
////////////////////////////////////////////////////////////////////////////////
#include "npcactlibtoolh"
#include "npcact_h_moving"
////////////////////////////////////
// PROTOTYPES
////////////////////////////////////


///////////////////////////////////////////////////////////////// [ M A I N ]
void main()
{
   string sParmIn=GetLocalString(OBJECT_SELF,"sLIBParm");
   string sParm;
   string sParm1;
   string sParm2;
   object oMe=OBJECT_SELF;
   int nArgC;
   DLL_TokenizeParameters(sParmIn);
   nArgC=GetLocalInt(oMe,"nArgc");
   if (nArgC>2)
   { // sufficient parameters passed
   } // sufficient parameters passed
   DLL_FreeParameters();
}
///////////////////////////////////////////////////////////////// [ M A I N ]

/////////////////////////////////////
// FUNCTIONS
/////////////////////////////////////
