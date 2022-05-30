Include Ensemble

Class FITLIB.Utils.ContextSearch Extends %ZEN.Portal.ContextSearch
{

ClassMethod TraceValues(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
	Kill pResults, pTopResults
	Set pResults(1)=""
	Set pResults(2)="Errors Only"
	Set pResults(3)="Minimal"
	Set pResults(4)="Full"
	Quit $$$OK
}

}
