Return-Path: <io-uring+bounces-13452-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KC/HHeGbDWoS0AUAu9opvQ
	(envelope-from <io-uring+bounces-13452-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:32:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E999658C8B3
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 73B59300767E
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 11:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEF3401A33;
	Wed, 20 May 2026 11:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dILIBQf1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCBC400E17;
	Wed, 20 May 2026 11:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276077; cv=none; b=bn05Ty1/rInG5pQCv3xQ6qaIudxR7GmjZ5Njuz0Oxgmr4jO6UtqqKttL4AewrD9KBoMxIo+d2r9ed1VP6cBXccH4zrHpKhBDqkXyw2I3AR6+ocWbsEAxolajnBJuLouPwY6OsscFFhbS1r1/n9LKj/qbSa5SbpZVsrKVerPSepk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276077; c=relaxed/simple;
	bh=B4blOnHXdI+jGuEKFGOxpG/izqDXLDPkIG4KXfH8Axc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0RIo5w/Xn4wFzUQZXaa14T8xxQA+ZK5N9hUhlMqvttn/kFq2UW0lMs3mhbrx6x0HffDSUs2kDCAieYtTMD5uFwSWk8trqc0CYKESJFKYYECN0jv+wCl2AM5vf2C1m5e84ffQg2EWCwQ5LLcZP/OAas8AWp4yWfO0l+89NkKf2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dILIBQf1; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52951F00893;
	Wed, 20 May 2026 11:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276075;
	bh=SCmueEPDpuN64ioI9XEvbENRMV04N6Cn8zg40gHVn6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dILIBQf1dCTSqcGvB2nVPIhNnkrt/Tq92um0jyz9WyP45dISP6sQ8U2RmtJQa9L8d
	 dhet9WGAUr6uFD58XCMS1thW2RNiquoEV2Rxtixs0x8loEF5mkjkpmF/3zDVEjlhd+
	 H6DI4iXaOxOSBDFfQGKYPeUm9XnNF4VzmIur5DsYzN2/m3qAU7hINSrV25pG+np6sR
	 PfOnV2GIBAKM4jdnZ5vDXZEPG5RuGXLFAOcXQLGyhISbm+BS9ZT3FKJGSBS+UvED12
	 QMT85vONpIGkpIp75kmddASHRv806OrnzuMa2kg+wjo0mq7m0NGM2mv4HDzMhpKSVm
	 ozk69/VLkY0Kw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] io_uring/fdinfo: translate SqThread PID through caller's pid_ns
Date: Wed, 20 May 2026 07:19:36 -0400
Message-ID: <20260520111944.3424570-64-sashal@kernel.org>
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
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[gmail.com,ntu.edu.sg,kernel.dk,kernel.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13452-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,msgid.link:url,ntu.edu.sg:email,kernel.dk:email]
X-Rspamd-Queue-Id: E999658C8B3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit 3799c2570982577551023ae035f5a786cf39a76e ]

SQPOLL stores current->pid (init_pid_ns view) in sqd->task_pid
at thread creation. fdinfo prints it raw via
seq_printf("SqThread:\t%d\n", sq_pid). A reader inside a
non-initial pid_ns sees the host PID, not the kthread's PID in
the reader's own pid_ns.

The SQPOLL kthread is created with CLONE_THREAD and no
CLONE_NEW*, so it lives in the submitter's pid_ns. An
unprivileged user_ns + pid_ns submitter can read fdinfo and
learn the host PID of a kthread whose in-namespace PID is
different.

Reproducer (mainline 7.0, KASAN): unshare CLONE_NEWUSER |
CLONE_NEWPID | CLONE_NEWNS, mount a private /proc, then have a
grandchild that is pid 1 in the new pid_ns open an io_uring
ring with IORING_SETUP_SQPOLL. /proc/self/task lists {1, 2};
the SQPOLL kthread is pid 2. Before: fdinfo prints
SqThread = <host pid>. After: SqThread = 2.

Use task_pid_nr_ns() against the proc inode's pid_ns to compute
sq_pid, instead of reading the stored sq->task_pid (which holds
the init_pid_ns view). pidfd_show_fdinfo() in kernel/pid.c
follows the same pattern.

Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
Link: https://patch.msgid.link/20260510084119.457578-1-maoyi.xie@ntu.edu.sg
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
Phase 1, commit message forensics:
- Record 1.1: subsystem `io_uring/fdinfo`; action verb `translate`;
  intent is to report `SqThread` in the proc fdinfo reader’s PID
  namespace.
