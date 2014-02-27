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
    public class FiltersController : Controller
    {
        public ActionResult Index()
        {
            var model = new TaskFilters();
            using (var DB = new DBDataContext())
            {
                // For Active Tasks
                model.TaskTypes = DB.F_TaskTypes("En").ToList().Select(x => new TaskFilters.FilteredTaskType
                {
                    id = x.ID,
                    Text = x.Text,
                    HasInstr = x.HasInstr
                });
                // For Active Tasks
                model.PriorityTypes = DB.F_PriorityTypes("En").ToList().Select(x => new SelectListItem
                {
                    Value = x.ID.ToString(),
                    Text = x.Text
                });
                // For Active Tasks
                model.StatusTypes = DB.F_StatusTypes("En").ToList().Select(x => new SelectListItem
                {
                    Value = x.ID.ToString(),
                    Text = x.Text
                });
                // for Active Tasks
                model.Patients = DB.F_Patients().ToList().Select(x => new SelectListItem
                {
                    Value = x.ID.ToString(),
                    Text = x.Surname + " " + x.Name + " (" + x.Department + ")"
                });
                // for Patients History
                model.AllPatients = DB.F_AllPatients(User.Identity.Name).ToList().Select(x => new SelectListItem
                {
                    Value = x.ID.ToString(),
                    Text = x.Surname + " " + x.Name + " (" + x.Department + ")"
                });
                // For Active Tasks
                model.Responsibles = DB.F_Nurses(User.Identity.Name).ToList().Select(x => new SelectListItem
                {
                    Value = x.ToString(),
                    Text= x.Nurse_Name + " " + x.Nurse_Surname + " (" + x.Department + ")"
                });

                model.Tasks = DB.F_ViewTasks("En").ToList().Select(x => new TaskFilters.FilteredTaskItem
                {
                    ID = x.ID,
                    Title = x.Title,
                    Patient_Name = x.Patient_Name,
                    Patient_Surname = x.Patient_Surname,
                    Patient_Department = x.Patient_Department,
                    Priority = x.Priority,
                    Instructions = x.Instructions,
                    Status = x.Status,
                    Creator_Name = x.Creator_Name,
                    Creator_Surname = x.Creator_Surname,
                    Creator_Department = x.Creator_Department,
                    TimeCreated = x.TimeCreated,
                    TimeUpdated = x.TimeUpdated,
                    Responsible_Name = x.Responsible_Name,
                    Responsible_Surname = x.Responsible_Surname,
                    Responsible_Department = x.Responsible_Department,
                    Deletable = x.Deletable
                });

                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
                model.From = DateTime.Today.AddYears(-1);
                model.Till = DateTime.Now;
            }
            return View("Index", model);
        }
    }
}