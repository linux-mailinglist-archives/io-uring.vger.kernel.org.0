Return-Path: <io-uring+bounces-13447-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOpfKriaDWoMzwUAu9opvQ
	(envelope-from <io-uring+bounces-13447-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:27:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1503858C6AA
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:27:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A342231496CC
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 11:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746A73DCDB5;
	Wed, 20 May 2026 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSDlUDOC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CD93DC4B1;
	Wed, 20 May 2026 11:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276009; cv=none; b=sVWGBmfgww3yRNAvU8Rrbn6sM+aQOZmibwYm5Gi71loIPmuJaPcldadNUpsVlvAKWI7rvyOJXHLS1YYHYCiethCziXT7WitGckLeamiAqLMxfoPpkqYrUGItBNFgY+XeL4+tpQNNu2voeRSKmuChTrqFf8BXyq6s4VWyhA/PezE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276009; c=relaxed/simple;
	bh=YBxiAIRhLLuhZloB1Bm/OKO7SGTkSns5aVZuj2FDPYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZGrQqdA2RwI7xNhwSz20PoH+XFGHaYvg2eJ3QGscDPJJbVAyHnH4ubgcNViQx0ky5TO1tYGcRdOomOu2z8c91cofEQ0cXy39/cCq9b1I/lWr2lRikLBEDeivV2efMg44KB5F8Az6tG6clUnuP0+UanHUVENx23xLWDJUNDV3Wvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSDlUDOC; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBAE1F00896;
	Wed, 20 May 2026 11:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276003;
	bh=NuW4Ocbcj6Nn7fwFtaRlCC1fPw05KhvfeqQ4pb/u2yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSDlUDOCgMK9gQhkcNUg8G/iqJu8Luq4AWWmku1+goTUjV+3T/0o8dyic7BXZVzBX
	 I1aEtYJ07ob4v7hVLTUu4i9a7WZTCc4AEPB2F3naO58jrqsPBzw20SmAJBksYiEO2z
	 lQy2AXo2Lq0B1Hd4NmSqPmu6/cKl1t/Y7KGke21cd3z7OvreDlk4P8hWEpU4cW/woo
	 jIVaODN+2WqP5uA9FtteiZ+lMVDPmOY+o5W7N/SBxLTmENmS1xHkjKAwxMUnQFKq9T
	 orf4gBog0X7QXnFpK9ZGqOJMrRQRlKZSecRHcaXyWyMgLfRuhj7A47DIpU/Y6dIKj3
	 5/6LN9vkTPeGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] io_uring: hold uring_lock when walking link chain in io_wq_free_work()
Date: Wed, 20 May 2026 07:18:45 -0400
Message-ID: <20260520111944.3424570-13-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13447-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[msgid.link:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:email]
X-Rspamd-Queue-Id: 1503858C6AA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 20c39819a27646573dfa0ac0d01c38895298a6f6 ]

io_wq_free_work() calls io_req_find_next() from io-wq worker context,
which reads and clears req->link without holding any lock. This can
potentially race with other paths that mutate the same chain under
ctx->uring_lock.

Take ctx->uring_lock around the io_req_find_next() call. Only requests
with IO_REQ_LINK_FLAGS reach this path, which is not the hot path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `io_uring`; action verb `hold`; intent:
serialize linked-request chain walking in `io_wq_free_work()` with
`ctx->uring_lock`.

