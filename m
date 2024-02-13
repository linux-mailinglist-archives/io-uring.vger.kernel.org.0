Return-Path: <io-uring+bounces-601-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CAA1853AA0
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 20:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1149B22B45
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 19:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785816087F;
	Tue, 13 Feb 2024 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lme36W6c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C7E605DD
	for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 19:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707851644; cv=none; b=suG3taBM3DZX+xTwwF17quk06KDnT6WFUjDu7xwpiOyw1LBoyRkiO1JPSMhj6LxHGO2qQY097Mx7uxbnEISAZEsmCGmTzOlc9kfUiVuNeusgSNmLHa2/sq1uAtxwf+wVdSuvffLywt9zZ532itht6svPXU16NZQb12ozpJDFnHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707851644; c=relaxed/simple;
	bh=2ReQMfCL1Aw49zDjNNTZo96Hd8ZLY0K30Zd3Ic32Nxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiybE8MNjLAwT5KIMbURBNBPKmQs26pR/OQ7Mxe89VliOeR6DFg9+OaCkR/cBoQhU9KUp9pj1PldfbfIkJKk8uo+luCNdp7ECRkMXqou4pD8mGBiCgd1FnX89/w26OoDj5hhZrVIcNG1MV5NeR22foTDR1t1cA0aloP5h1+ihag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lme36W6c; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-363acc3bbd8so4594705ab.1
        for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 11:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707851641; x=1708456441; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ks4ahqB4+W/rvQqJQjSRmZs4we6KjbHbNkJ+sqJKp/w=;
        b=lme36W6cil/BI5cu1bT668BuEs6cSCrlo1top3O41Xkr3Ip5O/9BHIlG9N9gW55lhj
         eGVeBMHcM11QBtY3iJscx+frwmFEm+VXVZy5hGjqRoThKLvH8q8iKVZ+W0QAMh9zQFAe
         /kFyF7QYtMqmteGieWDNJTxOp5d88xbrO2leXnnijRkEnQroX+tgz8P8t1BWc7XmRhAw
         4azxOVujg7FNmKl7EHwSao3wMDjb6F4K2KhPg3oNb9RyH9i473zsHSCYM5fIQsjtmO8f
         XzD4auUXtQHy4mxkjI6vXIpXH9cQGtVJKPNd2YJsS4gIQLMicTocwv28aEDqym4iqSzo
         NGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707851641; x=1708456441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ks4ahqB4+W/rvQqJQjSRmZs4we6KjbHbNkJ+sqJKp/w=;
        b=wx46zD6gSB+u8xG4hyHjoLulzBM+IBtpkWC2LbqiyDNM1qbKCtAFrOmbEj+exw42O4
         I83MbjPc/Lo30DlC6n+57vHOUYB5uCSJA8A6QjyaAxLy5UbdPf/g49GvdHGhl6XuOS4O
         tYts/Y1BK8ypoK5VobqreEd7i47sEqLZ9pCFSYxqrlMz/JTTknrQw6x/dqen0O2tTavQ
         iIzcpoQR75exJ3/V5hEqj4xg7EV9PZAorgR4QEKMS65A7265HvG0BbtvbjADslSkrUfw
         zuuaKYsDHg54bBRiHafYyf/fmsVi/Oj9P71Ip5YBK2l6usUKm2lzeR3sTHGg6j3/9pmD
         ygFA==
X-Gm-Message-State: AOJu0Yy5LK6Y8iwgwAE95Ff1vr5MC6joVZdINGnLU2isDnN2n8PGV+Xm
	GmQEeErFjhD9zlDP2MZl1QFJcqUfiijDteMkT3z07eSiAjplWrb0Lto5CCpX5G6p0tYiDunVyDz
	t
