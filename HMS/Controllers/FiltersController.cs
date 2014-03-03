using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using HMS.Models;
using System.Linq.Dynamic;

namespace HMS.Controllers
{
    [HMSAuthorize]
    public class FiltersController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.HistoryTab = false;
            var model = new TaskFilters();
            using (var DB = new DBDataContext())
            {
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
                    Value = x.ID.ToString(),
                    Text = x.Nurse_Name + " " + x.Nurse_Surname + " (" + x.Department + ")"
                });

                model.Tasks = DB.F_ViewTasks("En", null, null, null).ToList().Select(x => new TaskFilters.FilteredTaskItem
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

                model.HistoryTasks = DB.F_HistoryTasks("En").ToList().Select(x => new TaskFilters.FilteredTaskItem
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
                    Responsible_Department = x.Responsible_Department
                });

                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
            }
           
 
            return View("Index", model);
        }

        public ActionResult ActiveSortFilter(int? Importance, int? Status, int? TaskType, int? Patient, int? Responsible, string From, string Till, string sortBy = "Priority", bool ascending = true, int page = 1, int pageSize = 10)
        {
            ViewBag.HistoryTab = false;
            ViewBag.Importance = Importance.ToString();
            ViewBag.Status = Status.ToString();
            ViewBag.TaskType = TaskType;
            ViewBag.Patient = Patient.ToString();
            ViewBag.Responsible = Responsible.ToString();
            ViewBag.From = From;
            ViewBag.Till = Till;

            var model = new TaskFilters()
            {
                SortBy = sortBy,
                SortAscending = ascending,
                CurrentPageIndex = page,
                PageSize = pageSize
            };
            using (var DB = new DBDataContext())
            {
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
                model.StatusTypes = model.StatusTypes.Where(x => x.Value != "5");   // filter out Complete status
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
                    Value = x.ID.ToString(),
                    Text = x.Nurse_Name + " " + x.Nurse_Surname + " (" + x.Department + ")"
                });

                var tempmodel = new TaskFilters();
                tempmodel.Tasks = DB.F_ViewTasks("En", null, null, null).OrderBy(model.SortExpression).ToList().Select(x => new TaskFilters.FilteredTaskItem
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
                }).AsQueryable();

                if (Importance != null)
                {
                    string pri = model.PriorityTypes.Where(pr=>pr.Value==Importance.Value.ToString()).SingleOrDefault().Text;
                    tempmodel.Tasks = tempmodel.Tasks.Where(p => p.Priority == pri);
                }
                if (Status != null)
                {
                    string stat = model.StatusTypes.Where(pr => pr.Value == Status.Value.ToString()).SingleOrDefault().Text;
                    tempmodel.Tasks = tempmodel.Tasks.Where(p => p.Status == stat);
                }
                if (TaskType != null)
                {
                    string typ = model.TaskTypes.Where(pr => pr.id == TaskType).SingleOrDefault().Text;
                    tempmodel.Tasks = tempmodel.Tasks.Where(p => p.Title == typ);
                }
                if (Patient != null)
                {
                    string Surname =  model.Patients.Where(pr => pr.Value == Patient.Value.ToString()).SingleOrDefault().Text;
                    string [] comb = Surname.Split(' ');    // since Model.Patients stores Patient ID and combination of surname,name and department in one string
                    tempmodel.Tasks = tempmodel.Tasks.Where(p => p.Patient_Surname == comb[0]);
                }
                if (Responsible != null)
                {
                    string Surname = model.Responsibles.Where(pr => pr.Value == Responsible.Value.ToString()).SingleOrDefault().Text;
                    string[] comb = Surname.Split(' ');    // since Model.Patients stores Patient ID and combination of surname,name and department in one string
                    tempmodel.Tasks = tempmodel.Tasks.Where(p => p.Responsible_Name == comb[0]);
                }
                //From,Till

                model.HistoryTasks = DB.F_HistoryTasks("En").ToList().Select(x => new TaskFilters.FilteredTaskItem
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
                    Responsible_Department = x.Responsible_Department
                });

                model.Tasks = tempmodel.Tasks;
                model.TotalRecordCount = DB.F_ViewTasks("En", null, null, null).ToList().Count;

                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
                model.From = DateTime.Today.AddYears(-1);
                model.Till = DateTime.Now;
               /*

                // Determine the total number of FILTERED products being paged through (needed to compute PageCount)
                model.TotalRecordCount = filteredResults.Count();

                // Get the current page of sorted, filtered products
                model.Products = filteredResults
                                     .OrderBy(model.SortExpression)
                                     .Skip((model.CurrentPageIndex - 1) * model.PageSize)
                                     .Take(model.PageSize);
                * 
                */
            }
 
            return View("Index", model);
        }
        
        [HMSAuthorize(Roles = "Doctor")]
        public ActionResult HistorySortFilter(int? HistoryPatient, string HistoryFrom, string HistoryTill, string sortBy = "Priority", bool ascending = true, int page = 1, int pageSize = 10)
        {
            ViewBag.HistoryTab = true;
            ViewBag.HistoryPatient = HistoryPatient.ToString();
            ViewBag.From = HistoryFrom;
            ViewBag.Till = HistoryTill;

            var model = new TaskFilters()
            {
                SortBy = sortBy,
                SortAscending = ascending,
                CurrentPageIndex = page,
                PageSize = pageSize
            };
            using (var DB = new DBDataContext())
            {
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
                model.StatusTypes = model.StatusTypes.Where(x => x.Value != "5");   // filter out Complete status
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
                    Value = x.ID.ToString(),
                    Text = x.Nurse_Name + " " + x.Nurse_Surname + " (" + x.Department + ")"
                });

                model.HistoryTasks = DB.F_HistoryTasks("En").OrderBy(model.SortExpression).ToList().Select(x => new TaskFilters.FilteredTaskItem
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
                    Responsible_Department = x.Responsible_Department
                }).AsQueryable();

                if (HistoryPatient != null)
                {
                    string Surname = model.Patients.Where(pr => pr.Value == HistoryPatient.Value.ToString()).SingleOrDefault().Text;
                    string[] comb = Surname.Split(' ');    // since Model.Patients stores Patient ID and combination of surname,name and department in one string
                    model.HistoryTasks = model.HistoryTasks.Where(p => p.Patient_Surname == comb[0]);
                }
                //From,Till


                model.TotalRecordCount = DB.F_ViewTasks("En", null, null, null).ToList().Count;

                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
                
            }

            return View("Index", model);
        }
    }
}