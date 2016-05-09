How to run:
1. Install ruby-1.9.3. (The apis of service-desk is not avaliable for personal VM now.)

2. Generate api key (keep it secret)
  - Login manage engine
  - Click "Personalize" in right up corner
  - Select API Key Generation
  - Generate key

3. Open config/config.rb

4. Modify $manage_engine_path. Paste the api key to $api_key.

5. Run "bundle install"

6. Run script "ruby myapp.rb -o 0.0.0.0" to start up the server

7. You can write a bash script and put in Startup folder, so it can start the service whenever you restart the computer.
startup.sh:
cd /C/Users/xxx/Desktop/ManageEngineHelper
ruby myapp.rb -p 4567