Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907A2674074
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 19:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjASSCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 13:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjASSCk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 13:02:40 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC8A4EE3
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 10:02:33 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id p189so1358465iod.0
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 10:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zo7rwkH1ueFFKseiRYFfEN5MPxzoA/BBxczMpa9w0Y0=;
        b=hI5jF/b+VFhhgONYOJNZjrABvD9AEAyWZlYPVfBwLibCyH2aT43WQIWS+PA1/FQrT0
         66nwCuSYXgMMDENlFGpTiz0nJXkduIS7PCcoB4J4eD+ZaNWNCvZ47bGziyriYRRFJl4Y
         nS/jEuJg6Gr+O5kqQEJWwg/06JaN8Wxo7E5QerOmYgJsSMxo0oSLcsKCm1EmiiLTXV0t
         L0LZ9npUUfCgzlSACd7MZVMiy7sp1nQTREBv5G8uGZKIVuVz5jX/EB6YcJldZuPx5hPv
         /sHnnh1OoXTdVhowYzD8z6U4FZiw5CP8UcmNH65/jVLPHDF4rNvWm8oF2Au0Z+eaB9es
         kwGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zo7rwkH1ueFFKseiRYFfEN5MPxzoA/BBxczMpa9w0Y0=;
        b=xKy9jvMKR219ELkMfzSv4eRra1qt6CayZY8CYgo7VU0egG+To0Avse1ATB7gD+O5pa
         22c3BTiIsXZS6cOmPpqjQkzWPj5pbjxJ57ITDsxldiuTSlYbqF2oEcs5vUujD2sEPIjG
         NSrRWaIhdSipG5tHg1pYmd7JAOliERwEuIohxUAUxKcj+pGieaobS4mXhgIC7kKg8x0F
         qsK/VjgZyALgeNjDgribnCSST8/t1TuUbm5TGXPnGWxmDP9icUBbQOirXu83weJsskTQ
         nkUnxQDnRcI1f1wOJTm/5xJzB8H1XVzdCdjJWCTiuqqplhOkKObiTBE6YNECSnJH/1gX
         QIFQ==
X-Gm-Message-State: AFqh2koxJ6Wh+TYlWMApR2po/t4rzIcfJtjaVxTh+dLJBlMSgE9k3+6X
        UoHIl2TBMAQz4jBuJXzcuZC+Xb4dBVYLtiIH
X-Google-Smtp-Source: AMrXdXtzXy9XT++h5uDYKb6y0c2OpDXb6GLURjwNhYfp1qwV6Z9xDhSeYTqID6BZPVufVNF9YBQ65g==
X-Received: by 2002:a6b:4f10:0:b0:6ed:95f:92e7 with SMTP id d16-20020a6b4f10000000b006ed095f92e7mr1878438iob.0.1674151352907;
        Thu, 19 Jan 2023 10:02:32 -0800 (PST)
Received: from m1max.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d3-20020a0566022be300b00704d1d8faecsm2354914ioy.48.2023.01.19.10.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 10:02:28 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>,
        Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH 2/2] io_uring/msg_ring: fix missing lock on overflow for IOPOLL
Date:   Thu, 19 Jan 2023 11:02:25 -0700
Message-Id: <20230119180225.466835-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230119180225.466835-1-axboe@kernel.dk>
References: <20230119180225.466835-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the target ring is configured with IOPOLL, then we always need to hold
the target ring uring_lock before posting CQEs. We could just grab it
unconditionally, but since we don't expect many target rings to be of this
type, make grabbing the uring_lock conditional on the ring type.

Link: https://lore.kernel.org/io-uring/Y8krlYa52%2F0YGqkg@ip-172-31-85-199.ec2.internal/
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 321f5eafef99..a333781565d3 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -65,20 +65,33 @@ static void io_msg_tw_complete(struct callback_head *head)
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	int ret = 0;
 
-	if (current->flags & PF_EXITING)
+	if (current->flags & PF_EXITING) {
 		ret = -EOWNERDEAD;
-	else if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
-		ret = -EOVERFLOW;
+	} else {
+		/*
+		 * If the target ring is using IOPOLL mode, then we need to be
+		 * holding the uring_lock for posting completions. Other ring
+		 * types rely on the regular completion locking, which is
+		 * handled while posting.
+		 */
+		if (target_ctx->flags & IORING_SETUP_IOPOLL)
+			mutex_lock(&target_ctx->uring_lock);
+		if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+			ret = -EOVERFLOW;
+		if (target_ctx->flags & IORING_SETUP_IOPOLL)
+			mutex_unlock(&target_ctx->uring_lock);
+	}
 
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_queue_tw_complete(req, ret);
 }
 
-static int io_msg_ring_data(struct io_kiocb *req)
+static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	int ret;
 
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
@@ -93,10 +106,18 @@ static int io_msg_ring_data(struct io_kiocb *req)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
-		return 0;
-
-	return -EOVERFLOW;
+	ret = -EOVERFLOW;
+	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
+		if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+			return -EAGAIN;
+		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+			ret = 0;
+		io_double_unlock_ctx(target_ctx);
+	} else {
+		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+			ret = 0;
+	}
+	return ret;
 }
 
 static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
@@ -223,7 +244,7 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 
 	switch (msg->cmd) {
 	case IORING_MSG_DATA:
-		ret = io_msg_ring_data(req);
+		ret = io_msg_ring_data(req, issue_flags);
 		break;
 	case IORING_MSG_SEND_FD:
 		ret = io_msg_send_fd(req, issue_flags);
-- 
2.39.0

