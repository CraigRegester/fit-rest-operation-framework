Class FITLIB.REST.NPPES.dt.Endpoint Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property UseType As %String(%JSONFIELDNAME = "use", MAXLEN = "");

Property UseDescription As %String(%JSONFIELDNAME = "useDescription", MAXLEN = "");

Property UseOtherDescription As %String(%JSONFIELDNAME = "useOtherDescription", MAXLEN = "");

Property Endpoint As %String(%JSONFIELDNAME = "endpoint", MAXLEN = "");

Property EndpointDescription As %String(%JSONFIELDNAME = "endpointDescription", MAXLEN = "");

Property EndpointType As %String(%JSONFIELDNAME = "endpointType", MAXLEN = "");

Property EndpointTypeDescription As %String(%JSONFIELDNAME = "endpointTypeDescription", MAXLEN = "");

Property ContentType As %String(%JSONFIELDNAME = "contentType", MAXLEN = "");

Property ContentTypeDescription As %String(%JSONFIELDNAME = "contentTypeDescription", MAXLEN = "");

Property ContentOtherDescription As %String(%JSONFIELDNAME = "contentOtherDescription", MAXLEN = "");

Property Affiliation As %String(%JSONFIELDNAME = "affiliation", MAXLEN = "");

Property AffiliationName As %String(%JSONFIELDNAME = "affiliationName", MAXLEN = "");

Property AddressType As %String(%JSONFIELDNAME = "address_type", MAXLEN = "");

Property AddressLine1 As %String(%JSONFIELDNAME = "address_1", MAXLEN = "");

Property AddressLine2 As %String(%JSONFIELDNAME = "address_2", MAXLEN = "");

Property City As %String(%JSONFIELDNAME = "city", MAXLEN = "");

Property State As %String(%JSONFIELDNAME = "state", MAXLEN = "");

Property ZipCode As %String(%JSONFIELDNAME = "postal_code", MAXLEN = "");

Property CountryCode As %String(%JSONFIELDNAME = "country_code", MAXLEN = "");

Property CountryName As %String(%JSONFIELDNAME = "country_name", MAXLEN = "");

Storage Default
{
<Data name="EndpointState">
<Value name="1">
<Value>UseType</Value>
</Value>
<Value name="2">
<Value>UseDescription</Value>
</Value>
<Value name="3">
<Value>UseOtherDescription</Value>
</Value>
<Value name="4">
<Value>Endpoint</Value>
</Value>
<Value name="5">
<Value>EndpointDescription</Value>
</Value>
<Value name="6">
<Value>EndpointType</Value>
</Value>
<Value name="7">
<Value>EndpointTypeDescription</Value>
</Value>
<Value name="8">
<Value>ContentType</Value>
</Value>
<Value name="9">
<Value>ContentTypeDescription</Value>
</Value>
<Value name="10">
<Value>ContentOtherDescription</Value>
</Value>
<Value name="11">
<Value>Affiliation</Value>
</Value>
<Value name="12">
<Value>AffiliationName</Value>
</Value>
<Value name="13">
<Value>AddressType</Value>
</Value>
<Value name="14">
<Value>AddressLine1</Value>
</Value>
<Value name="15">
<Value>AddressLine2</Value>
</Value>
<Value name="16">
<Value>City</Value>
</Value>
<Value name="17">
<Value>State</Value>
</Value>
<Value name="18">
<Value>ZipCode</Value>
</Value>
<Value name="19">
<Value>CountryCode</Value>
</Value>
<Value name="20">
<Value>CountryName</Value>
</Value>
</Data>
<State>EndpointState</State>
<StreamLocation>^FITLIB.REST.NPPES.dt.EndpointS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
