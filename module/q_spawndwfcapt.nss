void createParty()
{
    location spawnPoint = GetLocation(GetObjectByTag("SpawnFriend"));
    CreateObject(OBJECT_TYPE_CREATURE, "dwf_ftrspawn", spawnPoint);
/*    CreateObject(OBJECT_TYPE_CREATURE, "dwf_sqr1", spawnPoint);
    CreateObject(OBJECT_TYPE_CREATURE, "dwf_sqr1", spawnPoint);
    CreateObject(OBJECT_TYPE_CREATURE, "dwf_ftr3", spawnPoint);
    CreateObject(OBJECT_TYPE_CREATURE, "dwf_sqr1", spawnPoint);
  */

int i=0;
object creature;


/*    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD),
        spawnPoint, 5.0f);*/
/*
object oCreature = GetFirstPC();
effect eImmunity = EffectSpellImmunity( SPELL_ALL_SPELLS );

ApplyEffectToObject( DURATION_TYPE_PERMANENT, eImmunity, oCreature );
*/
}

void main()
{
/*    object oPC = GetFirstPC();

    if (GetIsObjectValid(oPC))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC, 2.0f);
    }
*/


    DelayCommand(1.0, createParty());

}
