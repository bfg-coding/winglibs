const { EventBridgeClient, PutRuleCommand, DeleteRuleCommand, ListRulesCommand } = require("@aws-sdk/client-eventbridge");

const client = new EventBridgeClient();

const _getCronRule = async (ruleName) => {
  const command = new ListRulesCommand({});
  const response = await client.send(command);
  return response.Rules.find(rule => rule.Name === ruleName);
}

const _createCronRule = async (rule) => {
  console.log(`Creating cron rule: ${JSON.stringify(rule)}`);
  const command = new PutRuleCommand({
    Name: rule.Name,
    ScheduleExpression: rule.ScheduleExpression,
    State: rule.State,
    Description: rule.Description,
    EventPattern: rule.EventPattern ? JSON.stringify(rule.EventPattern) : undefined,
  });
  const response = await client.send(command);
  return response.RuleArn;
}

const _updateCronRule = async (rule) => {
  console.log(`Updating cron rule: ${JSON.stringify(rule)}`);
  const command = new PutRuleCommand({
    Name: rule.Name,
    ScheduleExpression: rule.ScheduleExpression,
    State: rule.State,
    Description: rule.Description,
    EventPattern: rule.EventPattern ? JSON.stringify(rule.EventPattern) : undefined,
  });
  const response = await client.send(command);
  return response.RuleArn;
}

const _deleteCronRule = async (ruleName) => {
  console.log(`Deleting cron rule: ${ruleName}`);
  const command = new DeleteRuleCommand({
    Name: ruleName,
    Force: true, // Set to true if you want to delete the rule even if it's associated with targets
  });
  await client.send(command);
}

const _listCronRules = async () => {
  const command = new ListRulesCommand({});
  const response = await client.send(command);
  return response.Rules.map(rule => ({
    Name: rule.Name,
    ScheduleExpression: rule.ScheduleExpression,
    State: rule.State,
    Description: rule.Description,
    EventPattern: rule.EventPattern ? JSON.parse(rule.EventPattern) : undefined,
  }));
}

module.exports = {
  _getCronRule,
  _createCronRule,
  _updateCronRule,
  _deleteCronRule,
  _listCronRules
}