//be_reseated after conversation, using sit_right to initialize - peak 5/10
void main()
{
object oCustomer=GetFirstPC();
string sLastSittingOn=GetLocalString(oCustomer, "sLastSittingOn");

object oLastSittingOn=GetNearestObjectByTag(sLastSittingOn,oCustomer);
//SendMessageToPC(oCustomer,"sLastSittingOn= "+GetTag(oLastSittingOn));
DelayCommand(3.0,AssignCommand(oCustomer,ActionSit(oLastSittingOn)));
}
