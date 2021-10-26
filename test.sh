echo "Welcome to Boilard's config installer TM"

# Create a .config dir where most config files will be stored.
echo "Creating .config directory."
configDir=$HOME/.config
if [ ! -d "$configDir" ]; then
  mkdir $HOME/.config
  echo ".config directory created."
else
  echo ".config already exists. Moving on.."
fi
