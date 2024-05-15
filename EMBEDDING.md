# Embedding

[Spring AI Embeddings API Transformers (ONNX)](https://docs.spring.io/spring-ai/reference/api/embeddings/onnx.html).

Sentence embeddings using a sentence transformer.

Sentence transformer models, serialized into the Open Neural Network Exchange (ONNX) format.

The [Deep Java Library](https://djl.ai/) and the Microsoft [ONNX Java Runtime libraries](https://onnxruntime.ai/docs/get-started/with-java.html) are applied to run the ONNX models and compute the embeddings in Java.

## Serialize with optimum-cli

We need to serialize the Tokenizer and the Transformer Model into ONNX format.

```bash
python3 -m venv venv
source ./venv/bin/activate
pip install --upgrade pip
pip install optimum onnx onnxruntime sentence_transformers
optimum-cli export onnx --model sentence-transformers/all-MiniLM-L6-v2 onnx-output-folder
```

## Oracle Database support

Convert a string into a `VECTOR` type:

```sql
SELECT
  TO_VECTOR(VECTOR_EMBEDDING(doc_model USING 'Hello world' AS data)) AS embedding;
```
