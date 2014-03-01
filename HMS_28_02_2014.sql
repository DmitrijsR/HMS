USE [master]
GO
/****** Object:  Database [HMS]    Script Date: 2/28/2014 1:00:04 PM ******/
CREATE DATABASE [HMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HMS', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL11.BTH14\MSSQL\DATA\HMS.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'HMS_log', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL11.BTH14\MSSQL\DATA\HMS_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [HMS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [HMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HMS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [HMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [HMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HMS] SET RECOVERY FULL 
GO
ALTER DATABASE [HMS] SET  MULTI_USER 
GO
ALTER DATABASE [HMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HMS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [HMS]
GO
/****** Object:  StoredProcedure [dbo].[SP_Authenticate]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Authenticate](@UserName varchar(50), @Password varchar(50),@IsAuthenticated int OUTPUT)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SET @IsAuthenticated =( SELECT ID from dbo.Personnel a
    where a.Username = @UserName
    and a.Password = @Password)
    IF (@IsAuthenticated IS NULL) 
        set @IsAuthenticated = 0;
    Else
		set @IsAuthenticated = 1;
	SELECT @IsAuthenticated ;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetRoles]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetRoles](	
	@UserName nvarchar(max)
)
AS
BEGIN
	Select Name from dbo.Roles r
	INNER JOIN dbo.PersonnelRole pr
	ON pr.RoleID=r.Id
	where pr.PersonnelID=(select ID from dbo.Personnel p where p.username = @UserName);
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetUserID]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[SP_GetUserID](	
	@UserName nvarchar(max)
)
AS
BEGIN
	select ID from dbo.Personnel p where p.username = @UserName;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Task_Assign]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Task_Assign](
	@TaskID int,
	@NurseID int
)
AS
BEGIN
	declare @err int
	begin transaction

	update dbo.Tasks set Responsible_ID = @NurseID,Status_ID=2,TimeUpdated=GETDATE() where ID = @TaskID;
	select @err = @@Error
	
	if @err <> 0
		rollback transaction 
	commit transaction 
	if @err = 0
		select @err = @@Error
	else
		select @err  

	select @err;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Tasks_Add]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Tasks_Add](
	@TypeID int,
    @PatientID int,
	@PriorityID int,
	@Instr nvarchar(max),
	@Creator_ID int,
	@NewTaskID int OUTPUT
)
AS
BEGIN
	declare @err int
	
	SET NOCOUNT ON;
	
	DECLARE @StatusID int;
	SELECT @StatusID = ID from dbo.Statuses where Name = '%Status_New';

	insert into dbo.Tasks([Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID]) 
	values (@TypeID, @PatientID, @PriorityID, @Instr, @StatusID, @Creator_ID);

	SELECT @NewTaskID = SCOPE_IDENTITY();
	
	select @err = @@Error;
	select @err;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Tasks_Delete]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Tasks_Delete](
	@TaskID int
)
AS
BEGIN
	declare @err int
	
	delete from dbo.Tasks
	Where ID = @TaskID

	select @err = @@Error;
	select @err;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Tasks_Report]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SP_Tasks_Report](
	@TaskID int,
	@StatusID int,
	@Attachment nvarchar(max) = NULL,
	@Comment nvarchar(max) = NULL
)
AS
BEGIN
	declare @err int
	
	begin transaction

	update dbo.Tasks set Status_ID = @StatusID where ID = @TaskID;
	select @err = @@Error
	
	if @err <> 0
		rollback transaction
	else
		begin
			
			insert into dbo.Reports (Task_ID, Status_ID, Attachment, Comment) 
			values (@TaskID, @StatusID, @Attachment, @Comment);
  
			select @err = @@Error
			
			if @err <> 0
				rollback transaction
		end
 
	commit transaction 
	if @err = 0
		select @err = @@Error
	else
		select @err  

	select @err;
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_AllPatients]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_AllPatients] (@PersonnelUserName nvarchar(MAX))
RETURNS @PatientsTab TABLE (
	ID			int, 
	Name		nvarchar(max),
	Surname		nvarchar(max),
	SocialNr	nvarchar(max),
	Department	nvarchar(max)
)
AS
BEGIN
	INSERT @PatientsTab
		select p.ID, p.Name, p.Surname, p.SocialNr, d.Department
		from dbo.Patients p 
		left join dbo.PatientAdmission pa on p.ID = pa.Patient_ID
		left join dbo.Departments d on pa.Department_ID = d.ID
	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_Dictionary]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_Dictionary] (@Language nchar(2))
RETURNS @DictionaryTab TABLE (
	Tag			nvarchar(max), 
	Text		nvarchar(max)
)
AS
BEGIN
	IF (dbo.F_ValidateLanguage(@Language) = 1)
	BEGIN
		INSERT @DictionaryTab
			select d.Tag, d.Text 
			from dbo.Dictionaries d
			left join dbo.SupportedLanguages sl on d.Language_ID = sl.ID
			where sl.Language = @Language AND d.Type = 'External'
	END
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_HistoryTasks]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_HistoryTasks] (@Language nchar(2))
RETURNS @TasksTab TABLE (
	ID						int, 
	Title					nvarchar(max),
	Patient_Name			nvarchar(max),
	Patient_Surname			nvarchar(max),
	Patient_Department		nvarchar(max),
	Priority				nvarchar(max),
	Instructions			nvarchar(max),
	Status					nvarchar(max),
	Creator_Name			nvarchar(max),
	Creator_Surname			nvarchar(max),
	Creator_Department		nvarchar(max),
	TimeCreated				datetime2,
	TimeUpdated				datetime2,
	Responsible_Name		nvarchar(max),
	Responsible_Surname		nvarchar(max),
	Responsible_Department	nvarchar(max)
)
AS
BEGIN
	IF (dbo.F_ValidateLanguage(@Language) = 1)
	BEGIN
		INSERT @TasksTab
			select t.ID, tt.Text, p.Name, p.Surname, p.Department, pt.Text, t.Instructions, s.Text, 
				per.Name, per.Surname, d.Department, t.TimeCreated, t.TimeUpdated, 
				per2.Name, per2.Surname, d2.Department
			from dbo.Tasks t
				left join dbo.F_TaskTypes(@Language) tt on t.Type_ID = tt.ID
				left join dbo.F_Patients() p on t.Patient_ID = p.ID
				left join dbo.F_PriorityTypes(@Language) pt on t.Priority_ID = pt.ID
				left join dbo.F_StatusTypes(@Language) s on t.Status_ID = s.ID
				left join dbo.Personnel per on t.Creator_ID = per.ID
				left join dbo.Departments d on per.Department_ID = d.ID
				left join dbo.Personnel per2 on t.Responsible_ID = per2.ID
				left join dbo.Departments d2 on per2.Department_ID = d2.ID
				left join dbo.Statuses st on t.Status_ID = st.ID
			where t.Status_ID = 5;

	END
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_NotificationTypes]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_NotificationTypes] (@Language nchar(2))
RETURNS @NotificationTypesTab TABLE (
	ID			int, 
	Text		nvarchar(max)
)
AS
BEGIN
	IF (dbo.F_ValidateLanguage(@Language) = 1)
	BEGIN
		INSERT @NotificationTypesTab
			select nt.ID, d.Text 
			from dbo.NotificationTypes nt 
			left join dbo.Dictionaries d on nt.Name = d.Tag
			left join dbo.SupportedLanguages sl on d.Language_ID = sl.ID
			where sl.Language = @Language
	END
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_Nurses]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[F_Nurses](@PersonnelUserName nvarchar(max))
RETURNS @NurseWorkLoad TABLE (
	ID						int, 
	Nurse_Name				nvarchar(max),
	Nurse_Surname			nvarchar(max),
	Department				nvarchar(max)
)
AS
BEGIN

	declare @Personnel_Dept int;
	set @Personnel_Dept = (select pers.Department_ID from dbo.Personnel pers where pers.Username = @PersonnelUserName)

	INSERT @NurseWorkLoad
	select n.ID, n.Name, n.Surname, d.Department
	from dbo.Personnel n
	Left Join dbo.PersonnelRole pr on pr.PersonnelID = n.ID
	Left Join dbo.Roles r on pr.RoleID = r.ID
	left join dbo.Departments d on d.ID = @Personnel_Dept 

	where n.ID = pr.PersonnelID 
	and r.Name = 'Nurse'
	and n.Department_ID = @Personnel_Dept
	Group By n.ID, n.Name, n.Surname, d.Department
RETURN 
END



GO
/****** Object:  UserDefinedFunction [dbo].[F_NurseWorkLoad]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[F_NurseWorkLoad](@TaskID int)
RETURNS @NurseWorkLoad TABLE (
	ID						int, 
	Nurse_Name				nvarchar(max),
	Nurse_Surname			nvarchar(max),
	All_Tasks				int,
	Active_Tasks			int,
	IsResponsible			bit
)
AS
BEGIN
	INSERT @NurseWorkLoad
	select n.ID, n.Name, n.Surname, 	
			Sum(Case When s.ID != 5 Then 1 else 0 End) All_Tasks, --if statuss is not Complete => +1
			Sum(Case When s.ID = 3 OR s.ID = 4 Then 1 else 0 End) Active_Tasks, -- if statuss is  Waiting or In process => +1
			Sum(case when n.ID = t.Responsible_ID AND @TaskID=t.ID then 1 else 0 end)
from dbo.Personnel n
Left Join Tasks t on n.ID = t.Responsible_ID
Left Join Statuses s on t.Status_ID = s.ID 
Left Join dbo.PersonnelRole pr on pr.PersonnelID = n.ID
Left Join dbo.Roles r on pr.RoleID = r.ID

where n.Department_ID = (select p.Department_ID from dbo.Personnel p
						 where p.ID = (select c.Creator_ID from dbo.Tasks c
									   where c.ID = @TaskID))
and n.ID = pr.PersonnelID 
and r.Name = 'Nurse'
Group By n.ID, n.Name, n.Surname
	RETURN 
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_Patients]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_Patients] ()
RETURNS @PatientsTab TABLE (
	ID			int, 
	Name		nvarchar(max),
	Surname		nvarchar(max),
	SocialNr	nvarchar(max),
	Department	nvarchar(max)
)
AS
BEGIN
	INSERT @PatientsTab
		select p.ID, p.Name, p.Surname, p.SocialNr, d.Department
		from dbo.Patients p 
		left join dbo.PatientAdmission pa on p.ID = pa.Patient_ID
		left join dbo.Departments d on pa.Department_ID = d.ID
		where pa.Date_FROM < GETDATE() AND (pa.Date_Till is Null OR pa.Date_Till > GETDATE());
	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[F_PriorityTypes]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_PriorityTypes] (@Language nchar(2))
RETURNS @PriorityTypesTab TABLE (
	ID			int, 
	Text		nvarchar(max)
)
AS
BEGIN
	IF (dbo.F_ValidateLanguage(@Language) = 1)
	BEGIN
		INSERT @PriorityTypesTab
			select pt.ID, d.Text 
			from dbo.PriorityTypes pt 
			left join dbo.Dictionaries d on pt.Name = d.Tag
			left join dbo.SupportedLanguages sl on d.Language_ID = sl.ID
			where sl.Language = @Language
	END
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_StatusTypes]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[F_StatusTypes] (@Language nchar(2))
RETURNS @StatusesTab TABLE (
	ID			int, 
	Text		nvarchar(max)
)
AS
BEGIN
	IF (dbo.F_ValidateLanguage(@Language) = 1)
	BEGIN
		INSERT @StatusesTab
			select s.ID, d.Text 
			from dbo.Statuses s 
			left join dbo.Dictionaries d on s.Name = d.Tag
			left join dbo.SupportedLanguages sl on d.Language_ID = sl.ID
			where sl.Language = @Language
	END
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_TaskTypes]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_TaskTypes] (@Language nchar(2))
RETURNS @TaskTypesTab TABLE (
	ID			int, 
	Text		nvarchar(max),
	HasInstr	nvarchar(max)
)
AS
BEGIN
	IF (dbo.F_ValidateLanguage(@Language) = 1)
	BEGIN
		INSERT @TaskTypesTab
			select tt.ID, d.Text, tt.HasInstr 
			from dbo.TaskTypes tt 
			left join dbo.Dictionaries d on tt.Name = d.Tag
			left join dbo.SupportedLanguages sl on d.Language_ID = sl.ID
			where sl.Language = @Language
	END
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_TranslateTo]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_TranslateTo](@Language nchar(2), @Tag nvarchar(max))
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @Result nvarchar(max)
	SET @Result = NULL

	IF (dbo.F_ValidateLanguage(@Language) = 1)
	BEGIN
		
			SELECT @Result = d.Text 
			FROM dbo.Dictionaries d
			LEFT JOIN dbo.SupportedLanguages sl on d.Language_ID = sl.ID
			WHERE sl.Language = @Language AND @Tag = d.Tag
	END	
	RETURN @Result
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_ValidateLanguage]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_ValidateLanguage] (@Language nchar(2))
RETURNS BIT
AS
BEGIN 
	RETURN
	(
		select count(ID) from dbo.SupportedLanguages where UPPER(Language) = UPPER(@Language) 
	)
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_ViewTaskDetails]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_ViewTaskDetails] (@TaskID int, @Language nchar(2))
RETURNS @TaskDetailsTab TABLE (
	ID						int, 
	Title					nvarchar(max),
	Patient_Name			nvarchar(max),
	Patient_Surname			nvarchar(max),
	Patient_SocialNr		nvarchar(max),
	Patient_Department		nvarchar(max),
	Priority				nvarchar(max),
	Instructions			nvarchar(max),
	Status_ID				int,
	Status					nvarchar(max),
	Creator_ID				int,
	TimeCreated				datetime2,
	TimeUpdated				datetime2,
	Responsible_Name		nvarchar(max),
	Responsible_Surname		nvarchar(max),
	Responsible_Department	nvarchar(max)
)
AS
BEGIN
	IF (dbo.F_ValidateLanguage(@Language) = 1)
	BEGIN
		INSERT @TaskDetailsTab
			select t.ID, tt.Text, p.Name, p.Surname, p.SocialNr, p.Department, pt.Text, t.Instructions, s.ID, s.Text, 
				t.Creator_ID, t.TimeCreated, t.TimeUpdated, 
				per.Name, per.Surname, d.Department
			from dbo.Tasks t
				left join dbo.F_TaskTypes(@Language) tt on t.Type_ID = tt.ID
				left join dbo.F_Patients() p on t.Patient_ID = p.ID
				left join dbo.F_PriorityTypes(@Language) pt on t.Priority_ID = pt.ID
				left join dbo.F_StatusTypes(@Language) s on t.Status_ID = s.ID
				left join dbo.Personnel per on t.Responsible_ID = per.ID
				left join dbo.Departments d on per.Department_ID = d.ID
				left join dbo.Statuses st on t.Status_ID = st.ID
			where t.ID = @TaskID

	END
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[F_ViewTasks]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[F_ViewTasks] (@Language nchar(2))
RETURNS @TasksTab TABLE (
	ID						int, 
	Title					nvarchar(max),
	Patient_Name			nvarchar(max),
	Patient_Surname			nvarchar(max),
	Patient_Department		nvarchar(max),
	Priority				nvarchar(max),
	Instructions			nvarchar(max),
	Status					nvarchar(max),
	Creator_Name			nvarchar(max),
	Creator_Surname			nvarchar(max),
	Creator_Department		nvarchar(max),
	TimeCreated				datetime2,
	TimeUpdated				datetime2,
	Responsible_Name		nvarchar(max),
	Responsible_Surname		nvarchar(max),
	Responsible_Department	nvarchar(max),
	Deletable				bit
)
AS
BEGIN
	IF (dbo.F_ValidateLanguage(@Language) = 1)
	BEGIN
		INSERT @TasksTab
			select t.ID, tt.Text, p.Name, p.Surname, p.Department, pt.Text, t.Instructions, s.Text, 
				per.Name, per.Surname, d.Department, t.TimeCreated, t.TimeUpdated, 
				per2.Name, per2.Surname, d2.Department, case st.Name when '%Status_New' then 1 when '%Status_Pending' then 1 else 0 end
			from dbo.Tasks t
				left join dbo.F_TaskTypes(@Language) tt on t.Type_ID = tt.ID
				left join dbo.F_Patients() p on t.Patient_ID = p.ID
				left join dbo.F_PriorityTypes(@Language) pt on t.Priority_ID = pt.ID
				left join dbo.F_StatusTypes(@Language) s on t.Status_ID = s.ID
				left join dbo.Personnel per on t.Creator_ID = per.ID
				left join dbo.Departments d on per.Department_ID = d.ID
				left join dbo.Personnel per2 on t.Responsible_ID = per2.ID
				left join dbo.Departments d2 on per2.Department_ID = d2.ID
				left join dbo.Statuses st on t.Status_ID = st.ID
			where t.Status_ID <> 5;

	END
	RETURN
END

GO
/****** Object:  Table [dbo].[Departments]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Department] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Dictionaries]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dictionaries](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Tag] [nvarchar](max) NOT NULL,
	[Language_ID] [int] NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Dictionaries] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NotificationTypes]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_NotificationTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PatientAdmission]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientAdmission](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Department_ID] [int] NOT NULL,
	[Date_From] [date] NOT NULL,
	[Date_Till] [date] NULL,
 CONSTRAINT [PK_PatientAdmission] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Patients]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Surname] [nvarchar](max) NOT NULL,
	[SocialNr] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Patients] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Personnel]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personnel](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Surname] [nvarchar](max) NOT NULL,
	[SocialNr] [nvarchar](max) NOT NULL,
	[Position_ID] [int] NOT NULL,
	[Department_ID] [int] NOT NULL,
	[Password] [nvarchar](max) NULL,
 CONSTRAINT [PK_Personnel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonnelRole]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonnelRole](
	[RoleID] [tinyint] NOT NULL,
	[PersonnelID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Positions]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Positions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Position] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Positions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PriorityTypes]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PriorityTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_PriorityTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Reports]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reports](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Task_ID] [int] NOT NULL,
	[Status_ID] [int] NOT NULL,
	[TimeAdded] [datetime2](7) NOT NULL,
	[Attachment] [nvarchar](max) NULL,
	[Comment] [nvarchar](max) NULL,
 CONSTRAINT [PK_Reports] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [tinyint] NOT NULL,
	[Name] [nchar](10) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Statuses]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statuses](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SupportedLanguages]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupportedLanguages](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Language] [nchar](2) NOT NULL,
 CONSTRAINT [PK_SupportedLanguages] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tasks]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tasks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Type_ID] [int] NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Priority_ID] [int] NOT NULL,
	[Instructions] [nvarchar](max) NULL,
	[Status_ID] [int] NOT NULL,
	[Creator_ID] [int] NOT NULL,
	[TimeCreated] [datetime2](7) NOT NULL,
	[Responsible_ID] [int] NULL,
	[TimeUpdated] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Tasks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaskTypes]    Script Date: 2/28/2014 1:00:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskTypes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[HasInstr] [bit] NOT NULL,
 CONSTRAINT [PK_TaskTypes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Departments] ON 

INSERT [dbo].[Departments] ([ID], [Department]) VALUES (1, N'G401')
INSERT [dbo].[Departments] ([ID], [Department]) VALUES (2, N'G402')
INSERT [dbo].[Departments] ([ID], [Department]) VALUES (3, N'G403')
INSERT [dbo].[Departments] ([ID], [Department]) VALUES (4, N'G404')
SET IDENTITY_INSERT [dbo].[Departments] OFF
SET IDENTITY_INSERT [dbo].[Dictionaries] ON 

INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1, N'%NotificationType_All', 1, N'All updates', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (2, N'%NotificationType_Complete', 1, N'When "Complete"', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (3, N'%NotificationType_InProcess', 1, N'When "In process"', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (4, N'%NotificationType_None', 1, N'None', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (5, N'%TaskType1', 1, N'Take blood samples for Blood Analysis', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (6, N'%TaskType2', 1, N'Take temperature', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (7, N'%TaskType3', 1, N'Vaccinate agaisnt', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (8, N'%PriorityType_High', 1, N'Important', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (9, N'%PriorityType_Medium', 1, N'Regular', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (10, N'%PriorityType_Low', 1, N'Not important', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (11, N'%Position_Doctor', 1, N'Doctor', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (12, N'%Position_HeadNurse', 1, N'HeadNurse', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (13, N'%Position_Nurse', 1, N'Nurse', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (14, N'%Status_New', 1, N'New', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (15, N'%Status_Pending', 1, N'Pending', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (16, N'%Status_InProcess', 1, N'In process', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (17, N'%Status_Waiting', 1, N'Waiting', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (18, N'%Status_Complete', 1, N'Complete', N'Internal')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (19, N'%ViewTasks_Title', 1, N'View Tasks', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (20, N'%CreateToDo_Title', 1, N'Create To-Do List', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (21, N'%NavBar_Add', 1, N'Todo List', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (22, N'%CreateToDo_SubmitBtn', 1, N'Create', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (23, N'%CreateToDo_PatientLabel', 1, N'Patient:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1022, N'%CreateToDo_IllegalInput_Msg', 1, N'Illegal input!', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1025, N'%CreateToDo_IllegalInput_Title', 1, N'Error', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1026, N'%NavBar_NumItems_Msg', 1, N'Number of tasks: ', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1027, N'%ViewTasks_Table_Priority', 1, N'Priority', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1028, N'%ViewTasks_Table_Title', 1, N'Title', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1029, N'%ViewTasks_Table_Instructions', 1, N'Instructions', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1030, N'%ViewTasks_Table_Status', 1, N'Status', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1031, N'%ViewTasks_Table_Created', 1, N'Created', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1032, N'%ViewTasks_Table_LstUpdated', 1, N'Last updated', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1033, N'%ViewTasks_Table_Responsible', 1, N'Responsible', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1034, N'%ViewTasks_Table_Actions', 1, N'Actions', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1035, N'%Report_Title', 1, N'Task Report', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1036, N'%Report_InvalidInput_Msg', 1, N'Invalid Input is provided!', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1037, N'%Report_Label_Title', 1, N'Title:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1038, N'%Report_Label_Instructions', 1, N'Instructions:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1039, N'%Report_Label_Patient', 1, N'Patient:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1040, N'%Report_Label_Created', 1, N'Created:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1041, N'%Report_Label_Modified', 1, N'Last updated:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1042, N'%Report_Label_Status', 1, N'Status:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1043, N'%Report_Label_Emergency', 1, N'Emergency', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1044, N'%Report_Label_Task', 1, N'Task #:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1045, N'%Error_Title', 1, N'Error', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1046, N'%Error_Msg', 1, N'An error occurred while processing your request', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1047, N'%TaskDetails_Title', 1, N'Task Details', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1048, N'%TaskDetails_PatientDetails', 1, N'Patient''s Details', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1049, N'%TaskDetails_Patient_Fname', 1, N'First Name:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1050, N'%TaskDetails_Patient_Lname', 1, N'Last Name:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1051, N'%TaskDetails_Patient_SocialNr', 1, N'Social number:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1052, N'%TaskDetails_Patient_Department', 1, N'Department', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1053, N'%TaskDetails_Responsible', 1, N'Responsible:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1054, N'%UserName_Lbl', 1, N'User Name:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1055, N'%Password_Lbl', 1, N'Password:', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1056, N'%Login_Btn', 1, N'Login', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1057, N'%UserName_PlHold', 1, N'Enter username', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1058, N'%Password_PlHold', 1, N'Enter password', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1059, N'%Login_Lbl', 1, N'Log In', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1060, N'%Logout_Lbl', 1, N'Log Out', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1061, N'%NavBar_Search', 1, N'Search', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1062, N'%NavBar_Follow', 1, N'Follow', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1063, N'%Nurse_Lbl', 1, N'Nurse', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1064, N'%Workload_Lbl', 1, N'Workload', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1065, N'%AssignRadio_Btn', 1, N'Assigned', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1066, N'%Assign_Btn', 1, N'Assign', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1067, N'%TaskAssignment_Title', 1, N'Task Assignment', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1068, N'%ActiveTask_Tab', 1, N'Active Tasks', N'External')
INSERT [dbo].[Dictionaries] ([ID], [Tag], [Language_ID], [Text], [Type]) VALUES (1069, N'%HistoryTask_Tab', 1, N'Patient History', N'External')
SET IDENTITY_INSERT [dbo].[Dictionaries] OFF
SET IDENTITY_INSERT [dbo].[NotificationTypes] ON 

INSERT [dbo].[NotificationTypes] ([ID], [Name], [Description]) VALUES (1, N'%NotificationType_All', N'All updates')
INSERT [dbo].[NotificationTypes] ([ID], [Name], [Description]) VALUES (2, N'%NotificationType_Complete', N'When "Complete"')
INSERT [dbo].[NotificationTypes] ([ID], [Name], [Description]) VALUES (3, N'%NotificationType_InProcess', N'When "In process"')
INSERT [dbo].[NotificationTypes] ([ID], [Name], [Description]) VALUES (4, N'%NotificationType_None', N'None')
SET IDENTITY_INSERT [dbo].[NotificationTypes] OFF
SET IDENTITY_INSERT [dbo].[PatientAdmission] ON 

INSERT [dbo].[PatientAdmission] ([ID], [Patient_ID], [Department_ID], [Date_From], [Date_Till]) VALUES (1, 1, 1, CAST(0x01380B00 AS Date), CAST(0x85380B00 AS Date))
INSERT [dbo].[PatientAdmission] ([ID], [Patient_ID], [Department_ID], [Date_From], [Date_Till]) VALUES (2, 2, 2, CAST(0x03380B00 AS Date), NULL)
INSERT [dbo].[PatientAdmission] ([ID], [Patient_ID], [Department_ID], [Date_From], [Date_Till]) VALUES (3, 3, 3, CAST(0x05380B00 AS Date), NULL)
INSERT [dbo].[PatientAdmission] ([ID], [Patient_ID], [Department_ID], [Date_From], [Date_Till]) VALUES (4, 6, 2, CAST(0x12380B00 AS Date), NULL)
INSERT [dbo].[PatientAdmission] ([ID], [Patient_ID], [Department_ID], [Date_From], [Date_Till]) VALUES (5, 7, 1, CAST(0x04380B00 AS Date), NULL)
SET IDENTITY_INSERT [dbo].[PatientAdmission] OFF
SET IDENTITY_INSERT [dbo].[Patients] ON 

INSERT [dbo].[Patients] ([ID], [Name], [Surname], [SocialNr]) VALUES (1, N'Dmitrijs', N'Rasjuks', N'860503-P114')
INSERT [dbo].[Patients] ([ID], [Name], [Surname], [SocialNr]) VALUES (2, N'Matīss', N'Bāliņš', N'881208-P110')
INSERT [dbo].[Patients] ([ID], [Name], [Surname], [SocialNr]) VALUES (3, N'Lulu', N'Marzan', N'850823-1642')
INSERT [dbo].[Patients] ([ID], [Name], [Surname], [SocialNr]) VALUES (6, N'Philip', N'Opuogen', N'871006-1111')
INSERT [dbo].[Patients] ([ID], [Name], [Surname], [SocialNr]) VALUES (7, N'Stanley', N'Theman', N'830715-8732')
SET IDENTITY_INSERT [dbo].[Patients] OFF
SET IDENTITY_INSERT [dbo].[Personnel] ON 

INSERT [dbo].[Personnel] ([ID], [Username], [Name], [Surname], [SocialNr], [Position_ID], [Department_ID], [Password]) VALUES (1, N'doc', N'John', N'Smith', N'650102-1452', 1, 1, N'202CB962AC59075B964B07152D234B70')
INSERT [dbo].[Personnel] ([ID], [Username], [Name], [Surname], [SocialNr], [Position_ID], [Department_ID], [Password]) VALUES (4, N'brownc', N'Caroline', N'Brown', N'781223-9861', 2, 1, N'444BCB3A3FCF8389296C49467F27E1D6')
INSERT [dbo].[Personnel] ([ID], [Username], [Name], [Surname], [SocialNr], [Position_ID], [Department_ID], [Password]) VALUES (6, N'atkinsonj', N'Julie', N'Atkinson', N'870812-9813', 3, 1, NULL)
INSERT [dbo].[Personnel] ([ID], [Username], [Name], [Surname], [SocialNr], [Position_ID], [Department_ID], [Password]) VALUES (7, N'johanssonm', N'Markus', N'Johansson', N'811101-4317', 3, 1, NULL)
INSERT [dbo].[Personnel] ([ID], [Username], [Name], [Surname], [SocialNr], [Position_ID], [Department_ID], [Password]) VALUES (8, N'rosss', N'Sandra', N'Ross', N'830304-5132', 3, 1, N'3EA73B209BB0A90CF6D32619E3AE8FEA')
INSERT [dbo].[Personnel] ([ID], [Username], [Name], [Surname], [SocialNr], [Position_ID], [Department_ID], [Password]) VALUES (9, N'N1', N'Jack', N'Black', N'666666-6666', 3, 1, NULL)
INSERT [dbo].[Personnel] ([ID], [Username], [Name], [Surname], [SocialNr], [Position_ID], [Department_ID], [Password]) VALUES (12, N'N2', N'John', N'wayne', N'777777-7777', 3, 1, NULL)
SET IDENTITY_INSERT [dbo].[Personnel] OFF
INSERT [dbo].[PersonnelRole] ([RoleID], [PersonnelID]) VALUES (1, 1)
INSERT [dbo].[PersonnelRole] ([RoleID], [PersonnelID]) VALUES (2, 8)
INSERT [dbo].[PersonnelRole] ([RoleID], [PersonnelID]) VALUES (3, 4)
INSERT [dbo].[PersonnelRole] ([RoleID], [PersonnelID]) VALUES (1, 1)
INSERT [dbo].[PersonnelRole] ([RoleID], [PersonnelID]) VALUES (3, 9)
INSERT [dbo].[PersonnelRole] ([RoleID], [PersonnelID]) VALUES (3, 12)
SET IDENTITY_INSERT [dbo].[Positions] ON 

INSERT [dbo].[Positions] ([ID], [Position], [Description]) VALUES (1, N'%Position_Doctor', N'Doctor')
INSERT [dbo].[Positions] ([ID], [Position], [Description]) VALUES (2, N'%Position_HeadNurse', N'Head nurse')
INSERT [dbo].[Positions] ([ID], [Position], [Description]) VALUES (3, N'%Position_Nurse', N'Nurse')
SET IDENTITY_INSERT [dbo].[Positions] OFF
SET IDENTITY_INSERT [dbo].[PriorityTypes] ON 

INSERT [dbo].[PriorityTypes] ([ID], [Name], [Description]) VALUES (1, N'%PriorityType_High', N'Important')
INSERT [dbo].[PriorityTypes] ([ID], [Name], [Description]) VALUES (2, N'%PriorityType_Medium', N'Regular')
INSERT [dbo].[PriorityTypes] ([ID], [Name], [Description]) VALUES (3, N'%PriorityType_Low', N'Not important')
SET IDENTITY_INSERT [dbo].[PriorityTypes] OFF
SET IDENTITY_INSERT [dbo].[Reports] ON 

INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (1, 17, 3, CAST(0x07A744BAC86311380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (2, 17, 3, CAST(0x07D92E4ADC6311380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (3, 17, 3, CAST(0x07F95EFAE86311380B AS DateTime2), N'c:\\test.txt', NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (4, 17, 3, CAST(0x076AD856F06311380B AS DateTime2), NULL, N'Nice')
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (5, 22, 3, CAST(0x0701DB333D6811380B AS DateTime2), NULL, N'I''m taking it')
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (6, 22, 3, CAST(0x0784EE2F766811380B AS DateTime2), NULL, N'Why')
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (7, 22, 1, CAST(0x077F3B03006911380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (8, 22, 5, CAST(0x07DEF3D1066911380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (9, 24, 5, CAST(0x07B84836A46911380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (10, 17, 4, CAST(0x079414A8AB6911380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (11, 27, 3, CAST(0x073E62F0EF7C11380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (12, 27, 3, CAST(0x07BEC6C6F67C11380B AS DateTime2), N'C:\Users\Italianboy\Desktop\CBS.log', NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (13, 27, 1, CAST(0x0756EAE9AB8011380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (14, 30, 5, CAST(0x075843E1CD8011380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (15, 33, 1, CAST(0x07A3D8E2F88011380B AS DateTime2), N'C:\Users\Italianboy\Desktop\CBS.log', NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (16, 37, 3, CAST(0x07F9C136789711380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (17, 17, 5, CAST(0x075EE75129B012380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (18, 36, 1, CAST(0x0718A3E51FBA12380B AS DateTime2), N'C:\Users\Italianboy\Desktop\CBS.log', NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (19, 64, 1, CAST(0x0733EB263D612A380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (20, 66, 1, CAST(0x078B9DEE22642A380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (21, 71, 5, CAST(0x07DD3D5F34BC2A380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (22, 37, 5, CAST(0x071DB55C39BC2A380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (23, 66, 4, CAST(0x073DDD3495BD2A380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (24, 65, 3, CAST(0x07CD2F3599BD2A380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (25, 67, 5, CAST(0x070D59C29DBD2A380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (26, 65, 3, CAST(0x07B41B7C71682B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (27, 65, 1, CAST(0x078F84C8CA682B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (28, 70, 3, CAST(0x07C29172CE682B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (29, 70, 5, CAST(0x0778A2D5F0682B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (30, 73, 2, CAST(0x078ECD25F4682B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (31, 73, 3, CAST(0x0717AA47F6682B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (32, 73, 2, CAST(0x07F26F7E4F6A2B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (33, 72, 4, CAST(0x07EAA8255D6A2B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (34, 70, 3, CAST(0x07922E2A1F702B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (35, 72, 2, CAST(0x0787D7A328712B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (36, 72, 4, CAST(0x0715C7D032712B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (37, 72, 2, CAST(0x0713CDF19E722B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (38, 78, 2, CAST(0x07B0360D20782B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (39, 87, 3, CAST(0x07E4158215922B380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (40, 73, 3, CAST(0x0786CBC6F67837380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (41, 73, 4, CAST(0x079C86FC74A139380B AS DateTime2), NULL, NULL)
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (42, 98, 3, CAST(0x0721D3A9F7A139380B AS DateTime2), NULL, N'dgdfgsdfg')
INSERT [dbo].[Reports] ([ID], [Task_ID], [Status_ID], [TimeAdded], [Attachment], [Comment]) VALUES (43, 75, 4, CAST(0x076D147F13183A380B AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Reports] OFF
INSERT [dbo].[Roles] ([Id], [Name]) VALUES (1, N'Doctor    ')
INSERT [dbo].[Roles] ([Id], [Name]) VALUES (2, N'Headnurse ')
INSERT [dbo].[Roles] ([Id], [Name]) VALUES (3, N'Nurse     ')
SET IDENTITY_INSERT [dbo].[Statuses] ON 

INSERT [dbo].[Statuses] ([ID], [Name], [Description]) VALUES (1, N'%Status_New', N'New')
INSERT [dbo].[Statuses] ([ID], [Name], [Description]) VALUES (2, N'%Status_Pending', N'Pending')
INSERT [dbo].[Statuses] ([ID], [Name], [Description]) VALUES (3, N'%Status_InProcess', N'In process')
INSERT [dbo].[Statuses] ([ID], [Name], [Description]) VALUES (4, N'%Status_Waiting', N'Waiting')
INSERT [dbo].[Statuses] ([ID], [Name], [Description]) VALUES (5, N'%Status_Complete', N'Complete')
SET IDENTITY_INSERT [dbo].[Statuses] OFF
SET IDENTITY_INSERT [dbo].[SupportedLanguages] ON 

INSERT [dbo].[SupportedLanguages] ([ID], [Language]) VALUES (1, N'En')
SET IDENTITY_INSERT [dbo].[SupportedLanguages] OFF
SET IDENTITY_INSERT [dbo].[Tasks] ON 

INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (17, 2, 3, 2, NULL, 5, 1, CAST(0x07143C2D270811380B AS DateTime2), 4, CAST(0x07143C2D270811380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (22, 2, 2, 1, NULL, 5, 1, CAST(0x07A22CBE362811380B AS DateTime2), NULL, CAST(0x07A22CBE362811380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (24, 3, 3, 2, N'flu', 5, 1, CAST(0x073A4C66F26711380B AS DateTime2), NULL, CAST(0x073A4C66F26711380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (30, 3, 2, 2, NULL, 5, 1, CAST(0x076646AC677B11380B AS DateTime2), 9, CAST(0x076646AC677B11380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (37, 1, 2, 3, N'150ml', 5, 1, CAST(0x07815CBA2B9711380B AS DateTime2), 12, CAST(0x07815CBA2B9711380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (67, 2, 2, 2, NULL, 5, 1, CAST(0x0710F338DE8629380B AS DateTime2), 9, CAST(0x0710F338DE8629380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (70, 3, 2, 2, NULL, 3, 1, CAST(0x07E09340DD8729380B AS DateTime2), 12, CAST(0x07E09340DD8729380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (71, 1, 2, 2, NULL, 5, 1, CAST(0x07203041DD8729380B AS DateTime2), 9, CAST(0x07203041DD8729380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (73, 2, 2, 2, NULL, 4, 1, CAST(0x07DD25F47EBD2A380B AS DateTime2), 12, CAST(0x07DD25F47EBD2A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (75, 1, 2, 2, NULL, 4, 1, CAST(0x07DD451328742B380B AS DateTime2), 12, CAST(0x07602FDF0F183A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (79, 3, 2, 2, NULL, 2, 1, CAST(0x07309D1828742B380B AS DateTime2), 9, CAST(0x07309D1828742B380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (82, 2, 2, 2, NULL, 2, 1, CAST(0x07B8D51928742B380B AS DateTime2), 4, CAST(0x07B8D51928742B380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (84, 3, 2, 2, NULL, 2, 1, CAST(0x07C8461C28742B380B AS DateTime2), 4, CAST(0x07C8461C28742B380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (85, 1, 2, 2, NULL, 2, 1, CAST(0x07FBBB1C28742B380B AS DateTime2), 4, CAST(0x07FBBB1C28742B380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (87, 1, 2, 2, NULL, 3, 1, CAST(0x0744068735902B380B AS DateTime2), 9, CAST(0x0744068735902B380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (88, 1, 2, 2, NULL, 1, 1, CAST(0x079EAF9F0B8C37380B AS DateTime2), NULL, CAST(0x079EAF9F0B8C37380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (89, 3, 2, 2, NULL, 1, 1, CAST(0x07CE24A00B8C37380B AS DateTime2), NULL, CAST(0x07CE24A00B8C37380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (90, 2, 2, 2, NULL, 1, 1, CAST(0x07EE72A00B8C37380B AS DateTime2), NULL, CAST(0x07EE72A00B8C37380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (91, 1, 2, 2, NULL, 1, 1, CAST(0x070EC1A00B8C37380B AS DateTime2), NULL, CAST(0x070EC1A00B8C37380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (92, 2, 3, 2, NULL, 1, 1, CAST(0x07B8370661A139380B AS DateTime2), NULL, CAST(0x07B8370661A139380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (93, 1, 3, 2, NULL, 1, 1, CAST(0x07F84E1761A139380B AS DateTime2), NULL, CAST(0x07F84E1761A139380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (94, 3, 3, 2, NULL, 1, 1, CAST(0x0712E71961A139380B AS DateTime2), NULL, CAST(0x0712E71961A139380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (95, 1, 6, 1, NULL, 1, 1, CAST(0x0757945391A139380B AS DateTime2), NULL, CAST(0x0757945391A139380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (96, 3, 2, 2, NULL, 1, 1, CAST(0x07EB95739BA139380B AS DateTime2), NULL, CAST(0x07EB95739BA139380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (97, 1, 2, 2, NULL, 1, 1, CAST(0x07F406769BA139380B AS DateTime2), NULL, CAST(0x07F406769BA139380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (98, 1, 2, 2, NULL, 3, 1, CAST(0x07EC50789BA139380B AS DateTime2), NULL, CAST(0x07EC50789BA139380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (103, 2, 1, 2, NULL, 1, 1, CAST(0x07157D550C893A380B AS DateTime2), NULL, CAST(0x07157D550C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (104, 2, 1, 2, NULL, 1, 1, CAST(0x07F3646A0C893A380B AS DateTime2), NULL, CAST(0x07F3646A0C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (105, 2, 1, 2, NULL, 1, 1, CAST(0x07F51F6F0C893A380B AS DateTime2), NULL, CAST(0x07F51F6F0C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (106, 2, 1, 2, NULL, 1, 1, CAST(0x07166E6F0C893A380B AS DateTime2), NULL, CAST(0x07166E6F0C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (107, 2, 1, 2, NULL, 1, 1, CAST(0x0737BC6F0C893A380B AS DateTime2), NULL, CAST(0x0737BC6F0C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (108, 2, 1, 2, NULL, 1, 1, CAST(0x0748E36F0C893A380B AS DateTime2), NULL, CAST(0x0748E36F0C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (109, 2, 1, 2, NULL, 1, 1, CAST(0x077B13750C893A380B AS DateTime2), NULL, CAST(0x077B13750C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (110, 2, 1, 2, NULL, 1, 1, CAST(0x078C3A750C893A380B AS DateTime2), NULL, CAST(0x078C3A750C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (111, 2, 1, 2, NULL, 1, 1, CAST(0x078584770C893A380B AS DateTime2), NULL, CAST(0x078584770C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (112, 2, 1, 2, NULL, 1, 1, CAST(0x07A6D2770C893A380B AS DateTime2), NULL, CAST(0x07A6D2770C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (113, 2, 1, 2, NULL, 1, 1, CAST(0x07C720780C893A380B AS DateTime2), NULL, CAST(0x07C720780C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (114, 2, 1, 2, NULL, 1, 1, CAST(0x07D747780C893A380B AS DateTime2), NULL, CAST(0x07D747780C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (115, 2, 1, 2, NULL, 1, 1, CAST(0x07F995780C893A380B AS DateTime2), NULL, CAST(0x07F995780C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (116, 2, 1, 2, NULL, 1, 1, CAST(0x073B32790C893A380B AS DateTime2), NULL, CAST(0x073B32790C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (117, 2, 1, 2, NULL, 1, 1, CAST(0x0702077B0C893A380B AS DateTime2), NULL, CAST(0x0702077B0C893A380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (118, 2, 7, 2, NULL, 1, 1, CAST(0x0715FCE857083B380B AS DateTime2), NULL, CAST(0x0715FCE857083B380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (119, 1, 7, 2, NULL, 1, 1, CAST(0x074771E957083B380B AS DateTime2), NULL, CAST(0x074771E957083B380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (120, 1, 7, 2, NULL, 1, 1, CAST(0x070690ED57083B380B AS DateTime2), NULL, CAST(0x070690ED57083B380B AS DateTime2))
INSERT [dbo].[Tasks] ([ID], [Type_ID], [Patient_ID], [Priority_ID], [Instructions], [Status_ID], [Creator_ID], [TimeCreated], [Responsible_ID], [TimeUpdated]) VALUES (121, 2, 7, 2, NULL, 1, 1, CAST(0x0727DEED57083B380B AS DateTime2), NULL, CAST(0x0727DEED57083B380B AS DateTime2))
SET IDENTITY_INSERT [dbo].[Tasks] OFF
SET IDENTITY_INSERT [dbo].[TaskTypes] ON 

INSERT [dbo].[TaskTypes] ([ID], [Name], [Description], [HasInstr]) VALUES (1, N'%TaskType1', N'Take blood samples for Blood Analysis', 1)
INSERT [dbo].[TaskTypes] ([ID], [Name], [Description], [HasInstr]) VALUES (2, N'%TaskType2', N'Take temperature', 0)
INSERT [dbo].[TaskTypes] ([ID], [Name], [Description], [HasInstr]) VALUES (3, N'%TaskType3', N'Vaccinate agaisnt ', 1)
SET IDENTITY_INSERT [dbo].[TaskTypes] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_SupportedLanguages]    Script Date: 2/28/2014 1:00:04 PM ******/
ALTER TABLE [dbo].[SupportedLanguages] ADD  CONSTRAINT [UK_SupportedLanguages] UNIQUE NONCLUSTERED 
(
	[Language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictionaries] ADD  CONSTRAINT [DF_Dictionaries_Type]  DEFAULT ('External') FOR [Type]
GO
ALTER TABLE [dbo].[Reports] ADD  CONSTRAINT [DF_Reports_TimeAdded]  DEFAULT (sysdatetime()) FOR [TimeAdded]
GO
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_Priority_ID]  DEFAULT ((2)) FOR [Priority_ID]
GO
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_TimeCreated]  DEFAULT (sysdatetime()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Tasks] ADD  CONSTRAINT [DF_Tasks_TimeUpdated]  DEFAULT (sysdatetime()) FOR [TimeUpdated]
GO
ALTER TABLE [dbo].[TaskTypes] ADD  CONSTRAINT [DF_TaskTypes_HasInstr]  DEFAULT ((0)) FOR [HasInstr]
GO
ALTER TABLE [dbo].[Dictionaries]  WITH CHECK ADD  CONSTRAINT [FK_Dictionaries_SupportedLanguages] FOREIGN KEY([Language_ID])
REFERENCES [dbo].[SupportedLanguages] ([ID])
GO
ALTER TABLE [dbo].[Dictionaries] CHECK CONSTRAINT [FK_Dictionaries_SupportedLanguages]
GO
ALTER TABLE [dbo].[PatientAdmission]  WITH CHECK ADD  CONSTRAINT [FK_PatientAdmission_Departments] FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Departments] ([ID])
GO
ALTER TABLE [dbo].[PatientAdmission] CHECK CONSTRAINT [FK_PatientAdmission_Departments]
GO
ALTER TABLE [dbo].[PatientAdmission]  WITH CHECK ADD  CONSTRAINT [FK_PatientAdmission_Patients] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patients] ([ID])
GO
ALTER TABLE [dbo].[PatientAdmission] CHECK CONSTRAINT [FK_PatientAdmission_Patients]
GO
ALTER TABLE [dbo].[Personnel]  WITH CHECK ADD  CONSTRAINT [FK_Personnel_Departments] FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Departments] ([ID])
GO
ALTER TABLE [dbo].[Personnel] CHECK CONSTRAINT [FK_Personnel_Departments]
GO
ALTER TABLE [dbo].[Personnel]  WITH CHECK ADD  CONSTRAINT [FK_Personnel_Positions] FOREIGN KEY([Position_ID])
REFERENCES [dbo].[Positions] ([ID])
GO
ALTER TABLE [dbo].[Personnel] CHECK CONSTRAINT [FK_Personnel_Positions]
GO
ALTER TABLE [dbo].[PersonnelRole]  WITH CHECK ADD FOREIGN KEY([PersonnelID])
REFERENCES [dbo].[Personnel] ([ID])
GO
ALTER TABLE [dbo].[PersonnelRole]  WITH CHECK ADD FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[Reports]  WITH CHECK ADD  CONSTRAINT [FK_Reports_Tasks] FOREIGN KEY([Status_ID])
REFERENCES [dbo].[Statuses] ([ID])
GO
ALTER TABLE [dbo].[Reports] CHECK CONSTRAINT [FK_Reports_Tasks]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Patients] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patients] ([ID])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Patients]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Personnel_Creator] FOREIGN KEY([Creator_ID])
REFERENCES [dbo].[Personnel] ([ID])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Personnel_Creator]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Personnel_Responsible] FOREIGN KEY([Responsible_ID])
REFERENCES [dbo].[Personnel] ([ID])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Personnel_Responsible]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_PriorityTypes] FOREIGN KEY([Priority_ID])
REFERENCES [dbo].[PriorityTypes] ([ID])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_PriorityTypes]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Statuses] FOREIGN KEY([Status_ID])
REFERENCES [dbo].[Statuses] ([ID])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Statuses]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_TaskTypes] FOREIGN KEY([Type_ID])
REFERENCES [dbo].[TaskTypes] ([ID])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_TaskTypes]
GO
ALTER TABLE [dbo].[Dictionaries]  WITH CHECK ADD  CONSTRAINT [CK_Dictionaries_Type] CHECK  (([Type]='External' OR [Type]='Internal'))
GO
ALTER TABLE [dbo].[Dictionaries] CHECK CONSTRAINT [CK_Dictionaries_Type]
GO
ALTER TABLE [dbo].[PatientAdmission]  WITH CHECK ADD  CONSTRAINT [CK_PatientAdmission_DateTill] CHECK  (([Date_Till]>[Date_From]))
GO
ALTER TABLE [dbo].[PatientAdmission] CHECK CONSTRAINT [CK_PatientAdmission_DateTill]
GO
ALTER TABLE [dbo].[Patients]  WITH CHECK ADD  CONSTRAINT [CK_Patients_SocialNr] CHECK  (([SocialNr] like '[0-9][0-9][0-9][0-9][0-9][0-9]-[P0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Patients] CHECK CONSTRAINT [CK_Patients_SocialNr]
GO
ALTER TABLE [dbo].[Personnel]  WITH CHECK ADD  CONSTRAINT [CK_Personnel_SocialNr] CHECK  (([SocialNr] like '[0-9][0-9][0-9][0-9][0-9][0-9]-[P0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Personnel] CHECK CONSTRAINT [CK_Personnel_SocialNr]
GO
USE [master]
GO
ALTER DATABASE [HMS] SET  READ_WRITE 
GO
