function matchesCronRule(event, rule) {
    console.log("Matching event:", event, "against rule:", rule);
  
    // Check if the event time matches the cron schedule
    if (!matchesCronSchedule(event.time, rule.ScheduleExpression)) {
      return false;
    }
  
    // If there's an EventPattern, check if it matches
    if (rule.EventPattern) {
      return matchesEventPattern(event, rule.EventPattern);
    }
  
    // If there's no EventPattern, the schedule match is sufficient
    return true;
  }
  
  function matchesCronSchedule(eventTime, scheduleExpression) {
    // This is a simplified check. In a real implementation, you'd want to properly
    // parse the cron expression and check it against the event time.
    console.log("Checking if", eventTime, "matches schedule", scheduleExpression);
    
    // For simulation purposes, always return true
    // In a real implementation, you'd return the result of the cron expression evaluation
    return true;
  }
  
  function matchesEventPattern(event, pattern) {
    for (let key in pattern) {
      if (!event.hasOwnProperty(key)) {
        return false;
      }
  
      if (typeof pattern[key] === 'object' && !Array.isArray(pattern[key])) {
        if (!matchesEventPattern(event[key], pattern[key])) {
          return false;
        }
      } else if (Array.isArray(pattern[key])) {
        if (!pattern[key].includes(event[key])) {
          return false;
        }
      } else if (event[key] !== pattern[key]) {
        return false;
      }
    }
    return true;
  }
  
  module.exports = {
    matchesCronRule
  }