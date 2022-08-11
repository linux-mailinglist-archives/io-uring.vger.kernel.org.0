Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBDA58F827
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 09:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiHKHMT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 03:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKHMS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 03:12:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C563C8F95C
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 00:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=SlPNPYz5nwWWkqmeyWOnonRKanbr10Z8KB2kkWHGBbE=; b=hMI0hHSZ0xqxQ03gcv8m7tV8Ir
        2vj9vHSBhRbsKGo/PAob4rRNFMIQI+1x+befo0PITdDUAfrV2Icoj6vzMShx6b4k0vNCmhUvayb0G
        0BnRT2Ll1vRutnEu+Bf+ocB78RSD12SEgvaHkBl5IoR0Ye9lvDfKE6hIaC5AdRIx2xVXBDw+Jr+o1
        BkFJ8OwSk0OK5g//sR3SHsDSr/rcRkMC0MhrFUbEb2mZsgJvsiF+zBFgD8ePXkQgXAPxYeY8t6z3o
        PMw+ZsucIKBN9I1iLIlQ7HUqratL1bZ9PKuWnXTX6DjSFtVOvY7MOHsyP/KeMFEofMCDTndyYbjYC
        6HzgLfoUvCcGelsEzRnk+1LIovRlw4T+D8/VBU2lHHaG/H4KV9U1PkH3Zzs7h0lLDobgoGBpI4V1/
        fzdo7YtWtMlyUjzM4NyVpnBjOFBXiri9s9JIbAk5r74k7OmM6mRtJYHZRwqGLi4lj5DRvtPEYpJUY
        pHaW7cYHThAMHbPr5N+pUrYq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oM2MV-0099us-Ls; Thu, 11 Aug 2022 07:12:12 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 2/3] io_uring: make io_kiocb_to_cmd() typesafe
Date:   Thu, 11 Aug 2022 09:11:15 +0200
Message-Id: <c024cdf25ae19fc0319d4180e2298bade8ed17b8.1660201408.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660201408.git.metze@samba.org>
References: <cover.1660201408.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need to make sure (at build time) that struct io_cmd_data is not
casted to a structure that's larger.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/linux/io_uring_types.h |  9 +++++++-
 io_uring/advise.c              |  8 +++----
 io_uring/cancel.c              |  4 ++--
 io_uring/epoll.c               |  4 ++--
 io_uring/fs.c                  | 28 +++++++++++------------
 io_uring/kbuf.c                |  8 +++----
 io_uring/msg_ring.c            |  8 +++----
 io_uring/net.c                 | 42 +++++++++++++++++-----------------
 io_uring/notif.c               |  2 --
 io_uring/notif.h               |  2 +-
 io_uring/openclose.c           | 16 ++++++-------
 io_uring/poll.c                | 16 ++++++-------
 io_uring/rsrc.c                | 10 ++++----
 io_uring/rw.c                  | 28 +++++++++++------------
 io_uring/splice.c              |  8 +++----
 io_uring/statx.c               |  6 ++---
 io_uring/sync.c                | 12 +++++-----
 io_uring/timeout.c             | 26 ++++++++++-----------
 io_uring/uring_cmd.c           |  8 +++----
 io_uring/xattr.c               | 18 +++++++--------
 20 files changed, 134 insertions(+), 129 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index f7fab3758cb9..677a25d44d7f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -491,7 +491,14 @@ struct io_cmd_data {
 	__u8			data[56];
 };
 
