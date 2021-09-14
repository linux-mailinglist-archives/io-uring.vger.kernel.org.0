Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3565040B066
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhINOTj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbhINOTO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:19:14 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907DFC061767
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:17:57 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id x2so6070505ila.11
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAR123urz57PkLjJI7L4tM4W+19Um5s2CkATxO6nEmU=;
        b=QruGRAFr2oSjMVUb8MXBl/rC/bZuD8zYtP9CP0OiIQnUUmkXC798A37UKEx98F1NJz
         jNmLX133VNu3Cr/aYV/vNiwKWg0gdau6ttA+r9Iu/UIfSHEcwCTKP7zNpnpvxWY7Jsxu
         ptPPXVKIyA7i+JDT6tPY7SbRDRJHphvVzHibMQIw2wNusXkSbZkfSTpgyce8N1E8rUHp
         9MqAPdk1QdrdH90WX/343EHbbYGME4PaSqoLmKmiJWTrBM6YgkjECdOSOiJmRk5MNc5C
         yOJUVxBugYKudVLdujvkw4JmL0TDKQs0Dx4xSBBOmLXCvPpZ5FgQJ04JoM8jV2KgiZKp
         54eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAR123urz57PkLjJI7L4tM4W+19Um5s2CkATxO6nEmU=;
        b=mBgL1rO4XlcPEgj07Wwi+qyWA5qRkXaom/gzY411xNqpA9xsauOWlk8xehHXoZRq5J
         HfbjrCM7hwhu41QDkubRtfvlfqU3XdEchUuesKTFKOzY7jsrix3tj2qtNzwSwgXQ+iiW
         TM7iIeJk6S7sXJyVtv2X+v3z2TNdWT0mPP/IGfybyFpxr20IihAfpS6cj8k83pXBn+D0
         f7zj5xo0Xu8obAg99v3PWVVDpymNXvW5cmVnigHcxtY9n2yhVQGs1OU5DxStpbpW0QTQ
         1kTgwx3S29sppATF9P1LZL4wuwA0eOSus06bDOuwUupTZLvMgWtCySB2uKWZE2APey46
         gjCQ==
X-Gm-Message-State: AOAM532He1SA46oaRO4Zl61+F/F+KC6im4OxuyQ1iWqU9dTyUsZqfoCX
        cfkuZmM0vexioFACM2qMfmYjGhWExDwRPEvSnWU=
X-Google-Smtp-Source: ABdhPJwMDKrzQZuKJQDWhrq87YkZzAIVO9KJIAF0XeD/7eYRoldBbxYwIO4Yt3kH6+E8svRjC7TIMg==
X-Received: by 2002:a05:6e02:2184:: with SMTP id j4mr12507827ila.30.1631629076816;
        Tue, 14 Sep 2021 07:17:56 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p135sm6673803iod.26.2021.09.14.07.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 07:17:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: use iov_iter state save/restore helpers
Date:   Tue, 14 Sep 2021 08:17:49 -0600
Message-Id: <20210914141750.261568-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914141750.261568-1-axboe@kernel.dk>
References: <20210914141750.261568-1-axboe@kernel.dk>
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
 fs/io_uring.c | 62 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 855ea544807f..dbc97d440801 100644
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
 
@@ -3310,12 +3310,16 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
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
+		iov_iter_save_state(&iorw->iter, &iorw->iter_state);
 	}
 	return 0;
 }
@@ -3334,6 +3338,7 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	iorw->free_iovec = iov;
 	if (iov)
 		req->flags |= REQ_F_NEED_CLEANUP;
+	iov_iter_save_state(&iorw->iter, &iorw->iter_state);
 	return 0;
 }
 
@@ -3437,19 +3442,23 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -3463,7 +3472,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
+	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3479,30 +3488,36 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
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
 
+	iov_iter_restore(iter, state);
+
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 	if (ret2)
 		return ret2;
 
 	iovec = NULL;
 	rw = req->async_data;
-	/* now use our persistent iterator, if we aren't already */
-	iter = &rw->iter;
+	/* now use our persistent iterator and state, if we aren't already */
+	if (iter != &rw->iter) {
+		iter = &rw->iter;
+		state = &rw->iter_state;
+	}
 
 	do {
-		io_size -= ret;
 		rw->bytes_done += ret;
+		iov_iter_advance(iter, ret);
+		if (!iov_iter_count(iter))
+			break;
+		iov_iter_save_state(iter, state);
+
 		/* if we can retry, do so with the callbacks armed */
 		if (!io_rw_should_retry(req)) {
 			kiocb->ki_flags &= ~IOCB_WAITQ;
@@ -3520,7 +3535,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 			return 0;
 		/* we got some bytes, but not all. retry. */
 		kiocb->ki_flags &= ~IOCB_WAITQ;
-	} while (ret > 0 && ret < io_size);
+	} while (ret > 0);
 done:
 	kiocb_done(kiocb, ret, issue_flags);
 out_free:
@@ -3543,19 +3558,24 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -3572,7 +3592,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), io_size);
+	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -3619,9 +3639,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
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

