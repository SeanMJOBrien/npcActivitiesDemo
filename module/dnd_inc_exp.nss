// ADND 1E Experience Tracking File
// Coded By: Archaegeo
// August 31, 2002


// fMult is the multiple applied to all exp awards.
float fMult=1.0;


// fClass floats are applied after the fMult float, and are averaged together
// for multiclass character.  All default to 1.0
float fClassCleric = 1.11111 ;
float fClassDruid = 0.90909 ;
float fClassFighter = 1.00000 ;
float fClassPaladin = 0.71429 ;
float fClassRanger = 0.83916 ;
float fClassWizard = 0.80000 ;
float fClassSorcerer = 0.80000 ;
float fClassRogue = 1.36364 ;
float fClassMonk = 0.69767 ;
float fClassBard = 1.36364 ;
float fClassBarbarian = 0.83916 ;


int GetExpForLevel(object oPC, int nLev)
{
    int nNew;
            if(nLev == 20) nNew=3750000;
            else if(nLev > 20) nNew=3750000;
            else if(nLev == 19) nNew=3375000;
            else if(nLev == 18) nNew=3000000;
            else if(nLev == 17) nNew=2625000;
            else if(nLev == 16) nNew=2250000;
            else if(nLev == 15) nNew=1875000;
            else if(nLev == 14) nNew=1500000;
            else if(nLev == 13) nNew=1125000;
            else if(nLev == 12) nNew=750000;
            else if(nLev == 11) nNew=375000;
            else if(nLev == 10) nNew=250000;
            else if(nLev == 9) nNew=135000;
            else if(nLev == 8) nNew=90000;
            else if(nLev == 7) nNew=60000;
            else if(nLev == 6) nNew=40000;
            else if(nLev == 5) nNew=22500;
            else if(nLev == 4) nNew=10000;
            else if(nLev == 3) nNew=5000;
            else if(nLev == 2) nNew=2500;
            else nNew=1;
    return nNew;
}
void DND_set_exp(object oPC, int nAmount)
{
    SetLocalInt(oPC,"CURRENTEXP",nAmount);
}


void SetUpExp(object oPC, int nAmount)
{
    int nCurXP;
    int nNexXP;
    float nCurDNDXP;
    int nNexDNDXP;
    int nLev=GetHitDice(oPC);
    nCurXP = GetXP(oPC);
    nNexDNDXP=GetExpForLevel(oPC, nLev+1);
    nNexXP = (((nLev+1) * nLev) / 2) * 1000;
    nCurDNDXP = (IntToFloat(nCurXP) * IntToFloat(nNexDNDXP)) / IntToFloat(nNexXP);
    DND_set_exp(oPC, FloatToInt(nCurDNDXP)+nAmount);
}

int DND_get_exp(object oPC)
{
    return GetLocalInt(oPC,"CURRENTEXP");
}

float GetMultiplier(int nClass)
{
    switch(nClass)
    {
        case CLASS_TYPE_BARBARIAN : return fClassBarbarian; break;
        case CLASS_TYPE_BARD   : return fClassBard; break;
        case CLASS_TYPE_CLERIC   : return fClassCleric; break;
        case CLASS_TYPE_DRUID   : return fClassDruid; break;
        case CLASS_TYPE_FIGHTER   : return fClassFighter; break;
        case CLASS_TYPE_MONK   : return fClassMonk; break;
        case CLASS_TYPE_PALADIN   : return fClassPaladin; break;
        case CLASS_TYPE_RANGER   : return fClassRanger; break;
        case CLASS_TYPE_ROGUE   : return fClassRogue; break;
        case CLASS_TYPE_SORCERER   : return fClassSorcerer; break;
        case CLASS_TYPE_WIZARD   : return fClassWizard; break;
    }
    return 1.0;
}

void DND_add_exp(object oPC, int nAmount)
{
    nAmount = FloatToInt((IntToFloat(nAmount) * fMult));
    float fClassMult;
    int nTot;
    while(GetClassByPosition(nTot+1, oPC) != CLASS_TYPE_INVALID)
    {
        fClassMult += GetMultiplier(GetClassByPosition(nTot+1,oPC));
        nTot++;
    }
    fClassMult /= nTot;

    nAmount = FloatToInt((IntToFloat(nAmount) * fClassMult));


//    if(GetXP(oPC)>1 && !GetLocalInt(oPC,"CURRENTEXP"))
//    {
        SetLocalInt(oPC,"EXPSETUP",nAmount);
        ExecuteScript("dnd_level",oPC);
        SendMessageToPC(oPC,"You gain: "+IntToString(nAmount)+" experience. Total "+
            "Exp: "+IntToString(DND_get_exp(oPC)));


        return;
//    }
//    SetLocalInt(oPC, "CURRENTEXP", (GetLocalInt(oPC,"CURRENTEXP")+nAmount));
//    SendMessageToPC(oPC,"You gain: "+IntToString(nAmount)+" experience. Total "+
//        "Exp: "+IntToString(DND_get_exp(oPC)));
//    ExecuteScript("dnd_level",oPC);
}


