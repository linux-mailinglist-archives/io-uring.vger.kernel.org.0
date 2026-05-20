Return-Path: <io-uring+bounces-13451-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIDjOvqdDWpO0AUAu9opvQ
	(envelope-from <io-uring+bounces-13451-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:41:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ECCE658CC92
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8AB7F307E131
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 11:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFF235200C;
	Wed, 20 May 2026 11:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4AXb3R9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5C23F9F50;
	Wed, 20 May 2026 11:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276064; cv=none; b=jnJqdUPj01DC1pHHjkRzrM7ZbA8iTgciyvBHQJvU1cUwmmuXchJsUT+D9V5vSkosanp31ZS8uX6v3kpyvvZLqijAK9PAb+KqR1bbok2CKT8uaUc/Oy7CfsnL9xCqW6TrBGmhxXt8MDnQd1gEjgXiwNqg5EpaoFl9LB8148dLjV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276064; c=relaxed/simple;
	bh=//Ly2Ai6Fh7VWI+ouLtx63/dbcphJNUEBX72m1hNbsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6UlrkQYA8E7RMdpvbQGUww0Uk5SxB12GoV844YG4/erNsTCyJwOedZc6FBEPkpbse2O8WNdOIXvgRd76Oc6vi+I/lnJntlR7NqD7ai7vQJIP0pszsIMslnsY4TkvTYsA5MKx5b+rwt+3NAf0Ylb/IQvRGtBXzg+o4H2CzalLog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4AXb3R9; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0010E1F00893;
	Wed, 20 May 2026 11:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276062;
	bh=RCJfnfuadbZVRROwAADW2uZfH3pa61+nYcGsboUdCkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4AXb3R9R/mU0Aw/YFRFyB/oxGTuLVsNByqO1dplBZ1M+m4gjtqUcobVQ62k99HQ9
	 Q4DwABPBwflPO9xYr2kTRdx/g5l+3aCB955aGlsPqcnq6mMUTE5BOMBwmXTlZelJNX
	 ixIpSlZRjJ0IDsO9OSATRcHbFc+93vBKu3qEUzJuPgkpqtaIzJiZoFPckzRf/muAmt
	 +GbLzVSqYUt9vi8ty8R9ifES3vQx58RMpOqpIqLdVHwzVolBbNfRDcFT5DVlbUzDEH
	 h1br/4uM+gjbKXqtqeetP5pAQ5GkWbtKtJdJVvAoabPJc3RYVPM2Chud8UagZe8Idn
	 or4MJZSrR97OA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] io_uring: hold uring_lock across io_kill_timeouts() in cancel path
Date: Wed, 20 May 2026 07:19:27 -0400
Message-ID: <20260520111944.3424570-55-sashal@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13451-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,msgid.link:url]
X-Rspamd-Queue-Id: ECCE658CC92
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a65855ec34aed84e1e5b4aea0323cc1745f83a5c ]

io_uring_try_cancel_requests() dropped ctx->uring_lock before calling
io_kill_timeouts(), which walks each timeout's link chain via
io_match_task() to test REQ_F_INFLIGHT. With chain mutation now
serialized by ctx->uring_lock, that walk needs the lock too.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record 1.1: Subsystem `io_uring`; action verb `hold`; intent is to keep
`ctx->uring_lock` held while `io_kill_timeouts()` walks timeout link
chains in the cancel path.

