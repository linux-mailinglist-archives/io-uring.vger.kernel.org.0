Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0F6180117
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgCJPEm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:04:42 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:41910 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgCJPEl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:04:41 -0400
Received: by mail-il1-f196.google.com with SMTP id l14so6423033ilj.8
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W4l733DAdrPNx9GnCTFROgD5OKn8lsLjlZl2HPp7xug=;
        b=kHfz3trLEgGlYAud6Zln8bp75H/YOdDKRuyRHVrULSONhqSc47OWGB31alrx1mWMKE
         FvGrDclbiHSK+KZ+Fd0oxTcfNSQeWXW4owsOU8Tj6QaSqpW4KToArXCye+fySyjux9eu
         c8H9RIpcJXkoOpKCz2UNSp0HM1DUAvy4l4koUE9K/Y4duYmY4ji0TS+dchq8JaqcuTcS
         tDwLG8YG5WHTgepx2TdULqZklvpmIJawoBT1GV0KL03wBVNfk2J/Df/NOq8SLHizTN7N
         OdcvtIR7G8WG4NFqRsDP+qR1/noaj7P9ZKnZl4S2I7HULH3f+T0pEDP+LvvF+2Fc8Ip7
         ozkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W4l733DAdrPNx9GnCTFROgD5OKn8lsLjlZl2HPp7xug=;
        b=YXdgvkhK7sr97xOxgG1iIskYu1nwnq/LQDBz8ZjCYu3YALjfp7pPzLJ6mhb9sIxPFp
         jvy8etCmHKdCiyreQ94zNy5ZQ3JnuB8AWwFacbu1t7hW0b0QAEhaBpCq5r40T7Jkf9o1
         krsXWBKRwSx/NeZGwmR/U9IYl+rEiRfEfGMANHY8SJI9Rf6FoZRlyhr5GZQFZbTmQJzz
         QbOSGQzcEbX2ot8usXrqQL0E4rjStJ8+/HR21MK5CQFvQu5VxM+8hLrr94vu46QgF+Y/
         ORLsLFsWq2JtOQgzjN7XEsXtEexSh1Wrkgz4UQfmv2AiEV8gBTs22qaJDnWu1y2POPD2
         RIvQ==
X-Gm-Message-State: ANhLgQ2b8SnAFgm0tcsDc85l16jOHOWt01/AF9L1uclcG8pZ0YCv+3xd
        LQi6Tq5j9lOBqAgB2+sb21RWkO+wqoY2zw==
X-Google-Smtp-Source: ADFU+vvfRW3EQIch03iJzyY95nyZic8xl2ZJCHUcjSWoD6eJ+kAqYLX/VHAkZedlxGsCfdNOvcyOLQ==
X-Received: by 2002:a92:c603:: with SMTP id p3mr18740270ilm.96.1583852679534;
        Tue, 10 Mar 2020 08:04:39 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm4684750ioh.7.2020.03.10.08.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:04:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring: provide means of removing buffers
Date:   Tue, 10 Mar 2020 09:04:24 -0600
Message-Id: <20200310150427.28489-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310150427.28489-1-axboe@kernel.dk>
References: <20200310150427.28489-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have IORING_OP_PROVIDE_BUFFERS, but the only way to remove buffers
is to trigger IO on them. The usual case of shrinking a buffer pool
would be to just not replenish the buffers when IO completes, and
instead just free it. But it may be nice to have a way to manually
remove a number of buffers from a given group, and
IORING_OP_REMOVE_BUFFERS provides that functionality.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 102 +++++++++++++++++++++++++++-------
 include/uapi/linux/io_uring.h |   1 +
 2 files changed, 84 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed898fb24612..0760a0099760 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -827,6 +827,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
+	[IORING_OP_REMOVE_BUFFERS] = {},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2995,6 +2996,75 @@ static int io_openat(struct io_kiocb *req, bool force_nonblock)
 	return io_openat2(req, force_nonblock);
 }
 
+static int io_remove_buffers_prep(struct io_kiocb *req,
+				  const struct io_uring_sqe *sqe)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	u64 tmp;
+
+	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
+		return -EINVAL;
+
+	tmp = READ_ONCE(sqe->fd);
+	if (!tmp || tmp > USHRT_MAX)
+		return -EINVAL;
+
+	memset(p, 0, sizeof(*p));
+	p->nbufs = tmp;
+	p->bgid = READ_ONCE(sqe->buf_group);
+	return 0;
+}
+
+static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
+			       int bgid, unsigned nbufs)
+{
+	unsigned i = 0;
+
+	/* shouldn't happen */
+	if (!nbufs)
+		return 0;
+
+	/* the head kbuf is the list itself */
+	while (!list_empty(&buf->list)) {
+		struct io_buffer *nxt;
+
+		nxt = list_first_entry(&buf->list, struct io_buffer, list);
+		list_del(&nxt->list);
+		kfree(nxt);
+		if (++i == nbufs)
+			return i;
+	}
+	i++;
+	kfree(buf);
+	idr_remove(&ctx->io_buffer_idr, bgid);
+
+	return i;
+}
+
+static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_provide_buf *p = &req->pbuf;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer *head;
+	int ret = 0;
+
+	io_ring_submit_lock(ctx, !force_nonblock);
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	ret = -ENOENT;
+	head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	if (head)
+		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
+
+	io_ring_submit_lock(ctx, !force_nonblock);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req(req);
+	return 0;
+}
+
 static int io_provide_buffers_prep(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
@@ -3077,15 +3147,7 @@ static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock)
 		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
 					GFP_KERNEL);
 		if (ret < 0) {
-			while (!list_empty(&head->list)) {
-				struct io_buffer *buf;
-
-				buf = list_first_entry(&head->list,
-							struct io_buffer, list);
-				list_del(&buf->list);
-				kfree(buf);
-			}
-			kfree(head);
+			__io_remove_buffers(ctx, head, p->bgid, -1U);
 			goto out;
 		}
 	}
@@ -4833,6 +4895,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_PROVIDE_BUFFERS:
 		ret = io_provide_buffers_prep(req, sqe);
 		break;
+	case IORING_OP_REMOVE_BUFFERS:
+		ret = io_remove_buffers_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -5128,6 +5193,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_provide_buffers(req, force_nonblock);
 		break;
+	case IORING_OP_REMOVE_BUFFERS:
+		if (sqe) {
+			ret = io_remove_buffers_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_remove_buffers(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -7006,16 +7079,7 @@ static int __io_destroy_buffers(int id, void *p, void *data)
 	struct io_ring_ctx *ctx = data;
 	struct io_buffer *buf = p;
 
-	/* the head kbuf is the list itself */
-	while (!list_empty(&buf->list)) {
-		struct io_buffer *nxt;
-
-		nxt = list_first_entry(&buf->list, struct io_buffer, list);
-		list_del(&nxt->list);
-		kfree(nxt);
-	}
-	kfree(buf);
-	idr_remove(&ctx->io_buffer_idr, id);
+	__io_remove_buffers(ctx, buf, id, -1U);
 	return 0;
 }
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9b263d9b24e6..cef4c0c0f26b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -128,6 +128,7 @@ enum {
 	IORING_OP_EPOLL_CTL,
 	IORING_OP_SPLICE,
 	IORING_OP_PROVIDE_BUFFERS,
+	IORING_OP_REMOVE_BUFFERS,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

