Class FITLIB.REST.NPPES.dt.Result Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property NPINumber As %Integer(%JSONFIELDNAME = "number");

Property NPIType As %String(%JSONFIELDNAME = "enumeration_type", MAXLEN = "");

Property Basic As FITLIB.REST.NPPES.dt.Basic(%JSONFIELDNAME = "basic");

Property OtherNames As list Of FITLIB.REST.NPPES.dt.OtherName(%JSONFIELDNAME = "other_names");

Property Addresses As list Of FITLIB.REST.NPPES.dt.Address(%JSONFIELDNAME = "addresses");

Property PracticeLocations As list Of FITLIB.REST.NPPES.dt.PracticeLocation(%JSONFIELDNAME = "practiceLocations");

Property Identifiers As list Of FITLIB.REST.NPPES.dt.Identifier(%JSONFIELDNAME = "identifiers");

Property Taxonomies As list Of FITLIB.REST.NPPES.dt.Taxonomy(%JSONFIELDNAME = "taxonomies");

Property Endpoints As list Of FITLIB.REST.NPPES.dt.Endpoint(%JSONFIELDNAME = "endpoints");

Property Created As %PosixTime(%JSONFIELDNAME = "created_epoch");

Property Updated As %PosixTime(%JSONFIELDNAME = "last_updated_epoch");

Storage Default
{
<Data name="ResultState">
<Value name="1">
<Value>NPINumber</Value>
</Value>
<Value name="2">
<Value>NPIType</Value>
</Value>
<Value name="3">
<Value>Basic</Value>
</Value>
<Value name="4">
<Value>OtherNames</Value>
</Value>
<Value name="5">
<Value>Addresses</Value>
</Value>
<Value name="6">
<Value>PracticeLocations</Value>
</Value>
<Value name="7">
<Value>Identifiers</Value>
</Value>
<Value name="8">
<Value>Taxonomies</Value>
</Value>
<Value name="9">
<Value>Endpoints</Value>
</Value>
<Value name="10">
<Value>Created</Value>
</Value>
<Value name="11">
<Value>Updated</Value>
</Value>
</Data>
<State>ResultState</State>
<StreamLocation>^FITLIB.REST.NPPES.dt.ResultS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
