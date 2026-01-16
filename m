Return-Path: <io-uring+bounces-11766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77098D3896C
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:44:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6AB73012BF8
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 22:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC88270540;
	Fri, 16 Jan 2026 22:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XGz/DD/y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7B7313E0C
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 22:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768603445; cv=none; b=HniTD+xERH5L0e8Rq+Ew3T2/E3A14JtBXnA3/zkFt+V+Jx33Ty2wA2Dd1UmmgP9JcDoIhrSi7NR+bg/c20wX2oeDII+3Kq6Z0g0KfD2zFQ4Ex3TqIDcTEx3IL42F5ijAEvSdBvzvzlZ4oseTB4J+ykOE2Gn51aqaEJHjx4eYT0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768603445; c=relaxed/simple;
	bh=VMWmVT46sKRAO/YCJ1sjcqdKeiO/zBAd5TwNmNr40ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHzRfLaJWVB7CDTk8FIqz/0LU4CdvmhWQY/0icGNaPQz3h0ib8TkC4u4wMBuzqkXOajCsfzxEFfqP/7ya1N/wd5nz7upVBf5tjDUo+mviYKOCneMJelTZ6gSvQeC0V7N0jWsZpNozxapBKzemDXKdkaJAbiZpvXWHa0ydrkkbI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XGz/DD/y; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-45c7f550f46so1577844b6e.3
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 14:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768603442; x=1769208242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wPb9d2k11iSWaMwitSxVfEDVH+sa569zw/+owkyDvI8=;
        b=XGz/DD/yZHsHU+voj0kAX4u0jEFJiwV0q31ty9bxy/sEPeF2XwVfDZy6ClcInoUMFZ
         OoH1emi2u/E97odo0ttJMRK41ZgiVEK6uX5iOfI9cAWyFeab9EFAwmlXbnFyICXjbSYU
         4Gv6RrVwisAewU+Lbjxf/+SWYYi6BayOtJTf5fXs6QCU1c7FSBwQ52qHHERJHNoZO0Nl
         P7ooWpmgGo3wvtEujtB20+bsyRqB774ePLlJm59uJqAMm6ycOTFoiqJjRBy4JZ9h6mvR
         tiPVOMUGNuR982FkPhv39NaaRCQurtFLNmFyyqxNufQgRAeGWoZFVjt+VB+hH88fWylf
         n4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768603442; x=1769208242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wPb9d2k11iSWaMwitSxVfEDVH+sa569zw/+owkyDvI8=;
        b=IxEQgvPX1+tqGgX/gLXF1StpQ3M4ZTTWZhWoeEKRe9x6RXYpmrQvjkNjkbQGQXSOXP
         TBIZRjxrm6aJXhTHpYteSo0ipo4ijFeDuHGJmacf3VZdG/I1AGU4UOlHWujrF1c5BvTH
         XErQKaTVLI715BFv8/v64oEyJ8xdYPKpDWZordWB4avcxQ1URDEPjOKXSKwBKJwJ2vjw
         dreDV4gSnR9hFPrjIieVo7GaBshYyG8lEz982wrELHIm1/lTVN97Hszi7bH+QS3nG5ls
         xLU6/gXCaFQrb1JDyj1uOt/wiTmPQElxD/i9HJlMvkPvOhv5FfAxeZ2XqiboHSosDZaS
         rDNQ==
X-Gm-Message-State: AOJu0YxEuurXAWaNbhXROtaEVQ9joW5sODAW6oUgCrGjA9hrOv0q0SZA
	mLXeqFobsOphlloeRhlNxZeCzY4y2MZveVZlHLjeQpKpS3Q35MZXypBNHmDu+P2V6mjfWsAIjzl
	dyMW+
X-Gm-Gg: AY/fxX6at8srRb2D5B9Uh+0KelEg7lnfm+dJIaYpTeadXNb/zDovKFx4SNT4TJj+7b3
	YV0YZ2wFM+Svbi5n/l2k+tLZV/kaK1inqS5tELsPAYy+vhOZIFP80xqLBmB+U0X15mCnGfj5gnD
	ABMguubV8VU52v1ZMJl+Vplz0b8BXhS6VOA9Y47xi18MeoLZHxJ3Es2YpwgexNRxwKl0cxRRCL7
	nRfboLyyZh1kv/28zTOsS0Nmx6Grzv3mGZnH/yC1yK03YoI8Vq6QEZijQHGpPa5ulBY9ndALp+8
	t4LB5bCpqN1KblukWL/eg09/s4c1SOaRN7GtMdkSmt38imJYLwLDEpBltd0aNoweTdOoEXA5lTp
	axEDo5VMDcXIzFxwTr8alWOe5ReWgHYQM4G1fduCMvEl8wGXh0fJ7Y5t0s/vVGcSy+ecqgUHQdu
	yBVH91BFTF+InItc629VN8NmAXI4CuZPJ1SKsvG5gRRfVMOAT+yypUsmzX
X-Received: by 2002:a05:6808:1a01:b0:45c:8dfe:19a8 with SMTP id 5614622812f47-45c9c080e3cmr1810757b6e.44.1768603442581;
        Fri, 16 Jan 2026 14:44:02 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dec9ebcsm1945098b6e.2.2026.01.16.14.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:44:02 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: add task fork hook
Date: Fri, 16 Jan 2026 15:38:41 -0700
Message-ID: <20260116224356.399361-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260116224356.399361-1-axboe@kernel.dk>
References: <20260116224356.399361-1-axboe@kernel.dk>
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
 io_uring/tctx.c          |  5 +++++
 kernel/fork.c            |  5 +++++
 4 files changed, 24 insertions(+), 1 deletion(-)

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
index 5b66755579c0..cca13d291cfd 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -351,3 +351,8 @@ int io_ringfd_unregister(struct io_ring_ctx *ctx, void __user *__arg,
 
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


