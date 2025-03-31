WITH RECURSIVE EmployeeHierarchy AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName,
        e.DepartmentID,
        e.RoleID,
        0 AS SubordinateCount
    FROM
        Employees e
            JOIN
        Departments d ON e.DepartmentID = d.DepartmentID
            JOIN
        Roles r ON e.RoleID = r.RoleID
    WHERE
        e.EmployeeID = 1

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName,
        e.DepartmentID,
        e.RoleID,
        0 AS SubordinateCount
    FROM
        Employees e
            JOIN
        Departments d ON e.DepartmentID = d.DepartmentID
            JOIN
        Roles r ON e.RoleID = r.RoleID
            JOIN
        EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
),
               TaskCounts AS (
                   SELECT
                       AssignedTo,
                       COUNT(*) AS TaskCount
                   FROM
                       Tasks
                   GROUP BY
                       AssignedTo
               )
SELECT
    eh.EmployeeID,
    eh.Name,
    eh.ManagerID,
    eh.DepartmentName,
    eh.RoleName,
    (SELECT STRING_AGG(p.ProjectName, ', ') FROM Projects p WHERE p.DepartmentID = eh.DepartmentID) AS Projects,
    (SELECT STRING_AGG(t.TaskName, ', ') FROM Tasks t WHERE t.AssignedTo = eh.EmployeeID) AS Tasks,
    COALESCE(tc.TaskCount, 0) AS TotalTasks,
    (SELECT COUNT(*) FROM Employees e2 WHERE e2.ManagerID = eh.EmployeeID) AS DirectSubordinates
FROM
    EmployeeHierarchy eh
        LEFT JOIN
    TaskCounts tc ON eh.EmployeeID = tc.AssignedTo
ORDER BY
    eh.Name;