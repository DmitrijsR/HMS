using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HMS.Models
{
    public class TaskFilters
    {
        public IEnumerable<FilteredTaskItem> Tasks { get; set; }
        public IEnumerable<FilteredTaskType> TaskTypes { get; set; }
        public IEnumerable<SelectListItem> StatusTypes { get; set; }
        public IEnumerable<SelectListItem> Patients { get; set; }
        public IEnumerable<SelectListItem> AllPatients { get; set; }
        public IEnumerable<SelectListItem> PriorityTypes { get; set; }
        public IEnumerable<SelectListItem> Responsibles { get; set; }
        public DateTime From { get; set; }
        public DateTime Till { get; set; }
        public Dictionary<string, string> Dictionary { get; set; }

        // Sorting-related properties
        public string SortBy { get; set; }
        public bool SortAscending { get; set; }
        public string SortExpression
        {
            get
            {
                return this.SortAscending ? this.SortBy + " asc" : this.SortBy + " desc";
            }
        }

        public class FilteredTaskType
        {
            public int? id { get; set; }
            public String Text { get; set; }
            private Boolean hasInstr;
            public object HasInstr
            {
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
        public class FilteredTaskItem
        {
            public int? ID { get; set; }
            public String Title { get; set; }
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
        public class Nurse
        {
            public int? ID { get; set; }
            public String Name { get; set; }
            public String Surname { get; set; }
            public String Department { get; set; }
        }
    }
}