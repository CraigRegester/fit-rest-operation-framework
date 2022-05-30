/// GenericResponse is intended to be used for Requests to vendors or endpoints
/// that do not return a response body (or the response body is meaningless).
/// 
/// <p>This generally occurs in scenarios where data is being POSTed or PUT to an
/// endpoint and no response is needed other than an HTTP 200 Status Code to
/// indicate success of the request.
Class FITLIB.REST.GenericResponse Extends (Ens.Response, %JSON.Adaptor)
{

Parameter %JSONIGNOREINVALIDFIELD = 1;

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
