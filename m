Return-Path: <io-uring+bounces-13271-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDSBNYdWAmourgEAu9opvQ
	(envelope-from <io-uring+bounces-13271-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 00:21:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC27516BB9
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 00:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1751308BD46
	for <lists+io-uring@lfdr.de>; Mon, 11 May 2026 22:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9394DD6C5;
	Mon, 11 May 2026 22:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rd4kAiiZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A174DBD75;
	Mon, 11 May 2026 22:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778537993; cv=none; b=pgKen+y1Vfr+QEX9jq4SZS80DvE97xFNrvJHlzb8tJAPb9j5qsHEmhtouyilY7/embvdsQb71k4pA9aqPUpUCky3SGGcDjzgKKn6ZAhGATxude/ezP2o0Xm+bqrrTMD65JG4Z9DmNw/ImAzmYS1MD3wKD8qNe8GlRhUwgRF8WAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778537993; c=relaxed/simple;
	bh=lrK/RVLsY/qCQGXYaWRUszCMLjdpNFQc/u6m65KLenw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZYWhnfKovB4jjYQRV7KoSkyU7OWxrYCWjKbslAZtlHExYgdOZx4/poTdTlo4hliA14g+ysGDkUwAi0HTEqYR0/X5hRFjXQlDkACbO6uYMtH55kNOkCLXxXpSpt80aoLEs5qoCrk7VNMKJnSl5m3fsYELOmBt6Uw9f9ncldZB+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rd4kAiiZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E674DC2BCF5;
	Mon, 11 May 2026 22:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778537990;
	bh=lrK/RVLsY/qCQGXYaWRUszCMLjdpNFQc/u6m65KLenw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rd4kAiiZwtA0KQPEYvFS73mHPq8FsPak9IrAF3LMjmzCAKaU5mkzXTn6S9UjK1pbZ
	 8pikV1OV4vuC37FqN61SgwDE0MSiAnaUYw38i9faJfUHMoHjpkTsM3EI4HmtJNWR9U
	 A7+NvGcsDX2bLQAdQnonGK0Z5UPXwmmHrBIGbT/pE9pj3/VAilmQUSEE8yTA8DQSpi
	 EmarofnZjWTrBvhnAB8t0QI/omUBruYNCjTne2aEqZcQhFyg+d4Mzv+y0n4IMnis8q
	 RpUxucRPQ1WLkBqGfJawL/D35DWF0+OIqQxHMWabk5B4Iar0pNc1a38rtNqKdq83Ea
	 EcmFWv4vbTlMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time namespace for IORING_ENTER_ABS_TIMER
Date: Mon, 11 May 2026 18:19:12 -0400
Message-ID: <20260511221931.2370053-13-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5AC27516BB9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,ntu.edu.sg,kernel.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13271-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email,msgid.link:url,ntu.edu.sg:email]
X-Rspamd-Action: no action

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]

io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
timespec from the caller via ext_arg->ts. It arms an ABS mode
hrtimer in __io_cqring_wait_schedule(). The conversion path in
io_uring/wait.c parses ext_arg->ts inline rather than going
through io_parse_user_time(). It therefore does not pick up the
time namespace conversion added by the previous patch.

Apply timens_ktime_to_host() to the parsed time on the
IORING_ENTER_ABS_TIMER branch. This mirrors the IORING_TIMEOUT_ABS
fix in io_parse_user_time(). Use ctx->clockid as the clock id.
ctx->clockid is set either at ring creation or via
IORING_REGISTER_CLOCK.

timens_ktime_to_host() is a no-op for clocks not affected by time
namespaces. It is also a no-op for callers in the initial time
namespace. The fast path is unchanged.

Reproducer: in unshare --user --time, with a -10s monotonic
offset, call io_uring_enter with min_complete=1,
IORING_ENTER_ABS_TIMER, and ts = now + 1s. The call returns
-ETIME after <1ms instead of after the expected ~1s.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
Link: https://patch.msgid.link/20260504153755.1293932-3-maoyi.xie@ntu.edu.sg
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

