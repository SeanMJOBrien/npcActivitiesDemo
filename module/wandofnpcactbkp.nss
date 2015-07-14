//::///////////////////////////////////////////////
//:: Example Item Event Script
//:: x2_it_example
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is an example of how to use the
    new default module events for NWN to
    have all code concerning one item in
    a single file.

    Note that this system only works if
    the following scripts are set in your
    module events

    OnEquip      - x2_mod_def_equ
    OnUnEquip    - x2_mod_def_unequ
    OnAcquire    - x2_mod_def_aqu
    OnUnAcqucire - x2_mod_def_unaqu
    OnActivate   - x2_mod_def_act
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-10
//:: Modified By: Grimlar
//:: Modified On: March 2004
//:://////////////////////////////////////////////

const int DEBUG = TRUE;

#include "x2_inc_switches"

void RemoveEffects(object oTarget)
{
    int iCount = 0;
    object oItem = OBJECT_SELF;
    effect eEffect = GetFirstEffect(oTarget);
    for (iCount = 1; iCount < 100; iCount++)
    {
        if (GetEffectCreator(eEffect) == oItem) RemoveEffect(oTarget, eEffect);
        eEffect = GetNextEffect(oTarget);
    }
}

int NoPlayersPresent()
{
    int iCount = 0;
    int iPlayersPresent = FALSE;
    object oPC = GetFirstPC();

    for (iCount =1; iCount < 10; iCount++)
    {
        if (GetIsDM(oPC) == FALSE && oPC != OBJECT_INVALID)
        {
            iPlayersPresent = TRUE;
            iCount = 10;
        }
        oPC = GetNextPC();
        if (oPC == OBJECT_INVALID) iCount = 10;
    }

    if (iPlayersPresent == TRUE) return FALSE;
    else return TRUE;

}

void fnMessage(object oPC,string sMsg)
{
  SendMessageToPC(oPC,sMsg);
  PrintString(sMsg);
} // fnMessage()

void DumpNPCACTData(object oPC, object oTarget)
{
   string sS;
   int nN;
   float fF;
   object oO;
   string sMsg;
   sMsg="[NPC ACTIVITIES DM WAND - DUMP DATA Initiated by '"+GetName(oPC)+"']";
   fnMessage(oPC,sMsg);
   sMsg="===  NPC '"+GetName(oTarget)+"["+GetTag(oTarget)+"]' ===";
   fnMessage(oPC,sMsg);
   sMsg="=== in area '"+GetName(GetArea(oTarget))+"["+GetTag(GetArea(oTarget))+"]' ===";
   fnMessage(oPC,sMsg);
   nN=GetLocalInt(oTarget,"nGNBStateSpeed");
   sMsg="nGNBStateSpeed="+IntToString(nN)+"  nGNBDisabled=";
   nN=GetLocalInt(oTarget,"nGNBDisabled");
   if (nN==TRUE) sMsg=sMsg+"TRUE";
   else { sMsg=sMsg+"FALSE"; }
   fnMessage(oPC,sMsg);
   nN=GetLocalInt(oTarget,"nGNBState");
   sMsg="nGNBState="+IntToString(nN)+" '";
   if (nN==0) sMsg=sMsg+"Inititializtion'";
   else if (nN==1) sMsg=sMsg+"Choose Destination'";
   else if (nN==2) sMsg=sMsg+"Move to Destination'";
   else if (nN==3) sMsg=sMsg+"Wait for arrival at Destination'";
   else if (nN==4) sMsg=sMsg+"Process Waypoint'";
   else if (nN==5) sMsg=sMsg+"Interpret Command'";
   else if (nN==6) sMsg=sMsg+"Wait for Command To Complete'";
   else if (nN==7) sMsg=sMsg+"Pause Interval'";
   else { sMsg=sMsg+"UNKNOWN'"; }
   fnMessage(oPC,sMsg);
   fF=GetLocalFloat(oTarget,"fGNBPause");
   sMsg="fGNBPause="+FloatToString(fF)+" sGNBDTag='"+GetLocalString(oTarget,"sGNBDTag")+"'";
   fnMessage(oPC,sMsg);
   nN=GetLocalInt(oTarget,"nGNBRun");
   sMsg="nGNBRun="+IntToString(nN)+"  sGNBHours='"+GetLocalString(oTarget,"sGNBHours")+"'";
   fnMessage(oPC,sMsg);
   oO=GetLocalObject(oTarget,"oDest");
   if (GetIsObjectValid(oO))
   { // valid destination
     sMsg="oDest='["+GetTag(oO)+"]' in area '"+GetName(GetArea(oO))+"["+GetTag(GetArea(oO))+"]";
   } // valid destination
   else { sMsg="oDest='Not a valid destination'"; }
   fnMessage(oPC,sMsg);
   nN=GetLocalInt(oTarget,"nGNBProfessions");
   sMsg="nGNBProfessions="+IntToString(nN);
   nN=GetLocalInt(oTarget,"nGNBProcessing");
   sMsg=sMsg+"  nGNBProcessing="+IntToString(nN);
   nN=GetLocalInt(oTarget,"nGNBProfProc");
   sMsg=sMsg+"  nGNBProfProc="+IntToString(nN);
   fnMessage(oPC,sMsg);
   sMsg="sAct='"+GetLocalString(oTarget,"sAct")+"'";
   fnMessage(oPC,sMsg);
   sMsg="[===== END OF DUMP =====]";
   fnMessage(oPC,sMsg);
}


