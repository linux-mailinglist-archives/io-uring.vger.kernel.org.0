Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E2B510E8A
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 04:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356801AbiD0B5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 21:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356991AbiD0B5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 21:57:43 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B971759E9
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:54:33 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id bo5so370090pfb.4
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2rbnYTLAWf9qT5a8ZuX6DbCphni1DemDS6pY8EsY0dM=;
        b=SSI1Zc8C1D6ksqpzKPluzv1IrzZxSLjd1/s0uPfNcA/ChsCGmPkU6noLF9ZfDN9mJL
         uzt+FlxuKn0bqUwnfPC6XTU2zXAgWXfu/i+EViX7DxwlwYfp20l+q02ht9mmvK1sAYHj
         3vDO9k7fOCzZqaPsgPPbmOe4Wp5SUYmelmpcjFiQ+e7deojo2SViz0C96vrdE3Auevp8
         RR/en+wCb4lMjMQ57EBeG9L8AZtxtGsmNT8GZYqU+1N51am+hvX8h34ELwHs1yDhgYhC
         xZDNg85zLJ4aUCSXd4S5Tro1+QHX7mBVOhYT0gG0pRcZwFZHxez2Tqm/4D9HRcvpiJ66
         AVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2rbnYTLAWf9qT5a8ZuX6DbCphni1DemDS6pY8EsY0dM=;
        b=5E+PuZ9FBjNUoDNyksLDZVmf3ER3kLeYbtn0lcYWOMgTsi5bujk4NVXudfKt0vb2G3
         lTHqS0caYqGeVgZCXcf7EqduKMl1CSfCNipTLl+sHHf9DpAmjw/neJJblNp1tBRdq/kj
         MFsOhT0lUb4XQhLZ/wayX2G9CSteS9vkjF8GXFxqq9mwaDvaTSrUsdnJbkj2F0M6w5fd
         ZkYq1tOsuI/T2xIiznhMuWquvCXAgx4pj/Tc0v6WTzC8re1UiCV65a6dSdvL8TZgyIgd
         QyiSov2+IuJLTzLvxukvWM27zyr9axrC2XZpHTXiuyMvYlmFVII5N0W2qx+DBcvW+C7Y
         CZYQ==
X-Gm-Message-State: AOAM530iMr1G+O4emoylYn3UrAGDP1BWhLHzL67gKOVmlBeaRmW2XR8K
        xEVwNwk/L+OwBRP0s4E9QEHoOT32AvozRDlB
X-Google-Smtp-Source: ABdhPJwg12yRA+dX4huyak6vgoWyoM78Fo9kxLY4PCWxtcnON6q+pSvDsn05wghD+R/nkKJYtDa+ww==
X-Received: by 2002:a63:4722:0:b0:3a9:fd43:fce9 with SMTP id u34-20020a634722000000b003a9fd43fce9mr22046143pga.620.1651024472515;
        Tue, 26 Apr 2022 18:54:32 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p185-20020a62d0c2000000b0050d1f7c515esm13194998pfg.219.2022.04.26.18.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:54:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: check IOPOLL/ioprio support upfront
Date:   Tue, 26 Apr 2022 19:54:27 -0600
Message-Id: <20220427015428.322496-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427015428.322496-1-axboe@kernel.dk>
References: <20220427015428.322496-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't punt this check to the op prep handlers, add the support to
io_op_defs and we can check them while setting up the request.

This reduces the text size by 500 bytes on aarch64, and makes this less
fragile by having the check in one spot and needing opcodes to opt in
to IOPOLL or ioprio support.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 148 ++++++++++++++++++--------------------------------
 1 file changed, 52 insertions(+), 96 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f1a9595ba4c2..39325e469738 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1028,6 +1028,10 @@ struct io_op_def {
 	unsigned		not_supported : 1;
 	/* skip auditing */
 	unsigned		audit_skip : 1;
+	/* supports ioprio */
+	unsigned		ioprio : 1;
+	/* supports iopoll */
+	unsigned		iopoll : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
 };
