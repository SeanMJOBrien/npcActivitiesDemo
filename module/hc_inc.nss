//Hardcore Death Info
//Archaegeo 2002 Jun 24

#include "hc_inc_pwdb_func"

// This script contains default values for PlayerState and is included in
// any file where PlayerState must be checked.  Other PlayerState's could
// be added here

    int PWS_PLAYER_STATE_ALIVE = 0;
    int PWS_PLAYER_STATE_DYING = 1;
    int PWS_PLAYER_STATE_DEAD = 2;
    int PWS_PLAYER_STATE_STABLE = 3;
    int PWS_PLAYER_STATE_DISABLED = 4;
    int PWS_PLAYER_STATE_RECOVERY = 5;
    int PWS_PLAYER_STATE_STABLEHEAL = 6;
    int PWS_PLAYER_STATE_RESURRECTED = 7;
    int PWS_PLAYER_STATE_RESTRUE = 8;
    int PWS_PLAYER_STATE_RAISEDEAD = 9;

object oMod=GetModule();

int GPS(object oPC)
{
    return GetPersistentInt(oMod,"PlayerState"+GetName(oPC)+GetPCPublicCDKey(oPC));
}

void SPS(object oPC, int nPS)
{
    SetPersistentInt(oMod,"PlayerState"+GetName(oPC)+GetPCPublicCDKey(oPC), nPS);
}



