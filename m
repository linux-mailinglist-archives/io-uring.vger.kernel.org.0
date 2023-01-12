Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839CF66785E
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 15:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240082AbjALO6l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 09:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbjALO6F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 09:58:05 -0500
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42815631BF;
        Thu, 12 Jan 2023 06:44:34 -0800 (PST)
Received: by mail-ej1-f50.google.com with SMTP id qk9so45323314ejc.3;
        Thu, 12 Jan 2023 06:44:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hgo5uu2APij7YO5lNSrXX/Q5O7LXn9huyjdHNDdm8QU=;
        b=aWE8xL7QuitK/cbs8WUL2vWtMY/Hp6A5LkjpZF1J+2/e8KZ7mqXFKeP04BAmxuzBi8
         TOFyYAwqvSbFqNREtY5X1XcbORlHnYu9A/POy4tWVWPIsvm6R3tnknfYHXr3nOuV2f+5
         rfh+68P4YCdVOVxXDOQeAu09qz622bE1s0GL/8M6KpYDHf8R4/6ySca/zaSIxgPfyLqR
         RT4o7rUZdJ+rzJAj2ELGyNqx39i1H6AGC0FlvK1s3r+agm8OwcTdK57iYxdJwCiGsY/U
         uvZ/CALSshY2eZr8RTzb7vcU144owuqLpxZc4TcxxLBzAXvxS4I36EZxZJaaPwxTAAI7
         CwhQ==
X-Gm-Message-State: AFqh2koZG4fsnqVjjkSSO8L72GTW+y8rLXZiSvkDMz387RcxXFC6dubF
        1VNAd2zAiJrVAQz5RVFYqXY=
X-Google-Smtp-Source: AMrXdXuIMDUmIL2kJ2PAsjcDg4B/JMxpTDE0Q6BQbPx+qFejx6d2PKOZBX02d4xj9hoJV+UBFRdynw==
X-Received: by 2002:a17:907:c78e:b0:7c1:23f7:623a with SMTP id tz14-20020a170907c78e00b007c123f7623amr63912823ejc.66.1673534672621;
        Thu, 12 Jan 2023 06:44:32 -0800 (PST)
Received: from localhost (fwdproxy-cln-022.fbsv.net. [2a03:2880:31ff:16::face:b00c])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906329100b007c0bb571da5sm7416961ejw.41.2023.01.12.06.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:44:32 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, dylany@meta.com, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     leitao@debian.org, leit@fb.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: Split io_issue_def struct
Date:   Thu, 12 Jan 2023 06:44:11 -0800
Message-Id: <20230112144411.2624698-2-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230112144411.2624698-1-leitao@debian.org>
References: <20230112144411.2624698-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch removes some "cold" fields from `struct io_issue_def`.

The plan is to keep only highly used fields into `struct io_issue_def`, so,
it may be hot in the cache. The hot fields are basically all the bitfields
and the callback functions for .issue and .prep.

The other less frequently used fields are now located in a secondary and
cold struct, called `io_cold_def`.

This is the size for the structs:

