using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HMS.Models
{
    public class TaskAssignment
    {
        public IEnumerable<Nurse> NurseList { get; set; }
        public Int32? ResponsiblePrev { get; set; }
        public Int32? ResponsibleCurrent { get; set; }
        public Int32? TaskID { get; set; }
        public Dictionary<string, string> Dictionary { get; set; }

        public class Nurse
        {
            public int? ID { get; set; }         
            public String Nurse_Name { get; set; }
            public String Nurse_Surname { get; set; }
            public Int32? All_Tasks { get; set; }
            public Int32? Active_Tasks { get; set; }         
            public bool? IsResponsible { get; set; }
        }

    }
}