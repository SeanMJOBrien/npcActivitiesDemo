////////////////////////////////////////////////////////////////////////////////
// npcact_h_time - NPC ACTIVITIES 6.0 - Time related functions
// By Deva Bryson Winblood.  09/15/2004
//------------------------------------------------------------------------------
// This header provides some specific time related functions
////////////////////////////////////////////////////////////////////////////////

/////////////////////////
// PROTOTYPES
/////////////////////////

// FILE: npcact_h_time                     FUNCTION: GetAbsoluteHour()
// This function will include convert months, days, and hours into
// a large number that takes all of them into consideration.  It does
// not deal with year.
int fnGetAbsoluteHour();


/////////////////////////
// FUNCTIONS
/////////////////////////

int fnGetAbsoluteHour()
{ // PURPOSE: To combine Month, day, and hour into an absolute hour
  int nRet=0;
  int nMonth=GetCalendarMonth();
  int nDay=GetCalendarDay();
  int nHour=GetTimeHour();
  nRet=nHour+(nDay*24)+(nMonth*30*24);
  return nRet;
} // fnGetAbsoluteHour()


//void main(){}
