# Oracle Database Vector Search

Oracle AI Vector Search feature allow you to store, index and search vector data within the Oracle Database.

Vector data is a representation of unstructured data as a multidimensional array. Vector search allows you to search for similar patterns within the semantic of the unstructured data: text, images, audio, and video.

Oracle Database support a vector Data Type for a seamless integration; indexes and search query capabilities included.

For the Generative AI, AI Vector Search at Oracle Database support Retrieval Augmented Generation (RAG) to increase higher accuracy and avoids hallucinations on LLMs based on private knowledge base.

[Oracle AI Vector Search User's Guide](https://docs.oracle.com/en/database/oracle/oracle-database/23/vecse/index.html)

One of the biggest benefits of Oracle AI Vector Search is that semantic search on unstructured data can be combined with relational search on business data in one single system.

Vector Search is often considered better than keyword search as vector search is based on the meaning and context behind the words and not the actual words themselves.

## Embeddings

Embeddings are AI models that transform unstructured data into numbers. Those numbers can be understood as vectors un a 2D Euclidean geometry, but in higher dimensions. We can calculate proximity of the points to reflect similarity in meaning. This proximity helps in text classification, semantic search, and even product recommendations.

## Tokens

The first and last step in Embedding is to convert words to tokens and finally convert tokens into words.

## Retrieval Augmented Generation

To improve accurate AI model responses, Retrieval Augmented Generation involves a ETL (extract, Transform and Load) batch processing that reads unstructed data from your documents, transforms it, and then writes it into a Vector Search database.

The vector database is used in the retrieval part of the RAG technique.

You need to split the original document into smaller pieces. The split needs to hold the semantic boundaries of the content. The split parts size must be a small percentage of the AI Model's token limit.

The final user prompt along with the similar documents found by the vector search are sent to the AI model for composing the final answer to the final user.

## Content

- [Spring AI for RAG on Oracle 23ai Vector DB with OpenAI and private LLMs](https://github.com/oracle-devrel/springai-rag-db23ai)
- [RAG with OCI, LangChain, and VLLMs](https://github.com/oracle-devrel/technology-engineering/blob/rag-marketing-update/cloud-infrastructure/ai-infra-gpu/AI%20Infrastructure/rag-langchain-vllm-mistral/README.md)
