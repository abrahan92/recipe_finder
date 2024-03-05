"use client";

import React, { useState } from "react";
import { FormControlLabel, Grid, Switch, Typography } from "@mui/material";
import AsynchronousSearchBox, {
 ingredientType,
 ingredientsType,
} from "./components/AsynchronousSearchBox";

import CustomButton from "./components/CustomButton";
import RecipeCard from "./components/RecipeCard";

const Home = () => {
 const [ingredients, setIngredients] = useState<ingredientsType>([]);
 const [selectedIngredients, setSelectedIngredients] =
  useState<ingredientsType>([]);

 const [recipes, setRecipes] = useState([]);
 const [totalRecipes, setTotalRecipes] = useState(0);
 const [loading, setLoading] = useState(false);
 const [currentPage, setCurrentPage] = useState(1);
 const [totalPages, setTotalPages] = useState(0);
 const [exactMatching, setExactMatching] = useState(false);

 const handleReset = () => {
  setSelectedIngredients([]);
  setRecipes([]);
  setTotalRecipes(0);
  setLoading(false);
  setCurrentPage(1);
  setTotalPages(0);
  setExactMatching(false);
 };

 const handleSearch = async (isLoadMore = false) => {
  setLoading(true);

  const nextPage = isLoadMore ? currentPage + 1 : 1;

  const ingredientNames = selectedIngredients
   .map((ingredient: ingredientType) => ingredient.name.replace(/\s+/g, "+"))
   .join(",");

  const url = `http://localhost:3005/recipes/search?ingredients=${ingredientNames}&page=${nextPage}&exact_match=${exactMatching}`;

  try {
   const response = await fetch(url);
   const data = await response.json();

   setRecipes(isLoadMore ? [...recipes, ...data.recipes] : data.recipes);
   setTotalRecipes(data.meta.total_count);
   setCurrentPage(nextPage);
   setTotalPages(data.meta.total_pages);
  } catch (error) {
   console.error("Failed to fetch recipes:", error);
  } finally {
   setLoading(false);
  }
 };

 return (
  <main
   style={{
    margin: "auto",
    maxWidth: "90%",
    paddingBottom: 40,
    paddingTop: 40,
   }}
  >
   <FormControlLabel
    control={
     <Switch
      checked={exactMatching}
      onChange={() => setExactMatching(!exactMatching)}
     />
    }
    label="Refined match"
   />
   <Grid container spacing={2} alignItems="center" my={3}>
    <AsynchronousSearchBox
     ingredients={ingredients}
     setIngredients={setIngredients}
     selectedIngredients={selectedIngredients}
     setSelectedIngredients={setSelectedIngredients}
    />
    <CustomButton
     disabled={selectedIngredients.length === 0}
     onClick={() => handleSearch(false)}
     label="Search recipe"
    />
    <CustomButton disabled={false} onClick={handleReset} label="Clear" />
   </Grid>
   {totalRecipes > 0 && (
    <Typography mb={1}>You can make {totalRecipes} recipes</Typography>
   )}
   <Grid container spacing={4} mb={4}>
    {recipes.map((item, index) => (
     <RecipeCard item={item} key={index} />
    ))}
   </Grid>
   {recipes.length > 0 &&
    selectedIngredients.length > 0 &&
    totalPages !== currentPage && (
     <CustomButton
      disabled={loading}
      onClick={() => handleSearch(true)}
      label="Show more"
     />
    )}
  </main>
 );
};

export default Home;
