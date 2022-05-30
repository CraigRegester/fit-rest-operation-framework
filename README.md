# FIT REST Operation Framework for InterSystems IRIS Interoperability

This repository is used to demostrate the capabilities of the Fantastic IRIS Toolbox (FIT) REST Operation Framework, an extension for the InterSystems IRIS Interoperability module.

This framework is intended primarily for use inside an Interoperability Production of the IRIS, IRIS for Health or HealthShare/Health Connect platforms.

**Note**: *Apologies for the rough nature of this documentation, I will attempt to add more as the voting period begins. I was not able to compile this sample repository until a couple hours prior to the deadline. -Craig*

## Background

Written in my spare time outside normal day-to-day business as a means to help me rapidly on-board new team members and reduce complexity as we find more and more vendors are asking us to integrate using their custom JSON REST APIs. With this framework, I have integrated solutions that take HL7 v2, map them using standard Interoperability DTLs to a custom Message Class that extends %JSON.Adaptor, and reap the benefits of reducing complex custom Operations to handle a myriad of situations (client-credential OAuth 2.0 Clients, custom outbound header tokens, Basic Auth headers, etc.).

## Introduction

Utilizing the standard EnsLib.HTTP.OutboundAdapter, this Busines Operation component is intended to be extended by custom vendor-specific REST Operation classes created by you and/or your organization to serve Interoperability workflows that engage outside vendors via REST API endpoints.

For example and demonstration, included in this package is a fully-working sample Operation for [NPPES NPI Registry](https://npiregistry.cms.hhs.gov/registry/help-api) - an open endpoint service provided by the United States Centers for Medicare & Medicaid Services government agency.

 While this extension is purposely derivative to a degree, as everything it does can be done with the tools provided by InterSystems Interoperability out of the box, its primary purpose is to drastically shortern the development timeframe for an Interopability team and create a common code base that ensures a consistent pattern is followed with each REST API Endpoint vendor configured - reducing code sprawl and drastic variation that makes it difficult for one engineer to support anothers' REST Operation.

 Furthermore, Interoperability Analysts at an organization now have the ability to see in the Interoperability Production UX almost the complete configuration for a REST API integration at a glance, no longer relying on their ability to find and read through custom-coded ObjectScript classes.

 Finally the FIT REST FunctionService and Trace Operation, included in this package as well, provide those same analysts (and engineers!) the valuable capability to see a FORMATTED representation of the JSON request and
 JSON response to/from the vendor's endpoint, drastically reducing the confusion caused by relying on the
 IRIS Interoperability Message Trace to only display the request in a XML encoded format.

 Example Method of a custom vendor-specific REST Operation class extending this class:

 ```objectscript
Method GetNPIData(pRequest As FITLIB.REST.NPPES.Msgs.GetNPIDataRequest, Output pResponse As FITLIB.REST.NPPES.Msgs.GetNPIDataResponse) As %Library.Status
{
    Set tSC = ..Initialize("GET",,.pRequest)
    Quit ..SubmitRequest(.pResponse)
}
```

## Key Features

- Utilizes built-in, InterSystems provided EnsLib.HTTP.OutboundAdapter
  - Handles exposing common HTTP request properties using standard Interoperability GUI-driven fields, similar to any other built-in Interoperability Operation.
  - i.e., this framework does not omit or subvert any proper InterSystems functionality
- On the contrary, it augments base functionality by providing low-level handling of HTTP Requests by adding GUI-driven fields for common REST API scenarios.
  - Multi-type Auth Method support
    - OAuth 2.0 Client (client-credentials) + audience (optional)
    - Bearer Tokens
    - Basic Authentication
    - Custom Authorization Header
  - Custom Outbound Headers (headerName:headerValue format, comma separated)
  - Accept non-standard HTTP Status Codes
    - e.g., Some vendors send an HTTP 422 for a patient ID they don't know but indicate it can be treated as a 'success'.
  - Custom REST Search Table to add non-standard JSON Fieldnames to a common index for key values (e.g., RESTPatientID)
- Augment standard tracing functionaity to give Interoperability analysts and engineers a method to see the literal URL string built up by URL Parameters as well as the JSON Formatted request body and response body, no longer relying on the XML view alone of the Message Object.

## How to Use

To get started, clone/git pull the repo into any local directory:

```git
git clone https://github.com/CraigRegester/fit-rest-operation-framework
```

Using VS Code w/ ObjectScript Extension or InterSystems Studio, import and compile the includes and classes into a sample namespace (USER is acceptable).

Open the [DemoProduction](https://github.com/CraigRegester/fit-rest-operation-framework/blob/main/src/cls/FITLIB/REST/DemoProduction.cls) in the Interoperability module under the namespace which you imported the code and utilizing the Test framework on the [REST.NPPES.Operation](https://github.com/CraigRegester/fit-rest-operation-framework/blob/main/src/cls/FITLIB/REST/NPPES/Operations.cls), search for a list of providers in Postal Code 02142.

View the Visual Trace created to see the results, including one of the key highlights of the framework: the ability to visualize the request and response in a formatted JSON trace directly within the Interoperability Message Trace!

Additionally, to see the included REST.FunctionService in action, view the sample [DTL](https://github.com/CraigRegester/fit-rest-operation-framework/blob/main/src/cls/FITLIB/DTL/FITRestNpiDemo.cls) and [Utils](https://github.com/CraigRegester/fit-rest-operation-framework/blob/main/src/cls/FITLIB/Utils/Interop.cls) class.

## Support and Guidance

Review the documentation included in-line on the classes within and the provided code examples (e.g., [/src/cls/FITLIB/REST/NPPES/Operations.cls](https://github.com/CraigRegester/fit-rest-operation-framework/blob/main/src/cls/FITLIB/REST/NPPES/Operations.cls)) and the sample Production ([/src/cls/FITLIB/REST/DemoProduction.cls](https://github.com/CraigRegester/fit-rest-operation-framework/blob/main/src/cls/FITLIB/REST/DemoProduction.cls)).
