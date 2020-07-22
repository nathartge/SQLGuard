# SQLGuard
SQLGuard is what I have called a grouping or collection of objects which I have developed or others that help me perform DBA tasks. base build scripts and SSIS Solution. This is a collection of what I use at times and is quite helpful for managing SQL environments

1. The basebuild solution can be customised for any enviroment and is a collection of scripts which will help you do perform DBA tasks. Some scripts are from OLA and OZAR which I love to use, the build will postiion these into a base DB and not the master DB. Rename as you like. 
2. SQLGuard SSIS solution health reporting
3. SQLGuard Netbackup SSIS solution, this uses a local db on each instance and an SSIS package which calls the local Netbackup agent and master server to backup SQL databases. 

Databases I use:

SQLGuard_Hub
This is a central storage point which is used for storing what is on the network. This only exists on your SQL Central Management server.

SQLGuard_DWH
This is where the SSIS package loads the data it collects. This only exists on your SQL Central Management server.

SQLGuard_Ops
This is a mix of useful scripts I have found which will help you do your role, deploy onto any instance. You will see the OZAR scrips as they are awesome and OLA ones plus what every I find which I like to store in a central DB which is at hand when you need them. 
