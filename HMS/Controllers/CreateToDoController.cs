using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HMS.Models;
using System.Data.Entity.Core.Objects;

namespace HMS
{
    public class CreateToDoController : Controller
    {
        //
        // GET: /CreateToDo/
        public ActionResult Index()
        {
            var model = new ToDoList();

            using (var DB = new DBDataContext())
            {
                model.TaskTypes = DB.F_TaskTypes("En").ToList().Select(x => new ToDoList.TaskType
                {
                    id = x.ID,
                    Text = x.Text,
                    HasInstr = x.HasInstr
                });
                
                model.Patients = DB.F_Patients().ToList().Select(x => new SelectListItem
                {
                    Value = x.ID.ToString(),
                    Text = x.Surname + " " + x.Name + " (" + x.Department + ")"
                });

                model.PriorityTypes = DB.F_PriorityTypes("En").ToList().Select(x => new SelectListItem
                {
                    Value = x.ID.ToString(),
                    Text = x.Text
                });

                model.NotificationTypes = DB.F_NotificationTypes("En").ToList().Select(x => new SelectListItem
                {
                    Value = x.ID.ToString(),
                    Text = x.Text
                });

                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
            }

            return View("Index", model);
        }

        public ActionResult Create(ToDoList model)
        {
            if (ModelState.IsValid)
            {
                //The model is OK. We can do whatever we want to do with the model
                using (var DB = new DBDataContext())
                {
                    foreach (ToDoList.TaskItem ti in model.Tasks)
                    {
                        var output = new ObjectParameter("NewTaskID", typeof(int));
                        //change 1 to insert current user id
                        int? result = DB.SP_Tasks_Add(ti.TaskID, model.PatientID, ti.Importance, ti.Value, HMSUser.GetMockUserID(), output).First();

                        if (result.HasValue && result == 0)
                        {
                            // Insert successful => Add notification rules using output.Value

                        }
                    }
                }

                return RedirectToAction("Index", "ViewTasks");
            }

            var Error_model = new DictionaryModel();

            using (var DB = new DBDataContext())
            {
                Error_model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
            }

            return View("Create", Error_model);
        }
	}
}