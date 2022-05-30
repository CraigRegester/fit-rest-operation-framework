/*
    Fantastic IRIS Toolbox REST Operation Framework

    Created by Craig C. Regester in April 2022
    MIT License

    All credit to InterSystems Corporation for the platform
    which this tool takes advantage. This is merely an extension.

*/

Include FIT

Class FITLIB.REST.Operation Extends (FITLIB.Utils.Trace.Helper, Ens.BusinessOperation, Ens.Util.JSON) [ Abstract ]
{

Parameter ADAPTER As %String = "EnsLib.HTTP.OutboundAdapter";

Parameter INVOCATION = "Queue";

/// %HttpRequest (%Net.HttpRequest)
/// Holds request object used to submit requests and get reponses
Property %HttpRequest As %Net.HttpRequest [ Internal ];

/// ResponseClassName (%String)
/// Automatically initialized with the Response ClassName.
/// Requires the Request Message Class has a Parameter set to name
/// its associated Response Message Class.
/// e.g, Parameter RESPONSECLASSNAME = "FITLIB.REST.NPPES.Msgs.GetNPIDataResponse";
Property ResponseClassName As %String(MAXLEN = 500) [ Private ];

/// RESTCallName (%String)
/// Automatically initialized with the REST Call Name
/// Requires the Request Message Class has a Parameter set.
/// This is generally used for Message Traces, nothing more.
/// e.g, Parameter RESTCALLNAME = "GetNPIData";
Property RESTCallName As %String(MAXLEN = 500) [ Private ];

/// RESTCallDescription (%String)
/// Automatically initialized with the REST Call Name
/// Requires the Request Message Class has a Parameter set.
/// This is generally used for Message Traces, nothing more.
/// e.g, Parameter RESTCALLDESCRIPTION = "Service provided by NPPES to return NPI data based on supplied parameters";
Property RESTCallDescription As %String(MAXLEN = 500) [ Private ];

/// HttpVerb (%String)
/// Helper property for tracing and executing requests
/// Automatically initialized with the HTTP Verb (Action)
/// upon Initialize(). e.g., POST/GET/PUT/DELETE
Property HttpVerb As %String [ Private ];

/// ApiEndpoint (%String)
/// Helper property for tracing and building up URL Parameters
/// Automatically initialized with the Endpoint
/// upon Initialize(). e.g., /api/GetPatient
Property ApiEndpoint As %String(MAXLEN = 2000) [ Private ];

/// Request (%String)
/// Helper property with OREF to incoming Message Request
/// so it is not necessary to pass ByRef to every internal method.
/// Automatically initialized upon Initialize().
Property Request As %RegisteredObject [ Private ];

/// CustomOutboundHeaders (%String)
/// Comma separated list of HTTP Headers in format of HEADERNAME:HEADERVALUE
/// that should be included on the outbound request.
/// e.g., Special-Client-ID:123450abc-edfg-1234-9876-0e2b55e71x99
Property CustomOutboundHeaders As %String(MAXLEN = 4000);

/// ValidHttpStatusCodes
/// Comma-separated list of accepted HTTP Status Codes. Default is 200 (HTTP OK), but some vendors will require
/// for alternate responses to be deemed as an 'OK' (non-error) response.
/// Inclusive ranges of codes can be specified as well with hyphen between values.
/// e.g., 200, 210-219, 422
Property ValidHttpStatusCodes As %String(MAXLEN = 1000) [ InitialExpression = "200" ];

/// Set REST Auth Method for this operation.
/// - OAuth 2.0 Client: Select OAuth 2.0 client in OAuth Client setting.
/// - Bearer Token: Select Interoperability Credential object with token in password field.
/// - Basic: Select Interoperability Credential object.
/// - Authorization Header: Select Interoperability Credential object with token in password field.
/// - Empty: Default (None)
Property AuthMethod As %String(DISPLAYLIST = ",OAuth 2.0 Client,Bearer Token,Basic Authentication,Authorization Header", MAXLEN = 100, VALUELIST = ",OAuthClient,BearerToken,Basic,AuthHeader");

/// Set OAuth 2.0 Client Name that will be used to retrieve an access token and
/// automatically be added to the %Net.HttpRequest object initialized by this
/// operation. Token will not be visible in the traces, watch for appropriate
/// error messages for guidance on misconfigurations.
/// System-Security Management-OAuth 2.0 Client-Client Configurations Application Name
/// is the appropriate value to place here.
Property OAuthClient As %String;

/// If required, specify the audience, or aud, property of the OAuth 2.0 authorization
/// requests. Generally, the audience is used to indicate which resource server the
/// client is asking to query.
Property OAuthClientAudience As %String(MAXLEN = 250);

/// Select the SearchTable class to be used for REST objects. 
/// As REST requests are custom by nature, ensure the custom Message Class
/// youc create properly handles GetRESTPatientID() to identify the MRN of the
/// REST request (If appropriate - not all REST requests will have one!).
Property SearchTableClass As %String;

Parameter SETTINGS As %String = "CustomOutboundHeaders:Connection,ValidHttpStatusCodes:Additional,AuthMethod:Basic,OAuthClient:Basic,OAuthClientAudience:Basic,SearchTableClass:Additional:selector?context={Ens.ContextSearch/SearchTableClasses?host=Ens.Request}";

/// Initialize
/// Intended to be the primary method called by a class extending this class.
/// Initializes a fresh %Net.HttpRequest, configures authorization when appropriate, adds custom HTTP
/// outbound headers when appropriate and sets the Content-Type header.
/// 
/// If all successful, initializes some class properties for helper method use and then calculates the
/// URL Parameters (if needed) before returning %Library.Status.
/// 
/// Parameters:
///     pHttpVerb: GET,POST,PUT,DELETE - See API Endpoint specifications for what is proper.
///     pApiEndpoint: Endpoint for the request REST Request (this is not the hostname or Instance!)
///         e.g., /api/v1/VendorName/PerformAction
///     pRequest: Any Custom Message Class that extends Ens.Request and %JSON.Adaptor. Does not necessarily mean it is a JSON message!
///     pContentType: Default is application/json. Can be overridden as long as SubmitRequest has support built-in.
///         Currently handled types are application/json and multipart/form-data
/// 
Method Initialize(pHttpVerb As %String, pApiEndpoint As %String = "", ByRef pRequest As Ens.Request, pContentType As %String = "application/json") As %Library.Status
{
    $$$FITTRACESTARTCALL
    Set tSC = ..ClearRequest()
    If $$$ISERR(tSC) Quit tSC
    $$$TRACE("Configuring Authorization headers (if specified).")
    Set tSC = ..ConfigureAuth()
    If $$$ISERR(tSC) Quit tSC
    $$$TRACE("Setting custom HTTP headers (if specified).")
    Set tSC = ..SetCustomHeaders()
    If $$$ISERR(tSC) Quit tSC
    $$$TRACE("Setting Content-Type: "_pContentType)
    Set ..%HttpRequest.ContentType = pContentType
    Set ..%HttpRequest.ContentCharset = "UTF-8"

    Set ..HttpVerb = pHttpVerb
    If pApiEndpoint'="" Set ..ApiEndpoint = ..Adapter.URL_pApiEndpoint
    If pApiEndpoint ="" Set ..ApiEndpoint = ..Adapter.URL
    Set ..Request = pRequest

    Set tSC = ..SetMessageParameters()
    Set tSC = ..SetURLParameters()

    Quit tSC
}

/// SetCustomHeaders
/// Based on property setting CustomOutboundHeaders, automatically adds the requested Outbound Headers and
/// associated values to the %Net.HttpRequest.
/// 
/// This method is automatically called by method Initialize.
Method SetCustomHeaders() As %Library.Status [ Private ]
{
    Set tSC = $$$OK
    If ..CustomOutboundHeaders'=""
    {
        Set ptr=0,outboundHeaders=$LISTFROMSTRING(..CustomOutboundHeaders,",")
        While $LISTNEXT(outboundHeaders,ptr,header)
        {
            Do ..%HttpRequest.SetHeader($PIECE(header,":",1,1),$PIECE(header,":",2,2))
            $$$TRACE("Added custom HTTP Header: "_$PIECE(header,":",1,1))
        }
    }
    Quit tSC
}

/// ConfigureAuth
/// Based on property settings of this class, automatically handles both OAuth 2.0 Client token retrieval and setting
/// or Bearer Token Authorization headers. 
/// 
/// It is still the engineer's responsibility to setup an appropriate OAuth 2.0 Client Description (if needed) under
/// System-Security Management-OAuth 2.0 Client-Client Configurations. Application Name is the value used here.
/// 
/// Bearer Tokens are stored inside the Password field of an Interoperability Credential object.
/// 
/// This method is automatically called by method Initialize.
Method ConfigureAuth() As %Library.Status [ Private ]
{
    Set tSC = $$$OK
    If ..AuthMethod'=""
    {
        If ..AuthMethod = "OAuthClient"
        {
            Set properties = ""
            If ..OAuthClientAudience'= ""
            {
                Set properties("audience") = ..OAuthClientAudience
            }

            Set isOAuthClientAuthed = ##class(%SYS.OAuth2.AccessToken).IsAuthorized(..OAuthClient,,,.accessToken,.idToken,.responseProperties,.oauthError)
            If 'isOAuthClientAuthed
            {
                Set tSC = ##class(%SYS.OAuth2.Authorization).GetAccessTokenClient(..OAuthClient,"",.properties,.oauthError)
                If $$$ISERR(tSC) Quit tSC
            }
            Set tSC = ##class(%SYS.OAuth2.AccessToken).AddAccessToken(..%HttpRequest,,..Adapter.SSLConfig,..OAuthClient)
            If $$$ISERR(tSC) Quit tSC
            $$$TRACE("OAuth 2.0 Client Authorization: Successful")
        }

        If ..AuthMethod = "BearerToken"
        {
            Set credentialObject = ##class(Ens.Config.Credentials).%OpenId(..Adapter.Credentials)
            Do ..%HttpRequest.SetHeader("Authorization",("Bearer "_credentialObject.Password))
            $$$TRACE("Bearer Token added to request.")
        }

        If ..AuthMethod = "Basic"
        {
            $$$TRACE("Basic Authentication added to request.")
        }

        If ..AuthMethod = "AuthHeader"
        {
            Set credentialObject = ##class(Ens.Config.Credentials).%OpenId(..Adapter.Credentials)
            Do ..%HttpRequest.SetHeader("Authorization",credentialObject.Password)
            $$$TRACE("Authorization Header added to request.")
        }
    }
    Else
    {
        $$$TRACE("No AuthMethod specified.")
    }
    Quit tSC
}

/// SetMessageParameters
/// Helper method intended to only be used by this class. Retrieves class parameters from source
/// message class and assigns them to the class properties for use in tracing and response object
/// generation.
/// 
/// Required Message Request Class Parameters (ex. if request class is MYPKG.REST.VENDORNAME.Msgs.GetSomethingRequest):
///     Parameter RESPONSECLASSNAME = "MYPKG.REST.VENDORNAME.Msgs.GetSomethingResponse";
///     Parameter RESTCALLNAME = "GetSomething";
///     Parameter RESTCALLDESCRIPTION = "This API requests gets something! cool!";
Method SetMessageParameters() As %Library.Status [ Internal, Private ]
{
    Set tSC = $$$OK

    Set tResponseClassName = "", tRESTCallName = "", tRESTCallDescription = ""
    $$$comMemberKeyGetLvar(tResponseClassName,..Request.%ClassName(1),$$$cCLASSparameter,"RESPONSECLASSNAME",$$$cPARAMdefault)
    $$$comMemberKeyGetLvar(tRESTCallName,..Request.%ClassName(1),$$$cCLASSparameter,"RESTCALLNAME",$$$cPARAMdefault)
    $$$comMemberKeyGetLvar(tRESTCallDescription,..Request.%ClassName(1),$$$cCLASSparameter,"RESTCALLDESCRIPTION",$$$cPARAMdefault)
    If tResponseClassName '= "" {
		Set ..ResponseClassName = tResponseClassName
    } Else {
        // Can't determine the response class for this message ...
        Set tSC = $$$EnsError($$$EnsErrNoResponseClass,..Request.%ClassName(1))
        Quit tSC
	}
    Set ..RESTCallName = tRESTCallName
    Set ..RESTCallDescription = tRESTCallDescription

    Quit tSC
}