Before: io_issue_def = 56 bytes
After: io_issue_def = 24 bytes; io_cold_def = 40 bytes

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/io_uring.c |  15 +-
 io_uring/opdef.c    | 327 ++++++++++++++++++++++++++++++--------------
 io_uring/opdef.h    |   9 +-
 io_uring/rw.c       |   2 +-
 4 files changed, 238 insertions(+), 115 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ac7868ec9be2..0be66b026a7f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -980,7 +980,7 @@ void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	__must_hold(&ctx->uring_lock)
 {
-	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+	const struct io_cold_def *def = &io_cold_defs[req->opcode];
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
@@ -1708,8 +1708,8 @@ unsigned int io_file_get_flags(struct file *file)
 
 bool io_alloc_async_data(struct io_kiocb *req)
 {
-	WARN_ON_ONCE(!io_issue_defs[req->opcode].async_size);
-	req->async_data = kmalloc(io_issue_defs[req->opcode].async_size, GFP_KERNEL);
+	WARN_ON_ONCE(!io_cold_defs[req->opcode].async_size);
+	req->async_data = kmalloc(io_cold_defs[req->opcode].async_size, GFP_KERNEL);
 	if (req->async_data) {
 		req->flags |= REQ_F_ASYNC_DATA;
 		return false;
@@ -1719,20 +1719,21 @@ bool io_alloc_async_data(struct io_kiocb *req)
 
 int io_req_prep_async(struct io_kiocb *req)
 {
+	const struct io_cold_def *cdef = &io_cold_defs[req->opcode];
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 
 	/* assign early for deferred execution for non-fixed file */
 	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
 		req->file = io_file_get_normal(req, req->cqe.fd);
-	if (!def->prep_async)
+	if (!cdef->prep_async)
 		return 0;
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
-	if (!io_issue_defs[req->opcode].manual_alloc) {
+	if (!def->manual_alloc) {
 		if (io_alloc_async_data(req))
 			return -EAGAIN;
 	}
-	return def->prep_async(req);
+	return cdef->prep_async(req);
 }
 
 static u32 io_get_sequence(struct io_kiocb *req)
@@ -1801,7 +1802,7 @@ static void io_clean_op(struct io_kiocb *req)
 	}
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
-		const struct io_issue_def *def = &io_issue_defs[req->opcode];
+		const struct io_cold_def *def = &io_cold_defs[req->opcode];
 
 		if (def->cleanup)
 			def->cleanup(req);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3c95e70a625e..5238ecd7af6a 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -50,7 +50,6 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_NOP] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
-		.name			= "NOP",
 		.prep			= io_nop_prep,
 		.issue			= io_nop,
 	},
@@ -64,13 +63,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.async_size		= sizeof(struct io_async_rw),
-		.name			= "READV",
 		.prep			= io_prep_rw,
 		.issue			= io_read,
-		.prep_async		= io_readv_prep_async,
-		.cleanup		= io_readv_writev_cleanup,
-		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITEV] = {
 		.needs_file		= 1,
@@ -82,18 +76,12 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.async_size		= sizeof(struct io_async_rw),
-		.name			= "WRITEV",
 		.prep			= io_prep_rw,
 		.issue			= io_write,
-		.prep_async		= io_writev_prep_async,
-		.cleanup		= io_readv_writev_cleanup,
-		.fail			= io_rw_fail,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
-		.name			= "FSYNC",
 		.prep			= io_fsync_prep,
 		.issue			= io_fsync,
 	},
@@ -106,11 +94,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.async_size		= sizeof(struct io_async_rw),
-		.name			= "READ_FIXED",
 		.prep			= io_prep_rw,
 		.issue			= io_read,
-		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
@@ -122,30 +107,24 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.async_size		= sizeof(struct io_async_rw),
-		.name			= "WRITE_FIXED",
 		.prep			= io_prep_rw,
 		.issue			= io_write,
-		.fail			= io_rw_fail,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
-		.name			= "POLL_ADD",
 		.prep			= io_poll_add_prep,
 		.issue			= io_poll_add,
 	},
 	[IORING_OP_POLL_REMOVE] = {
 		.audit_skip		= 1,
-		.name			= "POLL_REMOVE",
 		.prep			= io_poll_remove_prep,
 		.issue			= io_poll_remove,
 	},
 	[IORING_OP_SYNC_FILE_RANGE] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
-		.name			= "SYNC_FILE_RANGE",
 		.prep			= io_sfr_prep,
 		.issue			= io_sync_file_range,
 	},
@@ -155,14 +134,9 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
-		.name			= "SENDMSG",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
 		.issue			= io_sendmsg,
-		.prep_async		= io_sendmsg_prep_async,
-		.cleanup		= io_sendmsg_recvmsg_cleanup,
-		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
@@ -174,29 +148,21 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
-		.name			= "RECVMSG",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_recvmsg_prep,
 		.issue			= io_recvmsg,
-		.prep_async		= io_recvmsg_prep_async,
-		.cleanup		= io_sendmsg_recvmsg_cleanup,
-		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 	[IORING_OP_TIMEOUT] = {
 		.audit_skip		= 1,
-		.async_size		= sizeof(struct io_timeout_data),
-		.name			= "TIMEOUT",
 		.prep			= io_timeout_prep,
 		.issue			= io_timeout,
 	},
 	[IORING_OP_TIMEOUT_REMOVE] = {
 		/* used by timeout updates' prep() */
 		.audit_skip		= 1,
-		.name			= "TIMEOUT_REMOVE",
 		.prep			= io_timeout_remove_prep,
 		.issue			= io_timeout_remove,
 	},
@@ -206,7 +172,6 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollin			= 1,
 		.poll_exclusive		= 1,
 		.ioprio			= 1,	/* used for flags */
