Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57A6C169C73
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 03:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgBXC4Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 21:56:16 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35807 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgBXC4P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 21:56:15 -0500
Received: by mail-pg1-f193.google.com with SMTP id 7so2273468pgr.2
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 18:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CoZUfENDMcx4lrwfHMAHsXlT7UOVRxRRkOZHLeurh3E=;
        b=qSAG2A36K7VLa71Qorv0hbFJQdJkl2GWIiNXH48JiawOCtHkGK3gKEYcNmauRa6Rga
         R9+aSuZoBncQnHqNl/Mg3c7AH9Yde+jjKWrROeSArNG1cNMAO9NpkE4Ybvw2+cyn9yIb
         MOS+C0UXDH6c1InS+CVeR/YZJpTMGTwJ+mMTT5Kuwn+iX4oBtoUjPurTxD+BL936fSZT
         3iUA+UJjQPUcq9RNaRsKmiWloFVx1wLYbS8nb3fzFsoLBYUCY0t/FnISxurFeV4DCRar
         OqBh+5U+LfuLFAxZE+Ai/5t18dTInrXO23DhCr2ky3aUVsaNoByhfes3PEW/0vVBoW3x
         f/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CoZUfENDMcx4lrwfHMAHsXlT7UOVRxRRkOZHLeurh3E=;
        b=jEOiQ5l/0NF0V8SjsXZgZE2JTq00YUF6nqLjeB/iuuWnfWxft5AQB8+mvmxwQ//AVC
         atImtJPWcFFIgRjq/5XXjA1IPmaB+uP7hS6J/PQ7sJ/BE3Tvp5T0NA5TN6ALHNWTQVCT
         eE1HvdiASNqxCdR2of9B2GNwdba76PspXKPQTcwIOUB3d6ZLqot+QyIW9sgYR7U0jMvW
         UxN9T1D4qu42fX6VyGXAUxyqhES6jeSMWOYHnmqY1Pc/ug0xE9bFuYgBPdhhGGWqstWR
         1IIMobNSkm4TuZ9a6++SJ5OSMZU5n6idc6fhPn1xYJJNX7KyyJ/cV+6EialKAlXKFbY9
         0rYA==
X-Gm-Message-State: APjAAAUQptJvWADJAfG/WY8ZveMrEC2utAeP/eJAvbTNr5Cl5/grR3K1
        Nz6mN2eHIXQvpDn+tXZk0J7sjLXs7XI=
X-Google-Smtp-Source: APXvYqz09/ZPTl9ytxRK4XpK6WtFVJmSnCD/0xW7QVl5OuuK37Ua/CKET6WrKCPfZ6WPXUOMdxvbLQ==
X-Received: by 2002:a63:e80d:: with SMTP id s13mr50959712pgh.236.1582512974517;
        Sun, 23 Feb 2020 18:56:14 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z5sm10859169pfq.3.2020.02.23.18.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 18:56:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: add IORING_OP_PROVIDE_BUFFER
Date:   Sun, 23 Feb 2020 19:56:06 -0700
Message-Id: <20200224025607.22244-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224025607.22244-1-axboe@kernel.dk>
References: <20200224025607.22244-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_PROVIDE_BUFFER uses the buffer registration infrastructure to
support passing in an addr/len that is associated with a buffer ID and
buffer group ID. The group ID is used to index and lookup the buffers,
while the buffer ID can be used to notify the application which buffer
in the group was used.

At least for now, no validation is done of the buffer ID. If the
application provides buffers within the same group with identical buffer
IDs, then it'll have a hard time telling which buffer ID was used. The
only restriction is that the buffer ID can be a max of 16-bits in size,
so USHRT_MAX is the maximum ID that can be used.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 84 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 85 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 98b0e9552ef2..8b7c5ab69658 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -442,6 +442,14 @@ struct io_epoll {
 	struct epoll_event		event;
 };
 
+struct io_provide_buffer {
+	struct file			*file;
+	__u64				addr;
+	__s32				len;
+	__u32				gid;
+	__u16				bid;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -566,6 +574,7 @@ struct io_kiocb {
 		struct io_fadvise	fadvise;
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
+		struct io_provide_buffer	pbuf;
 	};
 
 	struct io_async_ctx		*io;
@@ -790,6 +799,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.file_table		= 1,
 	},
+	[IORING_OP_PROVIDE_BUFFER] = {},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2703,6 +2713,69 @@ static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
 	return io_openat2(req, nxt, force_nonblock);
 }
 
+static int io_provide_buffer_prep(struct io_kiocb *req,
+				  const struct io_uring_sqe *sqe)
+{
+	struct io_provide_buffer *p = &req->pbuf;
+	u64 off;
+
+	p->addr = READ_ONCE(sqe->addr);
+	p->len = READ_ONCE(sqe->len);
+	p->gid = READ_ONCE(sqe->fd);
+	off = READ_ONCE(sqe->off);
+	if (off > USHRT_MAX)
+		return -EINVAL;
+	p->bid = off;
+	return 0;
+}
+
+static int io_provide_buffer(struct io_kiocb *req, struct io_kiocb **nxt)
+{
+	struct io_provide_buffer *p = &req->pbuf;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct list_head *list;
+	struct io_buffer *buf;
+	int ret = 0;
+
+	list = idr_find(&ctx->io_buffer_idr, p->gid);
+	if (!list) {
+		list = kmalloc(sizeof(*list), GFP_KERNEL);
+		if (!list) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		INIT_LIST_HEAD(list);
+		ret = idr_alloc(&ctx->io_buffer_idr, list, p->gid, p->gid + 1,
+					GFP_KERNEL);
+		if (ret < 0) {
+			kfree(list);
+			goto out;
+		}
+	}
+
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf) {
+		if (list_empty(list)) {
+			idr_remove(&ctx->io_buffer_idr, p->gid);
+			kfree(list);
+		}
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	buf->addr = p->addr;
+	buf->len = p->len;
+	buf->bid = p->bid;
+	list_add(&buf->list, list);
+	ret = buf->bid;
+out:
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, nxt);
+	return 0;
+}
+
 static int io_epoll_ctl_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
@@ -4314,6 +4387,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_EPOLL_CTL:
 		ret = io_epoll_ctl_prep(req, sqe);
 		break;
+	case IORING_OP_PROVIDE_BUFFER:
+		ret = io_provide_buffer_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -4579,6 +4655,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_epoll_ctl(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_PROVIDE_BUFFER:
+		if (sqe) {
+			ret = io_provide_buffer_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_provide_buffer(req, nxt);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 653865554691..21915ada9507 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -113,6 +113,7 @@ enum {
 	IORING_OP_RECV,
 	IORING_OP_OPENAT2,
 	IORING_OP_EPOLL_CTL,
+	IORING_OP_PROVIDE_BUFFER,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

