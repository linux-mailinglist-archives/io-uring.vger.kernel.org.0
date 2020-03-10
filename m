Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF5B18010D
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgCJPEf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:04:35 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:40548 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgCJPEf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:04:35 -0400
Received: by mail-il1-f194.google.com with SMTP id g6so12284456ilc.7
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C+tqcHUSaQoWl0QVaKfql3XxyqA9s4wVLIRrTtNlx0o=;
        b=Lz7hl6+nRuxN5V6hxPpED5hhqGZB2dRwnRwqExdXTP5pD1qnao59hiYiiATBoneCzh
         Ti1kCpbv9fEShZrXCes+fXmRfpLrAV3EXqmzZwpUz6/UTK3SzY29yWju+zCiEPcqSh01
         h/4J+cCg8Ze7TDgpoOw06syiGABRyvq0UcdCeDUGM2r5na+3Oo9RnlMYO6DJGYU1i5p3
         7N1Bv1+6uIMUeoju9u5tIb0tzGaphjeHhBnSVVfUDfeldsgXYXCpNdVLFcH3yvUA0CWo
         eXXWSE/KhtbQkDv9GXvaR/ON8tQxeCQRpasaTmGmEBlyOTu6P9SzzR9XZFKMkAhqqQsV
         Ymvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C+tqcHUSaQoWl0QVaKfql3XxyqA9s4wVLIRrTtNlx0o=;
        b=Zy+IHF0vn9tB2vx4Sq4qdFA2iFAGufOwxxfoxkjCTdyx/W85Ty68e8DMrqT6JZnJFG
         hdixmsGUZ7lSKKOre6MW1H1nHKnmpJuaPB9dsDIYJUtuaBbpt5cPeMEFt9rQCdXU06V+
         2y+mxsbPr+X1V5u+FMtniN5vGqof2TM4kI1IHHnl1pEXONbsD19L0PWtXuYxcxewLYuZ
         mh1AJny7Sv+MZN8bTI2uE25SGTIWuCBULAr3hvRapeNI851dQ36WDTgDX/JqlPwcOq9r
         9wYo1WGNNJo48qWgPlu/yQaOcFa0xqOuMjKngT4A+h2f8oqSlkI43BHQZLQUGQnlvfMi
         hK3Q==
X-Gm-Message-State: ANhLgQ2LJCka+s7JV1EUo+Yte7czXSAoz2ptbQE4Gn6m9A11XOG/kgdn
        fZWe8oXrSjBwOCdfrsTnE6p9248UuXjTUw==
X-Google-Smtp-Source: ADFU+vvG2YsZenJ7pKlm3+yhoWhV2ekAiAZTyK+Q/6Ey5cysxIDuX4wzAk8D7qk16i+OhJ4z4y4UjA==
X-Received: by 2002:a92:8682:: with SMTP id l2mr15792311ilh.193.1583852673690;
        Tue, 10 Mar 2020 08:04:33 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm4684750ioh.7.2020.03.10.08.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:04:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] io_uring: add IORING_OP_PROVIDE_BUFFERS
Date:   Tue, 10 Mar 2020 09:04:19 -0600
Message-Id: <20200310150427.28489-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310150427.28489-1-axboe@kernel.dk>
References: <20200310150427.28489-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_PROVIDE_BUFFERS uses the buffer registration infrastructure to
support passing in an addr/len that is associated with a buffer ID and
buffer group ID. The group ID is used to index and lookup the buffers,
while the buffer ID can be used to notify the application which buffer
in the group was used. The addr passed in is the starting buffer address,
and length is each buffer length. A number of buffers to add with can be
specified, in which case addr is incremented by length for each addition,
and each buffer increments the buffer ID specified.

No validation is done of the buffer ID. If the application provides
buffers within the same group with identical buffer IDs, then it'll have
a hard time telling which buffer ID was used. The only restriction is
that the buffer ID can be a max of 16-bits in size, so USHRT_MAX is the
maximum ID that can be used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 128 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  10 ++-
 2 files changed, 135 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f3ae208f6a6..675b33cf855a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -447,6 +447,15 @@ struct io_splice {
 	unsigned int			flags;
 };
 
