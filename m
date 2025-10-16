Return-Path: <io-uring+bounces-10029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 97EEDBE3239
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:45:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1C618357E3D
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 11:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD756215F6B;
	Thu, 16 Oct 2025 11:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UTMHNbDn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B1B6F06B
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 11:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760615133; cv=none; b=ZNk5dTt09YK9+NRK+Yz4wrg9gXs+dzPOkbhSBV5Nq1Wywc2LX8QKfyAh2C3WOzVc3ZZIURR7EMEu852HD22pKRrW4x7zIEEqrhW8vXRoEJOVwGM9tKjJAfGJQ0p9w7zletOQXdT87oSmxq0yiXso2IcDoCozYahG39bbW//3+eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760615133; c=relaxed/simple;
	bh=ywaf8A/x7Nbf+M1/lao302zTHzVygKYK/vrc8LJ9Ar4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jQK7isHULcBRr9gBmGR+jFer3pjunl2jdJJSqhARCbqrTAizdxvxGZNcAGc2tVTiBTK/zOvrRODKj3MZIK9+IB6VGDQ4KZeysbruwSau8zVtppSEnWmhiMZrIk0D5xKQMM3hGqRpgucvegmiOoPHInIysrVhTKT5qzuEALRhqu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=UTMHNbDn; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-330469eb750so866898a91.2
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 04:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760615131; x=1761219931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xQBARUEmqTrZUTIQJxj8ULDOw4rsQvi2TBKE8gNYFOs=;
        b=UTMHNbDnF12FkwP01OhA5ymjdU2rDBOffoloyI1hv97cpWH+r1oaEzRKyoHnpgnRv/
         W3kaJ6GzOaXKYxnHoG8R0sbU0xj28jSOfe39wGwaxha43iZkx3W8mNyEiVWJyhM3aFeL
         BoJtwlAe+zNoSJ+8Y+7+DXUGkzKScfTJtF3uZh2DULkbtxr6o6a8l42eoxCjz24BbUDC
         lbEO3465jy3kYYhFNJlRITLowg6rM9tJNljC5P1TDxf2PICSBCgd8ZsnGzkVso4baa79
         MFRwkvZkJ0hoV8Iua9vxuEjp5i5mINSG8U8Nw3C2sgzAOsH4IEttpQGEUCQ3KZbqI2+B
         mmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760615131; x=1761219931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xQBARUEmqTrZUTIQJxj8ULDOw4rsQvi2TBKE8gNYFOs=;
        b=qk/MQe8OHAUiBaGk1Bwx2WvOkhz9cH5iKkn9JUYIadBXLSK4ta6dakVyR3ZFrQQRQS
         yci7txuPbTGAwhu41zVjIihVJrdMdMGo5Dr2Z5hUB2peS6+sRfzqoJ0fjf32oNGvnN9d
         GeRI4CNqZiyb9Jg0zQS+Sn0TKxsCt0wv0UoV+Alex8e19rgI/Bu1Isx79XeI98kO3sbu
         woeWQJN59jiZSJxZshS2RYGJ6x8XbmT1hqi5lSRD2MiKhkX0LwLcJ8gb0qhq5Z6vOWzO
         yhETq1p7VxNVImNPKbtwthIs4dgGDqDxgdE/QuVEV4d/82I3sLGwz7mhkodL+E1rdtCo
         lStg==
X-Forwarded-Encrypted: i=1; AJvYcCVIaJRsK3iviVfqEB5Nz/gIfSYRur9XyAy9uvJA6QYAwbZP4p7q+S4kmtP4rgqDfNTynHL0GZsPJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMT5Rl6EOG48it26r+geFGlXSXFvdyGXBfMn/5DaKBXKHAwDY0
	vjA0vs1YcI8XFt+JH4F+odni0bkFKJaJ3LA9ixQPVbqu6UR58VhCiI8yafBtp62RQL+s4RjDd/x
	xcvL3
