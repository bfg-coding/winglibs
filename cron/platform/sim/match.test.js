const { matchesCronRule } = require('./match');

const tests = [
  {
    name: "Basic cron schedule match",
    event: { 
      "time": "2023-06-01T12:00:00Z",
      "detail-type": "Scheduled Event",
      "source": "aws.events"
    },
    rule: { 
      Name: "DailyJob",
      ScheduleExpression: "cron(0 12 * * ? *)"
    },
    expected: true
  },
  {
    name: "Event pattern match",
    event: { 
      "time": "2023-06-01T12:00:00Z",
      "detail-type": "EC2 Instance State-change Notification",
      "source": "aws.ec2",
      "detail": { "state": "running" }
    },
    rule: { 
      Name: "EC2StateChange",
      ScheduleExpression: "rate(5 minutes)",
      EventPattern: {
        "source": ["aws.ec2"],
        "detail-type": ["EC2 Instance State-change Notification"],
        "detail": { "state": ["running", "stopped"] }
      }
    },
    expected: true
  },
  {
    name: "Event pattern mismatch",
    event: { 
      "time": "2023-06-01T12:00:00Z",
      "detail-type": "EC2 Instance State-change Notification",
      "source": "aws.ec2",
      "detail": { "state": "terminated" }
    },
    rule: { 
      Name: "EC2StateChange",
      ScheduleExpression: "rate(5 minutes)",
      EventPattern: {
        "source": ["aws.ec2"],
        "detail-type": ["EC2 Instance State-change Notification"],
        "detail": { "state": ["running", "stopped"] }
      }
    },
    expected: false
  },
  {
    name: "Cron job with no event pattern",
    event: { 
      "time": "2023-06-01T00:00:00Z",
      "detail-type": "Scheduled Event",
      "source": "aws.events"
    },
    rule: { 
      Name: "DailyBackup",
      ScheduleExpression: "cron(0 0 * * ? *)"
    },
    expected: true
  }
];

tests.forEach((test, index) => {
  const result = matchesCronRule(test.event, test.rule);
  console.log(`Test ${index + 1} (${test.name}):`, result === test.expected ? 'Pass' : 'Fail');
  if (result !== test.expected) {
    console.log('  Expected:', test.expected);
    console.log('  Got:', result);
  }
});