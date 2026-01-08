Return-Path: <io-uring+bounces-11534-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC40CD06170
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 21:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 761D33048EEB
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 20:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E01315D50;
	Thu,  8 Jan 2026 20:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QE29g7He"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF2D32BF5B
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 20:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904193; cv=none; b=Tpw5o8qC5NtDDFbSg/LujrFI7Vrhe4QdqusiBvC/IWbb5NzKECzniX5F2t9Nq0WMZqoApVWiiPntihRVNSt3mgYroSCnAFnaNxIIuEQ1Y+gjDKaU9yIpf+J3QXAkxM1Moe+9pQUZ+ErA1INJGOyVLEuJPfapx/if45daW00z7KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904193; c=relaxed/simple;
	bh=P/CXvos6+iENln5RszKa8J1gBcAJtZ0CVoHIdmMCWo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muqWwcJgvmGB/QMulKG/FtlnRLK3uQrQZLUEfOEtulXhT1fwDPbj9IElbcxqm5MiEAF9+v1laBA24Jo77TpJVVwIaH1JBSagtBU9mfeYg1dblaLF7zxYfAdfVO3chQUSatSrs4tnB83yUUZcUagkIx4PoX8UKgfx7D34C3pExS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QE29g7He; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7c7533dbd87so2643846a34.2
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 12:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767904190; x=1768508990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+zXmm51/t3kMvCrENo0wfAASBmqWcGKtcJRJqXjkvU=;
        b=QE29g7He2qluo2UU/7qeI+9sqdLOlTKOO6h3JbMS1YY3bmvKBFRXaPXP63d2nNuh4U
         Z1h/BEyWOSuYRwND44fwGv1T/2n83unmWdT3eDgoU0ad5DtsXKihmEngkS4VisN4hvjK
         0V9ZH9njWz6Fov/RGcjyZINa6CwWZwQ1weZ0EAuHyEo+RjvxIqltxQNA4+ZFHBBAI5V4
         QIwrGeprmUXg4XCu9qEi3smXagLEAmCMxEEzGuJBXEaqrKEcdrOcC40/bMvpRSXC93Hi
         VAIn/04mZWdc5jc3Zvq2NQp5/sevYjvG/5QZCEGi2m6SaImJ9D122H4jX3A5bUwNsfsR
         +qSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904190; x=1768508990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S+zXmm51/t3kMvCrENo0wfAASBmqWcGKtcJRJqXjkvU=;
        b=VY4mOy/75JQPSpohVi6ctiYcu1Q1kc4f3w0yGOOCuOjfBhjIuHnUF3vDgywWB4mz8q
         /JsJNFNK3Jdqb8V1HGXIUZRHG2Zdhanqf+B9xaqRvzQy9nuz8dwuk5id0K07+bKf3QCf
         p5ffTU+VFCo0XhaOpt3a3nAoO1vygFA1gcF6nIw1dGF3CpBujHZjqzjX/zFE0UFjA60E
         foesKRjjXfR18IuDcBKV0QFdxbCOULo4h1fWwu+m/NE+gJmE/Y7P3irbySeiAAa9xNED
         /tkBORyn6kw99v8sI6ITVbn7ljWjIR0M9l9UIKqkYe6B7DaRdT43WKSUCmyIbLY3Tq1p
         HQSA==
X-Gm-Message-State: AOJu0YznLtHYSdmD/8JSwXkszr3MRYsl77hpbujtBexy3nRrM2U04mjg
	XEPQnpY1r8VuhgqJysBGILiNmPJWtgJqQg9xJn9rH7xxpmARtQ52hWng+yLPqdVQOo5vwNtPFpf
	KWWST
X-Gm-Gg: AY/fxX5AIkmnXIuk22yK0A70+KyGJ+FZmCObbG7L+mqlWwRwjY1w4Jf8HN83mnoAmMf
	jyfrxyJpVMCZlf1iaO+8kuoS8E5ma6/Noc/qtbmaiG/7rCTTZT/dJMv8eFvjAjT6HgxFiTyFQhi
	IGeEqJfqM2TEKX37ny0J68EV4YuAli6fj0GHjqHU1yNAHdboUDkUngWcFX61cmYxl2piieydCXz
	VAq5S3cPPLZFPIxF7e90c5uudlgKJac744JAyG5cWyzPFYtizukyWWdQO+p6B/a3kNO9kbog+jf
	gkJBb8Cp2iT/wXa+tU/jLXnnnzV/rV6SXOQAxCulxo0SSUFDELilZ8VB0RagJ1MQJ2IlLE9/sN2
	mmU+XlSuTPfbo5FVQ61FXONYFeEYYkDqGsmTBX4pUvby+DRxj3/urXNoqaGgEU/WI8h8xUoY=
