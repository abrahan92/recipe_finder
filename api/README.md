# 🚀 Recipe Finder Rails API 🚀

## ⚙️ Features

- 🥄 **Ingredient-Based Search**: Type in what you have, and let us find the recipes for you.
- 🔍 **Auto-Complete Ingredient Suggestions**: Our smart search suggests ingredients as you type.
- 📈 **Ranked Search Results**: Find the best recipes, ranked by popularity and rating, at the top of your list.
- 🔄 **Refined Match**: Use the 'Refined Match' toggle to narrow down results to recipes that strictly include all selected ingredients.

## 👨🏻‍🔬 User Stories

1. **As a** user,  
   **I want to** enter ingredients I have,  
   **So that** I can quickly find top-rated recipes using those ingredients.

2. **As a** user,  
   **I want to** receive smart suggestions when inputting ingredients, 
   **So that** I can quickly get recipes that contains some of the ingredients that I have.

3. **As a** user,  
   **I want to** toggle between broad and strict recipe matches,  
   **So that** I can either explore a variety of recipes or focus on ones that use only my available ingredients.

## 🚀 Deployment

- `API` is deployed on Fly on this url: https://recipe-finder-api.fly.dev/ingredients/search?name=flour

- `WEBAPP` on https://recipe-finder-webapp.fly.dev/

## 🌐 Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### 🔑 Prerequisites
To run this project, ensure you have the following installed on your machine:

#### [Docker Desktop](https://www.docker.com/products/docker-desktop) 
Docker provides an easy-to-use desktop application that includes everything you need to build, share, and run containerized applications.

Visit the Docker [Desktop official page](https://www.docker.com/products/docker-desktop).
Choose the appropriate version for your operating system (Windows/Mac) and download the installer.
Follow the installation instructions and, once installed, start Docker Desktop from your applications folder.

#### [Docker Compose](https://docs.docker.com/compose/install/)

If you're using Windows or Mac, Docker Compose is included as part of the Docker Desktop installation. For Linux users:
Ensure you have Docker installed.

Follow the official [installation](https://docs.docker.com/compose/install/) guide for Docker Compose.

⚠️ **Note**: If you're using Docker and Docker Compose to run the application, you won't need to manually install the following dependencies, as they'll be containerized. However, if you choose to run the application outside of Docker, ensure you have the following installed:

#### [Ruby](https://www.ruby-lang.org/en/downloads/) (version 3.0.0)
#### [Rails](https://rubyonrails.org/) (version 7)
#### [Bundler](https://bundler.io/) (for managing Ruby gems)

### 💽 Installing

1.  Clone the repo:
         git clone https://github.com/abrahan92/recipe_finder.git

2.  Navigate into the directory the api directory:
         cd api

## 💻 ENV Variables

**1.** Verify you have `.envrc` in the project root and run allowdirenv to load all the env variables before running the `docker-compose up -d` command

## 🐳 Docker

Also provide a Dockerfile and DockerCompose for running the api with Docker containers.

After having docker and docker-compose installed and the ENV variables set, run:

    docker-compose up -d

## 📁 Project Structure
The application is structured around the Rails conventions.

**app/models** <br/><br/>
Contains the ActiveRecord models that represent the data structure of the application. Models are used to interact with the database and define relationships between different data entities.

**app/services** <br/><br/>
Here you can find 2 files that handle the bulk import and ingredients parsing.

**tmp/data** <br/><br/>
Place where have the recipe dataset to be procesed, also have a minified version
to be used in the localenviroment to avoid long time running.

**config/data** <br/><br/>
Here have the ingredients cleanup rules file to be used by the IngredientParser to
normalize the ingredients before storing on the db.

**app/controllers** <br/><br/>
This folder contains the Rails controllers, which handle the incoming HTTP requests and return the corresponding responses.

**config/** <br/><br/>
Contains configuration files and routes for the Rails application.

**db/** <br/><br/>
Includes database migrations, schema, and seeds.

**spec/** <br/><br/>
Root directory for all the tests. It's recommended to have corresponding test files for each of the main components files.