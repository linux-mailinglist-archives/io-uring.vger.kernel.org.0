Return-Path: <io-uring+bounces-7079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D24A619C8
	for <lists+io-uring@lfdr.de>; Fri, 14 Mar 2025 19:48:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 419487AC715
	for <lists+io-uring@lfdr.de>; Fri, 14 Mar 2025 18:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8AD20298B;
	Fri, 14 Mar 2025 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Hneh3Tvq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F8D1FF601
	for <io-uring@vger.kernel.org>; Fri, 14 Mar 2025 18:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741978116; cv=none; b=HV8D0AZXlF3YHDBnNhtlC7hJQRGJAe//iUJoOpZPr02MaWLx93fRX57o9cc4RmXgfECnPdNt4Rap1XcYAnVHnuPrAv8geVk/+uyl2Rh/feyAsvQp/rEkwswy705ATfrcH43r5VB1inxbKRzFk8aFP2cyyJxF5sYEBWREyvUZWdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741978116; c=relaxed/simple;
	bh=JFuYymYTde4ciH29gcWdK6E6xvNSx4yc91kW+PQiN/o=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=h03msfcCyB30QcFB5TC8Afr2+LEcEJU4g+ddbt+icrYPPDZhUNJ7t/CCt4ub5Eu2b93q7hkFuJvzW/iBMIJcU0zCIDV+op54tFxGaVBV094lQzZLx9aTLACEXlHyB6bviTYUiUhMvD0A6jbYcL/bypVTp8A34i5TYm5RY58hOME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Hneh3Tvq; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-85ae131983eso204911439f.0
        for <io-uring@vger.kernel.org>; Fri, 14 Mar 2025 11:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741978110; x=1742582910; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0hGhW52eaO35ipyJ2IKgJVAOTDeKijSpWtBy5Nzofk=;
        b=Hneh3TvquEQ37jgcqAuJdvpp2lHrD9SED6eP5QiLabKIbbT9VLiLVkAw/TiLPbWe/f
         4dEssspePt9A9zNpkTyJRZSufJPGAzXixhxHSD2QBbo1XpwBpC4H9Mtys/J1rG0EwMFo
         0yhPBLfl/tFZ9gxI1+ZVTnKlqYp0Xgw5kj96+L+bZVzBiZ9RdAnpV+kCNLwFzXUC0YWk
         3yhUZAbfrQCD2s7RZQAMDJNoYv2HEf6L4pnjqlcc74Y014bhWEkxOrytp+ov/qVeRei+
         xq804N+PEr41WwrPOWvB629pcJSPyDVMrWDEZVxE+agnphITG+hXELU802D6b2aV7Tr9
         YtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741978110; x=1742582910;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/0hGhW52eaO35ipyJ2IKgJVAOTDeKijSpWtBy5Nzofk=;
        b=JVLmudaiSWLCxLwuxS14kTSjyWQsc7jkxMJnlFXG4ulZoS7fwk2DTywqousnutwJMK
         Yrs8BIl3rEiYAr9uEw2Oa81HQEkhdmyBETCUFCTUvgrxuQU4m1Bs5mbudQAw73wQSqZM
         SxP4f+yFKJbchdm/LeKlbpspUdrfSnsiqELabbB4orLXH24pDBIdecIWTiyLkr2fjAiR
         X3apaRL3De4kj86YwWXv+QVnltx0ij8oGyMdXxuoEHRBZCIR9DgT5PSWCYIxvVLZ+uVa
         b3meEkGmA9IVTmKrXu2h5Abrk74VJ8YJx6L3K+F/j5mnz9GVxyZsUOSJDeiCmCq6cUdz
         PpMg==
X-Gm-Message-State: AOJu0YxJJc7PIjJZyRU229VFhIsoSriYEMqlQX7sUo7iSKUl+QJBRCvZ
	8+jYIemO9jbKF5BecNySxpMFZ1GnolXOLkWbFPRKPWg/qo4GCZB3Enl9ftnHEN/qqOUBqbotmd1
	D
