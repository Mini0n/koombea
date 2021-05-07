# Koombea CSV Contacts

Create Users' Contact lists by importing CSVs

### 📍 Description

Create Contact a list by importing CSVs w/ contacts rows

- Contact Fields:

  - Name,
  - Date of Birth
  - Phone
  - Address
  - Credit Card
  - Franchise
  - Email

- Customizable columns selector via JSON

  - `{ "name": 0, "birth": 1, "phone": 2, "address": 3, "card": 4, "email": 5 }`

- Validations for all fields
- Async CSV Processing
- Uploaded Files statuses & importing details
- Import error log with good detailing
- Mostly Rails included Gems.
  - Only `devise` and `credit_card_validations` gems in Production

# 🧱 Implementation notes

- User accounts powered by Devise
- File upload with Rails 6 Active Storage
- Asynchronous importing with an Active Job
- Credit card cyphering with bcrypt
- Credit card validation with CreditCardValidations

### 📦 Dependencies

- ruby 2.6.5p114
- Rails 6.0.3.7

### 💻 Run Local

1. Clone & Run

   - `git clone git@github.com:Mini0n/koombea.git`
   - `cd koombea`
   - `bundle install`
   - `rails db:migrate`
   - `rails s`

2. Launch

   Open your browser at the rails server serving port, usually `localhost:3000`

3. Sign Up

   Create a testing account with an email & password

4. Start Importing

   There are contact csv files samples in `./test/sample_files`

### ⚗️ ToDo

- Get an S3 Account to use Bucket Uploads (CreditCard problems)
- Use S3 Buckets & set `pg` gem to create Live version @ Heroku
- Tests, tests, tests (I invest too much time figuring out some other parts)
  - Please, if you will, take a look at this side-project where I implemented some beautiful testing: [github/Mini0n/quaerit](https://github.com/Mini0n/quaerit)
- GUI Improvements
- Go full API
- Front End Client with a JS Framework

### 📸 Screenshots

![screenshot](https://i.imgur.com/LGQUj7w.png)
![screenshot](https://i.imgur.com/qMJfNGR.png)
![screenshot](https://i.imgur.com/EI7bEqc.png)
![screenshot](https://i.imgur.com/YbaUtHI.png)
![screenshot](https://i.imgur.com/qGxZKW3.png)
![screenshot](https://i.imgur.com/FnlXcHg.png)
![screenshot](https://i.imgur.com/Xsbuj14.png)
