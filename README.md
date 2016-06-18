# Points Shopping Basket Exercise

## Running it

This should work on any version of ruby, though this used 2.0.0p648 which is the system default on
El Capitan.  It uses no external libraries so you should be able to `cd` into the project and run:

```sh
$ ruby run.rb
```

This will show the output.

To run tests:

```sh
$ ruby app_test.rb
```

## Notes

I slightly over-engineered this just to show how I would go about making a simple cart (for example,
I included quantity even though the quantities are always 1).  In a larger application, I would
break more things out into service objects and certainly _not_ call services right in models as
I did in `LineItem#tax`.  This could also be done via dependency injection though rails people love
to hate that (I'm all for it myself, depends on the design).
