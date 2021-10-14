Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240ED42DDBD
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbhJNPOZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbhJNPOV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:14:21 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B509C06177D
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id y3so20656476wrl.1
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OmwlIeYSIlDv4XjK9O4A46Tl4S+CWj6Fe5XSsBHAflA=;
        b=ZdohtPfuxMkV/rPkvIgIlXpQAQzfuJOkvIheqxpYms60nltwpLbD59iri8a7CKxr1f
         2hhWwIatgfG3WFo/lRQMGmsP6f/beDA99l6q71mNpqZJVTXFrdgIGccl/TLBKR0iI0jR
         i31eYnRiHvjzZvnZ+nmk+IQrGkxu7qESnzZqRtqhRlInf//BOEBjJ6YvcjvCT9kwwRiG
         IjOKNNkq1bo2a0PEp2AXKFbl2EoGHoeevv7oY7/u4nUT+U5YPqJR09QO2fRPY3ou54vr
         1tbJ5gDNrsgYLL7r9fjSPhfSqWcqCz+FsqBKj47etChSd5YoUGqXIJdWx89CmMCfbTTG
         8qtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OmwlIeYSIlDv4XjK9O4A46Tl4S+CWj6Fe5XSsBHAflA=;
        b=ocq6PSwTuiS4M5+oHxgskAt6bEiACQeTOi5DJpyi0lRDQ8+cx4TVv9zUndRx87H/Qf
         M2VqyFCuHzNjh2dNlRvmMA8r1CkqdpngJ4UjNSh3hB0nimS1QzUF7wsO798wDCwNGj0i
         lHOKf7b8Rsl2hSje2B7x/VXIj3XLCgzZE1DydObiLKaVNWpslkVgInICHsJbehxzrDfw
         G/qkCjiW2/tDRYFipzWNpSLB1vghe1FRMBMN3ErjwVrIUIkft5emGJH4WpzKeAvDNNek
         jMgM7swpc+YDDArwTjwoESLPLHpjz9H06iwW2UzicSzeLcHfMMrZHI9OynwY5qyHIKKr
         OCRA==
X-Gm-Message-State: AOAM531Bysu8LStY7A81HhphFEqIO/4YH3/AT9RB1UP2gBOZ3hkJlLu1
        wIKeDKy57t3YwqC45j1sRbkhaYm5at0=
X-Google-Smtp-Source: ABdhPJy9f1ynlI6goJanLOiLYHPsViRGusejYlwJeUYtfivFv8dhNEmRK8b5ZqK6bfnfNeguzknXyQ==
X-Received: by 2002:adf:b1d4:: with SMTP id r20mr7277151wra.308.1634224272293;
        Thu, 14 Oct 2021 08:11:12 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id c14sm2549557wrd.50.2021.10.14.08.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:11:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/8] io_uring: optimise read/write iov state storing
Date:   Thu, 14 Oct 2021 16:10:16 +0100
Message-Id: <5c5e7ffd7dc25fc35075c70411ba99df72f237fa.1634144845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634144845.git.asml.silence@gmail.com>
References: <cover.1634144845.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently io_read() and io_write() keep separate pointers to an iter and
to struct iov_iter_state, which is not great for register spilling and
requires more on-stack copies. They are both either on-stack or in
req->async_data at the same time, so use struct io_rw_state and keep a
pointer only to it, so having all the state with just one pointer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 79 ++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 42 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3447243805d9..248ef7b09268 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -694,9 +694,9 @@ struct io_async_msghdr {
 };
 
 struct io_rw_state {
-	struct iovec			fast_iov[UIO_FASTIOV];
 	struct iov_iter			iter;
 	struct iov_iter_state		iter_state;
+	struct iovec			fast_iov[UIO_FASTIOV];
 };
 
 struct io_async_rw {
@@ -3259,8 +3259,7 @@ static inline bool io_alloc_async_data(struct io_kiocb *req)
 }
 
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
-			     const struct iovec *fast_iov,
-			     struct iov_iter *iter, bool force)
+			     struct io_rw_state *s, bool force)
 {
 	if (!force && !io_op_defs[req->opcode].needs_async_setup)
 		return 0;
@@ -3272,7 +3271,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			return -ENOMEM;
 		}
 
-		io_req_map_rw(req, iovec, fast_iov, iter);
+		io_req_map_rw(req, iovec, s->fast_iov, &s->iter);
 		iorw = req->async_data;
 		/* we've copied and mapped the iter, ensure state is saved */
 		iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
