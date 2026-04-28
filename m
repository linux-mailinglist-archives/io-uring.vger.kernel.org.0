Return-Path: <io-uring+bounces-13155-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPG8NRqP8GnKUwEAu9opvQ
	(envelope-from <io-uring+bounces-13155-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 12:42:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79AC0482D3A
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 12:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C37C8301A773
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 10:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57AC3F23B2;
	Tue, 28 Apr 2026 10:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhBurYo/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13183F23AD;
	Tue, 28 Apr 2026 10:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372902; cv=none; b=bnb6KDbajWx1xDO+LgpyEf4beoScXk6RrDOTzepsj4AeK33n43LCbpluPPP/K3UnbA9ZE0h3VAojIrAticrn6QmWT1vpHbTJSB5txytBwOxFK/L/I19jLc80f27umzmZO8ALfh5J3DXN9idRdl6RT9GqyPWK6U9oKDABGy4IVT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372902; c=relaxed/simple;
	bh=QeNboGSJSRXtPmOjH1YXfc5ZIDYhbO5VfIYngbJPBQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZuy1hIRmqft90C1tyOjxABluFHe2/FsPw/YdNbuCDhGKDrfH1yJzTLyVUeusNdcNc9boZGcGhLM3ckVwafcgHopnyHk1j8MgJhhBFwGuF69qw34w1EJ9SekV2Oml2Y3lEvGc4rw/8pQFF0SWFwYsHH1GajEe4d/xsu9xoHAskA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhBurYo/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE48C2BCB6;
	Tue, 28 Apr 2026 10:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372902;
	bh=QeNboGSJSRXtPmOjH1YXfc5ZIDYhbO5VfIYngbJPBQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhBurYo/bDB5z6Tkwz9d98a8OJm2Y6S9e02SwqzqiGpnIxwjJyLAxRp2bHISwi6iQ
	 mfzN6KPXQCM4dQ17OUNTkX/MDdoZVsamkwHVvvHArHGXNiH8DSaEIMH1jDZWkygtxm
	 5vNP+aFLDnhL3jIiePrx20ZH7NYZLzSS949Tg7KGvROkJUdKaNCWcEx0Pe6iJTWjZ6
	 S69/FB6r1GBOiPF+oYUXDRr5DpfqfwmjnJ7MIeZfA8CRnqr1ojgj7/8m94Ag9FG4Qx
	 cT7iwlqHNvvXwKBuPOKkZR1PqKjYTpD44rU7zb901DuhyOiP0SE38KMlxSNbI7smd8
	 WCf0mfNiCEESg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] io_uring/rsrc: unify nospec indexing for direct descriptors
Date: Tue, 28 Apr 2026 06:40:17 -0400
Message-ID: <20260428104133.2858589-6-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 79AC0482D3A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13155-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.de:email]

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 53262c91f7b81f96495ff24e9d1fa8b1632e69c8 ]

For file updates, the node reset isn't capping the value via
array_index_nospec() like the other paths do. Ensure it's all sane and
have the update path do the proper capping as well.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough context. Let me write my analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line parse**
- Subsystem: `io_uring/rsrc`
- Action verb: "unify" (cleanup-style verb that often masks a fix)
- Record: `io_uring/rsrc` `unify` - bringing nospec indexing into one
  place across direct descriptor paths

**Step 1.2: Tag analysis**
- `Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>` - reviewed by
  an external developer
- `Signed-off-by: Jens Axboe <axboe@kernel.dk>` - io_uring maintainer
  (he wrote the patch)
- NO `Fixes:` tag
- NO `Cc: stable@vger.kernel.org`
- NO `Reported-by:`, `Link:`
- Record: Bare-bones tag set; reviewed once by SUSE engineer; author is
  the subsystem maintainer.

**Step 1.3: Body analysis**
- Bug description: "the node reset isn't capping the value via
  array_index_nospec() like the other paths do"
- Failure mode: Spectre v1 (Bounds Check Bypass / CVE-2017-5753)
  speculative side-channel
- Author explicitly contrasts the buggy file-update path with "the other
  paths" that already use `array_index_nospec()` (i.e., the buffer
  update path and `io_rsrc_node_lookup`)
- Record: This is missing Spectre v1 hardening on a user-reachable
  register-files-update code path.

**Step 1.4: Hidden bug fix detection**
- "unify" is cleanup language but the substance is restoring missing
  speculation protection on a user-controlled index. This is a real
  defensive-security fix (similar to the pattern of `b7620121dc04e`,
  `34bb77184123a`, `953c37e066f05`, and `29b95ac917927`, all of which
  were Spectre v1 nospec fixes).
