﻿using HMS.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HMS.Controllers
{
    [HMSAuthorize]
    public class ViewTasksController : Controller
    {
        //
        // GET: /ViewTasks/
        
        public ActionResult Index()
        {
            var model = new ViewTasksList();
            String Doctor_UID = null;
            String HNurse_UID = null;
            String Nurse_UID = null;

            using (var DB = new DBDataContext())
            {
                if (User.IsInRole("Doctor"))
                    Doctor_UID = User.Identity.Name;
                else if (User.IsInRole("Nurse"))
                    Nurse_UID = User.Identity.Name;
                else if (User.IsInRole("Headnurse"))
                    HNurse_UID = User.Identity.Name;
                
                model.Tasks = DB.F_ViewTasks("En", Doctor_UID, HNurse_UID, Nurse_UID).ToList().Select(x => new ViewTasksList.TaskItem
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
            }

            return View("Index", model);
        }

        public ActionResult Delete(ItemID RecordID)
        {
            var json = new { deleted = false };
            
            using (var DB = new DBDataContext())
            {
                int? result = DB.SP_Tasks_Delete(RecordID.ID).First();

                if (result == 0)
                    json = new { deleted = true };
            }

            return Json(json);
        }
	}
}