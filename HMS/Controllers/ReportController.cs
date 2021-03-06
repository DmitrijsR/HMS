﻿using HMS.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace HMS.Controllers
{
    [HMSAuthorize]
    public class ReportController : Controller
    {
        //
        // GET: /Report/
        public ActionResult Index(ItemID RecordID)
        {
            if (ModelState.IsValid)
            {
                var model = new TaskDetails();

                using (var DB = new DBDataContext())
                {
                    if (RecordID == null) { model.Details = null; }
                    else
                    {
                        model.Details = DB.F_ViewTaskDetails(RecordID.ID, "En").ToList().Select(x => new TaskDetails.TaskDetailItem
                        {
                            ID = x.ID,
                            Title = x.Title,
                            Patient_Name = x.Patient_Name,
                            Patient_Surname = x.Patient_Surname,
                            Patient_SocialNr = x.Patient_SocialNr,
                            Patient_Department = x.Patient_Department,
                            Priority = x.Priority,
                            Instructions = x.Instructions,
                            Status_ID = x.Status_ID,
                            Status = x.Status,
                            Creator_ID = x.Creator_ID,
                            TimeCreated = x.TimeCreated,
                            TimeUpdated = x.TimeUpdated,
                            Responsible_Name = x.Responsible_Name,
                            Responsible_Surname = x.Responsible_Surname,
                            Responsible_Department = x.Responsible_Department
                        }).FirstOrDefault();
                    }

                    if (model.Details != null)
                    {
                        model.StatusTypes = DB.F_StatusTypes("En").ToList().Select(x => new SelectListItem
                        {
                            Value = x.ID.ToString(),
                            Text = x.Text
                        });

                        model.PriorityTypes = DB.F_PriorityTypes("En").ToList().Select(x => new SelectListItem
                        {
                            Value = x.ID.ToString(),
                            Text = x.Text
                        });

                        model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);

                        return View("Index", model);
                    }
                }
            }

            var Error_model = new DictionaryModel();

            using (var DB = new DBDataContext())
            {
                Error_model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
            }

            return View("Error", Error_model);
        }
        [HttpPost]
        public ActionResult Add(ReportReq Request, HttpPostedFileBase file)
        {
            if (ModelState.IsValid)
            {

                if (file != null && file.ContentLength > 0)
                {
                    // extract only the fielname
                    var fileName = Path.GetFileName(file.FileName);
                    // store the file inside ~/App_Data/uploads folder
                    var path = Path.Combine(Server.MapPath("~/App_Data/uploads"), fileName);
                    file.SaveAs(path);
                }

                using (var DB = new DBDataContext())
                {
                    int? result = DB.SP_Tasks_Report(Request.Task_ID, Request.Details.Status_ID, Path.GetFileName(file.FileName), Request.comment, User.Identity.Name).First();

                    return RedirectToAction("Index", "ViewTasks");
                }
            }

            var Error_model = new DictionaryModel();

            using (var DB = new DBDataContext())
            {
                Error_model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
            }

            return View("Error", Error_model);
        }
	}
}