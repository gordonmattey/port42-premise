// Fixed generateCommandName function for install-v0.2.sh

generateCommandName(input) {
  const lower = input.toLowerCase();
  
  // First, try to extract explicit command name from patterns like:
  // "create a command called 'echo-nicer'"
  // "make a command named 'git-stats'"
  // "build something called my-tool"
  
  const namedPatterns = [
    /(?:create|make|build).*?(?:called|named)\s+['"`]?([a-z0-9-_]+)['"`]?/i,
    /(?:called|named)\s+['"`]?([a-z0-9-_]+)['"`]?/i,
    /['"`]([a-z0-9-_]+)['"`]/i  // Any quoted name
  ];
  
  for (const pattern of namedPatterns) {
    const match = input.match(pattern);
    if (match && match[1]) {
      console.log(`🎯 Extracted command name: ${match[1]}`);
      return match[1];
    }
  }
  
  // Legacy hardcoded patterns
  if (lower.includes('git') && lower.includes('haiku')) return 'git-haiku';
  if (lower.includes('todo')) return 'find-todos';
  if (lower.includes('pretty')) return 'prettify';
  if (lower.includes('week')) return 'week-summary';
  if (lower.includes('color')) return 'colorize';
  if (lower.includes('count') && lower.includes('lines')) return 'count-lines';
  
  // Generate from key words as fallback
  const words = lower
    .replace(/[^a-z0-9 ]/g, '')
    .split(' ')
    .filter(w => w.length > 2 && !['the', 'and', 'for', 'that', 'this', 'with', 'create', 'make', 'command', 'called', 'named'].includes(w))
    .slice(0, 2);
  
  if (words.length > 0) {
    return words.join('-');
  }
  
  return `cmd-${Date.now().toString(36)}`;
}