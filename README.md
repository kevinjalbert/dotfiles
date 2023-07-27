# Dotfiles

TODO: Flesh this README out more, this is a WIP of how to use this on a fresh install.

## Setup SSH/GPG

Use passphrases for both SSH and GPG keys. They should exist in 1Password as secure notes.

When setting up on a new machine, I like setting up a new SSH key. The old SSH Keys should be removed from GitHub

### Setup SSH

```bash
ssh-keygen -t rsa -b 4096 -C "kevin.j.jalbert@gmail.com"`
eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_rsa
pbcopy < ~/.ssh/id_rsa.pub
```

Make sure to add a passphrase (1password generated)

Take the key and add it to GitHub's SSH settings (https://github.com/settings/keys)

### Setup GPG

First we need to set the right permissions for the `gnupg` directory/files:

```bash
sudo chown -R $(whoami) ~/.gnupg
sudo find ~/.gnupg -type f -exec chmod 600 {} \;
sudo find ~/.gnupg -type d -exec chmod 700 {} \;
``

Next we pull down the Keybase public/private GPG keys from 1Password and import them locally via `gpg`:

```bash
cat keybase-public.key | gpg --import
cat keybase-private.key | gpg --allow-secret-key-import --import
```

Use the passphrase from 1Password

The following "shouldn't be needed", but incase a new GPG key is needed, it can be generated following this [guide](https://github.com/pstadler/keybase-gpg-github).

Also, don't remove older GPG keys from GitHub as it'll invalid the commits that have been signed with it in the past.

## Setup [asdf version manager](https://github.com/asdf-vm/asdf)

### Setup Ruby

`asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git`

> take a look at this -- https://github.com/asdf-vm/asdf-ruby#default-gems

`asdf install ruby <version>`

### Setup Node.js

`asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git`

> take a look at this -- https://github.com/asdf-vm/asdf-nodejs#default-npm-packages

`asdf install nodejs <version>`

### Getting it all going

TODO: get a shell script I can kick off like the homebrew one (URL based I can pass into bash)
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      kevinjalbert/dotfiles/HEAD/bootstrap.sh or something that gets everything _ready_

A bunch of steps of things to do, will likely need to be refined:

#### Initial apps

- Log in to App Store with Apple Id
  - Install XCode

- Install homebrew
  - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

- `brew install dropbox 1password`
  - Login Dropbox
  - Wait for files to sync of files (can take a while depending on amount of files)
  - Login to 1Password

#### Rake commands

- `cd ~/Dropbox/dotfiles`
- `rake install:brew_packages`
  - Enter password as needed
  - Take note of what failed
- `rake install:brew_cask_packages`
  - Enter password as needed
  - Take note of what failed
- `rake install:mas`
- `rake install:mackup`
- `rake update:mackup`
  - Might want to double check first `DRY_RUN=true rake update:mackup`
  - Accept overwrites as needed (mostly should all be yes)
- `rake install:zplug`
  - Enter password as needed (changing default shell)
- `rake update:zplug`
  - Before this, open a new shell or get into zsh first (need to see if I can force it via script)
- `rake install:fzf_bindings`
  - Yes to things, it should all be there anyways so it'll know
- `rake install:vim_plug`
- `rake update:vim`
- `rake install:macos`
- Restart

#### Manual setup (apps and other tweaks)

- Might have to allow certain apps to run still due to increase security in macOS (https://github.com/toland/qlmarkdown/issues/98#issuecomment-607733093)
- For most apps install required helpers, ensure notifications work, grant required permissions, and set to open on login

- Set default view in finder
  - Open finder
  - Select your hard disc
  - Command+J
  - Check the top two check boxes (Always open in list view, browse in list view)
  - Click use as defaults
  - Probably don't need to use the .DS_Store delete given new system
    - https://apple.stackexchange.com/a/284468

- Setup keyboard function keys show all the time
  - touchbar shows F# keys
  - Fn key does nothing
  - hold Fn Key shows control strip
  - Use F# keys on external keyboard

- Setup trackpad settings
  - three finger drag (just search for it), and tap to click (if it didn't get set)
  - Disable force click if possible

- Setup Apple Watch to unlock Mac in System Settings > Security and Privacy

- Open Google Chrome
  - Login as kevin.j.jalbert@gmail.com
  - Address extensions upon syncing
  - Set as default browser in system preferences

- Setup internet accounts
  - iCloud
    - disable contacts and photos
  - joint (only contacts)
  - main (only calendar)

- Open Music
  - Authorize computer (under Account in menu)
  - Wait for everything to sync

- Open Messages
  - Enable SMS linking from phone

- Open Messenger
  - Login

- Open Bartender
  - Set permissions
  - Ensure license is set

- Open iStats Menu
  - Install component

- Open Discord
  - Login via QR code scan on mobile

- Open KeepingYouAwake

- Open Spark
  - Login using kevin.j.jalbert@gmail.com account
  - Ensure settings kinda match up (email notifications being 'Smart', Dock count being whole inbox)
  - Set the avatars and labels

- Open Books
  - Account > Authorize

- Open TablePlus

- Open VSCode
  - Login with Github for Setting Sync

- Open Rectangle
  - Grant permissions

- Open Obsidian
  - Connect up vault (icloud)
  - Might have to ensure that all the 'files' are actually loaded locally in iCloud

- Open Calendar
  - Ensure right calendar accounts are showing up

- Open Contacts
  - Didn't seem to sync over for whatever reason las time (need to check)
  - Set default to join account

- Open Dash
  - Grant permissions
  - Ensure that the sync is working (should be)
  - Ensure that license is enabled

- Open Flux

- Open Karabiner Elements
  - Grant permissions

- Open HammerSpoon
  - Grant permissions
  - Open on login

- Open ImageOptim
  - Enable Guetzli
  - Set image processing level to insane

- Open Keybase
  - Login

- Open Postman
  - Login

- Open ProxyMan
  - Install helper
  - Open preferences > Advance and make it restore the previous HTTPS proxy when ProxyMan closes

- Install readwise (https://readwise.io/ibooks)
  - Install
  - Open and Login

- Open RescueTime
  - Login
  - Grant permissions

- Install https://github.com/sbarex/SourceCodeSyntaxHighlight

- Open Steam
  - Login

<!-- # Might not be a good idea - Reduce spotlight indexing (so we don't waste CPU and SSD)
  - Settings > Spotlight
    - Uncheck the search results (keep events/remidners -- so calendar search still works)
    - Throw home directory in Privacy -->

- Open Raycast
  - Ensure the hotkey is set to cmd+space
  - Ensure settings carry over

<!-- - Open Alfred
  - Setup License
  - Use Setting Sync
  - Setup Spotlight -> Alfred Keyboard shortcut
  - Change Theme to Wider Alfred OS
  - Ensure Snippets auto-expand (Alfred > Snippets > Check automatic expand)
  - Give require permisions (press button in pref) -->

- Open Shottr
  - Setup settings and set license
  - Set select area hotkey as Cmd+shift+4

- Setup login in items

- Set up dock
  - Add spacers `defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}' && killall Dock`

- Setup SSH and GPG
  - Look at above steps

- Setup asdf
  - Use steps above
