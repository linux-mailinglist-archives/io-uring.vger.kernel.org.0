Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259E314140C
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 23:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgAQWXX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 17:23:23 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46002 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgAQWXW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 17:23:22 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so19498283lfa.12;
        Fri, 17 Jan 2020 14:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aS/SYWrXDtyHFRLY59psBAoiZ6HS2GpsFk3yrbOyHlU=;
        b=eyVYl3vRYHsiYqqq2flj6E8wj5PBPh8hLPilBL9EUAO4EaWWPbsbFM03EPuk2ZNXFm
         Tjg00IMhGTslwNMQE/AvnfT0WMzHCcNXLj8F0JWY0jomZ5cPp4ZTvIiQwYeYTSnZca3Q
         FiCsVn6cYSP4DbjdOjyV5G3RDXy0VBjGKNCJZlsKaIB2pL9mEiEDG7L4kiYYXrxoC2o6
         V9wsWfGoIMlRHcwJCeXRoiq9YoE2dVGY2vrVTILtthYi66lojVqIRYvhtzB6OcloFiw+
         rhCZFH/D+woluYPKH2tjvdbe8psRPVOyMjKvzfhCvzQhEyfTW0xAycJoGYU/tITVlvNQ
         WfRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aS/SYWrXDtyHFRLY59psBAoiZ6HS2GpsFk3yrbOyHlU=;
        b=njcpSrM9+8JydpYicH0x3JK2huovQt8TPtD6hhcfvV6/LtV6wKrHnTI4viek9ANvR5
         KlwkuYsHt0MRFMUyPZVHc4wlxd/84JI6MAwachiNbMMVRgzs95ct7m+wMhWSQDjiB4aZ
         zrGQTqKR54Lke6GGPuqkHyxwHZsMdtUoucKdLjzpZdXtcsZeFpmytqe/Z/SoQgAt+alq
         toPo2bOGEDwflgs2gB2Gri+B2fhuWEUf7v9HvLszKDkI7fQNloqY1XDxvrGzzNFGY6nf
         hX09B+/EB7/bWYyyy1u/d8NwPwM6A/NJ8clyGoPZO3YcuZ5YP00ki0mqzQ4ddrJKDWyJ
         p/hQ==
X-Gm-Message-State: APjAAAV/Z6HEH3Y4IC853kc9DQrvHpoSdsQs47at4+oGoWmH4itDCtsF
        B1JP9CFvs2p+Aj0vOCb6IDk=
X-Google-Smtp-Source: APXvYqzKxrOb/OWjBY74fH1xU71NikR7/VTdqLkrF43LGutnBXUF+28ZYL5MYnTphYYavhE3TkPhng==
X-Received: by 2002:ac2:5468:: with SMTP id e8mr6598943lfn.113.1579299800186;
        Fri, 17 Jan 2020 14:23:20 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id r9sm14719708lfc.72.2020.01.17.14.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 14:23:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: optimise sqe-to-req flags translation
Date:   Sat, 18 Jan 2020 01:22:31 +0300
Message-Id: <2131fd747cfabb417e74d45f7a790afb8c996797.1579299684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
References: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For each IOSQE_* flag there is a corresponding REQ_F_* flag. And there
is a repetitive pattern of their translation:
e.g. if (sqe->flags & SQE_FLAG*) req->flags |= REQ_F_FLAG*

Use the same numeric value/bit for them, so this could be optimised to
check-less copy.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 58 +++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 163707ac9e76..859243ae74eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -452,6 +452,28 @@ struct io_async_ctx {
 	};
 };
 
