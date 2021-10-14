Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8922942DDBB
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 17:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhJNPOZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 11:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbhJNPOT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 11:14:19 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F6AC06177B
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:12 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r18so20583913wrg.6
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 08:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mFzc17tIcswgXZ4Blm5ofL2ptULB1B9HYpJKROwHOUc=;
        b=TqVloACDsOcOeMtzkHJAPEiv3T3us5OZY5IxkrfLSqU4eNwTz5pkh7/YbfSgMaAtXk
         lBBCmGRv3qal/lXlpHLNxTOtTHG8ZTCvrLNnNXS2JmhqBYphlfBpJkcyQFEKXqKv0Fin
         XwSPx4UK5zYVh+4baVdTdEyeRZrkSdcabtQimxUX9S0nyNVIqm1+AQxB9zzvSVVxXXf/
         nbiw7HEGduxvJ28NLyLVee1M2wnVZGeUnaLcDQcWVFJETtFuEpbTuNjCL3EdsELiN76a
         iTk6TTfddGU17E63NNcxLBH7LMX/OLezlpHYNwx7GfHa5SkBxzyv/V9ZuM0/7jJu1dLv
         ZkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mFzc17tIcswgXZ4Blm5ofL2ptULB1B9HYpJKROwHOUc=;
        b=T2N8oVxBgGHdCqWAvKNFo/fYWVVXkUbBbBcEVxre2GSR54/ZuWp4vUe0W62gCZcoZP
         HfhxUy3nB7z3JGADfYV5yXS+c2zWKbizrx3YzO2DPJ3tjVLql+EGMXMeP+IEC+Z3c6Gx
         8QVv6jPludMjW7H6/M1abdSK/VsVFe/vxcVqLYNW9PpLXux/4xSv7DGSA/yBNFusMbJO
         ow+FMzS0DLBKboSuhU/kPfAOkiVFgcvU3L6J0vOEwISnMZaygfc7rMeyU2Av5W84IIK+
         uwOL3CmanrclH/h9KvRR7rgZpp5J8LHd0Pw0Ug3mRFxdfy5EMnivOYXWihzO1AcPZMTj
         VbMQ==
X-Gm-Message-State: AOAM533s5MTYYOhsFdYoMdAcmSW2QPOW6zx84KTT/+66ka7k4mG5r1L8
        05MObIvG4FiwNJJwA2gXbKghrxazWP0=
X-Google-Smtp-Source: ABdhPJztxPBmlAJ95dcRiyH6t6IshbKRZpnicFT4t3I+lsFazjGuIR9yarBK2qG0qNXpBSqi/iyZDw==
X-Received: by 2002:a05:600c:3546:: with SMTP id i6mr20338953wmq.146.1634224271315;
        Thu, 14 Oct 2021 08:11:11 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id c14sm2549557wrd.50.2021.10.14.08.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:11:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/8] io_uring: encapsulate rw state
Date:   Thu, 14 Oct 2021 16:10:15 +0100
Message-Id: <e8245ffcb568b228a009ec1eb79c993c813679f1.1634144845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634144845.git.asml.silence@gmail.com>
References: <cover.1634144845.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new struct io_rw_state storing all iov related bits: fast iov,
iterator and iterator state. Not much changes here, simply convert
struct io_async_rw to use it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2f193893cf1b..3447243805d9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -693,11 +693,15 @@ struct io_async_msghdr {
 	struct sockaddr_storage		addr;
 };
 
-struct io_async_rw {
+struct io_rw_state {
 	struct iovec			fast_iov[UIO_FASTIOV];
-	const struct iovec		*free_iovec;
 	struct iov_iter			iter;
 	struct iov_iter_state		iter_state;
+};
+
+struct io_async_rw {
+	struct io_rw_state		s;
+	const struct iovec		*free_iovec;
 	size_t				bytes_done;
 	struct wait_page_queue		wpq;
 };
@@ -2550,7 +2554,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 
 	if (!req_has_async_data(req))
 		return !io_req_prep_async(req);
-	iov_iter_restore(&rw->iter, &rw->iter_state);
+	iov_iter_restore(&rw->s.iter, &rw->s.iter_state);
 	return true;
 }
 
@@ -3221,7 +3225,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 {
 	struct io_async_rw *rw = req->async_data;
 
-	memcpy(&rw->iter, iter, sizeof(*iter));
+	memcpy(&rw->s.iter, iter, sizeof(*iter));
 	rw->free_iovec = iovec;
 	rw->bytes_done = 0;
 	/* can only be fixed buffers, no need to do anything */
@@ -3230,13 +3234,13 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	if (!iovec) {
 		unsigned iov_off = 0;
 
-		rw->iter.iov = rw->fast_iov;
+		rw->s.iter.iov = rw->s.fast_iov;
 		if (iter->iov != fast_iov) {
 			iov_off = iter->iov - fast_iov;
-			rw->iter.iov += iov_off;
+			rw->s.iter.iov += iov_off;
 		}
-		if (rw->fast_iov != fast_iov)
-			memcpy(rw->fast_iov + iov_off, fast_iov + iov_off,
+		if (rw->s.fast_iov != fast_iov)
+			memcpy(rw->s.fast_iov + iov_off, fast_iov + iov_off,
 			       sizeof(struct iovec) * iter->nr_segs);
 	} else {
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -3271,7 +3275,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 		io_req_map_rw(req, iovec, fast_iov, iter);
 		iorw = req->async_data;
 		/* we've copied and mapped the iter, ensure state is saved */
-		iov_iter_save_state(&iorw->iter, &iorw->iter_state);
+		iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
 	}
 	return 0;
 }
@@ -3279,10 +3283,10 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 {
 	struct io_async_rw *iorw = req->async_data;
-	struct iovec *iov = iorw->fast_iov;
+	struct iovec *iov = iorw->s.fast_iov;
 	int ret;
 
-	ret = io_import_iovec(rw, req, &iov, &iorw->iter, false);
+	ret = io_import_iovec(rw, req, &iov, &iorw->s.iter, false);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -3290,7 +3294,7 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	iorw->free_iovec = iov;
 	if (iov)
 		req->flags |= REQ_F_NEED_CLEANUP;
-	iov_iter_save_state(&iorw->iter, &iorw->iter_state);
+	iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
 	return 0;
 }
 
@@ -3400,8 +3404,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req_has_async_data(req)) {
 		rw = req->async_data;
-		iter = &rw->iter;
-		state = &rw->iter_state;
+		iter = &rw->s.iter;
+		state = &rw->s.iter_state;
 		/*
 		 * We come here from an earlier attempt, restore our state to
 		 * match in case it doesn't. It's cheap enough that we don't
@@ -3472,9 +3476,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * Now use our persistent iterator and state, if we aren't already.
 	 * We've restored and mapped the iter to match.
 	 */
-	if (iter != &rw->iter) {
-		iter = &rw->iter;
-		state = &rw->iter_state;
+	if (iter != &rw->s.iter) {
+		iter = &rw->s.iter;
+		state = &rw->s.iter_state;
 	}
 
 	do {
@@ -3536,8 +3540,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req_has_async_data(req)) {
 		rw = req->async_data;
-		iter = &rw->iter;
-		state = &rw->iter_state;
+		iter = &rw->s.iter;
+		state = &rw->s.iter_state;
 		iov_iter_restore(iter, state);
 		iovec = NULL;
 	} else {
-- 
2.33.0