### Phase 1: Commit Message Forensics
Record: Subsystem `io_uring/wait`; action verb `honour`; intent is to
make `IORING_ENTER_ABS_TIMER` interpret caller absolute times in the
caller’s time namespace.

Record: Tags present:
`Suggested-by: Pavel Begunkov`, `Suggested-by: Jens Axboe`, author
`Signed-off-by: Maoyi Xie`, `Link:
https://patch.msgid.link/20260504153755.1293932-3-maoyi.xie@ntu.edu.sg`,
maintainer `Signed-off-by: Jens Axboe`. No `Fixes:`, `Reported-by:`,
`Tested-by:`, `Reviewed-by`, `Acked-by`, or `Cc: stable`.

Record: The commit describes a real userspace-visible bug:
`io_uring_enter()` with `IORING_ENTER_ABS_TIMER` parses `ext_arg->ts`
directly, then arms an absolute hrtimer without converting from the
caller’s time namespace to host time. The supplied reproducer in
`unshare --user --time` with a `-10s` monotonic offset returns `-ETIME`
in under 1 ms instead of about 1 second.

Record: This is not hidden cleanup. It is a direct correctness fix for
absolute timeout interpretation in time namespaces.

### Phase 2: Diff Analysis
Record: One file changed, `io_uring/wait.c`, 5 insertions and 1
deletion. Function modified: `io_cqring_wait()`. Scope: single-file
surgical fix.

Record: Before, `ext_arg->ts` was converted with
`timespec64_to_ktime()`. If `IORING_ENTER_ABS_TIMER` was unset, the code
added `start_time`; if set, it used the raw caller value as a host
absolute deadline. After, the absolute branch calls
`timens_ktime_to_host(ctx->clockid, iowq.timeout)`, while the relative
branch remains unchanged.

Record: Bug category is logic/correctness in time namespace handling.
The broken mechanism is that a namespaced absolute
`CLOCK_MONOTONIC`/`CLOCK_BOOTTIME` timestamp was fed to a host hrtimer
as if it were already in host time.

Record: Fix quality is strong: minimal, local, uses existing kernel
helper, and no new API. Regression risk is very low because
`timens_ktime_to_host()` is verified as a no-op for the initial time
namespace, for unsupported clocks, and when `CONFIG_TIME_NS` is
disabled.

### Phase 3: Git History Investigation
Record: `git blame` on the changed wait lines points to `0105b0562a5e`
(`io_uring: split out CQ waiting code into wait.c`) for the current file
location. The same logic predates the split; `2b8e976b9842` (`io_uring:
user registered clockid for wait timeouts`) shows this absolute-wait
path using `ctx->clockid` and is contained by `v6.12-rc1`.

Record: No `Fixes:` tag is present, so there was no tagged introducing
commit to follow. I inspected the companion parent commit instead:
`9cc6bac1bebf` fixes the same time-namespace issue for
`IORING_TIMEOUT_ABS`.

Record: Recent related history shows this is patch 2/2 after
`9cc6bac1bebf`. The candidate’s parent is exactly `9cc6bac1bebf`, but
this wait fix compiles independently as long as `timens_ktime_to_host()`
and `ctx->clockid` exist.

Record: Author history in `io_uring` before this commit only showed the
companion timeout fix. Jens Axboe applied the patch, and Pavel/Jens were
suggested-by/review participants.

Record: Dependencies: affected stable trees need `ctx->clockid` and
`timens_ktime_to_host()`. I verified both exist in local `for-
greg/6.12-100`; the same `IORING_ENTER_ABS_TIMER` buggy line exists in
`6.12`, `6.18`, `6.19`, and `7.0` local stable branches, but not in
`5.10`, `5.15`, `6.1`, or `6.6`.

### Phase 4: Mailing List And External Research
Record: `b4 dig -c 45d2b37a37ab...` found the original submission at `ht
tps://patch.msgid.link/20260504153755.1293932-3-maoyi.xie@ntu.edu.sg`.

