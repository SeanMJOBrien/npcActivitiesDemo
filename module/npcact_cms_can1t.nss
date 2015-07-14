// npcact_cms_can1t
void main()
{
     int nAmount=-10;
     object oPC=GetPCSpeaker();
     int nS=GetLocalInt(oPC,"nCMSSelection");
     nS=nS+nAmount;
     SetLocalInt(oPC,"nCMSSelection",nS);
}
