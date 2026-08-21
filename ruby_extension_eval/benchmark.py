
import json
from pathlib import Path
import tiktoken

from headroom.transforms.code_compressor import CodeAwareCompressor


SAMPLES = [
    "sample1.rb",
    "sample2.rb",
    "sample3.rb",
    "sample4.rb",
    "sample5.rb",
]


def count_tokens(text):
    enc = tiktoken.get_encoding("cl100k_base")
    return len(enc.encode(text))


def main():
    compressor = CodeAwareCompressor()
    results = []

    for filename in SAMPLES:
        path = Path("/content") / filename
        code = path.read_text()

        original_tokens = count_tokens(code)

        result = compressor.compress(
            code,
            language="ruby",
        )

        compressed_tokens = count_tokens(result.compressed)

        savings = (
            (original_tokens - compressed_tokens)
            / original_tokens
            * 100
        )

        results.append({
            "sample": filename,
            "original_tokens": original_tokens,
            "compressed_tokens": compressed_tokens,
            "token_savings_percent": round(savings, 2),
            "syntax_valid": result.syntax_valid,
        })

    average_savings = sum(
        r["token_savings_percent"] for r in results
    ) / len(results)

    output = {
        "extension": "Ruby support for CodeAwareCompressor",
        "samples": len(results),
        "results": results,
        "average_token_savings_percent": round(average_savings, 2),
    }

    Path("/content/benchmark_results.json").write_text(
        json.dumps(output, indent=2)
    )

    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
