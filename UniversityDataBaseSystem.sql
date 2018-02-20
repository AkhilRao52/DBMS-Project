
/* 1. Design Modifications:  a) Changed the grade to optional field in StudentsAndCourses table.
							 b) Inserted Street 1, Street 2 fields instead of House Number and replaced local and Home Address tables with a common table( Address ).
							 c) Added lookup tables for Semester and Benefits.
							 d) Altered Prerequisite table.
							 e) To improve readable quality, I changed some table and column names.		*/





/* 2. Creation Of Tables : */


CREATE TABLE Persons (
	PersonID	INTEGER			PRIMARY KEY			IDENTITY(1,1),
	FirstName	VARCHAR(50)		NOT NULL,
	MiddleName	VARCHAR(20),	
	LastName	VARCHAR(50)		NOT NULL,     
	NtID		VARCHAR(20)		NOT NULL,			
	SSN			CHAR(9),	
);	



CREATE TABLE AddressType (
	AddressTypeID	INTEGER		 PRIMARY KEY		IDENTITY(1,1),
	AddressType		VARCHAR(15)	 NOT NULL,
);



CREATE TABLE Address (
	PersonID	   INTEGER		 PRIMARY KEY		REFERENCES Persons(PersonID),
	Street1		   VARCHAR(200)  NOT NULL,
	Street2		   VARCHAR(100),
	City		   VARCHAR(50)	 NOT NULL,
	State		   VARCHAR(50)	 NOT NULL,
	Country		   VARCHAR(50)	 NOT NULL,
	ZIPCode		   CHAR(5)		 NOT NULL,
	AddressTypeID  INTEGER		 NOT NULL			REFERENCES AddressType(AddressTypeID),
);	 		




CREATE TABLE StudentStatus (
	StudentStatusID		INTEGER		 PRIMARY KEY		IDENTITY(1,1),
	StatusText			VARCHAR(50)  NOT NULL,
);		




CREATE TABLE Students (
	StudentID		INTEGER		PRIMARY KEY		IDENTITY(1,1),
	PersonID		INTEGER		NOT NULL		REFERENCES Persons(PersonID),
	StudentPassword VARCHAR(50) NOT NULL,
	StudentStatusID INTEGER		NOT NULL		REFERENCES StudentStatus(StudentStatusID),
	DateOfBirth		DATE		NOT NULL,
);			




CREATE TABLE College (
	CollegeID		INTEGER		PRIMARY KEY		IDENTITY(1,1),
	CollegeName		VARCHAR(50) NOT NULL,
);			




CREATE TABLE MajorAndMinor (
	SubjectID	 INTEGER		PRIMARY KEY		IDENTITY(1,1),
	IsMajor		 CHAR(1)		NOT NULL,
	ProgramName	 VARCHAR(50)    NOT NULL,
	CollegeID	 INTEGER		NOT NULL		REFERENCES College(CollegeID),
);




CREATE TABLE StudentMajorAndMinor (
	StudentID	INTEGER		REFERENCES Students(StudentID),
	SubjectID	INTEGER		REFERENCES MajorAndMinor(SubjectID),
	PRIMARY KEY(StudentID,SubjectID),
);




CREATE TABLE BenefitsSelected (
	BenefitsSelectionID		INTEGER		 PRIMARY KEY		IDENTITY(1,1),
	BenefitsSelected		VARCHAR(100) NOT NULL,
);			




CREATE TABLE Benefits (
	BenefitTypeID		INTEGER		 PRIMARY KEY	IDENTITY(1,1),
	BenefitCost			DECIMAL(6,2) NOT NULL,
	BenefitsSelected    INTEGER		 NOT NULL		REFERENCES BenefitsSelected(BenefitsSelectionID),
	BenefitsDescription VARCHAR(200),
);




CREATE TABLE EmployeeStatus (
	EmployeeStatusID	INTEGER		    PRIMARY KEY		IDENTITY(1,1),
	StatusText			VARCHAR(20)		NOT NULL,
);




CREATE TABLE JobInformation (
	JobID			INTEGER		  PRIMARY KEY		IDENTITY(1,1),
	JobTitle		VARCHAR(100)  NOT NULL,
	JobDescription	VARCHAR(200)  NOT NULL,
	MinPay			DECIMAL(7,2)  NOT NULL,
	MaxPay			DECIMAL(8,2)  NOT NULL,
	IsUnionJob		CHAR(1)		  NOT NULL,
);	




CREATE TABLE Employees (
	EmployeeID		INTEGER		 PRIMARY KEY	IDENTITY(1,1),
	PersonID		INTEGER		 NOT NULL		REFERENCES Persons(PersonID),
	EmployeeStatus	INTEGER		 NOT NULL		REFERENCES EmployeeStatus(EmployeeStatusID),
	YearlyPay		DECIMAL(8,2) NOT NULL,		
	HealthBenefits	INTEGER		 NOT NULL		REFERENCES Benefits(BenefitTypeID),
	VisionBenefits	INTEGER		 NOT NULL		REFERENCES Benefits(BenefitTypeID),
	DentalBenefits  INTEGER		 NOT NULL		REFERENCES Benefits(BenefitTypeID),
	JobInformation  INTEGER      NOT NULL       REFERENCES JobInformation(JobID),
);			




