Return-Path: <io-uring+bounces-2840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2B89578A9
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 01:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F1B21C2338D
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 23:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80981DF666;
	Mon, 19 Aug 2024 23:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RbCoAz8s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A815C613
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 23:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724110256; cv=none; b=W8qH5+Y6PIf3vmKp31mA9iRmXXlKe0ugBLUsft5C+vZ/pI+XkHC74RseR8lR6IUCmkdM3vc6/ylTxeJ0ZH1Y2szV4dBPCV1+ZcxOzq6W8WTx6NC5VdcYHnMbccGMo800rJIa4N7cXPJxwr5oILH/GgRYfe/7HVeyMEwmRx+h3xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724110256; c=relaxed/simple;
	bh=1AMvaUwiKqJEPa0Ol9keO8S69ng/qRx7RpmzDx/vtNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hqtez4DjcgL9NNSskiw4exHAdRwW0D+ykBkhOOtV3hgMo8NVe/Ovk2m+TgfkhxvFzXOPOqkTgLQTd2A84njmWE8WQgeo4aXSEmMe8yXURMiZye0zAauXg8Bw/AQU+fcLen04w5mYDLC82/GAVsmEKd6T4Qdmwf8x+y0B8ZE7JUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RbCoAz8s; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2d3d382de43so837083a91.0
        for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 16:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724110253; x=1724715053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvatlSeRar1mDUQg4xOKTeFuqZnG3ELf9pznvltnYEg=;
        b=RbCoAz8sTboDsi8aaD6p5/EMybVG8em6QqOLey2H4MmJhuv5WETbzpPvU2wyqXNxtu
         xzOI9jYnGqabzFx+qqkWh43KqGvLtPo+bMRrv+Jq6bi4o7fT/xfzpEe3XglJkxsziIQi
         N4pfSXTJ+E9gUgDGYgE3rT/PyZ7xzZ/9UOpI3AWWbyvppe24oe+w2i3WcPh5oL6GwJ59
         B1ezeMkltBmiWL/qSck6dV+mdJkcSS0qjxYaAF+n7nWT+p88Sm6gYDwR1v/Keh6PJtHZ
         qGhYozyxlEVY/HVOw+6LH2TAqi8ckfdL5yvF8wZpAdy8Cj1fSA3plIRHL7PoC9whvOaJ
         lbmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724110253; x=1724715053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvatlSeRar1mDUQg4xOKTeFuqZnG3ELf9pznvltnYEg=;
        b=q8SUcdk9KvIBLeezvwulYPki0nheKSAbRdit6yIjnGJnuIDb7ipqHEpL8W3cGUJ+E0
         4ZrI50Tx0pVUTm0UWRP60v1tcpjos5dvpcEOrHW6Hakam1DQIIte1DsVsoIFoKE90JrB
         aLmz85pa+b/+fHXaZWMkELoCMLyefDEP+3ostyJMnNt8KLMPloEptnWcm8RmkAR+YFB3
         LtHZo04JONGpliG6dFqjX8DI0Oc6nbRQTq08OLhaNowCRRIyQYT9LQMHFp/pOd1+9WjE
         G9vlDI/F69aCvuaaQ82C424riMAJdyhbFlth/uLpgd82ldTS+BwuXSe+uw5i8W/KKjHh
         cFIA==
X-Gm-Message-State: AOJu0YwtLSZ3CfNd98MsJxAwivQ85ZaHejh7xxeptlPd1WZzJFZJ2FsH
	qRr6v1SoXbl4lishyfM+KxyTBnVQb7fhG8r/kaTP5+GBX3gPBZrK5LEBkXcg6Iag/CdMRGOImKt
	O
X-Google-Smtp-Source: AGHT+IERNCchdBEtWEoWu4cf299u8sCDIiHath6hnhxsAjy5cjv6QKZyAQQnwr83RqUSAsL0XXFLRQ==
X-Received: by 2002:a05:6a21:3381:b0:1c4:d312:64d8 with SMTP id adf61e73a8af0-1c904f81da7mr8024689637.3.1724110253454;
        Mon, 19 Aug 2024 16:30:53 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61dc929sm8219838a12.40.2024.08.19.16.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 16:30:52 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: wire up min batch wake timeout
Date: Mon, 19 Aug 2024 17:28:53 -0600
Message-ID: <20240819233042.230956-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240819233042.230956-1-axboe@kernel.dk>
References: <20240819233042.230956-1-axboe@kernel.dk>
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
index d09a7c2e1096..20b67fea645d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2475,6 +2475,7 @@ struct ext_arg {
 	size_t argsz;
 	struct __kernel_timespec __user *ts;
 	const sigset_t __user *sig;
+	ktime_t min_time;
 };
 
 /*
@@ -2507,7 +2508,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
-	iowq.min_timeout = 0;
+	iowq.min_timeout = ext_arg->min_time;
 	iowq.timeout = KTIME_MAX;
 	start_time = io_get_time(ctx);
 
@@ -3231,8 +3232,7 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
 		return -EFAULT;
-	if (arg.pad)
-		return -EINVAL;
+	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
 	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
 	ext_arg->argsz = arg.sigmask_sz;
 	ext_arg->ts = u64_to_user_ptr(arg.ts);
@@ -3633,7 +3633,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE;
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
-- 
2.43.0


