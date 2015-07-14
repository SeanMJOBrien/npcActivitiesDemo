// npcact_cms_cap10
void main()
{
     int nAmount=10000;
     object oPC=GetPCSpeaker();
     int nS=GetLocalInt(oPC,"nCMSSelection");
     nS=nS+nAmount;
     SetLocalInt(oPC,"nCMSSelection",nS);
}
