using HMS.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HMS.Controllers
{
    [Authorize (Roles="Headnurse")]
    public class TaskAssignmentController : Controller
    {
        public ActionResult Index(Int32? Task_ID)
        {
            var model = new TaskAssignment();
            using (var DB = new DBDataContext())
            {
                if (Task_ID != null)
                {
                    model.NurseList = DB.F_NurseWorkLoad(Task_ID).ToList().Select(x => new TaskAssignment.Nurse
                    {
                        ID = x.ID,
                        Nurse_Name = x.Nurse_Name,
                        Nurse_Surname = x.Nurse_Surname,
                        Active_Tasks = x.Active_Tasks,
                        All_Tasks = x.All_Tasks,
                        IsResponsible = x.IsResponsible                          
                    });
                    model.ResponsibleCurrent = model.ResponsiblePrev = model.NurseList.Where(u => u.IsResponsible == true).Select(u => u.ID).FirstOrDefault();
                    model.TaskID = Task_ID;
                }               
                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text); 
            }
            return View("Index", model);
        }
    
        [HttpPost]
        public ActionResult Assign(TaskAssignment AssignedNurse)
        {
            if (ModelState.IsValid)
            {
                using (var DB = new DBDataContext())
                {

                    int? result = DB.SP_Task_Assign(AssignedNurse.TaskID,AssignedNurse.ResponsibleCurrent).First();
                    return RedirectToAction("Index", "ViewTasks");
                }
            }
           
            //ItemID task = new ItemID();
            //task.ID = (int)AssignedNurse.TaskID;
            return RedirectToAction("Index", "ViewTasks");
        }
    }
}