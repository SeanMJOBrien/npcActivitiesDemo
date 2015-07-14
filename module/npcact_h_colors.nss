///////////////////////////////////////////////////////////////////////////////
// npcact_h_colors - NPC ACTIVITIES 6.0 - Colored Text support add-on
// color_header - This script is a modified version of a script found on
// the internet.  This modified version offers a function to give a little
// control over the RGB values.  This script was heavily modified and added to
//-----------------------------------------------------------------------------
// Modifications and RGB function by Deva Bryson Winblood
///////////////////////////////////////////////////////////////////////////////

/////////////////////
// CONSTANTS
/////////////////////

// FIXED COLORS
const string COLOR_BLUE         = "<cfÌþ>";
const string COLOR_DARK_BLUE    = "<c fþ>";
const string COLOR_GRAY         = "<c®®®>";
const string COLOR_GREEN        = "<c þ >";
const string COLOR_LIGHT_BLUE   = "<c®þþ>";
const string COLOR_LIGHT_GRAY   = "<c°°°>";
const string COLOR_LIGHT_ORANGE = "<cþ® >";
const string COLOR_LIGHT_PURPLE = "<cÌ®Ì>";
const string COLOR_ORANGE       = "<cþf >";
const string COLOR_PURPLE       = "<cÌwþ>";
const string COLOR_RED          = "<cþ  >";
const string COLOR_WHITE        = "<cþþþ>";
const string COLOR_YELLOW       = "<cþþ >";
const string COLOR_NONE         = "";
const string COLOR_BLACK        = "<c   >";
const string COLOR_END          = "</c>";

// PURPOSE OF COLOR CONSTANT NAMES:
const string COLOR_SAVING_THROW    = "<cfÌþ>";
const string COLOR_ELECTRIC_DAMAGE = "<c fþ>";
const string COLOR_NEGATIVE_DAMAGE = "<c®®®>";
const string COLOR_ACID_DAMAGE     = "<c þ >";
const string COLOR_PLAYER_NAME     = "<c®þþ>";
const string COLOR_COLD_DAMAGE     = "<c®þþ>";
const string COLOR_SYSTEM_MESSAGE  = "<c°°°>";
const string COLOR_SONIC_DAMAGE    = "<cþ® >";
const string COLOR_TARGET_NAME     = "<cÌ®Ì>";
const string COLOR_ATTACK_ROLL     = "<cþf >";
const string COLOR_PHYSICAL_DAMAGE = "<cþf >";
const string COLOR_SPELL_CAST      = "<cÌwþ>";
const string COLOR_MAGIC_DAMAGE    = "<cÌwþ>";
const string COLOR_FIRE_DAMAGE     = "<cþ  >";
const string COLOR_POSITIVE_DAMAGE = "<cþþþ>";
const string COLOR_HEALING         = "<cþþ >";
const string COLOR_SENT_MESSAGE    = "<cþþ >";

// RGB VALUES
// SYMBOLS <space>,f,I,P,R,o,w
const string COLOR_RGB_0        = " ";
const string COLOR_RGB_1        = "f";
const string COLOR_RGB_2        = "w";
const string COLOR_RGB_3        = "®";
const string COLOR_RGB_4        = "°";
const string COLOR_RGB_5        = "Ì";
const string COLOR_RGB_6        = "þ";

/////////////////////
// PROTOTYPES
/////////////////////

// FILE: color_header               FUNCTION: ColorString()
// To return the sString value encapsulated within the specified
// color.  EXAMPLE: ColorString("RED LINE",COLOR_RED);
// Additional color tags were added:  Here is a list of all the supported
// color tags.
// COLORS:
// COLOR_BLUE, COLOR_DARK_BLUE, COLOR_GRAY, COLOR_GREEN, COLOR_LIGHT_BLUE,
// COLOR_LIGHT_GRAY, COLOR_LIGHT_ORANGE, COLOR_LIGHT_PURPLE, COLOR_ORANGE,
// COLOR_PURPLE, COLOR_RED, COLOR_WHITE, COLOR_YELLOW, COLOR_NONE, and COLOR_BLACK.
// SYSTEM CORRESPONDING COLOR TAGS:
// COLOR_SAVING_THROW, COLOR_ELECTRIC_DAMAGE, COLOR_NEGATIVE_DAMAGE, COLOR_ACID_DAMAGE,
// COLOR_PLAYER_NAME, COLOR_COLD_DAMAGE, COLOR_SYSTEM_MESSAGE, COLOR_SONIC_DAMAGE,
// COLOR_TARGET_NAME, COLOR_ATTACK_ROLL, COLOR_PHYSICAL_DAMAGE, COLOR_SPELL_CAST,
// COLOR_MAGIC_DAMAGE, COLOR_FIRE_DAMAGE, COLOR_POSITIVE_DAMAGE, COLOR_HEALING,
// and last COLOR_SENT_MESSAGE.
string ColorString(string sString,string sColorTag);