Record: `b4 dig -a` found only v1 of the series. The thread shows Jens
applied both patches with commit IDs `9cc6bac1bebf` and `45d2b37a37ab`.

Record: `b4 dig -w` shows the right people/lists were included: Maoyi
Xie, Jens Axboe, Pavel Begunkov, `io-uring@vger.kernel.org`, and `linux-
kernel@vger.kernel.org`.

Record: Reviewer feedback was positive: Pavel wrote “both look good” and
requested a liburing test; Jens replied “+1” for the test and later
applied the series. No NAKs or objections found.

Record: No separate bug-report link exists beyond the patch
thread/reproducer. Stable-specific WebFetch was blocked by Anubis, and
local thread search found no stable nomination.

### Phase 5: Code Semantic Analysis
Record: Modified function: `io_cqring_wait()`.

Record: Callers: `io_uring_enter(2)` reaches `io_cqring_wait()` when
`IORING_ENTER_GETEVENTS` is set, after `io_get_ext_arg()` copies/parses
the userspace getevents argument. This is directly syscall-reachable.

Record: Key callees: `timespec64_to_ktime()`, `timens_ktime_to_host()`,
`ktime_add()`, `io_get_time()`, `io_cqring_schedule_timeout()`, and
hrtimer setup/start helpers.

Record: Call chain: userspace `io_uring_enter()` -> `io_get_ext_arg()`
-> `io_cqring_wait()` -> `io_cqring_wait_schedule()` ->
`__io_cqring_wait_schedule()` -> `io_cqring_schedule_timeout()` ->
absolute hrtimer. The buggy path is reachable from userspace with
`IORING_ENTER_GETEVENTS | IORING_ENTER_EXT_ARG |
IORING_ENTER_ABS_TIMER`.

Record: Similar patterns: the companion commit fixes
`io_parse_user_time()` for `IORING_TIMEOUT_ABS`; POSIX timers,
`clock_nanosleep`, alarm timers, and `timerfd` already use
`timens_ktime_to_host()` for absolute timers.

### Phase 6: Stable Tree Analysis
Record: Local stable-branch grep found the buggy
`IORING_ENTER_ABS_TIMER` code in `for-greg/6.12-100`, `for-
greg/6.18-100`, `for-greg/6.19-200`, and `for-greg/7.0-100`. It was
absent from `5.10`, `5.15`, `6.1`, and `6.6`.

Record: Backport difficulty: current `7.0.y` apply check succeeds
cleanly. `6.12`/`7.0` have `io_uring/wait.c`; `6.18`/`6.19` local
branches have the same logic in `io_uring/io_uring.c`, so those need a
path/context backport but not semantic rework.

Record: No related fix with this subject was found in the checked stable
candidate branches.

### Phase 7: Subsystem Context
Record: Subsystem is `io_uring`, a core async I/O syscall subsystem.
Criticality: IMPORTANT, not universal core MM/VFS, but directly
userspace-facing and widely used.

Record: Subsystem activity is high; recent `io_uring` history has many
fixes and feature changes. This specific change is small despite the
active subsystem.

### Phase 8: Impact And Risk
Record: Affected population: users of `io_uring_enter()` absolute CQ
wait timeouts inside non-initial time namespaces, especially container-
like environments. Branch-limited to stable trees that contain
`IORING_ENTER_ABS_TIMER`.

Record: Trigger: userspace can trigger via `io_uring_enter()` with
`IORING_ENTER_ABS_TIMER` and a timespec from a shifted time namespace.
The provided reproducer uses `unshare --user --time`; whether fully
unprivileged depends on system user-namespace policy.

Record: Failure mode: incorrect timeout behavior. With the reproduced
negative offset, the wait returns `-ETIME` immediately; with other
offsets, absolute waits can be delayed incorrectly. Severity: MEDIUM to
HIGH user-visible correctness bug, potential application timeout/hang
behavior, but not a kernel crash, memory corruption, or security fix.

