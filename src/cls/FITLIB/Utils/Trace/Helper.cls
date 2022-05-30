Include FIT

/// This class is a derivative of an InterSystems class. All credit to InterSystems Corporation for its
/// original creation and the related TraceHelper include that has been derived as well.
/// 
/// The intent of this derivative is to augment the helper with the ability to output a proper JSON Formatted
/// stream if the object passed into the Trace Helper is a %DynamicAbstractObject.
Class FITLIB.Utils.Trace.Helper [ Abstract ]
{

Parameter SETTINGS As %String = "TraceOperations:Dev:selector?Select=1&context={FITLIB.Utils.ContextSearch/TraceValues}";

/// If this setting is not blank, then the system will expect there to be an operation named "Utils.Trace.Operation",
/// and it will direct trace messages to this operation.
Property TraceOperations As %String;

Method FITTrace(pCurrentClass, pMethod, pArgList...)
{
	Set tRequest = ..BuildTraceRequest(pCurrentClass,pMethod,pArgList...)
	If $THIS.%IsA("Ens.BusinessProcess") {
		Set tSC = ..SendRequestAsync("Utils.Trace.Operation",tRequest,0)
	} Else {
		Set tSC = ..SendRequestAsync("Utils.Trace.Operation",tRequest)
	}
}

ClassMethod BuildTraceRequest(pCurrentClass, pMethod, pArgList...)
{
	Set tRequest=##class(FITLIB.Utils.Trace.Request).%New()
	Set tRequest.CurrentClass=pCurrentClass
	Set tRequest.CurrentMethod=pMethod
	Set tRequest.Comment=pArgList(1)

	Set tMaxStringLength = $$$MaxStringLength-2500
	
	If pArgList>2 {
		Set tName=pArgList(2)
		For tI=3:1:pArgList
		{
			Set tVal=$GET(pArgList(tI))
			Set tItem=##class(FITLIB.Utils.Trace.Item).%New()
			Set tItem.ItemName=$PIECE(tName,",",tI - 2)
			If $ISOBJECT(tVal) {
				Set tSC=$$$OK
				Set tStream = ##class(%Stream.GlobalCharacter).%New()
				If tVal.%Extends("%XML.Adaptor") {
					Set tSC = tVal.XMLExportToStream(.tStream)  
				}
				ElseIf tVal.%Extends("%Stream.Object") {
					Do tStream.Write("<![CDATA[")
					Set tSC = tStream.CopyFrom(tVal)
					Do tStream.Write("]]>")
					Do tVal.Rewind()
				} ElseIf tVal.%Extends("%DynamicAbstractObject") {
					Do tStream.Write("<![CDATA[")
					Do ##class(%JSON.Formatter).%New().FormatToStream(tVal, .tStream)
					Do tStream.Write("]]>")
				}
				
				Set tItem.ItemClass=tVal
				If $$$ISERR(tSC)
				{
					Set tItem.ItemValue = $ZCONVERT($SYSTEM.Status.GetErrorText(tSC),"O","XML")
				}
				ElseIf tStream.Size < tMaxStringLength 
				{
					Do tStream.Rewind()
					Set tItem.ItemValue=tStream.Read(tMaxStringLength)
				} 
				Else
				{
					Set tItem.ItemStream=tStream
				}
			}
			Else 
			{
				If tItem.ItemName="tSC" Set tVal=$SELECT(tVal=1:1,1:$SYSTEM.Status.GetErrorText(tVal))
				Set tItem.ItemValue=$ZCONVERT(tVal,"O","XML")
			}
			Do tRequest.Items.Insert(tItem)
			Set tMaxStringLength=tMaxStringLength-$LENGTH(tItem.ItemValue)
		}
	}
	Return tRequest
}

}
