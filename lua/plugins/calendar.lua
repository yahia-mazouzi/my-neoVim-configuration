return {
  "mattn/calendar-vim",
  cmd = { "Calendar", "CalendarVR", "CalendarH", "CalendarT" },
  config = function()
    vim.g.calendar_google_calendar = 1
    vim.g.calendar_google_task = 1
  end,
}