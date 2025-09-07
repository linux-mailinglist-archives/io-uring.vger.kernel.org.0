Return-Path: <io-uring+bounces-9633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C95B4812A
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 01:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 426197A81FC
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 23:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246BB22333B;
	Sun,  7 Sep 2025 23:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eH2rfzYG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454E01E1E1C
	for <io-uring@vger.kernel.org>; Sun,  7 Sep 2025 23:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757286129; cv=none; b=KCnX52trayRRxRF0XudCHHgDRjUS96ZQJd66yaIAZzd0RDXQrc52I4zxg3wpajl9CBsfeQiszHzrpDViGA7Cjt42c9wtiwLThyQmmZA2XadF9N5nxIf1Or+mGCjnpJjtCHzqqnYkyhcbHDejjoszlvBpqmt7r6ZasIzApp91lQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757286129; c=relaxed/simple;
	bh=Z03TuR0ivOmNQ8EdUS4OzJG6XiG9c9x8EqogqDoVJHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqW7u17ev6qDeg/OkW+yo1JmuDadSg1+JKVU2U8YL6wrJGbBMAyVJpUtlaKg8CiDEGe53SV5m78yN9hdFHjn4M5BPjJrz3+sKVwwNRb6QOg9qqUNHn9hb7/DkDO5DNHiANEc77pkBm0PNuqoIClRyAS2vH+A71+YUREYYeV1Z30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eH2rfzYG; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-62733e779bbso1226695a12.1
        for <io-uring@vger.kernel.org>; Sun, 07 Sep 2025 16:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757286125; x=1757890925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4eBkiuBlM+05YOlcPOqIbeDVOSqi0ykfxg44IZkV9r8=;
        b=eH2rfzYGrfBhK95/DxheasqASrV4V4CkxUZGlQlapA4oq/G00+rtKJ0m5s9HxXfyJu
         cxDrKrjsQ/wv5eKYtPYXxk7un3SGHKE7ht+HgFhcjFS6FOfsF0ZMJZEZ2elVtsbDzv8G
         tUYZN5Cb3DD9YSlbejSsf5NwYPXKlZSvRCxZ/4u7NBsKUoZ6LmZQAb/UyyP0LZkzyf2W
         +PNhW4z12rePczjG7NhuyUUphj7LvppyugxT0lxyHSHRpI9qhrlNRJ6ygHrylRdDtlL1
         JtW0yGBwVEFueKS4UevPTzyJl0SWyYbmJklp1fKqxQa6BI68pnPa44pjMEodr6IbHqDv
         6PZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757286125; x=1757890925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4eBkiuBlM+05YOlcPOqIbeDVOSqi0ykfxg44IZkV9r8=;
        b=sLnrdB6z9U3hGj4+vBvNatJtTrnqGWQaj0RQLDAi2Y4q87h8X+tIHK2tgU1QMQpFf7
         XYKrRz+lKCL832z9OL8sJfdMeTCKkRGLycLX+VsL58csJLI001UefJh9o5zfcncGA+uK
         AwSIugZwaeXPnwJwEUjiG3WywFXVxMk5hB+zZchLqIsrf+JQKrnb6bGiPzuFnnCkDw5p
         h88bqU7lpNlw2pWAkUkJVxbswk5iGSkXWf5G7m8r4Guf2bG0eXPRsQTIaQCS9Q0YUPVn
         WIi1n8KWQXpEnHBYqbVs6ZXRRRgCejDbox26mQKF0K5e9NrwVjJuUmJkzfbAmO4DIQxB
         K2Ig==
X-Gm-Message-State: AOJu0Yy6+PuTSK9zF71+gOucDmWuV95YQGzoGAvqXdn5y9OIlz+QDMWC
	TUT105tSmjFfo7vy/GuY3yBpWFlqu0Brx00MB1AZDR/YKv5EDWtNPLRP159TlA==
X-Gm-Gg: ASbGncu+9gQA+BUgQbqZyRIscbLkvdByXVjNFohKr8vhZx7SPqyTQwD0gVfYhlzEkLA
	C/fGbPVzBJLJAbir6yMLgE5mGHP5/W7wsW/8qj6AeOjxKEWulG+HJk4J3SJQv9yLIJg/rIAKUEk
	+8W8DBHh4eSj4sO0ZAVtz/F5G6E8HEJZa/0EHAgcJqV09+uGXabmJaavQHlGW42Izz2RCPoj2Jd
	eY30jMSa+eqFKE7bnNfrFdwALC59D33jUqF/xJ4+RgXKNGZuwQGC8y8BM71jEfdpJmjJPfcdQj0
	Nmjg55bcTAESqMfrXz4hdBTYozmVBbRUAehrF0EGBAHaIS/npa/KSR6LC1UJA3TG2L1YRKM4arD
	V/nq7cQ4lDilAWhG8QqTmCKXqHyXLkfiw32JSrAHviOkSP9E=
X-Google-Smtp-Source: AGHT+IF9uhYEyNDc46N0hg1nA/ZSUQNXXxqU+mPiQT0I0KhLqZrbQTbcFPjxM3+x18tks2337aFyJw==
X-Received: by 2002:a05:6402:1ec4:b0:61c:c086:8092 with SMTP id 4fb4d7f45d1cf-6237ebc9380mr6124358a12.23.1757286125110;
        Sun, 07 Sep 2025 16:02:05 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.138])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-625ef80347asm3363570a12.1.2025.09.07.16.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 16:02:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 2/3] io_uring: add macros for avaliable flags
Date: Mon,  8 Sep 2025 00:02:59 +0100
Message-ID: <7296219887ecd4d6ef961345c6bf55c24d9c63fc.1757286089.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1757286089.git.asml.silence@gmail.com>
References: <cover.1757286089.git.asml.silence@gmail.com>
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
 io_uring/io_uring.c | 32 +++----------------------
 io_uring/io_uring.h | 57 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 29 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 20dfa5ef75dc..252a0021cd43 100644
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
@@ -3462,12 +3459,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
@@ -3875,15 +3867,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
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
@@ -3948,18 +3932,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
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
-			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL |
-			IORING_SETUP_CQE_MIXED))
+	if (p.flags & ~IORING_SETUP_FLAGS)
 		return -EINVAL;
-
 	return io_uring_create(entries, &p, params);
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index fa8a66b34d4e..a1d8d69411ff 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -18,6 +18,63 @@
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
+			IORING_SETUP_HYBRID_IOPOLL |\
+			IORING_SETUP_CQE_MIXED)
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


