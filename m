Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2D216A015
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 09:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgBXId7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 03:33:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38817 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXId7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 03:33:59 -0500
Received: by mail-wr1-f65.google.com with SMTP id e8so9276090wrm.5;
        Mon, 24 Feb 2020 00:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=12vPGZpFg0vglmSbRNNbzPOp/4sEkidPp3sfD3982tI=;
        b=O0Acsw26HSPxu5KgZtWMzFTfDMtqFgyRP4MZWZ0uA2JCOPQygmtb5FvcBslZxI0y0/
         K6crY0Qh+LqvJEc7/MjkCEkDE0hZji/eap26TsVnyniRBtL5qLEwYJH9P1uHR7a6gJHk
         HxkCdvsLEziKCuzXkEDun3r2b5KuYqx0a+vfQfeKDpLThOTO1zIrS9mgJPdu5Fk5OwP4
         h2Ig8HXVjGFceivRHpv6+vjZYaNpij4TCIeEGiJuv205g/OJBMOeajDlMURqzLxXG47a
         Pvtdlymz8ICvf9ams+30wSZFCQOTc0CaviHN17cqYpOay+vfbgm0guUET0AhsvZKKYhB
         OAfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=12vPGZpFg0vglmSbRNNbzPOp/4sEkidPp3sfD3982tI=;
        b=TdSGGR4+9ftaQhWEgQKKP8HKl8hqCvK+diriRUWgRmsmUx+9jD7PZQ78SmG3tsuAcO
         0qEAd8EdN2z8NIhzUAjmZYDTHNxbp2iAfdz1BXfydVyV+pJo0UHdBpCJCPB80+ttbrEo
         gfOlNDYsyNM48oDVtktU+JAfByWRZpdxhUc1wSfaO5VuupDAO7oWP7HKY7puRbIOIuZ3
         g95KCPiNLS+zt5/DfRNXW5J35ZlWY6Ai0ALKIXigIOv++W7RQVUUCHmgY899cNdrdudK
         Ozkx5lvtWsi7+tvKtKwmqHYYjfkUW1XFLVxvG2T6FKCrn4yBOltq5P/rcHoetf+fNh06
         dWxg==
X-Gm-Message-State: APjAAAXGCypFU/SeaZ6WphQWeLGMDgp+0ER4jcWAoAlUxq5Vtq90kLBU
        FVlp16x0wCRXTW99gXn73FE=
X-Google-Smtp-Source: APXvYqw2c3+epxtVujmqLcG/dulkNNB3WNC/+FwHLv6JZhDGq1lB3sJG4PstOy9QeTg4rAWuad0+Xw==
X-Received: by 2002:a5d:4085:: with SMTP id o5mr64690659wrp.321.1582533237552;
        Mon, 24 Feb 2020 00:33:57 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id p15sm16695353wma.40.2020.02.24.00.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 00:33:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] io_uring: add splice(2) support
Date:   Mon, 24 Feb 2020 11:32:45 +0300
Message-Id: <bf7f2f76de5f43cdc121b6ea2f1e204a97abe80e.1582530525.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582530525.git.asml.silence@gmail.com>
References: <cover.1582530525.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for splice(2).

- output file is specified as sqe->fd, so it's handled by generic code
- hash_reg_file handled by generic code as well
- len is 32bit, but should be fine
- the fd_in is registered file, when SPLICE_F_FD_IN_FIXED is set, which
is a splice flag (i.e. sqe->splice_flags).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 109 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  14 ++++-
 2 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 443870e0dc46..b9dd94143c30 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -76,6 +76,7 @@
 #include <linux/fadvise.h>
 #include <linux/eventpoll.h>
 #include <linux/fs_struct.h>
+#include <linux/splice.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -433,6 +434,15 @@ struct io_epoll {
 	struct epoll_event		event;
 };
 
+struct io_splice {
+	struct file			*file_out;
+	struct file			*file_in;
+	loff_t				off_out;
+	loff_t				off_in;
+	u64				len;
+	unsigned int			flags;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -549,6 +559,7 @@ struct io_kiocb {
 		struct io_fadvise	fadvise;
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
+		struct io_splice	splice;
 	};
 
 	struct io_async_ctx		*io;
@@ -749,6 +760,11 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.file_table		= 1,
 	},
+	[IORING_OP_SPLICE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+	}
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -763,6 +779,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static int io_grab_files(struct io_kiocb *req);
 static void io_ring_file_ref_flush(struct fixed_file_data *data);
 static void io_cleanup_req(struct io_kiocb *req);
+static int io_file_get(struct io_submit_state *state,
+		       struct io_kiocb *req,
+		       int fd, struct file **out_file,
+		       bool fixed);
 
 static struct kmem_cache *req_cachep;
 
@@ -2404,6 +2424,77 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	return ret;
 }
 
