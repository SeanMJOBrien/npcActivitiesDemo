void main()
{
    object oMarker = CreateObject(OBJECT_TYPE_PLACEABLE,"convmarker",GetLocation(OBJECT_SELF));
    AssignCommand(GetLastUsedBy(),ActionStartConversation(oMarker,"",TRUE,FALSE));
}
