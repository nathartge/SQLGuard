/*
Update lines 35 to 38 as needed.
*/

SET NOCOUNT ON

USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_SMTPConfigure]    Script Date: 20/07/2015 3:06:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------
--  Database Mail Simple Configuration Template.
--
--  This template creates a Database Mail profile, an SMTP account and 
--  associates the account to the profile.
--  The template does not grant access to the new profile for
--  any database principals.  Use msdb.dbo.sysmail_add_principalprofile
--  to grant access to the new profile for users who are not
--  members of sysadmin.
-------------------------------------------------------------

	DECLARE @profile_name sysname,
			@account_name sysname,
			@SMTP_servername sysname,
			@email_address NVARCHAR(128),
			@display_name NVARCHAR(128);

	-- Profile name. Replace with the name for your profile
			SET @profile_name = 'SQLGuardDBA';

	-- Account information. Replace with the information for your account.

			SET @account_name = 'SQLGuardDBA Operations';
			SET @SMTP_servername = 'smtp.domain.local';
			SET @email_address = 'MSSQLALerts@domain.local';
			SET @display_name = 'SQLGuardDBAOperations';


	-- Verify the specified account and profile do not already exist.
	IF EXISTS (SELECT * FROM msdb.dbo.sysmail_profile WHERE name = @profile_name)
	BEGIN
	  RAISERROR('The specified Database Mail profile (SQLGuardDBA) already exists.', 16, 1);
	  GOTO done;
	END;

	IF EXISTS (SELECT * FROM msdb.dbo.sysmail_account WHERE name = @account_name )
	BEGIN
	 RAISERROR('The specified Database Mail account (SQLGuardDBA Operations) already exists.', 16, 1) ;
	 GOTO done;
	END;

	-- Start a transaction before adding the account and the profile
	BEGIN TRANSACTION ;

	DECLARE @rv INT;

	-- Add the account
	EXECUTE @rv=msdb.dbo.sysmail_add_account_sp
		@account_name = @account_name,
		@email_address = @email_address,
		@display_name = @display_name,
		@mailserver_name = @SMTP_servername;

	IF @rv<>0
	BEGIN
		RAISERROR('Failed to create the specified Database Mail account (SQLGuardDBA Operations).', 16, 1) ;
		GOTO done;
	END

	-- Add the profile
	EXECUTE @rv=msdb.dbo.sysmail_add_profile_sp
		@profile_name = @profile_name ;

	IF @rv<>0
	BEGIN
		RAISERROR('Failed to create the specified Database Mail profile (SQLGuardDBA).', 16, 1);
		ROLLBACK TRANSACTION;
		GOTO done;
	END;

	-- Associate the account with the profile.
	EXECUTE @rv=msdb.dbo.sysmail_add_profileaccount_sp
		@profile_name = @profile_name,
		@account_name = @account_name,
		@sequence_number = 1 ;

	IF @rv<>0
	BEGIN
		RAISERROR('Failed to associate the speficied profile with the specified account (SQLGuardDBA Operations).', 16, 1) ;
		ROLLBACK TRANSACTION;
		GOTO done;
	END;

	COMMIT TRANSACTION;

	done:
