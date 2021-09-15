Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42EF40CA18
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhIOQbG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhIOQbD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:31:03 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BB2C061575
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:29:44 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id b6so3628781ilv.0
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=68QMgaOyy30ZWzL6VMOv0u6xAXRoGMvigRmyjt3oLcw=;
        b=g4y04qurQjxWPvWomB7+xnwZltDDNwwIq1tQDrA3GvSggskcK4+qtoZuWW9Ay6EXrR
         Oq0vmGKOc3utiT51usgqySMAF+kdlLus8XlBtJgIOO8kokkf1G0VYhl5KQeWnLie11zx
         aO8pQhyPvlXnjE6VYGBGLM/31Z7KyZz98WV+WaHLfgM/CxTAQfcbPPYXBHbLZ0Ig1+Hw
         mXKarhTwMYZ0DQDBDSCGB40hAUlNvn6nmd/Z7/GO5rd7TcSYLh62gvWir/3BhXI5++wz
         sryQHnS2jOxnS/3P69MOOEkyQM6waBax2/dEE26y/fBI5yx/Za72lFmUWOR57KuKCt4t
         sk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=68QMgaOyy30ZWzL6VMOv0u6xAXRoGMvigRmyjt3oLcw=;
        b=K88pVgYP/BVgEXJDAddvtcqR2HlXnHTSGbKvMy3ZYeVA6uz603qlBmZ9DG50boNc4T
         oFZMC8sC1VNv69uuqhETy0wZFcZzxJ6i5J1RintRAXfrfOuEqNZ2s3ZB8VVoxElCid66
         aGo/ajcF6poQP8tPXpjMFGJQIhDZTWnsuLzq3gnCfKB/FUg0R8vgUhn6XwGR2GjOF0fT
         3TIB4w8cY4HVpyxoLl2fblroxYmYxhIKl27CVO0kyMHs+WYduizCzozUQLSc22cd5NaF
         JUfP1BuoackVFE6wiHlmLC1laK1SxO8m1Ymxh5R/fL5/ZVlk4hZs2Wo/JuuH3lFIv78y
         aIxg==
X-Gm-Message-State: AOAM532l4u9ji77cKsgJG0vB+X9kKRQo3Rh81OUapQ2QgQefARqIybJs
        pGBzaZ5io8A9ecSlo+mAIAWJrin6swzByO/UhwE=
X-Google-Smtp-Source: ABdhPJxgUVu+M1LHqGpjznDJ+rPyInPuyzWHclEyGlCSFOsvCQyKu/xId6P3mCNg93VlDAeknvuG/Q==
X-Received: by 2002:a05:6e02:5a3:: with SMTP id k3mr652283ils.283.1631723384023;
        Wed, 15 Sep 2021 09:29:44 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t15sm227160ioi.7.2021.09.15.09.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:29:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: use iov_iter state save/restore helpers
Date:   Wed, 15 Sep 2021 10:29:36 -0600
Message-Id: <20210915162937.777002-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915162937.777002-1-axboe@kernel.dk>
References: <20210915162937.777002-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Get rid of the need to do re-expand and revert on an iterator when we
encounter a short IO, or failure that warrants a retry. Use the new
state save/restore helpers instead.

We keep the iov_iter_state persistent across retries, if we need to
restart the read or write operation. If there's a pending retry, the
operation will always exit with the state correctly saved.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 82 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 855ea544807f..25bda8a5a4e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -712,6 +712,7 @@ struct io_async_rw {
 	struct iovec			fast_iov[UIO_FASTIOV];
 	const struct iovec		*free_iovec;
 	struct iov_iter			iter;
+	struct iov_iter_state		iter_state;
 	size_t				bytes_done;
 	struct wait_page_queue		wpq;
 };
@@ -2608,8 +2609,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 
 	if (!rw)
 		return !io_req_prep_async(req);
-	/* may have left rw->iter inconsistent on -EIOCBQUEUED */
-	iov_iter_revert(&rw->iter, req->result - iov_iter_count(&rw->iter));
+	iov_iter_restore(&rw->iter, &rw->iter_state);
 	return true;
 }
 
@@ -3310,12 +3310,17 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 	if (!force && !io_op_defs[req->opcode].needs_async_setup)
 		return 0;
 	if (!req->async_data) {
+		struct io_async_rw *iorw;
+
 		if (io_alloc_async_data(req)) {
 			kfree(iovec);
 			return -ENOMEM;
 		}
 
 		io_req_map_rw(req, iovec, fast_iov, iter);
+		iorw = req->async_data;
+		/* we've copied and mapped the iter, ensure state is saved */
+		iov_iter_save_state(&iorw->iter, &iorw->iter_state);
 	}
 	return 0;
 }
