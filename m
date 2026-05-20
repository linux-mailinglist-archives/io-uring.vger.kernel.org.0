Return-Path: <io-uring+bounces-13450-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8E3uHpygDWqC0AUAu9opvQ
	(envelope-from <io-uring+bounces-13450-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:53:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D465658CFA1
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F0EA315B80D
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 11:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919B93F86FB;
	Wed, 20 May 2026 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TIBI9Z9z"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5893F660B;
	Wed, 20 May 2026 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276058; cv=none; b=b2pViDpv03WYlKGvPtgGHd1CcvDa4IrN9PRAiWkpMuE/pVQY252gJ0QgNr+WUj9qnfev9q4yycfKNbdwWKQCSLQcgfMMvh5QRITfeCq3U7TwO8+u1xjLmeOHmOIAdlZ6X4ThN2/2FvUj0i+l/rqEHDB4ZzP5rq41qObgcBt5ih0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276058; c=relaxed/simple;
	bh=O3GUQrcgrREjME4OlpBgGAHjugGqpCFiIiai4MQP2Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tAzvLy6hUomfCVwrWCCfmz3vFT1BFOgEmBG3SzGB890rRpo3ElYgVUwNW+ZVtptQVt2OshGOU80JWOsnd+e/7sGzvict8FSp6+eeWySnPcnl3As/ONk5VEtTilldFAqQwweuvRf0XyW0i1toh6K0/3oVRUVhqjDCsKvJQAWLnnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TIBI9Z9z; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D03B1F00896;
	Wed, 20 May 2026 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276056;
	bh=SVJ6+52vVYr+ZxyKK0zem41gMQhL29rg6s4I6fvQIAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIBI9Z9zaF+qOaFizNPFPTpRekO4q3SPB8dyXN+R04XvlnLZnTyLgr+nqP+XHnw8V
	 M9hCbG//BslyOM+HV71fKA7fSezZ52ZBlxfXF/nkWOg6M060UZ500wHpmdnI0OijLE
	 dDd4Dg0MzzCi0M58aIb9r/vyQvFRZbYJmCkQ6nKzU844ifDsgKnrA7OfNCRgbZO4VC
	 OdD203jHifB9sAw8U77eWn/JpEJ6mmmEyoq3ZLWWGc8XOPUVtI5FBQmxZTXqVAaSiQ
	 dOy/94Q9NEKm60CRItA4VTOVzZ3Srw3KrB+l4gOa7N6h3cGhdkq5616UTBxeMLgU2L
	 cagBr6DoyG5lw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zizhi Wo <wozizhi@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] io_uring: validate user-controlled cq.head in io_cqe_cache_refill()
Date: Wed, 20 May 2026 07:19:22 -0400
Message-ID: <20260520111944.3424570-50-sashal@kernel.org>
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
X-Spamd-Result: default: False [4.34 / 15.00];
	SEM_URIBL(3.50)[huaweicloud.com:email];
	MID_CONTAINS_FROM(1.00)[];
	MAILLIST(-0.15)[generic];
	BAD_REP_POLICIES(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13450-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	MIME_TRACE(0.00)[0:+];
	R_DKIM_ALLOW(0.00)[kernel.org:s=k20260515];
	FORGED_SENDER_MAILLIST(0.00)[];
	GREYLIST(0.00)[pass,body];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_SPAM(0.00)[0.942];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_SPF_ALLOW(0.00)[+ip4:172.234.253.10:c];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,msgid.link:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,huawei.com:email,huaweicloud.com:email,fedora:email]
X-Rspamd-Queue-Id: D465658CFA1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit f44d38a31f1802b7222adaea9ee69f9d280f698a ]

A fuzzing run reproduced an unkillable io_uring task stuck at ~100% CPU:

[root@fedora io_uring_stress]# ps -ef | grep io_uring
root  1240  1  99 13:36 ?  00:01:35 [io_uring_stress] <defunct>

