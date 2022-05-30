Class FITLIB.REST.NPPES.Operations Extends FITLIB.REST.Operation
{

/// (GET) NPPES API Registry
/// Developed by: CMS
/// Purpose:
///     The NPI Registry Public Search is a free directory of all active National Provider Identifier (NPI) records.
/// API Specification: https://npiregistry.cms.hhs.gov/registry/help-api
Method GetNPIData(pRequest As FITLIB.REST.NPPES.Msgs.GetNPIDataRequest, Output pResponse As FITLIB.REST.NPPES.Msgs.GetNPIDataResponse) As %Library.Status
{
    Set tSC = ..Initialize("GET",,.pRequest)
	Quit ..SubmitRequest(.pResponse)
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="FITLIB.REST.NPPES.Msgs.GetNPIDataRequest">
		<Method>GetNPIData</Method>
	</MapItem>
</MapItems>
}

}