CREATE TABLE JobRequirements (
	RequirementID	INTEGER		 PRIMARY KEY		IDENTITY(1,1),
	Description		VARCHAR(100) NOT NULL,
);		



		
CREATE TABLE JobAndRequirements (
	JobID		  INTEGER		 REFERENCES JobInformation(JobID),
	RequirementID INTEGER		 REFERENCES JobRequirements(RequirementID),
	PRIMARY KEY(JobID , RequirementID),
);		 	




CREATE TABLE OtherEquipment (
	EquipmentID   INTEGER		PRIMARY KEY		IDENTITY(1,1),
	EquipmentName VARCHAR(50)	NOT NULL,
	Description   VARCHAR(100),
);			   
	 	




CREATE TABLE ProjectorType (
	ProjectorTypeID   INTEGER	    PRIMARY KEY		IDENTITY(1,1),
	Description		  VARCHAR(100),
);		




CREATE TABLE Building (
	BuildingID		INTEGER		  PRIMARY KEY		IDENTITY(1,1),
	BuildingName	VARCHAR(100)  NOT NULL,
);




CREATE TABLE ClassRooms (
	ClassRoomID		       INTEGER  	PRIMARY KEY		IDENTITY(1,1),
	Building			   INTEGER		NOT NULL		REFERENCES Building(BuildingID),
	RoomNumber		       VARCHAR(5)   NOT NULL,
	MaximumSeatingCapacity INTEGER		NOT NULL,
	ProjectorType		   INTEGER		NOT NULL		REFERENCES ProjectorType(ProjectorTypeID),
	NumberOfWhiteBoards    INTEGER      NOT NULL,
);		  		



CREATE TABLE ClassRoomAndItsEquipment (
	ClassRoomID		INTEGER		REFERENCES ClassRooms(ClassRoomID),
    EquipmentID		INTEGER		REFERENCES OtherEquipment(EquipmentID),
	PRIMARY KEY(ClassRoomID , EquipmentID),
);



CREATE TABLE DayOfWeek (
	DayID		INTEGER			PRIMARY KEY			IDENTITY(1,1),
	Text		VARCHAR(10)		NOT NULL,
);



CREATE TABLE Course (
	CourseCode		VARCHAR(10),
	CourseNumber	INTEGER,
	CourseTitle		VARCHAR(100)		NOT NULL,
	Description		VARCHAR(200),
	PRIMARY KEY (CourseCode , CourseNumber),
);



CREATE TABLE CourseAndPrerequisites (
	CourseCode			VARCHAR(10),
	CourseNumber		INTEGER,
	PrerequisiteCode	VARCHAR(10),
	PrerequisiteNumber	INTEGER,
	PRIMARY KEY(CourseCode , CourseNumber , PrerequisiteCode , PrerequisiteNumber),
	FOREIGN KEY(CourseCode , CourseNumber)			   REFERENCES Course(CourseCode , CourseNumber),
	FOREIGN KEY(PrerequisiteCode , PrerequisiteNumber) REFERENCES Course(CourseCode , CourseNumber),
);




CREATE TABLE CourseAndFaculty (
	CourseFacultyID		INTEGER		PRIMARY KEY		IDENTITY(1,1),
	CourseCode			VARCHAR(10) NOT NULL,
	CourseNumber		INTEGER		NOT NULL,
	FacultyID			INTEGER		NOT NULL		REFERENCES Employees(EmployeeID),
	ClassRoomID			INTEGER		NOT NULL		REFERENCES ClassRooms(ClassRoomID),
	NumberOfSeats		INTEGER		NOT NULL,
	FOREIGN KEY(CourseCode , CourseNumber)			REFERENCES Course(CourseCode , CourseNumber),
);




CREATE TABLE CourseTimings (
	CourseTimingID		INTEGER		PRIMARY KEY		IDENTITY(1,1),
	CourseCode			VARCHAR(10) NOT NULL,
	CourseNumber		INTEGER		NOT NULL,
	Day					INTEGER		NOT NULL		REFERENCES DayOfWeek(DayID),
	StartTime			TIME		NOT NULL,
	EndTime				TIME		NOT NULL,
	FOREIGN KEY(CourseCode , CourseNumber)			REFERENCES Course(CourseCode , CourseNumber),
);



CREATE TABLE CourseStatus (
	CourseStatusID		INTEGER			PRIMARY KEY			IDENTITY(1,1),
	CourseStatus		VARCHAR(50)		NOT NULL,
);



CREATE TABLE StudentGrade (
	GradeID			INTEGER			PRIMARY KEY		IDENTITY(1,1),
	Grade			VARCHAR(3)		NOT NULL,
);



CREATE TABLE SemesterText (
	SemesterTextID		INTEGER		  PRIMARY KEY		IDENTITY(1,1),
	SemesterText		VARCHAR(100)  NOT NULL,
);				



CREATE TABLE SemesterInformation (
	SemesterID		 INTEGER		PRIMARY KEY		IDENTITY(1,1),
	Semester		 INTEGER		NOT NULL		REFERENCES SemesterText(SemesterTextID),
	Year			 CHAR(4)		NOT NULL,
	FirstDayOfClass  DATE			NOT NULL,
	LastDayOfClass	 DATE			NOT NULL,
);			



