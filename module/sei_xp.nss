//
//  NWExperience
//
//  XP functionality to replace NWN standard XP handling
//
//  (c) Shir'le E. Illios, 2002 (shirle@drowwanderer.com)
//
////////////////////////////////////////////////////////

#include "dnd_inc_exp"
// **************************************************************
// ** Constants
// **********************
// General experience scale slider (also includes monster xp scale).
float ADVANCE_XP_SCALE = 1.0;

// Monster experience scale slider.
float MONSTER_XP_SCALE = 1.0;


// **************************************************************
// ** Forward declarations
// **********************

// Private function for the subraces script. Do not use.
int SEI_GetEffectiveCharacterLevel( object a_oCharacter );

// Private function for the subraces script. Do not use.
int SEI_ModifyXPForSubrace( object a_oCharacter, int a_nXP );




// **************************************************************
// ** Forward declarations for the Script Editor Help.
// **********************

// Reward experience to the character.
//  ARGUMENTS:
//      a_oCharacter    = The character to give the experience to.
//      a_nXP           = The experience to give to the character.
//
void XP_RewardXP( object a_oCharacter, int a_nXP );

// Give XP to a party dividing it between them based on level.
//  ARGUMENTS:
//      a_oCharacter    = One of the party members to give the experience to.
//      a_oArea         = Only party members in this area will get XP.
//      a_nXP           = The amount of experience to divide between the party.
//
void XP_RewardXPToPartyInArea( object a_oCharacter, object a_oArea, int a_nXP );

// Reward characters experience for a kill.
// Use in a creature's OnDeath script.
//
void XP_RewardXPForKill();




// Make certain the character doesn't get more than one level from their xp gain.
//
int XP_CapXPToMaxGain( object a_oCharacter, int a_nXP )
{

    int nResult = a_nXP;

    // Get the character's level (ECL).
    int nLevel = SEI_GetEffectiveCharacterLevel( a_oCharacter );

    // Get how much experience the character has.
    int nXP = GetXP( a_oCharacter );

    // Get the maximum number of levels the character can gain.
    int nMaxLevelGain = ( ( nLevel >= 20 ) ? 0 : 1 );

    // Get the maximum experience the character is allowed to have.
    int nMaxXP = ( 500 * ( ( nLevel + nMaxLevelGain + 1 ) * ( nLevel + nMaxLevelGain ) ) ) - 1;

    // Get the maximum amount of experience the character can gain.
    int nMaxXPGain = nMaxXP - nXP;

    // Cap the character's experience gain to a maximum gain.
    if( nResult > nMaxXPGain )
    {
        nResult = nMaxXPGain;
    }

    return nResult;

} // End XP_CapXPToMaxGain


// Reward experience to the character.
//
void XP_RewardXP( object a_oCharacter, int a_nXP )
{

    int nXP = a_nXP;

    nXP = SEI_ModifyXPForSubrace( a_oCharacter, nXP );

    nXP = FloatToInt( ADVANCE_XP_SCALE * nXP );

    nXP = XP_CapXPToMaxGain( a_oCharacter, nXP );

    // Make certain that the character doesn't get zero XP.
    if( nXP < 1 )
    {
        nXP = 1;
    }
    if(!GetLocalInt(GetModule(),"PWEXP"))
        GiveXPToCreature( a_oCharacter, nXP );
    else
        DND_add_exp(a_oCharacter, nXP);

} // End XP_RewardXP


// Give XP to a party dividing it between them based on level.
//
void XP_RewardXPToPartyInArea( object a_oCharacter, object a_oArea, int a_nXP )
{

    // SEI_NOTE: There now is an exploit where higher level character can boost
    //           the XP from encounters by including low-level PC (and thus
    //           lowering the avarage level).

    int nPartyMembers = 0;
    int nPartyLevelTotal = 0;

    object oPC = GetFirstFactionMember( a_oCharacter );

    // First get the number of party members and total level.
    while( GetIsObjectValid( oPC ) )
    {

        if( !GetIsDM( oPC ) && ( a_oArea == GetArea( oPC ) ) )
        {
            ++nPartyMembers;
            nPartyLevelTotal += SEI_GetEffectiveCharacterLevel( oPC );
        }

        oPC = GetNextFactionMember( a_oCharacter, TRUE );

    } // End while

    oPC = GetFirstFactionMember( a_oCharacter );

    // Apply experience to each PC based on their level.
    while( GetIsObjectValid( oPC ) )
    {

        if( !GetIsDM( oPC ) && ( a_oArea == GetArea( oPC ) ) )
        {
            int nCharXP = FloatToInt( IntToFloat( a_nXP ) *
                ( IntToFloat( SEI_GetEffectiveCharacterLevel( oPC ) ) / IntToFloat( nPartyLevelTotal ) ) );
            XP_RewardXP( oPC, nCharXP );
        }

        oPC = GetNextFactionMember( a_oCharacter, TRUE );

    } // End while

} // End XP_RewardXPToPartyInArea


