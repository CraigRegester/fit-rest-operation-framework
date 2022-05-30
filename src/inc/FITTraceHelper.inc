ROUTINE FITTraceHelper [Type=INC]
#def1Arg FITTRACE(%args) DO:(##this.TraceOperations'=""&&(##this.TraceOperations'="Errors Only")&&(##this.TraceOperations'="Minimal")) ##this.FITTrace($$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg FITTRACEMIN(%args) DO:(##this.TraceOperations'=""&&(##this.TraceOperations'="Errors Only")) ##this.FITTrace($$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg FITTRACEERROR(%args) DO:##this.TraceOperations'="" ##this.FITTrace($$$CurrentClass,$$$CurrentMethod,%args)
#define FITTRACING ##this.TraceOperations'=""
#def1Arg FITTRACEHOST(%args) DO $zobjmethod(%FITTraceHost,"FITTrace",$$$CurrentClass,$$$CurrentMethod,%args)
#define FITTRACEHOSTSTART(%host) Set %FITTraceHost=%host
#def1Arg FITTRACECALLED(%args) DO:($D(%FITTraceHost)&&(%FITTraceHost.TraceOperations'="")&&(%FITTraceHost.TraceOperations'="Errors Only")&&(%FITTraceHost.TraceOperations'="Minimal")) $zobjmethod(%FITTraceHost,"FITTrace",$$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg FITTRACECALLEDMIN(%args) DO:($D(%FITTraceHost)&&(%FITTraceHost.TraceOperations'="")&&(%FITTraceHost.TraceOperations'="Errors Only")) $zobjmethod(%FITTraceHost,"FITTrace",$$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg FITTRACECALLEDERROR(%args) DO:($D(%FITTraceHost)&&(%FITTraceHost.TraceOperations'="")) $zobjmethod(%FITTraceHost,"FITTrace",$$$CurrentClass,$$$CurrentMethod,%args)
#define FITTRACINGCALLED $D(%FITTraceHost)
#define FITTRACESTARTCALL Set:##this.TraceOperations'="" %FITTraceHost=##This
#define FITTRACEENDCALL Kill %FITTraceHost

#define FITTraceServiceName "Utils.Trace.Service"
#define FITTraceServiceClass "FITLIB.Utils.Trace.Service"
#define FITTraceOperationName "Utils.Trace.Operation"

#define FITTraceConfigName ^IRIS.Temp.FIT.Trace.Level($namespace,"config")
#define FITTraceLevel ^IRIS.Temp.FIT.Trace.Level($namespace)
#define FITTraceLevelGET $Get($$$FITTraceLevel)

#def1Arg FITTraceInvoke(%args)  ##class($$$FITTraceServiceClass).Trace(%args)
#def1Arg FITTraceFull(%args) DO:$$$FITTraceIsFull $$$FITTraceInvoke($$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg FITTraceMin(%args) DO:$$$FITTraceIsMin $$$FITTraceInvoke($$$CurrentClass,$$$CurrentMethod,%args)
#def1Arg FITTraceError(%args) DO:$$$FITTraceIsError $$$FITTraceInvoke($$$CurrentClass,$$$CurrentMethod,%args)
#define FITTraceIsActive $$$FITTraceLevelGET
#define FITTraceIsError ($$$FITTraceLevelGET >= 1)
#define FITTraceIsMin ($$$FITTraceLevelGET >=2)
#define FITTraceIsFull ($$$FITTraceLevelGET >= 3)