CREATE TABLE StudentsAndCourses (
	StudentID		INTEGER		REFERENCES Students(StudentID),
	CourseCode		VARCHAR(10) NOT NULL,
	CourseNumber	INTEGER		NOT NULL,
	CourseStatus	INTEGER		NOT NULL							REFERENCES CourseStatus(CourseStatusID),
	Grade			INTEGER		REFERENCES StudentGrade(GradeID),
	Semester		INTEGER		NOT NULL							REFERENCES SemesterInformation(SemesterID),
	PRIMARY KEY (StudentID , CourseCode , CourseNumber),
	FOREIGN KEY (CourseCode , CourseNumber)							REFERENCES Course(CourseCode , CourseNumber),
);				








/* 3. Loading data into Tables: */





INSERT INTO Persons ( FirstName , MiddleName , LastName , NtID , SSN)
	VALUES ( 'Rob'     ,  'Jason' , 'Taylor' , 'rtaylor@su.edu'   , 578831927),
		   ( 'James'   ,   NULL   , 'Muller' , 'jmuller01@su.edu' , 684891982),
		   ( 'Samwell' ,   NULL   , 'Brooks' , 'sbrooks@su.edu'   , 845324201),
		   ( 'Steve'   , 'Harley' , 'Smith'  , 'ssmith@su.edu'    , 645910216),
		   ( 'Todd'    ,   NULL   ,'Ferguson', 'tferguson@su.edu' , 321064572),
		   ( 'Jon'	   ,   NULL	  , 'Miller' , 'jmiller@su.edu'   , 210346478),
		   ( 'Liam'    , 'David'  ,'Anderson', 'ldanderson@su.edu',   NULL   ),
		   ( 'Sophia'  ,   NULL   , 'Davis'  , 'sdavis7@su.edu'   , 732567890),
		   ( 'Emma'    ,  'Lee'   ,'Thompson', 'elthompson@su.edu',   NULL   ),
		   ( 'Jacob'   , 'Edward' , 'Clark'  , 'jclark@su.edu'    , 984818919),
		   ( 'Ethan'   ,   NULL   , 'Baker'  , 'ebaker@su.edu'    ,   NULL   ),
           ( 'Alex'    ,   NULL   , 'Hall'   , 'ahall@su.edu'     ,   NULL   ),
		   ( 'Michael' ,   NULL   , 'Nelson' , 'mnelson@su.edu'   , 823456125),
		   ( 'Mia'     ,   NULL   , 'Jackson', 'mjackson@su.edu'  ,   NULL   );



 INSERT INTO AddressType ( AddressType )
	 VALUES ( 'Home' ),
			( 'Local');	 

			

 INSERT INTO Address ( PersonID , Street1 , Street2 , City , State , Country , ZIPCode , AddressTypeID)
	VALUES ( 1  , '412JamesStreet'  , 'Apartment6'  , 'Syracuse' , 'NewYork' , 'USA' , 13250 , 2 ),
		   ( 2  , '1028AvandellAve' ,     NULL	    , 'Syracuse' , 'NewYork' , 'USA' , 13201 , 2 ),
		   ( 3  , '333ClevelandAve'	,     NULL      ,'JerseyCity','NewJersey', 'USA' , 02110 , 1 ),
		   ( 4  , '505StolcomRoad'  , 'Apartemnt2'  , 'Syracuse' , 'NewYork' , 'USA' , 13210 , 2 ),
		   ( 5  ,'312WestcottStreet', 'Apartment3'  , 'Syracuse' , 'NewYork' , 'USA' , 13215 , 2 ),
		   ( 6  ,  '415EuclidAve'   ,     NULL      , 'Syracuse' , 'NewYork' , 'USA' , 13217 , 2 ),
		   ( 7  ,   '721NobHill'	, 'Apartment4'  , 'Syracuse' , 'NewYork' , 'USA' , 13278 , 2 ),
		   ( 8  , '1073WaltonRoad'	,     NULL      , 'Langhorn' ,  'Ohio'   , 'USA' , 21058 , 1 ),
		   ( 9  ,'165NormanStreet'  ,	  NULL      , 'Syracuse' , 'NewYork' , 'USA' , 13248 , 2 ),
		   ( 10 ,'740WestcottStreet',     NULL      , 'Syracuse' , 'NewYork' , 'USA' , 13215 , 2 ),
		   ( 11 ,'158LincolnStreet' , 'Apartment2'  ,  'Chicago' , 'Illinois', 'USA' , 31548 , 1 ),
		   ( 12 ,'1098WashingtonAve',     NULL      , 'Syracuse' , 'NewYork' , 'USA' , 13265 , 1 ),
		   ( 13 , '333JordanStreet' ,     NULL      , 'Syracuse' , 'NewYork' , 'USA' , 13241 , 2 ),
		   ( 14 , '212AvandellAve'  , 'Apartment1'  , 'Syracuse' , 'NewYork' , 'USA' , 13254 , 2 );    



