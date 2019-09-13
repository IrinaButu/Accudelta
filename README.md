## Documentation
- Deployment
You can deploy using docker-compose up -d at root directory
- Backend
Backend is developed using asp.net core, entity framework core and odata in order to supply pagination and filtering. See [documentation](https://devblogs.microsoft.com/odata/supercharging-asp-net-core-api-with-odata/)
- Database
You can find sql script on db folder
- Fronted
Fronted is being developed with react using devextreme dx-datagrid in order to consume odata


# Accudelta Technical Interview:

## Summary
You are expected to implement the below application as a code exercise. You have one week to complete it, but it is expected to take no more than **4-5h of work**. You are free to spend more or less than that if you wish.
You can commit right to master branch or create a working branch, you can also perform more than one commit.

## Problem description
A web application with below features, containing funds and their values history. 
- A page with a list containing 1 million funds with pagination and search
  - The list should include last fund value
- Fund details page showing historical fund values
  - Each fund should have at least 1 value
- Specs: 
    - Fund: id (numeric), name (text), description (text)
    - Value: fund id (numeric), value date (date), value (numeric)

**If you prefer backend work**, focus on providing web api that can be called for data and provide documentation of that API.

**If you prefer frontend**, focus on providing that part and build a simple mock web api app that provides sample hardcoded data.

**Optional advanced task**, implement a CSV import app that will import 1M rows of fund prices into that webapi db backend, in under 20s in a reasonably speced PC machine. Assume data might already exist in database.
- CSV format:
    - `fund_id|fund_name|fund_description|value_date|value_value`

## Mandatory
- ASP.NET MVC or WebAPI or .NET CORE
- Dependency Injection
- SQL Server
- Unit tests

## Desired
- React
- Typescript
- Webpack
- SASS

## Deliverables
A project with above implementation. If the project is in a runnable state and other dependencies are required (for example sql scripts for database structure), please include a short description of how to run it in `how-to-run.md`.