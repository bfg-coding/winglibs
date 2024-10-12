bring cloud;

pub struct CronRule {
  Name: str;
  ScheduleExpression: str;
  State: str;
  Description: str?;
  EventPattern: Json?;
}

pub class CronManager {
  pub static inflight createCronRule(rule: CronRule): str {
    return CronManager._createCronRule(rule);
  }

  pub static inflight updateCronRule(rule: CronRule): str {
    return CronManager._updateCronRule(rule);
  }

  pub static inflight deleteCronRule(ruleName: str): void {
    CronManager._deleteCronRule(ruleName);
  }

  pub static inflight getCronRule(ruleName: str): CronRule? {
    return CronManager._getCronRule(ruleName);
  }
 
  pub static inflight listCronRules(): Array<CronRule> {
    return CronManager._listCronRules();
  }

  extern "./publish.js" static inflight _createCronRule(rule: CronRule): str;
  extern "./publish.js" static inflight _updateCronRule(rule: CronRule): str;
  extern "./publish.js" static inflight _deleteCronRule(ruleName: str): void;
  extern "./publish.js" static inflight _getCronRule(ruleName: str): CronRule?;
  extern "./publish.js" static inflight _listCronRules(): Array<CronRule>;
}