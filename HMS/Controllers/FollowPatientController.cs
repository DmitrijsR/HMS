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
    public class FollowPatientController: Controller
    {
        [HMSAuthorize(Roles = "Doctor, Headnurse")]
        public ActionResult Index()
        {
            FollowPatient model = new FollowPatient();
            using (var DB = new DBDataContext())
            {
                model.PrevFollowedPatients = DB.F_FollowedPatients(User.Identity.Name).ToList().Select(x => new FollowPatient.FPatient
                {
                    ID = x.ID,
                    Name = x.Surname + " " + x.Name + " (" + x.Department + ")"
                });
                model.CurrFollowedPatients = DB.F_FollowedPatients(User.Identity.Name).ToList().Select(x => new FollowPatient.FPatient
                {
                    ID = x.ID,
                    Name = x.Surname + " " + x.Name + " (" + x.Department + ")"
                });
                model.Patients = DB.F_Patients().ToList().Select(x => new SelectListItem
                {
                    Value = x.ID.ToString(),
                    Text = x.Surname + " " + x.Name + " (" + x.Department + ")"
                });
                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
            }

            return View("Index",model);
        }
        public ActionResult Follow(FollowPatient model)
        {
            using (var DB = new DBDataContext())
            {
                if (model.CurrFollowedPatients != null)
                {
                    foreach (FollowPatient.FPatient curr in model.CurrFollowedPatients)
                    {
                        if (model.PrevFollowedPatients == null)
                            DB.SP_Follow_Patient(User.Identity.Name, curr.ID);
                        else if (!model.PrevFollowedPatients.Any(x=>x.ID == curr.ID)) // if Previously followed patients does not contain currently followed patient then add
                        {   
                            DB.SP_Follow_Patient(User.Identity.Name, curr.ID);
                        }
                    }
                }

                if(model.PrevFollowedPatients != null) 
                {
                    foreach (FollowPatient.FPatient prev in model.PrevFollowedPatients)
                    {
                        if (model.CurrFollowedPatients == null)
                            DB.SP_Unfollow_Patient(User.Identity.Name, prev.ID);
                        else if (!model.CurrFollowedPatients.Any(x => x.ID == prev.ID)) // if Currently followed patients does not contain a previously followed patient then delete
                        {
                            DB.SP_Unfollow_Patient(User.Identity.Name, prev.ID);
                        }
                    }
                }

                model.PrevFollowedPatients = DB.F_FollowedPatients(User.Identity.Name).ToList().Select(x => new FollowPatient.FPatient
                {
                    ID = x.ID,
                    Name = x.Surname + " " + x.Name + " (" + x.Department + ")"
                });
                model.CurrFollowedPatients = DB.F_FollowedPatients(User.Identity.Name).ToList().Select(x => new FollowPatient.FPatient
                {
                    ID = x.ID,
                    Name = x.Surname + " " + x.Name + " (" + x.Department + ")"
                });
                model.Patients = DB.F_Patients().ToList().Select(x => new SelectListItem
                {
                    Value = x.ID.ToString(),
                    Text = x.Surname + " " + x.Name + " (" + x.Department + ")"
                });
                model.Dictionary = DB.F_Dictionary("En").ToDictionary(k => k.Tag, v => v.Text);
            }

            return RedirectToAction("Index","ViewTasks");
        }
	}
}