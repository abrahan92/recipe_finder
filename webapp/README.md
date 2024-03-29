# 🚀 Recipe Finder Rails WEBAPP 🚀

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

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.