Return-Path: <io-uring+bounces-9388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7689AB3986D
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 11:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 328D93AE6FB
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 09:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD0A25CC64;
	Thu, 28 Aug 2025 09:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ho2JbJM0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87145283FD0
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 09:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373899; cv=none; b=Y8/FT3q++22RdNXOBVG1VlVR2x2EEiwTUC7NVqmh8vKfhG2y0s4KLfYBxkZEoKgDaBGYBhZ2NOjxxv2Mo1y8L7nmqjuTzM+Jy7oDGt4fBF2vCXfDCJGd7/TXtXteIX6EzNjRap5tSD99ofXOZbIqk4sfO+qiYyxDo2L9mCsmjcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373899; c=relaxed/simple;
	bh=3nyizzNFSJ7AyBjEgjDJhi+rotFsnTAoGXw+XeXlQ38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4cv9S3HvKZGZdAj5yUPFSy8vxWV9HsEvqG0Day1h1TvDCq11PYJmCC5fNtOhxjILAWdO0qSMs9xlKx/f2oKvkk7WVsiyVXSVrhkYcTqMmbQnnVZBvFH93qsDd3LAxba0DCMpgvVGiFeBhTR3Dil3etVojQC8fXbpOrvTYUmxpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ho2JbJM0; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45b627ea5f3so2682655e9.1
        for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 02:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756373895; x=1756978695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AA2EKWhHH3f2LYY0vC/Mtz4blywlMJQ7+nFsB01j4KQ=;
        b=Ho2JbJM0bPprbKR6pt/wupfe4AOHL+t9HsEcOsUeyeqd8znbqUW+IcAlyvLBO1NRt6
         RW6bLQObfsyOXfWt4TXfeyZFw2laeeKV3X3pJj+rOSyc5BmleVN1KT3ujjrL0fz+0oY7
         Fp7HbaEmPrXcK1e8Squ78czTH8O52IQf1oQS3emHo8jyCGvgfoU00WmOi0nFCN/bsza+
         2cj1GwdHacxi2Dc/ivV+xzvtzi30z7ig3hiu/gxChsz6gBmMSUXN/Plt+/khCQgyoUfx
         uTEq3QgDszDjDOEbnadUA7UI0zjwoEG52pEGPdszP7g6Oj7GaJ6YZyqcbmwlvylWq4x0
         CFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756373895; x=1756978695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AA2EKWhHH3f2LYY0vC/Mtz4blywlMJQ7+nFsB01j4KQ=;
        b=tHxeigK+hlLoEQFx1dZ8Mgc2yJK2SXs0EWFins3GNTQaac4sPUc5wOCM2ZJ7KuGE/l
         DvEcuhN/eQWoBWW6DtTTX8Wmp90RzvkAJRcr5L1PIynKes6h5nwPjcGHja71ZTluDNQu
         xyBM3y8wyi2rWicwS4JadxvIaEPO+eXdYmX1VHuLAJkdVMJQymR2ZNdz62au2zmaeLoY
         GOobRNigd52qpEiPxY/c5j5/M9PIsyZnIkRlTltHjIewEFSlJ2Lnd0ON1QO+YGWPG1zC
         Crqju2h6eBkhF47O4w5HnfFN5hOh+TLDlaVcPCMWYtbM+2toFGxplLiaReUfV3cztSCI
         Wi+g==
X-Gm-Message-State: AOJu0YxryNDuZtN/U0o9l8t0S/87Uz3DvXwglNgJYUzMHkj7hcgNJqzc
	CQhDuk6jP5ReiQOridA9sh4GM4n7qabVThbBA7K7VOfJ8/D25tJobEL2niC6Sg==
X-Gm-Gg: ASbGncs1BvgOXCoGLMK4jPY0q6O/Re48T0LpU0HZHDSEyAkJxiru/8acz4pKRM3Fvcg
	gFlVB/afN0jcyEfOfYV9eL8lhWyEnCEZBMIyXrlpde+PllvMHx8l7OwmRlBzAH9W/awdtdtPJny
	Ojt9sZiwe9Ew4kvoAXcfZyTvZNGfjuq5ZQFti+zpmsw1rnAw+7RNSlLPgvNA5wvcp9iu43caWq+
	wJz2C7ivQBAdzAFs13+ok1wIMELwQZMh9jNjKcnudJpC3UvJX4CFHO2aJaP8vNqo9QQcJrsunmu
	AUYO8/3k4VhGpAFZ3//W2Z1OLTvU5TTutEGeijof9ToCsA9hzluzaOuw55WXidYOvhIy3YIEI8T
	++ZiZLT2AGUeYE7j7
X-Google-Smtp-Source: AGHT+IGHOH95yZTALT0IOim71Lli+/QONU0dl5T+IKAno0AlX2drKRQUXX5hJUtjZs+WULgQQNu0Fg==
X-Received: by 2002:a05:600c:3b95:b0:456:1d93:4365 with SMTP id 5b1f17b1804b1-45b5179f29cmr184224485e9.5.1756373894938;
        Thu, 28 Aug 2025 02:38:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:68ae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b797e5499sm24331455e9.21.2025.08.28.02.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 02:38:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH v2 2/3] io_uring: add macros for avaliable flags