X-Gm-Gg: ASbGncsAGZVL3/MMyB8ijVe2aPKzOCyjtPJzBn7DNUNBdKPKzOLaQ1E+zS5FNSOI9os
	kUSD5zgXvx5U8XylFxPRt6oba3phPPYjA2ybcxKZnhPMrZGZNq5MqiYN2omOjhnX2S5hON2YWXV
	Xcx5hSM2C6C8eIfePHX+5uRtYuDN/i1Otl8IrfbhxkR4pgLXAlcFolZtdirRmq565B1IgcSFsvg
	eTB25Egrsd7m8OxTivOfnvDB2OiT+zQKk1Q2ESaqArZDehVpmihjAfjP9ChebnJXQ0/2XQACgpx
	5moGlYwFijnYJ5K8KyRp4ukNQYV0ZJqYOf+rYL5JcrW7jq8DIMj4+tCoPuN9J3X8gKZCjOFr7ca
	4JSAg9+Q6y9GIw837OkrSb63WsDcE43GOt89gmCwtP4YPNt0OY9NOEWJYqv8OQ6KGdZi1EECXwx
	jF/2PavVlJptc8tr6iY0GmSV7xJB/FEZJIcu0PceA=
X-Google-Smtp-Source: AGHT+IFL9gVSjbsN/tjWEd0VOhMKK2bAN2AN91+u++PE9V0fiR0brtczbNxWDCYGnRnHnlgGldIZWg==
X-Received: by 2002:a17:90b:1d0a:b0:332:50e7:9d00 with SMTP id 98e67ed59e1d1-33b51118f31mr47965976a91.11.1760615130760;
        Thu, 16 Oct 2025 04:45:30 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a227765f7sm2660227a12.0.2025.10.16.04.45.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Oct 2025 04:45:30 -0700 (PDT)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	xiaobing.li@samsung.com,
	io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
	Diangang Li <lidiangang@bytedance.com>
Subject: [PATCH] io_uring: add IORING_SETUP_NO_SQTHREAD_STATS flag to disable sqthread stats collection
Date: Thu, 16 Oct 2025 19:45:19 +0800
Message-Id: <20251016114519.57780-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

introduces a new flag IORING_SETUP_NO_SQTHREAD_STATS that allows
user to disable the collection of statistics in the sqthread.
When this flag is set, the getrusage() calls in the sqthread are
skipped, which can provide a small performance improvement in high
IOPS workloads.

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
index 263bed13473e..57adae0d67e5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -231,6 +231,11 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_CQE_MIXED		(1U << 18)
 
+/*
+ * Disable SQPOLL thread stats collection, skipping getrusage() calls
+ */
+#define IORING_SETUP_NO_SQTHREAD_STATS	(1U << 19)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index ff3364531c77..055a505fa27c 100644
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
+	if (!(ctx->flags & IORING_SETUP_NO_SQTHREAD_STATS)) {
+		seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
+		seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
+	}
 	seq_printf(m, "UserFiles:\t%u\n", ctx->file_table.data.nr);
 	for (i = 0; i < ctx->file_table.data.nr; i++) {
 		struct file *f = NULL;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46d9141d772a..f3e72b447fca 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -54,7 +54,8 @@
 			IORING_SETUP_REGISTERED_FD_ONLY |\
 			IORING_SETUP_NO_SQARRAY |\
 			IORING_SETUP_HYBRID_IOPOLL |\
-			IORING_SETUP_CQE_MIXED)
+			IORING_SETUP_CQE_MIXED |\
+			IORING_SETUP_NO_SQTHREAD_STATS)
 
 #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
 			IORING_ENTER_SQ_WAKEUP |\
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index a3f11349ce06..4169dd02833b 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -161,6 +161,7 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
 	mutex_init(&sqd->lock);
 	init_waitqueue_head(&sqd->wait);
 	init_completion(&sqd->exited);
+	sqd->enable_work_time_stat = true;
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
+		if (ctx->flags & IORING_SETUP_NO_SQTHREAD_STATS)
+			sqd->enable_work_time_stat = false;
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


