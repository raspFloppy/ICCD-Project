# ICCD-Project

## Configuration

### Backend

To run the backend, you need to have Ruby installed. You can use `rbenv`, the project is using Ruby 3.4.3

```bash
rbenv install 3.4.3
```

Then gem and then rails must be installed:

```bash
gem install bundler
gem install rails
```

Then you need to install the dependencies:

```bash
bundle install
```

### Database

You can use whatever database you want, but for this project we are using supabase.
In the `.env` file you have to set your database URL on the `DATABASE_URL` variable.

Then run the following command to migrate the database:

```bash
rails db:create
rails db:migrate
```

## Development

To run the backend, you can use the following command:

```bash
rails server
```

This will start the server on `localhost:3000`.
