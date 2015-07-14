// npcact_cms_cap1z
void main()
{
     int nAmount=1;
     object oPC=GetPCSpeaker();
     int nS=GetLocalInt(oPC,"nCMSSelection");
     nS=nS+nAmount;
     SetLocalInt(oPC,"nCMSSelection",nS);
}
