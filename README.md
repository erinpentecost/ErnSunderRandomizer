# ErnSunderRandomizer

This is a Morrowind [OpenMW](https://openmw.org/) mod that hides Sunder at the end of a randomly-generated scavenger hunt. Every playthrough will result in a different series of clue and Sunder locations.

This has *no dependencies* on any other mods and will *work with all content*, whether provided by a mod or with the base game.

Dagoth Vemyn doesn't have Sunder anymore. Instead, he holds the first clue in a scavenger hunt all that can span all across Morrowind (and Tamriel and Anvil and Skyrim and whatever other mods you have installed). You can change the number of steps in the hunt in the mod settings; the default is 3. Take a randomized tour of all the content you installed every playthrough!

![example](sunder_hunt.gif)


## Installing
Extract [main](https://github.com/erinpentecost/ErnSunderRandomizer/archive/refs/heads/main.zip) to your `mods/` folder.


In your `openmw.cfg` file, and add these lines in the correct spots:

```yaml
data="/wherevermymodsare/mods/ErnSunderRandomizer-main"

content=ErnSunderRandomizer.omwscripts
```

## Contributing

Feel free to submit a PR to the [repo](https://github.com/erinpentecost/ErnSunderRandomizer) provided:

* You assert that all code submitted is your own work.
* You relinquish ownership of the code upon merge to `main`.
* You acknowledge your code will be governed by the project license.


### References

* https://en.uesp.net/wiki/Morrowind:Sunder (`false_sunder`)
* https://openmw.readthedocs.io/en/latest/reference/lua-scripting/openmw_types.html##(BookRecord)
* https://openmw.readthedocs.io/en/latest/reference/lua-scripting/openmw_world.html##(world).createRecord