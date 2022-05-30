Class FITLIB.REST.NPPES.dt.Basic Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property Credential As %String(%JSONFIELDNAME = "credential", MAXLEN = "");

Property CertificationDate As %String(%JSONFIELDNAME = "certification_date", MAXLEN = "");

Property EnumerationDate As %String(%JSONFIELDNAME = "enumeration_date", MAXLEN = "");

Property DisplayName As %String(%JSONFIELDNAME = "name", MAXLEN = "");

Property NameFirst As %String(%JSONFIELDNAME = "first_name", MAXLEN = "");

Property NameMiddle As %String(%JSONFIELDNAME = "middle_name", MAXLEN = "");

Property NameLast As %String(%JSONFIELDNAME = "last_name", MAXLEN = "");

Property NamePrefix As %String(%JSONFIELDNAME = "name_prefix", MAXLEN = "");

Property Gender As %String(%JSONFIELDNAME = "gender", MAXLEN = "");

Property isSoleProprietor As %String(%JSONFIELDNAME = "sole_proprietor", MAXLEN = "");

Property Status As %String(%JSONFIELDNAME = "status", MAXLEN = "");

Property Created As %String(%JSONFIELDNAME = "enumeration_date", MAXLEN = "");

Property Updated As %String(%JSONFIELDNAME = "last_updated", MAXLEN = "");

Property OrganizationName As %String(%JSONFIELDNAME = "organization_name", MAXLEN = "");

Property OrganizationalSubpart As %String(%JSONFIELDNAME = "organizational_subpart", MAXLEN = "");

Property ParentOrganizationEIN As %String(%JSONFIELDNAME = "parent_organization_ein", MAXLEN = "");

Property ParentOrganizationLegalBusinessName As %String(%JSONFIELDNAME = "parent_organization_legal_business_name", MAXLEN = "");

Property AuthorizedOfficialNamePrefix As %String(%JSONFIELDNAME = "authorized_official_name_prefix", MAXLEN = "");

Property AuthorizedOfficialFirstName As %String(%JSONFIELDNAME = "authorized_official_first_name", MAXLEN = "");

Property AuthorizedOfficialMiddleName As %String(%JSONFIELDNAME = "authorized_official_middle_name", MAXLEN = "");

Property AuthorizedOfficialLastName As %String(%JSONFIELDNAME = "authorized_official_last_name", MAXLEN = "");

Property AuthorizedOfficialCredential As %String(%JSONFIELDNAME = "authorized_official_credential", MAXLEN = "");

Property AuthorizedOfficialPosition As %String(%JSONFIELDNAME = "authorized_official_title_or_position", MAXLEN = "");

Property AuthorizedOfficialTelephone As %String(%JSONFIELDNAME = "authorized_official_telephone_number", MAXLEN = "");

Storage Default
{
<Data name="BasicState">
<Value name="1">
<Value>Credential</Value>
</Value>
<Value name="2">
<Value>CertificationDate</Value>
</Value>
<Value name="3">
<Value>EnumerationDate</Value>
</Value>
<Value name="4">
<Value>DisplayName</Value>
</Value>
<Value name="5">
<Value>NameFirst</Value>
</Value>
<Value name="6">
<Value>NameMiddle</Value>
</Value>
<Value name="7">
<Value>NameLast</Value>
</Value>
<Value name="8">
<Value>NamePrefix</Value>
</Value>
<Value name="9">
<Value>Gender</Value>
</Value>
<Value name="10">
<Value>isSoleProprietor</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>Created</Value>
</Value>
<Value name="13">
<Value>Updated</Value>
</Value>
<Value name="14">
<Value>OrganizationName</Value>
</Value>
<Value name="15">
<Value>OrganizationalSubpart</Value>
</Value>
<Value name="16">
<Value>ParentOrganizationEIN</Value>
</Value>
<Value name="17">
<Value>ParentOrganizationLegalBusinessName</Value>
</Value>
<Value name="18">
<Value>AuthorizedOfficialFirstName</Value>
</Value>
<Value name="19">
<Value>AuthorizedOfficialLastName</Value>
</Value>
<Value name="20">
<Value>AuthorizedOfficialTelephone</Value>
</Value>
<Value name="21">
<Value>AuthorizedOfficialPosition</Value>
</Value>
<Value name="22">
<Value>AuthorizedOfficialNamePrefix</Value>
</Value>
<Value name="23">
<Value>AuthorizedOfficialMiddleName</Value>
</Value>
<Value name="24">
<Value>AuthorizedOfficialCredential</Value>
</Value>
</Data>
<State>BasicState</State>
<StreamLocation>^FITLIB.REST.NPPES.dt.BasicS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
