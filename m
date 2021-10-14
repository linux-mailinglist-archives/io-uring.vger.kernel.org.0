Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE2942DDBF
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbhJNPO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbhJNPOV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:14:21 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A61C06177F
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:16 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g25so20459394wrb.2
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=amO6BHYoY732BRQ3C+3uD+BilWE7a4KJzuH+dyj+mZ4=;
        b=FaC0YOJBcpKLmXB/lM2WZ/cJmBFqI6OB71Mj1F930mi4LrYCqYozRVR8UmDoB7xgY7
         qyyfqRic397iCdjdimVt2QUy1lZnp5WIfUX01JxaBy4Y/f7owIDK64NmokanwJuwtK6O
         dyLto5hBVZeTzagoxwkIYikvIKl7mXKXTkifGS+m7BvEvq5CT96i89Y7ZE7rx5kZwLT6
         efsNELwfF58GC9Fqt2xoG73bAnUEBRSVJC4KR8WNaPWOSeKSP9CdBAoeRkEMdu8NVi43
         Nt/qgwwiE+SAaYzgwk1viLf2lU7F3tRdietw7Hc1fsHFyTIQ/bEHuY8rC8kvYsqTAOuF
         TjwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=amO6BHYoY732BRQ3C+3uD+BilWE7a4KJzuH+dyj+mZ4=;
        b=GGbHigJPj5Mpec5ZpDQjVtPWkJNdiOQOMD4lEZO7HiW8sLM7oFsrdYQcbk1pg889Su
         Vxn9aqCiBnO4litz+Jng6iwwDZ+8qcjcerE8rMzXg+a36okd35iDQXgovL4jo8uWBvRl
         l4zwXea8xUTb5T6pEumeVMcwVHoiBa8WuUMKFk29jdeEn0X8mZ7qw4JrGq4MYZTnYk3D
         DLYu0iZtFcgKeOiLfu9ajWdP0NLHLPEQkKRPeeR2gQfWeS7AOJ7PJVLXtOO0o3mNhv91
         M46/4fVXgjRXSAqmi5whAnOlST7/kkRn18te0lFy7/i1gDs4xq82NKUfdAIpwanF4qHh
         4v6w==
X-Gm-Message-State: AOAM5316nxPFs2/EqRMbBAnxxxsBJ9JcsyEY99gl5FYZ8SPRbgIJqY6C
        llaIfZstYHeir//bxiFAKknoPXnHZuE=
X-Google-Smtp-Source: ABdhPJy9HHu2qxUAzEGu2OiozbxlSHpN0hB2fBH2PAF/N+OF+S8CXPO6W7SjEOKcZyQTPrlKkulyHQ==
X-Received: by 2002:a7b:c444:: with SMTP id l4mr19858111wmi.115.1634224274288;
        Thu, 14 Oct 2021 08:11:14 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id c14sm2549557wrd.50.2021.10.14.08.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:11:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 7/8] io_uring: clean up io_import_iovec
Date:   Thu, 14 Oct 2021 16:10:18 +0100
Message-Id: <b1bbc213a95e5272d4da5867bb977d9acb6f2109.1634144845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634144845.git.asml.silence@gmail.com>
References: <cover.1634144845.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_import_iovec taking struct io_rw_state instead of an iter
pointer. First it takes care of initialising iovec pointer, which can be
forgotten. Even more, we can not init it if not needed, e.g. in case of
IORING_OP_READ_FIXED or IORING_OP_READ. Also hide saving iter_state
inside of it by splitting out an inline function of it to avoid extra
ifs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a22a983fb53..f9af54b10238 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3117,9 +3117,10 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	return __io_iov_buffer_select(req, iov, issue_flags);
 }
 
-static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
-			   struct iov_iter *iter, unsigned int issue_flags)
+static int __io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
+			     struct io_rw_state *s, unsigned int issue_flags)
 {
+	struct iov_iter *iter = &s->iter;
 	void __user *buf = u64_to_user_ptr(req->rw.addr);
 	size_t sqe_len = req->rw.len;
 	u8 opcode = req->opcode;
@@ -3142,11 +3143,13 @@ static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
 			req->rw.len = sqe_len;
 		}
 
-		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
+		ret = import_single_range(rw, buf, sqe_len, s->fast_iov, iter);
 		*iovec = NULL;
 		return ret;
 	}
 
+	*iovec = s->fast_iov;
+
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		ret = io_iov_buffer_select(req, *iovec, issue_flags);
 		if (!ret)
@@ -3159,6 +3162,19 @@ static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
 			      req->ctx->compat);
 }
 
+static inline int io_import_iovec(int rw, struct io_kiocb *req,
+				  struct iovec **iovec, struct io_rw_state *s,
+				  unsigned int issue_flags)
+{
+	int ret;
+
+	ret = __io_import_iovec(rw, req, iovec, s, issue_flags);
+	if (unlikely(ret < 0))
+		return ret;
+	iov_iter_save_state(&s->iter, &s->iter_state);
+	return ret;
+}
+
 static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
 {
 	return (kiocb->ki_filp->f_mode & FMODE_STREAM) ? NULL : &kiocb->ki_pos;
@@ -3284,11 +3300,11 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 {
 	struct io_async_rw *iorw = req->async_data;
-	struct iovec *iov = iorw->s.fast_iov;
+	struct iovec *iov;
 	int ret;
 
 	/* submission path, ->uring_lock should already be taken */
-	ret = io_import_iovec(rw, req, &iov, &iorw->s.iter, IO_URING_F_NONBLOCK);
+	ret = io_import_iovec(rw, req, &iov, &iorw->s, IO_URING_F_NONBLOCK);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -3296,7 +3312,6 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	iorw->free_iovec = iov;
 	if (iov)
 		req->flags |= REQ_F_NEED_CLEANUP;
-	iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
 	return 0;
 }
 
@@ -3415,12 +3430,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iovec = NULL;
 	} else {
 		s = &__s;
-		iovec = s->fast_iov;
-		ret = io_import_iovec(READ, req, &iovec, &s->iter, issue_flags);
-		if (ret < 0)
+		ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
+		if (unlikely(ret < 0))
 			return ret;
-
-		iov_iter_save_state(&s->iter, &s->iter_state);
 	}
 	req->result = iov_iter_count(&s->iter);
 
@@ -3543,11 +3555,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		iovec = NULL;
 	} else {
 		s = &__s;
-		iovec = s->fast_iov;
-		ret = io_import_iovec(WRITE, req, &iovec, &s->iter, issue_flags);
-		if (ret < 0)
+		ret = io_import_iovec(WRITE, req, &iovec, s, issue_flags);
+		if (unlikely(ret < 0))
 			return ret;
-		iov_iter_save_state(&s->iter, &s->iter_state);
 	}
 	req->result = iov_iter_count(&s->iter);
 
-- 
2.33.0

