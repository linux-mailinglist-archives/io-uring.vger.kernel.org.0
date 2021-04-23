Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A01F3689B2
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbhDWAUU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235812AbhDWAUT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:19 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368E2C061574
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:44 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id t14-20020a05600c198eb029012eeb3edfaeso262495wmq.2
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8amjPWQP/ni4iyHNFWY/ielkglMRqyq/fPWtm5gAaH8=;
        b=ArkLbwXCgINrjjtfkNL5VBh1TqNmK1en8XIMw1RnNaBUx2c3Ta9CovVf4kcvcBcXgs
         EGp+2BUGalVh6bZhrsUL2kOLsLfsp6yRmEHeg+6o3aXBTXGZ1TMH3EjAT1IPqPeaY03c
         o0244EBRNQ0+qQjxovneYUWZwT/VfbilcALPd3egQf0Wt7x20E8VVnqWA4X28W+5IIqn
         +wBbJlIkUTnTjJ8shkxkXRCbqiiStIB4pJRl3yC6rZMG8RBJzZoTiq7f9B1O0b0/mBCF
         jgacOCoLFyXHRc6ICYdIkdaxgcwt7+aIb43/Klr4PiKLwdo6hfgMpaZL0mJL00dl11zf
         X3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8amjPWQP/ni4iyHNFWY/ielkglMRqyq/fPWtm5gAaH8=;
        b=ocdio58FKPUW2mbB6fhzcro2D/jxWA6VCPLqAgkHd36OiEVhymz6fp/ET7S3d/hUVW
         lvfGCqaIGFzamKfU68eZXou0oefD1RXYQtwnVRVfeIpPqL4/iTbK5JEjqI7WQ9yIsas6
         85mD9dr68ZXlNzk17AmHmLWtolTNyIH6rRkdPePAlyF1v+ezsBpAuc+xTgqX5x/szmsG
         NcgeZbp0mhlNwDeaKMlvNrg0dk4nPw8WAZ64/h3ASOcQNABFLAkHwYYKUIYufX/leFrX
         5X4szdHpuCj9Wd0fpUti4OZFaVoUSnixZgQDlJVeyOCUsTtS4xDPPzR+YLQNaFJBbxfD
         5E7Q==
X-Gm-Message-State: AOAM533WSJgLUStI63JsvvLjpFEsoy8DsL6taa6/8/A6aSv7s6ajBSr4
        tS85dryROEw0BbljUJoWZQmBhEBmpHE=
X-Google-Smtp-Source: ABdhPJyqaVNwP8EySLV3oz1zzJVi4iI0LLSPkTRb+rKplWUwAu4IZXQj/qa1BtiHbfYeZB7r9WMfLA==
X-Received: by 2002:a7b:c4d9:: with SMTP id g25mr2646512wmk.182.1619137182905;
        Thu, 22 Apr 2021 17:19:42 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/11] io_uring: add generic path for rsrc update
Date:   Fri, 23 Apr 2021 01:19:22 +0100
Message-Id: <6fdc8259928edaf02b15be48288d5d2a6492b7e6.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
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
index 0c3936fe1943..906baaa10d09 100644
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
@@ -7722,25 +7723,20 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
@@ -7794,23 +7790,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
@@ -9688,6 +9667,40 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
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
@@ -9778,7 +9791,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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

