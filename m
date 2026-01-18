Return-Path: <io-uring+bounces-11802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B63D3986C
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:23:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EBD843002159
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 17:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AA46A33B;
	Sun, 18 Jan 2026 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZKuWokDv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B7C7260A
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768757020; cv=none; b=XCBRvkQsRRXCB7OK5fghCMQRYRoiRQ0ZT1MZNHI74DX9ycerqtxZAun0ZABysi18OCOkbQW+vSD2A7jS9RXwEQJhYmgtaZdYNAjyJJ8fYUxGA0Yw69ZXbvlOsT2bg6sLQ+f9MybmZObkKmBZP9HrkrAhyQMkaDVlKTUNhbfOuoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768757020; c=relaxed/simple;
	bh=gI8IF6i90sSpMM42+GglewFidk53i0JuU9sAPd58vhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7UxwoPBTm4w+0jbpAKMxqQ0SZYrwHdfgXT8ayfohW0dWSbMpYIopCAzIaOtrUwWtY1lmR5zOo8/tXY1gOVBYYIYCJjTP22PlZIECixUBWlINoCzOzBXS0XzH7TRFIwF+Mk1PRpFGUA/bdsIQtdN5mdJt8p0+vgF6MkD0RKWKQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZKuWokDv; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7cfd65ea639so2181875a34.0
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 09:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768757017; x=1769361817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/CPBtIEY2reDcfFlj80awQUDmd1e4dczwPPI3nx5ln0=;
        b=ZKuWokDvaeDg9Qpv+PNBbO3llnIdVvNsXVoNCldPFI1k5IKBInnOALT9Rqan7bNSCt
         1bNFYgd/dE8HwohOAUUI+l7XicTrQejHhZE7j6teZniubyDZzmfOelYpDdOf5kd+jwCI
         M+lsnPZ9tSF1/Dvqf0bq/JMgCq6pJEloesuRahGe0DrVpy7xG1KOgd0jgA4Su71fWbSt
         Hgl2pOJh9OKV3aC3s2G39rATCTKF3xvO2eeuS93yDt9fJ3JVaQ1WwRa1b4FlOL+nl36k
         fpmYG5APxzcyjcQ8Ldtn+FuT7O313I9t3DuYe2Ol1mv9qkYW3TKpHOp8rYQC+H2lIkjD
         BVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768757017; x=1769361817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/CPBtIEY2reDcfFlj80awQUDmd1e4dczwPPI3nx5ln0=;
        b=CiTvheCRx1AITKoOUGroIxxW/RJrDtAYO7p483kkwywU5xEcm/r6We/ChMqN0/8OqN
         C/Jv0c21Zlh3W0/qjBTfEClzmC5s+qR6E+2riaWJE+LxwtaA/Y4FA6IjoBll+fVe7wfz
         467ngN19/mylNqhvA1tJV7aq4TCA2PN6mEGzT5G/1WoFXOvi2R87s/ylEKqqbIHzqv8T
         6FcMihX7JsIl8d2zmFEYq5ZXPppcENzJNUl2NCSay0o5Uwf1HrG18n8ga0SljXiw8dHp
         yRedk/WHhoT7NELx18at0Gm8xoPWmWFTP4XNrKqSJmXhHMVFy+/RnC2HD9PoWZBYjBKe
         Tk/A==
X-Gm-Message-State: AOJu0Yw049s0sXT2r1hcmvL9qrmrDKaTB+WWQRIXE+wZy3uVQZ8j5y05
	sts2X2CyPgwGeojdpSXpcdx3xC9WJVNgBhJvbyZI//2nPbKetmm0I0YrhY0brr2RwRtv+8fJNte
	6r08e
X-Gm-Gg: AY/fxX4wdhm53dKRK6md9623NJzXGbnYlCqm5nchyOixNitWxDn8j32OKrqcYCOLHa3
	guPjDBlcIYdbbbcyLSB1wwYsUWmr72m1IWZzWvkoEQPN2ftwvlyNZiyCu7COBVZVWV5Wwzrs7wE
	V+Bfpks4qqnQWjabLB5fZITHAD7Vn6BuNB1jmeSyA+eCSuQPzHiK9D/iU/XQEmHvqkmleNPJzcB
	FGr1G6Y2bc1tOtomdG2DaVqaP7ENluYgZB93qfkx7R+my64v6mswwg1f592c/J8FPkaDBJwJgmU
	CLXVtEFZ+yv6a6ooPUfqRO5cnzAvV5LkVlLeNu6MGdpTpmWbsUBoOVDi5yIE5eI91Bp5hyOuHGw
	EExOWomkbLTNQIhEODML4JIwcf8ZHr8jNowHHvdrPtdtKwLccrRSZsnl1bTcJ1IoCBIgb7EuaO1
	9ViWZOzCLNeY0u1Co5gDZMSfB7DYRwln4r+tt6Dbl3nAZW5v/nt2fZEVra
X-Received: by 2002:a05:6830:82ba:b0:7cf:d168:1f3e with SMTP id 46e09a7af769-7cfded4dea5mr5294335a34.3.1768757017628;
        Sun, 18 Jan 2026 09:23:37 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf101198sm5489558a34.13.2026.01.18.09.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 09:23:36 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: add task fork hook
Date: Sun, 18 Jan 2026 10:16:55 -0700
Message-ID: <20260118172328.1067592-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260118172328.1067592-1-axboe@kernel.dk>
References: <20260118172328.1067592-1-axboe@kernel.dk>
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


