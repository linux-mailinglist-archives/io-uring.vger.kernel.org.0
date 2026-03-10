Return-Path: <io-uring+bounces-12620-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBedBIkxsGkShAIAu9opvQ
	(envelope-from <io-uring+bounces-12620-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 15:58:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6333252B5A
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 15:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CB868304696B
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 14:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EF2A30E84F;
	Tue, 10 Mar 2026 14:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbuLZbtr"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9242FD1A5;
	Tue, 10 Mar 2026 14:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773154592; cv=none; b=B0WKcTdgX47Q+XlYluh2CbBypu22KH8qa+9wVfq3khaWHPpXRmbORHJ4cSvygjzyCOdDEe7pD8BepQtiD7rbBZHpYOoFtY2TVrQfrwXphiAUoLzSCSJfrBZl+07TYz0JgNZTVGyTOoqgYCeeKJV5p218Xvi2YJT3Aa27cmkGwDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773154592; c=relaxed/simple;
	bh=MHAAeqITSgAjja+L5nbHM5Kukkj1HvizJNSigDOYsIU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MZIeGpeZ+hK9sRnfMG8PZKUKL9gT0srCgmIG7uJOShb17NkBHnSmDJ+hkbdc3m6eKJL0GVIrbbCJwfRk1PUXZZS4LrZNflG2HCmoxXfAkgX7cQG9junTAc+7PivHIhY4TFNpvLRIuxEbOtw7/TEULrDwlBIjKIDnuXFobk4k5sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbuLZbtr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A706AC19425;
	Tue, 10 Mar 2026 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154592;
	bh=MHAAeqITSgAjja+L5nbHM5Kukkj1HvizJNSigDOYsIU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AbuLZbtrFQ2eEP/CSDfXv2VVj6ZTPsn2boPdFdefyNYGiud5pf1lZ/Yst30PPwQ8C
	 zp+cc2YsZjspEYtoVIqmH7ecAftlZqJNshugjq4aR+Vuidpx/mNiFf3OvSrsWQBJ2M
	 +XtPj6XHmk5Ut3BY373v9kmQbWN4HUrHZRna+omiYQwwb4+6ntjvWwiztidnpEWzrv
	 28P8AoDDbgXDe9Cxtdtmy8oByboNoYRIjEXWUXYoBVDUrvYUGa0ecVlqy5v9DQ5fOq
	 YDusNUQ57UiXoJ0P4H3Rn2YYwJf0lb8lqsjYvImYMQxkLuoWVE2yV+u16rQBh4lE5M
	 aVEsH7YsI8IKA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Mar 2026 15:56:09 +0100
Subject: [PATCH v2 1/2] kthread: remove kthread_exit()
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
In-Reply-To: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4676; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MHAAeqITSgAjja+L5nbHM5Kukkj1HvizJNSigDOYsIU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRuMBQrcElj2ixs13jGuG7pat+rn1Y5/+yRjs/VXcp0a
 OYEru1hHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO50MbwP+zCA8Nk9krfpfwr
 n+ZP+c5VsObWkfmHl72MOF88Ka9gRRYjw96skCWv8g/2TvizTfh03I937t/W5H5bHhwvay23zEm
 hnwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: A6333252B5A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12620-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

In 28aaa9c39945 ("kthread: consolidate kthread exit paths to prevent use-after-free")
we folded kthread_exit() into do_exit() when we fixed a nasty UAF bug.
We left kthread_exit() around as an alias to do_exit(). Remove it
completely.

Reported-by: Christian Loehle <christian.loehle@arm.com>
Link: https://lore.kernel.org/1ff1bce2-8bb4-463c-a631-16e14f4ea7e2@arm.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/linux/kthread.h    | 1 -
 include/linux/module.h     | 2 +-
 include/linux/sunrpc/svc.h | 2 +-
 kernel/kthread.c           | 8 ++++----
 kernel/module/main.c       | 2 +-
 lib/kunit/try-catch.c      | 2 +-
 tools/objtool/noreturns.h  | 1 -
 7 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index a01a474719a7..37982eca94f1 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -116,7 +116,6 @@ void *kthread_probe_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
-#define kthread_exit(result) do_exit(result)
 void kthread_complete_and_exit(struct completion *, long) __noreturn;
 int kthreads_update_housekeeping(void);
 void kthread_do_exit(struct kthread *, long);
diff --git a/include/linux/module.h b/include/linux/module.h
index 14f391b186c6..79ac4a700b39 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -855,7 +855,7 @@ static inline int unregister_module_notifier(struct notifier_block *nb)
 	return 0;
 }
 
