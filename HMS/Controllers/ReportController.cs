using HMS.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HMS.Controllers
{
    public class ReportController : Controller
    {
        //
        // GET: /Report/
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Add(ItemID RecordID)
        {
            var model = new TaskDetails();

            using (var DB = new DBDataContext())
            {
                
            }

            return View("Add", model);
        }
	}
}