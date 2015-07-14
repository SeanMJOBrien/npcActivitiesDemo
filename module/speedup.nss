//////speedup
// pathway trigger area increase movement rate
// Peak 5/10
// see slowdown for comments
#include "nw_i0_spells"
// for RemoveSpecificEffect()
void main()
{
  object oMe = GetEnteringObject();
  int nMovement = EFFECT_TYPE_MOVEMENT_SPEED_DECREASE;
  RemoveSpecificEffect(nMovement,oMe);
}
