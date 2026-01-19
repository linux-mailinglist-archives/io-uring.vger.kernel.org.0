Return-Path: <io-uring+bounces-11829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4198AD3BC26
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 00:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 628FF303B470
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 23:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B7F28BA83;
	Mon, 19 Jan 2026 23:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RMbnN4L2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9AD29BDBC
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 23:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866914; cv=none; b=hkLHjH4f1Kx3w72t5J/DpQDxwyYJCixMsj8LSMe7aDeU+RQJY/BWzwmuRgmZtIb5ZaJFZ6S0kr74QC+OR9oo/E0RO/MIdi07AH+ejjLo13MHEyj9vyKwTkfJ1kVPhLpdVQiXDQdOap3vd8G+1WQdTJ3m0gYI8cL0nQ0iSKPmaig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866914; c=relaxed/simple;
	bh=gI8IF6i90sSpMM42+GglewFidk53i0JuU9sAPd58vhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hy8QrptpK2qZi6rcjt+Qkrmr4etmXn6wWuVh/H83AN1Fk8FZAaoBbghG2e8j0KQAPtXukBVPNvprwyQIURvqCDKxQfRamCX2fhdKeCP6pkXLShht2fjqP9Gsp8RIvWPbIzBYlkn8ILaAfQoZESxmDuj/suNiepCID+tlrRsXvMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RMbnN4L2; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7cfd10887d5so1989155a34.1
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768866906; x=1769471706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/CPBtIEY2reDcfFlj80awQUDmd1e4dczwPPI3nx5ln0=;
        b=RMbnN4L2dBK5slq0uYXunZhEHYtjFiKt9n7LogPN3RKHK3cbxD9JJQZRr1XmpVu5OT
         jEDdPOUkhcLoUHBGeqraDGbqi1Dnoz10PWyJ3FYqHN1yDKkfBNqd0jsbzfvFHRtkgFSV
         4RmRzBL4jAZ5xZczilhXzbfZXFk7N6hScFsQxqzbIWJwQZR61yVw/iyhiglk2IxgsO2C
         NxYN19N5bc/2mZ9ij8MVxbLbr+bWozC3ZX+uVe5i4bOD8h9XPlj5K8J35ojJRfyzQ9yy
         epSSokk80dPdEuQFS8Yb4zKF7/4RxjXBfMvuLRA+ZxxUcqOJppEAf60ecBQqoaGyBLta
         IBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768866906; x=1769471706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/CPBtIEY2reDcfFlj80awQUDmd1e4dczwPPI3nx5ln0=;
        b=T3XDoaDkasttGx0mrMKzC5j+VeFed9OHRmDPZVvzkaHElhAQx8jEN2w45dZby9NXic
         AvhsEtwUogcS4l/+gRGSw41azfsVN/oSHcZ8Vnf2rmG1jJeGZTGShlohA5ulbmTE0ptC
         ZI9xDcy7k+Prj+jnER5hG5XtPYSgV2cBbTeSav2Gque7aX3kOqrBhuG225N7acaBz9mh
         juorcNnWs516assEp0i/0cC50UdClbzE2wcv8y6mRlpB2WcB5aECvDjbu2sYjUBEDiwG
         CttyN+/pMtKYMvXT15lvF3r+xcSlt8JFjNHR+0pz+ctIh4xSwjcI0HOFbvTX130C8nbm
         qLXQ==
X-Gm-Message-State: AOJu0YxYY3mnsSS1ga+vad9djCNkUAbHzfi7T089UealXcrqdKLDqm4Z
	hmpowt0vog7mopM7kcKbDnHUTII2sEOzqfOMlHk7xmCAG+39vLEd2g3kQRhPTt533iIsDDzUHxB
	tVap2
X-Gm-Gg: AY/fxX5dQiXoG3Y3UIj1taFDEQIzbxIvZTaMvcfaawujZGmR7kbTtn2ZLo+2r/VQULW
	7sEp1hc/bLtXqXcQFP67HhyGknQZoryqafQPCNBIsfiZ8vqZrExPfwhJ7Dmq9F6nDaJ12rPOx2j
	lGGGa66KmYLgltjrkSxReG4xbetdZGGLhYEymTwCuDGE/2FsVZvPS6e0jpGkpnKhDCoGiKUg7r3
	qvWZGGpirK+Ejky4o0vLk3GDL1H967j1KQh0CePSxyVGQ7QUghhNPDIQdYEsgM5vjMTTYKDFOdZ
	WwHlO1K3dksC5S8/zu1Va7NozqwkzNauTAZrKM0/+rQZkIW7PCKOC2wO41Aj++Tl3lQm3gsIHt4
	oYuGUp4gbjjD4y2X/sJTTWlUDLiAMIwJZjo77II1IgkSSf3seRjME56+wLfP/M8eMqCuk8Hte3l
	foDXwiNunSUZ06uQmqncEQFqBiiy0VVTWeFrYL29apDvl4y9n7/Byz27Hx
X-Received: by 2002:a05:6830:6f42:b0:7cf:dbb4:320e with SMTP id 46e09a7af769-7cfe01f613amr5805216a34.18.1768866905964;
        Mon, 19 Jan 2026 15:55:05 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2a5f02sm7509997a34.25.2026.01.19.15.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 15:55:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	jannh@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring: add task fork hook
Date: Mon, 19 Jan 2026 16:54:29 -0700
Message-ID: <20260119235456.1722452-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260119235456.1722452-1-axboe@kernel.dk>
References: <20260119235456.1722452-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Called when copy_process() is called to copy state to a new child.
Right now this is just a stub, but will be used shortly to properly
handle fork'ing of task based io_uring restrictions.

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


