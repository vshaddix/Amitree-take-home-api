# README
  
Simple api for a task given by amitree.

---

### API Documentation

I've decided to create a CRUD structure of the API. If there is an application which wants to  


| Request type  | URL           | Module           |
| ------------- | ------------- | ---------------- |
| GET           | /user         | user             |
| GET           | /user/:id     | user             |
| POST          | /user         | user             |
| DELETE        | /user/:id     | user             |
| PUT/PATCH     | /user/:id     | user             |
| POST          | /authenticate | authentication   |
| POST          | /ping         | authentication   |

These are the possible requests in the API. A more detailed documentation follows:

The API works with JSONAPI Serializers. This means all entites are returned following the formatting of JSONAPI.
Currently the API returns only one entity: `user` and its internal relationships with its credits.

Here is an example of the `user` entity

``` json
	"data": {
        "id": "1",
        "type": "user",
        "attributes": {
            "id": 1,
            "name": "Vasil Rashkov",
            "email": "email@gmail.com",
            "referral_code": "RZTLCABJ"
        },
        "relationships": {
            "user_credit": {
                "data": [
                    {
                        "type": "user_credit",
                        "id": "1"
                    },
                    {
                        "type": "user_credit",
                        "id": "12"
                    }
                ]
            }
        }
    },
    "included": [
        {
            "id": "1",
            "type": "user_credit",
            "attributes": {
                "id": 1,
                "credit": 10,
                "reason": "The registration process successfully finished!",
                "created_at": "2021-01-14T01:54:34.724Z"
            }
        },
        {
            "id": "12",
            "type": "user_credit",
            "attributes": {
                "id": 12,
                "credit": 10,
                "reason": "Josh, John, James, Jerry have successfully finished the registration process!",
                "created_at": "2021-01-14T01:54:39.048Z"
            }
        }
    ]
```

---

### Authentication

The API exposes two endoinds for authentication `POST /authenticate` and `POST /ping`.

- `POST: /authenticate` receives `email` and `password` and after validation generates a `user_session`. I decided to follow such approach since the assignment pointed out, that there should be enough evidence of my skills. I could've used JWT. After the record is created, a Authorization header is returned to the user. There is a SHA1 token, which will be valid for 30 minutes. Each request extends the 30 minutes window.
- `POST: /ping` only takes in the Authorization header and extends the session.

#### All user requests, except for the `POST: /user` require a valid token in the `Authorization` request header! 


All of the following requests for the user entity will return the pointed serialized object.

- `GET: /user` - returns a collection of user entities
- `GET: /user/:id` - Where `:id` is the corresponding primary key from the DB, will return only one entity of type User. If there is no such user found, the API returns status code 422 and an empty `data` record.
- `DELETE: /user/:id` - Will delete the entity from the database and return 200 OK with empty response. Same as getting a single user, if none is found, the API returns 422 and an empty `data` record. 
- `PUT/PATCH: /user/:id` - Can update a user entity. The fields which are allowed to be updated are only `name` and `password`. Returns the serialized user entity.
- `POST: /user` request takes in the following parameters: `email`, `password` (pain text), `name` and the optional `referral_code`. The `referral_code` could also be sent as a HEADER. This is done to give more flexibility to the front end. If the user is created successfully, the API will run couple of checks in order to determine if the user should be rewarded. As stated in the assignment, if there is a `referral_code`, a valid one, the newly registered user will be credited 10$. If this is the fifth referral of the inviter - the inviter will be credited 10$. For each operation a new `user_credit` record is stored in the database. 

---


### System dependencies:

    - rails: 6.1.1
    - gem: 3.0.9
    - ruby: 2.6.3
    - postgres (PostgreSQL): 13.1
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

To initialize the database you need to execute the following commands in the terminal

```$ rails db:create```

```$ rails db:migrate```


---

### How to run the test suite

The test suite is built in from rails. To execute the tests, you can simply use ```$ rails t``` in the terminal.


---

### Deployment instructions

Deployment is done automatically after a commit in [`heroku`](https://frozen-gorge-25653.herokuapp.com/). 

The tests are also automatically triggered on commit in the `main` branch in [`travis-ci`](https://travis-ci.com/github/vshaddix/Amitree-take-home-api).



