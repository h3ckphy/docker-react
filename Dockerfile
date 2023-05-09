# taggin this phase with a name using "as <phase name>"
FROM node:16-alpine as builder

# by putting "as builder" that means that from this FROM command and
# everything underneath it is all going to referred to as the builder phase
# and the sole purpose of this phase is to install dependencies and
# build our application

WORKDIR "/app"

COPY package.json .
RUN npm install
COPY . .

# now that we're doing this build phase and we don't have any concern over
# changing our source code, we don't have to make use of that entire volume system anymore
# That volume system that we were implementing with Docker Compose was only required
# because we wanted to develop our application and have our changes immediately show up
# inside the container. When we're running our code in a production environment
# that's not a concern anymore because we're not changing our code at all
# So we can just do a straight copy of all of our source code directly into the container

RUN npm run build

# output of this phase is going to be the 'build' folder (как .output в наксте)
# the path to that inside the container will be /app/build
# that's gonna have all the stuff we care about
# that's gonna be the folder that we're going to want to somehow
# copy over during our run phase (step 2 in run phase)

# now our build phase is put together
# We're gonna write out the configuration for the run phase
# this is going to be the phase that says we're going to use the Nginx image
# where we're gonna copy over the results of npm run build and then somehow
# start up nginx

# specifying the start of a second phase
# by just putting in a 2nd FROM statement that essentially says
# "ok, previous block all complete, don't worry about it"
# any single block or any single phase can only have a single FROM statement
# we can imagine that FROM statement we put in here
# are kind of terminating each successive block
FROM nginx

# so inside of here we're going to write out the command to copy over that build folder
# into this new kind of like nginx container thing that we're putting together
# this is saying "I want to copy over smth from that other phase that we just
# were working on"
# указываем phase из результата которого берем что-то,
# потом папку, которую берем из результата
# и потом папку в типо новом контейнере выделенном для nginx

COPY --from=builder /app/build /usr/share/nginx/html

# if we want o server up some static html content we just put it into this folder:
# /usr/share/nginx/html
# so anything inside of it is going to be served up by nginx when it starts up

# It turns out that the default command of the nginx image is going to start up nginx for us
# so we don't have to run anything to start up nginx 
# When we start up the nginx container it's just gonna take care of the command for us automatically