@@ -3394,33 +3393,33 @@ static bool need_read_all(struct io_kiocb *req)
 
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct io_rw_state __s, *s;
+	struct iovec *iovec;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	struct iov_iter __iter, *iter = &__iter;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	struct iov_iter_state __state, *state;
 	struct io_async_rw *rw;
 	ssize_t ret, ret2;
 
 	if (req_has_async_data(req)) {
 		rw = req->async_data;
-		iter = &rw->s.iter;
-		state = &rw->s.iter_state;
+		s = &rw->s;
 		/*
 		 * We come here from an earlier attempt, restore our state to
 		 * match in case it doesn't. It's cheap enough that we don't
 		 * need to make this conditional.
 		 */
-		iov_iter_restore(iter, state);
+		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	} else {
-		ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
+		s = &__s;
+		iovec = s->fast_iov;
+		ret = io_import_iovec(READ, req, &iovec, &s->iter, !force_nonblock);
 		if (ret < 0)
 			return ret;
-		state = &__state;
-		iov_iter_save_state(iter, state);
+
+		iov_iter_save_state(&s->iter, &s->iter_state);
 	}
-	req->result = iov_iter_count(iter);
+	req->result = iov_iter_count(&s->iter);
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -3430,7 +3429,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	/* If the file doesn't support async, just async punt */
 	if (force_nonblock && !io_file_supports_nowait(req, READ)) {
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
+		ret = io_setup_async_rw(req, iovec, s, true);
 		return ret ?: -EAGAIN;
 	}
 
@@ -3440,7 +3439,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 	}
 
-	ret = io_iter_do_read(req, iter);
+	ret = io_iter_do_read(req, &s->iter);
 
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
@@ -3464,22 +3463,19 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * untouched in case of error. Restore it and we'll advance it
 	 * manually if we need to.
 	 */
-	iov_iter_restore(iter, state);
+	iov_iter_restore(&s->iter, &s->iter_state);
 
-	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
+	ret2 = io_setup_async_rw(req, iovec, s, true);
 	if (ret2)
 		return ret2;
 
 	iovec = NULL;
 	rw = req->async_data;
+	s = &rw->s;
 	/*
 	 * Now use our persistent iterator and state, if we aren't already.
 	 * We've restored and mapped the iter to match.
 	 */
-	if (iter != &rw->s.iter) {
-		iter = &rw->s.iter;
-		state = &rw->s.iter_state;
-	}
 
 	do {
 		/*
@@ -3487,11 +3483,11 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 * above or inside this loop. Advance the iter by the bytes
 		 * that were consumed.
 		 */
-		iov_iter_advance(iter, ret);
-		if (!iov_iter_count(iter))
+		iov_iter_advance(&s->iter, ret);
+		if (!iov_iter_count(&s->iter))
 			break;
 		rw->bytes_done += ret;
-		iov_iter_save_state(iter, state);
+		iov_iter_save_state(&s->iter, &s->iter_state);
 
 		/* if we can retry, do so with the callbacks armed */
 		if (!io_rw_should_retry(req)) {
@@ -3505,12 +3501,12 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 * desired page gets unlocked. We can also get a partial read
 		 * here, and if we do, then just retry at the new offset.
 		 */
-		ret = io_iter_do_read(req, iter);
+		ret = io_iter_do_read(req, &s->iter);
 		if (ret == -EIOCBQUEUED)
 			return 0;
 		/* we got some bytes, but not all. retry. */
 		kiocb->ki_flags &= ~IOCB_WAITQ;
-		iov_iter_restore(iter, state);
+		iov_iter_restore(&s->iter, &s->iter_state);
 	} while (ret > 0);
 done:
 	kiocb_done(kiocb, ret, issue_flags);
@@ -3530,28 +3526,27 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct io_rw_state __s, *s;
+	struct io_async_rw *rw;
+	struct iovec *iovec;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	struct iov_iter __iter, *iter = &__iter;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	struct iov_iter_state __state, *state;
-	struct io_async_rw *rw;
 	ssize_t ret, ret2;
 
 	if (req_has_async_data(req)) {
 		rw = req->async_data;
-		iter = &rw->s.iter;
-		state = &rw->s.iter_state;
-		iov_iter_restore(iter, state);
+		s = &rw->s;
+		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	} else {
-		ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
+		s = &__s;
+		iovec = s->fast_iov;
+		ret = io_import_iovec(WRITE, req, &iovec, &s->iter, !force_nonblock);
 		if (ret < 0)
 			return ret;
-		state = &__state;
-		iov_iter_save_state(iter, state);
+		iov_iter_save_state(&s->iter, &s->iter_state);
 	}
-	req->result = iov_iter_count(iter);
+	req->result = iov_iter_count(&s->iter);
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -3587,9 +3582,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (req->file->f_op->write_iter)
-		ret2 = call_write_iter(req->file, kiocb, iter);
+		ret2 = call_write_iter(req->file, kiocb, &s->iter);
 	else if (req->file->f_op->write)
-		ret2 = loop_rw_iter(WRITE, req, iter);
+		ret2 = loop_rw_iter(WRITE, req, &s->iter);
 	else
 		ret2 = -EINVAL;
 
@@ -3615,8 +3610,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb_done(kiocb, ret2, issue_flags);
 	} else {
 copy_iov:
-		iov_iter_restore(iter, state);
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
+		iov_iter_restore(&s->iter, &s->iter_state);
+		ret = io_setup_async_rw(req, iovec, s, false);
 		return ret ?: -EAGAIN;
 	}
 out_free:
-- 
2.33.0

