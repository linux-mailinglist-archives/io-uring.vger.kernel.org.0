Return-Path: <io-uring+bounces-139-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB0B7F4BDA
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 17:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF1F81C20AAC
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 16:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C1F57870;
	Wed, 22 Nov 2023 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBfqv5A+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7673FD56;
	Wed, 22 Nov 2023 08:02:52 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-50943ccbbaeso9875236e87.2;
        Wed, 22 Nov 2023 08:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700668970; x=1701273770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gkK7PO601H1RBbgbf5l3iMvM54jLAc0y16CY4Tdw43g=;
        b=fBfqv5A+aBI0uKbB1gCZKc8VrNhf0t8pOPBH2JXnK9iOg9U/uzcMwai8NLUnKQr+iU
         3pVXQiTqQeabAQ0UU6qQAiw5dyChq73ZcT7DzKV5UsFELUCfGvcd9Wbn2GXfm/rYyMVy
         jb8wPpxNx7eDavz5Fk/hCp5IEES8c5p8s6ZgZmPCZuP5ZD8/TbGeu+PJ+XkmENFDJali
         f41s+GyOwk9J+VsC3Dl8g5eY1Vhph7aFTeZv+0b1jQzq5jGDZ1ryMjq3bVu0F50FR1/x
         Xt0POqBshhJjQxQSJa+yKPH30lThUNy8zowDUUz3AA1Ftl5hNWuGRVe5ncjvWOqxsNzR
         PN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700668970; x=1701273770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gkK7PO601H1RBbgbf5l3iMvM54jLAc0y16CY4Tdw43g=;
        b=X9fT/6d7KSiLLOKFqGmbB6RzvpDOIAZjyOdYocvT+aRNO64G/tIwXASQiqIXEFS5Zc
         7r7eSwa4JBVpAc4RKv5dl7h6s/IPljMJwmOo6eIUWTzKOoRWwaD+dZ98HVvhAYUqviIU
         nZrGQbU9Br6M+xFyQ1zubWdB3WyPsFv0lOcyadfYUQTbPEifpOr9i47v18rbhbiOkbWS
         KCSKzWhwLCV/clUy/VGaoxBOMVHGmrEJh1FygVtlBPgJnANPqiYI9loAhHnCWkwgiCcj
         q+NSmBVK4i52xzakLEzCi3KPZU2V1eVAIcXaXpa8q8mIJoJzSD5rGCaHr7JbHhpxcGif
         8ycA==
X-Gm-Message-State: AOJu0YzP9pk1acLxPPTykfL6fmD44fQ8naTdHXYm8LPcq33yIM7xAq8T
	dRYwiOoTJJlJaRv+je2nIc2KvOL2i+4=
X-Google-Smtp-Source: AGHT+IHuSF3RLTzru/3I6Fp13VVWBGT+O0N5315u+wAyv+X/KenGfAao3fBZEy+WEbF3PsgesVP9Jg==
X-Received: by 2002:ac2:5e9b:0:b0:4ff:7f7f:22e7 with SMTP id b27-20020ac25e9b000000b004ff7f7f22e7mr2367670lfq.17.1700668969705;
        Wed, 22 Nov 2023 08:02:49 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:fba6])
        by smtp.gmail.com with ESMTPSA id x26-20020a1709065ada00b009fd04a1a1dfsm4541805ejs.40.2023.11.22.08.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 08:02:48 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	joshi.k@samsung.com
Subject: [PATCH 3/3] io_uring/cmd: inline io_uring_cmd_get_task
Date: Wed, 22 Nov 2023 16:01:11 +0000
Message-ID: <037278f2e69a0333d33d81864e3556ba54a76240.1700668641.git.asml.silence@gmail.com>
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

With io_uring_types.h we see all required definitions to inline
io_uring_cmd_get_task().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h | 10 +++++-----
 io_uring/uring_cmd.c         |  6 ------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index ee9b3bc3a4af..d69b4038aa3e 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -39,7 +39,6 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
 
 void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags);
-struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd);
 
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -60,10 +59,6 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
 }
-static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
-{
-	return NULL;
-}
 #endif
 
 /* users must follow the IOU_F_TWQ_LAZY_WAKE semantics */
@@ -79,4 +74,9 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
 }
 
+static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
+{
+	return cmd_to_io_kiocb(cmd)->task;
+}
+
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 94e9de1c24aa..34030583b9b2 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -52,12 +52,6 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 
-struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
-{
-	return cmd_to_io_kiocb(cmd)->task;
-}
-EXPORT_SYMBOL_GPL(io_uring_cmd_get_task);
-
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-- 
2.42.1


