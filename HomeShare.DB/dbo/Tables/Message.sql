CREATE TABLE [dbo].[Message] (
    [IdMessage]   INT            IDENTITY (1, 1) NOT NULL,
    [Nom]         NVARCHAR (50)  NOT NULL,
    [Email]       NVARCHAR (256) NOT NULL,
    [Sujet]       NVARCHAR (50)  NOT NULL,
    [Information] NVARCHAR (MAX) NOT NULL,
    [DateEnvoie]  DATETIME       NOT NULL,
    CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED ([IdMessage] ASC)
);

