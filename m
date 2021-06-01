Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0803975E5
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhFAPAi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 11:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbhFAPAg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 11:00:36 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19ADCC061574;
        Tue,  1 Jun 2021 07:58:54 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l2so7209597wrw.6;
        Tue, 01 Jun 2021 07:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8aZF279l5sMd1KIDSXbVbrhslN7qg7ZkVtQa3TiO424=;
        b=AdV2MBsgEc6or7WEa1Z3y/nBsF12MeU5capy2vAd/HcPavf1yLV/bEGPfoJ1r1XPEL
         Yu/LFXaewmJLrL406Jq1sGfovROJuQDAcgzTpAUPcnkoOqVwn40Zzw9kHibp+RH4H9sg
         EMsv19I5dVLT3wNXMkoAjVJCKnAN4yqtsGGMoTKHsyJhGX3A/WZu42SRS9vHKW3AMvlS
         /D7yhIvyzdIpu++CzVWWwbqfbCyLlHinUfIXsxztsUdqF3idGlzBGZMGgIrpW0P/a7b/
         zRKLE/LOHc5awDVcZCYNoRs7IvYxQAF86zO9p5z/rDXzZtTJ4eq8C9fWTbCWXNjU/n5s
         zMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8aZF279l5sMd1KIDSXbVbrhslN7qg7ZkVtQa3TiO424=;
        b=S45xDwvJ0eg4mQE0ceb82ZHqagKyt7SPvUp4NRPDAP9Q6lGogQl9A86peAjQoHG31Y
         gv3PZsN3N+q6KvIU8klFHcq13GO8l1Pd5dHLOIpjUTaen7yJqNlp2RQ5AAmpN0Y2CWHF
         L4RrScNPmFyvHpqcI//X9va+eXW8Z+91rk9ZDQAWqJpbpV31To/GbNgXjhWWDszszPEp
         vCiPRAF/S6LtsRtoWrwlE8YnEzD1kpBvmAboxoWuBMc1rU1ommMl5ArIAZWDCDECxQ4/
         xmtzKGMiAzcIY6vU5gsbbFhIWvG5elzQvFAGfXtGcx3EQrl+JuaDT/vb9NxQgxP8I1xp
         +UIw==
X-Gm-Message-State: AOAM530WDLaOOuDfWE7BKy5gUHZvbkaDT8ihyI6Zmr58nwARVV8KzGLg
        5U3EqgR/CZfAT8fVZT+XJXXbjkNcAoS6yg==
X-Google-Smtp-Source: ABdhPJxw6PPQwjzRnOnDqsKwOeIQ+0YJMihfTUoCxCA6WhwGViMcNyHDmxrzX6DVHecDZIyrnjONsA==
X-Received: by 2002:adf:f98f:: with SMTP id f15mr28901735wrr.4.1622559532358;
        Tue, 01 Jun 2021 07:58:52 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.139])
        by smtp.gmail.com with ESMTPSA id b4sm10697061wmj.42.2021.06.01.07.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 07:58:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: [RFC 2/4] io_uring: frame out futex op
Date:   Tue,  1 Jun 2021 15:58:27 +0100
Message-Id: <e0ccad0912374500dcd8df410ce684ddd10a7e96.1622558659.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622558659.git.asml.silence@gmail.com>
References: <cover.1622558659.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add userspace futex request definitions and draft some internal
functions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 23 +++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  9 +++++++++
 2 files changed, 32 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc9325472e8d..2c6b14a3a4f6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -77,6 +77,7 @@
 #include <linux/splice.h>
 #include <linux/task_work.h>
 #include <linux/pagemap.h>
+#include <linux/futex.h>
 #include <linux/io_uring.h>
 
 #define CREATE_TRACE_POINTS
@@ -665,6 +666,10 @@ struct io_unlink {
 	struct filename			*filename;
 };
 
+struct io_futex {
+	struct file			*file;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -809,6 +814,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_futex		futex;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1021,6 +1027,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_FUTEX] = {},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -5865,6 +5872,16 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return -EINVAL;
+}
+
+static int io_futex(struct io_kiocb *req, unsigned int issue_flags)
+{
+	return -EINVAL;
+}
+
 static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	switch (req->opcode) {
@@ -5936,6 +5953,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_FUTEX:
+		return io_futex_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6203,6 +6222,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, issue_flags);
 		break;
+	case IORING_OP_FUTEX:
+		ret = io_futex(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -10158,6 +10180,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(28, __u32,  statx_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  fadvise_advice);
 	BUILD_BUG_SQE_ELEM(28, __u32,  splice_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  futex_flags);
 	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e1ae46683301..6a1af5bb2ddf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -44,6 +44,7 @@ struct io_uring_sqe {
 		__u32		splice_flags;
 		__u32		rename_flags;
 		__u32		unlink_flags;
+		__u32		futex_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -137,6 +138,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_FUTEX,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -174,6 +176,13 @@ enum {
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
+enum {
+	IORING_FUTEX_WAKE_OP = 0,
+
+	IORING_FUTEX_LAST,
+};
+
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.31.1

