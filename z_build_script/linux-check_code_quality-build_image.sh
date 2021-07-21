#-------------------------------------------------------------------------------------------------------------------
# Checking potential npm issues
#-------------------------------------------------------------------------------------------------------------------
echo "An opportunity to check potential npm issues."
npm doctor
#-------------------------------------------------------------------------------------------------------------------
# Checking the potential npm security issues
#-------------------------------------------------------------------------------------------------------------------
npm audit
npm audit fix

#-------------------------------------------------------------------------------------------------------------------
# Checking the code quality with SonarQube
#-------------------------------------------------------------------------------------------------------------------
echo "Starting the SonarQube server."
gnome-terminal -- bash -c 'sonar.sh start; sleep 90'
echo "Waiting for the SonarQube server to start."
sleep 90

echo "Starting the analysis."
gnome-terminal -- bash -c 'cd .. ; sonar-scanner \
  -Dsonar.projectKey=front-end \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=6fb38c8274cb8efccba8778aef56d226e7550659; sleep 100'
  
echo "Waiting for the analysis to be done."
sleep 40 

echo "Starting a browser to check the result of the analysis."
chromium-browser http://localhost:9000 &
sleep 100

#--------------------------------------------------------------------------------------------------------------------
# Preparing the build of the Docker image
#--------------------------------------------------------------------------------------------------------------------
cd ..
echo "Starting the ng build."
ng build --prod

echo "Website files moving in context folder."
cp -Rfu dist/AccessibleTodoList-FrontEnd/*.* z_build_script/context/html
cp -Rfu dist/AccessibleTodoList-FrontEnd/assets z_build_script/context/html


echo "Building the new image."
cd z_build_script/context
sudo docker build -t atl-front-end:v0.9 .
cd ../..

