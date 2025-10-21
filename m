Return-Path: <io-uring+bounces-10082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A915DBF8014
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 19:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85887544BCE
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 17:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE23C33C523;
	Tue, 21 Oct 2025 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lbn5QIw/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9571E34E752
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 17:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761069528; cv=none; b=UNRRGqj/gB3pbNRINjENdqluTKJ9k2iNL4g9v9HxBAZjurpgiBcjWd7kFnkNk8z8A6B2j5cdRDA08SAQ819xa0dvpaoJ3RkfVaIOQqprjo6J0SGfZClifVuBUT9jNvQtfS4kzcYPRoDceZh50hcvx5xtrf3xjb7O/f1d20x+nRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761069528; c=relaxed/simple;
	bh=dYaqtba+lcEi9oMjWIvqfn4QBsARq3VcoPkYULF3kZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U12+laxJVXbyWHbcYpa3H1Fn8ayGxSrUcwLCVaRXqIs034eMJK166bfsJkPzPCWACty3sWjWbPFKTiswpwM2ZZm4NIYam8sFqs/o7FulXn9tw2lZ9OQJegDOCFCOMUazfMzaSlwmnKFcvoQCTBQH3ZL46l8X1cgdgIAartUfb28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lbn5QIw/; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-93eab530884so291604539f.3
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 10:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761069525; x=1761674325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//rgOuzlc3oY7UoauIetEGfK45OBiE/hDMSHNfmVnPo=;
        b=lbn5QIw/Gghs+2i3V40XsiNANLkSFoty0ZI052ly43juN+QPLMwx6Qwkbnh7yzsxue
         n+C1PO06o1fMNYT8tprIFPbi1HL7u31+cfJj64VtwDBKlT2aK8PVOowdRZwwQhz2xsF9
         hiSQaU0nx1LCY0+n3jzjvjgAxroAxO+KNPz1mzQjzQfD9uZiVj8LFzNl0LLJ0rq516/3
         X/Gc1cqwddf4x5tYb6pb6+jIimq/lEobFH7vwnKipXwbFJea8nLXkYEb4N0wA204puZ0
         C8i2CZOMTlDvBUu+GIWHFS+3SuJO55OfmZAdh4lPwoMJpXx71LEqt4pHbRn7D6a9UUce
         Ympw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761069525; x=1761674325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//rgOuzlc3oY7UoauIetEGfK45OBiE/hDMSHNfmVnPo=;
        b=uigbxOCHJ5y1bLehcbw5bEp5TCABVn9u0XkpYbNQua1NJG2Ao9tkZrAytCM/y0WHTL
         Bpzsbcubc3cNfuZu9DHQSGnNCDW/cMJEeEBGeR6J34tDHUyu0OCF5q/5SHiopgPY0ljF
         wY76+MgRrY8c0v1/W7DEaDrZQeWsCBCWNjwuv+3P7HX2yafTOV+gc9YhBcdsgkd4AgxC
         LR6l3iEvFEDDgVAkKQGGwq5rVSKcFV8AHyFzicvNNcOZDdU3tAVMxb3HbPmZL+MmNe+y
         lKpCMjpQtr/PfC3WAgR8fDrIa8+UjEhhRd/2/5dVsRxxxJN5hXUVmc0YsqIo7F6Zmfbm
         fVkg==
X-Gm-Message-State: AOJu0Yy+lWzOoRmqr03vPQPe75CR+pcXwrxzcCeFI79jLNVf7/G7tU3j
	848lo4o+P4RNbrbZk0ufihmjMB6YQo1rn3VfnJBhnAIkwjOBD/rHZTI1Te8yk3cr4dkQFG0tBNj
	lgOJ5GYE=
X-Gm-Gg: ASbGncurYLLgiL1ZyLqWRw/95gN1Lnc7DGrTZIADdSvqP4nb+4wiKidTg+GMoXybqD+
	THzb9pph3wcTqCvqjWg5XmUgSPUvJpnOyWeKm7ZCPCQ2SbpyeZyF0peTRE3CxzOYnS/CA0ChEBF
	tvT68d+S9Z8e4Dzd8fKOoefenl1//dergySQE86ZQG5thOIbSxF0JN+9aKWRjQtZ4JNK6sivG9l
	wvDXHgEVHlqxdQGV7Culn1vRNwyiQR/t3ev2dR0gOXcgSxRSS1mjlTKFk2wKF0buMa43nz4mVB0
	AbQVQQrrQW+IOuV7pnaVb5vw1iWuY0CSWHJuBjs/IkR+n0oGbNnWL4QgNWK/wWzW0t3YEx8QGJ7
	LKtRoodSUNXiagsUnZCUS5i9MxCLeckxhE08qxbL0Zga6jiRHvu4pesUsw6Q=