-		.name			= "ACCEPT",
 #if defined(CONFIG_NET)
 		.prep			= io_accept_prep,
 		.issue			= io_accept,
@@ -216,14 +181,11 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_ASYNC_CANCEL] = {
 		.audit_skip		= 1,
-		.name			= "ASYNC_CANCEL",
 		.prep			= io_async_cancel_prep,
 		.issue			= io_async_cancel,
 	},
 	[IORING_OP_LINK_TIMEOUT] = {
 		.audit_skip		= 1,
-		.async_size		= sizeof(struct io_timeout_data),
-		.name			= "LINK_TIMEOUT",
 		.prep			= io_link_timeout_prep,
 		.issue			= io_no_issue,
 	},
@@ -231,46 +193,36 @@ const struct io_issue_def io_issue_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.name			= "CONNECT",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_connect),
 		.prep			= io_connect_prep,
 		.issue			= io_connect,
-		.prep_async		= io_connect_prep_async,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
-		.name			= "FALLOCATE",
 		.prep			= io_fallocate_prep,
 		.issue			= io_fallocate,
 	},
 	[IORING_OP_OPENAT] = {
-		.name			= "OPENAT",
 		.prep			= io_openat_prep,
 		.issue			= io_openat,
-		.cleanup		= io_open_cleanup,
 	},
 	[IORING_OP_CLOSE] = {
-		.name			= "CLOSE",
 		.prep			= io_close_prep,
 		.issue			= io_close,
 	},
 	[IORING_OP_FILES_UPDATE] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
-		.name			= "FILES_UPDATE",
 		.prep			= io_files_update_prep,
 		.issue			= io_files_update,
 	},
 	[IORING_OP_STATX] = {
 		.audit_skip		= 1,
-		.name			= "STATX",
 		.prep			= io_statx_prep,
 		.issue			= io_statx,
-		.cleanup		= io_statx_cleanup,
 	},
 	[IORING_OP_READ] = {
 		.needs_file		= 1,
@@ -282,11 +234,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.async_size		= sizeof(struct io_async_rw),
-		.name			= "READ",
 		.prep			= io_prep_rw,
 		.issue			= io_read,
-		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_file		= 1,
@@ -298,21 +247,16 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.async_size		= sizeof(struct io_async_rw),
-		.name			= "WRITE",
 		.prep			= io_prep_rw,
 		.issue			= io_write,
-		.fail			= io_rw_fail,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
-		.name			= "FADVISE",
 		.prep			= io_fadvise_prep,
 		.issue			= io_fadvise,
 	},
 	[IORING_OP_MADVISE] = {
-		.name			= "MADVISE",
 		.prep			= io_madvise_prep,
 		.issue			= io_madvise,
 	},
@@ -323,13 +267,9 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
-		.name			= "SEND",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
 		.issue			= io_send,
-		.fail			= io_sendrecv_fail,
-		.prep_async		= io_send_prep_async,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
@@ -341,25 +281,20 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
-		.name			= "RECV",
 #if defined(CONFIG_NET)
 		.prep			= io_recvmsg_prep,
 		.issue			= io_recv,
-		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 	[IORING_OP_OPENAT2] = {
-		.name			= "OPENAT2",
 		.prep			= io_openat2_prep,
 		.issue			= io_openat2,
-		.cleanup		= io_open_cleanup,
 	},
 	[IORING_OP_EPOLL_CTL] = {
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
-		.name			= "EPOLL",
 #if defined(CONFIG_EPOLL)
 		.prep			= io_epoll_ctl_prep,
 		.issue			= io_epoll_ctl,
@@ -372,21 +307,18 @@ const struct io_issue_def io_issue_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
-		.name			= "SPLICE",
 		.prep			= io_splice_prep,
 		.issue			= io_splice,
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
-		.name			= "PROVIDE_BUFFERS",
 		.prep			= io_provide_buffers_prep,
 		.issue			= io_provide_buffers,
 	},
 	[IORING_OP_REMOVE_BUFFERS] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
-		.name			= "REMOVE_BUFFERS",
 		.prep			= io_remove_buffers_prep,
 		.issue			= io_remove_buffers,
 	},
