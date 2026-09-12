### Struture
```
chat.completion
├── id, model, created, object
├── choices[]              ← массив, но сервер всегда даёт один элемент
│   └── { index, finish_reason, message: { role, content } }
└── usage
    ├── prompt_tokens: 18, completion_tokens: 3, total_tokens: 21
    └── prompt_tokens_details.cached_tokens: 0
```
 
    