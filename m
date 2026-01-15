Return-Path: <io-uring+bounces-11734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 253A8D25E19
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:53:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8DCE730464D9
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 16:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CEC725228D;
	Thu, 15 Jan 2026 16:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SBn80TKy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8953ACEFF
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495980; cv=none; b=jdcwsGLFPWG6hSU0dgtXxXjnb3wUJZFf8IGs4JVmrwAgBW3UYza2W4RZolXDbYYP8HzQZc/Zc2dht9ENfx96cjkEtbjEZRrbifjY8ZRWMnKpS2CGN7H8AmnqlsOIxqQvSRNxmjoiXy7M6sDXIEChm6kCY1SrHwAc7Iy64pnABW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495980; c=relaxed/simple;
	bh=z5ldzGXb1Mx+Ie+WWddwX3eNbMvwxRXOp9cBd4hqmiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I21mwSjKFPnxKhLh8seyX62eaeAq9sefZUlJ5h96y/cm972TOZDhcDwn3Hs8Hccy03ZCtzgA7kmslPKykqiRdBLlwNHgL8bUdPoZqrvJGq8r4qzEOeFjkQJWIzI5rZEIgsCgQ+/Im2qm12eK6dUSxvCrfWAHM5KzZsqpA8B+SAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SBn80TKy; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-45c819ca0f1so707084b6e.0
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 08:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768495977; x=1769100777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FBvB/YxTuJ9KPLmb6aSnlinjD5ta37gomPuCv2m7dIA=;
        b=SBn80TKy84jkX41ikL3CnM6eBMzsVIGLs77lNNi2asFCEMPMSxG5Shq2j6Uzxj2zEG
         UjrOaClrxDEIwno/ofo7X9ZaSRU0TUkdPDWdm4LnSQ4Xs5WG5zmfRA8GXKAHPb9QehiG
         UkdiUUJTYpr8NJw5zBikAjKwKOyegRzzMZ54huqwBjDWbVgn0KSdoo3jbDG+gxFj0G6x
         5+E4O7EkG4iUU5xhi+oGMhXEwTgv1SoK0RltbV9DS529kIS2w4R9vK0Uqx9xX+l7jkUs
         kvq/Fp1bcmCHieNSGo0Pup8n9sjjLMU/itauNw6RB3+2n4j22+ceDJ7+jRzZwvo1OamR
         vwoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768495977; x=1769100777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FBvB/YxTuJ9KPLmb6aSnlinjD5ta37gomPuCv2m7dIA=;
        b=AqfN+n4lBiuOHwu8VidAxTI8F98OhJF6ezksKwUDaC3507bjq/K9YK3pDgOeahStW/
         AQDnN02/Y+ipUUTcs3/bntqBUoZW2QazT2CCaAfazf8hYHxz07mC7apxzoHD5lvoj5DK
         9fhSfrBwSEa+gEK/82H/OZ0ADBth0ehJf9+Mjbzx28Y4O2/9fOVmYbjkZM1PxeMXjyUs
         WTRwAOuDcscbu5COTINzEnGvevRa2zgBBQBn88nDSC0qGT/QGRaRcdrg4MEWVzrrspTC
         HF56gEYUa86lMlv2z6UOxv4hQ1uDLKS5AKd+hcmqtBd7owi5TBE9RmjnjdT+fbLley8L
         /mKw==
X-Gm-Message-State: AOJu0YyFLNmAa0UDQ1y82RJZV/sn47xzuNhrw4g2X9+TMFKguAR0CRPo
	6ceD4DutOO9GIuk/diic/oHcHMVzf8XwOHTFHZe3VwjFDCyrNLgJ0UF/l4IIeCe4A0yS1NkzlRJ
	VDOIv
