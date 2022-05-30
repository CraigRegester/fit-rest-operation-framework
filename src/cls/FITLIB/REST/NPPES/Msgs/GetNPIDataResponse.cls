Class FITLIB.REST.NPPES.Msgs.GetNPIDataResponse Extends (Ens.Response, %JSON.Adaptor)
{

Property ResultCount As %Integer(%JSONFIELDNAME = "result_count");

Property Results As list Of FITLIB.REST.NPPES.dt.Result(%JSONFIELDNAME = "results");

Storage Default
{
<Data name="GetNPIDataResponseDefaultData">
<Subscript>"GetNPIDataResponse"</Subscript>
<Value name="1">
<Value>ResultCount</Value>
</Value>
<Value name="2">
<Value>Results</Value>
</Value>
</Data>
<DefaultData>GetNPIDataResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
