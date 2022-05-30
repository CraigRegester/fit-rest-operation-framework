/*
    Fantastic IRIS Toolbox REST Operation Framework

    Created by Craig C. Regester in April 2022
    MIT License

    All credit to InterSystems Corporation for the platform
    which this tool takes advantage. This is merely an extension.

*/

/// Use this class to create an Interoperability Business Operation
/// with the name Utils.Trace.Operation
Class FITLIB.Utils.Trace.Operation Extends Ens.BusinessOperation
{

Method OnMessage(pRequest As Ens.Request, Output pResponse As Ens.Response) As %Status
{
	Quit $$$OK
}

}
