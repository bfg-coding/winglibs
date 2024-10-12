export default interface extern {
  matchesCronRule: (event: Readonly<CronEvent>, rule: Readonly<CronRule>) => Promise<boolean>,
}

interface CronEvent {
  time: string;
  'detail-type': string;
  source: string;
  detail?: any;
  [key: string]: any;
}

interface CronRule {
  Name: string;
  ScheduleExpression: string;
  EventPattern?: {
    [key: string]: any;
  };
}