X-Google-Smtp-Source: AGHT+IFbN+7POUz9hcB8S+DhS/EsGM1QHYl4gp3ZQEK6jfOuVPtUxnMKZrF/wD0uSTJbAmhv9JHyXg==
X-Received: by 2002:a05:6830:264a:b0:7c7:69c8:2cb with SMTP id 46e09a7af769-7ce50b8cdc1mr4649719a34.24.1767904190444;
        Thu, 08 Jan 2026 12:29:50 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478ee883sm6225020a34.28.2026.01.08.12.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:29:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/register: add support for inheriting task restrictions
Date: Thu,  8 Jan 2026 13:17:25 -0700
Message-ID: <20260108202944.288490-3-axboe@kernel.dk>
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

By default, the registered task restrictions only apply to the task they
were registered for. Any forked tasks or created threads will not
inherit them.

However, if IORING_REG_RESTRICTIONS_INHERIT is set when registering the
task restrictions, then they will be inherited across process fork or
thread creation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 2 ++
 include/uapi/linux/io_uring.h  | 7 +++++++
 io_uring/register.c            | 5 ++++-
 io_uring/tctx.c                | 4 +++-
 kernel/fork.c                  | 7 ++++++-
 5 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 54fd30abf2b8..b63b927d8718 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -222,9 +222,11 @@ struct io_rings {
 struct io_restriction {
 	DECLARE_BITMAP(register_op, IORING_REGISTER_LAST);
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
+	refcount_t refs;
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
 	bool registered;
+	bool inherited;
 };
 
 struct io_submit_link {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3ecf9c1bfa2d..8d671b5e33e3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -807,6 +807,13 @@ struct io_uring_restriction {
 	__u32 resv2[3];
 };
 
+enum {
+	/*
+	 * Registered restrictions are inherited for a fork.
+	 */
+	IORING_REG_RESTRICTIONS_INHERIT	= (1U << 0),
+};
+
 struct io_uring_task_restriction {
 	__u16 flags;
 	__u16 nr_res;
diff --git a/io_uring/register.c b/io_uring/register.c
index eac7a6da32b4..36573b362225 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -191,7 +191,7 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
 	if (copy_from_user(&tres, arg, sizeof(tres)))
 		return -EFAULT;
 
-	if (tres.flags)
+	if (tres.flags & ~IORING_REG_RESTRICTIONS_INHERIT)
 		return -EINVAL;
 	if (!mem_is_zero(tres.resv, sizeof(tres.resv)))
 		return -EINVAL;
@@ -205,6 +205,9 @@ static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
 		kfree(res);
 		return ret;
 	}
+	if (tres.flags & IORING_REG_RESTRICTIONS_INHERIT)
+		res->inherited = true;
+	refcount_set(&res->refs, 1);
 	current->io_uring_restrict = res;
 	return 0;
 }
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index c8ad735936dc..f9ad9cbee9be 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -66,7 +66,9 @@ void __io_uring_free(struct task_struct *tsk)
 		kfree(tctx);
 		tsk->io_uring = NULL;
 	}
-	kfree(tsk->io_uring_restrict);
+	if (tsk->io_uring_restrict &&
+	    refcount_dec_and_test(&tsk->io_uring_restrict->refs))
+		kfree(tsk->io_uring_restrict);
 }
 
 __cold int io_uring_alloc_task_context(struct task_struct *task,
diff --git a/kernel/fork.c b/kernel/fork.c
index 6081e1c93e21..505f9397a645 100644
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
@@ -2129,7 +2130,10 @@ __latent_entropy struct task_struct *copy_process(
 
 #ifdef CONFIG_IO_URING
 	p->io_uring = NULL;
-	p->io_uring_restrict = NULL;
+	if (p->io_uring_restrict && p->io_uring_restrict->inherited)
+		refcount_inc(&p->io_uring_restrict->refs);
+	else
+		p->io_uring_restrict = NULL;
 #endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
@@ -2526,6 +2530,7 @@ __latent_entropy struct task_struct *copy_process(
 	mpol_put(p->mempolicy);
 #endif
 bad_fork_cleanup_delayacct:
+	io_uring_free(p);
 	delayacct_tsk_free(p);
 bad_fork_cleanup_count:
 	dec_rlimit_ucounts(task_ucounts(p), UCOUNT_RLIMIT_NPROC, 1);
-- 
2.51.0


