Class FITLIB.Utils.Trace.Request Extends Ens.Request
{

Parameter XMLIGNOREINVALIDTAG As BOOLEAN = 1;

Parameter XMLIGNORENULL As STRING [ Constraint = ",0,1,inputonly,runtime", Flags = ENUM ] = "inputonly";

Property CurrentClass As %String(MAXLEN = 128);

Property CurrentMethod As %String(MAXLEN = 255);

Property Comment As %String(MAXLEN = 2048);

Property Items As list Of Item;

Storage Default
{
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>CurrentClass</Value>
</Value>
<Value name="2">
<Value>CurrentMethod</Value>
</Value>
<Value name="3">
<Value>Comment</Value>
</Value>
<Value name="4">
<Value>Items</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
