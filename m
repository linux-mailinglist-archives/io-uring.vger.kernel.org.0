Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F431600DC
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgBOWGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:06:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40573 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgBOWGp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:06:45 -0500
Received: by mail-wr1-f67.google.com with SMTP id t3so15174132wru.7;
        Sat, 15 Feb 2020 14:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bFoK/C15kDMpwiLm73hwFU4WVfAaaGpsowESXi5m1J8=;
        b=tGeMzW26uhZwXyYYBBcUp0k0w7sAsRoXEWKBDUIddpPHCKjo7Ts1SFewCKbTfZdcmp
         kaZg3YBPARwVyS0ebFBB218wDJ1htL+02kA7IkDl97Z6byjY6AwNYun6VHzbHRr3PUxA
         lBpjCf5cITL5o1bjglFw+BEL+Xx/wu1jphxGs6S6m8+RjVXPb3SVlVX61xn6WCd4vv+P
         tgP3F5leSd+661FrkRAfimZXwHaM835WgQNk39s4gRfKmyaqlreB0Y5dcKUJfaRm7xMk
         d9zZfJnOpKGw/uSqszh0sgsCSFEURmTXKBsuuXG7SYjrQKOD2+aqT8V3bo37Zo96R4UN
         MRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bFoK/C15kDMpwiLm73hwFU4WVfAaaGpsowESXi5m1J8=;
        b=h1B+f1zFsKIff3HL7acYNPctWl3ytsSJnFwa/WzkcbjpTps+RVMzRvyNJ77viTSKm0
         HosR9tTnMYzCVSoD6C3Jq6/r0UlVdm2h9aMA5u+9VAcThjQ+mkQeBQb+XrIe1DfCJ9rm
         rsnB4Y3Fh43PLO7+jgI7/Lhy3ge8L//DPV5WM5J0fcpIRFHjedbDv4NQTM0N9/dITodN
         IJ44bXzNHFDIjdTNVd6RM5Ze+MYO8HGBOV78D8eNxtdQvU9PuywSoKGjoPUbmT3Fyayg
         fjnQ3YOmXT0YH6SC3RVOXmDBYWOg3jCgbCifwhjn0lIw/SX6kA8RVei+4IXR23hQqnPq
         5RXw==
X-Gm-Message-State: APjAAAUvkKzVb0Bp5IpIs5SxfpFp4rMqAF8eCtMiuRVpdooovMi+RFvO
        ffKGXRJ/QVnGwVdBnCexkXk=
X-Google-Smtp-Source: APXvYqxOTos5Hh/wlql/Rw7CRq9D0ze8S8dfwPn/mIttiSBi6SVQnlUVss8j2+rfjDuyDVh+jW74kg==
X-Received: by 2002:a05:6000:118d:: with SMTP id g13mr11216448wrx.141.1581804402955;
        Sat, 15 Feb 2020 14:06:42 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id v15sm13281923wrf.7.2020.02.15.14.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:06:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] io_uring: add splice(2) support
Date:   Sun, 16 Feb 2020 01:05:41 +0300
Message-Id: <b33d7315f266225237dfd10f483162c51c2ed5bc.1581802973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581802973.git.asml.silence@gmail.com>
References: <cover.1581802973.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for splice(2). Out file is handled in generic path,
input file owned cared by splice* bits only.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 106 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  14 ++++-
 2 files changed, 119 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 389db6f5568b..1c71d848c974 100644
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
@@ -546,6 +556,7 @@ struct io_kiocb {
 		struct io_fadvise	fadvise;
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
+		struct io_splice	splice;
 	};
 
 	struct io_async_ctx		*io;
@@ -746,6 +757,11 @@ static const struct io_op_def io_op_defs[] = {
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
@@ -760,6 +776,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static int io_grab_files(struct io_kiocb *req);
 static void io_ring_file_ref_flush(struct fixed_file_data *data);
 static void io_cleanup_req(struct io_kiocb *req);
+static int io_get_file(struct io_submit_state *state,
+		       struct io_ring_ctx *ctx,
+		       int fd, struct file **out_file,
+		       bool fixed);
 
 static struct kmem_cache *req_cachep;
 
@@ -2412,6 +2432,77 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
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
+	sp->off_in = READ_ONCE(sqe->off_in);
+	sp->off_out = READ_ONCE(sqe->off);
+	sp->len = READ_ONCE(sqe->len);
+	sp->flags = READ_ONCE(sqe->splice_flags);
+
+	if (unlikely(READ_ONCE(sqe->ioprio) || (sp->flags & ~valid_flags)))
+		return -EINVAL;
+
+	ret = io_get_file(NULL, req->ctx, READ_ONCE(sqe->splice_fd_in),
+			   &sp->file_in, (sp->flags & SPLICE_F_FD_IN_FIXED));
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
+	struct io_splice* sp = &req->splice;
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
+	io_put_file(req->ctx, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
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
@@ -4227,6 +4318,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_EPOLL_CTL:
 		ret = io_epoll_ctl_prep(req, sqe);
 		break;
+	case IORING_OP_SPLICE:
+		ret = io_splice_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -4289,6 +4383,10 @@ static void io_cleanup_req(struct io_kiocb *req)
 	case IORING_OP_STATX:
 		putname(req->open.filename);
 		break;
+	case IORING_OP_SPLICE:
+		io_put_file(req->ctx, req->splice.file_in,
+			    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
+		break;
 	}
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -4492,6 +4590,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3f7961c1c243..bc2fe0281de7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -23,7 +23,10 @@ struct io_uring_sqe {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
 	};
-	__u64	addr;		/* pointer to buffer or iovecs */
+	union {
+		__u64	addr;	/* pointer to buffer or iovecs */
+		__u64	off_in;
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
+			__u32	splice_fd_in;
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