@@ -395,13 +327,11 @@ const struct io_issue_def io_issue_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
-		.name			= "TEE",
 		.prep			= io_tee_prep,
 		.issue			= io_tee,
 	},
 	[IORING_OP_SHUTDOWN] = {
 		.needs_file		= 1,
-		.name			= "SHUTDOWN",
 #if defined(CONFIG_NET)
 		.prep			= io_shutdown_prep,
 		.issue			= io_shutdown,
@@ -410,72 +340,51 @@ const struct io_issue_def io_issue_defs[] = {
 #endif
 	},
 	[IORING_OP_RENAMEAT] = {
-		.name			= "RENAMEAT",
 		.prep			= io_renameat_prep,
 		.issue			= io_renameat,
-		.cleanup		= io_renameat_cleanup,
 	},
 	[IORING_OP_UNLINKAT] = {
-		.name			= "UNLINKAT",
 		.prep			= io_unlinkat_prep,
 		.issue			= io_unlinkat,
-		.cleanup		= io_unlinkat_cleanup,
 	},
 	[IORING_OP_MKDIRAT] = {
-		.name			= "MKDIRAT",
 		.prep			= io_mkdirat_prep,
 		.issue			= io_mkdirat,
-		.cleanup		= io_mkdirat_cleanup,
 	},
 	[IORING_OP_SYMLINKAT] = {
-		.name			= "SYMLINKAT",
 		.prep			= io_symlinkat_prep,
 		.issue			= io_symlinkat,
-		.cleanup		= io_link_cleanup,
 	},
 	[IORING_OP_LINKAT] = {
-		.name			= "LINKAT",
 		.prep			= io_linkat_prep,
 		.issue			= io_linkat,
-		.cleanup		= io_link_cleanup,
 	},
 	[IORING_OP_MSG_RING] = {
 		.needs_file		= 1,
 		.iopoll			= 1,
-		.name			= "MSG_RING",
 		.prep			= io_msg_ring_prep,
 		.issue			= io_msg_ring,
-		.cleanup		= io_msg_ring_cleanup,
 	},
 	[IORING_OP_FSETXATTR] = {
 		.needs_file = 1,
-		.name			= "FSETXATTR",
 		.prep			= io_fsetxattr_prep,
 		.issue			= io_fsetxattr,
-		.cleanup		= io_xattr_cleanup,
 	},
 	[IORING_OP_SETXATTR] = {
-		.name			= "SETXATTR",
 		.prep			= io_setxattr_prep,
 		.issue			= io_setxattr,
-		.cleanup		= io_xattr_cleanup,
 	},
 	[IORING_OP_FGETXATTR] = {
 		.needs_file = 1,
-		.name			= "FGETXATTR",
 		.prep			= io_fgetxattr_prep,
 		.issue			= io_fgetxattr,
-		.cleanup		= io_xattr_cleanup,
 	},
 	[IORING_OP_GETXATTR] = {
-		.name			= "GETXATTR",
 		.prep			= io_getxattr_prep,
 		.issue			= io_getxattr,
-		.cleanup		= io_xattr_cleanup,
 	},
 	[IORING_OP_SOCKET] = {
 		.audit_skip		= 1,
-		.name			= "SOCKET",
 #if defined(CONFIG_NET)
 		.prep			= io_socket_prep,
 		.issue			= io_socket,
@@ -486,16 +395,12 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_URING_CMD] = {
 		.needs_file		= 1,
 		.plug			= 1,
-		.name			= "URING_CMD",
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.async_size		= uring_cmd_pdu_size(1),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
-		.prep_async		= io_uring_cmd_prep_async,
 	},
 	[IORING_OP_SEND_ZC] = {
-		.name			= "SEND_ZC",
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
@@ -503,32 +408,243 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_send_zc_prep,
 		.issue			= io_send_zc,
-		.prep_async		= io_send_prep_async,
-		.cleanup		= io_send_zc_cleanup,
-		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 	[IORING_OP_SENDMSG_ZC] = {
-		.name			= "SENDMSG_ZC",
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_send_zc_prep,
 		.issue			= io_sendmsg_zc,
+#else
+		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+};
+
+
+const struct io_cold_def io_cold_defs[] = {
+	[IORING_OP_NOP] = {
+		.name			= "NOP",
+	},
+	[IORING_OP_READV] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "READV",
+		.prep_async		= io_readv_prep_async,
+		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_WRITEV] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "WRITEV",
+		.prep_async		= io_writev_prep_async,
+		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_FSYNC] = {
+		.name			= "FSYNC",
+	},
+	[IORING_OP_READ_FIXED] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "READ_FIXED",
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_WRITE_FIXED] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "WRITE_FIXED",
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_POLL_ADD] = {
+		.name			= "POLL_ADD",
+	},
+	[IORING_OP_POLL_REMOVE] = {
+		.name			= "POLL_REMOVE",
+	},
+	[IORING_OP_SYNC_FILE_RANGE] = {
+		.name			= "SYNC_FILE_RANGE",
+	},
+	[IORING_OP_SENDMSG] = {
+		.name			= "SENDMSG",
+#if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
+		.prep_async		= io_sendmsg_prep_async,
+		.cleanup		= io_sendmsg_recvmsg_cleanup,
+		.fail			= io_sendrecv_fail,
+#endif
+	},
+	[IORING_OP_RECVMSG] = {
+		.name			= "RECVMSG",
+#if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
+		.prep_async		= io_recvmsg_prep_async,
+		.cleanup		= io_sendmsg_recvmsg_cleanup,
+		.fail			= io_sendrecv_fail,
+#endif
+	},
+	[IORING_OP_TIMEOUT] = {
+		.async_size		= sizeof(struct io_timeout_data),
+		.name			= "TIMEOUT",
+	},
+	[IORING_OP_TIMEOUT_REMOVE] = {
+		.name			= "TIMEOUT_REMOVE",
+	},
+	[IORING_OP_ACCEPT] = {
+		.name			= "ACCEPT",
+	},
+	[IORING_OP_ASYNC_CANCEL] = {
+		.name			= "ASYNC_CANCEL",
+	},
+	[IORING_OP_LINK_TIMEOUT] = {
+		.async_size		= sizeof(struct io_timeout_data),
+		.name			= "LINK_TIMEOUT",
+	},
+	[IORING_OP_CONNECT] = {
+		.name			= "CONNECT",
+#if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_connect),
+		.prep_async		= io_connect_prep_async,
+#endif
+	},
+	[IORING_OP_FALLOCATE] = {
+		.name			= "FALLOCATE",
+	},
+	[IORING_OP_OPENAT] = {
+		.name			= "OPENAT",
+		.cleanup		= io_open_cleanup,
+	},
+	[IORING_OP_CLOSE] = {
+		.name			= "CLOSE",
+	},
+	[IORING_OP_FILES_UPDATE] = {
+		.name			= "FILES_UPDATE",
+	},
+	[IORING_OP_STATX] = {
+		.name			= "STATX",
+		.cleanup		= io_statx_cleanup,
+	},
+	[IORING_OP_READ] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "READ",
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_WRITE] = {
+		.async_size		= sizeof(struct io_async_rw),
+		.name			= "WRITE",
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_FADVISE] = {
+		.name			= "FADVISE",
+	},
+	[IORING_OP_MADVISE] = {
+		.name			= "MADVISE",
+	},
+	[IORING_OP_SEND] = {
+		.name			= "SEND",
+#if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
+		.fail			= io_sendrecv_fail,
+		.prep_async		= io_send_prep_async,
+#endif
+	},
+	[IORING_OP_RECV] = {
+		.name			= "RECV",
+#if defined(CONFIG_NET)
+		.fail			= io_sendrecv_fail,
+#endif
+	},
+	[IORING_OP_OPENAT2] = {
+		.name			= "OPENAT2",
+		.cleanup		= io_open_cleanup,
+	},
+	[IORING_OP_EPOLL_CTL] = {
+		.name			= "EPOLL",
+	},
+	[IORING_OP_SPLICE] = {
+		.name			= "SPLICE",
+	},
+	[IORING_OP_PROVIDE_BUFFERS] = {
+		.name			= "PROVIDE_BUFFERS",
+	},
+	[IORING_OP_REMOVE_BUFFERS] = {
+		.name			= "REMOVE_BUFFERS",
+	},
+	[IORING_OP_TEE] = {
+		.name			= "TEE",
+	},
+	[IORING_OP_SHUTDOWN] = {
+		.name			= "SHUTDOWN",
+	},
+	[IORING_OP_RENAMEAT] = {
+		.name			= "RENAMEAT",
+		.cleanup		= io_renameat_cleanup,
+	},
+	[IORING_OP_UNLINKAT] = {
+		.name			= "UNLINKAT",
+		.cleanup		= io_unlinkat_cleanup,
+	},
+	[IORING_OP_MKDIRAT] = {
+		.name			= "MKDIRAT",
+		.cleanup		= io_mkdirat_cleanup,
+	},
+	[IORING_OP_SYMLINKAT] = {
+		.name			= "SYMLINKAT",
+		.cleanup		= io_link_cleanup,
+	},
+	[IORING_OP_LINKAT] = {
+		.name			= "LINKAT",
+		.cleanup		= io_link_cleanup,
+	},
+	[IORING_OP_MSG_RING] = {
+		.name			= "MSG_RING",
+		.cleanup		= io_msg_ring_cleanup,
+	},
+	[IORING_OP_FSETXATTR] = {
+		.name			= "FSETXATTR",
+		.cleanup		= io_xattr_cleanup,
+	},
+	[IORING_OP_SETXATTR] = {
+		.name			= "SETXATTR",
+		.cleanup		= io_xattr_cleanup,
+	},
+	[IORING_OP_FGETXATTR] = {
+		.name			= "FGETXATTR",
+		.cleanup		= io_xattr_cleanup,
+	},
+	[IORING_OP_GETXATTR] = {
+		.name			= "GETXATTR",
+		.cleanup		= io_xattr_cleanup,
+	},
+	[IORING_OP_SOCKET] = {
+		.name			= "SOCKET",
+	},
+	[IORING_OP_URING_CMD] = {
+		.name			= "URING_CMD",
+		.async_size		= uring_cmd_pdu_size(1),
+		.prep_async		= io_uring_cmd_prep_async,
+	},
+	[IORING_OP_SEND_ZC] = {
+		.name			= "SEND_ZC",
+#if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
+		.prep_async		= io_send_prep_async,
+		.cleanup		= io_send_zc_cleanup,
+		.fail			= io_sendrecv_fail,
+#endif
+	},
+	[IORING_OP_SENDMSG_ZC] = {
+		.name			= "SENDMSG_ZC",
+#if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep_async		= io_sendmsg_prep_async,
 		.cleanup		= io_send_zc_cleanup,
 		.fail			= io_sendrecv_fail,
-#else
-		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 };
@@ -536,7 +652,7 @@ const struct io_issue_def io_issue_defs[] = {
 const char *io_uring_get_opcode(u8 opcode)
 {
 	if (opcode < IORING_OP_LAST)
-		return io_issue_defs[opcode].name;
+		return io_cold_defs[opcode].name;
 	return "INVALID";
 }
 
@@ -544,12 +660,13 @@ void __init io_uring_optable_init(void)
 {
 	int i;
 
+	BUILD_BUG_ON(ARRAY_SIZE(io_cold_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(ARRAY_SIZE(io_issue_defs) != IORING_OP_LAST);
 
 	for (i = 0; i < ARRAY_SIZE(io_issue_defs); i++) {
 		BUG_ON(!io_issue_defs[i].prep);
 		if (io_issue_defs[i].prep != io_eopnotsupp_prep)
 			BUG_ON(!io_issue_defs[i].issue);
-		WARN_ON_ONCE(!io_issue_defs[i].name);
+		WARN_ON_ONCE(!io_cold_defs[i].name);
 	}
 }
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index d718e2ab1ff7..c22c8696e749 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -29,19 +29,24 @@ struct io_issue_def {
 	unsigned		iopoll_queue : 1;
 	/* opcode specific path will handle ->async_data allocation if needed */
 	unsigned		manual_alloc : 1;
+
+	int (*issue)(struct io_kiocb *, unsigned int);
+	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
+};
+
+struct io_cold_def {
 	/* size of async data needed, if any */
 	unsigned short		async_size;
 
 	const char		*name;
 
-	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
-	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep_async)(struct io_kiocb *);
 	void (*cleanup)(struct io_kiocb *);
 	void (*fail)(struct io_kiocb *);
 };
 
 extern const struct io_issue_def io_issue_defs[];
+extern const struct io_cold_def io_cold_defs[];
 
 void io_uring_optable_init(void);
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 54b44b9b736c..a8a2eb7ee27a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -516,7 +516,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     struct io_rw_state *s, bool force)
 {
-	if (!force && !io_issue_defs[req->opcode].prep_async)
+	if (!force && !io_cold_defs[req->opcode].prep_async)
 		return 0;
 	if (!req_has_async_data(req)) {
 		struct io_async_rw *iorw;
-- 
2.30.2

