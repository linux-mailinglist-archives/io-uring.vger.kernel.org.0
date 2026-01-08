Return-Path: <io-uring+bounces-11533-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A8BED06166
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 21:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A9333043791
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 20:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E05CB22A4F6;
	Thu,  8 Jan 2026 20:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M6NtbJGO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE94315D50
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 20:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904192; cv=none; b=H+jkHlqVi6JlBCgT3CsA2xNJzp8PVi3qHl2/lMgIMEPImfrWsEyBW+Ej1pqfzUSsskp3AWQsuax6T399jRVRZG5B+/BPSQ4yKUjZX6DVJr3jV/vn4/JLRXTtDdNR1hawaV+1aP2BzJ3a7fc1Qpnri351tlCHcmWVuydLwNyXmX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904192; c=relaxed/simple;
	bh=E27RXLlOzHsFDJLRn/HT9MqC6gnlbSq4TYGP701aYVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJHRKsOZfnhtG9UyNAlBOmc6NsRoWVE2gU1dJpR2N1bg6Qc6vcEQXlR2za2BN3tXZEEsAT4Z2XRSGADSWrmMdjMvFg0ayCYhmkQ2VkvNPLTD6QLuLv6lnKVCJbSKcgiZ2tkhhFEaDIbvl0Ldg+Rf94NDBNUV177xDW52DjCj6fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M6NtbJGO; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c7533dbd87so2643815a34.2
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 12:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767904189; x=1768508989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZsDAGY6R6bt5u39IlREg44gDj6M3Pu8gSRi7WUnF8bA=;
        b=M6NtbJGOM5PBt0z2zbypHLfZal0l5zGlxsOrec7CMZthCsCf5QXJUOtgxAZYXP2Psb
         m+1kWAm59eD2UqtwBKN01xQqkcsQx4Og2YXiqAnuFa2XzU8s2yo0rGnIlIdbe25bsPZB
         hy7cDMYwA87PqnTJzEumgSlKUhunDylovRpBRp5boZiHORRhmd3w42gAQDG76Oat9l13
         VNgXzDQHRnv3fwJARyW+FIHICTJlTVsAJPHdFpwAYRjQ+Dg+SO3Tc6jePDzenz/q4kyM
         5uBpy8HVPKsGCHTPl49WyOrY9sYCahKkCZB9XQt/jopn/G3Oo7jzIhoxigzeHhCRDRuo
         NfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904189; x=1768508989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZsDAGY6R6bt5u39IlREg44gDj6M3Pu8gSRi7WUnF8bA=;
        b=ou8+k6FBwB9A9TCF71r7TaGjSRsVwwq+G4I3d73JoQ5HktIIz7m7+Dx/7+fsPR8VoO
         0RJyBNlKeDF840HXV68R2VlNwFZ3ILEhpuIjygG0NszySgnodyygdIcDv4Mrv+51VVCI
         wpQBVQE9eoohigyyJoVasvGWQFBe75tOJwUJ+3E1rt37Ro5Z2WJpw4H+F4lK+gz4fvsx
         Br9T87xPWPWGx4kDA4Hs/d7O+vS2PejL5qD+eMMBePRciWB7Wmpxyj9T4N5tXIOmreH+
         83JrE1TD4sdlYhEQj58TlSVQazK9zuUrl1s7azQrXzVicKRn7IV0crTTUb9xzRglgvYs
         EUUA==
X-Gm-Message-State: AOJu0YzAsA51zOrlQjvV2rUmWWUtDqJZrO73GBdGjbzDO0n5++CMYdJo
	QgYc91f4WvDK5gCqKiD6S85jBjE1xAbLxz6SsUPuwkI+VBFe/+nMU83U9YMT21owPg1s/ESCEJS
	F9+q7
