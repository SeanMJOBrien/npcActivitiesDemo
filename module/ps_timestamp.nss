// Pete Smith's time stamping functions... Jan. '04
//
// Functions:
// TimeStamp(oTarget,nSlot);
//TimeStamp(oTarget,nAddYear,nAddMonth,nAddDay,nAddHour,nSlot);
//     This function can handle overflows such as adding 128 days instead of 6 months.
// GetIsLaterThan(oTarget,nSlot); returns 1 for TRUE or 0 for FALSE
//     Actually later than or currently. In the event a timestamp doesn't exist in
//     the specified slot, the function will return a 2 (neither true nor false).
//     For error trapping reasons.
// DeleteTimeStamp(oTarget,nSlot);
// GetHoursTill(oTarget,nSlot); // returns the time till a give time stamp in hours.

void TimeStamp(object oTarget,int nSlot = 1)
// Very Simple. Writes local integers to target object reading the current:
// GetTimeHour() - 0 to 23
// GetCalendarDay() - 1 to 28
// GetCalendarMonth() - 1 to 12
// GetCalendarYear() - 0 to 30,000
{
if (GetIsObjectValid(oTarget))
    {
    SetLocalInt(oTarget,"nStampHour"+IntToString(nSlot),GetTimeHour());
    SetLocalInt(oTarget,"nStampDay"+IntToString(nSlot),GetCalendarDay());
    SetLocalInt(oTarget,"nStampMonth"+IntToString(nSlot),GetCalendarMonth());
    SetLocalInt(oTarget,"nStampYear"+IntToString(nSlot),GetCalendarYear());
    }
}

void AdvanceTimeStamp(object oTarget, int nAddYear, int nAddMonth, int nAddDay, int nAddHour, int nSlot = 1)
// Turns the clock forward. If the specified slot is empty the code will make a new
// stamp and then advance it.
{
if ((GetIsObjectValid(oTarget)) && (GetLocalInt(oTarget,"nStampDay"+IntToString(nSlot))==0))
    {
    SetLocalInt(oTarget,"nStampHour"+IntToString(nSlot),GetTimeHour());
    SetLocalInt(oTarget,"nStampDay"+IntToString(nSlot),GetCalendarDay());
    SetLocalInt(oTarget,"nStampMonth"+IntToString(nSlot),GetCalendarMonth());
    SetLocalInt(oTarget,"nStampYear"+IntToString(nSlot),GetCalendarYear());
    }
if (GetIsObjectValid(oTarget))
    {
    int nHourBuffer = GetLocalInt(oTarget,"nStampHour"+IntToString(nSlot)) + nAddHour;
    int nDayBuffer = GetLocalInt(oTarget,"nStampDay"+IntToString(nSlot)) + nAddDay;
    int nMonthBuffer = GetLocalInt(oTarget,"nStampMonth"+IntToString(nSlot)) + nAddMonth;
    int nYearBuffer = GetLocalInt(oTarget,"nStampYear"+IntToString(nSlot)) + nAddYear;
    if (nHourBuffer > 23)
        {
        nDayBuffer = nDayBuffer + (nHourBuffer / 23);
        while (nHourBuffer > 23)
            {
            nHourBuffer = nHourBuffer - 23;
            }
        }
    if (nDayBuffer > 28)
        {
        nMonthBuffer = nMonthBuffer + (nDayBuffer / 28);
        while (nDayBuffer > 28)
            {
            nDayBuffer = nDayBuffer - 28;
            }
        }
    if (nMonthBuffer > 12)
        {
        nYearBuffer = nYearBuffer + (nMonthBuffer / 12);
        while (nMonthBuffer > 12)
            {
            nMonthBuffer = nMonthBuffer - 12;
            }
        }
    SetLocalInt(oTarget,"nStampHour"+IntToString(nSlot),nHourBuffer);
    SetLocalInt(oTarget,"nStampDay"+IntToString(nSlot),nDayBuffer);
    SetLocalInt(oTarget,"nStampMonth"+IntToString(nSlot),nMonthBuffer);
    SetLocalInt(oTarget,"nStampYear"+IntToString(nSlot),nYearBuffer);
    }
}

