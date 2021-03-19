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



	
