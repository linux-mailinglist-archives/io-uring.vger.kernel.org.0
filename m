Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4938033FAC5
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhCQWK7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhCQWKf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:10:35 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08F5C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:34 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id x16so190430iob.1
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mlCtvo7lnB0iAIDh/6KjoQhNocbRJDB6XHzCDEgRB0w=;
        b=fU9Nrq8cIE72vpfIlhgUuwx9MC0tESqrlAxAXSLPJgynmr3bCkNd8noZEn94+qHmrX
         g9AgcaaORwbWIS0kcNkXrTc6AM0vhSPmg9j/xv/ekA70ETtb+okKP8gD94Lixdx0bKcU
         rHGbPs3ccBKYi9QEQYVJ+FAqjruZeQBnOqxu3s77F3xzDRy0mMwJiNUt3XF2wjQYp6Pf
         dwvN5wJtgp14rHR4Et6TZvIBYLDIdWxOKKD+1vn+NcpZ6n/Gvok0gKLImDMEmEgOYdm8
         grZoiVXPV6UBakadT2c03nlEV9U7y+6WmLrIZU9CuGtCjYZIxnXje8Y/71HkQsBokAP4
         docw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mlCtvo7lnB0iAIDh/6KjoQhNocbRJDB6XHzCDEgRB0w=;
        b=RXj7jba0vlFX8EFtc+zNvNxLqYAv45M1OyFES4ufjxtKFHJ2Z7s8UNa0R9oPArSFvI
         JyIQGGb904RI0pEATiPWOzcdsM60a5cwAz2SBZHth+btYOsYMpT13u8MdXPTGLoJDmuH
         RGxAbeyUU8hxRUqqdO0Bi91kJFNRF37EGdBIRki5xDCy/3Xiu4nV8N94g1ah/9IDAW0p
         vuJ6Nw2a2GydDOjcFbQgO1VTNvgEPxQ/+Ct8GpBHbQDJ6172jDXm+VWev3gzGcf4mbg6
         Hj2zsoP1dLNIjbqCCVHorIY4QeHXMah2AMZhUPZ+XHzoj2hgPr81xK5Cqqw928bTFDMH
         V73A==
X-Gm-Message-State: AOAM530IOsF+IUkTr8TMJ+alt+rDH+0vTfGjFiCFVMDfnCrNL0sGprP1
        88XKtQ8cM0HsXtgaGl5fHNE1+4FOkD/alA==
X-Google-Smtp-Source: ABdhPJzrqcljJAwZRk9AlgC4IvsN9M92EA+nzgGjKYMBnJK3aj5MHuhLqgSE3epnUfPK5gkWJtwUZg==
X-Received: by 2002:a6b:3c1a:: with SMTP id k26mr8272711iob.113.1616019033900;
        Wed, 17 Mar 2021 15:10:33 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm160700ilq.42.2021.03.17.15.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:10:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, hch@lst.de, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] io_uring: add infrastructure around io_uring_cmd_sqe issue type
Date:   Wed, 17 Mar 2021 16:10:21 -0600
Message-Id: <20210317221027.366780-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317221027.366780-1-axboe@kernel.dk>
References: <20210317221027.366780-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Define an io_uring_cmd_sqe struct that passthrough commands can use,
and define an array that has offset information for the two members
that we care about (user_data and personality). Then we can init the
two command types in basically the same way, just reading the user_data
and personality at the defined offsets for the command type.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 57 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h | 10 ++++++
 2 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 416e47832468..a4699b066172 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -824,6 +824,22 @@ struct io_defer_entry {
 	u32			seq;
 };
 
+struct sqe_offset {
+	unsigned char		user_data;
+	unsigned char		personality;
+};
+
+static struct sqe_offset sqe_offsets[] = {
+	{
+		.user_data	= offsetof(struct io_uring_sqe, user_data),
+		.personality	= offsetof(struct io_uring_sqe, personality)
+	},
+	{
+		.user_data	= offsetof(struct io_uring_cmd_sqe, user_data),
+		.personality	= offsetof(struct io_uring_cmd_sqe, personality)
+	}
+};
+
 struct io_op_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