int GetIsLaterThan(object oTarget, int nSlot = 1)
{
    if ((GetIsObjectValid(oTarget) == FALSE) || ((GetLocalInt(oTarget,"nStampDay"+IntToString(nSlot)) == 0) && (GetIsObjectValid(oTarget))))
        return 2;
    int nLaterThan = 2;
   int nHour = GetTimeHour();
    int nDay = GetCalendarDay();
    int nMonth = GetCalendarMonth();
    int nYear = GetCalendarYear();
    int nTargetHour = GetLocalInt(oTarget,"nStampHour"+IntToString(nSlot));
    int nTargetDay = GetLocalInt(oTarget,"nStampDay"+IntToString(nSlot));
    int nTargetMonth = GetLocalInt(oTarget,"nStampMonth"+IntToString(nSlot));
    int nTargetYear = GetLocalInt(oTarget,"nStampYear"+IntToString(nSlot));
    if (nYear > nTargetYear) nLaterThan =  1;
    else if (nYear < nTargetYear) nLaterThan = 0;
    else if (nMonth > nTargetMonth) nLaterThan = 1;
    else if (nMonth < nTargetMonth) nLaterThan = 0;
    else if (nDay > nTargetDay) nLaterThan = 1;
    else if (nDay < nTargetDay) nLaterThan = 0;
    else if (nHour >= nTargetHour) nLaterThan = 1;
    else if (nHour < nTargetHour) nLaterThan = 0;
return nLaterThan;
}

void DeleteTimeStamp(object oTarget,int nSlot = 1)
{
if (GetIsObjectValid(oTarget))
    {
    DeleteLocalInt(oTarget,"nStampHour"+IntToString(nSlot));
    DeleteLocalInt(oTarget,"nStampDay"+IntToString(nSlot));
    DeleteLocalInt(oTarget,"nStampMonth"+IntToString(nSlot));
    DeleteLocalInt(oTarget,"nStampYear"+IntToString(nSlot));
    }
}

int GetHoursTill(object oTarget, int nSlot = 1)
{
int nCount = 0;
int nHour = GetTimeHour();
int nDay = GetCalendarDay();
int nMonth = GetCalendarMonth();
int nYear = GetCalendarYear();
int nTargetHour = GetLocalInt(oTarget,"nStampHour"+IntToString(nSlot));
int nTargetDay = GetLocalInt(oTarget,"nStampDay"+IntToString(nSlot));
int nTargetMonth = GetLocalInt(oTarget,"nStampMonth"+IntToString(nSlot));
int nTargetYear = GetLocalInt(oTarget,"nStampYear"+IntToString(nSlot));
nCount = ((nTargetYear - nYear) * 8064) + ((nTargetMonth - nMonth) * 672) + ((nTargetDay - nDay) * 24) + (nTargetHour - nHour);
if ((GetIsObjectValid(oTarget) == FALSE) || ((GetLocalInt(oTarget,"nStampDay"+IntToString(nSlot)) == 0) && (GetIsObjectValid(oTarget))))
    nCount = 0;
return nCount;
}

