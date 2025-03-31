WITH RECURSIVE EmployeeHierarchy AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        d.DepartmentName,
        r.RoleName,
        e.DepartmentID,
        e.RoleID
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
        e.RoleID
    FROM
        Employees e
            JOIN
        Departments d ON e.DepartmentID = d.DepartmentID
            JOIN
        Roles r ON e.RoleID = r.RoleID
            JOIN
        EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT
    eh.EmployeeID,
    eh.Name,
    eh.ManagerID,
    eh.DepartmentName,
    eh.RoleName,
    (SELECT STRING_AGG(p.ProjectName, ', ') FROM Projects p WHERE p.DepartmentID = eh.DepartmentID) AS Projects,
    (SELECT STRING_AGG(t.TaskName, ', ') FROM Tasks t WHERE t.AssignedTo = eh.EmployeeID) AS Tasks
FROM
    EmployeeHierarchy eh
ORDER BY
    eh.Name;