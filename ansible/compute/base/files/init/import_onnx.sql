BEGIN
    DBMS_VECTOR.LOAD_ONNX_MODEL( 'DATA_PUMP_DIR', 'all_MiniLM_L12_v2.onnx', 'doc_model' );
END;
/

EXIT;