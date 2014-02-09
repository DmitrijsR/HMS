using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Security;
using HMS.Models;

namespace HMS
{
    public class HMSRoleProvider: RoleProvider
    {       
        public override void AddUsersToRoles(string[] usernames, string[] roleNames)
        {
            throw new NotImplementedException();
        }

        public override string ApplicationName
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        public override void CreateRole(string roleName)
        {
            throw new NotImplementedException();
        }

        public override bool DeleteRole(string roleName, bool throwOnPopulatedRole)
        {
            throw new NotImplementedException();
        }

        public override string[] FindUsersInRole(string roleName, string usernameToMatch)
        {
            throw new NotImplementedException();
        }

        public override string[] GetAllRoles()
        {
            throw new NotImplementedException();
        }

        public override string[] GetRolesForUser(string username)
        {

            List<string> roles;
            ObjectResult<string> roleList;
            using (var DB = new DBDataContext())
            {
                roleList = DB.SP_GetRoles(username);
                roles = roleList.ToList();
            }
            string[] roleArray = roles.Select(role => role.Trim()).ToArray();
            return roleArray;
        }

        public override string[] GetUsersInRole(string roleName)
        {
            throw new NotImplementedException();
        }

        public override bool IsUserInRole(string username, string roleName)
        {
            throw new NotImplementedException();
            /*
            Personnel user = repository.GetUser(username);
            AUthTEstg.Models.Roles role = repository.GetRole(roleName);

            if (!repository.UserExists(user))
                return false;
            if (!repository.RoleExists(role))
                return false;

            return user.Roles.Contains(role);
             * */
        }

        public override void RemoveUsersFromRoles(string[] usernames, string[] roleNames)
        {
            throw new NotImplementedException();
        }

        public override bool RoleExists(string roleName)
        {
            throw new NotImplementedException();
        }
    }
}