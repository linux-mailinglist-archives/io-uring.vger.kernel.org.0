Return-Path: <io-uring+bounces-12619-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SK4tHag8sGmohQIAu9opvQ
	(envelope-from <io-uring+bounces-12619-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:45:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 27230253DDB
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:45:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DEF603192AF9
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 14:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA597301704;
	Tue, 10 Mar 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmYJxjF5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1852FCC0E;
	Tue, 10 Mar 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154587; cv=none; b=AHStr4HmYSQqIVIQqfFgKU2InmU1O47noC0MaLLyp6PJ2rgvmQXzFizsat1vUpy8R74C6WpDPm+qdBrNEhFvuHZJuasi0z4YEM/2o2WD57euZ7hDrMeJ81AE8S51dngwRNhfC6C24gyfhPDf1u2dG8leq44mh+iKaf5I4BzVW8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154587; c=relaxed/simple;
	bh=fE0Z/ubIZkvllDHDQoyXm3PyilLIY5Tu3AO0WZjDsTc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=EZZD1Jg5ddu5gn8ISD3MpuPwymKvwjPw23tu2Uu3ksmRlPEoTYFdBpw6XW1Gfj/6+wSOYGzWSWQGLVDnoU4WC40kw0HcLvctezMmcSCi4/9BoSqExh1PjoMuhuZhqFq78lRWaRVh/riYXNsmn0W7DwZeWyVW+MAG6+BltNWrvms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BmYJxjF5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9FAC19423;
	Tue, 10 Mar 2026 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154587;
	bh=fE0Z/ubIZkvllDHDQoyXm3PyilLIY5Tu3AO0WZjDsTc=;
	h=From:Subject:Date:To:Cc:From;
	b=BmYJxjF5a9dvOp3Ha8UOY28eN9Ls8Tj2k9Ht30d/cMSVQDuueoydi7eHYyhEKug0P
	 7Nlx16fAGAVjuUcYJ2TifdA8RZUEW1WVE9bwxzk6xsX+LpY8pVoI4vRK7LSwKi5txn
	 TXEzAkjKCCygTWwTUJXDiJ1W7J4iNz/l+AwgclQGa3Y15wLxiZd+BOIdUxRV70lpku
	 Yb+xcr51PtPS54Gt5fizFsM4bBka1qsrUKeauVLz/PqrHs9sj2wVpJAkDrkRlREcW4
	 KDGuvIRo5jnylDD0rRfqsWWjU9OfzKITpIrGYVmZLMxWkcDeykF04Ooym+xGP7OcEp
	 HXaeEl2lsisxg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 0/2] kthread, exit: clean up kernel thread exit paths
Date: Tue, 10 Mar 2026 15:56:08 +0100
Message-Id: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAgxsGkC/yWMWw6CMBQFt0Lut5fUkuBjK8aPthykosXcViQh7
 N1WP+fkzKwUIR6RztVKgtlHP4UMeleRG0y4gX2XmbTSrWpUy59JRh4hAQ/G4hNrHPvuBO202VP
 WXoLeL7/k5frn+LZ3uFQ65WFNBFsxwQ1lepqYIPV8qBWLa2jbvtE5QPyWAAAA
X-Change-ID: 20260306-work-kernel-exit-2e8fd9e2c2a1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-nfs@vger.kernel.org, bpf@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 netfs@lists.linux.dev, io-uring@vger.kernel.org, audit@vger.kernel.org, 
 rcu@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, 
 Christian Loehle <christian.loehle@arm.com>, linux-fsdevel@vger.kernel.org, 
 Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-9fd7c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3309; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fE0Z/ubIZkvllDHDQoyXm3PyilLIY5Tu3AO0WZjDsTc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRuMBTr7bhhNqNZgWf+LzYHk0VPGot/7yk3qp6qVMf86
 r3sWbafHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZtoyRof32OmMzK1MvFp3i
 RLOjK2rOFX5Z+v3AGxeDj8ltGz5br2Fk2COsfshHNk+cZf2uoIUP/xl9bjn/zH4H6x9zpi1CQW+
 KGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 27230253DDB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12619-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

In 28aaa9c39945 ("kthread: consolidate kthread exit paths to prevent
use-after-free") we folded kthread_exit() into do_exit() to fix a UAF
bug but left kthread_exit() around as an alias. Remove it.

While at it, rename do_exit() to task_exit() to communicate that is not
just a private api.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
Christian Brauner (2):
      kthread: remove kthread_exit()
      tree-wide: rename do_exit() to task_exit()

 Documentation/accounting/taskstats-struct.rst                |  2 +-
 Documentation/locking/robust-futexes.rst                     |  8 ++++----
 Documentation/trace/kprobes.rst                              |  2 +-
 fs/cachefiles/namei.c                                        |  2 +-
 include/linux/kernel.h                                       |  2 +-
 include/linux/kthread.h                                      |  1 -
 include/linux/module.h                                       |  2 +-
 include/linux/sunrpc/svc.h                                   |  2 +-
 io_uring/io-wq.c                                             |  2 +-
 io_uring/sqpoll.c                                            |  2 +-
 kernel/acct.c                                                |  2 +-
 kernel/auditsc.c                                             |  4 ++--
 kernel/bpf/verifier.c                                        |  2 +-
 kernel/exit.c                                                | 10 +++++-----
 kernel/futex/futex.h                                         |  2 +-
 kernel/futex/pi.c                                            |  2 +-
 kernel/futex/syscalls.c                                      |  2 +-
 kernel/kthread.c                                             |  8 ++++----
 kernel/locking/rwsem.c                                       |  2 +-
 kernel/module/main.c                                         |  2 +-
 kernel/pid_namespace.c                                       |  2 +-
 kernel/rcu/tasks.h                                           | 12 ++++++------
 kernel/reboot.c                                              |  6 +++---
 kernel/seccomp.c                                             |  8 ++++----
 kernel/signal.c                                              |  4 ++--
 kernel/time/posix-timers.c                                   |  2 +-
 kernel/umh.c                                                 |  2 +-
 kernel/vhost_task.c                                          |  2 +-
 lib/kunit/try-catch.c                                        |  2 +-
 mm/hugetlb.c                                                 |  2 +-
 security/tomoyo/gc.c                                         |  2 +-
 tools/objtool/noreturns.h                                    |  3 +--
 tools/testing/selftests/bpf/prog_tests/tracing_failure.c     |  2 +-
 tools/testing/selftests/bpf/progs/tracing_failure.c          |  2 +-
 .../selftests/ftrace/test.d/dynevent/fprobe_syntax_errors.tc |  2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_multiprobe.tc      |  2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |  2 +-
 37 files changed, 58 insertions(+), 60 deletions(-)
---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260306-work-kernel-exit-2e8fd9e2c2a1


