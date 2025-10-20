Return-Path: <io-uring+bounces-10061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C24BF0D77
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 13:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F178F4F30FD
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 11:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3251255F31;
	Mon, 20 Oct 2025 11:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="RAdAj59X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC8D1A23AC
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 11:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760959844; cv=none; b=gtEnXJ5Hr39Un9Ny/2Nzf2TAWigRG26yvA2A0WN6Jgl99EfYnfeg1hNXXmrxvJ7oRZf7+WWySYh8GlgpnnNe5rtItPwoaifMNOztOJijTkuNPjavrxJUUuAzZY65lIE7wx4qUJEbkRiWJtQhEMg09RrWXZpEWeWxNtxMosQZWBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760959844; c=relaxed/simple;
	bh=rzRriMxzwzmsLaMoiaXdSUbnWfNiz5GRoP4Iv5zdfyw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pe/LQRAgcI9OrijrFz3f5lOp6/oH+7looB6v6tv5W18rQaZkMpFiZincsy5yXfKV8GSQyL3/Cn2WUOU/sB1I79Drqrih1Ctc22zPQ7Ew+x0Np7u4W4SuCm6bBsWcz1BiB4oycU3hpbsn6s8MbfYbaFDqL4p3VAp9rz4ZU3EVEYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=RAdAj59X; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b556284db11so3666317a12.0
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 04:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760959842; x=1761564642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fHkFGLyUm6n1hgDMO+AA3hNa5MtckEdWjaIZxpPzRFw=;
        b=RAdAj59XEqYnf99rPyLb0xQMxvA6nbnfWOth6oN5GJo7Cir8b/Cg3soOuQeAR7fIBo
         UVzS3DdKrfy3nXNYRWpgvzw8kWr+zyPhqzkyMXfAJ1TTVOhGN/r0jwLGDfbP9Py5ms7P
         tw7ZcQOxlmCUlzWC7kPk4eF+OWTwsGV6h2BVS86dCM9JV+xIxZ4tagAoFN0sP4M/rfuX
         2TOIGDVmR5Mg8rd53/OAhlCKuLvEm2c7cgAoQcqX02UtpsnQeQhlOzbk9DBrHKKKUw8j
         I8DkAC4bAy10hALAclIpVA2Vwb78tLfya34Gqy0fZ5vfH3UKfcrPJTYOp0dwTc3GgG/3
         uwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760959842; x=1761564642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fHkFGLyUm6n1hgDMO+AA3hNa5MtckEdWjaIZxpPzRFw=;
        b=Sh+IadiS0QykHSjE+FHAprPWDOt1T0HCJ8GRU/wt5VQHP20E/V54FIhGslBK0N2GGT
         3x6jU09cj5pFuCe3pBL/OeGhYFDV1Ko9ovNd1F5kY4NN6p5mZkD/lIeI07tu1DlT+YDz
         GT4+TYTy5SaYQlkDgVaiO89cf7vi6JNvgXnH3Y9Z4BeQuN278HvtKpdTN5h6fTOwYoBT
         IQp9GkKJOB6LKXGLldHpgV4ClKtZM2+SGbnbwuqH/57sTrXpG2NqmC1D394l5udUzwj/
         f4G+NNTYgc6s3xiqarBYdJaMUxBa6BJb7VwlyZHCCrIwMBSaZbkXPz25DyTrXzuF97i1
         h0Jg==
X-Forwarded-Encrypted: i=1; AJvYcCUhuvgtq4RGrKLmSsDP5F0McknMq0ktrQ6KgJhVCNKIj2m1N7H++dhHXadq/+cDS5oPcxrZZbE5sQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwsPlNAQVtZOq8xYTQPpaIx704CHNxmoVNIVnHLL7drH2PLthC
	E55F2uVmLIPWD6QtRo1hpADgc5VG5LUN4faBsLD7+fJB/cz4K/IFnTbWktrIoDjlWmE=
X-Gm-Gg: ASbGnctEkq1nDKJAUVlP6H4SMz/ZgQhzRbhb6lgdKTZFkzQygeTgs4HeJfBmtX/VDfU
	KgQ45UxE8cibYmL2h+oRTXWzC1PLd691JapaIAVjRqARsqCRVu1/GlUFA4OWnOsluvrC4YEuI9O
	P4khdhYFsMUopxka2vyNP3mopP8pBkBBzOoI6ToIW6zyuGCCXUSGHLstK5TDVKGKaWZaKvQjhXu
	G+Bi06G7jGVcjj4cWy1W6QKInma27FH0CW8cVfoNiwsk59k42znZaMGcc+lAofZwiCKtzQwgU2t
	18fQ67ksCJw0bQ/yVE5IDWRcGB/gMENGCynnh6xJ5pD0Wzc8OSuqslx/Fu07Txa69prAE1FRjwK
	mqFjhWJwf8dq2csyc3LokOG2xEJOJkgunsEy6E2oO1h5ZelIi9tilrllsglnTE4Kgi00+elFQPh
	TWzDNn0JxLjLEje5o/wmbZWURqh5NDiNqT4eddQ5w4+SV4