Record 1.2: Tags present: `Signed-off-by: Jens Axboe <axboe@kernel.dk>`.
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`,
`Link:`, or `Cc: stable@vger.kernel.org` tags were present in the commit
message I verified from upstream commit
`a65855ec34aed84e1e5b4aea0323cc1745f83a5c`.

Record 1.3: The commit body describes a locking bug:
`io_uring_try_cancel_requests()` dropped `ctx->uring_lock` before
`io_kill_timeouts()`, but `io_kill_timeouts()` calls `io_match_task()`
and walks linked requests to inspect `REQ_F_INFLIGHT`. The root cause
stated by the author is that after linked-chain mutation is serialized
by `ctx->uring_lock`, this read-side traversal also needs that lock. No
crash log, reproducer, affected kernel version, or user report is
included.

Record 1.4: This is a hidden synchronization bug fix, despite the
subject not saying “fix”. It changes lock coverage around an existing
linked-list traversal and matches a race-condition pattern.

## Phase 2: Diff Analysis
Record 2.1: One file changed: `io_uring/cancel.c`, 1 insertion and 1
deletion. One function changed: `io_uring_try_cancel_requests()`. Scope
is a single-file, single-hunk surgical locking fix.

Record 2.2: Before: `ctx->uring_lock` was unlocked after canceling
deferred files, poll, waitid, futex, and uring_cmd requests, then
`io_kill_timeouts()` ran unlocked. After: `io_kill_timeouts()` runs
before unlocking `ctx->uring_lock`. The affected path is cancellation
during io_uring task/ring teardown, including exit/exec/SQPOLL/ring-exit
paths verified in callers.

Record 2.3: Bug category is synchronization/race condition. The specific
mechanism is an unlocked traversal of a linked request chain in
`io_kill_timeouts()`/`io_match_task()` while related chain mutation is
intended to be serialized by `ctx->uring_lock`.

Record 2.4: Fix quality is high if applied with its series dependency:
it is minimal, changes no data structures or APIs, and only extends an
already-held mutex over one additional cancel helper. Regression risk is
low but not zero because it extends lock scope over code that takes
`completion_lock` and `timeout_lock`; this risk is mitigated by patch
2/3 moving linked-timeout chain splicing out of hrtimer context.

## Phase 3: Git History Investigation
Record 3.1: `git blame` on current `io_uring/cancel.c` shows the old
unlock-before-`io_kill_timeouts()` code came from `ffce324364318`
(`io_uring/cancel: move cancelation code from io_uring.c to cancel.c`),
first contained in `v6.19`. The timeout chain walk in `io_match_task()`
was introduced by `59915143e89f`, first contained in `v6.0`.

Record 3.2: No `Fixes:` tag is present, so there was no Fixes target to
follow.

Record 3.3: Recent history shows this commit follows `49ae66eb8c273`
(`io_uring: defer linked-timeout chain splice out of hrtimer context`)
and is part of the same linked-request locking series. Recent current-
branch churn in these files is low: current `HEAD` after `v7.0` has only
`93a9caab11350` touching these files.

Record 3.4: Jens Axboe is listed in `MAINTAINERS` as the `IO_URING`
maintainer and has extensive recent io_uring commits in local history.
This is maintainer-authored.

Record 3.5: Dependency found: upstream parent `49ae66eb8c273` is patch
2/3, and `20c39819a276` is patch 1/3. The candidate’s rationale
explicitly depends on patch 2/3’s serialization change. I verified the
full 3-patch series applies cleanly to the current tree.

## Phase 4: Mailing List And External Research
Record 4.1: `b4 dig -c a65855ec34ae...` found the original patch at
`https://patch.msgid.link/20260511182217.226763-4-axboe@kernel.dk`. Lore
mirror confirms it was `[PATCH 3/3]` in `[PATCHSET 0/3] Linked request
fix`. `b4 dig -a` found only v1; no newer revision was found.

Record 4.2: `b4 dig -w` showed recipients were Jens Axboe and `io-
uring@vger.kernel.org`. No separate reviewer/acked/tested tags were
found.

Record 4.3: No `Reported-by` or bug-report `Link` tag exists. I found no
syzbot, bugzilla, or user report for this exact commit.

Record 4.4: Related patches are patch 1/3 (`20c39819a276`, hold
`uring_lock` in `io_wq_free_work()`) and patch 2/3 (`49ae66eb8c273`,
defer linked-timeout splice out of hrtimer context). The series cover
letter says it closes gaps where iterating a chain must hold either
`uring_lock` or `timeout_lock`, and modifying an existing chain must
hold both.

