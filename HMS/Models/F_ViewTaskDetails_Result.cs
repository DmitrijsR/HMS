//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HMS.Models
{
    using System;
    
    public partial class F_ViewTaskDetails_Result
    {
        public Nullable<int> ID { get; set; }
        public string Title { get; set; }
        public string Patient_Name { get; set; }
        public string Patient_Surname { get; set; }
        public string Patient_SocialNr { get; set; }
        public string Patient_Department { get; set; }
        public string Priority { get; set; }
        public string Instructions { get; set; }
        public Nullable<int> Status_ID { get; set; }
        public string Status { get; set; }
        public Nullable<int> Creator_ID { get; set; }
        public Nullable<System.DateTime> TimeCreated { get; set; }
        public Nullable<System.DateTime> TimeUpdated { get; set; }
        public string Responsible_Name { get; set; }
        public string Responsible_Surname { get; set; }
        public string Responsible_Department { get; set; }
    }
}
