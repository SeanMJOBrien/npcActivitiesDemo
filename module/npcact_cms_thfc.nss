// npcact_cms_thfc - Delete thief skill flag
void main()
{
  object oPC=GetPCSpeaker();
  DeleteLocalInt(oPC,"bCMSDoThief");
}
