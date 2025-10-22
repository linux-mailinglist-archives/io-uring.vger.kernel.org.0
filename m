Return-Path: <io-uring+bounces-10121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96999BFD858
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FBE13AC7D9
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D931339A4;
	Wed, 22 Oct 2025 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bpa6Ue4A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F522638B2
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761152665; cv=none; b=l5FRSwF1n9LMJQMAh1gzRjh5N20iPj/+YUuFmitKWA+fpu5QaPo10hJrIk9aZ3+MOOVkuEaedMPEnIbfxAfTwlMEhyRtLoAccrhU60WZjNTfKcjSLpCI51KFm2DvOf31F5hldeP2HrbeV5L4lLJebsuuCxCbgcJLa+wVBWZNaMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761152665; c=relaxed/simple;
	bh=i2eQI3XaFWULmqdYv3Ny6NLiIEgT6YS61RrHqGyQgdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR21fqftI4ql658/44cpKmKM7xgrGnmTuEFE1SPTPlaVMit6wyoavlnfDcRm1/JGIy5YMV7ZRZR8EC4mFgkSZLbyowuytLpjztYWsbf7LU1j3q+chronc8ODUQLiQSCjiD4BVObQ7gNoDKQ1q4fOBJ+rPZvjqQpb2COw+Y+dsDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bpa6Ue4A; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-430ae09ea23so26209595ab.0
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761152662; x=1761757462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cedYix93UpXuofahRWuOpgf8u8HttF8oaEywpS7Ki3c=;
        b=Bpa6Ue4At2+Hv3K8vQI8nax33G7EN1SKCh4HLKNyi1lNUdt1JGicHUsYv1VfWZZjTi
         tnlXD403d2+IpH3fsXvnO3hPIt9hPw0nBdjo2GuNZR0iFJNI5OgbZZM+7G4XAYXncww1
         PlOjepelpSgjmOn8v7bwazO/LSP/sfXieMcYegbGzz+YcO7d/aYuPYy+lIEwOYFBDxeO
         OwKJdi0DSIfCTXrj1TRjCT/3PMtA5LvisQMoxZtoem7wNEhdoHoDfh2gj0K558oyCUQI
         RWcPBcCnyxB8DgVux0lX0nOddvvwQpirSLhP4lBMaH8FlOMT41Pba/8vvTSRacPskT+1
         dNwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761152662; x=1761757462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cedYix93UpXuofahRWuOpgf8u8HttF8oaEywpS7Ki3c=;
        b=OVJOQ48VqtYpgqZBSst8tmAF7vwTxjXPhEJ0pdbT7Tw2wJ+PIQfco5BtGv5j+HDb0R
         jmkdppb/rvNS8iuus1bNffnQkUoSAZz9sjqu3G/1XvXjx87mZxIzb8a+fAwaIpwbFtW1
         rXQPTjnXR/txcyGwy2e/1HuuLN+2IcZj9E24psrUGEBJIF+pUweeFBvWAdYVcMKXWBvH
         KtgB1yaOb3rSXaj5p0jXbu/s/njKphfnvWOqt55Q+DMwHXHwBBhqrXdEP0HZUtB9iE4u
         IcaBxktrlAsUYq6Ewlj69erxnYUswB4+rVMb2ICFBGGV5P9MmcbT+iZOtemUQE5lJ8A6
         oXAw==
X-Gm-Message-State: AOJu0Yw8FX9w3QTbGn+NtTPQ+Vj3hRjQ2KOBS5Hk2dFFL+hFFRB707w5
	THAVVXhz17/Ti0rLkfz6PBwcT24Gf/sWnib5H4n1jTvtbygrb8lvxvWCQgnKHpzZmxENfG1GT5F
	T6PT7SE4=
X-Gm-Gg: ASbGncssktzD9xIuScsVAXxwJzW0ljE+mYa1LaBzwilxTai+qQRhuy9+/3qRID4LoZw
	vqwNl5z/rcQnSMDrBNMy15t/KSXHNeonACRaV+VKSwlVfRLVKbTiXUT28nqRLsZpLjiIa/AA3nu
	5eXUDmHkAFW3trjg6yRbKlgbbT9/wgV1uoNdvcAc906NH7K4jqt5BuCtzQYTew0e2AVlFfXXEnp
	JjUlkN+hu14nTzbeQt+jvXjpPtGXkrTvoXG67PXc9JT6SMADuPTaiW0OkhQU7/j6lsEYK38OKtH
	OLYHhO3uoQ6kCIp9hsF8WufhRrc1G3Y94AKAV/WSipLoVsAmtM8IZdBC5xFxn/tZA/uMGwSMx5L
	/TvWD0phmcGwKaOgEsJKN+zO/+/ieikIt2BSRkYPdNkNsOXNCtYRuAmwvCy6D9zPBt2saWw==
X-Google-Smtp-Source: AGHT+IEJRLIffhnekfUs4Wa5GpeiQRdkAifYgfyJsZn6gm0eOsIz3qpZGPGBALf4SfP+0qwODAn0xw==
X-Received: by 2002:a05:6e02:178e:b0:430:d061:d9f7 with SMTP id e9e14a558f8ab-430d061da22mr242828915ab.23.1761152661583;
        Wed, 22 Oct 2025 10:04:21 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a95fede6sm5352995173.12.2025.10.22.10.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 10:04:20 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: changfengnan@bytedance.com,
	xiaobing.li@samsung.com,
	lidiangang@bytedance.com,
	krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring/sqpoll: be smarter on when to update the stime usage
