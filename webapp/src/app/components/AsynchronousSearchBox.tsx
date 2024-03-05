import React, { useState, useEffect, useCallback } from "react";
import { Autocomplete, TextField, CircularProgress, Grid } from "@mui/material";
import { debounce } from "lodash";

export type ingredientType = {
  id: number;
  name: string;
};

export type ingredientsType = ingredientType[];

type setIngredientsType = React.Dispatch<React.SetStateAction<ingredientsType>>;

type AsynchronousSearchBoxProps = {
  ingredients: ingredientsType;
  setIngredients: setIngredientsType;
  selectedIngredients: ingredientsType;
  setSelectedIngredients: setIngredientsType;
};

const AsynchronousSearchBox = ({
  ingredients,
  setIngredients,
  selectedIngredients,
  setSelectedIngredients,
}: AsynchronousSearchBoxProps) => {
  const [inputValue, setInputValue] = useState("");
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [searchTerms, setSearchTerms] = useState([] as string[]);

  const addNewIngredients = (newIngredients: ingredientsType) => {
    setIngredients((prevOptions) => {
      const updatedOptions = [...prevOptions, ...newIngredients];

      return deduplicateOptions(updatedOptions);
    });
  };

  const deduplicateOptions = (options: ingredientsType): ingredientsType => {
    const uniqueIds = new Set(options.map((option) => option.id));

    return Array.from(uniqueIds).map(
      (id) => options.find((option) => option.id === id) as ingredientType
    );
  };

  const fetchIngredients = async (searchValue: string) => {
    setLoading(true);

    try {
      const encodedSearchValue = encodeURIComponent(searchValue);
      const url = `http://localhost:3005/ingredients/search?name=${encodedSearchValue}`;
      const response = await fetch(url);
      const data = await response.json();

      if (data?.length > 0) addNewIngredients(data);
    } catch (error) {
      console.error("Failed to fetch ingredients:", error);
    } finally {
      setLoading(false);
    }
  };

  const debouncedFetchIngredients = useCallback(
    debounce(fetchIngredients, 600),
    []
  );

  useEffect(() => {
    if (inputValue) {
      const foundIfTermExists = searchTerms.some((term: string) => {
        return term.toLowerCase().includes(inputValue.toLowerCase());
      });

      const searchTermExists = ingredients.some((option: ingredientType) =>
        option.name.toLowerCase().includes(inputValue.toLowerCase())
      );

      if (!foundIfTermExists) {
        setSearchTerms((prevTerms: string[]) => [...prevTerms, inputValue]);
      }

      if (!searchTermExists || !foundIfTermExists)
        debouncedFetchIngredients(inputValue);
    }
  }, [inputValue, debouncedFetchIngredients, ingredients]);

  return (
    <Grid item xs={12} sm={8}>
      <Autocomplete
        getOptionLabel={(option) => option.name}
        isOptionEqualToValue={(option, value) => option.id === value.id}
        loading={loading}
        multiple
        onChange={(e, newValue) => setSelectedIngredients(newValue)}
        onClose={() => setOpen(false)}
        onInputChange={(e, newInputValue) => setInputValue(newInputValue)}
        onOpen={() => setOpen(true)}
        open={open}
        options={ingredients}
        renderInput={(params) => (
          <TextField
            {...params}
            label="Search ingredients"
            InputProps={{
              ...params.InputProps,
              endAdornment: (
                <React.Fragment>
                  {loading ? (
                    <CircularProgress color="inherit" size={20} />
                  ) : null}
                  {params.InputProps.endAdornment}
                </React.Fragment>
              ),
            }}
          />
        )}
        value={selectedIngredients}
      />
    </Grid>
  );
};

export default AsynchronousSearchBox;
