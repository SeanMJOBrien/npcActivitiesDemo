void main()
{
object oPC=GetExitingObject();
effect eLoop=GetFirstEffect(oPC);

while (GetIsEffectValid(eLoop))
   {
   if (GetEffectType(eLoop)==EFFECT_TYPE_CONCEALMENT && GetEffectCreator(eLoop)==OBJECT_SELF)
       {
       RemoveEffect(oPC, eLoop);
       }
   eLoop=GetNextEffect(oPC);
   }
}
