using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HMS.Models
{
    public class ToDoList
    {
        public int PatientID { get; set; }
        public IEnumerable<TaskItem> Tasks { get; set; }
        public IEnumerable<TaskType> TaskTypes { get; set; }
        public IEnumerable<SelectListItem> Patients { get; set; }
        public IEnumerable<SelectListItem> PriorityTypes { get; set; }
        public IEnumerable<SelectListItem> NotificationTypes { get; set; }
        public Dictionary<string, string> Dictionary { get; set; }

        public class TaskType
        {
            public int? id { get; set; }
            public String Text { get; set; }
            private Boolean hasInstr;
            public object HasInstr {
                get { return this.hasInstr; } 
                set 
                {
                    if (value.GetType() == typeof(string) && value.Equals("1"))
                        this.hasInstr = true;
                    else
                        this.hasInstr = false;
                }
            }
        }
        public class TaskItem
        {
            public Int16 TaskID { get; set; }
            public String Value { get; set; }
            public Int16 Importance { get; set; }
            public Int16 NotificationType { get; set; }
        }
    }
}