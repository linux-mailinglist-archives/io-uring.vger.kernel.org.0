Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D751448B9
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 01:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgAVAGR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 19:06:17 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34844 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgAVAGQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 19:06:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id g17so5434060wro.2;
        Tue, 21 Jan 2020 16:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h7oPN0fHcma8hj0tfTxFypzTkTs9iot+mzcZU9jYQfA=;
        b=iyvIsQd17aqujrzVntjSCFkUM+uY+rJXzUF9Ifnmt+lvMk3CzQDRHgzqqiXOH/NzGH
         2n5OXIAymKXe3eioxs0mmc87oVrXTUTrmojgrQ4g6WpKS2CeBsUN4TBObYV4EWflJVFe
         ABi/hI1m/FKYZ55gkkKxEs8R2riCvoYvt5IEJgYUUvmKMNCPkDDQGvk84J98NFDDr8lJ
         ibw/7+oXCpN8Xw5CA2x7vBufPrxVzZfU0Fy8+dXtfIdEOlwxGVwDtd5FM6dYN9xwZ9bK
         P2YhohqqkajVsDIr3/PeL46vztd5oDqXoF3qQKgtKvVpEogb9fNlQcIYxed8U3pSGYKT
         S7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h7oPN0fHcma8hj0tfTxFypzTkTs9iot+mzcZU9jYQfA=;
        b=XJhqfvJOpimGvj3tOMPKGIxNq+UIkr8kjsFMTY0JlmyD1FBJ9+Vb6QkRlLbxSMucmy
         L91Do07Vt9kYkLrRyTGBiKoFA2ilyGhtD3ICEyFzCd5wlRud2wEEPOWNNedH61IULj6D
         RO7NWVxhMV1RaLjbIfbOhEAXvRNGukhx7PG8APmZtbsPtHf9VVGI4xFAFwzENWbe7DH7
         lP1he58U0jkaYdz8qbAaa9UC7DbytbyIGlkso+tNAi5hUi6aXuUnFfMDWR/mA6h5fiI1
         XgsLZN0Trc/Y/v1F5bWCmB3YJskhnyA+YK9LoquTW3GallBoXpQ1PauRGCi4dmBTEShd
         2sVQ==
X-Gm-Message-State: APjAAAWOhsUzT4OLrS1MyMaQqCZ1Y33oSesjxZjkT2OVvo+bQxRs09M7
        fqnl8q3gr0teNf8GiLGFqvN6CCrW
X-Google-Smtp-Source: APXvYqw8K8lxMVwamo2yCxmbHhShPjviREeQ2PUVqFTUN8CPzg5jWYdWXZitKgsVdsl4sTIqEcY4OA==
X-Received: by 2002:adf:b605:: with SMTP id f5mr7274714wre.383.1579651573836;
        Tue, 21 Jan 2020 16:06:13 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id o4sm54527068wrw.97.2020.01.21.16.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 16:06:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3/3] io_uring: add splice(2) support
Date:   Wed, 22 Jan 2020 03:05:19 +0300
Message-Id: <8bfd9a57bf42cfc10ee7195969058d6da277deed.1579649589.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579649589.git.asml.silence@gmail.com>
References: <cover.1579649589.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for splice(2). Nothing new, just reuse do_splice().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 86 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h | 16 ++++++-
 2 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9e4aee0fb99..44ec9c63c41d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -74,6 +74,7 @@
 #include <linux/namei.h>
 #include <linux/fsnotify.h>
 #include <linux/fadvise.h>
+#include <linux/splice.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -373,6 +374,15 @@ struct io_rw {
 	u64				len;
 };
 
+struct io_splice {
+	struct file			*file_in;
+	struct file			*file_out;
+	loff_t __user			*off_in;
+	loff_t __user			*off_out;
+	u64				len;
+	unsigned int			flags;
+};
+
 struct io_connect {
 	struct file			*file;
 	struct sockaddr __user		*addr;
@@ -534,6 +544,7 @@ struct io_kiocb {
 		struct io_files_update	files_update;
 		struct io_fadvise	fadvise;
 		struct io_madvise	madvise;
+		struct io_splice	splice;
 	};
 
 	struct io_async_ctx		*io;
@@ -719,6 +730,11 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 	},
+	[IORING_OP_SPLICE] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+	}
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -730,6 +746,10 @@ static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
+static int io_get_file(struct io_submit_state *state,
+		       struct io_ring_ctx *ctx,
+		       int fd, struct file **out_file,
+		       bool fixed);
 
 static struct kmem_cache *req_cachep;
 
@@ -2322,6 +2342,61 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	return ret;
 }
 
+static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_splice* sp = &req->splice;
+
+	sp->file_out = NULL;
+	sp->off_in = u64_to_user_ptr(READ_ONCE(sqe->off));
+	sp->off_out = u64_to_user_ptr(READ_ONCE(sqe->off_out));
+	sp->len = READ_ONCE(sqe->splice_len);
+	sp->flags = READ_ONCE(sqe->splice_flags);
+
+	if (unlikely(READ_ONCE(sqe->ioprio) || (sp->flags & ~SPLICE_F_ALL)))
+		return -EINVAL;
+
+	return io_get_file(NULL, req->ctx, READ_ONCE(sqe->fd_out),
+			   &sp->file_out, (sp->flags & IOSQE_SPLICE_FIXED_OUT));
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
+	struct io_splice* sp = &req->splice;
+	struct file *in = sp->file_in;
+	struct file *out = sp->file_out;
+	unsigned int flags = sp->flags;
+	long ret;
+
+	if (force_nonblock) {
+		if (io_splice_punt(in) || io_splice_punt(out)) {
+			req->flags |= REQ_F_MUST_PUNT;
+			return -EAGAIN;
+		}
+		flags |= SPLICE_F_NONBLOCK;
+	}
+
+	ret = do_splice(in, sp->off_in, out, sp->off_out, sp->len, flags);
+	if (force_nonblock && ret == -EAGAIN)
+		return -EAGAIN;
+
+	io_put_file(req->ctx, out, (flags & IOSQE_SPLICE_FIXED_OUT));
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
@@ -4044,6 +4119,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_OPENAT2:
 		ret = io_openat2_prep(req, sqe);
 		break;
+	case IORING_OP_SPLICE:
+		ret = io_splice_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -4272,6 +4350,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_openat2(req, nxt, force_nonblock);
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
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 57d05cc5e271..f234b13e7ed3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -23,8 +23,14 @@ struct io_uring_sqe {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
 	};
-	__u64	addr;		/* pointer to buffer or iovecs */
-	__u32	len;		/* buffer size or number of iovecs */
+	union {
+		__u64	addr;		/* pointer to buffer or iovecs */
+		__u64	off_out;
+	};
+	union {
+		__u32	len;	/* buffer size or number of iovecs */
+		__s32	fd_out;
+	};
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
@@ -37,10 +43,12 @@ struct io_uring_sqe {
 		__u32		open_flags;
 		__u32		statx_flags;
 		__u32		fadvise_advice;
+		__u32		splice_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
 		__u16	buf_index;	/* index into fixed buffers, if used */
+		__u64	splice_len;
 		__u64	__pad2[3];
 	};
 };
@@ -67,6 +75,9 @@ enum {
 /* always go async */
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 
+/* op custom flags */
+#define IOSQE_SPLICE_FIXED_OUT	(1U << 16)
+
 /*
  * io_uring_setup() flags
  */
@@ -106,6 +117,7 @@ enum {
 	IORING_OP_SEND,
 	IORING_OP_RECV,
 	IORING_OP_OPENAT2,
+	IORING_OP_SPLICE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.0

