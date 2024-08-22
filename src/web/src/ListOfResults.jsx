import { Skeleton, Stack } from "@mui/material";
import HotelCard from "./HotelCard";

function ListOfResults({ children: items, waiting }) {
  if (waiting) {
    return <Skeleton variant="text" sx={{ fontSize: "1rem" }} />;
  }
  if (!items) {
    return null;
  }

  return (
    <Stack
      spacing={2}
      sx={{
        minWidth: "100%",
        maxWidth: "500px",
      }}
    >
      {items.map((item, idx) => (
        <HotelCard key={idx}>{item}</HotelCard>
      ))}
    </Stack>
  );
}

export default ListOfResults;
