Class FITLIB.REST.DemoProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="FITLIB.REST.DemoProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description>Sample Production demoing the FIT REST Operation Framework</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="REST.FunctionService" Category="zSystem Components,Web Services" ClassName="FITLIB.REST.FunctionService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Utils.Trace.Operation" Category="zSystem Components,Web Services" ClassName="FITLIB.Utils.Trace.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="REST.NPPES.Operations" Category="Web Services" ClassName="FITLIB.REST.NPPES.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TraceOperations">Full</Setting>
    <Setting Target="Adapter" Name="HTTPPort">443</Setting>
    <Setting Target="Adapter" Name="HTTPServer">npiregistry.cms.hhs.gov</Setting>
    <Setting Target="Adapter" Name="SSLConfig">DefaultSSLClient</Setting>
    <Setting Target="Adapter" Name="URL">/api</Setting>
  </Item>
  <Item Name="FITRestNpiDemo" Category="Web Services" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">FITLIB.Rules.FITRestNpiDemo</Setting>
  </Item>
</Production>
}

}