+static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_splice* sp = &req->splice;
+	unsigned int valid_flags = SPLICE_F_FD_IN_FIXED | SPLICE_F_ALL;
+	int ret;
+
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		return 0;
+
+	sp->file_in = NULL;
+	sp->off_in = READ_ONCE(sqe->splice_off_in);
+	sp->off_out = READ_ONCE(sqe->off);
+	sp->len = READ_ONCE(sqe->len);
+	sp->flags = READ_ONCE(sqe->splice_flags);
+
+	if (unlikely(sp->flags & ~valid_flags))
+		return -EINVAL;
+
+	ret = io_file_get(NULL, req, READ_ONCE(sqe->splice_fd_in), &sp->file_in,
+			  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (ret)
+		return ret;
+	req->flags |= REQ_F_NEED_CLEANUP;
+
+	if (!S_ISREG(file_inode(sp->file_in)->i_mode))
+		req->work.flags |= IO_WQ_WORK_UNBOUND;
+
+	return 0;
+}
+
+static bool io_splice_punt(struct file *file)
+{
+	if (get_pipe_info(file))
+		return false;
+	if (!io_file_supports_async(file))
+		return true;
+	return !(file->f_mode & O_NONBLOCK);
+}
+
+static int io_splice(struct io_kiocb *req, struct io_kiocb **nxt,
+		     bool force_nonblock)
+{
+	struct io_splice *sp = &req->splice;
+	struct file *in = sp->file_in;
+	struct file *out = sp->file_out;
+	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
+	loff_t *poff_in, *poff_out;
+	long ret;
+
+	if (force_nonblock) {
+		if (io_splice_punt(in) || io_splice_punt(out))
+			return -EAGAIN;
+		flags |= SPLICE_F_NONBLOCK;
+	}
+
+	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
+	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
+	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
+	if (force_nonblock && ret == -EAGAIN)
+		return -EAGAIN;
+
+	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+
+	io_cqring_add_event(req, ret);
+	if (ret != sp->len)
+		req_set_fail_links(req);
+	io_put_req_find_next(req, nxt);
+	return 0;
+}
+
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
@@ -4219,6 +4310,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_EPOLL_CTL:
 		ret = io_epoll_ctl_prep(req, sqe);
 		break;
+	case IORING_OP_SPLICE:
+		ret = io_splice_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -4281,6 +4375,10 @@ static void io_cleanup_req(struct io_kiocb *req)
 	case IORING_OP_STATX:
 		putname(req->open.filename);
 		break;
+	case IORING_OP_SPLICE:
+		io_put_file(req, req->splice.file_in,
+			    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
+		break;
 	}
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -4484,6 +4582,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_epoll_ctl(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_SPLICE:
+		if (sqe) {
+			ret = io_splice_prep(req, sqe);
+			if (ret < 0)
+				break;
+		}
+		ret = io_splice(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -7225,6 +7331,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(8,  __u64,  off);
 	BUILD_BUG_SQE_ELEM(8,  __u64,  addr2);
 	BUILD_BUG_SQE_ELEM(16, __u64,  addr);
+	BUILD_BUG_SQE_ELEM(16, __u64,  splice_off_in);
 	BUILD_BUG_SQE_ELEM(24, __u32,  len);
 	BUILD_BUG_SQE_ELEM(28,     __kernel_rwf_t, rw_flags);
 	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
@@ -7239,9 +7346,11 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(28, __u32,  open_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  statx_flags);
 	BUILD_BUG_SQE_ELEM(28, __u32,  fadvise_advice);
+	BUILD_BUG_SQE_ELEM(28, __u32,  splice_flags);
 	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
+	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3f7961c1c243..08891cc1c1e7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -23,7 +23,10 @@ struct io_uring_sqe {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
 	};
-	__u64	addr;		/* pointer to buffer or iovecs */
+	union {
+		__u64	addr;	/* pointer to buffer or iovecs */
+		__u64	splice_off_in;
+	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
 		__kernel_rwf_t	rw_flags;
@@ -37,6 +40,7 @@ struct io_uring_sqe {
 		__u32		open_flags;
 		__u32		statx_flags;
 		__u32		fadvise_advice;
+		__u32		splice_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -45,6 +49,7 @@ struct io_uring_sqe {
 			__u16	buf_index;
 			/* personality to use, if used */
 			__u16	personality;
+			__s32	splice_fd_in;
 		};
 		__u64	__pad2[3];
 	};
@@ -113,6 +118,7 @@ enum {
 	IORING_OP_RECV,
 	IORING_OP_OPENAT2,
 	IORING_OP_EPOLL_CTL,
+	IORING_OP_SPLICE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -128,6 +134,12 @@ enum {
  */
 #define IORING_TIMEOUT_ABS	(1U << 0)
 
+/*
+ * sqe->splice_flags
+ * extends splice(2) flags
+ */
+#define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.24.0

