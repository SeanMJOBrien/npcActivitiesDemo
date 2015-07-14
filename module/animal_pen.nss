void main()
{
    /*
    * Smart Animal Pen
    *
    * This allows you to have creatures that will wander (using any wander
    * script) and never leave a specified "animal pen" area.
    * (This is useful for keeping animals away from fences and buildings
    *  where they tend to stick their bodies through solid objects)
    *
    * Unknown original author (thank you whoever you are)
    ***  Modified by Zeke Xeno  ***
    *
    * Useage,
    *
    * Create a generic trigger "pen" where you want your animals to stay.
    * Create 3 waypoints in that area named: WP_Return_1, WP_Return_2, and
    * WP_Return_3
    * Add animals to the pen
    * NOTE: ALL animals you want to stay in the pen need a tag that starts
    * "AP_" and need to start INSIDE the pen area.
    *
    * Now when the animals wander outside of the area of the trigger, they
    * will randomly return to one of the three waypoints.
    *
    */
    object oExit = GetExitingObject();
    string oExiterTag = GetTag(oExit);
    string sTag = GetSubString(oExiterTag, 0, 2);

    if(sTag == "AP")
    {
        string sNum = IntToString(Random(3) + 1);
        string sWayPoint = "WP_Return_" + sNum;

        AssignCommand(oExit,ClearAllActions());

        AssignCommand(oExit,ActionMoveToObject(GetNearestObjectByTag(sWayPoint)));
    }
    if(sTag=="Gr"&&(GetIsDawn()||GetIsDusk()))
    { // wait until milked
      AssignCommand(oExit,ClearAllActions());
      AssignCommand(oExit,ActionMoveToObject(GetNearestObjectByTag("POST_Dairy")));
    } // wait until milked
}
