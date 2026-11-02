---
name: nextjs-route-handler
description: "Creates Next.js App Router API route handlers (app/**/route.ts) with input validation, correct status codes and typed responses. Use when the user wants an API endpoint, webhook receiver or backend route in a Next.js app router project."
---
# Next.js route handler

## Step 1: Check the project
- `cat package.json`: Next.js major version, whether `zod` is installed, the package manager (lock file: `package-lock.json` npm, `pnpm-lock.yaml` pnpm, `yarn.lock` yarn, `bun.lock` bun).
- Find the app dir: `app/` or `src/app/`. Route handlers only work in the App Router.
- A `route.ts` cannot sit in the same folder as a `page.tsx`.

## Step 2: Write the handler
`src/app/api/projects/route.ts` (adjust to `app/` if there is no `src/`):
```ts
import { NextResponse } from "next/server";
import { z } from "zod";

const CreateProject = z.object({ name: z.string().min(1).max(120) });

export async function POST(request: Request) {
  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }
  const parsed = CreateProject.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Validation failed", issues: parsed.error.issues }, { status: 422 });
  }
  // create the record here
  return NextResponse.json({ data: { name: parsed.data.name } }, { status: 201 });
}
```
If zod isn't installed, ask before adding it (`npm install zod`) or validate by hand.

## Step 3: Dynamic segments
In Next.js 15 and later, `params` is a Promise:
```ts
export async function GET(_req: Request, { params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
}
```
On Next.js 14 and earlier, `params` is a plain object. Match the installed version.

## Step 4: Rules
- Check auth before doing work; return 401 (not signed in) or 403 (not allowed).
- Never return raw error objects or stack traces; log server-side, return a short message.
- Webhooks: verify the signature on the raw body (`await request.text()`) before parsing JSON.
- GET handlers are not cached by default from Next.js 15; on 14 add `export const dynamic = "force-dynamic"` when data must be fresh.

## Step 5: Verify
```bash
npx tsc --noEmit
npm run build
npm run dev   # then in another terminal:
curl -i -X POST localhost:3000/api/projects -H 'content-type: application/json' -d '{"name":"Demo"}'
curl -i -X POST localhost:3000/api/projects -H 'content-type: application/json' -d '{}'
```
Report the status codes you got.
