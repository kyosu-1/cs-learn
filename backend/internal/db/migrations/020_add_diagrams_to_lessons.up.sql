-- Add Mermaid diagrams to existing lessons

-- Process state transition diagram (OS)
INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('20000000-0000-0000-0000-000000000001', 'diagram', '{"diagram_type": "mermaid", "source": "stateDiagram-v2\n    [*] --> New\n    New --> Ready : admit\n    Ready --> Running : dispatch\n    Running --> Ready : timeout\n    Running --> Waiting : I/O request\n    Waiting --> Ready : I/O complete\n    Running --> [*] : exit"}', 2);

-- Full adder circuit diagram (Architecture)
INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('40000000-0000-0000-0000-000000000011', 'diagram', '{"diagram_type": "mermaid", "source": "graph LR\n    A[A] --> XOR1[XOR]\n    B[B] --> XOR1\n    XOR1 --> XOR2[XOR]\n    Cin[Cin] --> XOR2\n    XOR2 --> Sum[Sum]\n    A --> AND1[AND]\n    B --> AND1\n    XOR1 --> AND2[AND]\n    Cin --> AND2\n    AND1 --> OR[OR]\n    AND2 --> OR\n    OR --> Cout[Cout]"}', 2);

-- Pipeline stages diagram (Architecture)
INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('40000000-0000-0000-0000-000000000002', 'diagram', '{"diagram_type": "mermaid", "source": "graph LR\n    IF[IF\\nInstruction\\nFetch] --> ID[ID\\nInstruction\\nDecode]\n    ID --> EX[EX\\nExecute]\n    EX --> MEM[MEM\\nMemory\\nAccess]\n    MEM --> WB[WB\\nWrite\\nBack]\n    style IF fill:#4361ee,color:#fff\n    style ID fill:#2ecc71,color:#fff\n    style EX fill:#e74c3c,color:#fff\n    style MEM fill:#f39c12,color:#fff\n    style WB fill:#9b59b6,color:#fff"}', 1);

-- DNS resolution flow (Network)
INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000004', 'diagram', '{"diagram_type": "mermaid", "source": "sequenceDiagram\n    participant B as Browser\n    participant R as Recursive Resolver\n    participant Root as Root DNS\n    participant TLD as .com TLD\n    participant Auth as example.com Auth\n    B->>R: www.example.com?\n    R->>Root: .com の NS は?\n    Root-->>R: a.gtld-servers.net\n    R->>TLD: example.com の NS は?\n    TLD-->>R: a.iana-servers.net\n    R->>Auth: www.example.com の A は?\n    Auth-->>R: 93.184.216.34\n    R-->>B: 93.184.216.34"}', 1);

-- TCP 3-way handshake (Network)
INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('30000000-0000-0000-0000-000000000002', 'diagram', '{"diagram_type": "mermaid", "source": "sequenceDiagram\n    participant C as Client\n    participant S as Server\n    Note over S: LISTEN\n    C->>S: SYN (seq=x)\n    Note over C: SYN_SENT\n    S->>C: SYN+ACK (seq=y, ack=x+1)\n    Note over S: SYN_RCVD\n    C->>S: ACK (ack=y+1)\n    Note over C,S: ESTABLISHED"}', 1);

-- Memory hierarchy (Architecture)
INSERT INTO lesson_blocks (lesson_id, block_type, content, sort_order) VALUES
('40000000-0000-0000-0000-000000000003', 'diagram', '{"diagram_type": "mermaid", "source": "graph TD\n    REG[Registers\\n< 1ns] --> L1[L1 Cache\\n1-2ns]\n    L1 --> L2[L2 Cache\\n3-10ns]\n    L2 --> L3[L3 Cache\\n10-30ns]\n    L3 --> RAM[DRAM\\n50-100ns]\n    RAM --> SSD[SSD\\n10-100μs]\n    SSD --> HDD[HDD\\n5-10ms]\n    style REG fill:#e74c3c,color:#fff\n    style L1 fill:#f39c12,color:#fff\n    style L2 fill:#f1c40f,color:#000\n    style L3 fill:#2ecc71,color:#fff\n    style RAM fill:#3498db,color:#fff\n    style SSD fill:#9b59b6,color:#fff\n    style HDD fill:#95a5a6,color:#fff"}', 1);