+struct io_provide_buf {
+	struct file			*file;
+	__u64				addr;
+	__s32				len;
+	__u32				bgid;
+	__u16				nbufs;
+	__u16				bid;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -572,6 +581,7 @@ struct io_kiocb {
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
 		struct io_splice	splice;
+		struct io_provide_buf	pbuf;
 	};
 
 	struct io_async_ctx		*io;
@@ -799,7 +809,8 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
-	}
+	},
+	[IORING_OP_PROVIDE_BUFFERS] = {},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2785,6 +2796,110 @@ static int io_openat(struct io_kiocb *req, bool force_nonblock)
 	return io_openat2(req, force_nonblock);
 }
 
+static int io_provide_buffers_prep(struct io_kiocb *req,
+				   const struct io_uring_sqe *sqe)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	u64 tmp;
+
+	if (sqe->ioprio || sqe->rw_flags)
+		return -EINVAL;
+
+	tmp = READ_ONCE(sqe->fd);
+	if (!tmp || tmp > USHRT_MAX)
+		return -E2BIG;
+	p->nbufs = tmp;
+	p->addr = READ_ONCE(sqe->addr);
+	p->len = READ_ONCE(sqe->len);
+
+	if (!access_ok(u64_to_user_ptr(p->addr), p->len))
+		return -EFAULT;
+
+	p->bgid = READ_ONCE(sqe->buf_group);
+	tmp = READ_ONCE(sqe->off);
+	if (tmp > USHRT_MAX)
+		return -E2BIG;
+	p->bid = tmp;
+	return 0;
+}
+
+static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
+{
+	struct io_buffer *buf;
+	u64 addr = pbuf->addr;
+	int i, bid = pbuf->bid;
+
+	for (i = 0; i < pbuf->nbufs; i++) {
+		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+		if (!buf)
+			break;
+
+		buf->addr = addr;
+		buf->len = pbuf->len;
+		buf->bid = bid;
+		addr += pbuf->len;
+		bid++;
+		if (!*head) {
+			INIT_LIST_HEAD(&buf->list);
+			*head = buf;
+		} else {
+			list_add_tail(&buf->list, &(*head)->list);
+		}
+	}
+
+	return i ? i : -ENOMEM;
+}
+
+static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer *head, *list;
+	int ret = 0;
+
+	/*
+	 * "Normal" inline submissions always hold the uring_lock, since we
+	 * grab it from the system call. Same is true for the SQPOLL offload.
+	 * The only exception is when we've detached the request and issue it
+	 * from an async worker thread, grab the lock for that case.
+	 */
+	if (!force_nonblock)
+		mutex_lock(&ctx->uring_lock);
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	list = head = idr_find(&ctx->io_buffer_idr, p->bgid);
+
+	ret = io_add_buffers(p, &head);
+	if (ret < 0)
+		goto out;
+
+	if (!list) {
+		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
+					GFP_KERNEL);
+		if (ret < 0) {
+			while (!list_empty(&head->list)) {
+				struct io_buffer *buf;
+
+				buf = list_first_entry(&head->list,
+							struct io_buffer, list);
+				list_del(&buf->list);
+				kfree(buf);
+			}
+			kfree(head);
+			goto out;
+		}
+	}
+out:
+	if (!force_nonblock)
+		mutex_unlock(&ctx->uring_lock);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req(req);
+	return 0;
+}
+
 static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
@@ -4392,6 +4507,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_SPLICE:
 		ret = io_splice_prep(req, sqe);
 		break;
+	case IORING_OP_PROVIDE_BUFFERS:
+		ret = io_provide_buffers_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -4669,6 +4787,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_splice(req, force_nonblock);
 		break;
+	case IORING_OP_PROVIDE_BUFFERS:
+		if (sqe) {
+			ret = io_provide_buffers_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_provide_buffers(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 53b36311cdac..bc34a57a660b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -45,8 +45,13 @@ struct io_uring_sqe {
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
 		struct {
-			/* index into fixed buffers, if used */
-			__u16	buf_index;
+			/* pack this to avoid bogus arm OABI complaints */
+			union {
+				/* index into fixed buffers, if used */
+				__u16	buf_index;
+				/* for grouped buffer selection */
+				__u16	buf_group;
+			} __attribute__((packed));
 			/* personality to use, if used */
 			__u16	personality;
 			__s32	splice_fd_in;
@@ -119,6 +124,7 @@ enum {
 	IORING_OP_OPENAT2,
 	IORING_OP_EPOLL_CTL,
 	IORING_OP_SPLICE,
+	IORING_OP_PROVIDE_BUFFERS,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

