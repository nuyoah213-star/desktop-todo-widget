/**
 * Shared core logic for todo.hta and todo.html.
 * Uses ES5 syntax for IE11 (HTA) compatibility.
 */
var TC = {};

TC.PRI_LABELS = { high: '高', medium: '中', low: '低' };

TC.uid = function() {
  return Date.now().toString(36) + Math.random().toString(36).slice(2, 7);
};

TC.esc = function(s) {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
};

// IE-safe date parsing (ISO 8601 yyyy-mm-dd not supported in IE)
TC.parseDate = function(dateStr) {
  if (!dateStr) return null;
  var parts = dateStr.split('-');
  return new Date(+parts[0], +parts[1] - 1, +parts[2]);
};

TC.dueInfo = function(dateStr, todayMs) {
  if (!dateStr) return null;
  var d = TC.parseDate(dateStr);
  if (!d || isNaN(d.getTime())) return null;
  var diff = d.getTime() - todayMs;
  var dd = Math.round(diff / 86400000);
  var label;
  if (dd === 0) label = '今天';
  else if (dd === 1) label = '明天';
  else if (dd === -1) label = '昨天';
  else label = (d.getMonth() + 1) + '月' + d.getDate() + '日';
  return { label: label, cls: dd < 0 ? 'overdue' : (dd === 0 ? 'today' : '') };
};

TC.filterTodos = function(todos, filter, searchQ) {
  var list = todos.slice();
  if (filter === 'active')    list = list.filter(function(t) { return !t.completed; });
  if (filter === 'completed') list = list.filter(function(t) { return t.completed; });
  if (searchQ) {
    var q = searchQ.toLowerCase();
    list = list.filter(function(t) { return t.title.toLowerCase().indexOf(q) !== -1; });
  }
  return list;
};

// Cached todayMs — recalculates only when date changes
TC._todayMsCache = 0;
TC._todayDateKey = '';
TC.getTodayMs = function() {
  var now = new Date();
  var key = now.getFullYear() + '-' + (now.getMonth() + 1) + '-' + now.getDate();
  if (key !== TC._todayDateKey) {
    TC._todayDateKey = key;
    TC._todayMsCache = now.setHours(0, 0, 0, 0);
  }
  return TC._todayMsCache;
};
