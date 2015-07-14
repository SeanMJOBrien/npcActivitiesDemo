void main()
{
    // Clear invalid armour/cloak data from self
    DeleteLocalInt(OBJECT_SELF, "invalidcloak");
    DeleteLocalInt(OBJECT_SELF, "invalidarmour");
}
