bring cloud;
bring util;
bring "./../../types.w" as types;

pub class EventBridgeBus {
  extern "./match.js" inflight static matchesPattern(obj: Json, pattern: Json): bool;
  topic: cloud.Topic;
  rules: MutArray<types.CronRule>;

  new() {
    this.topic = new cloud.Topic() as "EventBridge";
    this.rules = MutArray<types.CronRule>[];
  }

  pub inflight createRule(rule: types.CronRule): str {
    this.rules.push(rule);
    let ruleArn = "arn:aws:events:us-east-1:123456789012:rule/{rule.Name}";
    log("EventBridge: created rule: {rule.Name}");
    return ruleArn;
  }

  pub inflight updateRule(rule: types.CronRule): str {
    let index = this.rules.findIndex(r => r.Name == rule.Name);
    if (index >= 0) {
      this.rules.setAt(index, rule);
      log("EventBridge: updated rule: {rule.Name}");
    } else {
      log("EventBridge: rule not found, creating new: {rule.Name}");
      this.rules.push(rule);
    }
    let ruleArn = "arn:aws:events:us-east-1:123456789012:rule/{rule.Name}";
    return ruleArn;
  }

  pub inflight deleteRule(ruleName: str): void {
    let index = this.rules.findIndex(r => r.Name == ruleName);
    if (index >= 0) {
      this.rules.removeAt(index);
      log("EventBridge: deleted rule: {ruleName}");
    } else {
      log("EventBridge: rule not found for deletion: {ruleName}");
    }
  }

  pub inflight listRules(): Array<types.CronRule> {
    return this.rules.copy();
  }
}