/////////////////////////////////////////////////////
// NPC ACTIVITIES 5.0 - OnPhysicalAttack Anvil
//--------------------------------------------------
// By Deva Bryson Winblood.
// Also used with NPC ACTIVITIES 6.0 but, did not require modification
/////////////////////////////////////////////////////
// SCRIPT: npcact_use_panvi
/////////////////////////////////////////////////////

void main()
{
    effect eSpark=EffectVisualEffect(VFX_COM_SPARKS_PARRY);
    object oMe=OBJECT_SELF;
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eSpark,oMe,1.0);
}
