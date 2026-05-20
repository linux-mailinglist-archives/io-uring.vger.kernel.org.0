Return-Path: <io-uring+bounces-13449-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPvqND+dDWoS0AUAu9opvQ
	(envelope-from <io-uring+bounces-13449-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:38:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BBC858CBAC
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 516383175959
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 11:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECF53F6C53;
	Wed, 20 May 2026 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQlcUA4Q"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1B73F44CD;
	Wed, 20 May 2026 11:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276056; cv=none; b=Z3qQxnETNzBF45rvuWfvIBHhSmHRb+xsZg7XZ215TrIZVVCar3pbL8xeN2xFMqMlEDpBGxlw/BK55eDKBON32hp4CXvawU0D8b1hZmLIOMG6ETEmGjbRA2qK5FmCVUx4J6qcWQ7TEJHpVKSmobSpcLLg5NFdur3Xem6V5eQVDQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276056; c=relaxed/simple;
	bh=MNq/8U2j5eLB1h2VBZPHF+KZltfN65vY8n+9Z4aKw3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ME/OEnDdxDt8WC7GDPyy7Osqbkax2Ou325NHK//aOsaqFCH29gneSLdgb+J35Pr8qB4+HLP5CajksRO+e///uu/QonKUm7tjHyTpUAkLhMsrbP8uJqqjUPBvbhwDFRmE7FYu/QJkPjGGkZXeWRv4nsFJAY40IwI1Rzf5PgRdmgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQlcUA4Q; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4AF1F00893;
	Wed, 20 May 2026 11:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276054;
	bh=paqoOUCaaHOHHctHufFKjrS7rt6VgzjmcsNCFGativk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQlcUA4QdlocwEG1cIOSWNsJPdzXbAoK1ZGfNm+HlM2s88Pn7XZGjHnNvf+4OXvwm
	 8UB5Iz9WWMaVsF6NKmkLnhFzRNSTeGExilNRppiGQrWUseOhh6iUVntwQtdqZHbXLX
	 rQEJGLYT2/hxESD6VpmTYUaNzfGcrsWA4xCHQSYLkVR3cS57Cd6UTprBqSdH9PVvpz
	 3x5AFS+kbmpLIbuIxYzUtUFUfldO4MI3No6eiKEalluD+WyGFsJTW+6BKZIdTWOiiO
	 0CZ/JJaysgnTiUbo/uhDODsYP+w/P+xu0oMRv98iqHE4LXXIYKr7FfOcFDX1HublVr
	 AIDyCXE9cGvUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] io_uring: defer linked-timeout chain splice out of hrtimer context
Date: Wed, 20 May 2026 07:19:21 -0400
Message-ID: <20260520111944.3424570-49-sashal@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13449-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,msgid.link:url,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 7BBC858CBAC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 49ae66eb8c27375075ffa308cfd4bf25af335d41 ]

io_link_timeout_fn() is the hrtimer callback that fires when a linked
timeout expires. It currently calls io_remove_next_linked(prev) under
ctx->timeout_lock to splice the timeout request out of the link chain.
This is the only chain-mutation site that runs without ctx->uring_lock,
because hrtimer callbacks cannot take a mutex. Defer the splicing until
the task_work callback.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record: subsystem `io_uring`; action verb `defer`; intent is to move
linked-timeout chain splicing out of `io_link_timeout_fn()` hrtimer
context and into task_work.