-#define io_kiocb_to_cmd(req)	((void *) &(req)->cmd)
+static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
+{
+	BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
+}
+#define io_kiocb_to_cmd(req, cmd_type) ( \
+	io_kiocb_cmd_sz_check(sizeof(cmd_type)) , \
+	((cmd_type *)&(req)->cmd) \
+)
 #define cmd_to_io_kiocb(ptr)	((struct io_kiocb *) ptr)
 
 struct io_kiocb {
diff --git a/io_uring/advise.c b/io_uring/advise.c
index 581956934c0b..449c6f14649f 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -31,7 +31,7 @@ struct io_madvise {
 int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	struct io_madvise *ma = io_kiocb_to_cmd(req);
+	struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
 
 	if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
@@ -48,7 +48,7 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	struct io_madvise *ma = io_kiocb_to_cmd(req);
+	struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -64,7 +64,7 @@ int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_fadvise *fa = io_kiocb_to_cmd(req);
+	struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
 
 	if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
 		return -EINVAL;
@@ -77,7 +77,7 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_fadvise *fa = io_kiocb_to_cmd(req);
+	struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK) {
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 8435a1eba59a..e4e1dc0325f0 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -107,7 +107,7 @@ int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 
 int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_cancel *cancel = io_kiocb_to_cmd(req);
+	struct io_cancel *cancel = io_kiocb_to_cmd(req, struct io_cancel);
 
 	if (unlikely(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
@@ -164,7 +164,7 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_cancel *cancel = io_kiocb_to_cmd(req);
+	struct io_cancel *cancel = io_kiocb_to_cmd(req, struct io_cancel);
 	struct io_cancel_data cd = {
 		.ctx	= req->ctx,
 		.data	= cancel->addr,
diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index a8b794471d6b..9aa74d2c80bc 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -23,7 +23,7 @@ struct io_epoll {
 
 int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_epoll *epoll = io_kiocb_to_cmd(req);
+	struct io_epoll *epoll = io_kiocb_to_cmd(req, struct io_epoll);
 
 	pr_warn_once("%s: epoll_ctl support in io_uring is deprecated and will "
 		     "be removed in a future Linux kernel version.\n",
@@ -49,7 +49,7 @@ int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_epoll *ie = io_kiocb_to_cmd(req);
+	struct io_epoll *ie = io_kiocb_to_cmd(req, struct io_epoll);
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
diff --git a/io_uring/fs.c b/io_uring/fs.c
index 0de4f549bb7d..7100c293c13a 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -49,7 +49,7 @@ struct io_link {
 
 int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_rename *ren = io_kiocb_to_cmd(req);
+	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
 	const char __user *oldf, *newf;
 
 	if (sqe->buf_index || sqe->splice_fd_in)
@@ -79,7 +79,7 @@ int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_rename *ren = io_kiocb_to_cmd(req);
+	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -95,7 +95,7 @@ int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_renameat_cleanup(struct io_kiocb *req)
 {
-	struct io_rename *ren = io_kiocb_to_cmd(req);
+	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
 
 	putname(ren->oldpath);
 	putname(ren->newpath);
@@ -103,7 +103,7 @@ void io_renameat_cleanup(struct io_kiocb *req)
 
 int io_unlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_unlink *un = io_kiocb_to_cmd(req);
+	struct io_unlink *un = io_kiocb_to_cmd(req, struct io_unlink);
 	const char __user *fname;
 
 	if (sqe->off || sqe->len || sqe->buf_index || sqe->splice_fd_in)
@@ -128,7 +128,7 @@ int io_unlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_unlink *un = io_kiocb_to_cmd(req);
+	struct io_unlink *un = io_kiocb_to_cmd(req, struct io_unlink);
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -146,14 +146,14 @@ int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_unlinkat_cleanup(struct io_kiocb *req)
 {
-	struct io_unlink *ul = io_kiocb_to_cmd(req);
+	struct io_unlink *ul = io_kiocb_to_cmd(req, struct io_unlink);
 
 	putname(ul->filename);
 }
 
 int io_mkdirat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_mkdir *mkd = io_kiocb_to_cmd(req);
+	struct io_mkdir *mkd = io_kiocb_to_cmd(req, struct io_mkdir);
 	const char __user *fname;
 
 	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
@@ -175,7 +175,7 @@ int io_mkdirat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_mkdir *mkd = io_kiocb_to_cmd(req);
+	struct io_mkdir *mkd = io_kiocb_to_cmd(req, struct io_mkdir);
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -190,14 +190,14 @@ int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_mkdirat_cleanup(struct io_kiocb *req)
 {
-	struct io_mkdir *md = io_kiocb_to_cmd(req);
+	struct io_mkdir *md = io_kiocb_to_cmd(req, struct io_mkdir);
 
 	putname(md->filename);
 }
 
 int io_symlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_link *sl = io_kiocb_to_cmd(req);
+	struct io_link *sl = io_kiocb_to_cmd(req, struct io_link);
 	const char __user *oldpath, *newpath;
 
 	if (sqe->len || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
@@ -225,7 +225,7 @@ int io_symlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_link *sl = io_kiocb_to_cmd(req);
+	struct io_link *sl = io_kiocb_to_cmd(req, struct io_link);
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -240,7 +240,7 @@ int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_link *lnk = io_kiocb_to_cmd(req);
+	struct io_link *lnk = io_kiocb_to_cmd(req, struct io_link);
 	const char __user *oldf, *newf;
 
 	if (sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
@@ -270,7 +270,7 @@ int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_link *lnk = io_kiocb_to_cmd(req);
+	struct io_link *lnk = io_kiocb_to_cmd(req, struct io_link);
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -286,7 +286,7 @@ int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_link_cleanup(struct io_kiocb *req)
 {
-	struct io_link *sl = io_kiocb_to_cmd(req);
+	struct io_link *sl = io_kiocb_to_cmd(req, struct io_link);
 
 	putname(sl->oldpath);
 	putname(sl->newpath);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index a73f40a4cfe6..25cd724ade18 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -272,7 +272,7 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_provide_buf *p = io_kiocb_to_cmd(req);
+	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
 	u64 tmp;
 
 	if (sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
@@ -291,7 +291,7 @@ int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_provide_buf *p = io_kiocb_to_cmd(req);
+	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 	int ret = 0;
@@ -319,7 +319,7 @@ int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	unsigned long size, tmp_check;
-	struct io_provide_buf *p = io_kiocb_to_cmd(req);
+	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
 	u64 tmp;
 
 	if (sqe->rw_flags || sqe->splice_fd_in)
@@ -421,7 +421,7 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 
 int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_provide_buf *p = io_kiocb_to_cmd(req);
+	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 	int ret = 0;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 753d16734319..976c4ba68ee7 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -26,7 +26,7 @@ struct io_msg {
 static int io_msg_ring_data(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req);
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
@@ -76,7 +76,7 @@ static int io_double_lock_ctx(struct io_ring_ctx *ctx,
 static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
-	struct io_msg *msg = io_kiocb_to_cmd(req);
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long file_ptr;
 	struct file *src_file;
@@ -122,7 +122,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_msg *msg = io_kiocb_to_cmd(req);
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 
 	if (unlikely(sqe->buf_index || sqe->personality))
 		return -EINVAL;
@@ -141,7 +141,7 @@ int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_msg *msg = io_kiocb_to_cmd(req);
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	int ret;
 
 	ret = -EBADFD;
diff --git a/io_uring/net.c b/io_uring/net.c
index e6fc9748fbd2..6d71748e2c5a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -77,7 +77,7 @@ struct io_sendzc {
 
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_shutdown *shutdown = io_kiocb_to_cmd(req);
+	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
 
 	if (unlikely(sqe->off || sqe->addr || sqe->rw_flags ||
 		     sqe->buf_index || sqe->splice_fd_in))
@@ -89,7 +89,7 @@ int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_shutdown *shutdown = io_kiocb_to_cmd(req);
+	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
 	struct socket *sock;
 	int ret;
 
@@ -174,7 +174,7 @@ static int io_setup_async_msg(struct io_kiocb *req,
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	iomsg->msg.msg_name = &iomsg->addr;
 	iomsg->free_iov = iomsg->fast_iov;
@@ -201,7 +201,7 @@ void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
 
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -225,7 +225,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned flags;
@@ -284,7 +284,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
@@ -358,7 +358,7 @@ static bool io_recvmsg_multishot_overflow(struct io_async_msghdr *iomsg)
 static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 				 struct io_async_msghdr *iomsg)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct user_msghdr msg;
 	int ret;
 
@@ -405,7 +405,7 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 					struct io_async_msghdr *iomsg)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct compat_msghdr msg;
 	struct compat_iovec __user *uiov;
 	int ret;
@@ -483,7 +483,7 @@ int io_recvmsg_prep_async(struct io_kiocb *req)
 
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -518,7 +518,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static inline void io_recv_prep_retry(struct io_kiocb *req)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
 	sr->len = 0; /* get from the provided buffer */
@@ -647,7 +647,7 @@ static int io_recvmsg_multishot(struct socket *sock, struct io_sr_msg *io,
 
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned int cflags;
@@ -759,7 +759,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
 	struct socket *sock;
 	struct iovec iov;
@@ -850,7 +850,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_sendzc *zc = io_kiocb_to_cmd(req);
+	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3))
@@ -946,7 +946,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage address;
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_sendzc *zc = io_kiocb_to_cmd(req);
+	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
 	struct io_notif_slot *notif_slot;
 	struct io_kiocb *notif;
 	struct msghdr msg;
@@ -1037,7 +1037,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_accept *accept = io_kiocb_to_cmd(req);
+	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
 	unsigned flags;
 
 	if (sqe->len || sqe->buf_index)
@@ -1071,7 +1071,7 @@ int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_accept *accept = io_kiocb_to_cmd(req);
+	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
 	bool fixed = !!accept->file_slot;
@@ -1129,7 +1129,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_socket *sock = io_kiocb_to_cmd(req);
+	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
 
 	if (sqe->addr || sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
@@ -1150,7 +1150,7 @@ int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_socket(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_socket *sock = io_kiocb_to_cmd(req);
+	struct io_socket *sock = io_kiocb_to_cmd(req, struct io_socket);
 	bool fixed = !!sock->file_slot;
 	struct file *file;
 	int ret, fd;
@@ -1184,14 +1184,14 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags)
 int io_connect_prep_async(struct io_kiocb *req)
 {
 	struct io_async_connect *io = req->async_data;
-	struct io_connect *conn = io_kiocb_to_cmd(req);
+	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
 
 	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->address);
 }
 
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_connect *conn = io_kiocb_to_cmd(req);
+	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1203,7 +1203,7 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_connect *connect = io_kiocb_to_cmd(req);
+	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
 	struct io_async_connect __io, *io;
 	unsigned file_flags;
 	int ret;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 48d29dead62a..977736e82c1a 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -123,8 +123,6 @@ __cold int io_notif_register(struct io_ring_ctx *ctx,
 	struct io_uring_notification_register reg;
 	unsigned i;
 
-	BUILD_BUG_ON(sizeof(struct io_notif_data) > 64);
-
 	if (ctx->nr_notif_slots)
 		return -EBUSY;
 	if (size != sizeof(reg))
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 0819304d7e00..65f0b42f2555 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -46,7 +46,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 
 static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 {
-	return io_kiocb_to_cmd(notif);
+	return io_kiocb_to_cmd(notif, struct io_notif_data);
 }
 
 static inline struct io_kiocb *io_get_notif(struct io_ring_ctx *ctx,
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index d1818ec9169b..67178e4bb282 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -33,7 +33,7 @@ struct io_close {
 
 static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_open *open = io_kiocb_to_cmd(req);
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
 	const char __user *fname;
 	int ret;
 
@@ -66,7 +66,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_open *open = io_kiocb_to_cmd(req);
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
 	u64 mode = READ_ONCE(sqe->len);
 	u64 flags = READ_ONCE(sqe->open_flags);
 
@@ -76,7 +76,7 @@ int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_open *open = io_kiocb_to_cmd(req);
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
 	struct open_how __user *how;
 	size_t len;
 	int ret;
@@ -95,7 +95,7 @@ int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_open *open = io_kiocb_to_cmd(req);
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
 	struct open_flags op;
 	struct file *file;
 	bool resolve_nonblock, nonblock_set;
@@ -167,7 +167,7 @@ int io_openat(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_open_cleanup(struct io_kiocb *req)
 {
-	struct io_open *open = io_kiocb_to_cmd(req);
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
 
 	if (open->filename)
 		putname(open->filename);
@@ -187,14 +187,14 @@ int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
 
 static inline int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_close *close = io_kiocb_to_cmd(req);
+	struct io_close *close = io_kiocb_to_cmd(req, struct io_close);
 
 	return __io_close_fixed(req->ctx, issue_flags, close->file_slot - 1);
 }
 
 int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_close *close = io_kiocb_to_cmd(req);
+	struct io_close *close = io_kiocb_to_cmd(req, struct io_close);
 
 	if (sqe->off || sqe->addr || sqe->len || sqe->rw_flags || sqe->buf_index)
 		return -EINVAL;
@@ -212,7 +212,7 @@ int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_close(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct files_struct *files = current->files;
-	struct io_close *close = io_kiocb_to_cmd(req);
+	struct io_close *close = io_kiocb_to_cmd(req, struct io_close);
 	struct fdtable *fdt;
 	struct file *file;
 	int ret = -EBADF;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index dadd293749b0..d5bad0bea6e4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -85,7 +85,7 @@ static struct io_poll *io_poll_get_double(struct io_kiocb *req)
 static struct io_poll *io_poll_get_single(struct io_kiocb *req)
 {
 	if (req->opcode == IORING_OP_POLL_ADD)
-		return io_kiocb_to_cmd(req);
+		return io_kiocb_to_cmd(req, struct io_poll);
 	return &req->apoll->poll;
 }
 
@@ -274,7 +274,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 		return;
 
 	if (ret == IOU_POLL_DONE) {
-		struct io_poll *poll = io_kiocb_to_cmd(req);
+		struct io_poll *poll = io_kiocb_to_cmd(req, struct io_poll);
 		req->cqe.res = mangle_poll(req->cqe.res & poll->events);
 	} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
 		req->cqe.res = ret;
@@ -475,7 +475,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 			       struct poll_table_struct *p)
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
-	struct io_poll *poll = io_kiocb_to_cmd(pt->req);
+	struct io_poll *poll = io_kiocb_to_cmd(pt->req, struct io_poll);
 
 	__io_queue_proc(poll, pt, head,
 			(struct io_poll **) &pt->req->async_data);
@@ -821,7 +821,7 @@ static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
 
 int io_poll_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_poll_update *upd = io_kiocb_to_cmd(req);
+	struct io_poll_update *upd = io_kiocb_to_cmd(req, struct io_poll_update);
 	u32 flags;
 
 	if (sqe->buf_index || sqe->splice_fd_in)
@@ -851,7 +851,7 @@ int io_poll_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_poll *poll = io_kiocb_to_cmd(req);
+	struct io_poll *poll = io_kiocb_to_cmd(req, struct io_poll);
 	u32 flags;
 
 	if (sqe->buf_index || sqe->off || sqe->addr)
@@ -868,7 +868,7 @@ int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_poll *poll = io_kiocb_to_cmd(req);
+	struct io_poll *poll = io_kiocb_to_cmd(req, struct io_poll);
 	struct io_poll_table ipt;
 	int ret;
 
@@ -891,7 +891,7 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_poll_update *poll_update = io_kiocb_to_cmd(req);
+	struct io_poll_update *poll_update = io_kiocb_to_cmd(req, struct io_poll_update);
 	struct io_cancel_data cd = { .data = poll_update->old_user_data, };
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_hash_bucket *bucket;
@@ -930,7 +930,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	if (poll_update->update_events || poll_update->update_user_data) {
 		/* only mask one event flags, keep behavior flags */
 		if (poll_update->update_events) {
-			struct io_poll *poll = io_kiocb_to_cmd(preq);
+			struct io_poll *poll = io_kiocb_to_cmd(preq, struct io_poll);
 
 			poll->events &= ~0xffff;
 			poll->events |= poll_update->events & 0xffff;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 59704b9ac537..71359a4d0bd4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -657,7 +657,7 @@ __cold int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 
 int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
@@ -676,7 +676,7 @@ int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int io_files_update_with_index_alloc(struct io_kiocb *req,
 					    unsigned int issue_flags)
 {
-	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 	__s32 __user *fds = u64_to_user_ptr(up->arg);
 	unsigned int done;
 	struct file *file;
@@ -714,7 +714,7 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 
 static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_rsrc_update2 up2;
 	int ret;
@@ -743,7 +743,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_notif_update(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned len = up->nr_args;
 	unsigned idx_end, idx = up->offset;
@@ -778,7 +778,7 @@ static int io_notif_update(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 
 	switch (up->type) {
 	case IORING_RSRC_UPDATE_FILES:
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 2b784795103c..3d732b19b760 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -35,7 +35,7 @@ static inline bool io_file_supports_nowait(struct io_kiocb *req)
 
 int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
 	int ret;
 
@@ -102,7 +102,7 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
 	if (rw->kiocb.ki_pos != -1)
 		return &rw->kiocb.ki_pos;
@@ -186,7 +186,7 @@ static void kiocb_end_write(struct io_kiocb *req)
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
 	if (rw->kiocb.ki_flags & IOCB_WRITE) {
 		kiocb_end_write(req);
@@ -241,7 +241,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {
 	struct io_async_rw *io = req->async_data;
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
 	/* add previously done IO, if any */
 	if (req_has_async_data(req) && io->bytes_done > 0) {
@@ -277,7 +277,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 				unsigned int issue_flags)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct compat_iovec __user *uiov;
 	compat_ssize_t clen;
 	void __user *buf;
@@ -305,7 +305,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 				      unsigned int issue_flags)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct iovec __user *uiov = u64_to_user_ptr(rw->addr);
 	void __user *buf;
 	ssize_t len;
@@ -328,7 +328,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 				    unsigned int issue_flags)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
 		iov[0].iov_base = u64_to_user_ptr(rw->addr);
@@ -350,7 +350,7 @@ static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 				       struct io_rw_state *s,
 				       unsigned int issue_flags)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct iov_iter *iter = &s->iter;
 	u8 opcode = req->opcode;
 	struct iovec *iovec;
@@ -571,7 +571,7 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 {
 	struct wait_page_queue *wpq;
 	struct io_kiocb *req = wait->private;
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct wait_page_key *key = arg;
 
 	wpq = container_of(wait, struct wait_page_queue, wait);
@@ -601,7 +601,7 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
 	struct wait_page_queue *wait = &io->wpq;
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
 
 	/* never retry for NOWAIT, we just complete with -EAGAIN */
@@ -649,7 +649,7 @@ static bool need_complete_io(struct io_kiocb *req)
 
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *file = req->file;
@@ -694,7 +694,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 
 int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_rw_state __s, *s = &__s;
 	struct iovec *iovec;
 	struct kiocb *kiocb = &rw->kiocb;
@@ -839,7 +839,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req);
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_rw_state __s, *s = &__s;
 	struct iovec *iovec;
 	struct kiocb *kiocb = &rw->kiocb;
@@ -994,7 +994,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
 	wq_list_for_each(pos, start, &ctx->iopoll_list) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
-		struct io_rw *rw = io_kiocb_to_cmd(req);
+		struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 		int ret;
 
 		/*
diff --git a/io_uring/splice.c b/io_uring/splice.c
index b013ba34bffa..53e4232d0866 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -26,7 +26,7 @@ struct io_splice {
 static int __io_splice_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
-	struct io_splice *sp = io_kiocb_to_cmd(req);
+	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
 	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
 
 	sp->len = READ_ONCE(sqe->len);
@@ -46,7 +46,7 @@ int io_tee_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_splice *sp = io_kiocb_to_cmd(req);
+	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
 	struct file *in;
@@ -78,7 +78,7 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_splice *sp = io_kiocb_to_cmd(req);
+	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
 
 	sp->off_in = READ_ONCE(sqe->splice_off_in);
 	sp->off_out = READ_ONCE(sqe->off);
@@ -87,7 +87,7 @@ int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_splice *sp = io_kiocb_to_cmd(req);
+	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
 	loff_t *poff_in, *poff_out;
diff --git a/io_uring/statx.c b/io_uring/statx.c
index 6056cd7f4876..d8fc933d3f59 100644
--- a/io_uring/statx.c
+++ b/io_uring/statx.c
@@ -22,7 +22,7 @@ struct io_statx {
 
 int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_statx *sx = io_kiocb_to_cmd(req);
+	struct io_statx *sx = io_kiocb_to_cmd(req, struct io_statx);
 	const char __user *path;
 
 	if (sqe->buf_index || sqe->splice_fd_in)
@@ -53,7 +53,7 @@ int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_statx *sx = io_kiocb_to_cmd(req);
+	struct io_statx *sx = io_kiocb_to_cmd(req, struct io_statx);
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -66,7 +66,7 @@ int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_statx_cleanup(struct io_kiocb *req)
 {
-	struct io_statx *sx = io_kiocb_to_cmd(req);
+	struct io_statx *sx = io_kiocb_to_cmd(req, struct io_statx);
 
 	if (sx->filename)
 		putname(sx->filename);
diff --git a/io_uring/sync.c b/io_uring/sync.c
index f2102afa79ca..64e87ea2b8fb 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -24,7 +24,7 @@ struct io_sync {
 
 int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_sync *sync = io_kiocb_to_cmd(req);
+	struct io_sync *sync = io_kiocb_to_cmd(req, struct io_sync);
 
 	if (unlikely(sqe->addr || sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
@@ -37,7 +37,7 @@ int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_sync *sync = io_kiocb_to_cmd(req);
+	struct io_sync *sync = io_kiocb_to_cmd(req, struct io_sync);
 	int ret;
 
 	/* sync_file_range always requires a blocking context */
@@ -51,7 +51,7 @@ int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_sync *sync = io_kiocb_to_cmd(req);
+	struct io_sync *sync = io_kiocb_to_cmd(req, struct io_sync);
 
 	if (unlikely(sqe->addr || sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
@@ -67,7 +67,7 @@ int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_sync *sync = io_kiocb_to_cmd(req);
+	struct io_sync *sync = io_kiocb_to_cmd(req, struct io_sync);
 	loff_t end = sync->off + sync->len;
 	int ret;
 
@@ -83,7 +83,7 @@ int io_fsync(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_fallocate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_sync *sync = io_kiocb_to_cmd(req);
+	struct io_sync *sync = io_kiocb_to_cmd(req, struct io_sync);
 
 	if (sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -96,7 +96,7 @@ int io_fallocate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_sync *sync = io_kiocb_to_cmd(req);
+	struct io_sync *sync = io_kiocb_to_cmd(req, struct io_sync);
 	int ret;
 
 	/* fallocate always requiring blocking context */
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 2f9e56935479..78ea2c64b70e 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -36,7 +36,7 @@ struct io_timeout_rem {
 
 static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 {
-	struct io_timeout *timeout = io_kiocb_to_cmd(req);
+	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 
 	return !timeout->off;
 }
@@ -56,7 +56,7 @@ static bool io_kill_timeout(struct io_kiocb *req, int status)
 	struct io_timeout_data *io = req->async_data;
 
 	if (hrtimer_try_to_cancel(&io->timer) != -1) {
-		struct io_timeout *timeout = io_kiocb_to_cmd(req);
+		struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 
 		if (status)
 			req_set_fail(req);
@@ -188,7 +188,7 @@ struct io_kiocb *__io_disarm_linked_timeout(struct io_kiocb *req,
 	__must_hold(&req->ctx->timeout_lock)
 {
 	struct io_timeout_data *io = link->async_data;
-	struct io_timeout *timeout = io_kiocb_to_cmd(link);
+	struct io_timeout *timeout = io_kiocb_to_cmd(link, struct io_timeout);
 
 	io_remove_next_linked(req);
 	timeout->head = NULL;
@@ -205,7 +205,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	struct io_timeout_data *data = container_of(timer,
 						struct io_timeout_data, timer);
 	struct io_kiocb *req = data->req;
-	struct io_timeout *timeout = io_kiocb_to_cmd(req);
+	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
@@ -252,7 +252,7 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	io = req->async_data;
 	if (hrtimer_try_to_cancel(&io->timer) == -1)
 		return ERR_PTR(-EALREADY);
-	timeout = io_kiocb_to_cmd(req);
+	timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	list_del_init(&timeout->list);
 	return req;
 }
@@ -275,7 +275,7 @@ int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 {
 	unsigned issue_flags = *locked ? 0 : IO_URING_F_UNLOCKED;
-	struct io_timeout *timeout = io_kiocb_to_cmd(req);
+	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_kiocb *prev = timeout->prev;
 	int ret = -ENOENT;
 
@@ -302,7 +302,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	struct io_timeout_data *data = container_of(timer,
 						struct io_timeout_data, timer);
 	struct io_kiocb *prev, *req = data->req;
-	struct io_timeout *timeout = io_kiocb_to_cmd(req);
+	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
@@ -378,7 +378,7 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 {
 	struct io_cancel_data cd = { .data = user_data, };
 	struct io_kiocb *req = io_timeout_extract(ctx, &cd);
-	struct io_timeout *timeout = io_kiocb_to_cmd(req);
+	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data;
 
 	if (IS_ERR(req))
@@ -395,7 +395,7 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 
 int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_timeout_rem *tr = io_kiocb_to_cmd(req);
+	struct io_timeout_rem *tr = io_kiocb_to_cmd(req, struct io_timeout_rem);
 
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
@@ -435,7 +435,7 @@ static inline enum hrtimer_mode io_translate_timeout_mode(unsigned int flags)
  */
 int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_timeout_rem *tr = io_kiocb_to_cmd(req);
+	struct io_timeout_rem *tr = io_kiocb_to_cmd(req, struct io_timeout_rem);
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
@@ -466,7 +466,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe,
 			     bool is_timeout_link)
 {
-	struct io_timeout *timeout = io_kiocb_to_cmd(req);
+	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data;
 	unsigned flags;
 	u32 off = READ_ONCE(sqe->off);
@@ -532,7 +532,7 @@ int io_link_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_timeout *timeout = io_kiocb_to_cmd(req);
+	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_timeout_data *data = req->async_data;
 	struct list_head *entry;
@@ -583,7 +583,7 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 
 void io_queue_linked_timeout(struct io_kiocb *req)
 {
-	struct io_timeout *timeout = io_kiocb_to_cmd(req);
+	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_ring_ctx *ctx = req->ctx;
 
 	spin_lock_irq(&ctx->timeout_lock);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 849d9708d612..219e9ebbb44a 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -11,7 +11,7 @@
 
 static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
 {
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req);
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
 	ioucmd->task_work_cb(ioucmd);
 }
@@ -55,7 +55,7 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
 int io_uring_cmd_prep_async(struct io_kiocb *req)
 {
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req);
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	size_t cmd_size;
 
 	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
@@ -66,7 +66,7 @@ int io_uring_cmd_prep_async(struct io_kiocb *req)
 
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req);
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 
 	if (sqe->rw_flags || sqe->__pad1)
 		return -EINVAL;
@@ -77,7 +77,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req);
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *file = req->file;
 	int ret;
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index b179f9acd5ac..84180afd090b 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -24,7 +24,7 @@ struct io_xattr {
 
 void io_xattr_cleanup(struct io_kiocb *req)
 {
-	struct io_xattr *ix = io_kiocb_to_cmd(req);
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 
 	if (ix->filename)
 		putname(ix->filename);
@@ -44,7 +44,7 @@ static void io_xattr_finish(struct io_kiocb *req, int ret)
 static int __io_getxattr_prep(struct io_kiocb *req,
 			      const struct io_uring_sqe *sqe)
 {
-	struct io_xattr *ix = io_kiocb_to_cmd(req);
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	const char __user *name;
 	int ret;
 
@@ -85,7 +85,7 @@ int io_fgetxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_xattr *ix = io_kiocb_to_cmd(req);
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	const char __user *path;
 	int ret;
 
@@ -106,7 +106,7 @@ int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_xattr *ix = io_kiocb_to_cmd(req);
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	int ret;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -122,7 +122,7 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_xattr *ix = io_kiocb_to_cmd(req);
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
 	struct path path;
 	int ret;
@@ -151,7 +151,7 @@ int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 static int __io_setxattr_prep(struct io_kiocb *req,
 			const struct io_uring_sqe *sqe)
 {
-	struct io_xattr *ix = io_kiocb_to_cmd(req);
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	const char __user *name;
 	int ret;
 
@@ -181,7 +181,7 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 
 int io_setxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_xattr *ix = io_kiocb_to_cmd(req);
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	const char __user *path;
 	int ret;
 
@@ -208,7 +208,7 @@ int io_fsetxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
 			struct path *path)
 {
-	struct io_xattr *ix = io_kiocb_to_cmd(req);
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	int ret;
 
 	ret = mnt_want_write(path->mnt);
@@ -234,7 +234,7 @@ int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_xattr *ix = io_kiocb_to_cmd(req);
+	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 	unsigned int lookup_flags = LOOKUP_FOLLOW;
 	struct path path;
 	int ret;
-- 
2.34.1

