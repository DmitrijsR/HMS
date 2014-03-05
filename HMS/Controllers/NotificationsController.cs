using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HMS.Models;

namespace HMS.Controllers
{
    public class NotificationsController : Controller
    {
        //
        // GET: /Notifications/
        public ActionResult Index()
        {
            var model = new Notifications();
            using (var DB = new DBDataContext())
            {
                model.Items = DB.F_ViewNotifications("En", User.Identity.Name).ToList().Select(x => new Notifications.NotifItem
                {
                    id = x.ID,
                    Notification = x.Notification
                });
                
                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
            }
            
            return View("Index", model);
        }
	}
}