Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8E46F285C
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 11:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjD3Jhq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 05:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjD3Jho (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 05:37:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B61D2735
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:42 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-2fa36231b1cso794699f8f.2
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682847460; x=1685439460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmuW/MpO/9IxCXcGhDL4XUbVtFJQiN1vt8nHVjwm53I=;
        b=VlLFbbxmDuQ6Fjd0ikAmdy7s6UvkS0rN6f+mgOf1Htv4UdYNYWBG42dTnQuDYP1te+
         RmKCsoqRgnJ+dmNBLWFEdN3+vSLcJDqVLltHss8CHBt8Q/egL5DP8+U4yGoyDk6h05qD
         yHA1M4nBbzivPL0bzVoMgwrend7qX3yUGOiRMesuIJgRjjREaGNkNXg6PRsdZl7iWzw+
         w+I3SQw0dDypFkq9GID4WG7r7C5d4+YSMImCyv33FBd70/Vj5cak5pzBZdRKztPDaoEv
         aMnheTh1yNKTLBfX12XX5etV5xPq0IrOEg1bTuNuyBppcqkAgg5EpSza1b4UMk/P52ha
         w3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682847460; x=1685439460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WmuW/MpO/9IxCXcGhDL4XUbVtFJQiN1vt8nHVjwm53I=;
        b=ZbGce07NLGLYq8qVjePjEdQuzeFAsvEnk84vd1RYHu36BsYqAQxbJobpRFiVBtpL9V
         Zxh+TA4h8gECkwZWsLhv7ltgGYqFDaTqvJliKdVZ47yqxP3ALKZUr119yQbrj/ELyBMd
         0Mdjk2yhccxdTkvpYyHrmhUpy8mHrV585AU/TzOUZMOdErjKobzDp+dbMXS0Z8v0imRW
         w5nHtrHMcB+Z78YWQ0PmhvYor7/uMZdL661RT0Ofzabw8S/6kwcUA3LqWB6lgLJeqG84
         kB9nAomOFlMgc5vUjgvhOeaE4F4aD49LYa23+D5YUPVS7Ltl19nBiliweLb8e4OBYsE8
         EdyQ==
X-Gm-Message-State: AC+VfDzLTwx1WUlImiP5cp8Fqen5KzVRW+Vv53NYeXh5skVwxH5Dsyo8
        tWGAETQ3ECGLAxva6kZf/92dUjIY14A=
X-Google-Smtp-Source: ACHHUZ4tZoBlQD9+cVWg/k/xGqRcUKknFJe4nGxVR0QRWye9TM+8l3sjTOe9Q8E9IoIiTiVKWx87qw==
X-Received: by 2002:a05:6000:1d1:b0:306:20eb:bedd with SMTP id t17-20020a05600001d100b0030620ebbeddmr2234265wrx.51.1682847460505;
        Sun, 30 Apr 2023 02:37:40 -0700 (PDT)
Received: from 127.0.0.1localhost (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c00d300b003f17eaae2c9sm29473170wmm.1.2023.04.30.02.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 02:37:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, ming.lei@redhat.com
Subject: [RFC 7/7] io_uring,fs: introduce IORING_OP_GET_BUF
Date:   Sun, 30 Apr 2023 10:35:29 +0100
Message-Id: <fc43826d510dc75de83d81161ca03e2688515686.1682701588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682701588.git.asml.silence@gmail.com>
References: <cover.1682701588.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are several problems with splice requests, aka IORING_OP_SPLICE:
1) They are always executed by a worker thread, which is a slow path,
   as we don't have any reliable way to execute it NOWAIT.
2) It can't easily poll for data, as there are 2 files it operates on.
   It would either need to track what file to poll or poll both of them,
   in both cases it'll be a mess and add lot of overhead.
3) It has to have pipes in the middle, which adds overhead and is not
   great from the uapi design perspective when it goes for io_uring
   requests.
4) We want to operate with spliced data as with a normal buffer, i.e.
   write / send / etc. data as normally while it's zerocopy.

It can partially be solved, but the root cause is a suboptimal for
io_uring design of IORING_OP_SPLICE. Introduce a new request type
called IORING_OP_GET_BUF, inspired by splice(2) as well as other
proposals like fused requests. The main idea is to use io_uring's
registered buffers as the middle man instead of pipes. Once a buffer
is fetched / spliced from a file using a new fops callback
->iou_get_buf, it's installed as a registered buffers and can be used
by all operations supporting the feature.

