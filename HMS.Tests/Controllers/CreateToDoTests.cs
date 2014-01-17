using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Web.Mvc;
using HMS.Models;

namespace HMS.Tests.Controllers
{
    [TestClass]
    public class CreateToDoTests
    {
        private CreateToDoController controller;

        [TestInitialize]
        public void Setup()
        {
            controller = new CreateToDoController();
        }

        [TestCleanup]
        public void TestCleanUp()
        {
            controller.Dispose();
            controller = null;
        }

        [TestMethod]
        public void CreateToDo_Index_is_not_Null()
        {
            var result = controller.Index();

            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void CreateToDo_Index_returns_ViewResult()
        {
            var result = controller.Index();

            // Assert
            Assert.IsInstanceOfType(result, typeof(ViewResult));
        }

        [TestMethod]
        public void CreateToDo_Index_returns_IndexView()
        {
            // Arrange
            const string expectedView = "Index";

            // Act
            ViewResult result = controller.Index() as ViewResult;

            // Assert
            Assert.AreEqual(expectedView, result.ViewName);
        }

        [TestMethod]
        public void CreateToDo_Create_is_not_Null()
        {
            var result = controller.Create(new ToDoList());

            Assert.IsNotNull(result);
        }

        [TestMethod]
        public void CreateToDo_Create_Redirects_To_ViewTasks_Index()
        {
            // Arrange

            // Act
            RedirectToRouteResult result = controller.Create(new ToDoList()) as RedirectToRouteResult;

            // Assert
            Assert.IsNotNull(result, "Not a redirect result");
            Assert.IsFalse(result.Permanent); // Or IsTrue if you use RedirectToActionPermanent
            Assert.AreEqual("Index", result.RouteValues["Action"]);
            Assert.AreEqual("ViewTasks", result.RouteValues["Controller"]);
        }
    }

    public class CreateToDo_Index_Model_Tests
    {
        private CreateToDoController controller;

        [TestInitialize]
        public void Setup()
        {
            controller = new CreateToDoController();
        }

        [TestCleanup]
        public void TestCleanUp()
        {
            controller.Dispose();
            controller = null;
        }

        [TestMethod]
        public void CreateToDo_Patients_are_not_empty()
        {
            var result = controller.Index() as ViewResult;
            var toDoList = (ToDoList)result.ViewData.Model;

            Assert.IsNotNull(toDoList.Patients);
        }

        [TestMethod]
        public void CreateToDo_PriorityTypes_are_not_empty()
        {
            var result = controller.Index() as ViewResult;
            var toDoList = (ToDoList)result.ViewData.Model;

            Assert.IsNotNull(toDoList.PriorityTypes);
        }

        [TestMethod]
        public void CreateToDo_NotificationTypes_are_not_empty()
        {
            var result = controller.Index() as ViewResult;
            var toDoList = (ToDoList)result.ViewData.Model;

            Assert.IsNotNull(toDoList.NotificationTypes);
        }

        [TestMethod]
        public void CreateToDo_Dictionary_is_not_empty()
        {
            var result = controller.Index() as ViewResult;
            var toDoList = (ToDoList)result.ViewData.Model;

            Assert.IsNotNull(toDoList.Dictionary);
        }

        [TestMethod]
        public void CreateToDo_TaskTypes_are_not_empty()
        {
            var result = controller.Index() as ViewResult;
            var toDoList = (ToDoList)result.ViewData.Model;

            Assert.IsNotNull(toDoList.TaskTypes);
        }
    }

    [TestClass]
    public class TaskItem_Validity_Tests
    {
        private ToDoList.TaskItem NewItem;

        [TestInitialize]
        public void Setup()
        {
            NewItem = new ToDoList.TaskItem();
        }

        [TestCleanup]
        public void TestCleanUp()
        {
            NewItem = null;
        }

        [TestMethod]
        public void New_TaskItem_Is_Not_Null()
        {
            Assert.IsNotNull(NewItem);
        }

