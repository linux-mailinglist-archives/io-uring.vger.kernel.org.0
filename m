Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5502A2579
	for <lists+io-uring@lfdr.de>; Mon,  2 Nov 2020 08:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgKBHoO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 02:44:14 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:45986 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726819AbgKBHoN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 02:44:13 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UDvXTOv_1604303042;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UDvXTOv_1604303042)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Nov 2020 15:44:09 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH RFC] io_uring: support ioctl
Date:   Mon,  2 Nov 2020 15:44:01 +0800
Message-Id: <1604303041-184595-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Async ioctl is necessary for some scenarios like nonblocking
single-threaded model

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
I've written corresponding liburing tests for this feature. Currently
just a simple test for BLKGETSIZE operation. I'll release it later soon
when it gets better.

 fs/io_uring.c                 | 56 +++++++++++++++++++++++++++++++++++++++++++
 fs/ioctl.c                    |  4 ++--
 include/linux/fs.h            |  3 ++-
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b42dfa0243bf..c8ab6b6d2d70 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -539,6 +539,13 @@ struct io_statx {
 	struct statx __user		*buffer;
 };
 
+struct io_ioctl {
+	struct file			*file;
+	unsigned int                    fd;
+	unsigned int                    cmd;
+	unsigned long                   arg;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -665,6 +672,7 @@ struct io_kiocb {
 		struct io_splice	splice;
 		struct io_provide_buf	pbuf;
 		struct io_statx		statx;
+		struct io_ioctl         ioctl;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -932,6 +940,10 @@ struct io_op_def {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
+	[IORING_OP_IOCTL] = {
+		.needs_file             = 1,
+		.work_flags             = IO_WQ_WORK_MM | IO_WQ_WORK_FILES
+	},
 };
 
 enum io_mem_account {
@@ -4819,6 +4831,45 @@ static int io_connect(struct io_kiocb *req, bool force_nonblock,
 }
 #endif /* CONFIG_NET */
 
+static int io_ioctl_prep(struct io_kiocb *req,
+			 const struct io_uring_sqe *sqe)
+{
+	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
+		return -EINVAL;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	req->ioctl.fd = READ_ONCE(sqe->fd);
+	req->ioctl.cmd = READ_ONCE(sqe->len);
+	req->ioctl.arg = READ_ONCE(sqe->addr);
+	return 0;
+}
+
+static int io_ioctl(struct io_kiocb *req, bool force_nonblock)
+{
+	int ret;
+
+	if (force_nonblock)
+		return -EAGAIN;
+
+	if (!req->file)
+		return -EBADF;
+
+	ret = security_file_ioctl(req->file, req->ioctl.cmd, req->ioctl.arg);
+	if (ret)
+		goto out;
+
+	ret = do_vfs_ioctl(req->file, req->ioctl.fd, req->ioctl.cmd, req->ioctl.arg);
+	if (ret == -ENOIOCTLCMD)
+		ret = vfs_ioctl(req->file, req->ioctl.cmd, req->ioctl.arg);
+
+out:
+	if (ret)
+		req_set_fail_links(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 struct io_poll_table {
 	struct poll_table_struct pt;
 	struct io_kiocb *req;
@@ -5742,6 +5793,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_remove_buffers_prep(req, sqe);
 	case IORING_OP_TEE:
 		return io_tee_prep(req, sqe);
+	case IORING_OP_IOCTL:
+		return io_ioctl_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -5985,6 +6038,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_TEE:
 		ret = io_tee(req, force_nonblock);
 		break;
+	case IORING_OP_IOCTL:
+		ret = io_ioctl(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 4e6cc0a7d69c..4ff2eb0d8ee0 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -664,8 +664,8 @@ static int ioctl_file_dedupe_range(struct file *file,
  * When you add any new common ioctls to the switches above and below,
  * please ensure they have compatible arguments in compat mode.
  */
-static int do_vfs_ioctl(struct file *filp, unsigned int fd,
-			unsigned int cmd, unsigned long arg)
+int do_vfs_ioctl(struct file *filp, unsigned int fd,
+		unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct inode *inode = file_inode(filp);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0bd126418bb6..ad62aa6f6136 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1732,7 +1732,8 @@ int vfs_mkobj(struct dentry *, umode_t,
 int vfs_utimes(const struct path *path, struct timespec64 *times);
 
 extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-
+extern int do_vfs_ioctl(struct file *filp, unsigned int fd,
+			unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
 					unsigned long arg);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 98d8e06dea22..4919b4e94c12 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -132,6 +132,7 @@ enum {
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
 	IORING_OP_TEE,
+	IORING_OP_IOCTL,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
1.8.3.1