Record: Benefit is moderate/high for affected containerized users
because it restores syscall semantics. Risk is very low: one local
conditional change plus an include, using established helper semantics.

### Phase 9: Final Synthesis
Record: Evidence for backporting: real reproduced bug, syscall-
reachable, affects stable branches with the feature, tiny patch,
maintainer-applied, positive reviewer feedback, matches established
time-namespace behavior elsewhere.

Record: Evidence against backporting: not a crash/security/data-
corruption fix; affects a narrower feature combination; no explicit
stable nomination; older stable trees do not contain the affected
feature.

Record: Unresolved: I did not run the reproducer locally. Lore WebFetch
was blocked by Anubis, but `b4` successfully fetched the thread. Exact
first upstream introduction of `IORING_ENTER_ABS_TIMER` was not cleanly
reconstructed from local blame alone, but affected stable branches were
directly verified by grep.

Stable rules:
1. Obviously correct and tested: yes by code inspection, reproducer, and
   positive review; no formal `Tested-by`.
2. Fixes a real bug: yes, reproduced wrong timeout result.
3. Important issue: yes for affected users, because absolute waits can
   return immediately or at the wrong time.
4. Small and contained: yes, 6-line single-function change.
5. No new features/APIs: yes.
6. Can apply to stable: yes for current `7.0.y`; minor path adjustment
   may be needed in some branches.

No automatic exception category applies.

## Verification
- [Phase 1] Parsed `git show` commit message and tags for
  `45d2b37a37ab98484693533496395c610a2cab96`.
- [Phase 2] Verified diff is one file, `io_uring/wait.c`, 5 insertions/1
  deletion in `io_cqring_wait()`.
- [Phase 3] Ran `git blame` on the changed lines; current file location
  comes from `0105b0562a5e`.
- [Phase 3] Inspected `2b8e976b9842`; verified `ctx->clockid`,
  `io_get_time(ctx)`, and selected-clock wait timeout support.
- [Phase 3] Inspected companion commit `9cc6bac1bebf`; verified same
  class of fix for `IORING_TIMEOUT_ABS`.
- [Phase 4] Ran `b4 dig`, `b4 dig -a`, `b4 dig -w`, and `b4 mbox`;
  verified v1-only series, correct recipients, positive feedback, and
  applied notice.
- [Phase 5] Read `io_uring_enter()` and `io_get_ext_arg()` call path;
  verified direct syscall reachability.
- [Phase 5] Verified `timens_ktime_to_host()` behavior in
  `include/linux/time_namespace.h` and `kernel/time/namespace.c`.
- [Phase 5] Verified similar established conversions in `kernel/time`
  and `fs/timerfd.c`.
- [Phase 6] Ran `git grep` on local stable branches; affected: `6.12`,
  `6.18`, `6.19`, `7.0`; unaffected: `5.10`, `5.15`, `6.1`, `6.6`.
- [Phase 6] Ran `git apply --check` for the candidate patch on current
  `7.0.y`; it applies cleanly.
- [Phase 8] Verified reproducer details from commit and mailing-list
  cover letter; did not execute it locally.

This should be backported to stable trees that contain
`IORING_ENTER_ABS_TIMER`, with the companion timeout patch strongly
recommended for complete io_uring absolute-timeout time-namespace
correctness.

**YES**

 io_uring/wait.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/wait.c b/io_uring/wait.c
index 91df86ce0d18c..ec01e78a216d6 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
 #include <linux/io_uring.h>
+#include <linux/time_namespace.h>
 
 #include <trace/events/io_uring.h>
 
@@ -229,7 +230,10 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 	if (ext_arg->ts_set) {
 		iowq.timeout = timespec64_to_ktime(ext_arg->ts);
-		if (!(flags & IORING_ENTER_ABS_TIMER))
+		if (flags & IORING_ENTER_ABS_TIMER)
+			iowq.timeout = timens_ktime_to_host(ctx->clockid,
+							    iowq.timeout);
+		else
 			iowq.timeout = ktime_add(iowq.timeout, start_time);
 	}
 
-- 
2.53.0


