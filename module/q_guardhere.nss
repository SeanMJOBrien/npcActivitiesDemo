/////////////////////////////////////////////////////////////////////////////
// Real Time Strategy - NWN - guard x
// rt_c_uc_guardx
//===========================================================================
// By Deva Bryson Winblood.  02/23/2003
/////////////////////////////////////////////////////////////////////////////

void main()
{
    object oMe=OBJECT_SELF;
    object oPC=GetPCSpeaker();
    string sTeamID=GetLocalString(oPC,"sTeamID");
    object oGArea=GetArea(oMe);
    vector vV=GetPosition(oMe);
    SetLocalFloat(oMe,"fGX",vV.x);
    SetLocalFloat(oMe,"fGY",vV.y);
    SetLocalFloat(oMe,"fGZ",vV.z);
    SetLocalObject(oMe,"oGArea",oGArea);
    SetLocalInt(oMe,"nMState",2);
    SetLocalInt(oMe,"nSState",0);
    SetLocalInt(oMe,"nParm",0);
    SetLocalObject(oMe,"oDestWP",OBJECT_INVALID);
    DeleteLocalInt(oMe,"bFormationGuard");
}
