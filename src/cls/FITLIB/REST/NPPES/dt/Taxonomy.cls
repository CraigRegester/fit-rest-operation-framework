Class FITLIB.REST.NPPES.dt.Taxonomy Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Parameter %JSONIGNOREINVALIDFIELD = 1;

Property Code As %String(%JSONFIELDNAME = "code", MAXLEN = "");

Property Description As %String(%JSONFIELDNAME = "desc", MAXLEN = "");

Property License As %String(%JSONFIELDNAME = "license", MAXLEN = "");

Property Primary As %Boolean(%JSONFIELDNAME = "primary");

Property State As %String(%JSONFIELDNAME = "state", MAXLEN = "");

Storage Default
{
<Data name="TaxonomyState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>License</Value>
</Value>
<Value name="4">
<Value>Primary</Value>
</Value>
<Value name="5">
<Value>State</Value>
</Value>
</Data>
<State>TaxonomyState</State>
<StreamLocation>^FITLIB.REST.NPPES.dt.TaxonomyS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
