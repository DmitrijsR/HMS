using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using HMS.Models;

namespace HMS.Controllers
{
    public class AccountController : Controller
    {

        public HMSMempershipProvider MembershipService { get; set; }
        public HMSRoleProvider AuthorizationService { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            if (MembershipService == null)
                MembershipService = new HMSMempershipProvider();
            if (AuthorizationService == null)
                AuthorizationService = new HMSRoleProvider();

            base.Initialize(requestContext);
        }

        public ActionResult Login()
        {     
            return View();
        }

        [AllowAnonymous]
        [HttpPost]
        public ActionResult Login(HMSUser model, string returnUrl)
        {
            if (ModelState.IsValid)
            {
                if (MembershipService.ValidateUser(model.Username, model.Password))
                {
                    FormsAuthentication.SetAuthCookie(model.Username, false);
                    return RedirectToLocal(returnUrl);
                }

            }
            // If we got this far, something failed, redisplay form
            ModelState.AddModelError("", "The user name or password provided is incorrect.");
            return View(model);
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            else
            {
                return RedirectToAction("Index", "ViewTasks");
            }
        }
	}
}