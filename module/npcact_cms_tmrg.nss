// npcact_cms_tmrg
int StartingConditional()
{
   object oPC=GetPCSpeaker();
   object oItem=GetLocalObject(oPC,"oCMSItem");
   object oTarget=GetLocalObject(oPC,"oCMSTarget");
   if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM)
   { // test 1
     if (GetResRef(oItem)==GetResRef(oTarget)&&GetTag(oItem)==GetTag(oTarget))
     { // test 2
       if (oItem!=oTarget) return TRUE;
     } // test 2
   } // test 1
   return FALSE;
}
