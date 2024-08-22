import { useEffect, useState } from "react";
import { Alert, Button, Container, Stack, TextField } from "@mui/material";
import ListOfResults from "./ListOfResults";
import AppTitle from "./AppTitle";

function App() {
  const [searchInput, setSearchInput] = useState("");
  const [query, setQuery] = useState("");
  const [waiting, setWaiting] = useState(false);
  const [searchHotelData, setSearchHotelData] = useState([]);
  const [searchHotelError, setSearchHotelError] = useState();

  useEffect(() => {
    const fetchSearch = async () => {
      try {
        setWaiting(true);
        const body = await fetch(`/api/hotels/search?q=${query}`, {
          method: "POST",
        });
        if (body.ok) {
          const data = await body.json();
          setSearchHotelData(data);
          setSearchHotelError("");
        } else {
          setSearchHotelData([]);
          setSearchHotelError(`${body.status} ${body.statusText}`);
        }
      } catch (error) {
        setSearchHotelData([]);
        setSearchHotelError(error.message);
      } finally {
        setWaiting(false);
      }
    };

    if (searchInput.length) {
      fetchSearch();
    }
  }, [query]);

  return (
    <Container>
      <Stack alignItems="center" spacing={3}>
        <AppTitle />
        <Stack spacing={1}>
          <Stack
            sx={{
              width: "100%",
            }}
            direction="row"
            spacing={2}
          >
            <TextField
              id="search-input"
              label="Search Hotels"
              sx={{ minWidth: "400px" }}
              multiline
              rows={2}
              onChange={({ target }) => {
                setSearchInput(target.value);
              }}
            />
            <Button
              sx={{ alignSelf: "flex-end" }}
              disabled={!searchInput.length}
              onClick={() => {
                setQuery(searchInput);
              }}
            >
              Browse
            </Button>
          </Stack>
          {searchHotelError && (
            <Alert severity="error">{searchHotelError}</Alert>
          )}
          <ListOfResults waiting={waiting}>{searchHotelData}</ListOfResults>
        </Stack>
      </Stack>
    </Container>
  );
}

export default App;
