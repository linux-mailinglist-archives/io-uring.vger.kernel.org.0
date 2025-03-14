Return-Path: <io-uring+bounces-7078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B01A61623
	for <lists+io-uring@lfdr.de>; Fri, 14 Mar 2025 17:22:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61B383B656E
	for <lists+io-uring@lfdr.de>; Fri, 14 Mar 2025 16:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99EF01FECA9;
	Fri, 14 Mar 2025 16:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Hq5/B6/F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9955E60B8A
	for <io-uring@vger.kernel.org>; Fri, 14 Mar 2025 16:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741969366; cv=none; b=Lpyk6bk7USnHbFxALjlxlTbrGnaub4cgrBhCW4E4zLAplRlH1hki+0g1JIHMyafUaZFkOk4v/uGzDssnNy3Rbi0OEsXCoQdVzL/p3bfntw/oPd5bb4YqluCJbJFqGkzz00N9c+dA6j82J8Kr2s59wEpEXk7T+WEjxChq3Jm5tmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741969366; c=relaxed/simple;
	bh=mc8KTESZVMgmCNUJuTSDE0H9jd5EvLy3nwU4dBVYB50=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=mvQiI008kPSe3SxyeN5aTMTZ2G48NlVbCv95FEMT/XJxodNtJg2ZG76Kg4gL7jJH7YVlrW3O1XcPoytP0XhAo0JLDz4NxfAk5EbIjhZcdaT70/FQjHv1xB1vMZHVpu7ye9vZXv7RJ99s1iHeJnaoNmWTWTRIjp6NMhx/XE+6DyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Hq5/B6/F; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3cfc8772469so9254195ab.3
        for <io-uring@vger.kernel.org>; Fri, 14 Mar 2025 09:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741969363; x=1742574163; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLvXMnt3mmDY7IDQcH5hm0cFaI8beFDv4MU8xSfplmE=;
        b=Hq5/B6/Fn8FtYw4LVKNsXoVSBakftoO2u1s9cGKJbBfa0MyOF9PB5iEP1+n4oDkOwB
         eNaZhRnrwzQZfLPy4htaQbG8+KMoXjCLRo39bxbvm4n0/1RbtTPg4NjxRm4ao1ipzcvK
         gRyY7MnSZiQBRHIRV1+GJmI+FK5reNe+1OqVarKRvj1FIEJ694yBCSrjsx+XvfDJmXrJ
         a7j5Ivsg6V1OrL9yPX9eY1cCRHjpMsgZUI4jMupk0fsqu3WnYbLulLMEdRnFvJgA8ijm
         4AyhiT6zkxh9OGvM0LR/KvrCvgs5qYzrrD+/u2shBwyCQ7NBHpiGE9ctIwIlDJvZ5OhN
         cgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741969363; x=1742574163;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WLvXMnt3mmDY7IDQcH5hm0cFaI8beFDv4MU8xSfplmE=;
        b=LoYAGKXB00iZN8onHMJOxm4ee0jBAZdQuFBZhLDKvqIKxaw+B7d86iTbm9eyCml9YE
         rkW397Pz0SwIFflyhqHZs2jy9soEf3ISc4QwAgSeHoGbKyJxHjz5SlhoeBkWoFu9Yapg
         NypsJTzK5J3kfvi0klvcVaQ2QVaDcn1Swr9PgRGeyxPaK8l3scUvsESwxiqK0uLQ0x/q
         OdUhIkcQ0XhMxDXwXogVTTA9KVxUaMdFna4NwOsnDPewVTybw9ZpuQVQ4BKSwtIFCpLb
         aUalYL3vKdiFE2wMnruKxVjzMuKPLC0ryJgErHpMsM9eP3x4Q774GaJXVH0yKDssJEFJ
         o/rA==
X-Gm-Message-State: AOJu0Yymkk1NlPtAJnjqrNviZa2L6Wdr1SgRgKifR7oFoOajiuMfWeNY
	jO8rdIAM1Kq6Ntvo+6Z72kuwc4b8ZsasY8EkuU7l1/DmXu2iVOkT63R/W20aEmcFoTndj7c9iQS
	Y
X-Gm-Gg: ASbGnct7Tu/RnlUIFpiB+cy2kMY0ZNDdTWsxaxM988B249o4kBV7fTd02RloB6af6HC
	So/AbWvMqqZ9+oDABUo+EaripkNYogmWgx0ew8Dtwtl5OkKIs45DZXxvXQx7h3FaUoSiDN+L323
	IP4eRTxY6GB7/v1Jj+NPvZw4+rnge1Uyh9t4Gf9uzjNVke+J9FbTCTfDsbmbrrlAUqJPBcLoQSa
	paeM9ktP6dWPgKESvIxVRKDhG1dlp2kpiPy/dMq7gGWE9HULFxl0WKEIKA5mNlIOPN4AZKNNZwH
	u91mjtNTaZqWbbNsS5VkiMukNr7ndABxmFtCst/8bw==
