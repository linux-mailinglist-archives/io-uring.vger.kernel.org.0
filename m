Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0781416FA
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2020 11:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgARKZH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jan 2020 05:25:07 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34191 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgARKZH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jan 2020 05:25:07 -0500
Received: by mail-wr1-f66.google.com with SMTP id t2so24958290wrr.1;
        Sat, 18 Jan 2020 02:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ccngIRSElwcAlLJmBzYYxqh5Y5c29YrzS8zO2nU/JzQ=;
        b=KRSiu9P3Ft4cNXD8ws45tFWKK1z8WPM8gJX0ySrmbSq6D7EddjF34ELSysgcKG8MWr
         QZBENsl3zhfhJrQW6a7F49hgCltFI/lUoQUw3HFTceI8iNip/abp6EwLOzqSHJyWUDcd
         i3vveqMgYoU2PDJP76Eps3PXZePjVOpRr7lyxwPEna3zG2wfV4AHVEkNTFZEIIxQyK5F
         CeQJE46bpaaS8CQLp9Aj6pUwGiUUBkx5aB8WHpgzgImQaw0TJj178WSTiUKdT910G4Kx
         LkWaUwARNmAA4zwqA6Lq9oKrCj34wwprVlKJrbunroDzoXMeLVlVYzXL1IWcoZOpDaYH
         ghjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ccngIRSElwcAlLJmBzYYxqh5Y5c29YrzS8zO2nU/JzQ=;
        b=hKsVaBGWJ0uSqnalsXzP3OtYvFqHvt2QYjbBssQR6huEV3pDm2mH4tyfa4l7LAU4gh
         t94bprXgBpHjsooPvWHzrnwUwG99o2cabyw4cSAGPL0of3RS8Ad4Co4Pg6va3IYoIS3w
         z8CP1qPAKJY3d0wtn6YXMbviuVysJVGVIbTAh8V5vUWB6OEHpbFW2HjFzSg6DI4sbDs7
         Q59H9YSZUTkgo0LdPCQ+wsQDz2RHHd4AaCs9QKmBb0YhfOiVpi/r/zXsuBwfls9g/nQs
         bzUR5jf/UR/xWxOBd0yBOSVeQU4TzFfeBn1989WCpcG6gM875jY7zoxMUnrFRwM5+hx5
         QB6Q==
X-Gm-Message-State: APjAAAV2ci8hC6jA5Lf/V+i0Hm79iCNyPXhtCniWPa1szi33SjsCCZgj
        MO7XQYu6x7Ks23+v+adgUeU=
X-Google-Smtp-Source: APXvYqyX4IP3pARzg/JBGKtAcEeeylfiy/XAS+/oOMRAeSqDMCBGSolZwI9KAEdNNP8gaF76qvnPVg==
X-Received: by 2002:a5d:50ce:: with SMTP id f14mr8146473wrt.254.1579343104324;
        Sat, 18 Jan 2020 02:25:04 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id v62sm40345wmg.3.2020.01.18.02.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 02:25:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring: optimise sqe-to-req flags translation
Date:   Sat, 18 Jan 2020 13:24:24 +0300
Message-Id: <06bcf64774c4730b33d1ef65e4fcb67f381cae08.1579340590.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <b507d39e-ec2b-5c9f-0fd0-6ab1b0491cad@kernel.dk>
References: <b507d39e-ec2b-5c9f-0fd0-6ab1b0491cad@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For each IOSQE_* flag there is a corresponding REQ_F_* flag. And there
is a repetitive pattern of their translation:
e.g. if (sqe->flags & SQE_FLAG*) req->flags |= REQ_F_FLAG*

Use the same numerical values/bits for them, and copy them instead of
manual handling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: enum to generate bits (Jens Axboe)
    Comments cross 80 chars, but IMHO more visually appealing

Crosses 

 fs/io_uring.c                 | 75 +++++++++++++++++++++--------------
 include/uapi/linux/io_uring.h | 26 +++++++++---
 2 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed1adeda370e..e3e2438a7480 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -452,6 +452,49 @@ struct io_async_ctx {
 	};
 };
 