Record: tags found only `Signed-off-by: Jens Axboe <axboe@kernel.dk>`.
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc: stable`,
or external `Link:` in the upstream commit.

Record: the body describes a locking bug: `io_link_timeout_fn()` mutates
the linked request chain under `ctx->timeout_lock` but without
`ctx->uring_lock`; hrtimer callbacks cannot take the mutex, so mutation
is deferred to task_work.

Record: this is a real hidden bug fix despite not saying “fix”: it
corrects an unsynchronized linked-list mutation in an hrtimer callback.

## Phase 2: Diff Analysis
Record: one file changed, `io_uring/timeout.c`, 14 insertions and 2
deletions. Modified functions: `__io_disarm_linked_timeout()`,
`io_req_task_link_timeout()`, `io_link_timeout_fn()`. Scope is single-
file surgical locking/race fix.

Record: before, `io_link_timeout_fn()` called
`io_remove_next_linked(prev)` directly from hrtimer context under only
`timeout_lock`. After, the timer claims the timeout, stores
`timeout->prev`, and queues task_work; `io_req_task_link_timeout()` then
splices `req` out of `prev->link` if the normal completion path did not
already do so.

Record: `__io_disarm_linked_timeout()` now detects `timeout->head ==
NULL`, meaning the timer already claimed the timeout, and avoids
cancel/list removal in that race.

Record: bug category is synchronization/race on linked request chain
mutation. Fix quality is good but series-sensitive: patch 3/3
(`a65855ec34aed`) is needed to keep `io_kill_timeouts()` walking chains
under `uring_lock` after this patch changes where splicing happens.

## Phase 3: Git History Investigation
Record: blame shows the relevant linked-timeout code and
`io_remove_next_linked()` originated mainly from `59915143e89f`
(“io_uring: move timeout opcodes and handling into its own file”), first
contained around `v6.0-rc1`; later timeout-lock changes include
`020b40f35624`, and `__io_disarm_linked_timeout()` changes include
`78967aabf613`, first around `v6.16-rc1`.

Record: no `Fixes:` tag exists, so there was no tagged introducer to
follow.

Record: recent history shows this is patch 2/3 in a linked-request
locking series:
`20c39819a276` locks `io_wq_free_work()` chain walking,
`49ae66eb8c27` defers linked-timeout splicing,
`a65855ec34ae` keeps `uring_lock` across `io_kill_timeouts()`.

Record: Jens Axboe is listed in `MAINTAINERS` as the `IO_URING`
maintainer and authored the commit.

## Phase 4: Mailing List And External Research
Record: `b4 dig -c 49ae66eb8c27` found the lore submission at
`https://patch.msgid.link/20260511182217.226763-3-axboe@kernel.dk`.

Record: `b4 dig -a` found only v1 of the 3-patch series. `b4 dig -w`
showed recipients were Jens Axboe and `io-uring@vger.kernel.org`.

Record: the saved mbox contains the cover letter “[PATCHSET 0/3] Linked
request fix”, stating chain iteration must hold either `uring_lock` or
`timeout_lock`, and modification should be buttoned up. No replies,
NAKs, review tags, or stable nominations were present in the mbox.

Record: direct `WebFetch` of lore and stable search pages was blocked by
Anubis, so no web-side stable discussion could be verified.

## Phase 5: Code Semantic Analysis
Record: key functions are `io_link_timeout_fn()`,
`io_req_task_link_timeout()`, `__io_disarm_linked_timeout()`, and
`io_remove_next_linked()`.

Record: call/reachability tracing verified `IORING_OP_LINK_TIMEOUT` uses
`io_link_timeout_prep()` in `io_uring/opdef.c`; prep installs
`io_link_timeout_fn()` as the hrtimer callback, and linked timeouts are
queued on `ctx->ltimeout_list`.

Record: task_work runners in `io_uring/tw.c` execute callbacks while
holding `ctx->uring_lock` in normal, fallback, and local-work paths.
This verifies the deferred splice runs in a mutex-protected context.

Record: similar pattern search found the hrtimer callback was the unique
changed direct chain mutation site in this diff; the related series
covers other chain walking gaps.

## Phase 6: Stable Tree Analysis
Record: `git merge-base --is-ancestor` verified the old timeout split
commit exists in `v6.19.14` and `v6.6.140`; the candidate itself is not
in `v7.0.9` or `v6.19.14`.

Record: `git show`/`rg` verified the buggy `io_link_timeout_fn()`
pattern exists in `v7.0.9`, `v6.19.14`, `v6.15`, `v6.12.90`, `v6.6.140`,
and in older `v5.15` under `fs/io_uring.c`.

Record: `git diff 49ae^..49ae | git apply --check` succeeded on the
current `v7.0.9` checkout. Older trees have API/path differences such as
task_work signature and `spin_lock` vs `raw_spin_lock`, so they need
manual backporting.

## Phase 7: Subsystem Context
Record: subsystem is `io_uring`, a core async I/O userspace API.
Criticality is IMPORTANT: not universal like MM/VFS, but reachable from
userspace and widely used.

Record: `git log origin/master --oneline -20 -- io_uring` shows high
activity, including this linked-request locking series and other recent
fixes.

## Phase 8: Impact And Risk
Record: affected users are systems using io_uring linked requests with
`IORING_OP_LINK_TIMEOUT`.

