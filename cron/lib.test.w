bring expect;
bring cloud;
bring "./lib.w" as lib;

// Mock Lambda function for testing
let mockLambda = new cloud.Function(inflight () => { return "Hello from mock Lambda"; }) as "MockLambda";

let cronJob = new lib.CronJob(mockLambda.arn);

test "CronJob.createJob creates a new job" {
  let jobName = "TestJob";
  let cronExpression = "cron(0 12 * * ? *)";
  let jobDetails = Json { "key": "value" };
  
  let ruleArn = cronJob.createJob(jobName, cronExpression, jobDetails);
  expect.notNil(ruleArn);
  expect.match(ruleArn, jobName);
}

test "CronJob.listJobs returns created jobs" {
  let jobs = cronJob.listJobs();
  expect.equal(jobs.length, 1);
  expect.equal(jobs[0].Name, "TestJob");
  expect.equal(jobs[0].ScheduleExpression, "cron(0 12 * * ? *)");
}

test "CronJob.updateJob updates an existing job" {
  let jobName = "TestJob";
  let newCronExpression = "cron(0 0 * * ? *)";
  let newJobDetails = Json { "key": "new value" };
  
  let updatedRuleArn = cronJob.updateJob(jobName, newCronExpression, newJobDetails);
  expect.notNil(updatedRuleArn);
  expect.match(updatedRuleArn, jobName);

  let jobs = cronJob.listJobs();
  expect.equal(jobs[0].ScheduleExpression, newCronExpression);
}

test "CronJob.deleteJob removes a job" {
  let jobName = "TestJob";
  cronJob.deleteJob(jobName);
  
  let jobs = cronJob.listJobs();
  expect.equal(jobs.length, 0);
}

test "CronJob.updateJob throws error for non-existent job" {
  try {
    cronJob.updateJob("NonExistentJob", "cron(0 0 * * ? *)", Json { "key": "value" });
    expect.fail("Expected an error to be thrown");
  } catch e {
    expect.equal(e, "Job NonExistentJob not found");
  }
}