// Get how much experience the CR is worth to a character of the average level.
//
int XP_GetXPFromCR( float a_fCR, float a_fAvgLvl )
{

    // Base experience to build the experience from.
    float fXP = 300.0;

    if( ( a_fAvgLvl >= 7.0 ) || ( a_fCR >= 1.5 ) )
    {

        fXP *= a_fAvgLvl;

        int nDiff = FloatToInt( ( ( a_fCR < 1.0 ) ? 1.0 : a_fCR ) - a_fAvgLvl );

        switch( nDiff )
        {

            // SEI_NOTE: Broken with styleguide for readability.

            case -7:    fXP /= 12.0;        break;
            case -6:    fXP /= 8.0;         break;
            case -5:    fXP *= 3.0 / 16.0;  break;
            case -4:    fXP /= 4.0;         break;
            case -3:    fXP /= 3.0;         break;
            case -2:    fXP /= 2.0;         break;
            case -1:    fXP *= 2.0 / 3.0;   break;
            case  0:                        break;
            case  1:    fXP *= 3.0 / 2.0;   break;
            case  2:    fXP *= 2.0;         break;
            case  3:    fXP *= 3.0;         break;
            case  4:    fXP *= 4.0;         break;
            case  5:    fXP *= 6.0;         break;
            case  6:    fXP *= 8.0;         break;
            case  7:    fXP *= 12.0;        break;
            // nDiff > 7 || nDiff < -7
            default:    fXP = 0.0;          break;

        } // End switch-case

    } // End if

    // Calculations for CR < 1
    if( ( a_fCR < 0.76 ) && ( fXP > 0.0 ) )
    {

        // SEI_NOTE: Broken with styleguide for readability.

             if( a_fCR <= 0.11 ) { fXP /= 10.0; }
        else if( a_fCR <= 0.13 ) { fXP /=  8.0; }
        else if( a_fCR <= 0.18 ) { fXP /=  6.0; }
        else if( a_fCR <= 0.28 ) { fXP /=  4.0; }
        else if( a_fCR <= 0.40 ) { fXP /=  3.0; }
        else if( a_fCR <= 0.76 ) { fXP /=  2.0; }

        // Only the CR vs Avg Level table could set nMonsterXP to 0...
        // to fix any round downs that result in 0:
        if( fXP <= 0.0 )
        {
            fXP = 1.0;
        }

    } // End if

    return FloatToInt( fXP );

} // End XP_GetXPFromCR


// Reward characters experience for a kill.
// Use in a creature's OnDeath script.
//
void XP_RewardXPForKill()
{

    object oKiller = GetLastKiller();
    object oKilledArea = GetArea( OBJECT_SELF );

    int nPartyMembers = 0;
    int nPartyLevelTotal = 0;

    object oPC = GetFirstFactionMember( oKiller );

    while( GetIsObjectValid( oPC ) )
    {

        if( !GetIsDM( oPC ) && ( oKilledArea == GetArea( oPC ) ) )
        {
            ++nPartyMembers;
            nPartyLevelTotal += SEI_GetEffectiveCharacterLevel( oPC );
        }

        oPC = GetNextFactionMember( oKiller, TRUE );

    } // End while

    if( nPartyMembers != 0 )
    {

        float fAvgPartyLevel = IntToFloat( nPartyLevelTotal ) / IntToFloat( nPartyMembers );

        // Bring partylevel up to 3 if less than 3
        if( fAvgPartyLevel < 3.0 )
        {
            fAvgPartyLevel = 3.0;
        }

        float fCR = GetChallengeRating( OBJECT_SELF );

        int nTotalXP = XP_GetXPFromCR( fCR, fAvgPartyLevel );

        XP_RewardXPToPartyInArea( oKiller, oKilledArea, FloatToInt( MONSTER_XP_SCALE * nTotalXP ) );

    } // End if

} // End XP_RewardXPForKill

