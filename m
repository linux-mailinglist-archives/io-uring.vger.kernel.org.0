Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733B74070E4
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 20:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhIJS0z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 14:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhIJS0z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 14:26:55 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CE7C061756
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 11:25:44 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id m11so3498389ioo.6
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 11:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pF069LFLYqZVT/magmUziYtfqHy/4m6/8hnl00DpDAY=;
        b=CmUfar/toYDNf6+XiE69fZFXYxQ801ESSSvckrOt+/eErD23/QIWAgb2vYHkN2ITqZ
         ++rBxpPKEMNgvebOKHumA2kBfTOuSiBe8vs8hd1bzf6lsVt2GWNaGCqXb7pG2iJ/Atib
         8JiGDFkZTAIenF8rKz6RgaGgq8zYJcYImTcvUjItTCg9GkPiwKwAgAfi9ZwtsbSi3ZG5
         5yMkvpLQMtuUO/H/5m0cUctu0tbgGyMLH0Rn98rE2owm1UXu2PgsAxDisN6ykX+z4Xbv
         EDJDUvKninScbenbmrIQ5Fi8EKwPV/IOFi22BxxSdtWqDZM98XRbvucEw0cZl7cMz556
         8VRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pF069LFLYqZVT/magmUziYtfqHy/4m6/8hnl00DpDAY=;
        b=k1iu07eK+3HXqDJIi0O5GTUTd+TXZoTaD9UTnCi1pkPFJRJoOU0O+qVSs2FpzDFXXZ
         isYqgZCKi/JHvmYxd9Ma4MVVcNZXW0v1RXqLZ28V7/zUkiD44thAJvEg6wI9k18WB0g+
         39J1S9Bt2XLaq685ai8Bv4sCPVm/+pGQNdPtUoQ0G7wgRoMU+JK0pXG/o/QhHzOaWwGG
         e9tOjiYMig45WIrOsio2aZIAQYPxNIKPyrPcgRpn+DRmdH/Je0xKfxvMGUfMJ7wHwdGe
         Kowf6D3+kLJ/qPMbC5lDs8aBkId/7JpL+IO2m5rgMUTVVbgehbySTsaW0P5GuFvvHFol
         F/nA==
X-Gm-Message-State: AOAM531epm5+pk8cIAH+CJRNjMp2RYYUxGH8FEHKOTqIV8otWIp5u618
        e33DZKSl1qGtI2wS628G43g2gbnpAZOqQwZR7uc=
X-Google-Smtp-Source: ABdhPJyaNgQzkFsKDP8HzGqlkNtbrvMKwA6//1EZVv8VAvQAEHkHLr3F8Iwx/30XzzEbJFRsajv5+w==
X-Received: by 2002:a5d:8b4b:: with SMTP id c11mr8181540iot.98.1631298343270;
        Fri, 10 Sep 2021 11:25:43 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c20sm2575149ili.42.2021.09.10.11.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 11:25:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: use iov_iter state save/restore helpers
Date:   Fri, 10 Sep 2021 12:25:35 -0600
Message-Id: <20210910182536.685100-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910182536.685100-1-axboe@kernel.dk>
References: <20210910182536.685100-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Get rid of the need to do re-expand and revert on an iterator when we
encounter a short IO, or failure that warrants a retry. Use the new
state save/restore helpers instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 855ea544807f..84e33f751372 100644
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
+	iov_iter_restore(&rw->iter, &rw->iter_state, 0);
 	return true;
 }
 
@@ -3437,19 +3437,22 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
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
 		iovec = NULL;
 	} else {
 		ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 		if (ret < 0)
 			return ret;
+		state = &__state;
 	}
-	io_size = iov_iter_count(iter);
-	req->result = io_size;
+	req->result = iov_iter_count(iter);
+	iov_iter_save_state(iter, state);
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -3463,7 +3466,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
+	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), state->count);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3479,18 +3482,17 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
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
+	} else if (ret <= 0 || ret == state->count || !force_nonblock ||
 		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
 		/* read all, failed, already did sync or don't want to retry */
 		goto done;
 	}
 
+	iov_iter_restore(iter, state, ret);
+
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 	if (ret2)
 		return ret2;
@@ -3501,7 +3503,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	iter = &rw->iter;
 
 	do {
-		io_size -= ret;
+		state->count -= ret;
 		rw->bytes_done += ret;
 		/* if we can retry, do so with the callbacks armed */
 		if (!io_rw_should_retry(req)) {
@@ -3520,7 +3522,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 			return 0;
 		/* we got some bytes, but not all. retry. */
 		kiocb->ki_flags &= ~IOCB_WAITQ;
-	} while (ret > 0 && ret < io_size);
+	} while (ret > 0 && ret < state->count);
 done:
 	kiocb_done(kiocb, ret, issue_flags);
 out_free:
@@ -3543,19 +3545,23 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
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
 		iovec = NULL;
 	} else {
 		ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 		if (ret < 0)
 			return ret;
+		state = &__state;
 	}
-	io_size = iov_iter_count(iter);
-	req->result = io_size;
+	req->result = iov_iter_count(iter);
+	iov_iter_save_state(iter, state);
+	ret2 = 0;
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -3572,7 +3578,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), io_size);
+	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), state->count);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -3619,9 +3625,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		kiocb_done(kiocb, ret2, issue_flags);
 	} else {
 copy_iov:
-		/* some cases will consume bytes even on error returns */
-		iov_iter_reexpand(iter, iter->count + iter->truncated);
-		iov_iter_revert(iter, io_size - iov_iter_count(iter));
+		iov_iter_restore(iter, state, ret2);
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		return ret ?: -EAGAIN;
 	}
-- 
2.33.0

