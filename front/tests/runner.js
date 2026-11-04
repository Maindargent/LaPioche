// Mini lanceur de tests, sans dépendance : ouvrez tests/index.html dans le
// navigateur (http://localhost:8080/tests/) pour voir les résultats.

const tests = [];

export function test(name, fn) {
  tests.push({ name, fn });
}

function describe(value) {
  return typeof value === "string" ? JSON.stringify(value) : JSON.stringify(value) ?? String(value);
}

export function assertTrue(condition, message = "la condition devrait être vraie") {
  if (!condition) throw new Error(message);
}

export function assertEqual(actual, expected, message = "") {
  if (describe(actual) !== describe(expected)) {
    throw new Error(`${message ? `${message} : ` : ""}attendu ${describe(expected)}, obtenu ${describe(actual)}`);
  }
}

export function assertIncludes(text, part, message = "") {
  if (!String(text).includes(part)) {
    throw new Error(`${message ? `${message} : ` : ""}${describe(text)} devrait contenir ${describe(part)}`);
  }
}

// Attend qu'une condition devienne vraie (l'interface se met à jour après des appels asynchrones).
export async function waitFor(condition, message = "la condition n'est jamais devenue vraie", timeout = 2000) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    if (await condition()) return;
    await new Promise((resolve) => setTimeout(resolve, 20));
  }
  throw new Error(`délai dépassé : ${message}`);
}

export async function run() {
  const output = document.querySelector("#results");
  const failures = [];
  let passed = 0;

  for (const { name, fn } of tests) {
    const item = document.createElement("li");
    try {
      await Promise.race([
        fn(),
        new Promise((_, reject) => setTimeout(() => reject(new Error("le test dépasse 5 secondes")), 5000)),
      ]);
      passed += 1;
      item.className = "pass";
      item.textContent = `✓ ${name}`;
    } catch (error) {
      failures.push({ name, message: error.message });
      item.className = "fail";
      item.textContent = `✗ ${name} : ${error.message}`;
    } finally {
      document.querySelectorAll("iframe[data-test-frame]").forEach((frame) => frame.remove());
    }
    output.append(item);
  }

  const summary = `${passed} réussi${passed > 1 ? "s" : ""}, ${failures.length} échec${failures.length > 1 ? "s" : ""}`;
  document.querySelector("#summary").textContent = summary;
  document.querySelector("#summary").className = failures.length === 0 ? "pass" : "fail";
  document.title = `${failures.length === 0 ? "OK" : "ÉCHEC"} - ${summary}`;
  window.testResults = { passed, failed: failures.length, failures };
}
