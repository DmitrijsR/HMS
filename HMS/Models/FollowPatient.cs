using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HMS.Models
{
    public class FollowPatient
    {
        public IEnumerable<SelectListItem> Patients { get; set; }
        public IEnumerable<FPatient> PrevFollowedPatients { get; set; }
        public IEnumerable<FPatient> CurrFollowedPatients { get; set; }
        public Dictionary<string, string> Dictionary { get; set; }

        public class FPatient
        {
            public int? ID { get; set; }
            public string Name { get; set; }
        }
    }
}