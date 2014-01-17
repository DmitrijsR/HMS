using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HMS.Models;
using System.Linq;

namespace HMS.Tests.Models
{
    [TestClass]
    public class DBModelTests
    {
        [TestMethod]
        public void DB_Model_is_not_Null()
        {
            var DB = new DBDataContext();
            
            Assert.IsNotNull(DB);
        }

        [TestMethod]
        public void DB_Patients_is_not_Null()
        {
            var DB = new DBDataContext();
            var patients = from p in DB.F_Patients()
                           select p;

            Assert.IsNotNull(patients);
        }

        [TestMethod]
        public void DB_TaskTypes_is_not_Null()
        {
            var DB = new DBDataContext();
            var tasktypes = from tt in DB.F_TaskTypes("En")
                           select tt;

            Assert.IsNotNull(tasktypes);
        }

        [TestMethod]
        public void DB_PriorityTypes_is_not_Null()
        {
            var DB = new DBDataContext();
            var prioritytypes = from pt in DB.F_PriorityTypes("En")
                           select pt;

            Assert.IsNotNull(prioritytypes);
        }
        
        [TestMethod]
        public void DB_NotificationTypes_is_not_Null()
        {
            var DB = new DBDataContext();
            var notificationtypes = from nt in DB.F_NotificationTypes("En")
                           select nt;

            Assert.IsNotNull(notificationtypes);
        }

        [TestMethod]
        public void DB_Dictionary_is_not_Null()
        {
            var DB = new DBDataContext();
            var dictionary = from d in DB.F_Dictionary("En")
                           select d;

            Assert.IsNotNull(dictionary);
        }
    }
}