X-Google-Smtp-Source: AGHT+IF8VMNfHV/EXMnTNxc2gcDU2NQQY//hClJ3pbjTujeEWZe7CHdGVuvCphR23vF9zUqANRkYDA==
X-Received: by 2002:a05:6602:2c01:b0:920:865c:a8a9 with SMTP id ca18e2360f4ac-93e7643157cmr2907822539f.14.1761069525182;
        Tue, 21 Oct 2025 10:58:45 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e866e0afbsm419906339f.17.2025.10.21.10.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 10:58:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: changfengnan@bytedance.com,
	xiaobing.li@samsung.com,
	lidiangang@bytedance.com,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring/sqpoll: switch away from getrusage() for CPU accounting
Date: Tue, 21 Oct 2025 11:55:54 -0600
Message-ID: <20251021175840.194903-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021175840.194903-1-axboe@kernel.dk>
References: <20251021175840.194903-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

getrusage() does a lot more than what the SQPOLL accounting needs, the
latter only cares about (and uses) the stime. Rather than do a full
RUSAGE_SELF summation, just query the used stime instead.

Cc: stable@vger.kernel.org
Fixes: 3fcb9d17206e ("io_uring/sqpoll: statistics of the true utilization of sq threads")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c |  9 +++++----
 io_uring/sqpoll.c | 34 ++++++++++++++++++++--------------
 io_uring/sqpoll.h |  1 +
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index ff3364531c77..966e06b078f6 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -59,7 +59,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 {
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
-	struct rusage sq_usage;
 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
 	unsigned int sq_head = READ_ONCE(r->sq.head);
 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
@@ -152,14 +151,16 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		 * thread termination.
 		 */
 		if (tsk) {
+			struct timespec64 ts;
+
 			get_task_struct(tsk);
 			rcu_read_unlock();
-			getrusage(tsk, RUSAGE_SELF, &sq_usage);
+			ts = io_sq_cpu_time(tsk);
 			put_task_struct(tsk);
 			sq_pid = sq->task_pid;
 			sq_cpu = sq->sq_cpu;
-			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
-					 + sq_usage.ru_stime.tv_usec);
+			sq_total_time = (ts.tv_sec * 1000000
+					 + ts.tv_nsec / 1000);
 			sq_work_time = sq->work_time;
 		} else {
 			rcu_read_unlock();
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index a3f11349ce06..8705b0aa82e0 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -11,6 +11,7 @@
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <linux/cpuset.h>
+#include <linux/sched/cputime.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -169,6 +170,22 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
 	return READ_ONCE(sqd->state);
 }
 
+struct timespec64 io_sq_cpu_time(struct task_struct *tsk)
+{
+	u64 utime, stime;
+
+	task_cputime_adjusted(tsk, &utime, &stime);
+	return ns_to_timespec64(stime);
+}
+
+static void io_sq_update_worktime(struct io_sq_data *sqd, struct timespec64 start)
+{
+	struct timespec64 ts;
+
+	ts = timespec64_sub(io_sq_cpu_time(current), start);
+	sqd->work_time += ts.tv_sec * 1000000 + ts.tv_nsec / 1000;
+}
+
 static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 {
 	unsigned int to_submit;
@@ -255,23 +272,12 @@ static bool io_sq_tw_pending(struct llist_node *retry_list)
 	return retry_list || !llist_empty(&tctx->task_list);
 }
 
-static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
-{
-	struct rusage end;
-
-	getrusage(current, RUSAGE_SELF, &end);
-	end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
-	end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
-
-	sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
-}
-
 static int io_sq_thread(void *data)
 {
 	struct llist_node *retry_list = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
-	struct rusage start;
+	struct timespec64 start;
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN] = {};
 	DEFINE_WAIT(wait);
@@ -317,7 +323,7 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
-		getrusage(current, RUSAGE_SELF, &start);
+		start = io_sq_cpu_time(current);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
@@ -333,7 +339,7 @@ static int io_sq_thread(void *data)
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin) {
-				io_sq_update_worktime(sqd, &start);
+				io_sq_update_worktime(sqd, start);
 				timeout = jiffies + sqd->sq_thread_idle;
 			}
 			if (unlikely(need_resched())) {
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index b83dcdec9765..84ed2b312e88 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -29,6 +29,7 @@ void io_sq_thread_unpark(struct io_sq_data *sqd);
 void io_put_sq_data(struct io_sq_data *sqd);
 void io_sqpoll_wait_sq(struct io_ring_ctx *ctx);
 int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx, cpumask_var_t mask);
+struct timespec64 io_sq_cpu_time(struct task_struct *tsk);
 
 static inline struct task_struct *sqpoll_task_locked(struct io_sq_data *sqd)
 {
-- 
2.51.0


