Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965541418AA
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2020 18:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgARRXa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jan 2020 12:23:30 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38825 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgARRXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jan 2020 12:23:30 -0500
Received: by mail-lj1-f194.google.com with SMTP id w1so29719917ljh.5;
        Sat, 18 Jan 2020 09:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=r7TzoLi4oIXDb+aVX8JdAgaI6J0aWVUzpv68Gy/CxWY=;
        b=C0JjhKiS8oL1gd/Qcw621cP0UJy8nsR4wJ6Ibnjg3AROL0LNnMRq4tMe3NBCdHVdrZ
         kluT1TouR0G3gnZDU9GkH/gJYF2Ch1SsmXwQL2Y0WiMC2JvD+SrABQ6lJZ/sPKFUMusr
         4oA6Xhhb0YRgwZVEG9BYLWM+w0VUS9CV0pU4XxA6bHer0ntQYDA6RDQixU9jwosAFzNS
         WrNBihclSlJQ5CwQXRePTEew2t9y8kfhyjK3EqiiyGtktqISb8oPcJEpJVOKZLIJTUHp
         POaxcWGxM+hG2tD3RbAqhRf40OiJ324OzxUlPdVklPskIEOIVHm+4UCJlxfkpk4w528S
         dQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r7TzoLi4oIXDb+aVX8JdAgaI6J0aWVUzpv68Gy/CxWY=;
        b=gbftO2sYj/1RJ4LRU676SA55HqR/R199gqRSkibAhwy0WiNUXC4JlVwz1D8nR0HWJt
         qMsgh1bdvf/7j8nTsdxheJ0cmmAr1SgHAy1XB/DmfZwjZNm1aPxM1ixllR3CmjHdpnDp
         lqmp2oPxhIATZI4pwHK3Haipc4DaikZiZtkp4oznWq8XhHrbi+215wi0FbL8TwPgla7n
         3ql2RNUJXFVZ1bgn+9eyocNu20nMco7NgX+XpeUGTboqgVSzbyv+74dVtLmOKa8JkWoR
         lPnDUifVULqyDFVRq/g4ot5pNbS5/HmlSFPDLt1xW6Fn4Zy0+J53FmY0bSwXvu1u1PcQ
         BbLw==
X-Gm-Message-State: APjAAAU+TasaD+ZCt1uWOkcqzbkl3j3uJwVtWPxx0kk+pD6eevSNVjxt
        bbDGMo6CrbOn4m1aHokWaKslfgEU
X-Google-Smtp-Source: APXvYqzsXDrW2hRWJfe98sSdnt6US5wBJ7+zbbLLwPqbo8bX0HfBaPskh/tWPADz8jsluNDS8zY/QA==
X-Received: by 2002:a2e:b0db:: with SMTP id g27mr8306973ljl.74.1579368207792;
        Sat, 18 Jan 2020 09:23:27 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id l64sm13966641lfd.30.2020.01.18.09.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 09:23:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/1] io_uring: optimise sqe-to-req flags translation
Date:   Sat, 18 Jan 2020 20:22:41 +0300
Message-Id: <648dbd08d8acb9c959acdd0fc76e8482d83635dd.1579368079.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <ad7c75c3-b660-9814-e3fe-ef5a3acd7e8f@gmail.com>
References: <ad7c75c3-b660-9814-e3fe-ef5a3acd7e8f@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For each IOSQE_* flag there is a corresponding REQ_F_* flag. And there
is a repetitive pattern of their translation:
e.g. if (sqe->flags & SQE_FLAG*) req->flags |= REQ_F_FLAG*

Use same numeric values/bits for them and copy instead of manual
handling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: enum to generate bits (Jens Axboe)
v3: don't use BIT() for userspace headers (Jens Axboe)
    leave IOSQE_* as defines for compatibility (Jens Axboe)

 fs/io_uring.c                 | 92 ++++++++++++++++++++++++-----------
 include/uapi/linux/io_uring.h | 23 +++++++--
 2 files changed, 81 insertions(+), 34 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed1adeda370e..cf5bad51f752 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -46,6 +46,7 @@
 #include <linux/compat.h>
 #include <linux/refcount.h>
 #include <linux/uio.h>
+#include <linux/bits.h>
 
 #include <linux/sched/signal.h>
 #include <linux/fs.h>
@@ -452,6 +453,65 @@ struct io_async_ctx {
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
+	/* ctx owns file */
+	REQ_F_FIXED_FILE	= BIT(REQ_F_FIXED_FILE_BIT),
+	/* drain existing IO first */
+	REQ_F_IO_DRAIN		= BIT(REQ_F_IO_DRAIN_BIT),
+	/* linked sqes */
+	REQ_F_LINK		= BIT(REQ_F_LINK_BIT),
+	/* doesn't sever on completion < 0 */
+	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),
+	/* IOSQE_ASYNC */
+	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
+
+	/* already grabbed next link */
+	REQ_F_LINK_NEXT		= BIT(REQ_F_LINK_NEXT_BIT),
+	/* fail rest of links */
+	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
+	/* on inflight list */
+	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
+	/* read/write uses file position */
+	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
+	/* must not punt to workers */
+	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
+	/* polled IO has completed */
+	REQ_F_IOPOLL_COMPLETED	= BIT(REQ_F_IOPOLL_COMPLETED_BIT),
+	/* has linked timeout */
+	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
+	/* timeout request */
+	REQ_F_TIMEOUT		= BIT(REQ_F_TIMEOUT_BIT),
+	/* regular file */
+	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
+	/* must be punted even for NONBLOCK */
+	REQ_F_MUST_PUNT		= BIT(REQ_F_MUST_PUNT_BIT),
+	/* no timeout sequence */
+	REQ_F_TIMEOUT_NOSEQ	= BIT(REQ_F_TIMEOUT_NOSEQ_BIT),
+	/* completion under lock */
+	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
+};
+
 /*
  * NOTE! Each of the iocb union members has the file pointer
  * as the first entry in their struct definition. So you can
@@ -494,23 +554,6 @@ struct io_kiocb {
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
@@ -4355,9 +4398,6 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 	flags = READ_ONCE(sqe->flags);
 	fd = READ_ONCE(sqe->fd);
 
-	if (flags & IOSQE_IO_DRAIN)
-		req->flags |= REQ_F_IO_DRAIN;
-
 	if (!io_req_needs_file(req, fd))
 		return 0;
 
@@ -4593,8 +4633,9 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -4618,10 +4659,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -4648,9 +4685,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
index 955fd477e530..57d05cc5e271 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -45,14 +45,27 @@ struct io_uring_sqe {
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
+/* use fixed fileset */
+#define IOSQE_FIXED_FILE	(1U << IOSQE_FIXED_FILE_BIT)
+/* issue after inflight IO */
+#define IOSQE_IO_DRAIN		(1U << IOSQE_IO_DRAIN_BIT)
+/* links next sqe */
+#define IOSQE_IO_LINK		(1U << IOSQE_IO_LINK_BIT)
+/* like LINK, but stronger */
+#define IOSQE_IO_HARDLINK	(1U << IOSQE_IO_HARDLINK_BIT)
+/* always go async */
+#define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 
 /*
  * io_uring_setup() flags
-- 
2.24.0

