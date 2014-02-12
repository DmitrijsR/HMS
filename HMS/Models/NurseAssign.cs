using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HMS.Models
{
    public class NurseAssign
    {
        public Int32? TaskID { get; set; }
        public Int32? NurseID { get; set; }
        /*
        public NurseAssign()
        {
            this.TaskID = null;
            this.NurseID = null;
        }
        public NurseAssign(Int32? task, Int32? nurse)
        {
            this.TaskID = task;
            this.NurseID = nurse;
        }
         * */
    }
}