X-Google-Smtp-Source: AGHT+IFP5uUkoTtndGHmaP2BnNA/eryTvukUu5rNirQ3pAqTSI/R0dz49P4xEagOgAtr2VCgd5wjcA==
X-Received: by 2002:a17:903:287:b0:24b:4a9a:703a with SMTP id d9443c01a7336-290c9cbc0d7mr159441065ad.17.1760959841472;
        Mon, 20 Oct 2025 04:30:41 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246fdc0desm78107075ad.47.2025.10.20.04.30.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 04:30:41 -0700 (PDT)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	xiaobing.li@samsung.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
	Diangang Li <lidiangang@bytedance.com>
Subject: [PATCH v2] io_uring: add IORING_SETUP_SQTHREAD_STATS flag to enable sqthread stats collection
Date: Mon, 20 Oct 2025 19:30:31 +0800
Message-Id: <20251020113031.2135-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In previous versions, getrusage was always called in sqrthread
to count work time, but this could incur some overhead.
This patch turn off stats by default, and introduces a new flag
IORING_SETUP_SQTHREAD_STATS that allows user to enable the
collection of statistics in the sqthread.

./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 ./testfile
IOPS base: 570K, patch: 590K

./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 /dev/nvme1n1
IOPS base: 826K, patch: 889K

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Diangang Li <lidiangang@bytedance.com>
---
 include/uapi/linux/io_uring.h |  5 +++++
 io_uring/fdinfo.c             | 15 ++++++++++-----
 io_uring/io_uring.h           |  3 ++-
 io_uring/sqpoll.c             | 10 +++++++---
 io_uring/sqpoll.h             |  1 +
 5 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 263bed13473e..8c5cb9533950 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -231,6 +231,11 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_CQE_MIXED		(1U << 18)
 
+/*
+ * Enable SQPOLL thread stats collection
+ */
+#define IORING_SETUP_SQTHREAD_STATS	(1U << 19)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index ff3364531c77..4c532e414255 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -154,13 +154,16 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		if (tsk) {
 			get_task_struct(tsk);
 			rcu_read_unlock();
-			getrusage(tsk, RUSAGE_SELF, &sq_usage);
+			if (sq->enable_work_time_stat)
+				getrusage(tsk, RUSAGE_SELF, &sq_usage);
 			put_task_struct(tsk);
 			sq_pid = sq->task_pid;
 			sq_cpu = sq->sq_cpu;
-			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
+			if (sq->enable_work_time_stat) {
+				sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
 					 + sq_usage.ru_stime.tv_usec);
-			sq_work_time = sq->work_time;
+				sq_work_time = sq->work_time;
+			}
 		} else {
 			rcu_read_unlock();
 		}
@@ -168,8 +171,10 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
-	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
-	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
+	if (ctx->flags & IORING_SETUP_SQTHREAD_STATS) {
+		seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
+		seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
+	}
 	seq_printf(m, "UserFiles:\t%u\n", ctx->file_table.data.nr);
 	for (i = 0; i < ctx->file_table.data.nr; i++) {
 		struct file *f = NULL;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46d9141d772a..949dc7cba111 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -54,7 +54,8 @@
 			IORING_SETUP_REGISTERED_FD_ONLY |\
 			IORING_SETUP_NO_SQARRAY |\
 			IORING_SETUP_HYBRID_IOPOLL |\
-			IORING_SETUP_CQE_MIXED)
+			IORING_SETUP_CQE_MIXED |\
+			IORING_SETUP_SQTHREAD_STATS)
 
 #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
 			IORING_ENTER_SQ_WAKEUP |\
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index a3f11349ce06..46bcd4854abc 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -161,6 +161,7 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 	mutex_init(&sqd->lock);
 	init_waitqueue_head(&sqd->wait);
 	init_completion(&sqd->exited);
+	sqd->enable_work_time_stat = false;
 	return sqd;
 }
 
@@ -317,7 +318,8 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
-		getrusage(current, RUSAGE_SELF, &start);
+		if (sqd->enable_work_time_stat)
+			getrusage(current, RUSAGE_SELF, &start);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
@@ -333,7 +335,8 @@ static int io_sq_thread(void *data)
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin) {
-				io_sq_update_worktime(sqd, &start);
+				if (sqd->enable_work_time_stat)
+					io_sq_update_worktime(sqd, &start);
 				timeout = jiffies + sqd->sq_thread_idle;
 			}
 			if (unlikely(need_resched())) {
@@ -445,7 +448,8 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 			ret = PTR_ERR(sqd);
 			goto err;
 		}
-
+		if (ctx->flags & IORING_SETUP_SQTHREAD_STATS)
+			sqd->enable_work_time_stat = true;
 		ctx->sq_creds = get_current_cred();
 		ctx->sq_data = sqd;
 		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index b83dcdec9765..55f2e4d46d54 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -19,6 +19,7 @@ struct io_sq_data {
 	u64			work_time;
 	unsigned long		state;
 	struct completion	exited;
+	bool			enable_work_time_stat;
 };
 
 int io_sq_offload_create(struct io_ring_ctx *ctx, struct io_uring_params *p);
-- 
2.20.1