string SayGreyhawkDateTime()
{
string sSay;
int nHour = GetTimeHour();
int nDay = GetCalendarDay();
int nMonth = GetCalendarMonth();
int nYear = GetCalendarYear();
sSay = ", "+IntToString(nYear)+" C.Y.";
if (nMonth == 1) sSay = " of the month of Fireseek"+sSay;
else if (nMonth == 2) sSay = " of the month of Readying"+sSay;
else if (nMonth == 3) sSay = " of the month of Coldeven"+sSay;
else if (nMonth == 4) sSay = " of the month of Planting"+sSay;
else if (nMonth == 5) sSay = " of the month of Flocktime"+sSay;
else if (nMonth == 6) sSay = " of the month of Wealsun"+sSay;
else if (nMonth == 7) sSay = " of the month of Reaping"+sSay;
else if (nMonth == 8) sSay = " of the month of Goodmonth"+sSay;
else if (nMonth == 9) sSay = " of the month of Harvester"+sSay;
else if (nMonth == 10) sSay = " of the month of Patchwall"+sSay;
else if (nMonth == 11) sSay = " of the month of Ready'reat"+sSay;
else if (nMonth == 12) sSay = " of the month of Sunsebb"+sSay;
if ((nDay == 1) || (nDay == 21)) sSay = ", the "+IntToString(nDay)+"st day"+sSay;
else if ((nDay == 2) || (nDay == 2)) sSay = ", the "+IntToString(nDay)+"nd day"+sSay;
else if ((nDay == 3) || (nDay == 23)) sSay = ", the "+IntToString(nDay)+"rd day"+sSay;
else  sSay = ", the "+IntToString(nDay)+"th day"+sSay;
     if ((nDay == 1) || (nDay == 8) || (nDay == 15) || (nDay == 22)) sSay = " on Starday"+sSay;
else if ((nDay == 2) || (nDay == 9) || (nDay == 16) || (nDay == 23)) sSay = " on Sunday"+sSay;
else if ((nDay == 3) || (nDay == 10) || (nDay == 17) || (nDay == 24)) sSay = " on Moonday"+sSay;
else if ((nDay == 4) || (nDay == 11) || (nDay == 18) || (nDay == 25)) sSay = " on Godsday"+sSay;
else if ((nDay == 5) || (nDay == 12) || (nDay == 19) || (nDay == 26)) sSay = " on Waterday"+sSay;
else if ((nDay == 6) || (nDay == 13) || (nDay == 20) || (nDay == 27)) sSay = " on Earthday"+sSay;
else if ((nDay == 7) || (nDay == 14) || (nDay == 21) || (nDay == 28)) sSay = " on Freeday"+sSay;

if (nHour == 12) sSay = "It is noon" + sSay;
else if (nHour == 0) sSay = "It is midnight" + sSay;
else if  ((nHour < 12) && (nHour > 2)) sSay = "It is "+IntToString(nHour)+" in the morning" + sSay;
else if  ((nHour == 1) || (nHour == 2)) sSay = "It is "+IntToString(nHour)+" after midnight" + sSay;
else if  ((nHour > 12) && (nHour < 18)) sSay = "It is "+IntToString(nHour-12)+" in the afternoon" + sSay;
else if  ((nHour < 20) && (nHour >= 18)) sSay = "It is "+IntToString(nHour-12)+" in the evening" + sSay;
else if  ((nHour < 24) && (nHour >= 20)) sSay = "It is "+IntToString(nHour-12)+" at night" + sSay;
return sSay;
}

string SayHours(int nHours)
    {
int nMonths;
int nDays;
int nMinHours = 0;
string sSay = "";
        while (nHours > 23)
            {
            nHours = nHours - 24;
            nDays++;
            }
        while (nDays > 28)
            {
            nDays = nDays - 28;
            nMonths ++;
            }
        if (nMonths > 0) sSay = IntToString(nMonths)+" month";
        if (nMonths > 1) sSay = sSay + "s";
        if ((nMonths > 0) && (nHours > 0) && (nDays > 0)) sSay = sSay + ", ";
        if ((nHours == 0) && (nMonths > 0) && (nDays > 0)) sSay = sSay + " and ";
        if (nDays > 0) sSay = sSay + IntToString(nDays)+" day";
        if (nDays > 1) sSay = sSay + "s";
        if (((nHours > 0) && (nDays > 0))||((nHours > 0) && (nMonths > 0))) sSay = sSay + " and ";
        if (nHours > 0) sSay = sSay + IntToString(nHours)+" hour";
        if (nHours > 1) sSay = sSay + "s";
    return sSay;
}

void AdvanceTimeInHours(int nSetHours)
{
//int nBuffer = 0;
//int nBuffer2 = 0;
//while (nSetHours != 0)
//    {
//    if ((nSetHours - 12) >= 0)
//        {
//        nBuffer = 12;
//        nSetHours -= 12;
//        }
//    else
//        {
//        nBuffer = nSetHours;
//        nSetHours = 0;
//        }
//    nBuffer2 = GetTimeHour() + nBuffer;
//    if (nBuffer2 > 23) nBuffer2 -= 24;
//    SetTime(nBuffer2,0,0,0);
int nBuffer2 = GetTimeHour() + nSetHours;
SetTime(nBuffer2,0,0,0);
//    }
}