INSERT INTO StudentStatus ( StatusText )
	VALUES ( 'UnderGraduate'  ),
		   (    'Graduate'    ),
		   ('Non-Matriculated'),
		   (    'Graduated'   );	



INSERT INTO Students ( PersonID , StudentPassword , StudentStatusID , DateOfBirth )
	VALUES ( 7 , 'CrazyBullDog' , 3 , '1991-06-20' ),
		   ( 8 ,   'Password'   , 1 , '1994-10-24' ),
		   ( 9 ,  'Salomon123'  , 2 , '1990-05-06' ),
		   ( 10,  'PowerfulPug'	, 4 , '1984-07-15' ),
		   ( 11,   'RandomPwd' 	, 1 , '1995-02-14' ),
		   ( 12, 'KingAndQueen' , 3 , '1989-04-26' ),
		   ( 13,   'UserName'   , 4 , '1980-01-01' ),
		   ( 14, 'DevineNation' , 2 , '1992-08-09' );



INSERT INTO College ( CollegeName )
	VALUES ( 'CollegeOfEngineering'  ),
		   (    'MedicalCollege'	 ),
		   ('CollegeOfArtsandScience');



INSERT INTO MajorAndMinor ( IsMajor , ProgramName , CollegeID )
	VALUES ( 'Y' ,'ComputerEngineering', 1 ),
		   ( 'Y' ,'ComputerScience', 1 ),
		   ( 'N' ,'ElectricalEngineering', 1 ),
		   ( 'Y' , 'MicroBiology'   , 2 ),
		   ( 'N' ,   'Pathology'    , 2 ),
		   ( 'Y' ,   'Sociology'    , 3 ),
		   ( 'N' ,'PoliticalScience', 3 );
		  


INSERT INTO StudentMajorAndMinor ( StudentID , SubjectID )
	VALUES ( 1 ,  6   ),
		   ( 2 ,  1   ),
		   ( 3 ,  2   ),
		   ( 4 ,  4   ),
		   ( 5 ,  1   ),
		   ( 6 ,  2   ), 
		   ( 7 ,  6   ),
		   ( 8 ,  4   );
		  


INSERT INTO BenefitsSelected ( BenefitsSelected )
	VALUES ( 'HealthBenefits(Single)'  ),
	       ( 'HealthBenefits(Family)'  ),
	       ( 'HealthBenefits(OptedOut)'),
		   ( 'VisionBenefits(Single)'  ),
		   ( 'VisionBenefits(Family)'  ),
		   ( 'VisionBenefits(OptedOut)'),
		   ( 'DentalBenefits(Single)'  ),
		   ( 'DentalBenefits(Family)'  ),
		   ( 'DentalBenefits(OptedOut)');



INSERT INTO Benefits ( BenefitCost , BenefitsSelected , BenefitsDescription )
	VALUES ( 1500 , 1 , NULL ),
		   ( 2000 , 2 , NULL ),
		   (    0 , 3 , 'OptedOutOfAllHealthBenefits'),
		   (  500 , 4 , NULL ),
		   (  700 , 5 , NULL ),
		   (    0 , 6 , 'OptedOutOfAllVisionBenefits'),
		   (  700 , 7 , NULL ),
		   ( 1000 , 8 , NULL ),
		   (    0 , 9 , 'OptedOutOfAllDentalBenefits');  



INSERT INTO EmployeeStatus ( StatusText )
	VALUES ( 'Active' ),
		   ('Inactive');



INSERT INTO JobInformation ( JobTitle , JobDescription , MinPay , MaxPay , IsUnionJob )
	VALUES ( 'Professor'		  , ' Must be able to develop syllabi for the classes he/she teaches and Minimum experience of 4 years in research and must be a part of ongoing reasearch' , 95000 , 300000 , 'Y' ),
		   ( 'AssociateProfessor' , ' Must be able to develop syllabi for the classes he/she teaches and Minimum experience of 2 years in research and must be a part of ongoing reasearch' , 70000 , 200000 , 'Y' ), 
		   ( 'AssistantProfessor' , ' Must be able to develop syllabi for the classes he/she teaches. No need of any research experience but must be a part of ongoing reasearch' , 54000 , 100000 , 'Y' ),
		   ( 'TeachingAssistant'  , ' He/She must help the Instructor of a particular class with the coursework. Can be a MS/Ph.D student(Preferrably Ph.D Student)' , 20000 , 50000 , 'N' ); 



INSERT INTO Employees ( PersonID , EmployeeStatus , YearlyPay , HealthBenefits , VisionBenefits , DentalBenefits , JobInformation )
	VALUES ( 1 , 1 , 80000 , 1 , 4 , 9 , 2 ),
		   ( 2 , 1 , 150000, 2 , 5 , 8 , 1 ),
		   ( 3 , 1 , 60000 , 3 , 6 , 9 , 3 ),
		   ( 4 , 1 , 200000, 1 , 4 , 7 , 1 ),
		   ( 5 , 1 , 54000 , 2 , 5 , 9 , 3 ),
		   ( 6 , 2 ,     0 , 3 , 6 , 9 , 2 );



