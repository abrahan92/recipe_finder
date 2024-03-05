import React from "react";
import {
  Card,
  CardContent,
  CardMedia,
  Grid,
  Rating,
  Typography,
} from "@mui/material";

interface Recipe {
  cook_time: number;
  cuisine: string;
  image: string;
  ingredients_list: string[];
  prep_time: number;
  ratings: number;
  title: string;
}

type RecipeCardProps = {
  item: Recipe;
};

const RecipeCard = ({ item }: RecipeCardProps) => {
  const { cook_time, image, ingredients_list, prep_time, ratings, title } =
    item;

  return (
    <Grid item xs={12} sm={6} md={4} lg={3}>
      <Card sx={{ height: "100%" }}>
        <CardMedia component="img" height="150" image={image} alt={title} />
        <CardContent>
          <Typography gutterBottom variant="h6">
            {title}
          </Typography>
          <Typography variant="body2" color="text.secondary" gutterBottom>
            Ingredients: {ingredients_list.join(", ")}
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Prep Time: {prep_time} minutes
          </Typography>
          <Typography variant="body2" color="text.secondary" gutterBottom>
            Cook Time: {cook_time} minutes
          </Typography>
          <Rating name="read-only" value={ratings} readOnly />
        </CardContent>
      </Card>
    </Grid>
  );
};

export default RecipeCard;
