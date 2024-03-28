Return-Path: <io-uring+bounces-1303-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCA58908AC
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 19:54:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FA9229D59D
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 18:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9054513775A;
	Thu, 28 Mar 2024 18:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ROI/DpX6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB679137766
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 18:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652064; cv=none; b=emMlfsjrXSUQdZ5BLbpDOiGml3MUxz1gZ6sWdJTlorvDXuQvWgkQa0bTJSC3OBebBZP812QzWLRPrgNKA/VJin4Ik5zmTBc8X/Px9sjKAOpck+tSJTVf/JBxUD6KFqGFG8Z2FVwR9BLfa1uIXvIRrJkLXJFJAhQi6KaWyO3jrLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652064; c=relaxed/simple;
	bh=ulvOA/fOGKjlgOCiBkh6HRvedlSctzNkeP6g239frL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qok9Vft2tY6AfLFSiHL62jJo1p2c8mGNWGwzlAfxpErGbDlcLspYQSKS9AJPAsB5V+CzbKHF0pNzEZ1t7Cp9Nsv6y27tTNWKTobQZ43ILNPagMgEe2bDSZxksJL7umvBkm1iourBzPHMRpeJb4TPU6RPPwp+5ZudO9btRdeO6AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ROI/DpX6; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ea7b38f773so277724b3a.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 11:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711652061; x=1712256861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=65KYXuavK2ROJ0oYC9aH8brlw8GCzH/RY253MWquCC4=;
        b=ROI/DpX6qX926PLwdGdWB2d8s1qpgfvQus1ymS8nGLxYxmwAUNyqLDNn5N4QuuhKsm
         Z/pC0A8Ue8784JWY/n66xjrrHkY2AC3i2uku6iO30NpZKLcAaXVobXojtW8NJZw7iTHL
         Qvj5qJfdbHQ/SdrIpgFKLMb9k94vjAvY/f+TLKxjG7qCn8kla+lBMDTAGzepsFBAtJjI
         QBCNReaYSvsDOTPyk0MXRpHRwURiMtHcOf44p36KPzdsFiufNML2F3zSIk+OMDZbp5pt
         hf9+HcAuf32Uv2Vf6qsfqsO78Hvq0+eqrNeIxm6IIJfpTgTYvfDR70gPF018K/nUN/Ts
         jfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711652061; x=1712256861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=65KYXuavK2ROJ0oYC9aH8brlw8GCzH/RY253MWquCC4=;
        b=TJBwwuHRR3VpRkMPoI/RdsgHP2UHrdgB2c6LV0tfZZ3rhio9eqXZmlf4NviWTalWe0
         +SmIN9qOBtMwTBhZUtYDqdDA6+Er+UoYA50CDuVv/mCrKTfPgieU77QCMcxqQh7OxFa7
         BMyM00ACG1PYNTnKM+f4S7sUZZxxL+KBb1f6dgrvEkrW7t7adimcIh1qhdsyjnz3o+gb
         pdQekeZUjUkS3+dLDY2n6Gk0u7LIRLaWf4+EZ9g78yIkDvqT7cVjplpZAnemB5ixY8e4
         gwCebtda+gMDttYG7/GfObqgHaTOWLQskxOGH5rdaO9+huXya5CfS8fiq6JwLR2/Ihq8
         BaxA==
X-Gm-Message-State: AOJu0YwxS+6Zsh7+3RTqQnkfIVfDn93h6CZevxa2qq7bD4k1YIfQ6L4U
	MVZPI/xE+o6rfBq3Go/FAz45vLbnMt9+O6zsL4s7VobEaA/uVVN8iliF1E5ypbpO8e4nuLBmNAL
	X
X-Google-Smtp-Source: AGHT+IH/w+XJdAxeUW6QIeSGh+YpfJ5xScO30UfRqIqv0krUtAkpGgz1BvY7cKZT/y4fiHnM2sgjMQ==
X-Received: by 2002:a05:6a00:198c:b0:6ea:ba47:a63b with SMTP id d12-20020a056a00198c00b006eaba47a63bmr213217pfl.0.1711652060934;
        Thu, 28 Mar 2024 11:54:20 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:b138])
        by smtp.gmail.com with ESMTPSA id v17-20020a056a00149100b006e631af9cefsm1717357pfu.62.2024.03.28.11.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 11:54:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/msg_ring: improve handling of target CQE posting
Date: Thu, 28 Mar 2024 12:52:45 -0600
Message-ID: <20240328185413.759531-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328185413.759531-1-axboe@kernel.dk>
References: <20240328185413.759531-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the exported helper for queueing task_work, rather than rolling our
own.

This improves peak performance of message passing by about 5x in some
basic testing, with 2 threads just sending messages to each other.
Before this change, it was capped at around 700K/sec, with the change
it's at over 4M/sec.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index d1f66a40b4b4..e12a9e8a910a 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -11,9 +11,9 @@
 #include "io_uring.h"
 #include "rsrc.h"
 #include "filetable.h"
+#include "refs.h"
 #include "msg_ring.h"
 
-
 /* All valid masks for MSG_RING */
 #define IORING_MSG_RING_MASK		(IORING_MSG_RING_CQE_SKIP | \
 					IORING_MSG_RING_FLAGS_PASS)
@@ -21,7 +21,6 @@
 struct io_msg {
 	struct file			*file;
 	struct file			*src_file;
-	struct callback_head		tw;
 	u64 user_data;
 	u32 len;
 	u32 cmd;
@@ -73,26 +72,20 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 	return current != target_ctx->submitter_task;
 }
 
-static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
+static int io_msg_exec_remote(struct io_kiocb *req, io_req_tw_func_t func)
 {
 	struct io_ring_ctx *ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct task_struct *task = READ_ONCE(ctx->submitter_task);
 
-	if (unlikely(!task))
-		return -EOWNERDEAD;
-
-	init_task_work(&msg->tw, func);
-	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
-		return -EOWNERDEAD;
-
+	__io_req_set_refcount(req, 2);
+	req->io_task_work.func = func;
+	io_req_task_work_add_remote(req, task, ctx, IOU_F_TWQ_LAZY_WAKE);
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
-static void io_msg_tw_complete(struct callback_head *head)
+static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	struct io_msg *msg = container_of(head, struct io_msg, tw);
-	struct io_kiocb *req = cmd_to_io_kiocb(msg);
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	int ret = 0;
 
@@ -120,6 +113,7 @@ static void io_msg_tw_complete(struct callback_head *head)
 
 	if (ret < 0)
 		req_set_fail(req);
+	req_ref_put_and_test(req);
 	io_req_queue_tw_complete(req, ret);
 }
 
@@ -205,16 +199,15 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	return ret;
 }
 
-static void io_msg_tw_fd_complete(struct callback_head *head)
+static void io_msg_tw_fd_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	struct io_msg *msg = container_of(head, struct io_msg, tw);
-	struct io_kiocb *req = cmd_to_io_kiocb(msg);
 	int ret = -EOWNERDEAD;
 
 	if (!(current->flags & PF_EXITING))
 		ret = io_msg_install_complete(req, IO_URING_F_UNLOCKED);
 	if (ret < 0)
 		req_set_fail(req);
+	req_ref_put_and_test(req);
 	io_req_queue_tw_complete(req, ret);
 }
 
-- 
2.43.0


