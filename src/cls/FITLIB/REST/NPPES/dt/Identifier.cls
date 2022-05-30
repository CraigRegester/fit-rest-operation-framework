Class FITLIB.REST.NPPES.dt.Identifier Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property Code As %String(%JSONFIELDNAME = "code", MAXLEN = "");

Property Description As %String(%JSONFIELDNAME = "desc", MAXLEN = "");

Property Identifier As %String(%JSONFIELDNAME = "identifier", MAXLEN = "");

Property Issuer As %String(%JSONFIELDNAME = "issuer", MAXLEN = "");

Property State As %String(%JSONFIELDNAME = "state", MAXLEN = "");

Storage Default
{
<Data name="IdentifierState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Identifier</Value>
</Value>
<Value name="4">
<Value>Issuer</Value>
</Value>
<Value name="5">
<Value>State</Value>
</Value>
</Data>
<State>IdentifierState</State>
<StreamLocation>^FITLIB.REST.NPP68EF.IdentifierS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
