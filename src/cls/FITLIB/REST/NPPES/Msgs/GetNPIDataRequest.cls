/// CMS NPPES NPI Registry
/// Specification available: https://npiregistry.cms.hhs.gov/api/demo?version=2.1
/// NOTE: Not all available fields are included in this demo package.
Class FITLIB.REST.NPPES.Msgs.GetNPIDataRequest Extends (Ens.Request, %JSON.Adaptor)
{

Parameter RESPONSECLASSNAME = "FITLIB.REST.NPPES.Msgs.GetNPIDataResponse";

Parameter RESTCALLNAME = "NPPES NPI Registry";

Parameter RESTCALLDESCRIPTION = "The NPI Registry Public Search is a free directory of all active National Provider Identifier (NPI) records.";

/// Provider (Type 1) or Organization (Type 2) NPI Number
/// Must be exactly 10 digits.
Property NPINumber As %String(%JSONINCLUDE = "INPUTONLY", MAXLEN = 10, MINLEN = 0);

/// Type 1 is a Individual Provider Type, Type 2 is an Organization
Property EnumerationType As %String(%JSONINCLUDE = "INPUTONLY", DISPLAYLIST = ",Type 1 (Individual),Type 2 (Organization)", MAXLEN = 5, MINLEN = 0, VALUELIST = ",NPI-1,NPI-2");

/// Individual Provider First Name
/// Exact name or wildcard (*) after 2 characters
/// For Type-1 search only
Property ProviderFirstName As %String(%JSONINCLUDE = "INPUTONLY");

/// Individual Provider Last Name
/// Exact name or wildcard (*) after 2 characters
/// For Type-1 search only
Property ProviderLastName As %String(%JSONINCLUDE = "INPUTONLY");

/// Organization Name
/// Exact name or wildcard (*) after 2 characters
/// For Type-2 search only
Property OrganizationName As %String(%JSONINCLUDE = "INPUTONLY");

/// Postal Code (Zip Code)
/// Exact Postal Code (5 digits will also return 9 digit zip + 4), or wildcard * after 2 characters
/// For Type-1 or Type-2 searches
Property PostalCode As %String(%JSONINCLUDE = "INPUTONLY");

/// Limit Results
/// Default is 10, max = 1000
/// For Type-1 or Type-2 searches
Property Limit As %Integer(%JSONINCLUDE = "INPUTONLY", MAXVAL = 1000, MINVAL = 1) [ InitialExpression = 10 ];

/// Written for Version 2.1 originally.
Property APIVersion As %String(%JSONINCLUDE = "INPUTONLY") [ InitialExpression = "2.1" ];

XData UrlParameters
{
<Mapping xmlns="http://www.intersystems.com/jsonmapping">
    <Property Name="NPINumber" FieldName="number"/>
    <Property Name="EnumerationType" FieldName="enumeration_type"/>
    <Property Name="ProviderFirstName" FieldName="first_name"/>
    <Property Name="ProviderLastName" FieldName="last_name"/>
    <Property Name="OrganizationName" FieldName="organization_name"/>
    <Property Name="PostalCode" FieldName="postal_code"/>
    <Property Name="Limit" FieldName="limit"/>
    <Property Name="APIVersion" FieldName="version"/>
</Mapping>
}

Storage Default
{
<Data name="GetNPIDataRequestDefaultData">
<Subscript>"GetNPIDataRequest"</Subscript>
<Value name="1">
<Value>NPINumber</Value>
</Value>
<Value name="2">
<Value>EnumerationType</Value>
</Value>
<Value name="3">
<Value>ProviderFirstName</Value>
</Value>
<Value name="4">
<Value>ProviderLastName</Value>
</Value>
<Value name="5">
<Value>OrganizationName</Value>
</Value>
<Value name="6">
<Value>PostalCode</Value>
</Value>
<Value name="7">
<Value>Limit</Value>
</Value>
<Value name="8">
<Value>APIVersion</Value>
</Value>
</Data>
<DefaultData>GetNPIDataRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
