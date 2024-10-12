export default interface extern {
  _getCronRule: (ruleName: string) => Promise<CronRule | undefined>,
  _createCronRule: (rule: CronRule) => Promise<string>;
  _updateCronRule: (rule: CronRule) => Promise<string>;
  _deleteCronRule: (ruleName: string) => Promise<void>;
  _listCronRules: () => Promise<CronRule[]>;
}

export interface CronRule {
  Name: string;
  ScheduleExpression: string;
  State: string;
  Description?: string;
  EventPattern?: any; // Using 'any' for JSON, but you could define a more specific type if needed
}