//////speedup
// pathway trigger area increase movement rate
// Peak 5/10
//
// place normal transition boxes enclosing road/path segments
// this script in on_enter
// corresponding slowdown in on_exit
// and slowdown_areaexit as area on_exit script event
//#include "nw_i0_spells"
void main()
{
  object oMe = GetExitingObject();
  effect eMovement = EffectMovementSpeedDecrease(35);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,eMovement,oMe);
}
