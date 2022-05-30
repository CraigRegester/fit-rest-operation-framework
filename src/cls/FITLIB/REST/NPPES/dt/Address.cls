Class FITLIB.REST.NPPES.dt.Address Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property Type As %String(%JSONFIELDNAME = "address_type", MAXLEN = "");

Property Purpose As %String(%JSONFIELDNAME = "address_purpose", MAXLEN = "");

Property AddressLine1 As %String(%JSONFIELDNAME = "address_1", MAXLEN = "");

Property AddressLine2 As %String(%JSONFIELDNAME = "address_2", MAXLEN = "");

Property City As %String(%JSONFIELDNAME = "city", MAXLEN = "");

Property State As %String(%JSONFIELDNAME = "state", MAXLEN = "");

Property ZipCode As %String(%JSONFIELDNAME = "postal_code", MAXLEN = "");

Property CountryCode As %String(%JSONFIELDNAME = "country_code", MAXLEN = "");

Property CountryName As %String(%JSONFIELDNAME = "country_name", MAXLEN = "");

Property Phone As %String(%JSONFIELDNAME = "telephone_number", MAXLEN = "");

Property Fax As %String(%JSONFIELDNAME = "fax_number", MAXLEN = "");

Storage Default
{
<Data name="AddressState">
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>Purpose</Value>
</Value>
<Value name="3">
<Value>AddressLine1</Value>
</Value>
<Value name="4">
<Value>AddressLine2</Value>
</Value>
<Value name="5">
<Value>City</Value>
</Value>
<Value name="6">
<Value>State</Value>
</Value>
<Value name="7">
<Value>ZipCode</Value>
</Value>
<Value name="8">
<Value>CountryCode</Value>
</Value>
<Value name="9">
<Value>CountryName</Value>
</Value>
<Value name="10">
<Value>Phone</Value>
</Value>
<Value name="11">
<Value>Fax</Value>
</Value>
</Data>
<State>AddressState</State>
<StreamLocation>^FITLIB.REST.NPPES.dt.AddressS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