- Record 1.2: tags are `Signed-off-by: Maoyi Xie
  <maoyi.xie@ntu.edu.sg>`, `Link: https://patch.msgid.link/2026051008411
  9.457578-1-maoyi.xie@ntu.edu.sg`, and `Signed-off-by: Jens Axboe
  <axboe@kernel.dk>`. No `Fixes:`, `Reported-by:`, `Tested-by:`,
  `Reviewed-by:`, `Acked-by:`, or `Cc: stable`.
- Record 1.3: the bug is a namespace information leak: `SqThread`
  reports the init-namespace/host PID to a reader inside a non-initial
  PID namespace. The message includes a concrete reproducer using
  unprivileged user/pid/mount namespaces and an SQPOLL ring.
- Record 1.4: this is not hidden cleanup; it is an explicit namespace
  correctness and information disclosure fix.

Phase 2, diff analysis:
- Record 2.1: one file, `io_uring/fdinfo.c`, with 2 insertions and 1
  deletion in `__io_uring_show_fdinfo()`. Scope is a single-function
  surgical fix.
- Record 2.2: before, fdinfo used stored `sq->task_pid`; after, it
  computes `sq_pid = task_pid_nr_ns(tsk,
  proc_pid_ns(file_inode(m->file)->i_sb))`.
- Record 2.3: bug category is logic/security namespace translation. The
  broken value was a raw task PID; the fix translates the live SQPOLL
  task into the proc fdinfo file’s PID namespace.
- Record 2.4: fix quality is high: minimal, uses existing helpers, keeps
  the existing task lifetime protection, and follows the verified
  `pidfd_show_fdinfo()` pattern. Regression risk is very low; host/init
  namespace output remains equivalent.

Phase 3, git history:
- Record 3.1: blame shows the current `sq_pid = sq->task_pid` line last
  touched by `606559dc4fa36a`, while the semantic change to store/print
  `sq->task_pid` came from `a0d45c3f596be`, first contained around
  `v6.7-rc2`.
- Record 3.2: no `Fixes:` tag is present, so there was no tagged
  introducing commit to follow.
- Record 3.3: recent `io_uring/fdinfo.c` history includes multiple
  fdinfo correctness fixes, including SQPOLL lifetime/UAF fixes and SQE
  display fixes. No prerequisite series was found for this patch.
- Record 3.4: local history shows no other `Maoyi Xie` commits under
  `io_uring`; `Jens Axboe` is the listed `IO_URING` maintainer and
  committed/applied the patch.
- Record 3.5: dependencies `task_pid_nr_ns()` and `proc_pid_ns()` exist
  in relevant stable branches checked. The patch applies cleanly to
  `p-6.12`, `p-6.18`, `p-6.19`, and `p-7.0`.

Phase 4, mailing list research:
- Record 4.1: `b4 dig -c 3799c2570982577551023ae035f5a786cf39a76e` found
  the lore thread at the supplied patch.msgid link. `b4 dig -a` found
  only v1.
- Record 4.2: original recipients included Jens Axboe, Pavel Begunkov,
  `io-uring@vger.kernel.org`, and `linux-kernel@vger.kernel.org`.
- Record 4.3: no separate bug-report link or reporter tag was present;
  the bug evidence is the commit’s reproducer.
- Record 4.4: no multi-patch series or related required patches were
  found by b4.
- Record 4.5: no stable-specific discussion was verified. WebFetch hit
  Anubis protection; web search did not produce usable stable discussion
  for this exact patch.

Phase 5, semantic analysis:
- Record 5.1: modified function is `__io_uring_show_fdinfo()`.
- Record 5.2: caller chain is `/proc/*/fdinfo` read in `fs/proc/fd.c` ->
  `file->f_op->show_fdinfo()` -> `io_uring_show_fdinfo()` ->
  `__io_uring_show_fdinfo()`.
- Record 5.3: relevant callees are `rcu_dereference()`,
  `get_task_struct()`, `io_sq_cpu_usec()`, `task_pid_nr_ns()`,
  `proc_pid_ns()`, and `seq_printf()`.
- Record 5.4: reachable from userspace by creating an
  `IORING_SETUP_SQPOLL` ring and reading `/proc/self/fdinfo/<fd>`.
  Current code has global `io_uring_allowed()` gating, but no SQPOLL-
  specific capability check was found in the flag validation path.
- Record 5.5: similar verified pattern exists in `pidfd_show_fdinfo()`,
  which derives the namespace from `file_inode(m->file)->i_sb`.

