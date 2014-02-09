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
            var model = new HMSUser();
            using (var DB = new DBDataContext())
            {
                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
            }
            return View(model);
        }

        [AllowAnonymous]
        [HttpPost]
        public ActionResult Login(HMSUser model, string ReturnUrl)
        {
            
            if (ModelState.IsValid)
            {
                if (MembershipService.ValidateUser(model.Username, model.Password))
                {
                    FormsAuthentication.SetAuthCookie(model.Username, false);
                    return RedirectToLocal(ReturnUrl);
                }

            }
            // If we got this far, something failed, redisplay form
            ModelState.AddModelError("", "The user name or password provided is incorrect.");
            return RedirectToAction("Login", "Account");
        }

        public ActionResult Logout()
        {          
            FormsAuthentication.SignOut();
            Session.Abandon();

            // clear authentication cookie
            HttpCookie cookie1 = new HttpCookie(FormsAuthentication.FormsCookieName, "");
            cookie1.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie1);

            // clear session cookie (not necessary for your current problem but i would recommend you do it anyway)
            HttpCookie cookie2 = new HttpCookie("ASP.NET_SessionId", "");
            cookie2.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie2);

            FormsAuthentication.RedirectToLoginPage();
            return RedirectToAction("Login", "Account");
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