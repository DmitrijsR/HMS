using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;

namespace HMS.Models
{
    public class HMSUser
    {
        public Int32? ID { get; set; }
        public string Username{ get; set; }
        public string Password { get; set; }

        public Dictionary<string, string> Dictionary { get; set; }

        //retrieve userID based on username
        public static Int32? GetUserID(string username)
        {
            using (var DB = new DBDataContext())
            {
                int?[] ids;
                ObjectResult<int?> UserId;
                UserId = DB.SP_GetUserID(username);
                ids = UserId.ToArray();
                return ids[0];
            }
        }
    }
}