X-Gm-Gg: ASbGncv8TY8bu9FT5ura6Y9fBIgTm6B0y3NA8+GbMiXlulZEeV6KTkN1hk8Rfvj+uFK
	qw4S5jziGe2zgBdrf7xmJgnWPAjszWD+DX3rxatO7xly0x6CyUPhUKBFo0w8ehoOUGKCWZMNdCw
	87pMy/HfLai1KYo1S3i4Ps5QivAjjlfDRYd/tGqofKmSLwuHTS8AL4UU956jFCkwzng9AMRrzUI
	uTfRldoWbPxCeo0SZ8XTaGCZhur1jDRjkqZAeO0tfzvj1QPzTrb4Ev4Uqnv/tIQhy0EJVYTPYdc
	CCwITtxzvqIsuK2Gl+E2KUEck0wtf/561b9qoLXZVw==
X-Google-Smtp-Source: AGHT+IELDBjjP6ws1knS+cf93x+ahIWeqFJMrrv00v+bDrW2Q9O2DTUnDlq7H6mVVsMEW04vBH05+Q==
X-Received: by 2002:a05:6602:36c6:b0:85b:40c7:ce54 with SMTP id ca18e2360f4ac-85dc4b26ac5mr446699539f.14.1741978109608;
        Fri, 14 Mar 2025 11:48:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85db87789d4sm79407939f.17.2025.03.14.11.48.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 11:48:28 -0700 (PDT)
Message-ID: <f548f142-d6f3-46d8-9c58-6cf595c968fb@kernel.dk>
Date: Fri, 14 Mar 2025 12:48:28 -0600
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
Subject: [PATCH v2] io_uring: enable toggle of iowait usage when waiting on
 CQEs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

By default, io_uring marks a waiting task as being in iowait, if it's
sleeping waiting on events and there are pending requests. This isn't
necessarily always useful, and may be confusing on non-storage setups
where iowait isn't expected. It can also cause extra power usage, by
preventing the CPU from entering lower sleep states.

This adds a new enter flag, IORING_ENTER_NO_IOWAIT. If set, then
io_uring will not mark the sleeping task as being in iowait. If the
kernel support this feature, then it will be marked by having the
IORING_FEAT_NO_IOWAIT feature flag set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Basic liburing support and a test case here:

https://git.kernel.dk/cgit/liburing/log/?h=iowait

Since v1:
- Add IORING_ENTER_NO_IOWAIT feature flag

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 050fa8eb2e8f..0d6c83c8d1cf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -541,6 +541,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
 #define IORING_ENTER_ABS_TIMER		(1U << 5)
 #define IORING_ENTER_EXT_ARG_REG	(1U << 6)
+#define IORING_ENTER_NO_IOWAIT		(1U << 7)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -578,6 +579,7 @@ struct io_uring_params {
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
 #define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
 #define IORING_FEAT_RW_ATTR		(1U << 16)
+#define IORING_FEAT_NO_IOWAIT		(1U << 17)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 58003fa6b327..d975e68e91f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2485,8 +2485,18 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
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
@@ -2496,7 +2506,7 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 * can take into account that the task is waiting for IO - turns out
 	 * to be important for low QD IO.
 	 */
-	if (current_pending_io())
+	if (ext_arg->iowait && current_pending_io())
 		current->in_iowait = 1;
 	if (iowq->timeout != KTIME_MAX || iowq->min_timeout)
 		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
@@ -2509,6 +2519,7 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 /* If this returns > 0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
+					  struct ext_arg *ext_arg,
 					  ktime_t start_time)
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
@@ -2522,17 +2533,9 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
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
@@ -2610,7 +2613,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 							TASK_INTERRUPTIBLE);
 		}
 
-		ret = io_cqring_wait_schedule(ctx, &iowq, start_time);
+		ret = io_cqring_wait_schedule(ctx, &iowq, ext_arg, start_time);
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 
@@ -3261,6 +3264,8 @@ static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 	const struct io_uring_getevents_arg __user *uarg = argp;
 	struct io_uring_getevents_arg arg;
 
+	ext_arg->iowait = !(flags & IORING_ENTER_NO_IOWAIT);
+
 	/*
 	 * If EXT_ARG isn't set, then we have no timespec and the argp pointer
 	 * is just a pointer to the sigset_t.
@@ -3338,7 +3343,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING |
 			       IORING_ENTER_ABS_TIMER |
-			       IORING_ENTER_EXT_ARG_REG)))
+			       IORING_ENTER_EXT_ARG_REG |
+			       IORING_ENTER_NO_IOWAIT)))
 		return -EINVAL;
 
 	/*
@@ -3752,7 +3758,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
 			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT |
-			IORING_FEAT_RW_ATTR;
+			IORING_FEAT_RW_ATTR | IORING_FEAT_NO_IOWAIT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
-- 
Jens Axboe


