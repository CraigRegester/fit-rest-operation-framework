Class FITLIB.DTL.FITRestNpiDemo Extends Ens.DataTransformDTL [ DependsOn = (Ens.StringRequest, Ens.StringResponse) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Ens.StringRequest' targetClass='Ens.StringResponse' create='new' language='objectscript' >
<annotation>Demonstrate FIT REST FunctionService Capability</annotation>
<comment>
<annotation>Demo derived from
https://npiregistry.cms.hhs.gov/registry/API-Examples</annotation>
</comment>
<assign value='441304824' property='pLocationZipCode' action='set' />
<assign value='"JOHN"' property='pProviderFirstName' action='set' />
<assign value='"SMITH"' property='pProviderLastName' action='set' />
<assign value='##class(FITLIB.Utils.Interop).GetProviderNPI(pProviderLastName,pProviderFirstName,pLocationZipCode)' property='npiNumber' action='set' />
<assign value='npiNumber' property='target.StringValue' action='set' />
</transform>
}

}
