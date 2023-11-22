Return-Path: <io-uring+bounces-138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 368AD7F4BD8
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 17:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A0811C209FF
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 16:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA485786C;
	Wed, 22 Nov 2023 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktaoQ/Ou"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EB31BF;
	Wed, 22 Nov 2023 08:02:50 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-a00b01955acso410310066b.1;
        Wed, 22 Nov 2023 08:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700668968; x=1701273768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YiiLGrpZSDIC4Qc1OGZlXR+FMZWiJkQTWTZS1aN/KEA=;
        b=ktaoQ/OuKb7W/v9ZY8ffw8Ns2sJbglUnzqGnCtkscifLEe7UIQ0uP/YWcj4QrPmxfF
         VMOt/3WBi2WfKJcOTfC6EHpcVFZnRHWVFR1uC/zX6LFWfDr1JNLZdcqsJrro2I5ZlVkl
         76s2jtNAwcr5F0pPCuf9My10yqAY8C75ttS4J4N6jU4bBNQunrXLsvVOXAAPKXbLBsf2
         qsWZZ7hXI+2q2HPVpFICY+SrW86in3ALxM8Ci9iqKdJ+oI7NwcQ5ntXjbzABEGsnbxlF
         5+jVHQCDIuTf7pwfpSwmRVkYxBGZYBJQlR7lysif5DU67oZ55cK/8TC13jA/EqZwIAzy
         UHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700668968; x=1701273768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YiiLGrpZSDIC4Qc1OGZlXR+FMZWiJkQTWTZS1aN/KEA=;
        b=D88TwKv+Kc8RonWBwCLCl98lkyLT/QaJIB/87kn7bWUkGY49JBQdsCv/OkZlLq/G+b
         B+yA6jfKTIoHcjge/mWYnJxJ1ur9+5oydw8Or7mSX6ENpWwhurOK9mTuWVEFi33TFKrR
         8qUqPKsvwDhpAgaJuAiT6rXH8W/Se+Z7xWQYPNP686r8f8UgoBDdX3TQQFPvScAI+qiI
         6QwEKnkKusLM8QYmHJB3yY5CwJxKV1Fi7IsflhdEfPbxjVhRoppS19rwMqtAO9BXm2Ry
         kKEWNQ7Ot9sV19mIb6EQNHgK5KRtFjbPhTsxlD+Ts1cGuTFPHuDtwND8zHGNmv5LUIjb
         3kKg==
X-Gm-Message-State: AOJu0YwvelUrvyryjtDxFZ+2fCpcCx3NdkH2uppLLACg2WR1iizQxQZ3
	GvBYNiy1+XZq/rijOg3twLoHa9Ys+AY=
X-Google-Smtp-Source: AGHT+IGFH0tW3t94HXFAM07g1SB+FjrzNCWiCzSDz1uOZHDp0U0s9sHudsY7p7+bVKYZydXprueerA==
X-Received: by 2002:a17:907:cbc9:b0:a00:1c9a:a472 with SMTP id vk9-20020a170907cbc900b00a001c9aa472mr2730748ejc.7.1700668968118;
        Wed, 22 Nov 2023 08:02:48 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:fba6])
        by smtp.gmail.com with ESMTPSA id x26-20020a1709065ada00b009fd04a1a1dfsm4541805ejs.40.2023.11.22.08.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 08:02:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	joshi.k@samsung.com
Subject: [PATCH 2/3] io_uring/cmd: inline io_uring_cmd_do_in_task_lazy
Date: Wed, 22 Nov 2023 16:01:10 +0000
Message-ID: <9af6ade1052b26c69a1d12dad3fa5d05126578b3.1700668641.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <cover.1700668641.git.asml.silence@gmail.com>
References: <cover.1700668641.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now as we can easily include io_uring_types.h, move IOU_F_TWQ_LAZY_WAKE
and inline io_uring_cmd_do_in_task_lazy().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h   | 31 ++++++++++++++++---------------
 include/linux/io_uring_types.h | 11 +++++++++++
 io_uring/io_uring.h            | 10 ----------
 io_uring/uring_cmd.c           |  7 -------
 4 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 62fcfaf6fcc9..ee9b3bc3a4af 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -36,15 +36,6 @@ void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
 			    unsigned flags);
-/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
-void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
-
-static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-{
-	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
-}
 
 void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags);
@@ -60,12 +51,9 @@ static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		ssize_t ret2, unsigned issue_flags)
 {
 }
-static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-{
-}
-static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+static inline void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
+			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
+			    unsigned flags)
 {
 }
 static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
@@ -78,4 +66,17 @@ static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd
 }
 #endif
 
+/* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
+static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
+}
+
+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
+{
+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
+}
+
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 0bcecb734af3..8ff4642dc6e3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -7,6 +7,17 @@
 #include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
+enum {
+	/*
+	 * A hint to not wake right away but delay until there are enough of
+	 * tw's queued to match the number of CQEs the task is waiting for.
+	 *
+	 * Must not be used wirh requests generating more than one CQE.
+	 * It's also ignored unless IORING_SETUP_DEFER_TASKRUN is set.
+	 */
+	IOU_F_TWQ_LAZY_WAKE			= 1,
+};
+
 enum io_uring_cmd_flags {
 	IO_URING_F_COMPLETE_DEFER	= 1,
 	IO_URING_F_UNLOCKED		= 2,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dc6d779b452b..48ffdb156f73 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -15,16 +15,6 @@
 #include <trace/events/io_uring.h>
 #endif
 
-enum {
-	/*
-	 * A hint to not wake right away but delay until there are enough of
-	 * tw's queued to match the number of CQEs the task is waiting for.
-	 *
-	 * Must not be used wirh requests generating more than one CQE.
-	 * It's also ignored unless IORING_SETUP_DEFER_TASKRUN is set.
-	 */
-	IOU_F_TWQ_LAZY_WAKE			= 1,
-};
 
 enum {
 	IOU_OK			= 0,
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 4ed0c66e3aae..94e9de1c24aa 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -78,13 +78,6 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 }
 EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);
 
-void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
-{
-	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
-}
-EXPORT_SYMBOL_GPL(io_uring_cmd_do_in_task_lazy);
-
 static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
 					  u64 extra1, u64 extra2)
 {
-- 
2.42.1


