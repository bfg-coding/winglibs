bring cloud;
bring aws;
bring "./platform/aws/publish.w" as cron;

pub class CronJob {
  lambdaArn: str;

  new(lambdaArn: str) {
    this.lambdaArn = lambdaArn;
  }

  pub inflight createJob(name: str, cronExpression: str, pkg: Json): str {
    let rule = cron.CronRule {
      Name: name,
      ScheduleExpression: cronExpression,
      State: "ENABLED",
      Description: "Created by Wing CronJob",
      EventPattern: Json {
        "detail": pkg
      }
    };

    let ruleArn = cron.CronManager.createCronRule(rule);
    
    // TODO: Add logic to set the Lambda function as the target for this rule
    // This would typically involve using the AWS SDK to call PutTargets

    log("Created job: {name} with ARN: {ruleArn}");
    return ruleArn;
  }

  pub inflight updateJob(name: str, cronExpression: str?, pkg: Json?): str {
    let existingRules = cron.CronManager.getCronRule(name);

    if existingRules == nil {
      throw "Job {name} not found";
    }

    let updatedRule = cron.CronRule {
      Name: name,
      ScheduleExpression: cronExpression ?? existingRule.ScheduleExpression,
      State: existingRule.State,
      Description: existingRule.Description ?? "Updated",
      EventPattern: CronJob.setEventPattern(existingRule.EventPattern, pkg)
    };

    let ruleArn = cron.CronManager.updateCronRule(updatedRule);
    
    // TODO: Update the target if necessary

    log("Updated job: {name} with ARN: {ruleArn}");
    return ruleArn;
  }

  pub inflight deleteJob(name: str): void {
    cron.CronManager.deleteCronRule(name);
    
    // TODO: Remove the target associated with this rule

    log("Deleted job: {name}");
  }

  pub inflight listJobs(): Array<cron.CronRule> {
    return cron.CronManager.listCronRules();
  }

  static inflight setEventPattern(pattern: Json, pkg: Json?): Json {
    if let pkg = pkg {
      return Json { "detail": pkg };
    } else {
      return pattern;
    }
  }
}