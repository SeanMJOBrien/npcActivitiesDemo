////////////////////////////////////////////////////////////////////////////////
// lib_nais_time - This library contains functions dealing with time and events
// By Deva B. Winblood.  03/25/2007
////////////////////////////////////////////////////////////////////////////////

#include "lib_nais_persist"
#include "lib_nais_tool"

//////////////////////
// PROTOTYPES
//////////////////////

// FILE: lib_nais_time              FUNCTION: Time_GetAbsoluteHour()
// This will return the time expressed as Hour+Day*24+Month*24*30+Year*24*30*12
int Time_GetAbsoluteHour();


// FILE: lib_nais_time              FUNCTION: Time_GetStringTime()
// This will return a string representation of the time that can be stored in
// a database.  Minute/Hour/Day/Month/Year
string Time_GetStringTime();


// FILE: lib_nais_time              FUNCTION: Time_SetTimeFromString()
// This will take a string in the format of Minute/Hour/Day/Month/Year and
// will set the game time to match that time.   This is primarily intended
// to support resetting game time on a restart, reload, or reboot.
void Time_SetTimeFromString(string sTime);


//////////////////////
// FUNCTIONS
//////////////////////

int Time_GetAbsoluteHour()
{ // PURPOSE: Return the absolute hour
    return GetTimeHour()+(GetCalendarDay()*24)+(GetCalendarMonth()*24*30)+(GetCalendarYear()*24*30*12);
} // Time_GetAbsoluteHour();


string Time_GetStringTime()
{ // PURPOSE: Return time as a string
    string sRet;
    sRet=IntToString(GetTimeMinute())+"/"+IntToString(GetTimeHour())+"/";
    sRet=sRet+IntToString(GetCalendarDay())+"/"+IntToString(GetCalendarMonth())+"/";
    sRet=sRet+IntToString(GetCalendarYear());
    return sRet;
} // Time_GetStringTime()

void Time_SetTimeFromString(string sTime)
{ // PURPOSE: Set time
    string sMaster=sTime;
    string sParse;
    int nMinute;
    int nHour;
    int nDay;
    int nMonth;
    int nYear;
    sParse=lib_ParseString(sMaster);
    sMaster=lib_RemoveParsed(sMaster,sParse);
    nMinute=StringToInt(sParse);
    sParse=lib_ParseString(sMaster);
    sMaster=lib_RemoveParsed(sMaster,sParse);
    nHour=StringToInt(sParse);
    sParse=lib_ParseString(sMaster);
    sMaster=lib_RemoveParsed(sMaster,sParse);
    nDay=StringToInt(sParse);
    sParse=lib_ParseString(sMaster);
    sMaster=lib_RemoveParsed(sMaster,sParse);
    nMonth=StringToInt(sParse);
    nYear=StringToInt(sMaster);
    SetCalendar(nYear,nMonth,nDay);
    SetTime(nHour,nMinute,0,0);
} // Time_SetTimeFromString()




//void main(){}