// FILE: color_header               FUNCTION: ColorRGBString()
// This function will allow you to pass colors as RGB values from
// 0 to 6.  It will generate a color for you based on that.
// This supports almost 400 different color combinations.
// EXAMPLE: ColorRGBString("This is a grey",3,3,3,);
string ColorRGBString(string sString,int nR,int nG,int nB);


/////////////////////
// FUNCTIONS
/////////////////////

string ColorString(string sString, string sColorTag)
{ // PURPOSE: To return the passed sString enclosed in the
  // proper color settings.
  string sRet=sString;
  if (sColorTag=="COLOR_BLUE"||sColorTag=="COLOR_SAVING_THROW") { sRet=COLOR_BLUE+sString+COLOR_END; }
  else if (sColorTag=="COLOR_DARK_BLUE"||sColorTag=="COLOR_ELECTRICAL_DAMAGE") { sRet=COLOR_DARK_BLUE+sString+COLOR_END; }
  else if (sColorTag=="COLOR_GRAY"||sColorTag=="COLOR_NEGATIVE_DAMAGE") { sRet=COLOR_GRAY+sString+COLOR_END; }
  else if (sColorTag=="COLOR_GREEN"||sColorTag=="COLOR_ACID_DAMAGE") { sRet=COLOR_GREEN+sString+COLOR_END; }
  else if (sColorTag=="COLOR_LIGHT_BLUE"||sColorTag=="COLOR_PLAYER_NAME"||sColorTag=="COLOR_COLD_DAMAGE") { sRet=COLOR_LIGHT_BLUE+sString+COLOR_END; }
  else if (sColorTag=="COLOR_LIGHT_GRAY"||sColorTag=="COLOR_SYSTEM_MESSAGE") { sRet=COLOR_LIGHT_GRAY+sString+COLOR_END; }
  else if (sColorTag=="COLOR_LIGHT_ORANGE"||sColorTag=="COLOR_SONIC_DAMAGE") { sRet=COLOR_LIGHT_ORANGE+sString+COLOR_END; }
  else if (sColorTag=="COLOR_LIGHT_PURPLE"||sColorTag=="COLOR_TARGET_NAME") { sRet=COLOR_LIGHT_PURPLE+sString+COLOR_END; }
  else if (sColorTag=="COLOR_ORANGE"||sColorTag=="COLOR_ATTACK_ROLL"||sColorTag=="COLOR_PHYSICAL_DAMAGE") { sRet=COLOR_ORANGE+sString+COLOR_END; }
  else if (sColorTag=="COLOR_PURPLE"||sColorTag=="COLOR_SPELL_CAST"||sColorTag=="COLOR_MAGIC_DAMAGE") { sRet=COLOR_PURPLE+sString+COLOR_END; }
  else if (sColorTag=="COLOR_RED"||sColorTag=="COLOR_FIRE_DAMAGE") { sRet=COLOR_RED+sString+COLOR_END; }
  else if (sColorTag=="COLOR_WHITE"||sColorTag=="COLOR_POSITIVE_DAMAGE") { sRet=COLOR_WHITE+sString+COLOR_END; }
  else if (sColorTag=="COLOR_YELLOW"||sColorTag=="COLOR_HEALING"||sColorTag=="COLOR_SENT_MESSAGE") { sRet=COLOR_YELLOW+sString+COLOR_END; }
  else if (sColorTag=="COLOR_BLACK") { sRet=COLOR_BLACK+sString+COLOR_END; }
  return sRet;
} // ColorString()

string fnRGBDigit(int nVal)
{ // PURPOSE: return a portion of the span code
  string sRet=COLOR_RGB_0;
  if (nVal==1) return COLOR_RGB_1;
  else if (nVal==2) return COLOR_RGB_2;
  else if (nVal==3) return COLOR_RGB_3;
  else if (nVal==4) return COLOR_RGB_4;
  else if (nVal==5) return COLOR_RGB_5;
  else if (nVal==6) return COLOR_RGB_6;
  return sRet;
} // fnRGBDigit();

string fnSupportRGB(int nR,int nG, int nB)
{ // PURPOSE: Return the proper RGB Highlight span code
  string sRet=fnRGBDigit(nR)+fnRGBDigit(nG)+fnRGBDigit(nB);
  return sRet;
} // fnSupportRGB()

string ColorRGBString(string sString,int nR,int nG,int nB)
{ // PURPOSE: To generate an RGB based color
  string sRet;
  sRet = "<c"+fnSupportRGB(nR,nG,nB)+">"+sString+COLOR_END;
  return sRet;
} // ColorRGBString()

//void main(){}