Date: Wed, 22 Oct 2025 11:02:48 -0600
Message-ID: <20251022170416.116554-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251022170416.116554-1-axboe@kernel.dk>
References: <20251022170416.116554-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current approach is a bit naive, and hence calls the time querying
way too often. Only start the "doing work" timer when there's actual
work to do, and then use that information to terminate (and account) the
work time once done. This greatly reduces the frequency of these calls,
when they cannot have changed anyway.

Running a basic random reader that is setup to use SQPOLL, a profile
before this change shows these as the top cycle consumers:

+   32.60%  iou-sqp-1074  [kernel.kallsyms]  [k] thread_group_cputime_adjusted
+   19.97%  iou-sqp-1074  [kernel.kallsyms]  [k] thread_group_cputime
+   12.20%  io_uring      io_uring           [.] submitter_uring_fn
+    4.13%  iou-sqp-1074  [kernel.kallsyms]  [k] getrusage
+    2.45%  iou-sqp-1074  [kernel.kallsyms]  [k] io_submit_sqes
+    2.18%  iou-sqp-1074  [kernel.kallsyms]  [k] __pi_memset_generic
+    2.09%  iou-sqp-1074  [kernel.kallsyms]  [k] cputime_adjust

and after this change, top of profile looks as follows:

+   36.23%  io_uring     io_uring           [.] submitter_uring_fn
+   23.26%  iou-sqp-819  [kernel.kallsyms]  [k] io_sq_thread
+   10.14%  iou-sqp-819  [kernel.kallsyms]  [k] io_sq_tw
+    6.52%  iou-sqp-819  [kernel.kallsyms]  [k] tctx_task_work_run
+    4.82%  iou-sqp-819  [kernel.kallsyms]  [k] nvme_submit_cmds.part.0
+    2.91%  iou-sqp-819  [kernel.kallsyms]  [k] io_submit_sqes
[...]
     0.02%  iou-sqp-819  [kernel.kallsyms]  [k] cputime_adjust

where it's spending the cycles on things that actually matter.

Reported-by: Fengnan Chang <changfengnan@bytedance.com>
Cc: stable@vger.kernel.org
Fixes: 3fcb9d17206e ("io_uring/sqpoll: statistics of the true utilization of sq threads")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/sqpoll.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 2b816fdb9866..e22f072c7d5f 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -170,6 +170,11 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
 	return READ_ONCE(sqd->state);
 }
 
+struct io_sq_time {
+	bool started;
+	u64 usec;
+};
+
 u64 io_sq_cpu_usec(struct task_struct *tsk)
 {
 	u64 utime, stime;
@@ -179,12 +184,24 @@ u64 io_sq_cpu_usec(struct task_struct *tsk)
 	return stime;
 }
 
-static void io_sq_update_worktime(struct io_sq_data *sqd, u64 usec)
+static void io_sq_update_worktime(struct io_sq_data *sqd, struct io_sq_time *ist)
+{
+	if (!ist->started)
+		return;
+	ist->started = false;
+	sqd->work_time += io_sq_cpu_usec(current) - ist->usec;
+}
+
+static void io_sq_start_worktime(struct io_sq_time *ist)
 {
-	sqd->work_time += io_sq_cpu_usec(current) - usec;
+	if (ist->started)
+		return;
+	ist->started = true;
+	ist->usec = io_sq_cpu_usec(current);
 }
 
-static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
+static int __io_sq_thread(struct io_ring_ctx *ctx, struct io_sq_data *sqd,
+			  bool cap_entries, struct io_sq_time *ist)
 {
 	unsigned int to_submit;
 	int ret = 0;
@@ -197,6 +214,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 	if (to_submit || !wq_list_empty(&ctx->iopoll_list)) {
 		const struct cred *creds = NULL;
 
+		io_sq_start_worktime(ist);
+
 		if (ctx->sq_creds != current_cred())
 			creds = override_creds(ctx->sq_creds);
 
@@ -278,7 +297,6 @@ static int io_sq_thread(void *data)
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN] = {};
 	DEFINE_WAIT(wait);
-	u64 start;
 
 	/* offload context creation failed, just exit */
 	if (!current->io_uring) {
@@ -313,6 +331,7 @@ static int io_sq_thread(void *data)
 	mutex_lock(&sqd->lock);
 	while (1) {
 		bool cap_entries, sqt_spin = false;
+		struct io_sq_time ist = { };
 
 		if (io_sqd_events_pending(sqd) || signal_pending(current)) {
 			if (io_sqd_handle_event(sqd))
@@ -321,9 +340,8 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
-		start = io_sq_cpu_usec(current);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-			int ret = __io_sq_thread(ctx, cap_entries);
+			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
 
 			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
@@ -331,15 +349,18 @@ static int io_sq_thread(void *data)
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
 
-		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-			if (io_napi(ctx))
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			if (io_napi(ctx)) {
+				io_sq_start_worktime(&ist);
 				io_napi_sqpoll_busy_poll(ctx);
+			}
+		}
+
+		io_sq_update_worktime(sqd, &ist);
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
-			if (sqt_spin) {
-				io_sq_update_worktime(sqd, start);
+			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
-			}
 			if (unlikely(need_resched())) {
 				mutex_unlock(&sqd->lock);
 				cond_resched();
-- 
2.51.0