/// SetURLParameters
/// Helper method intended to only be used by this class. Using an XData block empowered by %JSON.Adaptor
/// that must be named UrlParameters, will retrieve properly formatted URL parameters from the source
/// message class and append them to the URL to be part of the query string.
/// 
/// Required Message Request Class XData Block example:
/// 
/// Property Hostname As %String(%JSONINCLUDE = "INPUTONLY", MAXLEN = "") [ Required ];
/// Property PatientIdentifier As %String(%JSONINCLUDE = "INPUTONLY", MAXLEN = "") [ Required ];
/// 
/// XData UrlParameters
/// {
/// <Mapping xmlns="http://www.intersystems.com/jsonmapping">
///    <Property Name="PatientIdentifier" FieldName="mrn"/>
/// </Mapping>
/// }
/// 
/// In the example above, both properties are INPUTONLY %JSONINCLUDE types but only PatientIdentifier
/// will be used as a Url Parameter and will have a key name of mrn.
/// e.g., /getpatient?mrn=123456
Method SetURLParameters() As %Library.Status [ Private ]
{
    Set tSC = $$$OK
    Set params = ""
    Set tSC = ..Request.%JSONExportToString(.urlParams,"UrlParameters")
    If urlParams '= ""
    {
        Set jsonUrlParams = {}.%FromJSON(urlParams)
        Set iter = jsonUrlParams.%GetIterator()
        If $ISOBJECT(iter)
        {
            While iter.%GetNext(.paramKey, .paramValue)
            {
                Set encodedParamValue = $ZCONVERT(paramValue,"O","UTF8")
                Set encodedParamValue = $ZCONVERT(encodedParamValue,"O","URL")
                If ((params="") && (..ApiEndpoint '[ "?"))
                {
                    Set params = "?"_paramKey_"="_encodedParamValue
                }
                Else
                {
                    Set params = params_"&"_paramKey_"="_encodedParamValue
                }
            }
        }
    }

    Set ..ApiEndpoint = ..ApiEndpoint_params
    Quit tSC
}

/// SubmitRequest
/// After any special handling and Initialize(), SubmitRequest can be safely executed to perform
/// the HTTP Action (Verb) required and return the response, if applicable.
/// 
/// Parameters:
///     pResponse: Any Custom Message Class that extends Ens.Response and %JSON.Adaptor
///     httpResponse: An instantiated %Net.HttpResponse object, if desired, for further interogation
/// 
///  Initialize and SubmitRequest are the primary methods intended to be used by extenders of this class.
///  All necessary sub-methods are executed by Initialize and SubmitRequest when appropriate, based on
///  defined properties and parameters (e.g., Content-Type, Auth Method, etc.)
Method SubmitRequest(Output pResponse As Ens.Response, Output httpResponse As %Net.HttpResponse = {$$$NULLOREF}) As %Library.Status
{
    Set tSC = $$$OK, validHttpStatusCodes = $LISTFROMSTRING(..ValidHttpStatusCodes,","), originalContentType = ..%HttpRequest.ContentType
    Set tSC = ..SetRequestSearchTableIndex()

    If (originalContentType [ "application/json")
    {
        $$$TRACE("Executing HandleJSONRequest. Content-Type: "_originalContentType)
        Set tSC = ..HandleJSONRequest()
        Quit:$$$ISERR(tSC) tSC
    }
    ElseIf (originalContentType [ "multipart/form-data")
    {
        $$$TRACE("Executing HandleFormDataRequest. Content-Type: "_originalContentType)
        Set tSC = ..HandleFormDataRequest()
        Quit:$$$ISERR(tSC) tSC
    }

    $$$TRACE("Sending "_..HttpVerb_" to endpoint "_..ApiEndpoint)
    Set tSC = ..Adapter.SendFormDataURL(..ApiEndpoint, .httpResponse, ..HttpVerb, ..%HttpRequest)

    If $$$ISERR(tSC)&&$ISOBJECT(httpResponse)&&$ISOBJECT(httpResponse.Data)&&httpResponse.Data.Size {
        $$$TRACE("Checking HTTP Response Status Code for valid value. It may override a normally invalid code.")
        If $LISTLENGTH(validHttpStatusCodes)=0 Set validHttpStatusCodes = $LISTBUILD("200")
        Set ptr=0
        While $LISTNEXT(validHttpStatusCodes,ptr,code)
        {
            If (code["-")
            {
                If ((httpResponse.StatusCode >= $PIECE(code,"-",1,1)) || (httpResponse.StatusCode <= $PIECE(code,"-",2,2)))
                {
                    $$$TRACE("Valid response code received.")
                    Set tSC = $$$OK
                    Quit
                }
            }
            ElseIf (code)
            {
                If (httpResponse.StatusCode = code)
                {
                    $$$TRACE("Valid response code received.")
                    Set tSC = $$$OK
                    Quit
                }
            }
        }
        If $$$ISERR(tSC)
        {
            $$$LOGWARNING("Invalid HTTP Status Code: "_httpResponse.StatusCode_":"_httpResponse.ReasonPhrase)
            Set tSC=$$$ERROR($$$EnsErrHTTPStatus,httpResponse.StatusCode,httpResponse.ReasonPhrase)
        }
    }
    Quit:$$$ISERR(tSC) tSC

    $$$TRACE("Transforming Response into Message Object")
    Set tSC = ..HandleJSONResponse(.pResponse)
    
    $$$FITTRACEENDCALL
    $$$TRACE("Returning response to caller and exiting.")
    Quit tSC
}

Method HandleFormDataRequest() As %Library.Status
{
    Set tSC = $$$OK
    Set mimeWriter = ##class(%Net.MIMEWriter).%New(), rootMIME = ##class(%Net.MIMEPart).%New()

    // "Getting properties via macro-wrapped direct global references is harder to read,
    // but is the fastest way to do it." Thanks @Timothy.Leavitt!
    // https://community.intersystems.com/post/listing-all-properties-class-and-why-i-love-objectscript
    Set key = "", class = ..Request.%ClassName(1)
    For {
        Set key = $$$comMemberNext(class,$$$cCLASSproperty,key)
        Quit:key=""
        Set type = $$$comMemberKeyGet(class,$$$cCLASSproperty,key,$$$cPROPtype)
        Set origin = $$$comMemberKeyGet(class,$$$cCLASSproperty,key,$$$cPROPorigin)
        Set properties(key) = $LISTBUILD(type,origin)
    }

    Set key=""
    For {
        Set key=$ORDER(properties(key),1,data)
        Quit:key=""
        Set $LISTBUILD(type,origin) = data
        // Make sure we only get non-inherited properties
        If origin = class
        {
            Set propRef = $PROPERTY(..Request,key)
            Set fieldName = $$$comMemberArrayGet(class,$$$cCLASSproperty,key,$$$cPROPparameter,"%JSONFIELDNAME")
            If type = "%Library.String"
            {
                $$$TRACE("Adding form data property '"_fieldName_"'")
                Set txtMIMEPart = ##class(%Net.MIMEPart).%New()
                // Define/Set the Content-Disposition header indicating how this MIME part is encoded and what it contains.
		        // Final string looks like: form-data; name="propertyName"
                Set txtContentDisposition = "form-data; name="_$CHAR(34)_fieldName_$CHAR(34)
                Do txtMIMEPart.SetHeader("Content-Disposition", txtContentDisposition)
                Set txtMIMEPart.Body = ##class(%Stream.GlobalCharacter).%New()
                Do txtMIMEPart.Body.Write(propRef)
                $$$TRACE("Txt MIME Part created. Disposition: "_txtContentDisposition_"  Value: "_propRef)
                Do rootMIME.Parts.Insert(txtMIMEPart)
            }

            If ((type = "Ens.StreamContainer") && ($ISOBJECT(propRef)))
            {
                $$$TRACE("Adding form data property '"_fieldName_"'")
                Set fileExt = $PIECE(propRef.OutputFilename,".",*)
                Set fileMIMEPart = ##class(%Net.MIMEPart).%New()
                // Define/Set the Content-Disposition header indicating how this MIME part is encoded and what it contains.
		        // Final string looks like: form-data; name="file1"; filename="myfilename.ext"
                Set fileContentDisposition = "form-data; name="_$CHAR(34)_fieldName_$CHAR(34)_"; filename="_$CHAR(34)_propRef.OutputFilename_$CHAR(34)
                Do fileMIMEPart.SetHeader("Content-Disposition", fileContentDisposition)
                Set fileMIMEPart.Body = propRef.Stream
                Set fileMIMEPart.ContentType = ("application/"_fileExt)
                $$$TRACE("File MIME Part created. Disposition: "_fileContentDisposition_"  Content-Type: "_fileMIMEPart.ContentType)
                Do rootMIME.Parts.Insert(fileMIMEPart)
            }
        }
    }

    Set tSC = mimeWriter.OutputToStream(..%HttpRequest.EntityBody)
    If $$$ISERR(tSC) {Do $SYSTEM.Status.DisplayError(tSC) Quit}
    Set tSC = mimeWriter.WriteMIMEBody(rootMIME)
	If $$$ISERR(tSC) {Do $SYSTEM.Status.DisplayError(tSC) Quit}

    Set reqContentType = "multipart/form-data; boundary="_rootMIME.Boundary
    Do ..%HttpRequest.SetHeader("Content-Type",reqContentType)

    Set tTraceTitle = "REST Request: "_..RESTCallName
    Set URL = $SELECT(..Adapter.SSLConfig'="":"https",1:"http")_"://"_..Adapter.HTTPServer_..ApiEndpoint
    Set HTTPAction = ..HttpVerb
    Set tVariableNames = "tSC,HTTPAction,URL,%Net.HttpRequest.ContentType,%Net.HttpRequest.EntityBody"
    If $$$FITTRACINGCALLED
    {
        $$$FITTRACECALLED(tTraceTitle,tVariableNames,tSC,HTTPAction,URL,reqContentType,..%HttpRequest.EntityBody)
    }

    Quit tSC
}

/// HandleJSONRequest
/// 
Method HandleJSONRequest() As %Library.Status [ Private ]
{
    Set tSC = $$$OK
    Set tSC = ..Request.%JSONExportToString(.json)
    Set tSC = ..%HttpRequest.EntityBody.Write(json)

    Set tTraceTitle = "REST Request: "_..RESTCallName
    Set URL = $SELECT(..Adapter.SSLConfig'="":"https",1:"http")_"://"_..Adapter.HTTPServer_..ApiEndpoint
    Set HTTPAction = ..HttpVerb
    Set tVariableNames = "tSC,HTTPAction,URL,%Net.HttpRequest.EntityBody"
    If $$$FITTRACINGCALLED
    {
        Set jsonObject = {}.%FromJSON(json)
        $$$FITTRACECALLED(tTraceTitle,tVariableNames,tSC,HTTPAction,URL,$GET(jsonObject))
    }

    Quit tSC
}

/// HandleJSONResponse
/// Returns JSON Request as message object associated with the request message object's RESPONSECLASSNAME property.
/// 
/// Response can safely be returned, if desired, to Interoperability Business Process.
/// 
/// Parameters:
///     pHttpResponse: The %Net.HttpResponse object of %Net.HttpRequest. Typically ..%HttpRequest.HttpResponse.
///     pResponse: By Reference handle to the pResponse object which is initialized with the JSON Stream returning from the endpoint.
Method HandleJSONResponse(ByRef pResponse As Ens.Response) As %Library.Status [ Private ]
{
    Set tSC = $$$OK
    Set tHttpResponseStatusCode = ..%HttpRequest.HttpResponse.StatusCode
    Set tHttpResponseStatusLine = ..%HttpRequest.HttpResponse.StatusLine
    Set tHttpResponseIsObject = $ISOBJECT(..%HttpRequest.HttpResponse.Data)
    Set tHttpResponseContentLength = ..%HttpRequest.HttpResponse.ContentLength
    Set tHttpResponseContentInfo = ..%HttpRequest.HttpResponse.ContentInfo
    Set tHttpResponseContentType = ..%HttpRequest.HttpResponse.ContentType

    Set tTraceTitle = "REST Response: "_..RESTCallName
    Set tVariableNames = "tSC,%Net.HttpResponse.StatusCode,%Net.HttpResponse.StatusLine,%Net.HttpResponse.Data,%Net.HttpResponse.ContentLength,%Net.HttpResponse.ContentInfo,%Net.HttpResponse.ContentType"
    If ((tHttpResponseIsObject) && ($ZCONVERT(tHttpResponseContentType,"L") [ "application/json"))
    {
        Set responseData = {}.%FromJSON(..%HttpRequest.HttpResponse.Data)
        Set pResponse = $CLASSMETHOD(..ResponseClassName,"%New")
        Set tSC = pResponse.%JSONImport(responseData)
    }
    Else
    {
        Set responseData = ..%HttpRequest.HttpResponse.Data
    }
    
    If $$$FITTRACINGCALLED
    {
        $$$FITTRACECALLED(tTraceTitle,tVariableNames,tSC,tHttpResponseStatusCode,tHttpResponseStatusLine,tHttpResponseIsObject,tHttpResponseContentLength,tHttpResponseContentInfo,tHttpResponseContentType,responseData)
    }

    Quit tSC
}

/// SetRequestSearchTableIndex
/// Helper Method to Index REST Request Message Objects into a Search Table.
/// To use, the Request or Response object must have a Method of this nature:
/// Method GetRESTPatientID() As %String
/// {
///     // Quit this method with a reference to property containing the patient ID.
///     Quit ..CustomPatientIDPropertyName
/// }
Method SetRequestSearchTableIndex() As %Library.Status [ Internal, Private ]
{
	Set tSC = $$$OK
	If ""'=..SearchTableClass {
		Try {		
			Set tSCStore=$ZOBJCLASSMETHOD(..SearchTableClass,"IndexDoc",..Request)
			If $$$ISERR(tSCStore) $$$LOGWARNING("Failed to construct SearchTable entries for message "_..Request_"/"_..Request.%Id()_" using class '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
		} Catch errobj { $$$LOGWARNING("Failed to invoke SearchTable method "_..SearchTableClass_".IndexDoc() for message "_..Request_"/"_..Request.%Id()_" : "_errobj.AsSystemError()) }
	}
	Quit tSC
}

/// OnInit
/// This user callback method is called via initConfig() from %OnNew()
Method OnInit() As %Library.Status
{
	Set ..%HttpRequest=##class(%Net.HttpRequest).%New()
	Quit $$$OK
}

/// ClearRequest
/// Clears the %Net.HttpRequest object for use.
/// Helper method called by Init before sending a new request.
/// This method cannot be invoked externally.
Method ClearRequest() As %Library.Status [ Internal ]
{
	Set tSC=$$$OK
	Set ..%HttpRequest.Location="", ..%HttpRequest.AcceptGzip=0, ..%HttpRequest.FollowRedirect=0, ..%HttpRequest.ReadRawMode=1,  ..%HttpRequest.WriteRawMode=0
	Do ..%HttpRequest.Reset()
	Do ..%HttpRequest.RemoveHeader("HOST"), ..%HttpRequest.RemoveHeader("USER-AGENT"), ..%HttpRequest.RemoveHeader("REFERER")
	Quit tSC
}

}