The task loops inside io_cqring_wait() and never returns to userspace,
and SIGKILL has no effect.

This is caused by the CQ ring exposing rings->cq.head to userspace as
writable, while the authoritative tail lives in kernel-private
ctx->cached_cq_tail. io_cqe_cache_refill() computes free space as an
unsigned subtraction:

    free = ctx->cq_entries - min(tail - head, ctx->cq_entries);

If userspace keeps head within [0, tail], the subtraction is well
defined and min() just acts as a defensive clamp. But if userspace
advances head past tail, (tail - head) wraps to a huge value, free
becomes 0, and io_cqe_cache_refill() fails. The CQE is pushed onto the
overflow list and IO_CHECK_CQ_OVERFLOW_BIT is set.

The wait loop in io_cqring_wait() relies on an invariant: refill() only
fails when the CQ is *physically* full, in which case rings->cq.tail has
been advanced to iowq->cq_tail and io_should_wake() returns true. The
tampered head breaks this: refill() fails while the ring is not full, no
OCQE is copied in, rings->cq.tail never catches up, io_should_wake()
stays false, and io_cqring_wait_schedule() keeps returning early because
IO_CHECK_CQ_OVERFLOW_BIT is still set. The result is a tight retry loop
that never returns to userspace.

Introduce io_cqring_queued() as the single point that converts the
(tail, head) pair into a trustworthy queued count. Since the real
head/tail distance is bounded by cq_entries (far below 2^31), a signed
comparison reliably detects userspace moving head past tail; in that
case treat the queue as empty so callers see the full cache as free and
forward progress is preserved.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://patch.msgid.link/20260514021847.4062782-1-wozizhi@huaweicloud.com
[axboe: fixup commit message, kill 'queued' var, and keep it all in
io_uring.c]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record: Subsystem `io_uring`; action verb `validate`; intent is to
validate a user-controlled CQ head value used by
`io_cqe_cache_refill()`.