@@ -3334,6 +3339,7 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	iorw->free_iovec = iov;
 	if (iov)
 		req->flags |= REQ_F_NEED_CLEANUP;
+	iov_iter_save_state(&iorw->iter, &iorw->iter_state);
 	return 0;
 }
 
@@ -3437,19 +3443,28 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
-	ssize_t io_size, ret, ret2;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct iov_iter_state __state, *state;
+	ssize_t ret, ret2;
 
 	if (rw) {
 		iter = &rw->iter;
+		state = &rw->iter_state;
+		/*
+		 * We come here from an earlier attempt, restore our state to
+		 * match in case it doesn't. It's cheap enough that we don't
+		 * need to make this conditional.
+		 */
+		iov_iter_restore(iter, state);
 		iovec = NULL;
 	} else {
 		ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 		if (ret < 0)
 			return ret;
+		state = &__state;
+		iov_iter_save_state(iter, state);
 	}
-	io_size = iov_iter_count(iter);
-	req->result = io_size;
+	req->result = iov_iter_count(iter);
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -3463,7 +3478,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
+	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3479,30 +3494,49 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
 			goto done;
-		/* some cases will consume bytes even on error returns */
-		iov_iter_reexpand(iter, iter->count + iter->truncated);
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
 		goto out_free;
-	} else if (ret <= 0 || ret == io_size || !force_nonblock ||
+	} else if (ret <= 0 || ret == req->result || !force_nonblock ||
 		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
 
+	/*
+	 * Don't depend on the iter state matching what was consumed, or being
+	 * untouched in case of error. Restore it and we'll advance it
+	 * manually if we need to.
+	 */
+	iov_iter_restore(iter, state);
+
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 	if (ret2)
 		return ret2;
 
 	iovec = NULL;
 	rw = req->async_data;
-	/* now use our persistent iterator, if we aren't already */
-	iter = &rw->iter;
+	/*
+	 * Now use our persistent iterator and state, if we aren't already.
+	 * We've restored and mapped the iter to match.
+	 */
+	if (iter != &rw->iter) {
+		iter = &rw->iter;
+		state = &rw->iter_state;
+	}
 
 	do {
-		io_size -= ret;
+		/*
+		 * We end up here because of a partial read, either from
+		 * above or inside this loop. Advance the iter by the bytes
+		 * that were consumed.
+		 */
+		iov_iter_advance(iter, ret);
+		if (!iov_iter_count(iter))
+			break;
 		rw->bytes_done += ret;
+		iov_iter_save_state(iter, state);
+
 		/* if we can retry, do so with the callbacks armed */
 		if (!io_rw_should_retry(req)) {
 			kiocb->ki_flags &= ~IOCB_WAITQ;
@@ -3520,7 +3554,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 			return 0;
 		/* we got some bytes, but not all. retry. */
 		kiocb->ki_flags &= ~IOCB_WAITQ;
-	} while (ret > 0 && ret < io_size);
+		iov_iter_restore(iter, state);
+	} while (ret > 0);
 done:
 	kiocb_done(kiocb, ret, issue_flags);
 out_free:
@@ -3543,19 +3578,24 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
-	ssize_t ret, ret2, io_size;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct iov_iter_state __state, *state;
+	ssize_t ret, ret2;
 
 	if (rw) {
 		iter = &rw->iter;
+		state = &rw->iter_state;
+		iov_iter_restore(iter, state);
 		iovec = NULL;
 	} else {
 		ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 		if (ret < 0)
 			return ret;
+		state = &__state;
+		iov_iter_save_state(iter, state);
 	}
-	io_size = iov_iter_count(iter);
-	req->result = io_size;
+	req->result = iov_iter_count(iter);
+	ret2 = 0;
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -3572,7 +3612,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), io_size);
+	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -3619,9 +3659,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb_done(kiocb, ret2, issue_flags);
 	} else {
 copy_iov:
-		/* some cases will consume bytes even on error returns */
-		iov_iter_reexpand(iter, iter->count + iter->truncated);
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
+		iov_iter_restore(iter, state);
+		if (ret2 > 0)
+			iov_iter_advance(iter, ret2);
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		return ret ?: -EAGAIN;
 	}
-- 
2.33.0

