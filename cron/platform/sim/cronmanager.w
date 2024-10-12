bring cloud;
bring "./../../types.w" as types;
bring "./bus.w" as bus;

pub class CronManager impl types.ICronManager {
  bus: bus.EventBridgeBus;

  new() {
    this.bus = new bus.EventBridgeBus();
  }

  pub inflight createCronRule(rule: types.CronRule): str {
    return this.bus.createRule(rule);
  }

  pub inflight updateCronRule(rule: types.CronRule): str {
    return this.bus.updateRule(rule);
  }

  pub inflight deleteCronRule(ruleName: str): void {
    this.bus.deleteRule(ruleName);
  }

  pub inflight listCronRules(): Array<types.CronRule> {
    return this.bus.listRules();
  }
}

pub class CronJob impl types.ICronJob {
  cronManager: CronManager;
  lambdaArn: str;

  new(lambdaArn: str) {
    this.cronManager = new CronManager();
    this.lambdaArn = lambdaArn;
  }

  pub inflight createJob(name: str, cron: str, pkg: Json): str {
    let rule = types.CronRule {
      Name: name,
      ScheduleExpression: cron,
      State: "ENABLED",
      Description: "Created by Wing CronJob",
      EventPattern: Json {
        "detail": pkg
      }
    };
    return this.cronManager.createCronRule(rule);
  }

  pub inflight updateJob(name: str, cron: str?, pkg: Json?): str {
    let existingRules = this.cronManager.listCronRules();
    let existingRule = existingRules.find(r => r.Name == name);
    
    if existingRule == nil {
      throw "Job {name} not found";
    }

    let updatedRule = types.CronRule {
      Name: name,
      ScheduleExpression: cron ?? existingRule.ScheduleExpression,
      State: existingRule.State,
      Description: existingRule.Description,
      EventPattern: pkg != nil ? Json { "detail": pkg } : existingRule.EventPattern
    };

    return this.cronManager.updateCronRule(updatedRule);
  }

  pub inflight deleteJob(name: str): void {
    this.cronManager.deleteCronRule(name);
  }

  pub inflight listJobs(): Array<types.CronRule> {
    return this.cronManager.listCronRules();
  }
}