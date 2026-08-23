import fnmatch
from pathlib import Path, PurePosixPath
import zipfile


def load_gitignore_patterns(root: Path) -> list[str]:
    patterns: list[str] = []
    for name in (".gitignore", ".gitingore"):
        gitignore = root / name
        if not gitignore.exists():
            continue
        with gitignore.open("r", encoding="utf-8") as f:
            for raw in f:
                line = raw.strip()
                if not line or line.startswith("#"):
                    continue
                patterns.append(line)
    return patterns


def is_ignored(rel_path: str, patterns: list[str]) -> bool:
    rel = rel_path.replace("\\", "/")
    for pattern in patterns:
        candidate = pattern.replace("\\", "/")
        if not candidate:
            continue

        match = fnmatch.fnmatch(rel, candidate)
        if match:
            return True

        if candidate.endswith("/"):
            dir_pattern = candidate.rstrip("/")
            if rel == dir_pattern or rel.startswith(dir_pattern + "/"):
                return True

        if candidate.startswith("/"):
            if fnmatch.fnmatch(rel, candidate.lstrip("/")):
                return True

    return False


def should_include(rel_path: str, patterns: list[str]) -> bool:
    rel = rel_path.replace("\\", "/")
    if rel in {".git", ".gitignore", ".gitingore"}:
        return False
    if is_ignored(rel, patterns):
        return False

    if rel.startswith("textures/"):
        parts = PurePosixPath(rel).parts
        if len(parts) > 3:
            return False

    return True


def zip_mod(root: Path, output_zip: Path) -> None:
    patterns = load_gitignore_patterns(root)

    with zipfile.ZipFile(output_zip, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for path in sorted(root.rglob("*")):
            if path.is_dir():
                continue
            rel = path.relative_to(root).as_posix()
            if not should_include(rel, patterns):
                continue
            zf.write(path, rel)

    print(f"Created: {output_zip}")


if __name__ == "__main__":
    root = Path(__file__).resolve().parent
    output_zip = root / f"{root.name}.zip"
    zip_mod(root, output_zip)