-#define module_put_and_kthread_exit(code) kthread_exit(code)
+#define module_put_and_kthread_exit(code) do_exit(code)
 
 static inline void print_modules(void)
 {
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 4dc14c7a711b..c86fc8a87eae 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -338,7 +338,7 @@ static inline void svc_thread_init_status(struct svc_rqst *rqstp, int err)
 {
 	store_release_wake_up(&rqstp->rq_err, err);
 	if (err)
-		kthread_exit(1);
+		do_exit(1);
 }
 
 struct svc_deferred_req {
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 791210daf8b4..1447c14c8540 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -323,7 +323,7 @@ void __noreturn kthread_complete_and_exit(struct completion *comp, long code)
 	if (comp)
 		complete(comp);
 
-	kthread_exit(code);
+	do_exit(code);
 }
 EXPORT_SYMBOL(kthread_complete_and_exit);
 
@@ -395,7 +395,7 @@ static int kthread(void *_create)
 	if (!done) {
 		kfree(create->full_name);
 		kfree(create);
-		kthread_exit(-EINTR);
+		do_exit(-EINTR);
 	}
 
 	self->full_name = create->full_name;
@@ -435,7 +435,7 @@ static int kthread(void *_create)
 		__kthread_parkme(self);
 		ret = threadfn(data);
 	}
-	kthread_exit(ret);
+	do_exit(ret);
 }
 
 /* called from kernel_clone() to get node information for about to be created task */
@@ -738,7 +738,7 @@ EXPORT_SYMBOL_GPL(kthread_park);
  * instead of calling wake_up_process(): the thread will exit without
  * calling threadfn().
  *
- * If threadfn() may call kthread_exit() itself, the caller must ensure
+ * If threadfn() may call do_exit() itself, the caller must ensure
  * task_struct can't go away.
  *
  * Returns the result of threadfn(), or %-EINTR if wake_up_process()
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c3ce106c70af..340b4dc5c692 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -228,7 +228,7 @@ static int mod_strncmp(const char *str_a, const char *str_b, size_t n)
 void __noreturn __module_put_and_kthread_exit(struct module *mod, long code)
 {
 	module_put(mod);
-	kthread_exit(code);
+	do_exit(code);
 }
 EXPORT_SYMBOL(__module_put_and_kthread_exit);
 
diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index d84a879f0a78..99d9603a2cfd 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -18,7 +18,7 @@
 void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch)
 {
 	try_catch->try_result = -EFAULT;
-	kthread_exit(0);
+	do_exit(0);
 }
 EXPORT_SYMBOL_GPL(kunit_try_catch_throw);
 
diff --git a/tools/objtool/noreturns.h b/tools/objtool/noreturns.h
index 14f8ab653449..40c0b05c6726 100644
--- a/tools/objtool/noreturns.h
+++ b/tools/objtool/noreturns.h
@@ -30,7 +30,6 @@ NORETURN(ex_handler_msr_mce)
 NORETURN(hlt_play_dead)
 NORETURN(hv_ghcb_terminate)
 NORETURN(kthread_complete_and_exit)
-NORETURN(kthread_exit)
 NORETURN(kunit_try_catch_throw)
 NORETURN(machine_real_restart)
 NORETURN(make_task_dead)

-- 
2.47.3


