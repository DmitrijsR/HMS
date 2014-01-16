using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Web.Mvc;
using HMS;
using HMS.Controllers;

namespace HMS.Tests.Controllers
{
    [TestClass]
    public class ViewTasksTests
    {
        [TestMethod]
        public void ViewTasks_Index_is_not_Null()
        {
            // Arrange
            ViewTasksController controller = new ViewTasksController();
 
            // Act
            ViewResult result = controller.Index() as ViewResult;

            // Assert
            Assert.IsNotNull(result);
        }
    }
}