Date: Thu, 28 Aug 2025 10:39:27 +0100
Message-ID: <507e773a16ee8c49c6cd8a6cfa2c16eb1930111e.1756373946.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756373946.git.asml.silence@gmail.com>
References: <cover.1756373946.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add constants for supported setup / request / feature flags as well as
the feature mask. They'll be used in the next patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 31 +++----------------------
 io_uring/io_uring.h | 56 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ef69dd58734..8fcfbcb91a33 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -108,9 +108,6 @@
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
-#define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
-			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
-
 #define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
@@ -3403,12 +3400,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	struct file *file;
 	long ret;
 
-	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
-			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
-			       IORING_ENTER_REGISTERED_RING |
-			       IORING_ENTER_ABS_TIMER |
-			       IORING_ENTER_EXT_ARG_REG |
-			       IORING_ENTER_NO_IOWAIT)))
+	if (unlikely(flags & ~IORING_ENTER_FLAGS))
 		return -EINVAL;
 
 	/*
@@ -3808,15 +3800,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
-			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
-			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
-			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
-			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_MIN_TIMEOUT |
-			IORING_FEAT_RW_ATTR | IORING_FEAT_NO_IOWAIT;
+	p->features = IORING_FEAT_FLAGS;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
@@ -3876,17 +3860,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			return -EINVAL;
 	}
 
-	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
-			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
-			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
-			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
-			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
-			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL))
+	if (p.flags & ~IORING_SETUP_FLAGS)
 		return -EINVAL;
-
 	return io_uring_create(entries, &p, params);
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index abc6de227f74..0551f648e0b0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -18,6 +18,62 @@
 #include <trace/events/io_uring.h>
 #endif
 
+#define IORING_FEAT_FLAGS (IORING_FEAT_SINGLE_MMAP |\
+			IORING_FEAT_NODROP |\
+			IORING_FEAT_SUBMIT_STABLE |\
+			IORING_FEAT_RW_CUR_POS |\
+			IORING_FEAT_CUR_PERSONALITY |\
+			IORING_FEAT_FAST_POLL |\
+			IORING_FEAT_POLL_32BITS |\
+			IORING_FEAT_SQPOLL_NONFIXED |\
+			IORING_FEAT_EXT_ARG |\
+			IORING_FEAT_NATIVE_WORKERS |\
+			IORING_FEAT_RSRC_TAGS |\
+			IORING_FEAT_CQE_SKIP |\
+			IORING_FEAT_LINKED_FILE |\
+			IORING_FEAT_REG_REG_RING |\
+			IORING_FEAT_RECVSEND_BUNDLE |\
+			IORING_FEAT_MIN_TIMEOUT |\
+			IORING_FEAT_RW_ATTR |\
+			IORING_FEAT_NO_IOWAIT)
+
+#define IORING_SETUP_FLAGS (IORING_SETUP_IOPOLL |\
+			IORING_SETUP_SQPOLL |\
+			IORING_SETUP_SQ_AFF |\
+			IORING_SETUP_CQSIZE |\
+			IORING_SETUP_CLAMP |\
+			IORING_SETUP_ATTACH_WQ |\
+			IORING_SETUP_R_DISABLED |\
+			IORING_SETUP_SUBMIT_ALL |\
+			IORING_SETUP_COOP_TASKRUN |\
+			IORING_SETUP_TASKRUN_FLAG |\
+			IORING_SETUP_SQE128 |\
+			IORING_SETUP_CQE32 |\
+			IORING_SETUP_SINGLE_ISSUER |\
+			IORING_SETUP_DEFER_TASKRUN |\
+			IORING_SETUP_NO_MMAP |\
+			IORING_SETUP_REGISTERED_FD_ONLY |\
+			IORING_SETUP_NO_SQARRAY |\
+			IORING_SETUP_HYBRID_IOPOLL)
+
+#define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
+			IORING_ENTER_SQ_WAKEUP |\
+			IORING_ENTER_SQ_WAIT |\
+			IORING_ENTER_EXT_ARG |\
+			IORING_ENTER_REGISTERED_RING |\
+			IORING_ENTER_ABS_TIMER |\
+			IORING_ENTER_EXT_ARG_REG |\
+			IORING_ENTER_NO_IOWAIT)
+
+
+#define SQE_VALID_FLAGS (IOSQE_FIXED_FILE |\
+			IOSQE_IO_DRAIN |\
+			IOSQE_IO_LINK |\
+			IOSQE_IO_HARDLINK |\
+			IOSQE_ASYNC |\
+			IOSQE_BUFFER_SELECT |\
+			IOSQE_CQE_SKIP_SUCCESS)
+
 enum {
 	IOU_COMPLETE		= 0,
 
-- 
2.49.0