void main()
{
    int nEvent = GetUserDefinedItemEventNumber(); //Which event triggered this
    object oPC;                                   //The player character using the item
    object oItem;                                 //The item being used
    object oSpellOrigin;                          //The origin of the spell
    object oSpellTarget;                          //The target of the spell
    int iSpell;                                   //The Spell ID number

    //Set the return value for the item event script
    // * X2_EXECUTE_SCRIPT_CONTINUE - continue calling script after executed script is done
    // * X2_EXECUTE_SCRIPT_END - end calling script after executed script is done
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {
        case X2_ITEM_EVENT_ONHITCAST:
            // * This code runs when the item has the 'OnHitCastSpell: Unique power' property
            // * and it hits a target(if it is a weapon) or is being hit (if it is a piece of armor)
            // * Note that this event fires for non PC creatures as well.

            oItem  =  GetSpellCastItem();               // The item triggering this spellscript
            oPC = OBJECT_SELF;                            // The player triggering it
            oSpellOrigin = OBJECT_SELF ;               // Where the spell came from
            oSpellTarget = GetSpellTargetObject();  // What the spell is aimed at

            //Your code goes here
            break;

        case X2_ITEM_EVENT_ACTIVATE:
// * This code runs when the Unique Power property of the item is used or the item
// * is activated. Note that this event fires for PCs only
        {

            oPC   = GetItemActivator();                 // The player who activated the item
            oItem = GetItemActivated();               // The item that was activated
            object oTarget = GetItemActivatedTarget();

    if (GetIsDM(oPC) == FALSE)
    {
        SendMessageToPC(oPC,"You are not a DM!");
        DestroyObject(oItem);
        return;
    }

    RemoveEffects(oTarget);

    if (GetLocalInt(oTarget,"nGNBDisabled") == FALSE)
    {
            SendMessageToPC(oPC,"Stopping npc: " + GetName(oTarget));

            int nGNBDisabled = GetLocalInt(oTarget,"nGNBDisabled");
            SetLocalInt(oTarget,"nGNBDisabled",TRUE);

            int nGNBProfessions = GetLocalInt(oTarget,"nGNBProfessions");
            SetLocalInt(oTarget,"nGNBProfessions",TRUE);

            int nGNBState = GetLocalInt(oTarget,"nGNBState");
            SetLocalInt(oTarget,"nGNBState",6);

            AssignCommand(oTarget,ActionDoCommand(ClearAllActions(FALSE)));
            AssignCommand(oTarget,ClearAllActions(FALSE));
            if (NoPlayersPresent()) ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(VFX_DUR_AURA_RED_DARK,FALSE),oTarget,60.0);
        }

        else if (GetLocalInt(oTarget,"nGNBDisabled") == TRUE)
        {
            SendMessageToPC(oPC,"Restarting npc: " + GetName(oTarget));

            int nGNBDisabled = GetLocalInt(oTarget,"nGNBDisabled");
            SetLocalInt(oTarget,"nGNBDisabled",FALSE);

            int nGNBProfessions = GetLocalInt(oTarget,"nGNBProfessions");
            SetLocalInt(oTarget,"nGNBProfessions",FALSE);

            int nGNBState = GetLocalInt(oTarget,"nGNBState");
            SetLocalInt(oTarget,"nGNBState",0);

            if (NoPlayersPresent()) ApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectVisualEffect(VFX_DUR_AURA_GREEN,FALSE),oTarget,60.0);
        }

        if (DEBUG) DumpNPCACTData(oPC, oTarget);


            //Your code goes here
            break;

        }
        case X2_ITEM_EVENT_EQUIP:
            // * This code runs when the item is equipped
            // * Note that this event fires for PCs only

            oPC = GetPCItemLastEquippedBy();        // The player who equipped the item
            oItem = GetPCItemLastEquipped();         // The item that was equipped

            //Your code goes here
            break;

        case X2_ITEM_EVENT_UNEQUIP:
            // * This code runs when the item is unequipped
            // * Note that this event fires for PCs only

            oPC    = GetPCItemLastUnequippedBy();   // The player who unequipped the item
            oItem  = GetPCItemLastUnequipped();      // The item that was unequipped

            //Your code goes here
            break;

        case X2_ITEM_EVENT_ACQUIRE:
            // * This code runs when the item is acquired
            // * Note that this event fires for PCs only

            oPC = GetModuleItemAcquiredBy();        // The player who acquired the item
            oItem  = GetModuleItemAcquired();        // The item that was acquired

            //Your code goes here
            break;

        case X2_ITEM_EVENT_UNACQUIRE:

            // * This code runs when the item is unacquired
            // * Note that this event fires for PCs only

            oPC = GetModuleItemLostBy();            // The player who dropped the item
            oItem  = GetModuleItemLost();            // The item that was dropped

            //Your code goes here
            break;

       case X2_ITEM_EVENT_SPELLCAST_AT:
            //* This code runs when a PC or DM casts a spell from one of the
            //* standard spellbooks on the item

            oPC = OBJECT_SELF;                          // The player who cast the spell
            oItem  = GetSpellTargetObject();        // The item targeted by the spell
            iSpell = GetSpellId();                         // The id of the spell that was cast
                                                                    // See the list of SPELL_* constants

            //Your code goes here

            //Change the following line from X2_EXECUTE_SCRIPT_CONTINUE to
            //X2_EXECUTE_SCRIPT_END if you want to prevent the spell that was
            //cast on the item from taking effect
            nResult = X2_EXECUTE_SCRIPT_CONTINUE;
            break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

