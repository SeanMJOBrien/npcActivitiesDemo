//autoclose - place in door's OnOpen script
void main()
{
   DelayCommand(3.0, ActionCloseDoor(OBJECT_SELF));
}
