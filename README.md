# README
  
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

---

### Ruby version used for this project

```ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-darwin19]```

---

### System dependencies:

    - rails version - 6.1.1
    - ...
---

### Configuration


---

### Database creation

We will be using ```postgresql``` for the purposes of this project. 

On MacOS to install and setup the database you will need to do the following steps in your terminal:

**Step 1**: $ brew install postgresql

To start the service and enable it to start at login, run the following:
**Step 2**: ```$ brew services start postgresql```

Now we need to create a new role with which we will be managing out database
**Step 3**: ```$ createuser -P -d ```appname``` ```

(Where ```appname``` could be replaced with out desired name. For example ```amitree-take-home-api```.)
        
To store your password in an environment variable at login, run the following command, replacing ```appname``` with the name of your app and ```PostgreSQL_Role_Password``` with the password you created in the last step.
**Step 4**: ```$ echo 'export APPNAME_DATABASE_PASSWORD="PostgreSQL_Role_Password"' >> ~/.bash_profile```

To export the variable for your current session, use the source command:
**Step 5**: ```$ source ~/.bash_profile```

Now we should be able to create out database.
**Step 6**: ```$ rails db:create```

### Note!
If you wish to go with a different username, be sure to change it in the ```config/database.yml``` file.

---

### Database initialization




---

### How to run the test suite

---

### Services (job queues, cache servers, search engines, etc.)

---

### Deployment instructions