@@ -844,6 +860,8 @@ struct io_op_def {
 	unsigned		plug : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
+	/* offset definition for user_data/personality */
+	unsigned short		offsets;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -988,6 +1006,9 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
+	[IORING_OP_URING_CMD] = {
+		.offsets		= 1,
+	},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -6384,16 +6405,21 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 }
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe)
+		       const struct io_uring_sqe_hdr *hdr)
 {
 	struct io_submit_state *state;
+	const struct io_op_def *def;
 	unsigned int sqe_flags;
+	const __u64 *uptr;
+	const __u16 *pptr;
 	int personality, ret = 0;
 
-	req->opcode = READ_ONCE(sqe->hdr.opcode);
+	req->opcode = READ_ONCE(hdr->opcode);
+	def = &io_op_defs[req->opcode];
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags = sqe_flags = READ_ONCE(sqe->hdr.flags);
-	req->user_data = READ_ONCE(sqe->user_data);
+	req->flags = sqe_flags = READ_ONCE(hdr->flags);
+	uptr = (const void *) hdr + sqe_offsets[def->offsets].user_data;
+	req->user_data = READ_ONCE(*uptr);
 	req->async_data = NULL;
 	req->file = NULL;
 	req->ctx = ctx;
@@ -6419,11 +6445,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(!io_check_restriction(ctx, req, sqe_flags)))
 		return -EACCES;
 
-	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-	    !io_op_defs[req->opcode].buffer_select)
+	if ((sqe_flags & IOSQE_BUFFER_SELECT) && !def->buffer_select)
 		return -EOPNOTSUPP;
 
-	personality = READ_ONCE(sqe->personality);
+	pptr = (const void *) hdr + sqe_offsets[def->offsets].personality;
+	personality = READ_ONCE(*pptr);
 	if (personality) {
 		req->work.creds = xa_load(&ctx->personalities, personality);
 		if (!req->work.creds)
@@ -6436,17 +6462,15 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * Plug now if we have more than 1 IO left after this, and the target
 	 * is potentially a read/write to block based storage.
 	 */
-	if (!state->plug_started && state->ios_left > 1 &&
-	    io_op_defs[req->opcode].plug) {
+	if (!state->plug_started && state->ios_left > 1 && def->plug) {
 		blk_start_plug(&state->plug);
 		state->plug_started = true;
 	}
 
-	if (io_op_defs[req->opcode].needs_file) {
+	if (def->needs_file) {
 		bool fixed = req->flags & REQ_F_FIXED_FILE;
 
-		req->file = io_file_get(state, req, READ_ONCE(sqe->hdr.fd),
-					fixed);
+		req->file = io_file_get(state, req, READ_ONCE(hdr->fd), fixed);
 		if (unlikely(!req->file))
 			ret = -EBADF;
 	}
@@ -6461,7 +6485,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	struct io_submit_link *link = &ctx->submit_state.link;
 	int ret;
 
-	ret = io_init_req(ctx, req, sqe);
+	ret = io_init_req(ctx, req, &sqe->hdr);
 	if (unlikely(ret)) {
 fail_req:
 		io_req_complete_failed(req, ret);
@@ -9915,6 +9939,7 @@ static int __init io_uring_init(void)
 #define BUILD_BUG_SQE_ELEM(eoffset, etype, ename) \
 	__BUILD_BUG_VERIFY_ELEMENT(struct io_uring_sqe, eoffset, etype, ename)
 	BUILD_BUG_ON(sizeof(struct io_uring_sqe) != 64);
+	BUILD_BUG_ON(sizeof(struct io_uring_cmd_sqe) != 64);
 	BUILD_BUG_SQE_ELEM(0,  __u8,   hdr.opcode);
 	BUILD_BUG_SQE_ELEM(1,  __u8,   hdr.flags);
 	BUILD_BUG_SQE_ELEM(2,  __u16,  hdr.ioprio);
@@ -9943,6 +9968,12 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
+#define BUILD_BUG_SQEC_ELEM(eoffset, etype, ename) \
+	__BUILD_BUG_VERIFY_ELEMENT(struct io_uring_cmd_sqe, eoffset, etype, ename)
+	BUILD_BUG_SQEC_ELEM(8,				__u64,	user_data);
+	BUILD_BUG_SQEC_ELEM(18,				__u16,	personality);
+	BUILD_BUG_SQEC_ELEM(sqe_offsets[1].user_data,	__u64,	user_data);
+	BUILD_BUG_SQEC_ELEM(sqe_offsets[1].personality,	__u16,	personality);
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5609474ccd9f..165ac406f00b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -74,6 +74,15 @@ struct io_uring_sqe {
 	};
 };
 
+struct io_uring_cmd_sqe {
+	struct io_uring_sqe_hdr	hdr;
+	__u64			user_data;
+	__u16			op;
+	__u16			personality;
+	__u32			len;
+	__u64			pdu[5];
+};
+
 enum {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,
@@ -148,6 +157,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_URING_CMD,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.31.0

