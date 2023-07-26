Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC54D7633A3
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 12:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbjGZK1W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 06:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbjGZK1D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 06:27:03 -0400
Received: from out-52.mta1.migadu.com (out-52.mta1.migadu.com [IPv6:2001:41d0:203:375::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F322693
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 03:26:54 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690367212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AIwkwyyOL4dDQylwCuzd8varDzvojejFt1MW7yy46Fo=;
        b=W5LXT952/mTYofbLKoAITkAYWh3kf3RddWb4B/Ld8Mct10G7vgOyX8zIJrQyqP00Sml7eR
        ehvm6KsBP0sfwmI2AzHE52Fm3pGaMsIc4CRBs/fJ7rHayUnM8Gn9UYwTvUlThHNZMCFYt9
        tcVA8ihaRusHPt5NWeVN7U14OV9HphI=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 7/7] add lseek for io_uring
Date:   Wed, 26 Jul 2023 18:26:03 +0800
Message-Id: <20230726102603.155522-8-hao.xu@linux.dev>
In-Reply-To: <20230726102603.155522-1-hao.xu@linux.dev>
References: <20230726102603.155522-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

This is related with previous io_uring getdents patchset, we need a way
to rewind the cursor of file when it comes to the end of a file by
getdents. Introduce lseek to io_uring for this, besides, it's also a
common syscall users call. So it's good for coding consistency when
users use io_uring as their main loop.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/fs.c                 | 63 +++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |  3 ++
 io_uring/opdef.c              |  8 +++++
 4 files changed, 75 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c3efe241e310..d445876d4afc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -236,6 +236,7 @@ enum io_uring_op {
 	IORING_OP_SEND_ZC,
 	IORING_OP_SENDMSG_ZC,
 	IORING_OP_GETDENTS,
+	IORING_OP_LSEEK,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/fs.c b/io_uring/fs.c
index 793eceb562a7..3992a19195ff 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -53,6 +53,12 @@ struct io_getdents {
 	unsigned int			count;
 };
 
+struct io_lseek {
+	struct file			*file;
+	off_t				offset;
+	unsigned int			whence;
+};
+
 int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
@@ -348,3 +354,60 @@ int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+int io_lseek_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_lseek *lsk = io_kiocb_to_cmd(req, struct io_lseek);
+
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	lsk->offset = READ_ONCE(sqe->addr);
+	lsk->whence = READ_ONCE(sqe->len);
+
+	return 0;
+}
+
+int io_lseek(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_lseek *lsk = io_kiocb_to_cmd(req, struct io_lseek);
+	struct file *file = req->file;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	bool should_lock = file->f_mode & FMODE_ATOMIC_POS;
+	unsigned int whence = lsk->whence;
+	loff_t res;
+	off_t ret;
+
+	if (whence > SEEK_MAX)
+		return -EINVAL;
+
+	if (force_nonblock) {
+		if (!(file->f_flags & O_NONBLOCK) &&
+		    !(file->f_mode & FMODE_NOWAIT))
+			return -EAGAIN;
+	}
+
+	if (should_lock) {
+		if (!force_nonblock)
+			mutex_lock(&file->f_pos_lock);
+		else if (!mutex_trylock(&file->f_pos_lock))
+			return -EAGAIN;
+	}
+
+	res = vfs_lseek_nowait(file, lsk->offset, whence, force_nonblock);
+	if (res == -EAGAIN && force_nonblock) {
+		if (should_lock)
+			mutex_unlock(&file->f_pos_lock);
+		return -EAGAIN;
+	}
+
+	ret = res;
+	if (res != (loff_t)ret)
+		ret = -EOVERFLOW;
+
+	if (should_lock)
+		mutex_unlock(&file->f_pos_lock);
+
+	io_req_set_res(req, ret, 0);
+	return 0;
+}
+
diff --git a/io_uring/fs.h b/io_uring/fs.h
index f83a6f3a678d..32a8441c5142 100644
--- a/io_uring/fs.h
+++ b/io_uring/fs.h
@@ -21,3 +21,6 @@ void io_link_cleanup(struct io_kiocb *req);
 
 int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_getdents(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_lseek_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_lseek(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 1bae6b2a8d0b..eb1f7ee4f079 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -433,6 +433,11 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_getdents_prep,
 		.issue			= io_getdents,
 	},
+	[IORING_OP_LSEEK] = {
+		.needs_file		= 1,
+		.prep			= io_lseek_prep,
+		.issue			= io_lseek,
+	},
 };
 
 
@@ -656,6 +661,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_GETDENTS] = {
 		.name			= "GETDENTS",
 	},
+	[IORING_OP_LSEEK] = {
+		.name			= "LSEEK",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.25.1