+enum {
+	/* correspond one-to-one to IOSQE_IO_* flags*/
+	REQ_F_FIXED_FILE	= IOSQE_FIXED_FILE,	/* ctx owns file */
+	REQ_F_IO_DRAIN		= IOSQE_IO_DRAIN,	/* drain existing IO first */
+	REQ_F_LINK		= IOSQE_IO_LINK,	/* linked sqes */
+	REQ_F_HARDLINK		= IOSQE_IO_HARDLINK,	/* doesn't sever on completion < 0 */
+	REQ_F_FORCE_ASYNC	= IOSQE_ASYNC,		/* IOSQE_ASYNC */
+
+	REQ_F_LINK_NEXT		= 1 << 5,	/* already grabbed next link */
+	REQ_F_FAIL_LINK		= 1 << 6,	/* fail rest of links */
+	REQ_F_INFLIGHT		= 1 << 7,	/* on inflight list */
+	REQ_F_CUR_POS		= 1 << 8,	/* read/write uses file position */
+	REQ_F_NOWAIT		= 1 << 9,	/* must not punt to workers */
+	REQ_F_IOPOLL_COMPLETED	= 1 << 10,	/* polled IO has completed */
+	REQ_F_LINK_TIMEOUT	= 1 << 11,	/* has linked timeout */
+	REQ_F_TIMEOUT		= 1 << 12,	/* timeout request */
+	REQ_F_ISREG		= 1 << 13,	/* regular file */
+	REQ_F_MUST_PUNT		= 1 << 14,	/* must be punted even for NONBLOCK */
+	REQ_F_TIMEOUT_NOSEQ	= 1 << 15,	/* no timeout sequence */
+	REQ_F_COMP_LOCKED	= 1 << 16,	/* completion under lock */
+};
+
 /*
  * NOTE! Each of the iocb union members has the file pointer
  * as the first entry in their struct definition. So you can
@@ -494,23 +516,6 @@ struct io_kiocb {
 	struct list_head	link_list;
 	unsigned int		flags;
 	refcount_t		refs;
-#define REQ_F_NOWAIT		1	/* must not punt to workers */
-#define REQ_F_IOPOLL_COMPLETED	2	/* polled IO has completed */
-#define REQ_F_FIXED_FILE	4	/* ctx owns file */
-#define REQ_F_LINK_NEXT		8	/* already grabbed next link */
-#define REQ_F_IO_DRAIN		16	/* drain existing IO first */
-#define REQ_F_LINK		64	/* linked sqes */
-#define REQ_F_LINK_TIMEOUT	128	/* has linked timeout */
-#define REQ_F_FAIL_LINK		256	/* fail rest of links */
-#define REQ_F_TIMEOUT		1024	/* timeout request */
-#define REQ_F_ISREG		2048	/* regular file */
-#define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
-#define REQ_F_TIMEOUT_NOSEQ	8192	/* no timeout sequence */
-#define REQ_F_INFLIGHT		16384	/* on inflight list */
-#define REQ_F_COMP_LOCKED	32768	/* completion under lock */
-#define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
-#define REQ_F_FORCE_ASYNC	131072	/* IOSQE_ASYNC */
-#define REQ_F_CUR_POS		262144	/* read/write uses file position */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -4342,9 +4347,6 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	flags = READ_ONCE(sqe->flags);
 	fd = READ_ONCE(sqe->fd);
 
-	if (flags & IOSQE_IO_DRAIN)
-		req->flags |= REQ_F_IO_DRAIN;
-
 	if (!io_req_needs_file(req, fd))
 		return 0;
 
@@ -4566,6 +4568,12 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
+/*
+ * This should be equal to bitmask of corresponding REQ_F_* flags,
+ * i.e. REQ_F_IO_DRAIN|REQ_F_HARDLINK|REQ_F_FORCE_ASYNC
+ */
+#define SQE_INHERITED_FLAGS (IOSQE_IO_DRAIN|IOSQE_IO_HARDLINK|IOSQE_ASYNC)
+
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
 {
@@ -4580,8 +4588,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		ret = -EINVAL;
 		goto err_req;
 	}
-	if (sqe_flags & IOSQE_ASYNC)
-		req->flags |= REQ_F_FORCE_ASYNC;
+	req->flags |= sqe_flags & SQE_INHERITED_FLAGS;
 
 	ret = io_req_set_file(state, req, sqe);
 	if (unlikely(ret)) {
@@ -4605,10 +4612,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			head->flags |= REQ_F_IO_DRAIN;
 			ctx->drain_next = 1;
 		}
-
-		if (sqe_flags & IOSQE_IO_HARDLINK)
-			req->flags |= REQ_F_HARDLINK;
-
 		if (io_alloc_async_ctx(req)) {
 			ret = -EAGAIN;
 			goto err_req;
@@ -4635,9 +4638,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 			req->flags |= REQ_F_LINK;
-			if (sqe_flags & IOSQE_IO_HARDLINK)
-				req->flags |= REQ_F_HARDLINK;
-
 			INIT_LIST_HEAD(&req->link_list);
 			ret = io_req_defer_prep(req, sqe);
 			if (ret)
-- 
2.24.0

