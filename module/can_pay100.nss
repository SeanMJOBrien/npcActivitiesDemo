//:: FileName can_pay100
// Does the PC have 100 gp to pay?

#include "NW_I0_PLOT"

int StartingConditional()
{
    return (HasGold(100,GetPCSpeaker()));
}