- Record: This IS a hidden bug fix - missing Spectre v1 protection.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `io_uring/rsrc.c`: +3 lines in `__io_sqe_files_update()`
- `io_uring/rsrc.h`: +6/-1 lines in `io_reset_rsrc_node()` inline
- Total: 10 insertions, 2 deletions across 2 files
- Scope: single-file-pair, single subsystem, surgical
- Record: ~10 line surgical change in one helper + one caller.

**Step 2.2: Code flow change**
- Before in `__io_sqe_files_update`: `i = up->offset + done;
  io_reset_rsrc_node(...)` - relies only on the upfront architectural
  check at line 222 (`up->offset + nr_args > ctx->file_table.data.nr`)
- After: explicit `if (i >= ctx->file_table.data.nr) break;` then `i =
  array_index_nospec(i, ...)` - speculation barrier
- Before in `io_reset_rsrc_node`: `data->nodes[index]` directly without
  index hardening
- After: bounds-check-then-nospec-mask before dereferencing
  `data->nodes[index]`
- Index parameter widened from `int` to `unsigned int` (safer for the
  comparison with unsigned `data->nr`)
- Record: Adds Spectre v1 mitigation in two places (caller-side and
  helper-side, defense-in-depth).

**Step 2.3: Bug mechanism**
- Category: Memory safety / Spectre v1 (Bounds Check Bypass)
- Mechanism: User passes `up->offset` and `nr_args`. The upfront check
  at line 222 is architecturally correct, but on speculation, a CPU
  could mispredict the bounds branch and do a speculative
  `data->nodes[i]` load with i out of bounds, leaving observable cache
  state. `array_index_nospec()` is the canonical mitigation.
- Record: Spectre v1 / CVE-2017-5753 hardening on a user-reachable index
  load.

**Step 2.4: Fix quality**
- Obviously correct - the pattern is identical to surrounding code
  (`io_rsrc_node_lookup`, `__io_sqe_buffers_update`)
- No semantic change for non-malicious callers (architectural bounds
  were already guaranteed)
- Zero regression risk: only adds an extra bounds-check + nospec mask on
  an existing index
- Record: High-quality, low-risk hardening.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- The helper `io_reset_rsrc_node()` was added by `4007c3d8c22a2`
  ("io_uring/rsrc: add io_reset_rsrc_node() helper", Jens Axboe, Oct 29
  2024) — first appears in v6.13.
- Before that refactor (v6.12), `__io_sqe_files_update` had `i =
  array_index_nospec(up->offset + done, ctx->nr_user_files);` — verified
  by `git show v6.12:io_uring/rsrc.c`. So v6.12 was protected.
- Record: Bug introduced in 4007c3d8c22a2 (v6.13) by inadvertently
  dropping `array_index_nospec()` during the helper extraction.

**Step 3.2: Fixes: tag follow-through**
- No Fixes: tag in this commit. Logical Fixes target is `4007c3d8c22a2`,
  present in v6.13 and later.
- Record: Bug regression introduced in v6.13; absent in v6.12 LTS.

