# Testing & Refactoring

## Testing

* Use **Swift Testing** framework, not XCTest.
* Tests must be in **Swift**, not ObjC.

---

## Refactoring workflow

When refactoring (e.g., ObjC → Swift):

1. **Write tests first** (if none exist).
   * Test coverage must be **high for the code being refactored** (not the whole project):
     * target **~80%+** at minimum;
     * **prefer 100%** where practical.

2. **Refactor code.**

3. **Run tests** to verify nothing broke.
