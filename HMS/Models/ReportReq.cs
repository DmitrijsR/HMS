using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HMS.Models
{
    public class ReportReq
    {
        public int Task_ID { get; set; }
        public Status Details { get; set; }
        public string comment { get; set; }
        public string attachment { get; set; }
        public string IsEmergency { get; set; }

        public class Status
        {
            public int Status_ID { get; set; }
        }
    }
}