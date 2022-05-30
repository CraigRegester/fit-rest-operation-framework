/// 
Class FITLIB.Rules.FITRestNpiDemo Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="FITLIB.REST.DemoProduction">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<comment text="Send a Ens.StringRequest using the Production Test Framework to the Business Process associated with this rule set... then look at the Message Trace!"></comment>
<rule name="FIT REST NPI Demo">
<when condition="1">
<send transform="FITLIB.DTL.FITRestNpiDemo" target="Utils.Trace.Operation"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