INSERT INTO JobRequirements ( Description )
	VALUES ( 'Need minimum experience of 4 years in the field of research'),
		   ( 'Need minimum experience of 2 years in the field of research'),
		   ( 'No need of any research experience but must be a part of ongoing reasearch'),
		   ( ' Must be an active MS/Ph.D student' );



INSERT INTO JobAndRequirements ( JobID , RequirementID )
	VALUES ( 1 , 1 ),
		   ( 2 , 2 ),
		   ( 3 , 3 ),
		   ( 4 , 4 );



INSERT INTO OtherEquipment ( EquipmentName , Description )
	VALUES ( 'Microphone' , NULL ),
		   (  'Speakers' ,  NULL ),
		   (   'Camera'  , 'Can be used to record lectures' ),
		   (  'Computer' , NULL  );



INSERT INTO ProjectorType ( Description )
	VALUES ( 'ShortThrowProjector' ),
		   (  'PowerliteProjector' ),
		   (   'LaserProjector'    );

 

INSERT INTO Building ( BuildingName )
	VALUES ( ' CentreForScienceAndTechnology '),
		   (  'BowneHall'  ),
		   (  'MaxwellHall'  ); 
		   
		  

INSERT INTO ClassRooms ( Building , RoomNumber , MaximumSeatingCapacity , ProjectorType , NumberOfWhiteBoards )
	VALUES ( 1 , 101 , 120 , 3 , 3 ),
		   ( 1 , 102 ,  80 , 1 , 2 ),
		   ( 1 , 103 , 100 , 3 , 2 ),
		   ( 2 , 201 ,  60 , 2 , 1 ),
		   ( 2 , 202 ,  70 , 1 , 1 ),
		   ( 3 , 301 ,  90 , 3 , 2 ),
		   ( 3 , 302 , 110 , 2 , 2 );  
		   
		   

INSERT INTO ClassRoomAndItsEquipment ( ClassRoomID , EquipmentID )
	VALUES ( 1 , 1 ),
		   ( 1 , 2 ),
		   ( 1 , 3 ),
		   ( 1 , 4 ),
		   ( 2 , 1 ),
		   ( 2 , 2 ),
		   ( 2 , 4 ),
		   ( 3 , 1 ),
		   ( 3 , 2 ),
		   ( 3 , 4 ),
		   ( 4 , 4 ),
		   ( 5 , 1 ),
		   ( 5 , 2 ),
		   ( 6 , 1 ),
		   ( 6 , 2 ),
		   ( 6 , 3 ),
		   ( 6 , 4 ),
		   ( 7 , 4 );		
		   
		   

INSERT INTO DayOfWeek ( Text )
	VALUES ( 'Monday'  ),
		   ( 'Tuesday' ),
		   ('Wednesday'),
		   ( 'Thursday'),
		   ( 'Friday'  );
		   		   	    	 	
					
								
INSERT INTO Course ( CourseCode , CourseNumber , CourseTitle , Description )
	VALUES ( 'CSE' , 581 , 'DataBaseManagementSystem' , NULL ),
		   ( 'CSE' , 631 ,   'ObjectOrientedDesign'   , NULL ),
		   ( 'CSE' , 615 ,   'ComputerArchitecture'   , NULL ),
		   ( 'CIS' , 675 , 'Algorithms' ,'In this course, you learn how design efficient Algorithms'),
		   ( 'CIS' , 621 , 'Mathematical Computation' , NULL ),
		   ( 'CIS' , 637 ,   'Structuredprogramming'  , NULL ),
		   (  'EE' , 515 ,    'RobotProgramming'      , NULL ),
		   (  'MB' , 689 ,   'MicrobialDiversity'     , NULL ),
		   (  'MB' , 672 ,'EnvironmentalBiotechnology', NULL ),
		   (  'MB' , 695,'BioprocessAndBioengineering', NULL ),
		   ( 'PAT' , 742 ,    'SpeechPathology'       , NULL ), 
		   (  'SC' , 627 ,     'HumanRelations'       , NULL ),
		   (  'SC' , 685 ,      'GlobalEconomy'       , NULL ),
		   (  'SC' , 781 ,     'AncientLiterature'    , NULL ),
		   (  'PS' , 750 ,   'PublicAdministration'   , NULL );




INSERT INTO CourseAndPrerequisites ( CourseCode , CourseNumber , PrerequisiteCode , PrerequisiteNumber )
	VALUES ( 'CIS' , 637 , 'CIS' , 621 ),
		   (  'MB' , 695 ,  'MB' , 672 ),
		   (  'MB' , 695 ,  'MB' , 689 );	 
		   
		   
		  

INSERT INTO CourseAndFaculty ( CourseCode , CourseNumber , FacultyID , ClassRoomID , NumberOfSeats )
	VALUES ( 'CSE' , 581 , 1 , 1 , 120 ),
		   ( 'CSE' , 631 , 1 , 3 , 100 ),
		   ( 'CSE' , 615 , 2 , 2 ,  80 ),
		   ( 'CIS' , 675 , 2 , 1 , 120 ),
		   ( 'CIS' , 621 , 3 , 2 ,  80 ),
		   ( 'CIS' , 637 , 3 , 3 , 100 ),
		   (  'EE' , 515 , 2 , 2 ,  80 ),
		   (  'MB' , 672 , 4 , 5 ,  70 ),
		   (  'MB' , 689 , 4 , 4 ,  60 ),
		   (  'MB' , 695 , 4 , 5 ,  70 ),
		   ( 'PAT' , 742 , 4 , 4 ,  60 ),
		   (  'SC' , 627 , 5 , 6 ,  90 ),
		   (  'SC' , 685 , 5 , 7 , 110 ),
		   (  'SC' , 781 , 5 , 7 , 110 ),
		   (  'PS' , 750 , 5 , 6 ,  90 );   		   								   	
							 				



