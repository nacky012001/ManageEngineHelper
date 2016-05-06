How to run:
1. Generate api key (keep it secret)
  - Login manage engine
  - Click "Personalize" in right up corner
  - Select API Key Generation
  - Generate key

2. Open config/config.rb

3. Modify $manage_engine_path. Paste the api key to $api_key.

4. Run "bundle install"

5. Run script "ruby myapp.rb -o 0.0.0.0" to start up the server

6. You can write a bash script and put in Startup folder, so it can start the service whenever you restart the computer.
startup.sh:
cd /C/Users/xxx/Desktop/ManageEngineHelper
ruby myapp.rb -p 4567