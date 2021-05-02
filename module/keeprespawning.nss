void main()
{
    int iUD = GetUserDefinedEventNumber();
    int iRandom = Random(4)+1;  //(4)+1 normal / (3)+2 for no archer respawn
    string sRandom = IntToString(iRandom);
    object oKoboldSpawn = GetNearestObjectByTag("Spawn_Kobold");
    location lSpawn = GetLocation(oKoboldSpawn);

    if (iUD == 1007)
    {
        CreateObject(OBJECT_TYPE_CREATURE, "kobold"+sRandom, lSpawn);
    }
}