X-Gm-Gg: AY/fxX4DmSY2THw1vH0Z/3expwwdidm8ukfX1Qim0gMBUUPcd8ErAl3arv9la7V2vm5
	sOORhZWQwJrSCz8fP1WQt9H/D40a2wwu8Ae/OUZoVwNFKVl9swQqVn4SJqgOujAkoHD3B+wBCn2
	lupi/AiAhVB4WhrIM6BKR70eIIq78cpFwsw6JTq7c8wY2NzetVH2Selgi0qO+1Wn0QKUiOCckJ3
	uFseyYwNP6Kz/vrx8MbC/SN/QQlWJRCieD54Amip6YRCR1zW0k6A3YRVTI+tAWqqud5wbifR/nR
	F73SccjRL8clWFJGvfiEBIW+OwjH/n2ByCs66mvrhIES5/QQbHYaeBQQVmfpE6hLroSja9Av994
	qZGT5W2pqkOqLsU8UQItu2eydCfnkunvfcTiNAJ7f/mj8Ikom+/HLDUB/YT06wLTwNkJkhQ==
X-Received: by 2002:a05:6808:1485:b0:45a:3d58:6475 with SMTP id 5614622812f47-45c87fd3922mr2125962b6e.13.1768495977039;
        Thu, 15 Jan 2026 08:52:57 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0db2ddsm14369a34.3.2026.01.15.08.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 08:52:56 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: allow registration of per-task restrictions
Date: Thu, 15 Jan 2026 09:36:34 -0700
Message-ID: <20260115165244.1037465-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260115165244.1037465-1-axboe@kernel.dk>
References: <20260115165244.1037465-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently io_uring supports restricting operations on a per-ring basis.
To use those, the ring must be setup in a disabled state by setting
IORING_SETUP_R_DISABLED. Then restrictions can be set for the ring, and
the ring can then be enabled.

This commit adds support for IORING_REGISTER_RESTRICTIONS_TASK, which
allows to register the same kind of restrictions, but with the task
itself rather than with a specific ring. Once done, any ring created
will inherit these restrictions.

