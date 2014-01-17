using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HMS.Models
{
    public class HMSUser
    {
        public Int32 ID { get; set; }

        public static Int32 GetMockUserID()
        {
            return 1;
        }
    }
}