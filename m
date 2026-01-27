Return-Path: <io-uring+bounces-11950-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WM5gLQ0FeWk3ugEAu9opvQ
	(envelope-from <io-uring+bounces-11950-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:33:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E29E899212
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 19:33:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CBCF5300B528
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE37328632;
	Tue, 27 Jan 2026 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pBolP3tK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F0D328B72
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538806; cv=none; b=oedwF4LI2yEcfyqwN1IKpANEbkRwdQEdJ/PKpch19gHvZierouDKy2fvwIMRdM0E9h0NKiKkzWOjqkjOr2B0r8HrnSkrwKhe+z+A3gScJ6eGufQZ5+RZFRNUTOVxjpSzQhINxlCp0NTqnKxuDJpBVnnLwGYKG/iJ0pmSYSPfN90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538806; c=relaxed/simple;
	bh=tZI1QB5MnRu4bKUEbLKC/RBZiGFsPlIzdvRmF+J3FfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5GxF1Bl/jfuJRVgsrDjE9P1pLt0l17hSfgczBRwOwN7cKVpP2NslxfClQcIp5ogL3ACJCBfDtAdXsBQqK3VIkFegtZpgPF19FR6Ktm4FMNeYk1fdjGqyEcV+6fAeMswkEazuJTy1pK/34KMnamrE/HUfxvNroUlA8CYjcL6uxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pBolP3tK; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1248d27f293so1492382c88.0
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769538803; x=1770143603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUez8ctlQKD0wSJt7bnuKaxD6ngfcI5V1NPTGNxZ1OM=;
        b=pBolP3tKc3wwQahOxjklhMPNXrDOuOrVWhkwIMwcI0eLbH3rkDexCSHgKfEuAJlWXi
         KyCkhf2LNrNc5W9A2d+UR3H8wZomoec4wQEpOgGFULKtiGPFecOQcpdHaHTCNUNGlNOT
         qT1hVNBuimiq1bfaTwcrdySKA89uInq/AstlpoezIUYVnWQelkv7qzojhOYi5dpGXg+s
         u5PLqkoADKj7VFBH2O/+y7QdSmKCXdadsk7d4l/78Tpg3Vv/tE/zWyZDH/CO3kuj0/qT
         bfVMMBOtm6vGstHKY/YdP41P8vlcHM6PAC8CGCLJ3VU43VIbQvnIEu3oeF78RwC0OSL3
         K8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538803; x=1770143603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LUez8ctlQKD0wSJt7bnuKaxD6ngfcI5V1NPTGNxZ1OM=;
        b=VpTgQJt7X6MRCzDSw7LfJsy2GUPbNKKTOYbD+LLS5SSjwcok8YIJD99kM2i7lyw0+3
         TZQYYRoaW9xELO7LsHM8miXNuMTyo24I7Y6u+isbYAyhs6MtCquSJmlKxLkIncAMyDPb
         I1AI9jPQzTJjV+KIR6/JH61PWBltEk7xjvhR9TejT/VMN+HmPBFS3yw/ubxRGDcHjJoc
         fiZOcjZKVQZQDjDR5X+nyAoLBr/YuoxkSG7kwYNZSsbbEfJe/ppRy275GqChhMM+Twhl
         Iy1Ji8WvaQ0HL/c0Ppf813bmbQS6Kw1FE5IoVJWXNu6Z637l2vfd45+FXcMHov0pZ9xP
         W1HQ==
X-Gm-Message-State: AOJu0YwbfmlfzQwfh3pNME3WDeKAZfkH4Db919hiQYfkgGh+P20EtCxh
	2w7+kqa8YZpg0yQIgNB5siqSNetSIikO2uHZh7NrYI8m0VzRRuVF1y2HrCpZ4yl+pSzt4sssBCj
	V/9oM
X-Gm-Gg: AZuq6aIyw3r4VGAbKxpyxqdHmTAW1QrC/CcXoT6WtATORdJ+8/uxny0+L3SUy7KwMfL
	IdGK5i2ArUaabsxAU5jYvuAdf6TVZLwrsoZEm951agVVB9BtCrHIMnl7wfwJytH5OEReNJMQDSD
	256w5MiJ7woZlotCNZVhr9Ad5jORZkTN0K3tkrOKUAyyyUg/flTq8wGx8B9tHdVoKexRNBgTNOA
	sR0Gu+klqnlfk3mP15QTmFoO5M741N7k4tNtpmWWrD29TN7YaORgLe29I86GqrJGNlUV9uz+Y8Z
	+5e2abdLGOiu6qwCpQhE1/rbA5O80nVfxukIiaXFJIsbj1Gade0REYwl5O4uSixHixMVcjzcvtd
	P7RvEbLQhRDmJVIWIzZAgxeMEZWzx0RDxa7eA41UEFsJ3W2HiKH+KLs5IFFKx85M9ORR53ZA7sc
	aB3Sdv6cE377yE2OHT6bCK6oaTOeJmE3JFIIg1tGZfUTiijPe+maQfmgE83zGSfA==
X-Received: by 2002:a05:7022:118e:b0:123:3360:aa99 with SMTP id a92af1059eb24-124a00f0febmr1115237c88.47.1769538802901;
        Tue, 27 Jan 2026 10:33:22 -0800 (PST)
Received: from m2max.corp.tfbnw.net ([2620:10d:c090:600::cedf])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a7bd05b1sm670139c88.3.2026.01.27.10.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 10:33:22 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	cyphar@cyphar.com,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring: add task fork hook
Date: Tue, 27 Jan 2026 11:30:01 -0700
Message-ID: <20260127183311.86505-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127183311.86505-1-axboe@kernel.dk>
References: <20260127183311.86505-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11950-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: E29E899212
X-Rspamd-Action: no action

Called when copy_process() is called to copy state to a new child.
Right now this is just a stub, but will be used shortly to properly
handle fork'ing of task based io_uring restrictions.

Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring.h | 14 +++++++++++++-
 include/linux/sched.h    |  1 +
 io_uring/tctx.c          | 25 ++++++++++++++++---------
 kernel/fork.c            |  5 +++++
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 85fe4e6b275c..d1aa4edfc2a5 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -12,6 +12,7 @@ void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
 bool io_is_uring_fops(struct file *file);
+int __io_uring_fork(struct task_struct *tsk);
 
 static inline void io_uring_files_cancel(void)
 {
@@ -25,9 +26,16 @@ static inline void io_uring_task_cancel(void)
 }
 static inline void io_uring_free(struct task_struct *tsk)
 {
-	if (tsk->io_uring)
+	if (tsk->io_uring || tsk->io_uring_restrict)
 		__io_uring_free(tsk);
 }
+static inline int io_uring_fork(struct task_struct *tsk)
+{
+	if (tsk->io_uring_restrict)
+		return __io_uring_fork(tsk);
+
+	return 0;
+}
 #else
 static inline void io_uring_task_cancel(void)
 {
@@ -46,6 +54,10 @@ static inline bool io_is_uring_fops(struct file *file)
 {
 	return false;
 }
+static inline int io_uring_fork(struct task_struct *tsk)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d395f2810fac..9abbd11bb87c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1190,6 +1190,7 @@ struct task_struct {
 
 #ifdef CONFIG_IO_URING
 	struct io_uring_task		*io_uring;
+	struct io_restriction		*io_uring_restrict;
 #endif
 
 	/* Namespaces: */
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 5b66755579c0..d4f7698805e4 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -54,16 +54,18 @@ void __io_uring_free(struct task_struct *tsk)
 	 * node is stored in the xarray. Until that gets sorted out, attempt
 	 * an iteration here and warn if any entries are found.
 	 */
-	xa_for_each(&tctx->xa, index, node) {
-		WARN_ON_ONCE(1);
-		break;
-	}
-	WARN_ON_ONCE(tctx->io_wq);
-	WARN_ON_ONCE(tctx->cached_refs);
+	if (tctx) {
+		xa_for_each(&tctx->xa, index, node) {
+			WARN_ON_ONCE(1);
+			break;
+		}
+		WARN_ON_ONCE(tctx->io_wq);
+		WARN_ON_ONCE(tctx->cached_refs);
 
-	percpu_counter_destroy(&tctx->inflight);
-	kfree(tctx);
-	tsk->io_uring = NULL;
+		percpu_counter_destroy(&tctx->inflight);
+		kfree(tctx);
+		tsk->io_uring = NULL;
+	}
 }
 
 __cold int io_uring_alloc_task_context(struct task_struct *task,
@@ -351,3 +353,8 @@ int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *__arg,
 
 	return i ? i : ret;
 }
+
+int __io_uring_fork(struct task_struct *tsk)
+{
+	return 0;
+}
diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8e..08a2515380ec 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -97,6 +97,7 @@
 #include <linux/kasan.h>
 #include <linux/scs.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring_types.h>
 #include <linux/bpf.h>
 #include <linux/stackprotector.h>
 #include <linux/user_events.h>
@@ -2129,6 +2130,9 @@ __latent_entropy struct task_struct *copy_process(
 
 #ifdef CONFIG_IO_URING
 	p->io_uring = NULL;
+	retval = io_uring_fork(p);
+	if (unlikely(retval))
+		goto bad_fork_cleanup_delayacct;
 #endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
@@ -2525,6 +2529,7 @@ __latent_entropy struct task_struct *copy_process(
 	mpol_put(p->mempolicy);
 #endif
 bad_fork_cleanup_delayacct:
+	io_uring_free(p);
 	delayacct_tsk_free(p);
 bad_fork_cleanup_count:
 	dec_rlimit_ucounts(task_ucounts(p), UCOUNT_RLIMIT_NPROC, 1);
-- 
2.51.0


