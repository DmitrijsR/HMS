using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HMS.Models
{
    public class ViewTasksList
    {
        public IEnumerable<TaskItem> Tasks { get; set; }
        public Dictionary<string, string> Dictionary { get; set; }

        public class TaskItem
        {
            public int? ID	{ get; set; }
	        public String Title	{ get; set; }
	        public String Patient_Name { get; set; }
	        public String Patient_Surname { get; set; }
	        public String Patient_Department { get; set; }
	        public String Priority { get; set; }
	        public String Instructions { get; set; }
	        public String Status { get; set; }
	        public String Creator_Name { get; set; }
	        public String Creator_Surname { get; set; }
	        public String Creator_Department { get; set; }
            public DateTime? TimeCreated { get; set; }
            public DateTime? TimeUpdated { get; set; }
	        public String Responsible_Name { get; set; }
	        public String Responsible_Surname { get; set; }
	        public String Responsible_Department { get; set; }
            public bool? Deletable { get; set; }
        }
    }
}