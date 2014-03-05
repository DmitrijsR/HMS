using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HMS.Models
{
    public class Notifications
    {
        public IEnumerable<NotifItem> Items { get; set; }
        public Dictionary<string, string> Dictionary { get; set; }

        public class NotifItem
        {
            public int? id { get; set; }
            public String Notification { get; set; }
        }
    }
}