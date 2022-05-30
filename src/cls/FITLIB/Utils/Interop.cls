Class FITLIB.Utils.Interop Extends Ens.Rule.FunctionSet
{

/// Sample Interoperability Utility Function that returns an NPI # match for an HL7 Message in a DTL
/// that is viewable in Interoperability Production Message Trace!
/// 
/// This is a CONTRIVED Demo/Sample! Please ensure you apply appropriate error handling and 
/// validation to inputs and outputs prior to using in a real-world scenario.
ClassMethod GetProviderNPI(pLastName As %String, pFirstName As %String, pLocationZipCode As %String) As %String
{
    Set npi = ""
    If ((pLastName="") || (pFirstName="") || (pLocationZipCode="")) Quit npi

    Set tSC = ##class(Ens.Director).CreateBusinessService("REST.FunctionService", .tService)
    Set tService.TargetConfigName = "REST.NPPES.Operations"
    Set tService.FunctionName = "Executing NPPES GetNPIData Demo Request"
    If '$IsObject(tService) Quit npi

    Set getNPIDataReq = ##class(FITLIB.REST.NPPES.Msgs.GetNPIDataRequest).%New()
    Set getNPIDataReq.EnumerationType = "NPI-1"
    Set getNPIDataReq.ProviderFirstName = pFirstName
    Set getNPIDataReq.ProviderLastName = pLastName
    Set getNPIDataReq.PostalCode = pLocationZipCode

    Set tSC = tService.ProcessInput(getNPIDataReq, .getNPIDataResp)
    If (($$$ISOK(tSC)) && ($IsObject(getNPIDataResp)))
    { 
        If getNPIDataResp.ResultCount >= 1
        {
            Set npi = getNPIDataResp.Results.GetAt(1).NPINumber
        }
    }

    Quit npi
}

}