If a restriction filter is registered with a task, then it's
inherited on fork for its children. Children may only further restrict
operations, not extend them.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring.h      |  2 +-
 include/linux/sched.h         |  1 +
 include/uapi/linux/io_uring.h |  9 +++++
 io_uring/io_uring.c           | 14 ++++++++
 io_uring/register.c           | 65 +++++++++++++++++++++++++++++++++++
 io_uring/tctx.c               | 26 +++++++++-----
 kernel/fork.c                 |  4 +++
 7 files changed, 111 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 85fe4e6b275c..cfd2f4c667ee 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -25,7 +25,7 @@ static inline void io_uring_task_cancel(void)
 }
 static inline void io_uring_free(struct task_struct *tsk)
 {
-	if (tsk->io_uring)
+	if (tsk->io_uring || tsk->io_uring_restrict)
 		__io_uring_free(tsk);
 }
 #else
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
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0e1b0871fe5e..dcf70e064e45 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -703,6 +703,8 @@ enum io_uring_register_op {
 	/* register bpf filtering programs */
 	IORING_REGISTER_BPF_FILTER		= 37,
 
+	IORING_REGISTER_RESTRICTIONS_TASK	= 38,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -808,6 +810,13 @@ struct io_uring_restriction {
 	__u32 resv2[3];
 };
 
+struct io_uring_task_restriction {
+	__u16 flags;
+	__u16 nr_res;
+	__u32 resv[3];
+	__DECLARE_FLEX_ARRAY(struct io_uring_restriction, restrictions);
+};
+
 struct io_uring_clock_register {
 	__u32	clockid;
 	__u32	__resv[3];
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 80aeb498ec8a..f1625e4c6c7b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3623,6 +3623,20 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	else
 		ctx->notify_method = TWA_SIGNAL;
 
+	/*
+	 * If the current task has restrictions enabled, then copy them to
+	 * our newly created ring and mark it as registered.
+	 */
+	if (current->io_uring_restrict) {
+		struct io_restriction *res = current->io_uring_restrict;
+
+		refcount_inc(&res->refs);
+		ctx->restrictions = res;
+		ctx->op_restricted = res->op_registered;
+		ctx->reg_restricted = res->reg_registered;
+		ctx->bpf_restricted = res->bpf_registered;
+	}
+
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
 	 * the mm is exited and dropped before the files, hence we need to hang
diff --git a/io_uring/register.c b/io_uring/register.c
index cb006d53a146..00b9508b18f9 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -223,6 +223,67 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
+{
+	struct io_uring_task_restriction __user *ures = arg;
+	struct io_uring_task_restriction tres;
+	struct io_restriction *res;
+	int ret;
+
+	/* Disallow if task already has registered restrictions */
+	if (current->io_uring_restrict)
+		return -EPERM;
+	if (nr_args != 1)
+		return -EINVAL;
+
+	if (copy_from_user(&tres, arg, sizeof(tres)))
+		return -EFAULT;
+
+	if (tres.flags)
+		return -EINVAL;
+	if (!mem_is_zero(tres.resv, sizeof(tres.resv)))
+		return -EINVAL;
+
+	res = io_alloc_restrictions();
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	ret = io_parse_restrictions(ures->restrictions, tres.nr_res, res);
+	if (ret < 0) {
+		kfree(res);
+		return ret;
+	}
+	current->io_uring_restrict = res;
+	return 0;
+}
+
+static int io_register_bpf_filter_task(void __user *arg, unsigned int nr_args)
+{
+	struct io_restriction *res;
+	int ret;
+
+	if (nr_args != 1)
+		return -EINVAL;
+
+	/* If no task restrictions exist, setup a new set */
+	res = current->io_uring_restrict;
+	if (!res) {
+		res = io_alloc_restrictions();
+		if (IS_ERR(res))
+			return PTR_ERR(res);
+	}
+
+	ret = io_register_bpf_filter(res, arg);
+	if (ret) {
+		if (res != current->io_uring_restrict)
+			io_put_restrictions(res);
+		return ret;
+	}
+	if (!current->io_uring_restrict)
+		current->io_uring_restrict = res;
+	return 0;
+}
+
 static int io_register_enable_rings(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
@@ -955,6 +1016,10 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
 		return io_uring_register_send_msg_ring(arg, nr_args);
 	case IORING_REGISTER_QUERY:
 		return io_query(arg, nr_args);
+	case IORING_REGISTER_RESTRICTIONS_TASK:
+		return io_register_restrictions_task(arg, nr_args);
+	case IORING_REGISTER_BPF_FILTER:
+		return io_register_bpf_filter_task(arg, nr_args);
 	}
 	return -EINVAL;
 }
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 5b66755579c0..d45785dcd2e3 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -11,6 +11,8 @@
 
 #include "io_uring.h"
 #include "tctx.h"
+#include "register.h"
+#include "bpf_filter.h"
 
 static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 					struct task_struct *task)
@@ -54,16 +56,22 @@ void __io_uring_free(struct task_struct *tsk)
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
+	if (tsk->io_uring_restrict) {
+		io_put_restrictions(tsk->io_uring_restrict);
+		tsk->io_uring_restrict = NULL;
+	}
 }
 
 __cold int io_uring_alloc_task_context(struct task_struct *task,
diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8e..da8fd6fd384c 100644
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
@@ -2129,6 +2130,8 @@ __latent_entropy struct task_struct *copy_process(
 
 #ifdef CONFIG_IO_URING
 	p->io_uring = NULL;
+	if (p->io_uring_restrict)
+		refcount_inc(&p->io_uring_restrict->refs);
 #endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
@@ -2525,6 +2528,7 @@ __latent_entropy struct task_struct *copy_process(
 	mpol_put(p->mempolicy);
 #endif
 bad_fork_cleanup_delayacct:
+	io_uring_free(p);
 	delayacct_tsk_free(p);
 bad_fork_cleanup_count:
 	dec_rlimit_ucounts(task_ucounts(p), UCOUNT_RLIMIT_NPROC, 1);
-- 
2.51.0


