using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HMS.Models
{
    public class HMSUser
    {
        public Int32 ID { get; set; }

        public static Int32 GetUserID()
        {
            return 1;
        }

        public static Roles GetRole()
        {
            return Roles.Doctor;
        }

        public enum Roles {
            Doctor = 1,
            HeadNurse = 2,
            Nurse = 3
        }
    }
}