using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HMS
{
    public class HMSAuthorize : AuthorizeAttribute
    {
        protected override void HandleUnauthorizedRequest(System.Web.Mvc.AuthorizationContext filterContext)
        {
            //filterContext.ActionDescriptor.ActionName
            filterContext.Controller.TempData["Auth_Error"] = "You are not authorized for this action.";
            base.HandleUnauthorizedRequest(filterContext);
        }
    }
}