import {
  Button,
  Card,
  CardActions,
  CardContent,
  CardHeader,
  Snackbar,
  Typography,
} from "@mui/material";
import { useState } from "react";

function HotelCard({ children: hotel }) {
  const [openAlert, setOpenAlert] = useState(false);

  const handleClick = () => {
    setOpenAlert(true);
  };

  const handleClose = (event, reason) => {
    if (reason === "clickaway") {
      return;
    }

    setOpenAlert(false);
  };

  return (
    <>
      <Card sx={{ minWidth: "200" }}>
        <CardHeader title={hotel.name}></CardHeader>
        <CardContent>
          <Typography variant="body2">{hotel.description}</Typography>
          <Typography sx={{ fontSize: 12 }} color="text.secondary" gutterBottom>
            {hotel.city} ({hotel.country})
          </Typography>
        </CardContent>
        <CardActions>
          <Button size="small" onClick={handleClick}>
            Book
          </Button>
        </CardActions>
      </Card>
      <Snackbar
        open={openAlert}
        autoHideDuration={3000}
        onClose={handleClose}
        message=";) Not yet implemented"
      />
    </>
  );
}

export default HotelCard;