INSERT INTO CourseTimings ( CourseCode , CourseNumber , Day , StartTime , EndTime )
	VALUES ( 'CSE' , 581 , 1 , '08:00:00' , '09:15:00' ),
		   ( 'CSE' , 581 , 2 , '08:00:00' , '09:15:00' ),
		   ( 'CSE' , 631 , 3 , '10:30:00' , '11:45:00' ),
		   ( 'CSE' , 631 , 5 , '10:30:00' , '11:45:00' ),
		   ( 'CSE' , 615 , 2 , '15:15:00' , '16:30:00' ),
		   ( 'CSE' , 615 , 4 , '15:15:00' , '16:30:00' ),
		   ( 'CIS' , 675 , 1 , '17:45:00' , '19:00:00' ),
		   ( 'CIS' , 675 , 3 , '17:45:00' , '19:00:00' ),
		   ( 'CIS' , 621 , 1 , '10:30:00' , '11:45:00' ),
		   ( 'CIS' , 621 , 2 , '10:30:00' , '11:45:00' ),
		   ( 'CIS' , 637 , 4 , '17:45:00' , '19:00:00' ),
		   ( 'CIS' , 637 , 5 , '17:45:00' , '19:00:00' ),
		   (  'EE' , 515 , 2 , '09:15:00' , '10:30:00' ),
		   (  'EE' , 515 , 4 , '09:15:00' , '10:30:00' ),
		   (  'MB' , 672 , 1 , '08:00:00' , '09:15:00' ),
		   (  'MB' , 672 , 3 , '08:00:00' , '09:15:00' ),
		   (  'MB' , 689 , 2 , '10:30:00' , '11:45:00' ),
		   (  'MB' , 689 , 4 , '10:30:00' , '11:45:00' ),
		   (  'MB' , 695 , 3 , '11:45:00' , '13:00:00' ),
		   (  'MB' , 695 , 5 , '11:45:00' , '13:00:00' ),									
		   ( 'PAT' , 742 , 1 , '14:00:00' , '15:15:00' ),										
           ( 'PAT' , 742 , 4 , '14:00:00' , '15:15:00' ),
		   (  'SC' , 627 , 3 , '15:15:00' , '16:30:00' ),
		   (  'SC' , 627 , 5 , '15:15:00' , '16:30:00' ),
		   (  'SC' , 685 , 2 , '16:30:00' , '17:45:00' ),
		   (  'SC' , 685 , 4 , '16:30:00' , '17:45:00' ),
		   (  'SC' , 781 , 1 , '17:45:00' , '19:00:00' ),
		   (  'SC' , 781 , 3 , '17:45:00' , '19:00:00' ),
		   (  'PS' , 750 , 1 , '15:15:00' , '16:30:00' ),
		   (  'PS' , 750 , 5 , '15:15:00' , '16:30:00' );




INSERT INTO CourseStatus ( CourseStatus )
	VALUES (  'Regular'  ),
		   (   'Audit'   ),
		   ( 'Pass/Fail' ),
		   ('NotEnrolled');
		    


INSERT INTO StudentGrade ( Grade )
	VALUES ( 'A+' ),
		   ( 'A-' ),
		   ( 'B+' ),
		   ( 'B-' ),
		   ( 'C+' ),
		   ( 'C-' ),
		   ( 'D+' ),
		   ( 'D-' ),
		   ( 'F'  ),
		   ( 'AU' );



INSERT INTO SemesterText ( SemesterText )
	VALUES ( 'Fall'),
		   ('Spring'),
		   ('Summer');



INSERT INTO SemesterInformation ( Semester , Year , FirstDayOfClass , LastDayOfClass )
	VALUES ( 1 , 2012 , '2012-08-31' , '2012-12-15' ),
		   ( 2 , 2012 , '2012-01-17' , '2012-05-21' ),
		   ( 3 , 2012 , '2012-06-05' , '2012-08-08' ),   
		   ( 1 , 2013 , '2013-08-29' , '2013-12-13' ),
		   ( 2 , 2013 , '2013-01-16' , '2013-05-19' ),
		   ( 3 , 2013 , '2013-06-02' , '2013-08-07' ),
		   ( 1 , 2014 , '2014-09-01' , '2014-12-13' ),
		   ( 2 , 2014 , '2014-01-18' , '2014-05-22' ),
		   ( 3 , 2014 , '2014-06-08' , '2014-08-10' ),
		   ( 1 , 2015 , '2015-08-30' , '2015-12-14' ),
		   ( 2 , 2015 , '2015-01-15' , '2015-05-20' ),
		   ( 3 , 2015 , '2015-06-04' , '2015-08-06' ),
		   ( 1 , 2016 , '2016-08-28' , '2016-12-12' ),
		   ( 2 , 2016 , '2016-01-19' , '2016-05-24' ),
		   ( 3 , 2016 , '2016-06-09' , '2016-08-11' ),
		   ( 1 , 2011 , '2011-08-27' , '2011-12-13' );