+enum {
+	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
+	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
+	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
+	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
+	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
+
+	REQ_F_LINK_NEXT_BIT,
+	REQ_F_FAIL_LINK_BIT,
+	REQ_F_INFLIGHT_BIT,
+	REQ_F_CUR_POS_BIT,
+	REQ_F_NOWAIT_BIT,
+	REQ_F_IOPOLL_COMPLETED_BIT,
+	REQ_F_LINK_TIMEOUT_BIT,
+	REQ_F_TIMEOUT_BIT,
+	REQ_F_ISREG_BIT,
+	REQ_F_MUST_PUNT_BIT,
+	REQ_F_TIMEOUT_NOSEQ_BIT,
+	REQ_F_COMP_LOCKED_BIT,
+};
+
+enum {
+	/* correspond one-to-one to IOSQE_IO_* flags*/
+	REQ_F_FIXED_FILE	= BIT(REQ_F_FIXED_FILE_BIT),	/* ctx owns file */
+	REQ_F_IO_DRAIN		= BIT(REQ_F_IO_DRAIN_BIT),	/* drain existing IO first */
+	REQ_F_LINK		= BIT(REQ_F_LINK_BIT),		/* linked sqes */
+	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),	/* doesn't sever on completion < 0 */
+	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),	/* IOSQE_ASYNC */
+
+	REQ_F_LINK_NEXT		= BIT(REQ_F_LINK_NEXT_BIT),	/* already grabbed next link */
+	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),	/* fail rest of links */
+	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),	/* on inflight list */
+	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),	/* read/write uses file position */
+	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),	/* must not punt to workers */
+	REQ_F_IOPOLL_COMPLETED	= BIT(REQ_F_IOPOLL_COMPLETED_BIT),/* polled IO has completed */
+	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),	/* has linked timeout */
+	REQ_F_TIMEOUT		= BIT(REQ_F_TIMEOUT_BIT),	/* timeout request */
+	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),		/* regular file */
+	REQ_F_MUST_PUNT		= BIT(REQ_F_MUST_PUNT_BIT),	/* must be punted even for NONBLOCK */
+	REQ_F_TIMEOUT_NOSEQ	= BIT(REQ_F_TIMEOUT_NOSEQ_BIT),	/* no timeout sequence */
+	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),	/* completion under lock */
+};
+
 /*
  * NOTE! Each of the iocb union members has the file pointer
  * as the first entry in their struct definition. So you can
@@ -494,23 +537,6 @@ struct io_kiocb {
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
@@ -4355,9 +4381,6 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	flags = READ_ONCE(sqe->flags);
 	fd = READ_ONCE(sqe->fd);
 
-	if (flags & IOSQE_IO_DRAIN)
-		req->flags |= REQ_F_IO_DRAIN;
-
 	if (!io_req_needs_file(req, fd))
 		return 0;
 
@@ -4593,8 +4616,9 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		ret = -EINVAL;
 		goto err_req;
 	}
-	if (sqe_flags & IOSQE_ASYNC)
-		req->flags |= REQ_F_FORCE_ASYNC;
+	/* same numerical values with corresponding REQ_F_*, safe to copy */
+	req->flags |= sqe_flags & (IOSQE_IO_DRAIN|IOSQE_IO_HARDLINK|
+					IOSQE_ASYNC);
 
 	ret = io_req_set_file(state, req, sqe);
 	if (unlikely(ret)) {
@@ -4618,10 +4642,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -4648,9 +4668,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 			req->flags |= REQ_F_LINK;
-			if (sqe_flags & IOSQE_IO_HARDLINK)
-				req->flags |= REQ_F_HARDLINK;
-
 			INIT_LIST_HEAD(&req->link_list);
 			ret = io_req_defer_prep(req, sqe);
 			if (ret)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 955fd477e530..cee59996b23a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -10,6 +10,7 @@
 
 #include <linux/fs.h>
 #include <linux/types.h>
+#include <linux/bits.h>
 
 /*
  * IO submission data structure (Submission Queue Entry)
@@ -45,14 +46,29 @@ struct io_uring_sqe {
 	};
 };
 
+enum {
+	IOSQE_FIXED_FILE_BIT,
+	IOSQE_IO_DRAIN_BIT,
+	IOSQE_IO_LINK_BIT,
+	IOSQE_IO_HARDLINK_BIT,
+	IOSQE_ASYNC_BIT,
+};
+
 /*
  * sqe->flags
  */
-#define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
-#define IOSQE_IO_DRAIN		(1U << 1)	/* issue after inflight IO */
-#define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
-#define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
-#define IOSQE_ASYNC		(1U << 4)	/* always go async */
+enum {
+	/* use fixed fileset */
+	IOSQE_FIXED_FILE	= BIT(IOSQE_FIXED_FILE_BIT),
+	/* issue after inflight IO */
+	IOSQE_IO_DRAIN		= BIT(IOSQE_IO_DRAIN_BIT),
+	/* links next sqe */
+	IOSQE_IO_LINK		= BIT(IOSQE_IO_LINK_BIT),
+	/* like LINK, but stronger */
+	IOSQE_IO_HARDLINK	= BIT(IOSQE_IO_HARDLINK_BIT),
+	/* always go async */
+	IOSQE_ASYNC		= BIT(IOSQE_ASYNC_BIT),
+};
 
 /*
  * io_uring_setup() flags
-- 
2.24.0

