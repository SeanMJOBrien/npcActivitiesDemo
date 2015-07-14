void main()
{
object oSelf = OBJECT_SELF;
object oSpawner = GetLocalObject(oSelf, "MASTER");
int nAction = GetCurrentAction(oSelf);
if((nAction == ACTION_WAIT || nAction == ACTION_INVALID) && oSpawner != OBJECT_INVALID)
  {
  ClearAllActions();
  ActionMoveToObject(oSpawner);
  }
//Rest of On-HeartBeat Script
}
