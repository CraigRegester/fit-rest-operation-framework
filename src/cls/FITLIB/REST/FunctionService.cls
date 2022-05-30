/*
    Fantastic IRIS Toolbox REST Operation FunctionService
        Sub-component of the FIT REST Operation Framework

    Created by Craig C. Regester in April 2022
    MIT License

    All credit to InterSystems Corporation for the platform
    which this tool takes advantage. This is merely an extension.

*/

/// <p>Simple adapterless service intended to be used as a 
/// Function helper so that 'utility-like' REST calls can
/// be made to vendors (e.g., NPPES) endpoints amd still take
/// full advantage of the FITLIB.REST.Operation functionality.
/// 
/// <p>Requires the Production contain a Business Service using
/// this class with a Pool Size of 0. No other settings required.
/// 
/// <p>Recommend: REST.FunctionService, used by Demos, but not required.
/// 
/// <p>Takes only two properties, TargetConfigName (Required) and
/// FunctionName (Optional but Recommended).
/// 
/// <p>TargetConfigName specifies where the Request object should be
/// sent inside the Production.
/// 
/// <p>FunctionName specifies the name of the Function making the
/// request for troubleshooting purposes in the Message Trace.
/// 
/// <p>Typical usage from a function or IRIS terminal (using GetNPIData as example):
/// <br>Set tSC = ##class(Ens.Director).CreateBusinessService("REST.FunctionService", .tService)
/// <br>Set tService.TargetConfigName = "REST.NPPES.Operations"
/// <br>Set tService.FunctionName = "Executing NPPES GetNPIData Request"
/// <br>If '$IsObject(tService) Quit tSC
/// <br>Set getNPIDataReq = ##class(FITLIB.REST.NPPES.Msgs.GetNPIDataRequest).%New()
/// <br>Set tSC = getDataReq.%JSONImport(jsonReq)
/// <br>Set getNPIDataReq.NPINumber = "1234567890"
/// <br>Set tSC = tService.ProcessInput(getNPIDataReq, .getNPIDataResp)
/// <br>If (($$$ISOK(tSC)) && ($IsObject(getNPIDataResp)))
/// <br>{ <DoStuff> }
Class FITLIB.REST.FunctionService Extends Ens.BusinessService
{

Parameter ADAPTER As %String;

Property TargetConfigName As %String;

Property FunctionName As %String;

Method OnProcessInput(pInput As %RegisteredObject, pOutput As %RegisteredObject) As %Library.Status
{
    Set tSC = $$$OK
    Set tSC = ..SendRequestSync(..TargetConfigName, pInput, .pOutput,,..FunctionName)
	Quit tSC
}

}