Step 1.2 Record: Tags present in commit
`20c39819a27646573dfa0ac0d01c38895298a6f6`:
- `Signed-off-by: Jens Axboe <axboe@kernel.dk>`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org` tags in the committed
  message.

Step 1.3 Record: The commit states that `io_wq_free_work()` calls
`io_req_find_next()` from io-wq worker context, and `io_req_find_next()`
reads and clears `req->link` without a lock. The stated failure mode is
a potential race with other paths mutating the same chain under
`ctx->uring_lock`. No stack trace, reproducer, affected-version
statement, or user report is in the commit message.

Step 1.4 Record: This is a hidden bug fix despite the subject not saying
“fix”: it adds missing synchronization around shared linked-request
state. The diff confirms it is not a cleanup or feature.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `io_uring/io_uring.c`, 6 insertions
and 1 deletion. Only `io_wq_free_work()` is modified. Scope: single-file
surgical locking fix.

Step 2.2 Record: Before, `io_wq_free_work()` called
`io_req_find_next(req)` directly when `IO_REQ_LINK_FLAGS` was set.
After, it stores `req->ctx`, takes `ctx->uring_lock`, calls
`io_req_find_next(req)`, and unlocks. The affected path is io-wq worker
completion/freeing of linked requests, not the normal unlinked hot path.

Step 2.3 Record: Bug category is synchronization/race condition.
`io_req_find_next()` reads `req->link` and clears it; `git grep`
verified other link-chain assignment/mutation sites in
submission/timeout paths. The fix serializes this worker-side chain walk
with the mutex used by normal chain mutation paths.

Step 2.4 Record: The fix is obviously small and locally correct: it
protects exactly the shared `req->link` read/clear. Regression risk is
low but not zero, because it adds a mutex acquisition in worker cleanup.
The commit message and code both verify the path is limited to requests
with `IO_REQ_LINK_FLAGS`.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` on the pre-fix parent showed the current
direct `io_wq_free_work()` call to `io_req_find_next()` came from
`247f97a5f19b64`, described by `git describe` as `v6.5-rc1~235^2~10`.
Older helper-based worker cleanup existed before that;
`io_wq_free_work()`/io-wq callback code is present from at least
`v5.15-rc1~185^2~41`, and stable branch checks show equivalent
vulnerable helper paths in `5.10.y`, `5.15.y`, and `6.1.y`.

Step 3.2 Record: No `Fixes:` tag is present, so there was no tagged
introducing commit to follow.

Step 3.3 Record: Recent `io_uring/io_uring.c` history includes related
io-wq/refcount work, notably `390513642ee676` / stable variants,
“io_uring: always do atomic put from iowq,” which changed the same
function and was KCSAN/syzbot-motivated. Mainline related commits
immediately after this candidate are `49ae66eb8c273` and
`a65855ec34aed`, the other two patches in the linked-request locking
series.

Step 3.4 Record: `MAINTAINERS` verifies Jens Axboe is the `IO_URING`
maintainer. `git log --author='Jens Axboe' -- io_uring` shows multiple
recent io_uring commits by him.

Step 3.5 Record: Build-wise this patch is standalone for trees with the
current direct `io_wq_free_work()` shape. For older stable trees using
`io_put_req_find_next()`, it needs a manual backport into the helper or
equivalent worker path. Semantically, it is patch 1/3 of a related
locking series; patches `49ae66eb8c273` and `a65855ec34aed` should be
considered with it to complete the linked-chain locking invariant.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 20c39819a2764` found the original submission
at `https://patch.msgid.link/20260511182217.226763-2-axboe@kernel.dk`.
`b4 dig -a` found only v1. The saved mbox shows this was `[PATCH 1/3]`.

Step 4.2 Record: `b4 dig -w` showed the patch was sent by Jens Axboe to
`io-uring@vger.kernel.org`, with Jens on Cc. No separate
reviewer/maintainer tags or replies were found in the saved matched
thread.

Step 4.3 Record: No bug-report link or `Reported-by:` tag exists. Web
search for the exact subject did not find a direct bug report.

Step 4.4 Record: The mbox cover letter says the series is “Linked
request fix” and “closing some gaps on linked requests, where iterating
a chain must hold either ->uring_lock OR ->timeout_lock, and modifying
any existing [chain] must hold both.” Patch 2 defers linked-timeout
splicing out of hrtimer context; patch 3 keeps `uring_lock` held across
`io_kill_timeouts()`.

