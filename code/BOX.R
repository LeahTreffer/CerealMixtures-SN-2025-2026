# Connect to BOX
# Workflow by ChatGPT

# Do this for each person's R to connect them to thier own BOX account
# Should only have to do this script once to establsish BOX connection

# https://r-box.github.io/boxr/articles/boxr.html
install.packages("boxr")
library(boxr)

# 1. Create a Box Developer App
## go to https://app.box.com/developers/console and log in using account the shared BOX has access to

# 2. Create new App
## Create New App → Custom App → OAuth 2.0 with JWT (Server Authentication) or OAuth 2.0 (User Authentication)
### If you want to access your own Box files → Choose OAuth 2.0 (User Authentication)
#### This is the one I chose on Oct 30
### If this will run automatically on a server → Choose OAuth 2.0 with JWT

# 3. Name your app (e.g., R-Box-Connector)

# 4. Get credentials & apply desired settings
## App Settings → scroll down to OAuth 2.0 Credentials

### Leah's info (this will be unique for other people)
### Developer Tolken: OtthyNW4FQrrAIM9Di6fZxkiA49bCqzH
### Client ID: bamza65junx3iksnkq2jyo8dc4xo5aok
### Client Secret: Guj1WmaR4rC6FckY1TAbFWVUTNWC4lCb

# Add a redirect URL (allows R package to authenticate)
## http://localhost:1410/

# Application Scope
## check Read all files.. and Write all files... 

# 5. Save changes

# 6. Authenticate (replace with individual's info)
box_auth(client_id = "bamza65junx3iksnkq2jyo8dc4xo5aok", client_secret = "Guj1WmaR4rC6FckY1TAbFWVUTNWC4lCb")
# opens as website window, click grant access 

box_auth_on_attach()

# test authentication 
box_dir_create("test-folder")        # Create a folder
box_ls()                             # List files/folders in your root Box
box_ul("test-folder", "data.csv")    # Upload a file
