import { Stack, Typography } from "@mui/material";
import oracleLogo from "./assets/oracle.svg";

function AppTitle() {
  return (
    <Stack alignItems="center" direction="row" spacing={1}>
      <Typography variant="h2">H</Typography>
      <img src={oracleLogo} height={60} alt="Oracle Logo" loading="lazy" />
      <Typography variant="h2">tel with Vector Search</Typography>
    </Stack>
  );
}

export default AppTitle;
