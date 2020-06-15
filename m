Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507371F8FFF
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 09:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgFOHev (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 03:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgFOHeu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 03:34:50 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53555C061A0E;
        Mon, 15 Jun 2020 00:34:50 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id p5so15928115wrw.9;
        Mon, 15 Jun 2020 00:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qjsk++Pix8KjxxXAqgwUSe/HplN2eP5f9UTChVTDsnY=;
        b=bre6wkYEwWhrWFm5OMw2x4DbrW33CuINRb/I2iekq9drqUy/x37EtOYszOWff045Sy
         B7tgq/TAvAZg/Y1zUPySidgMTmoXjmsR6HS1+9toLtCG6XzMNwFR746/W1/VZfweYVXD
         6ntBrnmGetvA8GC2m02EEKubqY5sf4Ql39uCoosgcvIyFwauF4CbWa87pBsGxXOmVh1y
         P8ZDq6HayVLsIstrepALyZA2ohaMUFGsOBdEttZ3DY9j5BtIt32nSKD2CqlFI+IvjPMt
         3xQ+koSxsobl/mQRlQX9LGuO1jwxsXFqey2tkLzEhJYIOyVFVyukzTt936guE6dNFpZK
         HIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qjsk++Pix8KjxxXAqgwUSe/HplN2eP5f9UTChVTDsnY=;
        b=j6TrxujhxtPUGYs9W/w1ClRzwC8vMqry6J7ljlnoG63NdsERJlx7TSjlljriQMLU6d
         tyjBUjpdn0I0Gj4ESiPpxFynvYqWGqmE/i0LxEwqwudEi8sEE4xuld3J71o90xhkAXj2
         nPY5rBj6utS4lwc1/k4YIGy708Fz27RbOIi9il+PJPHwZEZrPHGldqIQACY3dKmr9HTW
         EAewgqKPa9BtaJ4/nIsKjeGXndefGJM+C+jvWSxd+U0gM1xIQfgHPorWKxCp1CqO8x9r
         MC9TUoypeB36UJZ69wEKkfRzZRQZkt34vGUrVQ0UPyNmytbyWmXp6qf1rcqLKsCLJ/2a
         E1Gg==
X-Gm-Message-State: AOAM533d4IcRGjK4XbWeAN+fzn5NbjjAZIbAXPc7y7pRWOXeEzvY5Fp+
        5vxkkeF7rU++AZ22rBVRjJs=
X-Google-Smtp-Source: ABdhPJy6NOLZL9LObfcAG7ZT63gChmITB6+eaKDXqeL4qK7G2p8B1OXAzC6WuepeJ8GJOSE0IROcSA==
X-Received: by 2002:a5d:5601:: with SMTP id l1mr29196223wrv.254.1592206489009;
        Mon, 15 Jun 2020 00:34:49 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id l17sm20271324wmi.16.2020.06.15.00.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 00:34:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ebiederm@xmission.com
Subject: [PATCH 2/2] io_uring: cancel by ->task not pid
Date:   Mon, 15 Jun 2020 10:33:14 +0300
Message-Id: <356acaf3ea3a0f62e77a65e10c940e4656aa6b81.1592206077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592206077.git.asml.silence@gmail.com>
References: <cover.1592206077.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For an exiting process it tries to cancel all its inflight requests.
Use req->task to match such instead of work.pid. We always have
req->task set, and it will be valid because we're matching only
current exiting task.

Also, remove work.pid and everything related, it's useless now

Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h    |  1 -
 fs/io_uring.c | 16 ++++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index b72538fe5afd..071f1a997800 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -90,7 +90,6 @@ struct io_wq_work {
 	const struct cred *creds;
 	struct fs_struct *fs;
 	unsigned flags;
-	pid_t task_pid;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index f05d2e45965e..54addaba742d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1065,8 +1065,6 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 		}
 		spin_unlock(&current->fs->lock);
 	}
-	if (!req->work.task_pid)
-		req->work.task_pid = task_pid_vnr(current);
 }
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
@@ -7455,11 +7453,12 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static bool io_cancel_pid_cb(struct io_wq_work *work, void *data)
+static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 {
-	pid_t pid = (pid_t) (unsigned long) data;
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct task_struct *task = data;
 
-	return work->task_pid == pid;
+	return req->task == task;
 }
 
 static int io_uring_flush(struct file *file, void *data)
@@ -7471,11 +7470,8 @@ static int io_uring_flush(struct file *file, void *data)
 	/*
 	 * If the task is going away, cancel work it may have pending
 	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
-		void *data = (void *) (unsigned long)task_pid_vnr(current);
-
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_pid_cb, data, true);
-	}
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, current, true);
 
 	return 0;
 }
-- 
2.24.0