Record: trigger is a timing race between linked-timeout hrtimer expiry
and other linked-chain completion/cancel paths; this is reachable from
userspace via io_uring submissions.

Record: verified failure class is unsynchronized linked-list/request-
chain mutation. No crash report was verified, but the protected object
is request-chain state, so the stability risk is request chain
corruption, wrong cancellation/completion, or follow-on memory lifetime
bugs.

Record: benefit is high for affected io_uring users because it closes a
real locking gap in request lifetime/chain handling. Risk is low-medium:
the patch is small, but should be backported with the adjacent locking
fixes, especially `a65855ec34aed`.

## Phase 9: Final Synthesis
Record: evidence for backporting: real race fix, userspace-reachable
io_uring path, single-file 16-line patch, authored by subsystem
maintainer, applies cleanly to `v7.0.9`, and the buggy pattern exists
across active stable/LTS tags checked.

Record: evidence against/concerns: no reporter/test tag, no explicit
stable tag, no verified crash trace, and the commit is part of a 3-patch
locking series; backporting only this patch without the follow-up
cancel-path lock change can leave the locking story incomplete.

Record: stable rules: obviously correct by code inspection with the
series context; fixes a real synchronization bug; important because it
affects request-chain mutation in a userspace API; small and contained;
no new feature/API; applies cleanly to `v7.0.9`, with older trees
needing backport adjustment.

Record: no automatic exception category applies; this is not a device
ID, quirk, DT, build, or documentation fix.

## Verification
- [Phase 1] `git show -s` confirmed subject, body, author, and absence
  of tags beyond Jens’s SOB.
- [Phase 2] `git show --patch 49ae66eb8c27` confirmed
  `io_uring/timeout.c` only, 14 insertions/2 deletions.
- [Phase 3] `git blame` confirmed relevant code history; `git describe
  --contains` placed `59915143e89f` around `v6.0-rc1` and `78967aabf613`
  around `v6.16-rc1`.
- [Phase 3] `git log` confirmed related commits `20c39819a276` and
  `a65855ec34ae`.
- [Phase 4] `b4 dig` found the exact patch submission and v1 3-patch
  series; saved mbox showed no review replies or stable nomination.
- [Phase 5] `rg` and `git show` traced `IORING_OP_LINK_TIMEOUT` prep,
  hrtimer setup, task_work execution, and task_work locking.
- [Phase 6] stable tag checks verified the buggy pattern exists in
  checked stable/LTS tags; `git apply --check` succeeded on current
  `v7.0.9`.
- [Phase 7] `MAINTAINERS` verified Jens Axboe maintains `IO_URING`.
- [Phase 8] failure mode is verified as a locking/race bug; concrete
  crash symptoms are UNVERIFIED.

The commit should be backported, preferably together with the adjacent
linked-request locking series commits needed for a complete invariant.

**YES**

 io_uring/timeout.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index e3815e3465dde..4ee1c21e1b15f 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -245,6 +245,10 @@ static struct io_kiocb *__io_disarm_linked_timeout(struct io_kiocb *req,
 	struct io_timeout *timeout = io_kiocb_to_cmd(link, struct io_timeout);
 
 	io_remove_next_linked(req);
+
+	/* If this is NULL, then timer already claimed it and will complete it */
+	if (!timeout->head)
+		return NULL;
 	timeout->head = NULL;
 	if (hrtimer_try_to_cancel(&io->timer) != -1) {
 		list_del(&timeout->list);
@@ -328,6 +332,14 @@ static void io_req_task_link_timeout(struct io_tw_req tw_req, io_tw_token_t tw)
 	int ret;
 
 	if (prev) {
+		/*
+		 * splice the linked timeout out of prev's chain if the regular
+		 * completion path didn't already do it.
+		 */
+		if (prev->link == req)
+			prev->link = req->link;
+		req->link = NULL;
+
 		if (!tw.cancel) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
@@ -362,10 +374,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 
 	/*
 	 * We don't expect the list to be empty, that will only happen if we
-	 * race with the completion of the linked work.
+	 * race with the completion of the linked work. Splice of prev is
+	 * done in io_req_task_link_timeout(), if needed.
 	 */
 	if (prev) {
-		io_remove_next_linked(prev);
 		if (!req_ref_inc_not_zero(prev))
 			prev = NULL;
 	}
-- 
2.53.0


