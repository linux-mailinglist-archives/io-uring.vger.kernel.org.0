Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF874FE377
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350155AbiDLONE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355985AbiDLOM7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:12:59 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A291CFF1
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:41 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id g18so11644734wrb.10
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QfQIbyxxwaEFVTkT1Lw8AKEIVS14XCmCgjCCQRPnQGI=;
        b=GpaOvcs/bviANxds0g8cGU37KhLVxuTjKENqoPC4Vai7umbanW8uIyEKFksW+v4zT1
         3tBU1pyaY7j6wq22Ye97b/Kc3esyJLESUKbvhk0FxG33q6QroaYV/WrzuOfl5qj+hV+8
         GRQzmPCd5szPVQJ2xZpwMjWjtWThPWBP42OcSOVOb9idvJ6rlBxOcN4fYpiuxxn1CXqk
         6rkCwPGOmyzWexBS96X7MZBtQFSkseOSk7DpyTOFEgj6lX2Ypt+DvacGReVZsZGX5D6n
         XKwHtbrHhKupdMvGBZa1GZiYQgcAftusZQbZztYC9avnF9IEIdeX9cUOHyX2HeYnrCJ+
         NXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QfQIbyxxwaEFVTkT1Lw8AKEIVS14XCmCgjCCQRPnQGI=;
        b=TL0CwD1/I/l411gQ23AYh+eQO79F0srChzQ3A6hDdgyhgVWlr02bEWZRDYPoQD2W2b
         KEarMZnYpXcU+dJthasEE1x1WaCxt6s56CI/ijy9L4NpQ00+AHTBt9U8zq+gWGyMn6Eh
         a1gDnTM5XV5GCLAS0qJfhPf7EaTA41ccnvy/4PBXg4pAVnnLZfOBYX+p+JHgOxo6rUGQ
         dKFQZarTH4h3hrd3bWqmswcgh4bYlMOXBPfKP0i05GMHCW0J16r/0PMsgssgFmxL439a
         nfO11nUFDufTB/Q9JKuX+j/ZG76cuHOiOG76YnHFMO5bUpvEHltkizaBmQkOtqezIiN4
         IL3w==
X-Gm-Message-State: AOAM533leP8Llp8spIJn7UVF+2j6pnpEDnYqqA6tSzcnm1Zxzs+86GK9
        nPch3tpWizyP1SE8bGwuH0lfs1rtj6k=
X-Google-Smtp-Source: ABdhPJwhdepva7a3EjTSFVxoBasPPub6W+fzgF7hRpMvJIiCd+mS2czsSXG9sL39OwhbBviIFd2HAQ==
X-Received: by 2002:a5d:6da8:0:b0:207:b134:2011 with SMTP id u8-20020a5d6da8000000b00207b1342011mr1699147wrs.241.1649772639813;
        Tue, 12 Apr 2022 07:10:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm2363703wmb.47.2022.04.12.07.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:10:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 7/9] io_uring: optimise submission loop invariant
Date:   Tue, 12 Apr 2022 15:09:49 +0100
Message-Id: <c3b3df9aeae4c2f7a53fd8386385742e4e261e77.1649771823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of keeping @submitted in io_submit_sqes(), which for each
iteration requires comparison with the initial number of SQEs, store the
number of SQEs left to submit. We'll need nr only for when we're done
with SQE handling.

note: if we can't allocate a req for the first SQE we always has been
returning -EAGAIN to the userspace, save this behaviour by looking into
the cache in a slow path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a751ca167d21..20eb73d9ae42 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7836,24 +7836,22 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries = io_sqring_entries(ctx);
-	int submitted = 0;
+	unsigned int left;
+	int ret;
 
 	if (unlikely(!entries))
 		return 0;
 	/* make sure SQ entry isn't read before tail */
-	nr = min3(nr, ctx->sq_entries, entries);
-	io_get_task_refs(nr);
+	ret = left = min3(nr, ctx->sq_entries, entries);
+	io_get_task_refs(left);
+	io_submit_state_start(&ctx->submit_state, left);
 
-	io_submit_state_start(&ctx->submit_state, nr);
 	do {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 
-		if (unlikely(!io_alloc_req_refill(ctx))) {
-			if (!submitted)
-				submitted = -EAGAIN;
+		if (unlikely(!io_alloc_req_refill(ctx)))
 			break;
-		}
 		req = io_alloc_req(ctx);
 		sqe = io_get_sqe(ctx);
 		if (unlikely(!sqe)) {
@@ -7861,7 +7859,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 			break;
 		}
 		/* will complete beyond this point, count as submitted */
-		submitted++;
+		left--;
 		if (io_submit_sqe(ctx, req, sqe)) {
 			/*
 			 * Continue submitting even for sqe failure if the
@@ -7870,20 +7868,20 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 			if (!(ctx->flags & IORING_SETUP_SUBMIT_ALL))
 				break;
 		}
-	} while (submitted < nr);
+	} while (left);
 
-	if (unlikely(submitted != nr)) {
-		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
-		int unused = nr - ref_used;
-
-		current->io_uring->cached_refs += unused;
+	if (unlikely(left)) {
+		ret -= left;
+		/* try again if it submitted nothing and can't allocate a req */
+		if (!ret && io_req_cache_empty(ctx))
+			ret = -EAGAIN;
+		current->io_uring->cached_refs += left;
 	}
 
 	io_submit_state_end(ctx);
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
-
-	return submitted;
+	return ret;
 }
 
 static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
-- 
2.35.1