        /**************************************************
         *  TaskItem.TaskID Validity Tests
         * ***********************************************/

        [TestMethod]
        public void TaskItem_TaskID_Accepts_Integers()
        {
            // Any value that exists in dbo.TaskTypes.ID
            NewItem.TaskID = 1;
            Assert.AreEqual(NewItem.TaskID, Convert.ToInt16(1));
        }

        /**************************************************
         *  TaskItem.Value Validity Tests
         * ***********************************************/

        [TestMethod]
        public void TaskItem_Value_Accepts_Integers()
        {
            NewItem.Value = "tuberculosis 1cm3";
            Assert.AreEqual(NewItem.Value, "tuberculosis 1cm3");
        }


        /**************************************************
         *  TaskItem.Importance Validity Tests
         * ***********************************************/

        [TestMethod]
        public void TaskItem_Importance_Accepts_Integers()
        {
            NewItem.Importance = 1;
            Assert.AreEqual(NewItem.Importance, Convert.ToInt16(1));
        }
        /**************************************************
         *  TaskItem.NotificationType Validity  Tests
         * ***********************************************/

        [TestMethod]
        public void TaskItem_NotificationType_Accepts_Integers()
        {
            NewItem.NotificationType = 1;
            Assert.AreEqual(NewItem.NotificationType, Convert.ToInt16(1));
        }
    }

    [TestClass]
    public class TaskItem_Boundary_Tests
    {
        private ToDoList.TaskItem NewItem;

        [TestInitialize]
        public void Setup()
        {
            NewItem = new ToDoList.TaskItem();
        }

        [TestCleanup]
        public void TestCleanUp()
        {
            NewItem = null;
        }

        /**************************************************
         *  TaskItem.TaskID Lower Boundary Tests
         * ***********************************************/

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void TaskItem_TaskID_Throws_ArgumentOutOfRangeException_If_Zero()
        {
            NewItem.TaskID = 0; //ID.Identity Field in SQl Server starts at 1
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void TaskItem_TaskID_Throws_ArgumentOutOfRangeException_If_Negative()
        {
            NewItem.TaskID = -1;
        }

        /**************************************************
         *  TaskItem.TaskID NotExistingValue Tests
         * ***********************************************/

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void TaskItem_TaskID_Throws_ArgumentOutOfRangeException_If_More_Than_Max_Nr_Of_Tasks()
        {
            // 100 does not(!) exists in dbo.TaskTypes.ID
            NewItem.TaskID = 100;
        }

        /**************************************************
         *  TaskItem.Importance Lower Boundary Tests
         * ***********************************************/

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void TaskItem_Importance_Throws_ArgumentOutOfRangeException_If_Zero()
        {
            NewItem.Importance = 0;
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void TaskItem_Importance_Throws_ArgumentOutOfRangeException_If_Negative()
        {
            NewItem.Importance = -1;
        }

        /**************************************************
         *  TaskItem.Importance NotExistingValue Tests
         * ***********************************************/

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void TaskItem_Importance_Throws_ArgumentOutOfRangeException_If_More_Than_Nr_Of_PriorityTypes()
        {
            NewItem.Importance = 100;
        }

        /**************************************************
         *  TaskItem.NotificationType Lower Boundary Tests
         * ***********************************************/

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void TaskItem_NotificationType_Throws_ArgumentOutOfRangeException_If_Zero()
        {
            NewItem.NotificationType = 0;
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void TaskItem_NotificationType_Throws_ArgumentOutOfRangeException_If_Negative()
        {
            NewItem.NotificationType = -1;
        }

        /**************************************************
         *  TaskItem.NotificationType NotExistingValue Tests
         * ***********************************************/

        [TestMethod]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void TaskItem_NotificationType_Throws_ArgumentOutOfRangeException_If_More_Than_Nr_Of_NotificationTypes()
        {
            NewItem.NotificationType = 100;
        }

    }
}