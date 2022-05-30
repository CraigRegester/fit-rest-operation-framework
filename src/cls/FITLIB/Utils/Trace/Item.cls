Class FITLIB.Utils.Trace.Item Extends (%SerialObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL = "inputonly";

Property ItemName As %String(MAXLEN = "");

Property ItemClass As %String(MAXLEN = "");

Property ItemStream As %Stream.GlobalCharacter(CONTENT = "ESCAPE");

Property ItemValue As %String(CONTENT = "MIXED", MAXLEN = "");

Property ItemDescription As %String(MAXLEN = "");

Property ItemComment As %String(MAXLEN = 2048);

Storage Default
{
<Data name="ItemState">
<Value name="1">
<Value>ItemClass</Value>
</Value>
<Value name="2">
<Value>ItemStream</Value>
</Value>
<Value name="3">
<Value>ItemValue</Value>
</Value>
<Value name="4">
<Value>ItemDescription</Value>
</Value>
<Value name="5">
<Value>ItemComment</Value>
</Value>
<Value name="6">
<Value>ItemName</Value>
</Value>
</Data>
<State>ItemState</State>
<StreamLocation>^FITLIB.Utils.Trace.ItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
