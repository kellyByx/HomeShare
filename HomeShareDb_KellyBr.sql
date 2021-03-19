USE [master]
GO
/****** Object:  Database [HomeShareDBASP]    Script Date: 19-03-21 16:01:37 ******/
CREATE DATABASE [HomeShareDBASP]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HomeShareDBASP', FILENAME = N'C:\Users\kelzoe\HomeShareDBASP.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HomeShareDBASP_log', FILENAME = N'C:\Users\kelzoe\HomeShareDBASP_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [HomeShareDBASP] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HomeShareDBASP].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HomeShareDBASP] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET ARITHABORT OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HomeShareDBASP] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HomeShareDBASP] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET  ENABLE_BROKER 
GO
ALTER DATABASE [HomeShareDBASP] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HomeShareDBASP] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [HomeShareDBASP] SET  MULTI_USER 
GO
ALTER DATABASE [HomeShareDBASP] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HomeShareDBASP] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HomeShareDBASP] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HomeShareDBASP] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HomeShareDBASP] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [HomeShareDBASP] SET QUERY_STORE = OFF
GO
USE [HomeShareDBASP]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [HomeShareDBASP]
GO
/****** Object:  UserDefinedFunction [dbo].[SF_EncryptedPassword]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SF_EncryptedPassword]
(
	@password NVARCHAR(32),
	@salt CHAR(8)
)
RETURNS VARBINARY(32)
AS
BEGIN
	RETURN HASHBYTES('SHA2_256',CONCAT(SUBSTRING(@salt,0,4),@password,SUBSTRING(@salt,4,4)))
END
GO
/****** Object:  UserDefinedFunction [dbo].[SF_GenerateSalt]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SF_GenerateSalt]
()
RETURNS CHAR(8)
AS
BEGIN
	DECLARE @saltResult NVARCHAR(8)
	DECLARE @randomValue SMALLINT, @i SMALLINT
	SET @i = 0;
	WHILE @i < 8
	BEGIN
		SET @randomValue = (SELECT RandomValue FROM [V_GetRandom]) 
		SET @saltResult = CONCAT(@saltResult,@randomValue)
		SET @i = @i + 1;
	END

	RETURN @saltResult

END
GO
/****** Object:  Table [dbo].[BienEchange]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BienEchange](
	[idBien] [int] IDENTITY(1,1) NOT NULL,
	[titre] [nvarchar](50) NOT NULL,
	[DescCourte] [nvarchar](150) NOT NULL,
	[DescLong] [ntext] NOT NULL,
	[NombrePerson] [int] NOT NULL,
	[Pays] [int] NOT NULL,
	[Ville] [nvarchar](50) NOT NULL,
	[Rue] [nvarchar](50) NOT NULL,
	[Numero] [nvarchar](5) NOT NULL,
	[CodePostal] [nvarchar](50) NOT NULL,
	[Photo] [nvarchar](50) NOT NULL,
	[AssuranceObligatoire] [bit] NOT NULL,
	[isEnabled] [bit] NOT NULL,
	[DisabledDate] [date] NULL,
	[Latitude] [nvarchar](50) NOT NULL,
	[Longitude] [nvarchar](50) NOT NULL,
	[idMembre] [int] NOT NULL,
	[DateCreation] [date] NOT NULL,
 CONSTRAINT [PK_BienEchange] PRIMARY KEY CLUSTERED 
(
	[idBien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[Vue_CinqDernierBiens]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vue_CinqDernierBiens]
AS
SELECT     TOP (5) idBien, titre, DescCourte, DescLong, NombrePerson, Pays, Ville, Rue, Numero, CodePostal, Photo, AssuranceObligatoire, isEnabled, DisabledDate, Latitude, Longitude, idMembre, 
                      DateCreation
FROM         dbo.BienEchange
ORDER BY DateCreation DESC
GO
/****** Object:  View [dbo].[Vue_BiensParPays]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vue_BiensParPays]
AS
SELECT     TOP (100) PERCENT idBien, titre, DescCourte, DescLong, NombrePerson, Pays, Ville, Rue, Numero, CodePostal, Photo, AssuranceObligatoire, isEnabled, DisabledDate, Latitude, Longitude, 
                      idMembre, DateCreation
FROM         dbo.BienEchange
ORDER BY Pays
GO
/****** Object:  Table [dbo].[AvisMembreBien]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvisMembreBien](
	[idAvis] [int] IDENTITY(1,1) NOT NULL,
	[note] [int] NOT NULL,
	[message] [ntext] NOT NULL,
	[idMembre] [int] NOT NULL,
	[idBien] [int] NOT NULL,
	[DateAvis] [datetime] NOT NULL,
	[Approuve] [bit] NOT NULL,
 CONSTRAINT [PK_AvisMembreBien] PRIMARY KEY CLUSTERED 
(
	[idAvis] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[Vue_MeilleursAvis]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vue_MeilleursAvis]
AS
SELECT     TOP (100) PERCENT dbo.BienEchange.idBien, dbo.BienEchange.titre, dbo.BienEchange.DescCourte, dbo.BienEchange.DescLong, dbo.BienEchange.NombrePerson, dbo.BienEchange.Pays, 
                      dbo.BienEchange.Ville, dbo.BienEchange.Rue, dbo.BienEchange.Numero, dbo.BienEchange.CodePostal, dbo.BienEchange.Photo, dbo.BienEchange.AssuranceObligatoire, 
                      dbo.BienEchange.isEnabled, dbo.BienEchange.DisabledDate, dbo.BienEchange.Latitude, dbo.BienEchange.Longitude, dbo.BienEchange.idMembre, dbo.BienEchange.DateCreation
FROM         dbo.AvisMembreBien INNER JOIN
                      dbo.BienEchange ON dbo.AvisMembreBien.idBien = dbo.BienEchange.idBien
WHERE     (dbo.AvisMembreBien.note > 6)
ORDER BY dbo.AvisMembreBien.note DESC
GO
/****** Object:  View [dbo].[V_GetRandom]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_GetRandom]
	AS SELECT FLOOR(RAND()*10) AS RandomValue

	-- Rappel on le met dans une vue car random ne peut pas etre use dans une fonction ("regle de chez sqlServer").
GO
/****** Object:  Table [dbo].[Membre]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Membre](
	[idMembre] [int] IDENTITY(1,1) NOT NULL,
	[Nom] [nvarchar](50) NOT NULL,
	[Prenom] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[Pays] [int] NOT NULL,
	[Telephone] [nvarchar](20) NOT NULL,
	[Login] [nvarchar](50) NOT NULL,
	[Password] [varbinary](max) NOT NULL,
	[Salt] [char](8) NULL,
 CONSTRAINT [PK_membre] PRIMARY KEY CLUSTERED 
(
	[idMembre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MembreBienEchange]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MembreBienEchange](
	[idMembre] [int] NOT NULL,
	[idBien] [int] NOT NULL,
	[DateDebEchange] [date] NOT NULL,
	[DateFinEchange] [date] NOT NULL,
	[Assurance] [bit] NULL,
	[Valide] [bit] NOT NULL,
 CONSTRAINT [PK_MembreBienEchange] PRIMARY KEY CLUSTERED 
(
	[idMembre] ASC,
	[idBien] ASC,
	[DateDebEchange] ASC,
	[DateFinEchange] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Message]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Message](
	[IdMessage] [int] IDENTITY(1,1) NOT NULL,
	[Nom] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[Sujet] [nvarchar](50) NOT NULL,
	[Information] [nvarchar](max) NOT NULL,
	[DateEnvoie] [datetime] NOT NULL,
 CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED 
(
	[IdMessage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Options]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Options](
	[idOption] [int] IDENTITY(1,1) NOT NULL,
	[Libelle] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Options] PRIMARY KEY CLUSTERED 
(
	[idOption] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OptionsBien]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OptionsBien](
	[idOption] [int] NOT NULL,
	[idBien] [int] NOT NULL,
	[Valeur] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OptionsBien] PRIMARY KEY CLUSTERED 
(
	[idOption] ASC,
	[idBien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pays]    Script Date: 19-03-21 16:01:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pays](
	[idPays] [int] IDENTITY(1,1) NOT NULL,
	[Libelle] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Pays] PRIMARY KEY CLUSTERED 
(
	[idPays] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AvisMembreBien] ON 
GO
INSERT [dbo].[AvisMembreBien] ([idAvis], [note], [message], [idMembre], [idBien], [DateAvis], [Approuve]) VALUES (2, 4, N'Beaucoup trop humide', 1, 2, CAST(N'2015-03-06T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[AvisMembreBien] ([idAvis], [note], [message], [idMembre], [idBien], [DateAvis], [Approuve]) VALUES (4, 10, N'Quel merveille', 4, 3, CAST(N'2015-03-06T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[AvisMembreBien] ([idAvis], [note], [message], [idMembre], [idBien], [DateAvis], [Approuve]) VALUES (5, 1, N'Vraiment n''importe quoi ce bien', 1, 2, CAST(N'2015-03-06T00:00:00.000' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[AvisMembreBien] OFF
GO
SET IDENTITY_INSERT [dbo].[BienEchange] ON 
GO
INSERT [dbo].[BienEchange] ([idBien], [titre], [DescCourte], [DescLong], [NombrePerson], [Pays], [Ville], [Rue], [Numero], [CodePostal], [Photo], [AssuranceObligatoire], [isEnabled], [DisabledDate], [Latitude], [Longitude], [idMembre], [DateCreation]) VALUES (2, N'Un peu Humide', N'Petite maison sous-marine tout confort', N'Maison tout confort située au large de Miami. <br /> Possibilité de venir avec votre animal de compagnie si celui-ci adore les longs séjours dans l''eau ou si il est naturellement amphibie. Pas de piscine mais une magnifique serre contenant algues et anémones.', 2, 6, N'Miami', N'UnderStreet', N'8', N'123456', N'maisonSousMarine.jpg', 0, 1, NULL, N'25.774', N'36.874', 1, CAST(N'2015-03-06' AS Date))
GO
INSERT [dbo].[BienEchange] ([idBien], [titre], [DescCourte], [DescLong], [NombrePerson], [Pays], [Ville], [Rue], [Numero], [CodePostal], [Photo], [AssuranceObligatoire], [isEnabled], [DisabledDate], [Latitude], [Longitude], [idMembre], [DateCreation]) VALUES (3, N'Vue imprenable sur le grand Canyon', N'Maison perchée sur la falaise offrant une vue imprenable.', N'Vivre comme un aigle et respirer l''air pur.<br > Cette maison est un petit paradis perché offran lt confort moderne.', 1, 7, N'Colorado Sping', N'RockNRoll', N'10', N'784521', N'rockHouse.jpg', 1, 1, NULL, N'36.159420', N'-112.202579', 3, CAST(N'2015-03-06' AS Date))
GO
INSERT [dbo].[BienEchange] ([idBien], [titre], [DescCourte], [DescLong], [NombrePerson], [Pays], [Ville], [Rue], [Numero], [CodePostal], [Photo], [AssuranceObligatoire], [isEnabled], [DisabledDate], [Latitude], [Longitude], [idMembre], [DateCreation]) VALUES (4, N'Belle Vue ', N'Maison Avec balcon a l''étage', N'Grande villa de 400m carré qui posède divers balcon a l''étage', 8, 5, N'milo', N'edvis', N'44', N'6452', N'bgmain.png', 1, 1, NULL, N'48.745', N'28.745', 3, CAST(N'2016-11-07' AS Date))
GO
INSERT [dbo].[BienEchange] ([idBien], [titre], [DescCourte], [DescLong], [NombrePerson], [Pays], [Ville], [Rue], [Numero], [CodePostal], [Photo], [AssuranceObligatoire], [isEnabled], [DisabledDate], [Latitude], [Longitude], [idMembre], [DateCreation]) VALUES (5, N'Bole d''air', N'Maison en montage', N'Belle maison en bois dans la montage agréable en été comme e, hiver', 7, 2, N'halen', N'gilbert', N'47', N'3642', N'bginside.jpg', 1, 1, NULL, N'73.95', N'12.87', 1, CAST(N'2019-11-12' AS Date))
GO
SET IDENTITY_INSERT [dbo].[BienEchange] OFF
GO
SET IDENTITY_INSERT [dbo].[Membre] ON 
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (1, N'Pink', N'Panther', N'pink@panther.com', 7, N'555-456325', N'Pink', 0x500069006E006B00, NULL)
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (3, N'Admin', N'Admin', N'admin@HomeShare.be', 1, N'4562325214', N'Admin', 0x410064006D0069006E00, NULL)
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (4, N'Dolphin', N'Flipper', N'dolphin.Flip@sea.us', 6, N'0000000000', N'Dol', 0x5000680069006E00, NULL)
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (5, N'Deris', N'Loic', N'l.deris@yahoo.fr', 4, N'06124587456', N'LoicDeris', 0x18777F08727A8E9D44A8887F51D47F89792D59895914ABDDDD200433BE4A049F, N'73799497')
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (6, N'Drom', N'lucie', N'D.luci@yahoo.be', 4, N'0432156876', N'Drom02', 0x3DBCC89511681C5F696384C68ACD25CC08B3EF68D2C7AF5FF7AF4CEBE1D30D99, N'11280278')
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (7, N'Mil', N'marie', N'marilM@gmail.com', 3, N'08753654281', N'Marie24', 0x61CB8363912D6734CB0761059693D198F00F106FC68ACB0EF52614CAA83BEA34, N'28073817')
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (8, N'marckx', N'Jhon', N'M.J@yahoo.com', 2, N'0523641876', N'Marckx21', 0x98C8385138BB23F2395D65CAE5F8697E8D61B5A47435A21E926AF296C0A4AE2D, N'86066306')
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (10, N'du bois', N'élodie', N'elodei.D@gmail.be', 1, N'0423578915', N'DuboisElodie', 0x45BAB56920A261BCACCFD6DB6CA1C07D75C8E897B97B18B8648046B0A4B278BE, N'92850125')
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (11, N'Bruyninx', N'Kelly', N'k.bruyninx@interface3.be', 1, N'0765478942', N'Byx', 0x37DC28B7D1ED7242618C23717E31BCE18456D072906F833DD08052AFBD858CEA, N'28551585')
GO
INSERT [dbo].[Membre] ([idMembre], [Nom], [Prenom], [Email], [Pays], [Telephone], [Login], [Password], [Salt]) VALUES (12, N'wulf', N'lisa', N'wulfL@gmail.com', 5, N'028749631', N'lisaWulf', 0x603E0923880B0A88CC6B45F88897BEB9B95611A8C61EAD4363FCBBD2582B793C, N'42354998')
GO
SET IDENTITY_INSERT [dbo].[Membre] OFF
GO
SET IDENTITY_INSERT [dbo].[Message] ON 
GO
INSERT [dbo].[Message] ([IdMessage], [Nom], [Email], [Sujet], [Information], [DateEnvoie]) VALUES (1, N'Emil', N'Emilzola@yahoo.fr', N'App', N'Bonjour est ce que votre service est gratuit ou payant?', CAST(N'2021-03-19T06:57:00.280' AS DateTime))
GO
INSERT [dbo].[Message] ([IdMessage], [Nom], [Email], [Sujet], [Information], [DateEnvoie]) VALUES (2, N'Elise', N'Elise.P@gmail.com', N'Pays', N'Bonjour est ce que c''est possible d''échanger un bien mais hors Europe?', CAST(N'2021-03-19T07:04:32.173' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Message] OFF
GO
SET IDENTITY_INSERT [dbo].[Options] ON 
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (1, N'Chien admis')
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (2, N'Lave Linge')
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (3, N'Lave vaisselle')
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (4, N'Wifi')
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (5, N'Parking')
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (6, N'Piscine')
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (7, N'Feu ouvert')
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (8, N'Lit enfant')
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (9, N'WC')
GO
INSERT [dbo].[Options] ([idOption], [Libelle]) VALUES (10, N'Salle de bain')
GO
SET IDENTITY_INSERT [dbo].[Options] OFF
GO
INSERT [dbo].[OptionsBien] ([idOption], [idBien], [Valeur]) VALUES (1, 2, N'Oui')
GO
INSERT [dbo].[OptionsBien] ([idOption], [idBien], [Valeur]) VALUES (1, 3, N'Non')
GO
INSERT [dbo].[OptionsBien] ([idOption], [idBien], [Valeur]) VALUES (2, 2, N'Non')
GO
INSERT [dbo].[OptionsBien] ([idOption], [idBien], [Valeur]) VALUES (3, 3, N'Non')
GO
INSERT [dbo].[OptionsBien] ([idOption], [idBien], [Valeur]) VALUES (4, 2, N'Oui')
GO
INSERT [dbo].[OptionsBien] ([idOption], [idBien], [Valeur]) VALUES (6, 2, N'Oui')
GO
INSERT [dbo].[OptionsBien] ([idOption], [idBien], [Valeur]) VALUES (8, 3, N'1')
GO
INSERT [dbo].[OptionsBien] ([idOption], [idBien], [Valeur]) VALUES (9, 2, N'1')
GO
INSERT [dbo].[OptionsBien] ([idOption], [idBien], [Valeur]) VALUES (10, 2, N'5')
GO
SET IDENTITY_INSERT [dbo].[Pays] ON 
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (1, N'Belgique')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (2, N'France')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (3, N'Italie')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (4, N'Pays-Bas')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (5, N'Luxembourg')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (6, N'Austalie')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (7, N'USA')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (8, N'Anglettere')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (9, N'Espagne')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (10, N'Portugal')
GO
INSERT [dbo].[Pays] ([idPays], [Libelle]) VALUES (11, N'Islande')
GO
SET IDENTITY_INSERT [dbo].[Pays] OFF
GO
ALTER TABLE [dbo].[AvisMembreBien] ADD  CONSTRAINT [DF_AvisMembreBien_Approuve]  DEFAULT ((0)) FOR [Approuve]
GO
ALTER TABLE [dbo].[BienEchange] ADD  CONSTRAINT [DF_BienEchange_Pays]  DEFAULT ((1)) FOR [Pays]
GO
ALTER TABLE [dbo].[BienEchange] ADD  CONSTRAINT [DF_BienEchange_AssuranceObligatoire]  DEFAULT ((0)) FOR [AssuranceObligatoire]
GO
ALTER TABLE [dbo].[BienEchange] ADD  CONSTRAINT [DF_BienEchange_isEnabled]  DEFAULT ((0)) FOR [isEnabled]
GO
ALTER TABLE [dbo].[BienEchange] ADD  CONSTRAINT [DF_BienEchange_DateCreation]  DEFAULT (getdate()) FOR [DateCreation]
GO
ALTER TABLE [dbo].[MembreBienEchange] ADD  CONSTRAINT [DF_MembreBienEchange_Valide]  DEFAULT ((0)) FOR [Valide]
GO
ALTER TABLE [dbo].[AvisMembreBien]  WITH CHECK ADD  CONSTRAINT [FK_AvisMembreBien_BienEchange] FOREIGN KEY([idBien])
REFERENCES [dbo].[BienEchange] ([idBien])
GO
ALTER TABLE [dbo].[AvisMembreBien] CHECK CONSTRAINT [FK_AvisMembreBien_BienEchange]
GO
ALTER TABLE [dbo].[AvisMembreBien]  WITH CHECK ADD  CONSTRAINT [FK_AvisMembreBien_membre] FOREIGN KEY([idMembre])
REFERENCES [dbo].[Membre] ([idMembre])
GO
ALTER TABLE [dbo].[AvisMembreBien] CHECK CONSTRAINT [FK_AvisMembreBien_membre]
GO
ALTER TABLE [dbo].[BienEchange]  WITH CHECK ADD  CONSTRAINT [FK_BienEchange_membre] FOREIGN KEY([idMembre])
REFERENCES [dbo].[Membre] ([idMembre])
GO
ALTER TABLE [dbo].[BienEchange] CHECK CONSTRAINT [FK_BienEchange_membre]
GO
ALTER TABLE [dbo].[BienEchange]  WITH CHECK ADD  CONSTRAINT [FK_BienEchange_Pays] FOREIGN KEY([Pays])
REFERENCES [dbo].[Pays] ([idPays])
GO
ALTER TABLE [dbo].[BienEchange] CHECK CONSTRAINT [FK_BienEchange_Pays]
GO
ALTER TABLE [dbo].[MembreBienEchange]  WITH CHECK ADD  CONSTRAINT [FK_MembreBienEchange_BienEchange] FOREIGN KEY([idBien])
REFERENCES [dbo].[BienEchange] ([idBien])
GO
ALTER TABLE [dbo].[MembreBienEchange] CHECK CONSTRAINT [FK_MembreBienEchange_BienEchange]
GO
ALTER TABLE [dbo].[MembreBienEchange]  WITH CHECK ADD  CONSTRAINT [FK_MembreBienEchange_membre] FOREIGN KEY([idMembre])
REFERENCES [dbo].[Membre] ([idMembre])
GO
ALTER TABLE [dbo].[MembreBienEchange] CHECK CONSTRAINT [FK_MembreBienEchange_membre]
GO
ALTER TABLE [dbo].[OptionsBien]  WITH CHECK ADD  CONSTRAINT [FK_OptionsBien_BienEchange] FOREIGN KEY([idBien])
REFERENCES [dbo].[BienEchange] ([idBien])
GO
ALTER TABLE [dbo].[OptionsBien] CHECK CONSTRAINT [FK_OptionsBien_BienEchange]
GO
ALTER TABLE [dbo].[OptionsBien]  WITH CHECK ADD  CONSTRAINT [FK_OptionsBien_Options] FOREIGN KEY([idOption])
REFERENCES [dbo].[Options] ([idOption])
GO
ALTER TABLE [dbo].[OptionsBien] CHECK CONSTRAINT [FK_OptionsBien_Options]
GO
/****** Object:  StoredProcedure [dbo].[SP_Check_Password]    Script Date: 19-03-21 16:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Check_Password]
	@login NVARCHAR(16),
	@password NVARCHAR(32)
AS
    DECLARE @hPassword VARBINARY(32)
	DECLARE @salt CHAR(8)
	DECLARE @newPassword VARBINARY(MAX)
	SELECT @salt = salt, @hPassword = Password FROM Membre WHERE login=@login
	SELECT @newPassword = dbo.SF_EncryptedPassword (@password, @salt)

	IF(@newPassword = @hPassword)

    BEGIN
        SELECT[Login], Nom, Prenom, Email, Pays, Telephone
		FROM Membre
		WHERE login=@login

	END 

	--mis en maximum pour etre large
GO
/****** Object:  StoredProcedure [dbo].[SP_Membre_insert]    Script Date: 19-03-21 16:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Membre_insert]
    
    @nom             NVARCHAR (50),  
    @prenom          NVARCHAR (50),  
    @email          NVARCHAR (256), 
    @pays            INT, 
    @telephone      NVARCHAR (20),  
    @login          NVARCHAR (50),  
    @password       NVARCHAR (MAX)

       
AS
DECLARE @idMembre INTEGER, @salt CHAR(8)
	SET @salt = [dbo].SF_GenerateSalt()
	INSERT INTO[Membre]([Nom], [Prenom], [Email],[Pays],[Telephone],[Login], [Password] ,[Salt])
		   VALUES (@nom, @prenom, @email, @pays, @telephone, @login, dbo.SF_EncryptedPassword(@password, @salt), @salt)
	SET @idMembre = @@IDENTITY
GO
/****** Object:  StoredProcedure [dbo].[sp_RecupBienDispo]    Script Date: 19-03-21 16:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cognitic 
-- Create date: 28/02/2015
-- Description:	Récupérer les biens disponible entre deux dates
-- =============================================
Create PROCEDURE [dbo].[sp_RecupBienDispo]
	@DateDeb date,
	@DateFin date
AS
BEGIN
	SELECT     *
FROM         BienEchange
where idBien not in (select idBien from MembreBienEchange where 
(@DateDeb >=DateDebEchange and DateFinEchange >= @DateDeb)
or
(DateFinEchange>=@DateFin and DateDebEchange<= @DateFin )
or 
(@DateDeb<=DateDebEchange and DateFinEchange>= @DateFin)
)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_RecupBienMembre]    Script Date: 19-03-21 16:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cognitic 
-- Create date: 28/02/2015
-- Description:	Récupérer les biens d'un membre
-- =============================================
CREATE PROCEDURE [dbo].[sp_RecupBienMembre] 
	@idMembre int
AS
BEGIN
	select * from BienEchange
	where idMembre = @idMembre
END
GO
/****** Object:  StoredProcedure [dbo].[sp_RecupToutesInfosBien]    Script Date: 19-03-21 16:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Cognitic 
-- Create date: 28/02/2015
-- Description:	Récupérer les infos complètes d'un bien à partir de son id
-- =============================================
CREATE PROCEDURE [dbo].[sp_RecupToutesInfosBien] 
	@idBien int
AS
BEGIN
SELECT     *
FROM        BienEchange  left JOIN
                      AvisMembreBien ON AvisMembreBien.idBien = BienEchange.idBien left JOIN
                      Membre ON AvisMembreBien.idMembre = Membre.idMembre AND BienEchange.idMembre = Membre.idMembre left JOIN
                      MembreBienEchange ON BienEchange.idBien = MembreBienEchange.idBien AND Membre.idMembre = MembreBienEchange.idMembre left JOIN
                      OptionsBien ON BienEchange.idBien = OptionsBien.idBien left JOIN
                      Options ON OptionsBien.idOption = Options.idOption left JOIN
                      Pays ON BienEchange.Pays = Pays.idPays
                      where BienEchange.idBien=@idBien
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "BienEchange"
            Begin Extent = 
               Top = 6
               Left = 248
               Bottom = 247
               Right = 439
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vue_BiensParPays'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vue_BiensParPays'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "BienEchange"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 269
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vue_CinqDernierBiens'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vue_CinqDernierBiens'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "AvisMembreBien"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 219
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BienEchange"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 126
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vue_MeilleursAvis'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Vue_MeilleursAvis'
GO
USE [master]
GO
ALTER DATABASE [HomeShareDBASP] SET  READ_WRITE 
GO