X-Google-Smtp-Source: AGHT+IH2O0Pkk00Qud1delcH7nE8eZSoh+0Y80M9y3M1DEEMy8/i2Ofv1G+x4Od21JTX9ObFRPTT7Q==
X-Received: by 2002:a05:6e02:2184:b0:3d1:9236:ca52 with SMTP id e9e14a558f8ab-3d48398237emr20879825ab.0.1741969363121;
        Fri, 14 Mar 2025 09:22:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637fe8a3sm906899173.101.2025.03.14.09.22.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 09:22:42 -0700 (PDT)
Message-ID: <d665dd6a-ab8d-4f43-8280-e70b5f064866@kernel.dk>
Date: Fri, 14 Mar 2025 10:22:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: enable toggle of iowait usage when waiting on CQEs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

By default, io_uring marks a waiting task as being in iowait, if it's
sleeping waiting on events and there are pending requests. This isn't
necessarily always useful, and may be confusing on non-storage setups
where iowait isn't expected. It can also cause extra power usage, by
preventing the CPU from entering lower sleep states.

This adds a new enter flag, IORING_ENTER_NO_IOWAIT. If set, then
io_uring will not mark the sleeping task as being in iowait.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This is easily paired with an io_uring_set_iowait(ring, bool) on the
liburing side, which can add it to its internal flags. Might be worth
adding a FEAT flag for this too, so a caller knows if it'll be honored
or not. Can also be detected by an EINVAL return on the first
io_uring_enter(2) call with the flag set, but that's a bit more
cumbersome.

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9e5eec7490bb..f82a92c5c823 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -546,6 +546,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
 #define IORING_ENTER_ABS_TIMER		(1U << 5)
 #define IORING_ENTER_EXT_ARG_REG	(1U << 6)
+#define IORING_ENTER_NO_IOWAIT		(1U << 7)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5ff30a7092ed..6e5096837784 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2483,8 +2483,18 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
 	return READ_ONCE(iowq->hit_timeout) ? -ETIME : 0;
 }
 
+struct ext_arg {
+	size_t argsz;
+	struct timespec64 ts;
+	const sigset_t __user *sig;
+	ktime_t min_time;
+	bool ts_set;
+	bool iowait;
+};
+
 static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 				     struct io_wait_queue *iowq,
+				     struct ext_arg *ext_arg,
 				     ktime_t start_time)
 {
 	int ret = 0;
@@ -2494,7 +2504,7 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 * can take into account that the task is waiting for IO - turns out
 	 * to be important for low QD IO.
 	 */
-	if (current_pending_io())
+	if (ext_arg->iowait && current_pending_io())
 		current->in_iowait = 1;
 	if (iowq->timeout != KTIME_MAX || iowq->min_timeout)
 		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
@@ -2507,6 +2517,7 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 /* If this returns > 0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
+					  struct ext_arg *ext_arg,
 					  ktime_t start_time)
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
@@ -2520,17 +2531,9 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
 
-	return __io_cqring_wait_schedule(ctx, iowq, start_time);
+	return __io_cqring_wait_schedule(ctx, iowq, ext_arg, start_time);
 }
 
-struct ext_arg {
-	size_t argsz;
-	struct timespec64 ts;
-	const sigset_t __user *sig;
-	ktime_t min_time;
-	bool ts_set;
-};
-
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
@@ -2608,7 +2611,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 							TASK_INTERRUPTIBLE);
 		}
 
-		ret = io_cqring_wait_schedule(ctx, &iowq, start_time);
+		ret = io_cqring_wait_schedule(ctx, &iowq, ext_arg, start_time);
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 
@@ -3265,6 +3268,8 @@ static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 	const struct io_uring_getevents_arg __user *uarg = argp;
 	struct io_uring_getevents_arg arg;
 
+	ext_arg->iowait = !(flags & IORING_ENTER_NO_IOWAIT);
+
 	/*
 	 * If EXT_ARG isn't set, then we have no timespec and the argp pointer
 	 * is just a pointer to the sigset_t.
@@ -3342,7 +3347,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING |
 			       IORING_ENTER_ABS_TIMER |
-			       IORING_ENTER_EXT_ARG_REG)))
+			       IORING_ENTER_EXT_ARG_REG |
+			       IORING_ENTER_NO_IOWAIT)))
 		return -EINVAL;
 
 	/*

-- 
Jens Axboe


