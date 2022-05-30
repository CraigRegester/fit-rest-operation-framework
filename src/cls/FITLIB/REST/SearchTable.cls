Class FITLIB.REST.SearchTable Extends Ens.CustomSearchTable
{

/// As each REST Request likely has different fieldname specifications, intent is to identify a standard
/// set of fields (e.g., PatientID) so that the custom message classes can all index key values regardless of their custom field names.
Parameter DOCCLASS = "Ens.Request";

/// Standard Property to hold the PatientID (MRN) of a REST Request. Different vendors may use different
/// names for PatientID (e.g. MRN, MedicalRecordNum, PatientNumber, etc) but having a consistent
/// property identified for SearchTable purposes will allow all REST Request objects to use the same
/// SearchTable (FITLIB.REST.SearchTable)
Property RESTPatientID As %String(COLLATION = "EXACT");

Index RESTPatientID On RESTPatientID [ Type = bitmap ];

/// Callback invoked by the Message Viewer UI
ClassMethod OnProcessCondition(pProperty As %String, pOperator As %String, pValue As %String, pTableName As %String, pTableInFrom As %Boolean, pSelectAsName As %String, pDisplayOnly As %Boolean = 0, ByRef pSelect As %String, ByRef pFrom As %String, ByRef pWhere As %String, ByRef pSQLFetch As %Boolean) As %Status
{
	If 'pTableInFrom {
		Set pFrom = pFrom _ $SELECT(pFrom = "": "", 1: ", ") _ pTableName
	}
	Set pSQLFetch = 1
	Set pSelect = pTableName_".RESTPatientID As RESTPatientID"
	If 'pDisplayOnly {
		Set tWhere = ##class(EnsPortal.MsgFilter.Assistant).GetSQLCondition(pOperator,pTableName_".RESTPatientID",pValue)	
	}
	Quit $$$OK
}

ClassMethod OnIndexDoc(pDocObj As Ens.Request, pSearchTable As FITLIB.REST.SearchTable) As %Status
{
	Set pSearchTable.RESTPatientID = pDocObj.GetRESTPatientID()
	Quit $$$OK
}

ClassMethod BuildIndexHelper(pObjectName As %String) As %Status
{
	Set tTotalMsgs = "UNKNOWN"
	Write !,"Preparing to Build Search Table Index for: "_pObjectName,!

	&sql(
	DECLARE MsgCursor CURSOR FOR
	SELECT 	MessageBodyId, COUNT(MessageBodyId) INTO :msgBodyId, :tTotalMsgs
	FROM 	Ens.MessageHeader msgHead
	WHERE  ((:pObjectName LIKE 'From%' AND msgHead.SourceConfigName = :pObjectName) OR
			(:pObjectName LIKE 'To%' AND msgHead.TargetConfigName = :pObjectName))
	)
	
	&sql(OPEN MsgCursor)
	
	For { &sql(FETCH MsgCursor)
		Quit:SQLCODE=100
		Write !,"Msg ID: "_msgBodyId
    Set tSC = ##class(FITLIB.REST.SearchTable).BuildIndex(msgBodyId,msgBodyId)
	}
	
	&sql(CLOSE MsgCursor)
	
  Write !,"Finished indexing "_tTotalMsgs_" messages for "_pObjectName_" into FITLIB.REST.SearchTable.",!
}

Storage Default
{
<Data name="SearchTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>RESTPatientID</Value>
</Value>
</Data>
<DataLocation>^FITLIB.REST.SearchTableD</DataLocation>
<DefaultData>SearchTableDefaultData</DefaultData>
<IdLocation>^FITLIB.REST.SearchTableD</IdLocation>
<IndexLocation>^FITLIB.REST.SearchTableI</IndexLocation>
<StreamLocation>^FITLIB.REST.SearchTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
