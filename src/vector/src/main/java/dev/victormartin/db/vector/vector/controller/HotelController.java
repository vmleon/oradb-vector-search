package dev.victormartin.db.vector.vector.controller;

import dev.victormartin.db.vector.vector.dao.*;
import dev.victormartin.db.vector.vector.entities.Hotel;
import dev.victormartin.db.vector.vector.repository.HotelRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
public class HotelController {

    Logger log = LoggerFactory.getLogger(HotelController.class);

    @Autowired
    HotelRepository hotelRepository;

    @GetMapping("/api/hotels")
    public List<HotelGetResponse> getAllHotels() {
        log.info("Get all hotels");
        List<Hotel> all = hotelRepository.findAll();

        List<HotelGetResponse> response = all.stream()
                .map(h -> new HotelGetResponse(h.getId(), h.getName(), h.getDescription(), h.getCity(), h.getCountry()))
                .collect(Collectors.toUnmodifiableList());
        return response;
    }

    @PostMapping("/api/hotels")
    public HotelCreateResponse createHotel(@RequestBody HotelCreateRequest request) {
        log.info("Create hotel");
        Hotel hotel = new Hotel();
        hotel.setName(request.name());
        hotel.setDescription(request.description());
        hotel.setCity(request.city());
        hotel.setCountry(request.country());

        Hotel saved = hotelRepository.save(hotel);

        HotelCreateResponse response =
                new HotelCreateResponse(saved.getId(),
                        saved.getName(),
                        saved.getDescription(),
                        saved.getCity(),
                        saved.getCountry());
        return response;
    }

    @PostMapping("/api/hotels/search")
    public List<HotelSearchResponse> search(@RequestParam String q,
                                            @RequestBody(required = false) HotelSearchRequest request) {
        int topN = 3;
        if (request != null) {
            try {
                topN = Integer.parseInt(request.n());
            } catch(NumberFormatException ex) {
                topN = 3;
            }
        }
        log.info("Searching hotels with query '{}' and topN {}", q, topN);
        List<Hotel> all = hotelRepository.searchBySimilarity(q, topN);
        List<HotelSearchResponse> response = all.stream()
                .limit(topN)
                .map(h -> new HotelSearchResponse(h.getId(),
                        h.getName(),
                        h.getDescription(),
                        h.getCity(),
                        h.getCountry()))
                .collect(Collectors.toUnmodifiableList());
        return response;
    }

    @GetMapping("/api/hotels/country")
    public List<HotelGetResponse> getHotelsByCountry() {
        log.info("Get hotels by country");
        List<Hotel> all = hotelRepository.searchExampleByCity("Barcelona");

        List<HotelGetResponse> response = all.stream()
                .map(h -> new HotelGetResponse(h.getId(), h.getName(), h.getDescription(), h.getCity(), h.getCountry()))
                .collect(Collectors.toUnmodifiableList());
        return response;
    }
}
