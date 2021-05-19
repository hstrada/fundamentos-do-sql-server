USE [balta-io]
GO

-- listar as carreiras
SELECT 
    [Id]
    ,[Title]
    ,[Url]
    ,(SELECT COUNT([CareerId]) FROM [CareerItem] WHERE [CareerItem].[CareerId] = [Id]) As [Courses]
FROM
    [Career]
GO

-- visualizacao de cursos
CREATE OR ALTER VIEW vwCourses AS 
    SELECT 
        [Course].[Id],
        [Course].[Tag],
        [Course].[Title],
        [Course].[Url],
        [Course].[Summary],
        [Course].[CreateDate],
        [Category].[Title] AS [Category],
        [Author].[Name] AS [Author]
    FROM
        [Course]
        INNER JOIN [Category] ON [Course].[CategoryId] = [Category].[Id]
        INNER JOIN [Author] ON [Course].[AuthorId] = [Author].[Id]
    WHERE
        [Active] = 1   
GO

SELECT * FROM vwCourses
GO

-- visualizar carreiras
CREATE OR ALTER VIEW vwCareers AS
    SELECT
        [Career].[Id],
        [Career].[Title],
        [Career].[Url],
        COUNT([Id]) AS [Courses]
    FROM
        [Career]
        INNER JOIN [CareerItem] ON [CareerItem].[CareerId] = [Career].[Id]
    GROUP BY
        [Career].[Id],
        [Career].[Title],
        [Career].[Url]
GO

SELECT * FROM vwCareers
GO

-- progresso de um estudante
CREATE OR ALTER PROCEDURE spStudentProgress (
    @StudentId UNIQUEIDENTIFIER
)
AS
    SELECT     
        [Student].[Name] AS [Student],
        [Course].[Title] AS [Course],    
        [StudentCourse].[Progress],
        [StudentCourse].[LastUpdateDate]
    FROM
        [StudentCourse]
        INNER JOIN [Student] ON [StudentCourse].[StudentId] = [Student].[Id]
        INNER JOIN [Course] ON [StudentCourse].[CourseId] = [Course].[Id]
    WHERE
        [StudentCourse].[StudentId] = @StudentId
        AND [StudentCourse].[Progress] < 100
        AND [StudentCourse].[Progress] > 0
    ORDER BY
        [StudentCourse].[LastUpdateDate] DESC
GO

SELECT TOP 100 * FROM [Student]
GO