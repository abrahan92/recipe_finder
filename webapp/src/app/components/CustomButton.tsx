import React from "react";
import { Button, Grid } from "@mui/material";

type CustomButtonProps = {
  disabled: boolean;
  label: string;
  onClick: () => void;
};

const CustomButton = ({ disabled, label, onClick }: CustomButtonProps) => {
  return (
    <Grid item xs={12} sm={2}>
      <Button
        disabled={disabled}
        fullWidth
        onClick={onClick}
        size="large"
        variant="contained"
      >
        {label}
      </Button>
    </Grid>
  );
};

export default CustomButton;
