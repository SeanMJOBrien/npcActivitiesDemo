#include "hench_i0_conv"

int StartingConditional()
{
    if ((GetLocalInt(OBJECT_SELF, sHenchNoDisarmTraps)) && (GetHasSkill(SKILL_DISABLE_TRAP)))
    {
        return TRUE;
    }
    return FALSE;
}


