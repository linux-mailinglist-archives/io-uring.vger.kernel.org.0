Return-Path: <io-uring+bounces-2872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33846959F91
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 16:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E45EC28354F
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 14:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DA81B1D58;
	Wed, 21 Aug 2024 14:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hmhNfnxK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9CF1B1D67
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724249961; cv=none; b=ngbhmYii3EEy88lyBwhEo9+jmekiTFFDOyebRPXVeodqc5y/75CnHxwmt7MCNGZHbKlDWt7qYNzX38UR102Mpzns0gieawtCYN6lUKrunZpFua09uj8pot5HjoqJB4iwi8x8kip213EtVn1Czmm5mL5hC0dN+rGUO/m241M07jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724249961; c=relaxed/simple;
	bh=qTu2sq7yn2EcrdeyktCwvGZiekwXDzf7KiZE3ztBGg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPu6ayUs0TAyH0wFsDFJ2EtLGIgb6MYmlyhNC3dQfaMveEJxeVzciEVWXQxGPHz/gFERb/3wpoTRg8W0LMErVRQ63PF+zhLfD2erdWeQBAe2O6dra9utMyzwR858cmpKRtIgZ+njLDqZRZjMrXjx1X8WPz9AY+MyogsDsWTb+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hmhNfnxK; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-39d34be8ca2so14960635ab.3
        for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 07:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724249958; x=1724854758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JTP5Qj5lqGHnxMoth1w7TFkhoBRC9gXIAWqqk84GW5Q=;
        b=hmhNfnxKOLlu3I+oieYh2jSVbZ1T7Hl+OGbnA2tHz8XEuGSxVnGDocBkMkkUhT/l8t
         qT48bwCs0PLtX6ImqEaYKtBK0UlXWxelk6Z5AFcBmYt9dsUBzMvT3eu7ClSpwKnn6fnt
         oxQ5Lk8MzLQc475IfcPNkJtTUk5yANYbhi5KTfp1C3KeJXj82Mi0L+wfhMm2QHg+0oY5
         Jp3eN5iqJ81+nmUID84pCXo3qSqsJcur99eWFcFMu8ny80xVYQuEurVaOOvLHhBX6J/x
         kFSSX/XhTBxTcDi6J38AtjAZOML09rTDWUIadJlaAnfrlTGBsbBXzsFpMQOJAcK7bdLK
         oNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724249958; x=1724854758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JTP5Qj5lqGHnxMoth1w7TFkhoBRC9gXIAWqqk84GW5Q=;
        b=kycDlLKvsMGJRIFi2VNnZBbBbtk+pQFA5rrC/Kiso6FY2AZP2E60YXp2wFvDQ25nw5
         Q3OfsTQDzMPjWO7LeAW6We7EIs1/60b3/9IPIMWexZW8T8FsqvqSry/Dtp9UteteZ8/x
         0b5+U2pxbtvbt/o3BxRS7j/e8h5HVjrN76uWqDxmpoEOUqJdkdxH4oANHMqMn9Gqj+Cv
         jbEAMtdx7t1eWxMnjd9WWOZY+OQK3Jg9P/UVfF41uvPw7JB3h0YIzC72zAXHK3KgK9n6
         Pce6VmZ5RBfa6dVtC4hcDg9QGWNlQ9dmxn2VXhM/JAaXaxvbN2wMUREz//NkCkQARE9K
         o7EA==
X-Gm-Message-State: AOJu0YwsEp7OOCC4XTaS/0AhEsHIoHptxyGEoghV0Gn8LI2Mm7NQSsf7
	NReRcjZHwFOpozorl/+NISPZSBS2gX/RAShpaqwJrsVSqj35qJFuFRhmI05OLbjNUYxtdhc6Lwx
	2
X-Google-Smtp-Source: AGHT+IFlNCYpa4qWoXTqcPfpbKq3KeJsd/W+NaC9UdXaucz99r31imD6l4EfeZ1yT4Y8KrZVnlKDgQ==
X-Received: by 2002:a05:6e02:1384:b0:376:3e9c:d9a8 with SMTP id e9e14a558f8ab-39d6c35a178mr27463935ab.9.1724249958133;
        Wed, 21 Aug 2024 07:19:18 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d1eb0bc93sm50967285ab.19.2024.08.21.07.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:19:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: wire up min batch wake timeout
Date: Wed, 21 Aug 2024 08:16:26 -0600
Message-ID: <20240821141910.204660-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240821141910.204660-1-axboe@kernel.dk>
References: <20240821141910.204660-1-axboe@kernel.dk>
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
 include/uapi/linux/io_uring.h | 3 ++-
 io_uring/io_uring.c           | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7af716136df9..042eab793e26 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -543,6 +543,7 @@ struct io_uring_params {
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
+#define IORING_FEAT_MIN_TIMEOUT		(1U << 15)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -766,7 +767,7 @@ enum io_uring_register_restriction_op {
 struct io_uring_getevents_arg {
 	__u64	sigmask;
 	__u32	sigmask_sz;
-	__u32	pad;
+	__u32	min_wait_usec;
 	__u64	ts;
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 87e7cf6551d7..03b226689e20 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2476,6 +2476,7 @@ struct ext_arg {
 	size_t argsz;
 	struct __kernel_timespec __user *ts;
 	const sigset_t __user *sig;
+	ktime_t min_time;
 };
 
 /*
@@ -2508,7 +2509,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
-	iowq.min_timeout = 0;
+	iowq.min_timeout = ext_arg->min_time;
 	iowq.timeout = KTIME_MAX;
 	start_time = io_get_time(ctx);
 
@@ -3234,8 +3235,7 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
 		return -EFAULT;
-	if (arg.pad)
-		return -EINVAL;
+	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
 	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
 	ext_arg->argsz = arg.sigmask_sz;
 	ext_arg->ts = u64_to_user_ptr(arg.ts);
@@ -3636,7 +3636,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE;
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
-- 
2.43.0