Once the userspace releases the buffer, io_uring will wait for all
requests using the buffer to complete and then use a file provided
callback ->release() to return the buffer back. It operates on the
level of the entire buffer instead of individual pages like it's with
splice(2). As it was noted by the fused cmd work from where it came,
this approach should be more flexible and efficient, and also leaves
the space for more optimisations like custom caching or avoiding page
refcounting altogether.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/fs.h            |  2 +
 include/linux/io_uring.h      | 11 +++++
 include/uapi/linux/io_uring.h |  1 +
 io_uring/opdef.c              | 11 +++++
 io_uring/rsrc.c               |  2 +-
 io_uring/rsrc.h               |  2 +
 io_uring/splice.c             | 90 +++++++++++++++++++++++++++++++++++
 io_uring/splice.h             |  4 ++
 8 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 475d88640d3d..a2528a39571f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1753,6 +1753,7 @@ struct dir_context {
 
 struct iov_iter;
 struct io_uring_cmd;
+struct iou_get_buf_info;
 
 struct file_operations {
 	struct module *owner;
@@ -1798,6 +1799,7 @@ struct file_operations {
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
+	int (*iou_get_buf)(struct file *file, struct iou_get_buf_info *);
 } __randomize_layout;
 
 struct inode_operations {
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index e0e7df5beefc..9564db555bab 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -30,6 +30,17 @@ struct iou_buf_desc {
 	void			*private;
 };
 
+enum {
+	IOU_GET_BUF_F_NOWAIT	= 1,
+};
+
+struct iou_get_buf_info {
+	loff_t			off;
+	size_t			len;
+	unsigned		flags;
+	struct iou_buf_desc	*desc;
+};
+
 struct io_uring_cmd {
 	struct file	*file;
 	const void	*cmd;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0716cb17e436..b244215d03ad 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -223,6 +223,7 @@ enum io_uring_op {
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
+	IORING_OP_GET_BUF,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index cca7c5b55208..d3b7144c685a 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -428,6 +428,13 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_GET_BUF] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.prep			= io_get_buf_prep,
+		.issue			= io_get_buf,
+	},
 };
 
 
@@ -648,6 +655,10 @@ const struct io_cold_def io_cold_defs[] = {
 		.fail			= io_sendrecv_fail,
 #endif
 	},
+	[IORING_OP_GET_BUF] = {
+		.name			= "IORING_OP_GET_BUF",
+		.cleanup		= io_get_buf_cleanup,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index db4286b42dce..bdcd417bca87 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -89,7 +89,7 @@ static void io_put_reg_buf(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 		kvfree(imu);
 }
 
-static struct io_mapped_ubuf *io_alloc_reg_buf(struct io_ring_ctx *ctx,
+struct io_mapped_ubuf *io_alloc_reg_buf(struct io_ring_ctx *ctx,
 					       int nr_bvecs)
 {
 	struct io_cache_entry *entry;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index aba95bdd060e..6aaf7acb60c5 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -177,4 +177,6 @@ static inline void io_reg_buf_release(struct io_mapped_ubuf *imu)
 	imu->desc.release(&imu->desc);
 }
 
+struct io_mapped_ubuf *io_alloc_reg_buf(struct io_ring_ctx *ctx, int nr_bvecs);
+
 #endif
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 2a4bbb719531..3d50334caec5 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -13,6 +13,7 @@
 
 #include "io_uring.h"
 #include "splice.h"
+#include "rsrc.h"
 
 struct io_splice {
 	struct file			*file_out;
@@ -119,3 +120,92 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+struct io_get_buf {
+	struct file			*file;
+	struct io_mapped_ubuf		*imu;
+	int				max_pages;
+	loff_t				off;
+	u64				len;
+};
+
+void io_get_buf_cleanup(struct io_kiocb *req)
+{
+	struct io_get_buf *gb = io_kiocb_to_cmd(req, struct io_get_buf);
+	struct io_mapped_ubuf *imu = gb->imu;
+
+	if (!imu)
+		return;
+	if (imu->desc.nr_bvecs && !WARN_ON_ONCE(!imu->desc.release))
+		io_reg_buf_release(imu);
+
+	kvfree(imu);
+	gb->imu = NULL;
+}
+
+int io_get_buf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_get_buf *gb = io_kiocb_to_cmd(req, struct io_get_buf);
+	struct io_mapped_ubuf *imu;
+	int nr_pages;
+
+	if (unlikely(sqe->splice_flags || sqe->splice_fd_in || sqe->ioprio ||
+		     sqe->addr || sqe->addr3))
+		return -EINVAL;
+
+	req->buf_index = READ_ONCE(sqe->buf_index);
+	gb->len = READ_ONCE(sqe->len);
+	gb->off = READ_ONCE(sqe->off);
+	nr_pages = (gb->len >> PAGE_SHIFT) + 2;
+	gb->max_pages = nr_pages;
+
+	gb->imu = imu = io_alloc_reg_buf(req->ctx, nr_pages);
+	if (!imu)
+		return -ENOMEM;
+	imu->desc.nr_bvecs = 0;
+	req->flags |= REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+int io_get_buf(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_get_buf *gb = io_kiocb_to_cmd(req, struct io_get_buf);
+	struct io_mapped_ubuf *imu = gb->imu;
+	struct iou_get_buf_info bi;
+	int ret, err;
+
+	bi.off = gb->off;
+	bi.len = gb->len;
+	bi.flags = (issue_flags & IO_URING_F_NONBLOCK) ? IOU_GET_BUF_F_NOWAIT : 0;
+	bi.desc = &imu->desc;
+
+	if (!gb->file->f_op->iou_get_buf)
+		return -ENOTSUPP;
+	ret = gb->file->f_op->iou_get_buf(gb->file, &bi);
+	if (ret < 0) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+		goto done;
+	}
+
+	imu->ubuf = 0;
+	imu->ubuf_end = ret;
+	imu->dir_mask = 1U << ITER_SOURCE;
+	imu->acct_pages = 0;
+
+	io_ring_submit_lock(req->ctx, issue_flags);
+	err = io_install_buffer(req->ctx, imu, req->buf_index);
+	io_ring_submit_unlock(req->ctx, issue_flags);
+	if (unlikely(err)) {
+		ret = err;
+		goto done;
+	}
+
+	gb->imu = NULL;
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+done:
+	if (ret != gb->len)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/splice.h b/io_uring/splice.h
index 542f94168ad3..2b923fc2bbf1 100644
--- a/io_uring/splice.h
+++ b/io_uring/splice.h
@@ -5,3 +5,7 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_splice(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_get_buf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_get_buf(struct io_kiocb *req, unsigned int issue_flags);
+void io_get_buf_cleanup(struct io_kiocb *req);
-- 
2.40.0

