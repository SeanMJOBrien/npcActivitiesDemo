#include "nw_i0_henchman"

void main()
{
    SetFormerMaster(GetPCSpeaker(), OBJECT_SELF);
    RemoveHenchman(GetPCSpeaker());
    ClearAllActions();

}
