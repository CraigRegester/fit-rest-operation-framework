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
ClassMethod OnProcessCondition(
	pProperty As %String,
	pOperator As %String,
	pValue As %String,
	pTableName As %String,
	pTableInFrom As %Boolean,
	pSelectAsName As %String,
	pDisplayOnly As %Boolean = 0,
	ByRef pSelect As %String,
	ByRef pFrom As %String,
	ByRef pWhere As %String,
	ByRef pSQLFetch As %Boolean) As %Status
{
	If 'pTableInFrom {
		Set pFrom = pFrom _ $select(pFrom = "": "", 1: ", ") _ pTableName
	}
	Set pSQLFetch = 1
	Set pSelect = pTableName_".RESTPatientID As RESTPatientID"
	If 'pDisplayOnly {
		Set tWhere = ##class(EnsPortal.MsgFilter.Assistant).GetSQLCondition(pOperator,pTableName_".RESTPatientID",pValue)	
	}
	Quit $$$OK
}

ClassMethod OnIndexDoc(
	pDocObj As Ens.Request,
  pSearchTable As FITLIB.REST.SearchTable) As %Status
{
	Set pSearchTable.RESTPatientID = pDocObj.GetRESTPatientID()
	Quit $$$OK
}

ClassMethod BuildIndexHelper(pObjectName As %String) As %Status
{
	S tTotalMsgs = "UNKNOWN"
	W !,"Preparing to Build Search Table Index for: "_pObjectName,!

	&sql(
	DECLARE MsgCursor CURSOR FOR
	SELECT 	MessageBodyId, COUNT(MessageBodyId) INTO :msgBodyId, :tTotalMsgs
	FROM 	Ens.MessageHeader msgHead
	WHERE  ((:pObjectName LIKE 'From%' AND msgHead.SourceConfigName = :pObjectName) OR
			(:pObjectName LIKE 'To%' AND msgHead.TargetConfigName = :pObjectName))
	)
	
	&sql(OPEN MsgCursor)
	
	FOR { &sql(FETCH MsgCursor)
		Q:SQLCODE=100
		W !,"Msg ID: "_msgBodyId
    S tSC = ##class(FITLIB.REST.SearchTable).BuildIndex(msgBodyId,msgBodyId)
	}
	
	&sql(CLOSE MsgCursor)
	
  W !,"Finished indexing "_tTotalMsgs_" messages for "_pObjectName_" into FITLIB.REST.SearchTable.",!
}

}
