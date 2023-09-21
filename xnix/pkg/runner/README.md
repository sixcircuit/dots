
# runner: a *simple* command runner

I dislike complicated command runners. Runner is dirt simple. It's one script, and one file that defines your commands.
You can include the run script in all your projects, or put it in a global location.

## Installation

To get the "binary":

```
wget https://raw.github.com/sktaylor/runner/master/run
```

I put the "binary" in my path, `~/bin` specifically (which I added to my path), but as I said, you can just include it in the root of every repository and use `./run <whatever command>` to make it easier for collaborators. You can even do both, I usually do.

To get an example `run_file`:

```
wget https://raw.github.com/sktaylor/runner/master/run_file
```

## Usage

You need a file named `run_file` in the current directory, or in a parent directory of the current working directory. Runner will search "above" the current working directory and use the closest `run_file` it finds.
If it doesn't find a `run_file` in the current directory, or it's parents. It will check for a `run_file` in the directory next to the "binary". So if you include it with your project, next to your `run_file` you can call it from a parent directory, or absolutely.
`/home/foo_user/run some_command` only works if there is a `run_file` in `/home/foo_user`.

```python
# run_file

from subprocess import call

def _shell(cmd):
    return call(cmd.split())

def echo(args):
    return _shell('echo ' + " ".join(args))

def echo_two(args):
    return _shell('echo ' + " ".join(args) + " " + " ".join(args))
```

Then you can run any of the commands in it with the "run" script:

```
# ./run echo "hello world."
hello world.

# ./run echo_two "hello world." 
hello world. hello world.
```

If you had "run" somewhere in your path you could just do:

```
# run echo_two "hello world." 
hello world. hello world.
```

So long as there is a `run_file` available, there is always a function called `help`, that will list the available functions.

```
# run help 
... usage and a list of functions available ...
```

## Working Directory

The working directory is changed to the location of the `run_file` before commands in it are executed, so that you can use paths relative to it.
The working directory is changed back to it's original location after the commands are run.

## Function Names

The binary provides a command called "help" it will list all the functions in your `run_file` that do not start with "\_"

```python
# run_file

def _hidden_function(args):
    pass
```

If no function name is passed to the binary it will look for a function named "default", and run it if it exists.

```python
# run_file

def default(args):
    print("I run when you pass no arguments.")
```

```
# ./run
I run when you pass no arguments.
```
    
## License

Apache. See the LICENSE file in the root of the the repository for specifics.