Record 4.5: Stable-list search was limited by lore.kernel.org bot
protection, and web search did not find stable-specific discussion for
this exact commit. No stable-specific objection was found.

## Phase 5: Code Semantic Analysis
Record 5.1: Modified function: `io_uring_try_cancel_requests()`.

Record 5.2: Callers verified: `io_ring_exit_work()` calls
`io_uring_try_cancel_requests(ctx, NULL, true, false)` during ring exit;
`io_uring_cancel_generic()` calls it during task cancellation;
`sqpoll.c` calls `io_uring_cancel_generic(true, sqd)` for SQPOLL
shutdown; `fs/exec.c` reaches this via `io_uring_task_cancel()`;
`kernel/exit.c` reaches it via `io_uring_files_cancel()`.

Record 5.3: Key callees around the fix: `io_cancel_defer_files()`,
`io_poll_remove_all()`, `io_waitid_remove_all()`,
`io_futex_remove_all()`, `io_uring_try_cancel_uring_cmd()`, then
`io_kill_timeouts()`. `io_kill_timeouts()` takes `completion_lock` and
`timeout_lock`, iterates `ctx->timeout_list`, calls `io_match_task()`,
and flushes killed timeouts.

Record 5.4: Reachability is verified from userspace lifecycle
operations: io_uring rings/requests can reach cancellation via process
exit, exec, SQPOLL thread shutdown, or ring teardown. Whether
unprivileged users can create io_uring instances on a given deployment
depends on config/sysctl and was not separately verified.

Record 5.5: Similar patterns found: nearby cancel walkers such as
`io_cancel_remove_all()` and `io_poll_remove_all()` assert or run under
`ctx->uring_lock`; `io_match_task_safe()` exists to protect linked-
timeout walks, and patch 1/3 fixes another unlocked link-chain walk in
`io_wq_free_work()`.

## Phase 6: Stable Tree Analysis
Record 6.1: The exact pre-fix `io_uring/cancel.c` pattern exists in
local `v6.19`, `v7.0`, and current `HEAD`. `v6.18` does not have this
exact `io_kill_timeouts()` call in `io_uring/cancel.c`. The refactor
commit `ffce324364318` is an ancestor of `v6.19`, `v7.0`, and `HEAD`,
but not `v6.18`.

Record 6.2: Backport difficulty is low for `v6.19+` style trees: `git
apply --check` succeeded for the candidate alone and for the full
3-patch series on the current tree.

Record 6.3: No alternate stable fix for this exact locking gap was found
in local history or web search.

## Phase 7: Subsystem Context
Record 7.1: Subsystem is `io_uring`, a core async I/O subsystem
reachable through userspace syscalls when enabled. Criticality is
IMPORTANT to CORE depending on deployment, because it affects process
exit/exec and ring teardown correctness for io_uring users.

Record 7.2: Subsystem activity is high; recent local history shows many
io_uring changes by Jens Axboe and others. This patch was pulled into
Linus’ tree for `v7.1-rc4` as part of io_uring fixes.

## Phase 8: Impact And Risk
Record 8.1: Affected users are systems with `CONFIG_IO_URING` and
workloads using linked io_uring requests/timeouts, especially during
cancellation/teardown paths.

Record 8.2: Trigger conditions are linked request/timeouts plus
cancellation paths such as exit, exec, SQPOLL shutdown, or ring exit.
The exact race timing was not reproduced here.

Record 8.3: Failure mode is a locking/data-race hazard on linked
request-chain traversal. No crash report is verified, so I rate severity
as MEDIUM-HIGH rather than proven CRITICAL: cancellation races in
io_uring can lead to missed cancellation or unsafe traversal, but this
specific commit message does not document an observed oops/UAF.

Record 8.4: Benefit is high when backporting the linked-request locking
series, because it completes the lock invariant introduced by patch 2/3.
Risk is low: 1-line lock-scope adjustment, no new API, no feature, no
data structure change. Risk rises if cherry-picked without understanding
the series, so it should be queued with `20c39819a276` and
`49ae66eb8c273`.

## Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: real synchronization bug;
maintainer-authored; included in an upstream fixes pull; tiny and
contained; applies cleanly; affects userspace-reachable cancellation
paths; needed to complete a 3-patch linked-chain locking invariant.
Evidence against: no reported crash/reproducer; patch is part 3/3 and
should not be treated as an isolated standalone semantic fix; older
stable trees before the `cancel.c` refactor need separate backport
analysis.

Record 9.2: Stable rules checklist: obviously correct and tested by
upstream integration: yes, with dependency caveat. Fixes a real bug:
yes, a verified locking race/gap. Important issue: yes enough for
stable, because it is a race in io_uring linked request cancellation,
though no crash is documented. Small and contained: yes, 1 insertion/1
deletion in one function. No new features/APIs: yes. Can apply to
stable: yes for current `v6.19+` style trees; full series apply-check
passed on this tree.

Record 9.3: No automatic exception category applies; this is not a
device ID, quirk, DT, build, or documentation fix.

Record 9.4: Decision: backport, but queue it with the preceding linked-
request locking patches, especially `49ae66eb8c273`, because this
commit’s locking rationale depends on that series invariant.

## Verification
- [Phase 1] Verified upstream commit
  `a65855ec34aed84e1e5b4aea0323cc1745f83a5c` message and tags via GitHub
  API and Gitiles.
- [Phase 2] Verified diff is 1 insertion/1 deletion in
  `io_uring/cancel.c`, moving `mutex_unlock(&ctx->uring_lock)` after
  `io_kill_timeouts()`.
- [Phase 3] Ran `git blame` on `io_uring/cancel.c` and
  `io_uring/timeout.c`; identified `ffce324364318`, `59915143e89f`,
  `6971253f0787`, and `a9c83a0ab66a` as relevant historical commits.
- [Phase 3] Verified containing tags: `ffce324364318` present from
  `v6.19`; candidate and series commits first contained in `v7.1-rc4`.
- [Phase 4] Ran `b4 dig -c`, `-a`, and `-w`; found the lore message ID,
  v1-only series, and original recipients.
- [Phase 4] Fetched lore.gnuweeb mirror for patch 0/3, 1/3, 2/3, and
  3/3; confirmed series context and dependency.
- [Phase 5] Used code search and file reads to trace callers from
  `kernel/exit.c`, `fs/exec.c`, `sqpoll.c`, `io_ring_exit_work()`, and
  `io_uring_cancel_generic()`.
- [Phase 6] Checked `v6.18`, `v6.19`, `v7.0`, and `HEAD` for the exact
  code pattern; verified current tree and `v6.19+` have the old unlock-
  before-timeout call.
- [Phase 6] Ran `git apply --check` for the candidate and the full
  3-patch series; both apply cleanly to the current tree.
- [Phase 7] Verified `MAINTAINERS` lists Jens Axboe as `IO_URING`
  maintainer.
- [Phase 8] Verified the failure class from actual code paths and series
  discussion; no runtime reproducer or observed crash was found.
- UNVERIFIED: Whether older pre-`v6.19` stable trees have an equivalent
  bug in the pre-refactor `io_uring.c` layout.
- UNVERIFIED: Any stable-list discussion, because lore.kernel.org/stable
  fetch was blocked and web search found no exact stable discussion.

**YES**

 io_uring/cancel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 65e04063e343b..1d8928c829b61 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -554,8 +554,8 @@ __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	ret |= io_waitid_remove_all(ctx, tctx, cancel_all);
 	ret |= io_futex_remove_all(ctx, tctx, cancel_all);
 	ret |= io_uring_try_cancel_uring_cmd(ctx, tctx, cancel_all);
-	mutex_unlock(&ctx->uring_lock);
 	ret |= io_kill_timeouts(ctx, tctx, cancel_all);
+	mutex_unlock(&ctx->uring_lock);
 	if (tctx)
 		ret |= io_run_task_work() > 0;
 	else
-- 
2.53.0


