Return-Path: <io-uring+bounces-2005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B03B8D4F12
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:28:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C9451C2442A
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 15:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697F613212C;
	Thu, 30 May 2024 15:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nsc4Uql2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1765176253
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717082922; cv=none; b=LEuV+k98qo8qvTZ+sTdz+uZgzwUUt9GyASU6QckJuvXNKrcQMxOw39GAFBLel3YMEcdvJvILqM0wbRSqPWblRrTXIRGhf8mcjX5ZD6wKsgJiI057Q0eqkDW6n6Ru0mC52Xd1gUZNqzmsQtgYWYyaWomGndejKf5EaRF2aDU5sW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717082922; c=relaxed/simple;
	bh=n+m+CwAvSa1kXq2eCZNOoaL2fkYdDcUOpkvs/F1yy/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQKv5S86b00WaRH2i+c7srVkFT4bhOwzghoE3lXEnO8OEqE6d+Y2Yq/ocpYVFULkRqVmOupNvn9v6T09Cg5jkctdM7vhrncLS5iS1jwmee2pbHsItwt9WyRD0sCKC8SXWXu8ijhkiFvIOlFE1Mdsv+QvUejqQksObGoAPad3aV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nsc4Uql2; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3d1dbf0d2deso114939b6e.0
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 08:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717082919; x=1717687719; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f8xHpPp6VwiyLi53MsP31sWZpcYRDe2M7wr7hfpOP6E=;
        b=nsc4Uql2VyTXxXit2bW4syXu1yzzUrMd+HwRsb8lqFrVOvFnMbQyDflRvkcwzpCkk0
         /3IZNNtJyqBKwlq1NR6/oEncWuTnBKHmvD/wy9tEHvt/aPBFqYJKjc3NGwm2MrYbD3pi
         ucUtOnmnKomDecYe9pz2BV5ZAMhS1SOKr88EtL6q6vs/EDE4riDL72NrsuvWqUBsh+XT
         0KKZsTmjzz04q/01DXaE+RGl4RWThI996ihuLQwFqYqKR3y/gqsXRwQh9EwdkQB8GKzO
         zYzrq7jm6ADcsxrw+MkgHRS5ZRvev8xKyBQz/yyp4hb1hNJh8r6vyjVZij5D9fgJ9O0O
         zyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717082919; x=1717687719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f8xHpPp6VwiyLi53MsP31sWZpcYRDe2M7wr7hfpOP6E=;
        b=mIuMHYlODOqLtFsagJBLfhO9wIDbY1kDemB9EEAuLyGtO6xWtPcFHeYCh7J9Hwcy/x
         3sNwH4lYNdkczdbiyNUfcEKqbF/1wSI2/x8+5nQn+NJYSGw60UY/KP6OHtxt1YZxWIpZ
         6NGVf8bxXOhD/CCvGgojvLunt/eZRc3jyjgzSRehrp05v1w7yTFaiQcLnitP+SicSAZj
         vJbBwymS33urujuEJk3Dzp6rYA6o1s5BylluJrLcjNI19Tv/s68ld17qPE3bUMekII7T
         wY6q8E0Tj55OB1hQ4QzW+EAiSH0ynxILr1xvXMk5CCNXgQgRXWgDh6WdbFJBXcbLr7MU
         WudA==
X-Gm-Message-State: AOJu0Yzx3rFLDh+MblphWuUZfk/b1uT5NxZQbizO22wVCsnNUQRuENKN
	KZQu66SVlrTu7JVGk2vDQfmFpXEzia/Kvd8gxdz6sDqyFRfurY7SS+1btzGeJeic4LzNA2yU6Ni
	n
X-Google-Smtp-Source: AGHT+IFfDHyYZBU2oqNxcVfNkKT0Lwe+19Fw4h5BRC84kFPff4DMGcBpUNWDEFz4Ax2xTHyjHhkg/w==
X-Received: by 2002:a05:6808:23cb:b0:3c8:2be1:a65b with SMTP id 5614622812f47-3d1dcbe62c5mr2799134b6e.0.1717082918525;
        Thu, 30 May 2024 08:28:38 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b3682381sm2008136b6e.2.2024.05.30.08.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:28:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] io_uring/msg_ring: avoid double indirection task_work for fd passing
Date: Thu, 30 May 2024 09:23:41 -0600
Message-ID: <20240530152822.535791-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240530152822.535791-2-axboe@kernel.dk>
References: <20240530152822.535791-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like what was done for MSG_RING data passing avoiding a double task_work
roundtrip for IORING_SETUP_DEFER_TASKRUN, implement the same model for
fd passing. File descriptor passing is separately locked anyway, so the
only remaining issue is CQE posting, just like it was for data passing.
And for that, we can use the same approach.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 58 +++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index bdb935ef7aa2..74590e66d7f7 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -71,22 +71,6 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 	return target_ctx->task_complete;
 }
 
-static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
-{
-	struct io_ring_ctx *ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-	struct task_struct *task = READ_ONCE(ctx->submitter_task);
-
-	if (unlikely(!task))
-		return -EOWNERDEAD;
-
-	init_task_work(&msg->tw, func);
-	if (task_work_add(task, &msg->tw, TWA_SIGNAL))
-		return -EOWNERDEAD;
-
-	return IOU_ISSUE_SKIP_COMPLETE;
-}
-
 static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
 {
 	bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
@@ -236,17 +220,39 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	return ret;
 }
 
-static void io_msg_tw_fd_complete(struct callback_head *head)
+static int io_msg_install_remote(struct io_kiocb *req, unsigned int issue_flags,
+				 struct io_ring_ctx *target_ctx)
 {
-	struct io_msg *msg = container_of(head, struct io_msg, tw);
-	struct io_kiocb *req = cmd_to_io_kiocb(msg);
-	int ret = -EOWNERDEAD;
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	bool skip_cqe = msg->flags & IORING_MSG_RING_CQE_SKIP;
+	struct io_overflow_cqe *ocqe = NULL;
+	int ret;
 
-	if (!(current->flags & PF_EXITING))
-		ret = io_msg_install_complete(req, IO_URING_F_UNLOCKED);
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_queue_tw_complete(req, ret);
+	if (!skip_cqe) {
+		ocqe = io_alloc_overflow(target_ctx);
+		if (!ocqe)
+			return -ENOMEM;
+	}
+
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags))) {
+		kfree(ocqe);
+		return -EAGAIN;
+	}
+
+	ret = __io_fixed_fd_install(target_ctx, msg->src_file, msg->dst_fd);
+	mutex_unlock(&target_ctx->uring_lock);
+
+	if (ret >= 0) {
+		msg->src_file = NULL;
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+		if (!skip_cqe) {
+			spin_lock(&target_ctx->completion_lock);
+			io_msg_add_overflow(msg, target_ctx, ocqe, ret, 0);
+			return 0;
+		}
+	}
+	kfree(ocqe);
+	return ret;
 }
 
 static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
@@ -271,7 +277,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (io_msg_need_remote(target_ctx))
-		return io_msg_exec_remote(req, io_msg_tw_fd_complete);
+		return io_msg_install_remote(req, issue_flags, target_ctx);
 	return io_msg_install_complete(req, issue_flags);
 }
 
-- 
2.43.0


