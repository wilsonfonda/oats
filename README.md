# OATS
# Open Attendance Service

This application is a software as a service (SAAS) that provides a system to maintain a company's attendance record.

# Model and Database

We have 6 ActiveRecord model:
1.  Company
    This model stores company's informations (name, address, contact).

2.  Office
    This model stores location and acceptable range (for checkin/checkout). An office belongs to one company and a company can have many offices.

3.  User
    This model stores user's informations such as name and email. This model is also used for authentication and authorization, so this model also stores password and role. There are 4 roles:
    a.  Admin, represented by character '0'
    b.  Owner, represented by character '1'
    c.  HR, represented by character '2'
    d.  Employee, represented by character '3'
    An user belongs to one office and a office can have many users.

4.  Ownership
    This model stores the relationship between a company and its owner which is a user. A company belongs to one owner and an owner can only have one company.

5.  Worktime
    This model stores a pair of checkin and checkout time + place. Worktime belongs to a user and a user can have many worktimes. 

6.  Billing
    This model stores a company's bills. A new bill can only be created by an admin. A company can have many billings.