Step 4.5 Record: WebFetch of lore was blocked by Anubis, but `b4`
successfully retrieved the thread. Web search did not find stable-
specific discussion for this exact patch. No direct stable nomination
was verified.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: Modified function: `io_wq_free_work()`.

Step 5.2 Record: Callers verified by `git grep`: `io_wq_free_work()` is
called from `io_uring/io-wq.c` after `io_wq_submit_work()` in the worker
loop and from the cancel path helper `io_run_cancel()`. This is io-wq
worker context.

Step 5.3 Record: Key callee is `io_req_find_next()`, verified to read
`req->link`, set `req->link = NULL`, and return the next linked request.
`io_wq_free_work()` then frees the current request via `io_free_req()`.

Step 5.4 Record: Reachability is verified from userspace:
`io_uring_enter()` locks `ctx->uring_lock` and calls `io_submit_sqes()`,
user SQE flags include `IOSQE_IO_LINK`, `IOSQE_IO_HARDLINK`, and
`IOSQE_ASYNC`, and async paths queue work into io-wq. This makes the
affected path reachable by user-submitted linked async io_uring
requests.

Step 5.5 Record: Similar patterns found: the normal completion/free
batching path calls `io_queue_next()`/`io_req_find_next()` while
`__io_submit_flush_completions()` and `io_free_batch_list()` require
`ctx->uring_lock`. Timeout code also mutates `req->link`, and the same
series addresses that.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Step 6.1 Record: Stable branch checks verified equivalent vulnerable
code in `stable/linux-5.10.y`, `stable/linux-5.15.y`,
`stable/linux-6.1.y`, `stable/linux-6.6.y`, `stable/linux-6.12.y`,
`stable/linux-6.19.y`, and `stable/linux-7.0.y`. The exact direct hunk
exists in newer trees; older trees use `io_put_req_find_next()`.

Step 6.2 Record: `git apply --check` of the candidate patch succeeded on
the current checked-out `stable/linux-7.0.y` tree. Backport difficulty:
clean or near-clean for newer trees with the direct function body;
manual but simple for older helper-based trees.

Step 6.3 Record: Exact-subject `git log` over listed stable branches
found no existing stable copy of this fix. Related stable history
contains earlier io_uring link/refcount fixes, but not this locking fix.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: Subsystem is `io_uring`, a core async I/O subsystem
reachable through the `io_uring_enter` syscall. Criticality:
important/core-adjacent because it is syscall-reachable and handles
request lifetime, completion, and linked request ordering.

Step 7.2 Record: The subsystem is active: recent mainline history around
the candidate contains multiple io_uring fixes and refactors, and the
candidate came through the io_uring maintainer tree.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: Affected users are systems using io_uring linked
requests that can complete through io-wq, especially linked async
operations. This is feature/config/user-workload specific, not
universal.

Step 8.2 Record: Trigger requires linked request chains and worker
completion/cancellation interleaving with other chain mutation/walk
paths. Unprivileged reachability depends on system policy, but the code
path is syscall-reachable through io_uring submission. No public
reproducer was verified.

Step 8.3 Record: Verified failure mode is an unsynchronized data race on
`req->link`. The precise observed symptom is unverified, but the raced
state controls request-chain lifetime/progression; plausible
consequences include lost/misordered linked request handling or memory-
safety/lifetime bugs. Severity: medium-high to high because it is a
syscall-reachable race in request lifetime code, though no crash report
was verified.

Step 8.4 Record: Benefit is high enough for stable because it removes a
real locking hole in io_uring linked-request handling. Risk is low:
6-line contained mutex protection, not on the unlinked hot path, no new
API, no behavior change except serialization.

## Phase 9: Final Synthesis
Step 9.1 Evidence for backporting:
- Verified real unsynchronized access: `io_wq_free_work()` called
  `io_req_find_next()` without `ctx->uring_lock`, while
  `io_req_find_next()` reads and clears `req->link`.
- Verified reachability from user-submitted io_uring linked async
  requests.
- Verified equivalent code exists across active stable trees from
  `5.10.y` through `7.0.y`.
