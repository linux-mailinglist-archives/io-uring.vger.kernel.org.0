Return-Path: <io-uring+bounces-610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3F8856940
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 17:15:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB2201F238C2
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 16:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B2413957C;
	Thu, 15 Feb 2024 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HEPOxFkj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF76213A25F
	for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708013414; cv=none; b=nNsYvzXWHVlfZSK4utyZIAMQQLGwrl2Xkyk1HOcjlI5QhOK+r2R6cHSMvDJhv+19yMx/3q1yJCIbU3YX4lxKSEpmwAViWWJbw3JMlZ4Gor3pQSF+NtZErrokkQe0a1k4blw/S5HIfGcXfZAaaA/a0ZltHofWt1EDNi7bqUIVJ90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708013414; c=relaxed/simple;
	bh=+01ggezWDlBXaMZzUYyNL+qL7BUdm/4u6nKXttGq8+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3hDT257/MorZG4fWNzecD5rsIsVdm7dDTvKdzz7fVPzpL7LUdEHvujtIM/4lt34O3kdGl+EWOdfoU5j4jSkYn4DLYHIeDnA4A5o4BXT9ISgecHI6kbAVDw3GT7OnJn9cW3tceo1JhA9AuD9mC3oAHpHy22MApk4NsrGtioTYXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HEPOxFkj; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-35d374bebe3so1535565ab.1
        for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 08:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708013410; x=1708618210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ktOLqvWoXFqusXcGOV12iqejJlkHbShshkXyRrkD7I=;
        b=HEPOxFkjIl1NVaronn9hJDlY1pmPb5ugOy5uDemE5ML9aOFzKfKiZYvRAu9e26be3W
         tHGpF+0o+cRAo881nSbQ0uoILrlEdkSkwFGo59QIfoLvrOtN8L07dfOc1QUmnA89Kg+H
         5cKEbWh/ULKvupS7StMFlMaT+3QRV+pZ/QfZlmoOq27m5lQ93IyQea3f15GZJ9gXNytE
         4LxzqEzjOLwUBtNpZQseJ7jCf2L1GTqrK4z8MY5F/MFIVi0LVwjBUNTV5B1cbTIEns/a
         mSrYqSRDl5XQ7evbCY7JBedYQxp6wLWZK+IoIuwyEq+4aEifdgEVlpGQnXc+OQYg+Crd
         opXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708013410; x=1708618210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ktOLqvWoXFqusXcGOV12iqejJlkHbShshkXyRrkD7I=;
        b=Atdgza9t2cybHZN4DU4DoeTeqw97q57DzhLOJecm3VvpMFYtwPrMnntXRKzin0oCPY
         xn7G0HXOJSnSGlPXueHyA9GBoIr/2ZMmnfm/Q3Y2NPbmz6D9JUn8yN6Pl4TFPtH+8NSR
         MC5uU1OkVtN6tMxYt40U++L210CitJs6t0Ju50EO4lZ+FMRJGWGrFr7azOXn05D2xm/Z
         FJGhjNPqRhfz0VAdStmKuVNO+rxWkCSJDKzv6zXCQZeBe9PNQhVL/aNnYipTXI/JAUsB
         vSu//09PARfiMdDHvxfdzZ5v68ldsl+d1hgdqLaYnzot1vyKM+kEh5EIHAXagDUGULVU
         OSzw==
X-Gm-Message-State: AOJu0YyGsyuq54sgI/9OUHzgYnBpEPdjcdsnr33smC6x3XWdFeM24yGH
	hhIgXP+WjvfzCqa/d5KZXe7CWlv1f32j+qF2wpAK/7v376imyQMafE1rTCmKjkPo3vx1L/TukBa
	u
X-Google-Smtp-Source: AGHT+IHsDy/2kOKfUoYJaZ7ZpxFoBJ58qi3Xt5H1Eo7RshjEM7KPtdx2WyZ8VeBI841MuixFZZt1JQ==
X-Received: by 2002:a92:c24b:0:b0:363:c919:eee3 with SMTP id k11-20020a92c24b000000b00363c919eee3mr2240616ilo.0.1708013410519;
        Thu, 15 Feb 2024 08:10:10 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x4-20020a056e02074400b0036275404ab3sm458524ils.85.2024.02.15.08.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 08:10:09 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: wire up min batch wake timeout
Date: Thu, 15 Feb 2024 09:06:59 -0700
Message-ID: <20240215161002.3044270-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215161002.3044270-1-axboe@kernel.dk>
References: <20240215161002.3044270-1-axboe@kernel.dk>
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
index e72261f280a7..8dd5eb647b43 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2647,7 +2647,8 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
  */
 static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			  const sigset_t __user *sig, size_t sigsz,
-			  struct __kernel_timespec __user *uts)
+			  struct __kernel_timespec __user *uts,
+			  ktime_t min_time)
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
@@ -2684,7 +2685,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
-	iowq.min_timeout = KTIME_MAX;
+	iowq.min_timeout = min_time;
 	iowq.timeout = KTIME_MAX;
 	start_time = ktime_get_ns();
 
@@ -3634,10 +3635,12 @@ static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t a
 
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
@@ -3656,8 +3659,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
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
@@ -3769,13 +3772,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
 
@@ -4058,7 +4062,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
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


