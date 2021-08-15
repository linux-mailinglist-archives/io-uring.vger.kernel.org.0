Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8433EC864
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhHOJlj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbhHOJlj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:41:39 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30ADC061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:09 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x10so13021299wrt.8
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=di2NnCkCpD2pRjUau4zuVw52jFtb0yMGZl5JQLmsRfQ=;
        b=W1VSzXvFt8/2zkB9Y0jh3Y+TN65WK9TGKFu98j0R4rhLCcbAQV6fLx+Sgzaf8lKj4D
         SoIkVpSj+evm5DA0zbKxgvIR6ATnj1sQsnOCPLvYmUNr7MfABvkqD90GvlXsrT+uGARp
         4xhM5ZjWGz2lQ3SpOqM3QVLrrCB9SVkZSA3bz4sRbf3aPk62Moqb/VBDCNhma7X9+0kw
         x/h/TE2nJSO6aRuxrk3ngmCnD2TKBXrT5bARng/BavJDcD9/kiZj32nWvH2OqaanCtqI
         V55F7fPWe77qPyj7c8Pln00MRfiyVu/p8GZMMrZBq9OcFxDDQjf7QL0yrUZC9a1GN9Py
         fT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=di2NnCkCpD2pRjUau4zuVw52jFtb0yMGZl5JQLmsRfQ=;
        b=YFkMdDp6KI3ZCBvXH4x0Vq1fRbdPLgHCGrvn5BVoJNqzVTkyTMYpgZFh3Tv/uPbJ29
         zUG6U6yydPVJoT0oQTXJM2ZR0eS+oeGVJVIwYHYDVaiV0zWpvsI5HHIN5xqMm8EEXtub
         lbgc06U8QpjtfmOC3vBX/7m09BBGxRAlR8PV8JiH+uZUAH3n19lPPK9op/Bl9/2xC7VO
         hnGUToD9xePHe6xkwPBaeAU1l+CQp0vOooxoSuRCqFHKxJyvAw3LEOlG57uo4r2V7LAS
         GIb4vsb+WbxcHlNVMRHC+OLn1ADMBeUGtJB9GEOpsQkQUNzf+QUNQbMpPix1JbmQPZ8Z
         VLUQ==
X-Gm-Message-State: AOAM533cZTE+lYpkU31GnEwfzYnYav9bkZrrE5e0qN1IIbv/sayo8tnw
        mtfny12ax46bppwB0kigr5ZMXXDGf6w=
X-Google-Smtp-Source: ABdhPJy13lRnwFw1/O1XQ/k/ZMPEIFtmSJFv32545iY5Ma9iBDg+IeGbBpDfbwIHpFPYa+A/gcvv0g==
X-Received: by 2002:a05:6000:10c5:: with SMTP id b5mr12618038wrx.298.1629020468410;
        Sun, 15 Aug 2021 02:41:08 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t8sm8828815wrx.27.2021.08.15.02.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:41:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 6/9] io_uring: kill REQ_F_LTIMEOUT_ACTIVE
Date:   Sun, 15 Aug 2021 10:40:23 +0100
Message-Id: <04150760b0dc739522264b8abd309409f7421a06.1628981736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628981736.git.asml.silence@gmail.com>
References: <cover.1628981736.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of handling double consecutive linked timeouts through tricky
flag combinations, just check the submit_state.link during timeout_prep
and fail that case in advance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a0d081dca389..ece69b1217c8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -705,7 +705,6 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
-	REQ_F_LTIMEOUT_ACTIVE_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
 	REQ_F_DONT_REISSUE_BIT,
@@ -750,8 +749,6 @@ enum {
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
-	/* linked timeout is active, i.e. prepared by link's head */
-	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
 	/* completion is deferred through io_comp_state */
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
 	/* caller should reissue async */
@@ -1313,7 +1310,6 @@ static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 	__io_req_set_refcount(nxt, 2);
 
 	nxt->timeout.head = req;
-	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
 	req->flags |= REQ_F_LINK_TIMEOUT;
 	return nxt;
 }
@@ -1893,11 +1889,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 {
 	struct io_kiocb *link = req->link;
 
-	/*
-	 * Can happen if a linked timeout fired and link had been like
-	 * req -> link t-out -> link t-out [-> ...]
-	 */
-	if (link && (link->flags & REQ_F_LTIMEOUT_ACTIVE)) {
+	if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 		struct io_timeout_data *io = link->async_data;
 
 		io_remove_next_linked(req);
@@ -5698,6 +5690,15 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
+
+	if (is_timeout_link) {
+		struct io_submit_link *link = &req->ctx->submit_state.link;
+
+		if (!link->head)
+			return -EINVAL;
+		if (link->last->opcode == IORING_OP_LINK_TIMEOUT)
+			return -EINVAL;
+	}
 	return 0;
 }
 
-- 
2.32.0