INSERT INTO StudentsAndCourses ( StudentID , CourseCode , CourseNumber , CourseStatus , Grade , Semester )
	VALUES ( 1 , 'CSE' , 581 , 3 ,   2 , 12 ),
		   ( 1 , 'CSE' , 615 , 4 , NULL, 13 ),
		   ( 2 , 'CIS' , 675 , 3 ,   1 , 10 ),
		   ( 2 ,  'EE' , 515 , 2 ,  10 , 11 ),
		   ( 3 , 'CSE' , 631 , 3 ,   9 , 12 ),
		   ( 3 ,  'EE' , 515 , 2 ,  10 , 14 ),
		   ( 4 , 'CIS' , 621 , 3 ,   4 ,  7 ),
		   ( 4 , 'CIS' , 637 , 3 ,   3 ,  8 ),
		   ( 5 ,  'MB' , 672 , 1 , NULL, 13 ),
		   ( 5 ,  'MB' , 689 , 1 , NULL, 13 ),
		   ( 6 , 'PAT' , 742 , 2 ,  10 , 12 ),
		   ( 6 ,  'MB' , 695 , 4 , NULL, 13 ),
		   ( 7 ,  'SC' , 627 , 3 ,   4 ,  2 ),
		   ( 7 ,  'SC' , 685 , 3 ,   5 ,  3 ),
		   ( 8 ,  'SC' , 781 , 1 , NULL, 13 ),
		   ( 8 ,  'PS' , 750 , 2 ,  10 , 13 );   







/* 4. Creating views 



  i) View that displays Student information , courses they are enrolled in along with the respective Faculty information  

*/
  


CREATE VIEW StudentCourses

AS

SELECT u.StudentID , p.FirstName AS StudentFirstName , p.LastName AS StudentLastName , u.CourseCode , u.CourseNumber , c.CourseTitle ,p1.FirstName AS FacultyFirstName , p1.LastName AS FacultyLastName , f.FacultyID
	FROM StudentsAndCourses u 
	INNER JOIN Course c			  ON u.CourseNumber = c.CourseNumber AND u.CourseCode = c.CourseCode
	INNER JOIN CourseAndFaculty f ON u.CourseNumber = f.CourseNumber AND u.CourseCode = f.CourseCode
	INNER JOIN Students s		  ON u.StudentID = s.StudentID
	INNER JOIN Persons p		  ON s.PersonID = p.PersonID 
	INNER JOIN Persons p1		  ON f.FacultyID = p1.PersonID;



/*
   ii) View that displays details of active employees , who are enrolled in Dental Benefits ( either single or family plan ) and their yearly pay

*/



CREATE VIEW ActiveEmployees

AS

SELECT p.FirstName , p.LastName , p.Ntid , e.YearlyPay 
	FROM Persons p 
	INNER JOIN Employees e		ON p.PersonID = e.EmployeeID 
	INNER JOIN JobInformation j ON e.JobInformation = j.JobID 
	INNER JOIN EmployeeStatus s ON e.EmployeeStatus = s.EmployeeStatusID
	INNER JOIN Benefits b		ON e.DentalBenefits = b.BenefitTypeID
	WHERE (JobID = 1 OR JobID = 2) AND (EmployeeStatusID =1 ) AND (BenefitTypeID = 7 OR BenefitTypeID = 8);


/*
   iii) View that displays names of students , their course details ( along with course status ) and their respective grades 

*/    



CREATE VIEW StudentGrades

AS

SELECT p.FirstName AS StudentFirstName, p.LastName AS StudentLastName , c1.CourseCode , c1.CourseNumber , c.CourseTitle , c1.CourseStatus , g.Grade 
	FROM Persons p
	INNER JOIN Students s            ON p.PersonID = s.StudentID  
	INNER JOIN StudentsAndCourses c1 ON s.StudentID = c1.StudentID
	INNER JOIN Course c              ON c1.CourseCode = c.CourseCode AND c1.CourseNumber = c.CourseNumber
	INNER JOIN StudentGrade g        ON c1.Grade = g.GradeID;
	


/* 
   iV) View that displays list of classrooms with computer facility along with their respective building names and the details of courses which are taught in the classrooms

*/



CREATE VIEW ClassesWithComputers 

AS

SELECT f.ClassRoomID , f.CourseCode , f.CourseNumber , c.CourseTitle , b.BuildingName 
	FROM CourseAndFaculty f
	INNER JOIN ClassRooms r				  ON f.ClassRoomID = r.ClassRoomID 
	INNER JOIN Course c					  ON f.CourseCode = c.CourseCode AND f.CourseNumber = c.CourseNumber 
	INNER JOIN Building b				  ON r.Building = b.BuildingID
	INNER JOIN ClassRoomAndItsEquipment e ON r.ClassRoomID = e.ClassRoomID
	WHERE ( EquipmentID = 4 );
	