**Step 3.3: Related changes / file history**
- `io_uring/rsrc.h` recently saw `82dadc8a49475` ("take unsigned index
  in io_rsrc_node_lookup()", Jan 2026) — related index typing cleanup
- This commit takes the same step for `io_reset_rsrc_node`
- Record: Latest in a series of small index-safety improvements; no
  prerequisites required.

**Step 3.4: Author**
- Jens Axboe is the io_uring maintainer; he both wrote 4007c3d8c22a2
  (introduced the regression) and authors this fix.
- Record: Subsystem maintainer authored.

**Step 3.5: Dependencies**
- The patch uses only existing primitives (`array_index_nospec`, the
  existing `data->nr` field, the existing helper signature). Standalone.
- Record: Standalone, no prerequisites.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original submission**
- `b4 dig -c 53262c91f7b81` found patch 2/6 of "Various bug fixes"
  series at lore.kernel.org/all/20260421135626.581917-3-axboe@kernel.dk
- Cover letter ("PATCHSET 0/6 Various bug fixes") explicitly describes
  the patches:
  - "Patch 2, spectre masking for file updates."
  - Patch 6 is the only one with `Cc: stable@kernel.org` (a different
    patch with a clear regression Fixes:)
- Record: Submitted as part of a 6-patch series; cover-letter labels
  this one as "spectre masking" specifically (separate category from
  "defensive cleanups").

**Step 4.2: Reviewers (b4 dig -w)**
- Original recipients: `Jens Axboe`, `io-uring@vger.kernel.org`
- Reply thread: Gabriel Krisman Bertazi (SUSE) gave Reviewed-by
- Record: Reviewed by external developer (SUSE).

**Step 4.3: Bug report**
- No Reported-by / Link tags. No bug report - this is proactive
  hardening.
- Record: Proactive Spectre v1 mitigation, no specific user-triggered
  report.

**Step 4.4: Series context**
- Series: 1/6 (defensive cleanup, not reachable), 2/6 (this - spectre
  masking), 3/6 (defensive cleanup), 4/6 (defensive hardening), 5/6
  (futex actual fix, has Fixes:), 6/6 (ring resize actual fix, has
  Fixes: + Cc: stable)
- Record: Standalone within the series; doesn't depend on the others.

**Step 4.5: Stable list history**
- Not searched in detail. Note: the author chose NOT to Cc stable on
  this specific patch.
- Record: No explicit stable nomination, but author historically doesn't
  cc-stable Spectre hardening either (precedent: similar nospec fixes
  953c37e066f05/29b95ac917927 went to stable via maintainer-tagged
  Fixes:).

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Modified functions**
- `__io_sqe_files_update()` - handles `IORING_REGISTER_FILES_UPDATE`
- `io_reset_rsrc_node()` - inline helper used in 4 places

**Step 5.2: Callers**
- `io_reset_rsrc_node()` callers (verified by Grep):
  - `io_uring/rsrc.c:241` - in `__io_sqe_files_update()` (this fix's
    site)
  - `io_uring/rsrc.c:320` - in `__io_sqe_buffers_update()` (already
    nospec'd at the caller)
  - `io_uring/filetable.c:79` - in `io_install_fixed_file()` (called for
    direct fd installs; bounds-checked at line 72)
  - `io_uring/filetable.c:138` - in `io_fixed_fd_remove()` (bounds-
    checked at line 132)
- All 4 are user-reachable via io_uring register/update operations.
- Record: 4 call sites; all reachable from userspace via io_uring
  `register` syscall paths.

**Step 5.3: Callees**
- `io_reset_rsrc_node()` calls `io_put_rsrc_node()` and indexes
  `data->nodes[index]`. The `array_index_nospec()` mask is now applied
  before the indexed load.

**Step 5.4: Reachability**
- The path is reachable from userspace via
  `io_uring_register(IORING_REGISTER_FILES_UPDATE, ...)`. Any process
  with io_uring access can hit it.
- Record: User-reachable from a basic syscall path.

**Step 5.5: Similar patterns**
- `io_rsrc_node_lookup()` already does the same pattern (bounds check +
  nospec mask)
- `__io_sqe_buffers_update()` already does the nospec mask at the caller
- This commit harmonizes the file-update path and the helper itself
- Past similar fixes: `b7620121dc04e` (2019), `34bb77184123a` (2022),
  `953c37e066f05` (2023), `29b95ac917927` (2024) - all backported
- Record: Identical pattern to a long lineage of accepted Spectre v1
  nospec fixes.

## PHASE 6: CROSS-REFERENCING / STABLE TREE

**Step 6.1: Buggy code in stable**
- `io_reset_rsrc_node()` introduced in `4007c3d8c22a2` (v6.13). Stable
  trees v6.13.y onward inherit the missing nospec.
- v6.12.y LTS does NOT have this regression (the function itself doesn't
  exist there).
- Record: Affected stable trees: v6.13.y - v6.19.y. v6.12 LTS
  unaffected.

**Step 6.2: Backport difficulty**
- The diff context is small. The function shape has been stable since
  v6.13 with only minor signature changes (e.g., `82dadc8a49475` made
  `io_rsrc_node_lookup` index unsigned in Jan 2026). Backport should
  apply nearly cleanly to active stable trees that have
  `io_reset_rsrc_node`.
- Record: Likely clean apply on v6.13+ stable trees; v6.12 LTS not
  applicable.

**Step 6.3: Related fixes already in stable**
- `953c37e066f05` and similar nospec fixes are already in older stable
  kernels.
- Record: This is the latest in the series; no overlap.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- `io_uring/` - heavily used core async I/O subsystem reachable by any
  unprivileged process; security-sensitive.
- Criticality: IMPORTANT (used by many distros, databases, language
  runtimes).

**Step 7.2: Activity**
- Highly active subsystem with frequent fixes. Spectre and registration-
  path hardening is an ongoing theme.

## PHASE 8: IMPACT / RISK

**Step 8.1: Affected users**
- Any user of io_uring fixed-files (`IORING_REGISTER_FILES_UPDATE`) on a
  kernel >= v6.13. That's a large population - any process able to call
  `io_uring_setup`.

**Step 8.2: Trigger**
- Trigger: a userspace caller invokes `IORING_REGISTER_FILES_UPDATE`
  with a manipulated offset to mistrain a CPU branch predictor for a
  Spectre v1 attack. Architecturally bounded, but exposes a speculative-
  load gadget to any unprivileged caller.
- Record: Unprivileged userspace can reach the path.

**Step 8.3: Failure mode**
- Pure architectural correctness is unaffected; the failure mode is
  *information disclosure* via a Spectre v1 side channel. Severity for a
  sanitizer/Spectre hardening category: MEDIUM-HIGH (security hardening,
  defense-in-depth, no crash but real CVE class).

**Step 8.4: Risk-Benefit**
- Benefit: closes a known speculative gadget on a user-reachable indexed
  load - matches a long-standing pattern of accepted backports.
- Risk: ~10 lines, identical to widely-deployed pattern in adjacent
  code, fully verifiable. Very low.
- Record: High benefit / very low risk.

## PHASE 9: SYNTHESIS

**Step 9.1: Evidence**
- FOR backporting:
  - Spectre v1 (CVE-2017-5753 class) speculative-load gadget on a user-
    reachable path.
  - Restores protection that existed in v6.12 and was lost during the
    v6.13 helper extraction (`4007c3d8c22a2`).
  - 10-line surgical change identical in pattern to multiple historical
    nospec fixes that DID go to stable (`b7620121dc04e`,
    `34bb77184123a`, `953c37e066f05`, `29b95ac917927`).
  - Defense-in-depth: hardens both the caller and the helper.
  - Reviewed-by external developer. Maintainer-authored.
- AGAINST:
  - No `Fixes:` tag, no `Cc: stable` (notable since other patches in the
    same series do have them).
  - Cover letter labels this as "spectre masking" rather than "actual
    fix".
  - Architectural bound check already exists at line 222-223 in
    `__io_sqe_files_update`; the issue is purely speculative-execution.
- UNVERIFIED: Did not exhaustively check every active stable branch for
  divergence; reliant on grep/log of mainline.

**Step 9.2: Stable rules**
1. Obviously correct and tested? YES (10 lines, well-known pattern,
   reviewed).
2. Fixes a real bug? YES (Spectre v1 class info-leak gadget, regression
   vs v6.12).
3. Important issue? YES (security hardening, CVE class, user-reachable).
4. Small and contained? YES (10 lines, 2 files, 1 subsystem).
5. No new features or APIs? YES.
6. Apply to stable trees? YES for v6.13.y+ (helper exists there).

**Step 9.3: Exception category**
- Falls under defensive security hardening with strong precedent
  (multiple prior nospec fixes in io_uring backported).

**Step 9.4: Decision**
- Borderline by author's tagging choice but technically a Spectre v1
  mitigation that follows a well-established pattern of stable-eligible
  io_uring nospec fixes. Restores protection lost in v6.13.

## Verification

- [Phase 1] Read commit message via `git show
  53262c91f7b81f96495ff24e9d1fa8b1632e69c8`: confirmed `Reviewed-by:
  Gabriel Krisman Bertazi`, `Signed-off-by: Jens Axboe`, no `Fixes:`, no
  `Cc: stable`.
- [Phase 2] Diff analysis: confirmed 3 added lines in
  `io_uring/rsrc.c::__io_sqe_files_update()` and 6 added/1 removed in
  `io_uring/rsrc.h::io_reset_rsrc_node()`. Index type widened to
  `unsigned int`.
- [Phase 2] Read post-fix `io_uring/rsrc.c` lines 211-272 and
  `io_uring/rsrc.h` lines 90-140 to verify the upfront bounds check at
  line 222 and the resulting helper shape.
- [Phase 3] `git log -- io_uring/rsrc.c | head` and `git log
  --grep="io_reset_rsrc_node"`: located helper introduction
  `4007c3d8c22a2` (Oct 29 2024).
- [Phase 3] `git tag --contains 4007c3d8c22a2 | grep "^v"` (via prefix
  match): no results means the tag is in v6.13+ (helper introduced for
  v6.13).
- [Phase 3] `git show v6.12:io_uring/rsrc.c`: verified v6.12 had `i =
  array_index_nospec(up->offset + done, ctx->nr_user_files);` so this is
  a true regression introduced by the helper extraction.
- [Phase 4] `b4 dig -c 53262c91f7b81f96495ff24e9d1fa8b1632e69c8`:
  matched lore URL `https://lore.kernel.org/all/20260421135626.581917-3-
  axboe@kernel.dk/`.
- [Phase 4] `b4 dig -w`: original recipients limited to Jens Axboe and
  io-uring list.
- [Phase 4] Saved mbox via `b4 dig -m`: cover-letter explicitly
  classifies this patch as "spectre masking for file updates"; only
  patch 6/6 has `Cc: stable@kernel.org`. Patch 5/6 has `Fixes:` for an
  old commit but no Cc: stable; this one (patch 2/6) has neither.
- [Phase 4] Verified `Reviewed-by: Gabriel Krisman Bertazi` reply in the
  saved mbox at line 1490.
- [Phase 5] `Grep "io_reset_rsrc_node"` across `io_uring/`: found 4
  callers (rsrc.c:241, rsrc.c:320, filetable.c:79, filetable.c:138), all
  in user-reachable register paths. Inspected `filetable.c:62-141` to
  confirm both call sites are bounds-checked at the architectural level
  but lacked a nospec mask before the helper.
- [Phase 5] Located historical precedents: `git log
  --grep="^io_uring.*nospec"` returned `953c37e066f05`, `4cdd158be9d09`,
  `34bb77184123a`, `b7620121dc04e`. Inspected `b7620121dc04e` and
  `34bb77184123a` to confirm pattern (Spectre v1 nospec on indexed
  register paths).
- [Phase 6] Stable affected: v6.13+ (since helper introduction); v6.12
  LTS unaffected (different code structure with existing nospec).
- [Phase 8] Failure mode classified as Spectre v1 information disclosure
  on a user-reachable indexed load; severity MEDIUM-HIGH (security CVE
  class).
- UNVERIFIED: Did not check each individual active stable tree (v6.13.y
  through v6.19.y) line-for-line for backport conflicts; assessment
  based on the limited churn around the helper since v6.13.
- UNVERIFIED: Did not directly confirm whether
  953c37e066f05/29b95ac917927 actually landed in every stable branch
  (relied on the historical pattern of similar nospec fixes being
  backported).

## Decision rationale

This is a small (~10 line) Spectre v1 mitigation that restores
`array_index_nospec()` protection on a user-reachable indexed-load
gadget that was inadvertently dropped when the `io_reset_rsrc_node()`
helper was extracted in v6.13. It applies the same idiom already used in
the buffer-update path (`__io_sqe_buffers_update`) and the lookup helper
(`io_rsrc_node_lookup`), and it directly mirrors a long line of similar
nospec fixes that have been backported (`b7620121dc04e`,
`34bb77184123a`, `953c37e066f05`, `29b95ac917927`). The patch is
reviewed, surgical, regression-free, maintainer-authored, and addresses
a genuine speculative-execution gadget reachable by any unprivileged
process that can use io_uring. Although the author did not add `Cc:
stable` or a `Fixes:` tag (a deliberate choice noted on the cover-letter
as "spectre masking" rather than "actual fix"), the technical merits
clearly satisfy the stable rules: real CVE-class bug, important, small,
contained, no new functionality, applies cleanly to the affected stable
trees (v6.13+).

**YES**

 io_uring/rsrc.c | 3 +++
 io_uring/rsrc.h | 9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1b96ab5e98c99..7953f38af1eb0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -238,6 +238,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			continue;
 
 		i = up->offset + done;
+		if (i >= ctx->file_table.data.nr)
+			break;
+		i = array_index_nospec(i, ctx->file_table.data.nr);
 		if (io_reset_rsrc_node(ctx, &ctx->file_table.data, i))
 			io_file_bitmap_clear(&ctx->file_table, i);
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index cff0f8834c353..44e3386f7c1ca 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -109,10 +109,15 @@ static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node
 }
 
 static inline bool io_reset_rsrc_node(struct io_ring_ctx *ctx,
-				      struct io_rsrc_data *data, int index)
+				      struct io_rsrc_data *data,
+				      unsigned int index)
 {
-	struct io_rsrc_node *node = data->nodes[index];
+	struct io_rsrc_node *node;
 
+	if (index >= data->nr)
+		return false;
+	index = array_index_nospec(index, data->nr);
+	node = data->nodes[index];
 	if (!node)
 		return false;
 	io_put_rsrc_node(ctx, node);
-- 
2.53.0


