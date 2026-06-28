import { describe, it, expect, vi } from 'vitest';
import { readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { parse as parseYaml } from 'yaml';
import type { Router } from 'express';

// 외부 I/O 모듈은 import 시점 부수효과(redis Queue/GCS 클라이언트 생성)를 피하려 목.
// 이 테스트는 라우팅 테이블만 필요하다.
vi.mock('./modules/analyses/analysis.queue.js', () => ({ enqueueAnalysis: vi.fn() }));
vi.mock('./lib/storage.js', () => ({ uploadImage: vi.fn() }));

import { routeGroups } from './routes.js';

const HTTP_METHODS = new Set(['get', 'post', 'put', 'delete', 'patch', 'options', 'head']);

// ── 코드의 실제 엔드포인트 추출 (Express 라우터 stack 인트로스펙션) ──
// 결과 형식: "post /sessions/guest" — openapi 와 맞추려 /v1 prefix 제거 + :param→{param}.
function endpointsFromCode(): Set<string> {
  const out = new Set<string>();
  for (const [mount, router] of routeGroups) {
    const stack = (router as Router & { stack: RouterLayer[] }).stack;
    for (const layer of stack) {
      if (!layer.route) continue;
      const full = normalizePath(mount + layer.route.path);
      for (const method of Object.keys(layer.route.methods)) {
        if (HTTP_METHODS.has(method)) out.add(`${method} ${full}`);
      }
    }
  }
  return out;
}

interface RouterLayer {
  route?: { path: string; methods: Record<string, boolean> };
}

function normalizePath(p: string): string {
  let s = p.replace(/^\/v1/, ''); // openapi 의 paths 는 /v1 미포함(servers url 에 있음)
  s = s.replace(/:([A-Za-z0-9_]+)/g, '{$1}'); // :id → {id}
  if (s.length > 1 && s.endsWith('/')) s = s.slice(0, -1); // 끝 슬래시 제거
  return s;
}

// ── openapi.yaml 의 선언된 엔드포인트 추출 ──
function endpointsFromSpec(): Set<string> {
  const specPath = path.join(
    path.dirname(fileURLToPath(import.meta.url)),
    '../../docs/plans/openapi.yaml',
  );
  const doc = parseYaml(readFileSync(specPath, 'utf8')) as {
    paths: Record<string, Record<string, unknown>>;
  };
  const out = new Set<string>();
  for (const [p, item] of Object.entries(doc.paths)) {
    for (const method of Object.keys(item)) {
      if (HTTP_METHODS.has(method)) out.add(`${method} ${p}`);
    }
  }
  return out;
}

describe('API 계약 가드 — 코드 라우트 ↔ openapi.yaml 동기화', () => {
  const code = endpointsFromCode();
  const spec = endpointsFromSpec();

  it('실제 엔드포인트가 추출된다(인트로스펙션 sanity — 가드가 헛돌지 않음 보장)', () => {
    // 양쪽 추출기가 실제 데이터를 만들어야 아래 일치 비교가 의미를 가진다.
    expect(code.size).toBeGreaterThanOrEqual(10);
    expect(spec.size).toBeGreaterThanOrEqual(10);
    // 대표 엔드포인트가 양쪽에서 정확히 추출되는지(prefix/param 정규화 포함) 못박는다.
    for (const e of ['post /sessions/guest', 'post /friends/{friendUserId}/follow', 'get /feed']) {
      expect(code.has(e), `코드 추출 누락: ${e}`).toBe(true);
      expect(spec.has(e), `스펙 추출 누락: ${e}`).toBe(true);
    }
  });

  it('스펙에 없는 라우트가 없어야 한다(문서 누락 차단)', () => {
    const undocumented = [...code].filter((e) => !spec.has(e)).sort();
    expect(
      undocumented,
      `openapi.yaml 에 누락된 엔드포인트(코드엔 있음):\n${undocumented.join('\n')}`,
    ).toEqual([]);
  });

  it('라우트 없는 스펙 항목이 없어야 한다(유령 스펙 차단)', () => {
    const phantom = [...spec].filter((e) => !code.has(e)).sort();
    expect(phantom, `구현 없는 openapi.yaml 항목(스펙엔 있음):\n${phantom.join('\n')}`).toEqual([]);
  });
});