- Verified fix is tiny, contained, maintainer-authored, and applies
  cleanly to `7.0.y`.
- Verified this is part of an explicit “Linked request fix” series
  closing locking gaps.

Evidence against or concerns:
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, stable Cc,
  stack trace, or reproducer was verified.
- It is patch 1/3 of a related series; for best stable correctness,
  patches `49ae66eb8c273` and `a65855ec34aed` should be
  evaluated/backported together.
- Older stable trees need manual adaptation to `io_put_req_find_next()`.

Step 9.2 Stable rules checklist:
1. Obviously correct and tested? Correct by inspection; external testing
   not verified.
2. Fixes a real bug? Yes, verified race on `req->link`.
3. Important issue? Yes enough for stable: syscall-reachable request-
   chain/lifetime race, though exact crash symptom is unverified.
4. Small and contained? Yes, one function, one file, 6 insertions.
5. No new features/APIs? Yes.
6. Can apply to stable? Yes for newer trees; older trees need
   straightforward backport.

Step 9.3 Exception category: None. This is not a device ID, quirk, DT,
build, or documentation-only patch.

Step 9.4 Decision: Backport. The technical merit is a small, maintainer-
authored synchronization fix for a verified io_uring linked-request race
in code present across stable trees. Treat the rest of the 3-patch
linked-request locking series as related follow-up material rather than
ignoring it.

## Verification
- [Phase 1] `git show --format=fuller --stat --patch 20c39819a2764`:
  confirmed subject, body, tags, one-file diff, and absence of
  `Fixes:`/`Reported-by:`/stable tags.
- [Phase 2] Diff inspection: confirmed
  `mutex_lock(&ctx->uring_lock)`/unlock added around
  `io_req_find_next()` only in `io_wq_free_work()`.
- [Phase 3] `git blame` on the parent: confirmed `io_wq_free_work()`
  direct call history and `req->link` read/clear history.
- [Phase 3] `git describe --contains`: confirmed relevant code history
  reaches released kernels including `v6.5-rc1`, `v5.15-rc1`, and
  earlier helper behavior.
- [Phase 3] Stable branch `git grep`: confirmed vulnerable worker/helper
  paths in `5.10.y`, `5.15.y`, `6.1.y`, `6.6.y`, `6.12.y`, `6.19.y`, and
  `7.0.y`.
- [Phase 4] `b4 dig -c`, `-a`, `-w`, and saved mbox: confirmed original
  submission URL, v1-only series, recipients, cover-letter context, and
  3-patch series.
- [Phase 4] WebFetch: lore direct fetch was blocked by Anubis; b4 mbox
  provided the thread content.
- [Phase 5] `git grep` call tracing: confirmed `io_wq_free_work()`
  callers in io-wq worker/cancel paths, `io_uring_enter()` to
  `io_submit_sqes()` submission path, and user-visible link flags.
- [Phase 6] `git apply --check`: confirmed the patch applies cleanly to
  the current `stable/linux-7.0.y` worktree.
- [Phase 7] `MAINTAINERS` search: confirmed Jens Axboe is the `IO_URING`
  maintainer.
- [Phase 8] Verified no public reproducer or exact crash symptom in the
  commit/thread; severity assessment is based on verified race location
  and syscall reachability, not on an observed report.

**YES**

 io_uring/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 97260bca67e7b..a72efb3a62bac 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1450,8 +1450,13 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	struct io_kiocb *nxt = NULL;
 
 	if (req_ref_put_and_test_atomic(req)) {
-		if (req->flags & IO_REQ_LINK_FLAGS)
+		if (req->flags & IO_REQ_LINK_FLAGS) {
+			struct io_ring_ctx *ctx = req->ctx;
+
+			mutex_lock(&ctx->uring_lock);
 			nxt = io_req_find_next(req);
+			mutex_unlock(&ctx->uring_lock);
+		}
 		io_free_req(req);
 	}
 	return nxt ? &nxt->work : NULL;
-- 
2.53.0