@@ -1042,6 +1046,8 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_async_setup	= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITEV] = {
@@ -1052,6 +1058,8 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_async_setup	= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_FSYNC] = {
@@ -1064,6 +1072,8 @@ static const struct io_op_def io_op_defs[] = {
 		.pollin			= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITE_FIXED] = {
@@ -1073,6 +1083,8 @@ static const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_POLL_ADD] = {
@@ -1137,6 +1149,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_CLOSE] = {},
 	[IORING_OP_FILES_UPDATE] = {
 		.audit_skip		= 1,
+		.iopoll			= 1,
 	},
 	[IORING_OP_STATX] = {
 		.audit_skip		= 1,
@@ -1148,6 +1161,8 @@ static const struct io_op_def io_op_defs[] = {
 		.buffer_select		= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITE] = {
@@ -1157,6 +1172,8 @@ static const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.plug			= 1,
 		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_FADVISE] = {
@@ -1191,9 +1208,11 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {
 		.audit_skip		= 1,
+		.iopoll			= 1,
 	},
 	[IORING_OP_REMOVE_BUFFERS] = {
 		.audit_skip		= 1,
+		.iopoll			= 1,
 	},
 	[IORING_OP_TEE] = {
 		.needs_file		= 1,
@@ -1211,6 +1230,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_LINKAT] = {},
 	[IORING_OP_MSG_RING] = {
 		.needs_file		= 1,
+		.iopoll			= 1,
 	},
 };
 
@@ -4139,9 +4159,7 @@ static int io_renameat_prep(struct io_kiocb *req,
 	struct io_rename *ren = &req->rename;
 	const char __user *oldf, *newf;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -4190,10 +4208,7 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 	struct io_unlink *un = &req->unlink;
 	const char __user *fname;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index ||
-	    sqe->splice_fd_in)
+	if (sqe->off || sqe->len || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -4239,10 +4254,7 @@ static int io_mkdirat_prep(struct io_kiocb *req,
 	struct io_mkdir *mkd = &req->mkdir;
 	const char __user *fname;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->rw_flags || sqe->buf_index ||
-	    sqe->splice_fd_in)
+	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -4282,10 +4294,7 @@ static int io_symlinkat_prep(struct io_kiocb *req,
 	struct io_symlink *sl = &req->symlink;
 	const char __user *oldpath, *newpath;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->rw_flags || sqe->buf_index ||
-	    sqe->splice_fd_in)
+	if (sqe->len || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -4331,9 +4340,7 @@ static int io_linkat_prep(struct io_kiocb *req,
 	struct io_hardlink *lnk = &req->hardlink;
 	const char __user *oldf, *newf;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -4380,9 +4387,7 @@ static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_NET)
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->ioprio || sqe->off || sqe->addr || sqe->rw_flags ||
+	if (unlikely(sqe->off || sqe->addr || sqe->rw_flags ||
 		     sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 
@@ -4422,9 +4427,6 @@ static int __io_splice_prep(struct io_kiocb *req,
 	struct io_splice *sp = &req->splice;
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
 	if (unlikely(sp->flags & ~valid_flags))
@@ -4523,11 +4525,6 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
  */
 static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	__io_req_complete(req, issue_flags, 0, 0);
 	return 0;
 }
@@ -4535,8 +4532,8 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 static int io_msg_ring_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->rw_flags ||
-		     sqe->splice_fd_in || sqe->buf_index || sqe->personality))
+	if (unlikely(sqe->addr || sqe->rw_flags || sqe->splice_fd_in ||
+		     sqe->buf_index || sqe->personality))
 		return -EINVAL;
 
 	req->msg.user_data = READ_ONCE(sqe->off);
@@ -4577,12 +4574,7 @@ static int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
-		     sqe->splice_fd_in))
+	if (unlikely(sqe->addr || sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.flags = READ_ONCE(sqe->fsync_flags);
@@ -4615,10 +4607,7 @@ static int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 static int io_fallocate_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags ||
-	    sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
@@ -4649,9 +4638,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->buf_index))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -4783,7 +4770,7 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
+	if (sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
 	    sqe->splice_fd_in)
 		return -EINVAL;
 
@@ -4850,7 +4837,7 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
+	if (sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -4980,9 +4967,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_EPOLL)
-	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->epoll.epfd = READ_ONCE(sqe->fd);
@@ -5026,9 +5011,7 @@ static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->madvise.addr = READ_ONCE(sqe->addr);
@@ -5061,9 +5044,7 @@ static int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->addr || sqe->splice_fd_in)
-		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->fadvise.offset = READ_ONCE(sqe->off);
@@ -5099,9 +5080,7 @@ static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	const char __user *path;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -5146,10 +5125,7 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
-	    sqe->rw_flags || sqe->buf_index)
+	if (sqe->off || sqe->addr || sqe->len || sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -5215,12 +5191,7 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
-		     sqe->splice_fd_in))
+	if (unlikely(sqe->addr || sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
@@ -5298,8 +5269,6 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
 	if (unlikely(sqe->addr2 || sqe->file_index))
 		return -EINVAL;
 
@@ -5533,8 +5502,6 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
 	if (unlikely(sqe->addr2 || sqe->file_index))
 		return -EINVAL;
 
@@ -5692,9 +5659,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = &req->accept;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->len || sqe->buf_index)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -5760,10 +5725,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = &req->connect;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags ||
-	    sqe->splice_fd_in)
+	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -6446,9 +6408,7 @@ static int io_poll_update_prep(struct io_kiocb *req,
 	struct io_poll_update *upd = &req->poll_update;
 	u32 flags;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
 	if (flags & ~(IORING_POLL_UPDATE_EVENTS | IORING_POLL_UPDATE_USER_DATA |
@@ -6478,9 +6438,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	struct io_poll_iocb *poll = &req->poll;
 	u32 flags;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->addr)
+	if (sqe->buf_index || sqe->off || sqe->addr)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->len);
 	if (flags & ~IORING_POLL_ADD_MULTI)
@@ -6687,11 +6645,9 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 {
 	struct io_timeout_rem *tr = &req->timeout_rem;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tr->ltimeout = false;
@@ -6761,10 +6717,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	unsigned flags;
 	u32 off = READ_ONCE(sqe->off);
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len != 1 ||
-	    sqe->splice_fd_in)
+	if (sqe->buf_index || sqe->len != 1 || sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)
 		return -EINVAL;
@@ -6946,11 +6899,9 @@ static int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 static int io_async_cancel_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->splice_fd_in)
+	if (sqe->off || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
@@ -7036,7 +6987,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
+	if (sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->rsrc_update.offset = READ_ONCE(sqe->off);
@@ -7849,6 +7800,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		}
 	}
 
+	if (!io_op_defs[opcode].ioprio && sqe->ioprio)
+		return -EINVAL;
+	if (!io_op_defs[opcode].iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
 	if (io_op_defs[opcode].needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
 
-- 
2.35.1