Record: Tags found: `Suggested-by: Jens Axboe`, `Signed-off-by: Zizhi
Wo`, `Link: https://patch.msgid.link/20260514021847.4062782-1-
wozizhi@huaweicloud.com`, maintainer edit note from Jens, `Signed-off-
by: Jens Axboe`. No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-
by`, or `Cc: stable` tags were present.

Record: The commit describes a fuzzed, reproducible user-visible
failure: an `io_uring` task spins at about 100% CPU inside
`io_cqring_wait()`, never returns to userspace, and ignores `SIGKILL`.
Root cause is that userspace can write `rings->cq.head`; if it advances
`head` past the kernel-private `ctx->cached_cq_tail`, unsigned
subtraction wraps, `io_cqe_cache_refill()` sees no free space, overflow
stays set, and the wait loop keeps retrying.

Record: This is not hidden cleanup. It is an explicit bug fix for a
userspace-triggerable livelock/unkillable task.

## Phase 2: Diff Analysis
Record: One file changed: `io_uring/io_uring.c`, 17 insertions and 5
deletions. Modified/added functions: new `io_cqring_queued()`, modified
`io_fill_nop_cqe()`, modified `io_cqe_cache_refill()`. Scope is a
single-file surgical fix.

Record: Before, free CQ space was computed as `ctx->cq_entries -
min(__io_cqring_events(ctx), ctx->cq_entries)`, where
`__io_cqring_events()` is `cached_cq_tail - user_head`. If `user_head >
cached_cq_tail`, that unsigned subtraction wraps and is clamped to
`cq_entries`, making `free` zero.

Record: After, `io_cqring_queued()` casts the tail-head difference to
signed `int`; non-negative values are clamped to `cq_entries`, while
negative values are treated as zero queued entries. `io_fill_nop_cqe()`
uses the same trusted queued-count helper.

Record: Bug category is logic/correctness with user-controlled index
validation failure, causing an overflow-path livelock. It is not a
feature, API, refactor, or hardware enablement.

Record: Fix quality is good: for valid rings it preserves existing
behavior; for invalid `head > tail` it chooses forward progress.
Regression risk is low because the helper is local and affects only CQ
free-space calculation. The only semantic change is for corrupted user
CQ head state.

## Phase 3: Git History Investigation
Record: `git blame` shows the affected free-space calculation in
`io_cqe_cache_refill()` comes from `faf88dde060f74` (`io_uring: don't
inline __io_get_cqe()`), first contained in `v6.0-rc1~181^2~85`. The
overflow ordering guard comes from `aa1df3a360a0c5` (`io_uring: fix CQE
reordering`), first contained in `v6.1-rc1~135^2~10`. The later
`cqe32`/NOP path comes from `e26dca67fde19`, first contained in
`v6.18-rc1~137^2~45`.

Record: No `Fixes:` tag is present, so there was no tagged introducing
commit to follow.

Record: Recent file history shows multiple `io_uring` fixes around
CQ/ring handling, including `61a11cf481272` protecting lockless
`ctx->rings` accesses and `a7d755ed9ce97` fixing overflow CQE
reordering. No prerequisite specific to this helper was identified.

Record: Author Zizhi Wo has other kernel commits, but no recent local
`io_uring` commits found. Jens Axboe is the `IO_URING` maintainer in
`MAINTAINERS` and applied the final patch with edits.

Record: Dependencies: the fix depends only on existing
`ctx->cached_cq_tail`, `ctx->cq_entries`, `READ_ONCE(rings->cq.head)`,
and `min()`. It can be backported standalone, though older stable trees
need context adjustment because the exact function signature and file
layout differ.

## Phase 4: Mailing List And External Research
Record: `b4 dig -c f44d38a31f1802b7222adaea9ee69f9d280f698a` found the
original v2 submission at `https://patch.msgid.link/20260514021847.40627
82-1-wozizhi@huaweicloud.com`.

Record: `b4 dig -a` found v1 and v2. v1 was
`20260513063254.1122354-1-wozizhi@huaweicloud.com`; v2 was the submitted
version that matches the final fix concept. Jens reviewed v1 and said
snapshotting `tail` before a possible NOP fill looked wrong, and noted
the refill path had the same unsigned issue. v2 addressed this by
introducing a helper used by both paths.

Record: `b4 dig -w` showed the right recipients: Jens Axboe, Pavel
Begunkov, `io-uring@vger.kernel.org`, `linux-kernel@vger.kernel.org`,
and related Huawei contacts.

Record: The v2 mbox shows Jens applied it and then further edited it by
moving the helper into `io_uring.c`, removing the now-unused `queued`
variable, and trimming the comments/message. No NAK was found. No stable
nomination was found in the fetched thread.

Record: WebFetch access to lore search pages and git.kernel.org was
blocked by Anubis, so stable-list web search could not be verified
through WebFetch. Local `git log --grep` on sampled stable branches
found no existing exact stable commit.

## Phase 5: Code Semantic Analysis
Record: Key functions: `io_cqring_queued()`, `io_fill_nop_cqe()`,
`io_cqe_cache_refill()`.

Record: Callers: `io_cqe_cache_refill()` is called by
`io_get_cqe_overflow()` in `io_uring/io_uring.h`, which feeds normal CQE
posting, auxiliary CQEs, request completions, multishot completions,
message-ring completions, and overflow flushing. `io_cqring_wait()` is
reached from `SYSCALL_DEFINE6(io_uring_enter)` when
`IORING_ENTER_GETEVENTS` is used.

Record: Callees/side effects: the affected code reads the user-writable
CQ head, computes queue occupancy/free space, sets
`ctx->cqe_cached`/`ctx->cqe_sentinel`, and decides whether completions
go directly to the CQ ring or the overflow list.

Record: Reachability is verified from userspace through
`io_uring_enter()`. The provided reproduction ran as root; unprivileged
triggerability was not independently verified, but the affected state is
controlled by the userspace owner of the mmaped CQ ring.

Record: Similar pattern found: `__io_cqring_events()` in current code
and stable branches computes `cached_cq_tail - READ_ONCE(cq.head)`, so
the unsigned wrap condition is real in the relevant code paths.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Record: The buggy free-space logic exists in sampled stable trees:
`stable/linux-6.1.y` has it in `__io_get_cqe()`, and
`stable/linux-6.6.y`, `stable/linux-6.12.y`, `stable/linux-6.18.y`, and
`stable/linux-6.19.y` have it in `io_cqe_cache_refill()` or equivalent.
The specific min/free logic was introduced for v6.0-rc1, so v6.1+ stable
trees are affected.

Record: `stable/linux-5.15.y` has an older `io_get_cqe()` form using
`__io_cqring_events(ctx) == ctx->cq_entries`, not the same `min(tail -
head, cq_entries)` free-space calculation. I did not verify that the
exact livelock fixed here applies to 5.15, so this decision is driven by
verified v6.1+ evidence.

Record: Expected backport difficulty: low to moderate. 6.18/6.19 are
close but may lack the exact split into `wait.c`/`wait.h` seen in
current 7.0; 6.6/6.12 need a smaller adaptation because there is no
`cqe32`/NOP path; 6.1 needs the helper folded into the older
`__io_get_cqe()` path. The semantic fix is standalone.

Record: No related fix already present was found by exact subject search
in sampled stable branches.

## Phase 7: Subsystem And Maintainer Context
Record: Subsystem is `io_uring`, a core async I/O userspace API.
Criticality is IMPORTANT/CORE-adjacent because it is syscall reachable
and used by databases, storage/network software, runtimes, and fuzzers.

Record: Subsystem activity is high: recent local history shows many
`io_uring` fixes and refactors. The patch was handled by Jens Axboe,
listed maintainer for `IO_URING`.

## Phase 8: Impact And Risk Assessment
Record: Affected users are systems using `io_uring`; trigger requires a
userspace process manipulating its CQ head and waiting for completions.
The reproduction is a fuzzing/stress case with direct userspace control
of the mapped CQ ring.

Record: Trigger likelihood is not “everyday normal app behavior”, but it
is syscall/userspace reachable and can create an unkillable high-CPU
task. Unprivileged triggerability was not independently verified beyond
normal `io_uring` userspace reachability.

Record: Failure mode is HIGH severity: livelock/tight retry loop, 100%
CPU, no return to userspace, and `SIGKILL` ineffective per the commit
and mailing-list patch.

Record: Benefit is high for affected stable trees because it prevents a
userspace-triggered unkillable task. Risk is low because the change is
small, local, and only changes behavior for invalid user-controlled CQ
head state. Risk/benefit strongly favors backporting.

## Phase 9: Final Synthesis
Record: Evidence for backporting: real fuzzed bug; clear root cause;
userspace-reachable path; severe livelock/unkillable task; small local
fix; maintainer-reviewed evolution from v1 to v2; final maintainer-
applied version; verified affected code in v6.1+ stable branches.

Record: Evidence against backporting: no explicit `Cc: stable`, no
`Fixes:` tag, no `Tested-by`, and exact patch may need small branch-
specific backport adjustments. These are not enough to outweigh the
verified bug severity and small fix.

Record: Unresolved questions: exact applicability to 5.15 was not
established; exact clean-apply status on each stable branch was not
tested; unprivileged triggerability beyond ordinary userspace `io_uring`
access was not independently proven.

Stable rules checklist:
1. Obviously correct and tested: mostly yes by inspection and maintainer
   review; no explicit `Tested-by` and no local runtime test.
2. Fixes a real bug: yes, fuzzed livelock/unkillable task.
3. Important issue: yes, high-severity CPU spin and unkillable wait.
4. Small and contained: yes, one file, 17 insertions and 5 deletions.
5. No new feature/API: yes, static helper only.
6. Can apply to stable: yes with likely minor backport adjustments for
   older branches.

Exception category: none; this is a direct bug fix, not a device ID,
quirk, DT, build, or documentation exception.

Decision: backport to affected stable trees, especially v6.1+ where the
buggy free-space calculation was verified. Avoid claiming 5.15 without a
separate targeted analysis/backport.

## Verification
- [Phase 1] Parsed commit object
  `f44d38a31f1802b7222adaea9ee69f9d280f698a` with `git show`; confirmed
  subject, tags, and 17/5 diffstat.
- [Phase 2] Inspected the candidate diff with `git show`; confirmed new
  `io_cqring_queued()` and replacements in `io_fill_nop_cqe()` and
  `io_cqe_cache_refill()`.
- [Phase 3] Ran `git blame` on affected lines; confirmed key code came
  from `faf88dde060f74`, `aa1df3a360a0c5`, and `e26dca67fde19`.
- [Phase 3] Ran `git describe --contains`; confirmed first containment
  around v6.0-rc1, v6.1-rc1, and v6.18-rc1 respectively.
- [Phase 4] Ran `b4 dig -c`, `b4 dig -a`, and `b4 dig -w`; confirmed
  v1/v2 patch history, recipients, and maintainer involvement.
- [Phase 4] Fetched v1/v2 mboxes with `b4 mbox`; confirmed Jens’ v1
  concern and v2 application with edits.
- [Phase 5] Used `rg` and file reads to trace `io_cqe_cache_refill()`
  through CQE posting and `io_uring_enter()`/`IORING_ENTER_GETEVENTS`.
- [Phase 6] Checked stable branches with `git blame`; verified affected
  logic in sampled v6.1, v6.6, v6.12, v6.18, and v6.19 branches.
- [Phase 7] Checked `MAINTAINERS`; verified Jens Axboe is listed
  maintainer for `IO_URING`.
- [Phase 8] Verified failure mode from commit message and mailing-list
  patch body; did not independently run the fuzzer or reproducer.
- UNVERIFIED: exact clean apply on every stable tree, exact
  applicability to 5.15, and unprivileged triggerability.

**YES**

 io_uring/io_uring.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a72efb3a62bac..431d157e81595 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -680,13 +680,27 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
 	return ocqe;
 }
 
+/*
+ * Compute queued CQEs for free-space calculation, clamped to cq_entries.
+ */
+static unsigned int io_cqring_queued(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = io_get_rings(ctx);
+	int diff;
+
+	diff = (int)(ctx->cached_cq_tail - READ_ONCE(rings->cq.head));
+	if (diff >= 0)
+		return min((unsigned int)diff, ctx->cq_entries);
+	return 0;
+}
+
 /*
  * Fill an empty dummy CQE, in case alignment is off for posting a 32b CQE
  * because the ring is a single 16b entry away from wrapping.
  */
 static bool io_fill_nop_cqe(struct io_ring_ctx *ctx, unsigned int off)
 {
-	if (__io_cqring_events(ctx) < ctx->cq_entries) {
+	if (io_cqring_queued(ctx) < ctx->cq_entries) {
 		struct io_uring_cqe *cqe = &ctx->rings->cqes[off];
 
 		cqe->user_data = 0;
@@ -707,7 +721,7 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
-	unsigned int free, queued, len;
+	unsigned int free, len;
 
 	/*
 	 * Posting into the CQ when there are pending overflowed CQEs may break
@@ -727,9 +741,7 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32)
 		off = 0;
 	}
 
-	/* userspace may cheat modifying the tail, be safe and do min */
-	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
-	free = ctx->cq_entries - queued;
+	free = ctx->cq_entries - io_cqring_queued(ctx);
 	/* we need a contiguous range, limit based on the current array offset */
 	len = min(free, ctx->cq_entries - off);
 	if (len < (cqe32 + 1))
-- 
2.53.0


