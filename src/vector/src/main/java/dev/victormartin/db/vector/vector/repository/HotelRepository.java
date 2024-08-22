package dev.victormartin.db.vector.vector.repository;

import dev.victormartin.db.vector.vector.entities.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface HotelRepository extends JpaRepository<Hotel, Long> {
    @Query(
            value = "SELECT id, name, description, city, country " +
                    "FROM HOTELS u ORDER BY " +
                    "VECTOR_DISTANCE(" +
                    "       TO_VECTOR(VECTOR_EMBEDDING(DOC_MODEL USING :query AS DATA)), " +
                    "   DESCRIPTION_VECTOR, " +
                    "   EUCLIDEAN) " +
                    "FETCH FIRST :topK ROWS ONLY",
            nativeQuery = true)
    List<Hotel> searchBySimilarity(@Param("query") String query, @Param("topK") int topK);

    @Query(
            value = "SELECT h.id, h.name, h.description, h.city, h.country " +
                    "FROM HOTELS h " +
                    "WHERE h.city = :city",
            nativeQuery = true)
    List<Hotel> searchExampleByCity(@Param("city") String city);
}