/* 5. Stored Procedures and Functions
 
	i) Stored Procedure that checks whether a student can enroll in a particular course and this Stored Procedure allows only a new student to enroll or a student with grade 'F' in the previous attempt .

*/
	
GO

CREATE PROCEDURE dbo.StudentCourseEnrollment (@StudentID AS INTEGER ,
											  @Coursecode AS VARCHAR(10),
											  @CourseNumber AS INTEGER,
											  @Semester AS VARCHAR(10),
											  @Year AS CHAR(4)) 
									
AS	


BEGIN	

	IF @Semester IN (SELECT SemesterText 
						FROM SemesterText) 
	DECLARE @SemesterID AS INTEGER
	SELECT @SemesterID = 
						CASE
							WHEN @Semester = 'Fall'	 THEN 1 
							WHEN @Semester = 'Spring'THEN 2
							WHEN @Semester = 'Summer'THEN 3
						END

	IF @Year IN ( SELECT Year 
					  FROM SemesterInformation
					  WHERE Semester = @SemesterID )	

	BEGIN 

		DECLARE @FirstDayOfClass AS DATE 
		DECLARE @SemID AS INTEGER 
		SELECT @FirstDayOfClass = FirstDayOfClass , @SemID = SemesterID
			FROM SemesterInformation
			WHERE Semester = @SemesterID AND Year = @Year

		IF DATEDIFF ( DAY , @FirstDayOfClass , GETDATE() ) < 30

		  BEGIN

			IF EXISTS(SELECT *
						 FROM StudentsAndCourses
						 WHERE StudentID = @StudentID ) 			 
			
			BEGIN 

				IF EXISTS(SELECT *
							FROM Course
							 WHERE CourseNumber = @CourseNumber AND CourseCode = @CourseCode) 	

				BEGIN	
						 		 
					DECLARE @GradeID AS INTEGER , @CourseStatus AS VARCHAR(10)
					SELECT @GradeID = Grade , @CourseStatus = CourseStatus 
						FROM StudentAndCourses 
						WHERE StudentID = @StudentID AND CourseNumber = @CourseNumber AND CourseCode = @CourseCode

					IF @CourseStatus IS NOT NULL AND @GradeID != 9 

						BEGIN 

							PRINT ('You are already registered for this course')
						
						END

						ELSE 

							BEGIN

								INSERT INTO StudentAndCourses
									VALUES (@StudentID , @CourseCode , @CourseNumber , 1 , NULL ,@SemID)

							END
				        
				END

				ELSE
					PRINT ('Enter valid Course details')
			END

			ELSE
				PRINT ('Please enter valid StudentID')
		END

		ELSE
			PRINT ('Cannot enroll for the mentioned Semester and year')
    END

	ELSE 
		PRINT('Deadline for enrolling in this semester is passed') 
END;
			    




/* ii) Function that displays grade of a student (given StudentID , CourseCode and CourseNumber)  */

GO

CREATE FUNCTION dbo.GradeDetails (@StudentID AS INTEGER , @CourseCode AS VARCHAR(10) , @CourseNumber AS INTEGER )

	RETURNS VARCHAR(3)

AS

BEGIN

		DECLARE @GradeDetails VARCHAR(3)
		SELECT @GradeDetails = ( SELECT g.Grade 
								FROM StudentsAndCourses s
								INNER JOIN StudentGrade g ON s.Grade = g.GradeID
								WHERE StudentID = @StudentID AND CourseCode = @CourseCode AND CourseNumber = @CourseNumber )

    RETURN @GradeDetails 

END;



/* iii) Function that gives Job requirements, if you input the JobID */

GO

CREATE FUNCTION dbo.JobsAndTheirRequirements(@JobID AS INTEGER)

	RETURNS @JobsTable TABLE(Jobtitle VARCHAR(50) , Requirements VARCHAR(200))

AS

BEGIN

		INSERT INTO @JobsTable
		SELECT t.JobTitle , r.Description  
		    FROM JobInformation t
		    INNER JOIN JobAndRequirements j ON t.JobID = j.JobID 
		    INNER JOIN JobRequirements r    ON j.RequirementID = r.RequirementID 
			WHERE j.JobID = @JobID    

   	RETURN

END;




/* iV) Function that inputs facultyID and displays FacultyName and the details of courses they are teaching  */


GO

CREATE FUNCTION dbo.CourseFaculty (@FacultyID AS INTEGER )

	RETURNS @Facultytable TABLE ( FirstName VARCHAR(50) , LastName VARCHAR(50) , CourseTitle VARCHAR(100) , CourseCode VARCHAR(10) , CourseNumber INTEGER  )

AS

BEGIN

		INSERT INTO @FacultyTable
		SELECT p.FirstName , p.LastName , c1.CourseTitle , c.CourseCode , c.courseNumber 
				FROM CourseAndFaculty c
				INNER JOIN Employees e  ON c.FacultyID = e.EmployeeID 
				INNER JOIN Persons p    ON e.PersonID = p.PersonID
				INNER JOIN Course c1    ON c.CourseCode = c1.CourseCode AND c.CourseNumber = c1.CourseNumber 
				WHERE FacultyID = @FacultyID

	RETURN

END;

