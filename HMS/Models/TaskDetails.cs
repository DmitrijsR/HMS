using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HMS.Models
{
    public class TaskDetails
    {
        public TaskDetailItem Details { get; set; }
        public Dictionary<string, string> Dictionary { get; set; }
        public IEnumerable<SelectListItem> StatusTypes { get; set; }
        public IEnumerable<SelectListItem> PriorityTypes { get; set; }
        public IEnumerable<ReportItem> CommentsNotifications { get; set; }

        public class TaskDetailItem
        {
            public int? ID { get; set; }
            public String Title { get; set; }
            public String Patient_Name { get; set; }
            public String Patient_Surname { get; set; }
            public String Patient_SocialNr { get; set; }
            public String Patient_Department { get; set; }
            public String Priority { get; set; }
            public String Instructions { get; set; }
            public int? Status_ID { get; set; }
            public String Status { get; set; }
            public int? Creator_ID { get; set; }
            public DateTime? TimeCreated { get; set; }
            public DateTime? TimeUpdated { get; set; }
            public String Responsible_Name { get; set; }
            public String Responsible_Surname { get; set; }
            public String Responsible_Department { get; set; }
        }
        
        public class ReportItem
        {
            public int? id { get; set; }
            public String Text { get; set; }
        }
    }
}