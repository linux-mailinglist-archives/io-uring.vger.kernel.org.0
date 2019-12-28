Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD05B12BEB1
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfL1TVa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:21:30 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38918 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfL1TVa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:21:30 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so10115708plp.6
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=li9Jp6aQg9/LLmjzvW0oDRzhNp/39Qv0VvFTI6NriDg=;
        b=O56rg4PaPyQ9wyUSATFC4UcJfj2H41TQJZksbYFYJQM3VYqHm6ONvohycZM3IkcwZN
         qY90Xbv8pPuFcVR+bA7Sdwzhtqs/8Ue0UinyNUuNDVuLVFJNCfFXodLZbsfTLm/M1cwX
         T3LD7bcrbbjkmLcofgZiOPcqv5O0xu7RdVq3S/qMPlpvSUrXVEVNFngjq9QI0zJmzaxP
         WNE6Sxnp0yYYcsc1lUmblKjAyjEXG5UIfMnf5kCY75KQyW0JUEnB3mvCNJF3dPMSp67X
         kDYyKne7CR+LOOGXHxDEjk3p2eXBlQ5DccsnjAjYCaNhqH7NLcsmzhIUvHYmBIUoqrga
         Q9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=li9Jp6aQg9/LLmjzvW0oDRzhNp/39Qv0VvFTI6NriDg=;
        b=k0HG60DDAdylx/0kKyx7tAl8c2zG5NhCMBQgeh+NYYYFDOqJDc635IB1TTy3CcJlND
         WvHDA3d8dTAfJwVEMf9BVuc6hA7Yo9ujgl4LSG7R8Tp9Lcz0plp0uhMTIEtRXFKR8m6K
         ZAoW7dPVFEbzzxZ5EhCPMZ8yPnRVFRfRzu3ndWFdUNl8mbiObY4fZ4zMvND6lt2vqKeZ
         Q/PCqkLonZNhskeNYJjtgqd6/sImDvxTGXtKJ4aqIBF7dcqcd7EnPM9BmBRkxD4VGQ1/
         mHkFg49/4muy95VRIlZGMEwQ+JsYlue6Cf/v7QBQHbQglNqukePdwKgCXj6BwcRKUbw0
         RnFw==
X-Gm-Message-State: APjAAAWzJls+qnDsg88EICKhhs3VsR9fYyMUZAJU1h2uJBkKmxl1ksew
        TtvbxBXqPilwFqMikUymgaXQ16gkE1HK3w==
X-Google-Smtp-Source: APXvYqznICyULLsXkERCeiOEfKzZXf/FgRnFF4Djb6DZU75RRTp9RfasMLgl6kRCyzfhXTIBcYYHqQ==
X-Received: by 2002:a17:902:10e:: with SMTP id 14mr9641461plb.122.1577560889190;
        Sat, 28 Dec 2019 11:21:29 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z30sm47067902pfq.154.2019.12.28.11.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:21:28 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] io_uring: add IORING_OP_MADVISE
Date:   Sat, 28 Dec 2019 12:21:18 -0700
Message-Id: <20191228192118.4005-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191228192118.4005-1-axboe@kernel.dk>
References: <20191228192118.4005-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for doing madvise(2) through io_uring. We assume that
any operation can block, and hence punt everything async. This could be
improved, but hard to make bullet proof. The async punt ensures it's
safe.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 56 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d99b9c5a568..b1f28037aa74 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -403,7 +403,10 @@ struct io_files_update {
 
 struct io_fadvise {
 	struct file			*file;
-	u64				offset;
+	union {
+		u64			offset;
+		u64			addr;
+	};
 	u32				len;
 	u32				advice;
 };
@@ -682,6 +685,10 @@ static const struct io_op_def io_op_defs[IORING_OP_LAST] = {
 		/* IORING_OP_FADVISE */
 		.needs_file		= 1,
 	},
+	{
+		/* IORING_OP_MADVISE */
+		.needs_mm		= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -2446,6 +2453,42 @@ static int io_openat(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
+static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+#if defined(CONFIG_ADVISE_SYSCALLS)
+	if (sqe->ioprio || sqe->buf_index || sqe->off)
+		return -EINVAL;
+
+	req->fadvise.addr = READ_ONCE(sqe->addr);
+	req->fadvise.len = READ_ONCE(sqe->len);
+	req->fadvise.advice = READ_ONCE(sqe->fadvise_advice);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
+{
+#if defined(CONFIG_ADVISE_SYSCALLS)
+	struct io_fadvise *fa = &req->fadvise;
+	int ret;
+
+	if (force_nonblock)
+		return -EAGAIN;
+
+	ret = do_madvise(fa->addr, fa->len, fa->advice);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, nxt);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
 static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS)
@@ -3775,6 +3818,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_FADVISE:
 		ret = io_fadvise_prep(req, sqe);
 		break;
+	case IORING_OP_MADVISE:
+		ret = io_madvise_prep(req, sqe);
+		break;
 	default:
 		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 				req->opcode);
@@ -3979,6 +4025,14 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		ret = io_fadvise(req, nxt, force_nonblock);
 		break;
+	case IORING_OP_MADVISE:
+		if (sqe) {
+			ret = io_madvise_prep(req, sqe);
+			if (ret)
+				break;
+		}
+		ret = io_madvise(req, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f87d8fb42916..7cb6fe0fccd7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -88,6 +88,7 @@ enum {
 	IORING_OP_READ,
 	IORING_OP_WRITE,
 	IORING_OP_FADVISE,
+	IORING_OP_MADVISE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.1

