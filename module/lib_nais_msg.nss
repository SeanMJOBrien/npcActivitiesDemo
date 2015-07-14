////////////////////////////////////////////////////////////////////////////////
// lib_nais_msg - Library of different methods for sending messages
// By Deva B. Winblood.  3/22/2007
////////////////////////////////////////////////////////////////////////////////

#include "lib_nais_tool"
#include "lib_nais_team"

/////////////////////////////////
// CONSTANTS
/////////////////////////////////



/////////////////////////////////
// PROTOTYPES
/////////////////////////////////


// FILE: lib_nais_msg           FUNCTION: Msg_Team()
// This will send a message to all team members. sColor will cause it to
// display in a specific color.  sSound will cause it to play a sound.
// If sTeamID is "" then it will use oSpeaker's team.
void Msg_Team(object oSpeaker,string sMsg,string sColor="",string sSound="",string sTeamID="",int bNameSpeaker=TRUE);


// FILE: lib_nais_msg           FUNCTION: Msg_Players()
// This will send a message to all players.   sColor will cause it to display
// in a specific color.  sSound will cause it to play a sound.
void Msg_Players(object oSpeaker,string sMsg,string sColor="",string sSound="",int bNameSpeaker=FALSE);


/////////////////////////////////
// FUNCTIONS
/////////////////////////////////


void Msg_Team(object oSpeaker,string sMsg,string sColor="",string sSound="",string sTeamID="",int bNameSpeaker=TRUE)
{ // PURPOSE: The message will be sent to all team members.
    object oPC;
    object oSound;
    string sSend;
    string sTID=sTeamID;
    if (GetIsObjectValid(oSpeaker))
    { // valid speaker
        if (GetStringLength(sTID)<1) sTID=Team_GetTeamID(oSpeaker);
        if (GetStringLength(sTID)>0)
        { // team specified
            if (bNameSpeaker) sSend=lib_SetStringColor(GetName(oSpeaker)+" sends:","555");
            if (GetStringLength(sColor)==3) sSend=sSend+lib_SetStringColor(sMsg,sColor);
            else { sSend=sSend+sMsg; }
            oPC=GetFirstPC();
            while(GetIsObjectValid(oPC))
            { // check all PCs
                if (Team_GetTeamID(oPC)==sTID&&oPC!=oSpeaker)
                { // correct team
                    SendMessageToPC(oPC,sSend);
                    if (GetStringLength(sSound)>0)
                    { // play sound
                        oSound=CreateObject(OBJECT_TYPE_PLACEABLE,"sound_object",GetLocation(oPC));
                        SetLocalString(oSound,"sSound",sSound);
                    } // play sound
                } // correct team
                oPC=GetNextPC();
            } // check all PCs
        } // team specified
    } // valid speaker
} // Msg_Team()


void Msg_Players(object oSpeaker,string sMsg,string sColor="",string sSound="",int bNameSpeaker=FALSE)
{ // PURPOSE: Send a message to all players
    object oPC;
    object oSound;
    string sSend;
    if (GetIsObjectValid(oSpeaker))
    { // valid speaker
        if (bNameSpeaker) sSend=lib_SetStringColor(GetName(oSpeaker)+" sends:","555");
        if (GetStringLength(sColor)==3) sSend=sSend+lib_SetStringColor(sMsg,sColor);
        else { sSend=sSend+sMsg; }
        oPC=GetFirstPC();
        while(GetIsObjectValid(oPC))
        { // check all PCs
            if (oPC!=oSpeaker)
            { // send message here
                SendMessageToPC(oPC,sSend);
                if (GetStringLength(sSound)>0)
                { // play sound
                    oSound=CreateObject(OBJECT_TYPE_PLACEABLE,"sound_object",GetLocation(oPC));
                    SetLocalString(oSound,"sSound",sSound);
                } // play sound
            } // send message here
            oPC=GetNextPC();
        } // check all PCs
    } // valid speaker
} // Msg_Players()


//void main(){}
