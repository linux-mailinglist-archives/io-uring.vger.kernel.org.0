Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D5C36A788
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhDYNdW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhDYNdV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:21 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1D8C061756
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:41 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e5so24402964wrg.7
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sYVbXq9kerqZG7kpRFhxR81E20GW8bkR4nH2DTdirEc=;
        b=G3YiwZyOvdzWD/cFvfap09yyhkAk1673/VCHZvWma4IKHob+7WCeFInok7ehRuWZkY
         RDJg/FoOltYuyvGkaOkRhOB3JQNnbLGGaXciFWPc5LkAldv850CKZks24T/6wGSIlgAV
         2klryUw9w7u1O97Gpk5O3HCK6MYSqeI1X8BbqXQ0NpiZYLzmZp29Zn1MSzz/PtVYyj9L
         IOUuNbHAWPVCD7kzEm56uNVJcKCmKKUp4Tqh2gEToK9i84RK+axUC4W9+2OGa89NqKFs
         U3YUpOrF6EuUlHsLLDQqimLG1tUhpMf1ZMDucmrgwJ8wnXtwnDvIKaKdFyhFlQkaZX7e
         Zs6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sYVbXq9kerqZG7kpRFhxR81E20GW8bkR4nH2DTdirEc=;
        b=raa7q414BRKmegP82vJyv3Qrx2li8feWmMikWL2+eIObU38rn/RL8uyIxH6wndnufP
         oeN87wxZHAKS0WKQ0DYpCgvYvp3wm1JEoMNfXOCDoSm2uPXsH8ADrAwhgpG0Vu3cqCQt
         5sW1CJknhzFpRoQbTZs4UOLbUtmzIM19WRaWWeie6+kNx17esz5OkLNAAjqvZsV+RMwr
         XEImDUlZMd+FKpyiVz6M1o7oMjCS3b/gJUWjsbNDB3lWGyjcu07aj5ovXVyoSYMPO+XU
         SQ/ajyqsjgJmLQToDZBP3q2Nq+k11dLd5hrrv7xKNd8mBl0JKURRFcUsl73uJ82Ip+0S
         cE7w==
X-Gm-Message-State: AOAM533AjBZwB2AMxQTcAGxDobfH4n5ZZiK+0TiPbWlJOw6rMCJ9Kpou
        6vQHBOWHE5CHYaNNrQfzX1ALmJw8dbk=
X-Google-Smtp-Source: ABdhPJyEAHqkt4GQdVjCTIlWKb15F//JBSsXwaOZ7TQlINLmCayfhZpz7lScDsXQbsD7BDtivkjcDQ==
X-Received: by 2002:adf:d22c:: with SMTP id k12mr10037708wrh.25.1619357560682;
        Sun, 25 Apr 2021 06:32:40 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 05/12] io_uring: add generic path for rsrc update
Date:   Sun, 25 Apr 2021 14:32:19 +0100
Message-Id: <b49c3ff6b9ff0e530295767604fe4de64d349e04.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract some common parts for rsrc update, will be used reg buffers
support dynamic (i.e. quiesce-lee) managing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 79 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8cc593da5cc4..0f79bb0362cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1035,9 +1035,9 @@ static void io_dismantle_req(struct io_kiocb *req);
 static void io_put_task(struct task_struct *task, int nr);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
-static int __io_sqe_files_update(struct io_ring_ctx *ctx,
-				 struct io_uring_rsrc_update *ip,
-				 unsigned nr_args);
+static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
+				     struct io_uring_rsrc_update *up,
+				     unsigned nr_args);
 static void io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
@@ -5818,7 +5818,8 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up.data = req->rsrc_update.arg;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_sqe_files_update(ctx, &up, req->rsrc_update.nr_args);
+	ret = __io_register_rsrc_update(ctx, IORING_REGISTER_FILES_UPDATE,
+					&up, req->rsrc_update.nr_args);
 	mutex_unlock(&ctx->uring_lock);
 
 	if (ret < 0)
@@ -7721,25 +7722,20 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
 {
+	__s32 __user *fds = u64_to_user_ptr(up->data);
 	struct io_rsrc_data *data = ctx->file_data;
 	struct io_fixed_file *file_slot;
 	struct file *file;
-	__s32 __user *fds;
-	int fd, i, err;
-	__u32 done;
+	int fd, i, err = 0;
+	unsigned int done;
 	bool needs_switch = false;
 
-	if (check_add_overflow(up->offset, nr_args, &done))
-		return -EOVERFLOW;
-	if (done > ctx->nr_user_files)
+	if (!ctx->file_data)
+		return -ENXIO;
+	if (up->offset + nr_args > ctx->nr_user_files)
 		return -EINVAL;
-	err = io_rsrc_node_switch_start(ctx);
-	if (err)
-		return err;
 
-	fds = u64_to_user_ptr(up->data);
 	for (done = 0; done < nr_args; done++) {
-		err = 0;
 		if (copy_from_user(&fd, &fds[done], sizeof(fd))) {
 			err = -EFAULT;
 			break;
@@ -7793,23 +7789,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
-static int io_sqe_files_update(struct io_ring_ctx *ctx, void __user *arg,
-			       unsigned nr_args)
-{
-	struct io_uring_rsrc_update up;
-
-	if (!ctx->file_data)
-		return -ENXIO;
-	if (!nr_args)
-		return -EINVAL;
-	if (copy_from_user(&up, arg, sizeof(up)))
-		return -EFAULT;
-	if (up.resv)
-		return -EINVAL;
-
-	return __io_sqe_files_update(ctx, &up, nr_args);
-}
-
 static struct io_wq_work *io_free_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
@@ -9687,6 +9666,40 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 	return 0;
 }
 
+static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
+				     struct io_uring_rsrc_update *up,
+				     unsigned nr_args)
+{
+	__u32 tmp;
+	int err;
+
+	if (check_add_overflow(up->offset, nr_args, &tmp))
+		return -EOVERFLOW;
+	err = io_rsrc_node_switch_start(ctx);
+	if (err)
+		return err;
+
+	switch (opcode) {
+	case IORING_REGISTER_FILES_UPDATE:
+		return __io_sqe_files_update(ctx, up, nr_args);
+	}
+	return -EINVAL;
+}
+
+static int io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned opcode,
+				   void __user *arg, unsigned nr_args)
+{
+	struct io_uring_rsrc_update up;
+
+	if (!nr_args)
+		return -EINVAL;
+	if (copy_from_user(&up, arg, sizeof(up)))
+		return -EFAULT;
+	if (up.resv)
+		return -EINVAL;
+	return __io_register_rsrc_update(ctx, opcode, &up, nr_args);
+}
+
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
@@ -9777,7 +9790,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = io_sqe_files_unregister(ctx);
 		break;
 	case IORING_REGISTER_FILES_UPDATE:
-		ret = io_sqe_files_update(ctx, arg, nr_args);
+		ret = io_register_rsrc_update(ctx, opcode, arg, nr_args);
 		break;
 	case IORING_REGISTER_EVENTFD:
 	case IORING_REGISTER_EVENTFD_ASYNC:
-- 
2.31.1

