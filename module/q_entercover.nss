void main()
{
string s = GetStringRight(GetTag(OBJECT_SELF), 2);
int nConceal = StringToInt(s);
    if (nConceal < 1)
        {nConceal=25;} // Default 25%
    object oPC = GetEnteringObject();
    SendMessageToPC(oPC, ""+IntToString(nConceal)+"% cover against ranged attacks");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(nConceal, MISS_CHANCE_TYPE_VS_RANGED)), oPC);
}