Phase 6, stable tree analysis:
- Record 6.1: `p-6.12`, `p-6.18`, `p-6.19`, and `p-7.0` contain the
  exact `sq->task_pid` fdinfo pattern. `p-6.6` also contains
  `sq->task_pid`; `p-6.1` uses `task_pid_nr(sq->thread)`, which also
  returns `tsk->pid` in the checked header. `p-5.10` and `p-5.15` did
  not show `SqThread` fdinfo matches in checked paths.
- Record 6.2: exact patch applies cleanly to `p-6.12+` branches checked.
  Older `p-6.1`/`p-6.6` need backport adjustment due code shape
  differences.
- Record 6.3: no existing stable fix for this specific namespace
  translation was found in checked stable branch code.

Phase 7, subsystem context:
- Record 7.1: subsystem is `io_uring`, an important syscall-facing
  kernel I/O subsystem; affected surface is SQPOLL fdinfo, not the core
  I/O data path.
- Record 7.2: file history shows active fdinfo development and recent
  fixes. Maintainer metadata verifies Jens Axboe as `IO_URING`
  maintainer.

Phase 8, impact and risk:
- Record 8.1: affected users are container/pid-namespace users who
  create SQPOLL io_uring rings and read proc fdinfo.
- Record 8.2: trigger is straightforward where io_uring is allowed:
  create SQPOLL in non-init pid namespace and read fdinfo. It is not
  timing-dependent.
- Record 8.3: failure mode is host PID information disclosure and pid
  namespace isolation violation. Severity is medium
  security/correctness, not crash/corruption.
- Record 8.4: benefit is meaningful for namespace isolation; risk is
  very low due a 3-line localized proc-output fix.

Phase 9, synthesis:
- Record 9.1: evidence for backporting: real reproducer, unprivileged
  namespace information leak, tiny fix, maintainer-applied, uses
  established proc namespace helper pattern, clean applies to multiple
  stable branches. Evidence against: no crash/data corruption; older
  stable branches need adapted backports.
- Record 9.2: stable rules: obviously correct yes; fixes real user-
  visible bug yes; important enough as security/isolation info leak yes;
  small and contained yes; no new feature/API yes; applies cleanly to
  checked `p-6.12+`, with older-tree rework as noted.
- Record 9.3: no automatic exception category applies.
- Record 9.4: decision is to backport.

## Verification
- Phase 1: `git show --format=fuller --patch
  3799c2570982577551023ae035f5a786cf39a76e` verified the commit message,
  trailers, and 3-line diff.
- Phase 2: local `io_uring/fdinfo.c` read verified the pre-patch
  `sq->task_pid` fdinfo output and task reference context.
- Phase 3: `git blame`, `git show a0d45c3f596be`, `git describe
  --contains`, and file logs verified history and first-release context.
- Phase 4: `b4 dig -c`, `b4 dig -a`, `b4 dig -w`, and `b4 mbox` verified
  the lore thread, v1-only submission, recipients, and Jens “Applied,
  thanks” reply with commit `3799c257...`.
- Phase 5: reads of `fs/proc/fd.c`, `io_uring/io_uring.c`,
  `io_uring/sqpoll.c`, `kernel/fork.c`, `include/linux/pid.h`,
  `kernel/pid.c`, and `fs/pidfs.c` verified reachability, helper
  semantics, SQPOLL creation flags, and the pidfd fdinfo pattern.
- Phase 6: checked `p-6.1`, `p-6.6`, `p-6.12`, `p-6.18`, `p-6.19`,
  `p-7.0`, and `stable/linux-7.0.y` code; worktree `git apply --check`
  verified clean application to `p-6.12`, `p-6.18`, `p-6.19`, and
  `p-7.0`.
- Unverified: no kernel build or runtime reproducer was run; stable-list
  discussion could not be verified because direct lore WebFetch was
  blocked and search found no usable exact stable thread.

This is stable material: it fixes a concrete namespace information leak
with a tiny, conventional, low-risk change.

**YES**

 io_uring/fdinfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index c2d3e45544bb4..001fb542dc11a 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -190,8 +190,9 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 			get_task_struct(tsk);
 			rcu_read_unlock();
 			usec = io_sq_cpu_usec(tsk);
+			sq_pid = task_pid_nr_ns(tsk,
+						proc_pid_ns(file_inode(m->file)->i_sb));
 			put_task_struct(tsk);
-			sq_pid = sq->task_pid;
 			sq_cpu = sq->sq_cpu;
 			sq_total_time = usec;
 			sq_work_time = sq->work_time;
-- 
2.53.0