string SayTimestamp(object oTarget,int nSlot = 1)
{
string sSay;
int nHour = GetLocalInt(oTarget,"nStampHour"+IntToString(nSlot));
int nDay = GetLocalInt(oTarget,"nStampDay"+IntToString(nSlot));
int nMonth = GetLocalInt(oTarget,"nStampMonth"+IntToString(nSlot));
int nYear = GetLocalInt(oTarget,"nStampYear"+IntToString(nSlot));
sSay = ", "+IntToString(nYear)+" C.Y.";
if (nMonth == 1) sSay = " of the month of Fireseek"+sSay;
else if (nMonth == 2) sSay = " of the month of Readying"+sSay;
else if (nMonth == 3) sSay = " of the month of Coldeven"+sSay;
else if (nMonth == 4) sSay = " of the month of Planting"+sSay;
else if (nMonth == 5) sSay = " of the month of Flocktime"+sSay;
else if (nMonth == 6) sSay = " of the month of Wealsun"+sSay;
else if (nMonth == 7) sSay = " of the month of Reaping"+sSay;
else if (nMonth == 8) sSay = " of the month of Goodmonth"+sSay;
else if (nMonth == 9) sSay = " of the month of Harvester"+sSay;
else if (nMonth == 10) sSay = " of the month of Patchwall"+sSay;
else if (nMonth == 11) sSay = " of the month of Ready'reat"+sSay;
else if (nMonth == 12) sSay = " of the month of Sunsebb"+sSay;
if ((nDay == 1) || (nDay == 21)) sSay = ", the "+IntToString(nDay)+"st day"+sSay;
else if ((nDay == 2) || (nDay == 2)) sSay = ", the "+IntToString(nDay)+"nd day"+sSay;
else if ((nDay == 3) || (nDay == 23)) sSay = ", the "+IntToString(nDay)+"rd day"+sSay;
else  sSay = ", the "+IntToString(nDay)+"th day"+sSay;
     if ((nDay == 1) || (nDay == 8) || (nDay == 15) || (nDay == 22)) sSay = " on Starday"+sSay;
else if ((nDay == 2) || (nDay == 9) || (nDay == 16) || (nDay == 23)) sSay = " on Sunday"+sSay;
else if ((nDay == 3) || (nDay == 10) || (nDay == 17) || (nDay == 24)) sSay = " on Moonday"+sSay;
else if ((nDay == 4) || (nDay == 11) || (nDay == 18) || (nDay == 25)) sSay = " on Godsday"+sSay;
else if ((nDay == 5) || (nDay == 12) || (nDay == 19) || (nDay == 26)) sSay = " on Waterday"+sSay;
else if ((nDay == 6) || (nDay == 13) || (nDay == 20) || (nDay == 27)) sSay = " on Earthday"+sSay;
else if ((nDay == 7) || (nDay == 14) || (nDay == 21) || (nDay == 28)) sSay = " on Freeday"+sSay;

if (nHour == 12) sSay = "It is noon" + sSay;
else if (nHour == 0) sSay = "It is midnight" + sSay;
else if  ((nHour < 12) && (nHour > 2)) sSay = "It is "+IntToString(nHour)+" in the morning" + sSay;
else if  ((nHour == 1) || (nHour == 2)) sSay = "It is "+IntToString(nHour)+" after midnight" + sSay;
else if  ((nHour > 12) && (nHour < 18)) sSay = "It is "+IntToString(nHour-12)+" in the afternoon" + sSay;
else if  ((nHour < 20) && (nHour >= 18)) sSay = "It is "+IntToString(nHour-12)+" in the evening" + sSay;
else if  ((nHour < 24) && (nHour >= 20)) sSay = "It is "+IntToString(nHour-12)+" at night" + sSay;
return sSay;
}

string SayLogTime()
{
string sSay = "<Y"+IntToString(GetCalendarYear())+",M"+IntToString(GetCalendarMonth())+",D"+IntToString(GetCalendarDay())+",H"+IntToString(GetTimeHour() + 1)+">";
return sSay;
}

