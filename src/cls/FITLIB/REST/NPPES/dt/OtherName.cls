Class FITLIB.REST.NPPES.dt.OtherName Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property Code As %String(%JSONFIELDNAME = "code", MAXLEN = "");

Property Credential As %String(%JSONFIELDNAME = "credential", MAXLEN = "");

Property NameFirst As %String(%JSONFIELDNAME = "first_name", MAXLEN = "");

Property NameMiddle As %String(%JSONFIELDNAME = "middle_name", MAXLEN = "");

Property NameLast As %String(%JSONFIELDNAME = "last_name", MAXLEN = "");

Property Type As %String(%JSONFIELDNAME = "type", MAXLEN = "");

Property OrganizationName As %String(%JSONFIELDNAME = "organization_name", MAXLEN = "");

Storage Default
{
<Data name="OtherNameState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Credential</Value>
</Value>
<Value name="3">
<Value>NameFirst</Value>
</Value>
<Value name="4">
<Value>NameMiddle</Value>
</Value>
<Value name="5">
<Value>NameLast</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>OrganizationName</Value>
</Value>
</Data>
<State>OtherNameState</State>
<StreamLocation>^FITLIB.REST.NPPE68EF.OtherNameS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