X-Google-Smtp-Source: AGHT+IHX8E4qE6pojKTOyl51AsCJ3JHpdeOEvyDDKg1efAbAoOMozcW/kCZBiYpW3Djd9sFhK8XDWg==
X-Received: by 2002:a6b:d810:0:b0:7c4:8059:7715 with SMTP id y16-20020a6bd810000000b007c480597715mr456196iob.1.1707851641274;
        Tue, 13 Feb 2024 11:14:01 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cz17-20020a0566384a1100b004713ef05d60sm2032176jab.96.2024.02.13.11.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 11:13:59 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: wire up min batch wake timeout
Date: Tue, 13 Feb 2024 12:03:41 -0700
Message-ID: <20240213191352.2452160-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240213191352.2452160-1-axboe@kernel.dk>
References: <20240213191352.2452160-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose min_wait_usec in io_uring_getevents_arg, replacing the pad member
that is currently in there. The value is in usecs, which is explained in
the name as well.

Note that if min_wait_usec and a normal timeout is used in conjunction,
the normal timeout is still relative to the base time. For example, if
min_wait_usec is set to 100 and the normal timeout is 1000, the max
total time waited is still 1000. This also means that if the normal
timeout is shorter than min_wait_usec, then only the min_wait_usec will
take effect.

See previous commit for an explanation of how this works.

IORING_FEAT_MIN_TIMEOUT is added as a feature flag for this, as
applications doing submit_and_wait_timeout() style operations will
generally not see the -EINVAL from the wait side as they return the
number of IOs submitted. Only if no IOs are submitted will the -EINVAL
bubble back up to the application.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  3 ++-
 io_uring/io_uring.c           | 21 +++++++++++++--------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..dbefda14d087 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -522,6 +522,7 @@ struct io_uring_params {
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
+#define IORING_FEAT_MIN_TIMEOUT		(1U << 14)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -738,7 +739,7 @@ enum {
 struct io_uring_getevents_arg {
 	__u64	sigmask;
 	__u32	sigmask_sz;
-	__u32	pad;
+	__u32	min_wait_usec;
 	__u64	ts;
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 34f7884be932..2f9aaa3d8273 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2653,7 +2653,8 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
  */
 static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			  const sigset_t __user *sig, size_t sigsz,
-			  struct __kernel_timespec __user *uts)
+			  struct __kernel_timespec __user *uts,
+			  ktime_t min_time)
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
@@ -2690,7 +2691,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
-	iowq.min_timeout = KTIME_MAX;
+	iowq.min_timeout = min_time;
 	iowq.timeout = KTIME_MAX;
 	start_time = ktime_get_ns();
 
@@ -3640,10 +3641,12 @@ static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t a
 
 static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
 			  struct __kernel_timespec __user **ts,
-			  const sigset_t __user **sig)
+			  const sigset_t __user **sig, ktime_t *min_time)
 {
 	struct io_uring_getevents_arg arg;
 
+	*min_time = KTIME_MAX;
+
 	/*
 	 * If EXT_ARG isn't set, then we have no timespec and the argp pointer
 	 * is just a pointer to the sigset_t.
@@ -3662,8 +3665,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
 		return -EFAULT;
-	if (arg.pad)
-		return -EINVAL;
+	if (arg.min_wait_usec)
+		*min_time = arg.min_wait_usec * NSEC_PER_USEC;
 	*sig = u64_to_user_ptr(arg.sigmask);
 	*argsz = arg.sigmask_sz;
 	*ts = u64_to_user_ptr(arg.ts);
@@ -3775,13 +3778,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		} else {
 			const sigset_t __user *sig;
 			struct __kernel_timespec __user *ts;
+			ktime_t min_time;
 
-			ret2 = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
+			ret2 = io_get_ext_arg(flags, argp, &argsz, &ts, &sig, &min_time);
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
 				ret2 = io_cqring_wait(ctx, min_complete, sig,
-						      argsz, ts);
+						      argsz, ts, min_time);
 			}
 		}
 
@@ -4064,7 +4068,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING;
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
+			IORING_FEAT_MIN_TIMEOUT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
-- 
2.43.0


