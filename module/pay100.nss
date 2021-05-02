//:: FileName pay100
// PC pays 100 gp to NPC

void main()
{

    // Remove some gold from the player
    TakeGoldFromCreature(100, GetPCSpeaker(), TRUE);
}
