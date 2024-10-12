bring cloud;

pub struct CronJobProps {
  name: str;
  schedule: str;
  state: str;
  description: str?;
  eventPattern: Json?;
}

pub struct CronRule {
  Name: str;
  ScheduleExpression: str;
  State: str;
  Description: str?;
  EventPattern: Json?;
}

pub interface ICronManager extends std.IResource {
  inflight createCronRule(rule: CronRule): str;
  inflight updateCronRule(rule: CronRule): str;
  inflight deleteCronRule(ruleName: str): void;
  inflight listCronRules(): Array<CronRule>;
}

pub interface ICronJob extends std.IResource {
  inflight createJob(name: str, cron: str, pkg: Json): str;
  inflight updateJob(name: str, cron: str?, pkg: Json?): str;
  inflight deleteJob(name: str): void;
  inflight listJobs(): Array<CronRule>;
}
