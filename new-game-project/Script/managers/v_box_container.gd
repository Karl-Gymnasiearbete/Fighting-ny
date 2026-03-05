extends VBoxContainer

public partial class Draggable : Control
{
	public override Variant _GetDragData(Vector2 atPosition)
	{
		var d = this;
		Node node = ((Node)this).Duplicate();
		SetDragPreview((Control)node);
		return d;
	}
}