X-Gm-Gg: AY/fxX4NYEIlxrmXzf6fQolfW4BtQn12y8l3YoV/X4w3zEENW5RX0iIZqlretWOgdrT
	NvwgQDzjjoDRrAd6DWOHn4bKfE8ch9scfN6diXEsOHgnaaKmfL4oo3NxnmGBsyzDnlY5i8wCxtf
	ZRoZfcqc1M8VM3bfuKoATh5b8x9VVkVn/enBnoDNvEJ9128KdMFhNc27wj9vS7MQlid1Wiop/eR
	Sdw+un7JOR+Undf5irSErF3/QWVgJ/QfYJz+WBGO+twy3C4Qwp3X+XAUe7/zl1zYrw3iyT1MXxc
	6FXXRtCZAZiDLF6gZGYaodYlM0W10EaO0b6nBjHVHor7KfMqUwWBUb1sMHcpGJSWxyyS48Qjld6
	NqAwAcZl2i01aLmeB77it1CmeH+8WkHaqQk3zAJ5PW5iDRLguGH7hlDopiIanuikoLTc4s3A=
X-Google-Smtp-Source: AGHT+IHj3KDmyJ7XhZGVZZrOD493vIVZB7lXDr0hAO8lWlcp0u8YBNyqDI8BvX4GJEsPI5gb/crxSw==
X-Received: by 2002:a05:6830:4acb:b0:7c7:1f5:28a with SMTP id 46e09a7af769-7ce50a86dbcmr4764190a34.12.1767904188954;
        Thu, 08 Jan 2026 12:29:48 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478ee883sm6225020a34.28.2026.01.08.12.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:29:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: allow registration of per-task restrictions
Date: Thu,  8 Jan 2026 13:17:24 -0700
Message-ID: <20260108202944.288490-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260108202944.288490-1-axboe@kernel.dk>
References: <20260108202944.288490-1-axboe@kernel.dk>
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

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring.h      |  2 +-
 include/linux/sched.h         |  1 +
 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/io_uring.c           | 10 ++++++++++
 io_uring/register.c           | 36 +++++++++++++++++++++++++++++++++++
 io_uring/tctx.c               | 21 +++++++++++---------
 kernel/fork.c                 |  1 +
 7 files changed, 70 insertions(+), 10 deletions(-)

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
index b5b23c0d5283..3ecf9c1bfa2d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -700,6 +700,8 @@ enum io_uring_register_op {
 	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
 	IORING_REGISTER_ZCRX_CTRL		= 36,
 
+	IORING_REGISTER_RESTRICTIONS_TASK	= 37,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -805,6 +807,13 @@ struct io_uring_restriction {
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
index 1aebdba425e8..044da739ed0b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3608,6 +3608,16 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	else
 		ctx->notify_method = TWA_SIGNAL;
 
+	/*
+	 * If the current task has restrictions enabled, then copy them to
+	 * our newly created ring and mark it as registered.
+	 */
+	if (current->io_uring_restrict) {
+		memcpy(&ctx->restrictions, current->io_uring_restrict, sizeof(ctx->restrictions));
+		ctx->restrictions.registered = true;
+		ctx->restricted = true;
+	}
+
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
 	 * the mm is exited and dropped before the files, hence we need to hang
diff --git a/io_uring/register.c b/io_uring/register.c
index 62d39b3ff317..eac7a6da32b4 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -175,6 +175,40 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 	return ret;
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
+		return -EBUSY;
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
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
+
+	ret = io_parse_restrictions(ures->restrictions, tres.nr_res, res);
+	if (ret) {
+		kfree(res);
+		return ret;
+	}
+	current->io_uring_restrict = res;
+	return 0;
+}
+
 static int io_register_enable_rings(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
@@ -889,6 +923,8 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
 		return io_uring_register_send_msg_ring(arg, nr_args);
 	case IORING_REGISTER_QUERY:
 		return io_query(arg, nr_args);
+	case IORING_REGISTER_RESTRICTIONS_TASK:
+		return io_register_restrictions_task(arg, nr_args);
 	}
 	return -EINVAL;
 }
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 5b66755579c0..c8ad735936dc 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -54,16 +54,19 @@ void __io_uring_free(struct task_struct *tsk)
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
+	kfree(tsk->io_uring_restrict);
 }
 
 __cold int io_uring_alloc_task_context(struct task_struct *task,
diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8e..6081e1c93e21 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2129,6 +2129,7 @@ __latent_entropy struct task_struct *copy_process(
 
 #ifdef CONFIG_IO_URING
 	p->io_uring = NULL;
+	p->io_uring_restrict = NULL;
 #endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
-- 
2.51.0


