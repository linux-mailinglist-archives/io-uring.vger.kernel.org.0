Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD67332D9CC
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhCDS54 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbhCDS5t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:49 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3D0C0613D8
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:36 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id e10so28598402wro.12
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eR/P8/cLh2/uKoYBZSUzqvqnK66vm9pRg4vl/kl8AkE=;
        b=jawynTac4Ya2wH+QcQR86FROVYuFpuSBbASPoQMktr1KVuh6xt3cInuI0r3UL3kojW
         RR9vxEAFqGQPJI2dk07ECpqHWfDghT+0w3N/ekJifb+TSlZtXpvFH0eniKlglhzIrr8d
         2hgnpMoQRec4d5O7bASWnwgsFlsK62k6dGsrrvbRbkCey2sI1am8bBq0bakw4eonQqSs
         BYsldm3QJa8iVjvBDVm47zBdrE+SfHfWreocxx1iGdWWlcGGicPnS64oDedEgfOgC9vj
         8cz9jf5slKOS4/SacF2E6VxPmg4xzCK2Y9mUQ14U+l+1/HN4XkJ3BgclpYUHgTtIq0pY
         WdsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eR/P8/cLh2/uKoYBZSUzqvqnK66vm9pRg4vl/kl8AkE=;
        b=HvFGuGHOqDy86gPipJtrOLKXQQ59vhiOAIFPlx/DPFoqSGY4NoQcmS33VlvNwZztH9
         Ivz4Z/Mmy11zIXLmrCWs/c4F3j9b86sKTw0vOnJ4Os8P9b56Pol8WW70M74Q+VRrY+Rs
         dU0A2kIq3PDRrjW2Ojb2y0CUM0gUVPvCrrNNOc/wJw0xKhtfU3vo78lBiKWShHfsZMLS
         1CsVAD3uCPsBG0LhygSLYDPDdRb6jLNhgp87OZeMK+UHcSgE7RL/GZUvSJ7GnnXZnY/B
         HWwot1woyQ+beESu1xPEwfRV9gHYdPNqvZIl4w1LxOvdfmouiFJOJB4hQ4Unbf52L0vn
         HR3w==
X-Gm-Message-State: AOAM531EGMHT4rxaQqH74Hc9DSc5g8thAvzOk/h/yTGyAE7PkJCyBn7B
        3ao3Yf9jK9jCLQGg8IcUqO4=
X-Google-Smtp-Source: ABdhPJw5x0sA93R9yghHkHGUCejS8TtnB0In+HN3KgzHfE2pHvE6Xn/VVTuiH551973zxrP5IJIC+g==
X-Received: by 2002:adf:b355:: with SMTP id k21mr5610362wrd.156.1614884195623;
        Thu, 04 Mar 2021 10:56:35 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/11] io_uring: optimise success case of __io_queue_sqe
Date:   Thu,  4 Mar 2021 18:52:24 +0000
Message-Id: <1d97c5ad38cde257f5975dcbb530084d6bff23fb.1614883424.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the case of successfully issued request by doing that check first.
It's not much of a difference, just generates slightly better code for
me.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c05579ac7bb7..75395cc84c39 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6171,15 +6171,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
-	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
-		if (!io_arm_poll_handler(req)) {
-			/*
-			 * Queued up for async execution, worker will release
-			 * submit reference when the iocb is actually submitted.
-			 */
-			io_queue_async_work(req);
-		}
-	} else if (likely(!ret)) {
+	if (likely(!ret)) {
 		/* drop submission reference */
 		if (req->flags & REQ_F_COMPLETE_INLINE) {
 			struct io_ring_ctx *ctx = req->ctx;
@@ -6191,6 +6183,14 @@ static void __io_queue_sqe(struct io_kiocb *req)
 		} else {
 			io_put_req(req);
 		}
+	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
+		if (!io_arm_poll_handler(req)) {
+			/*
+			 * Queued up for async execution, worker will release
+			 * submit reference when the iocb is actually submitted.
+			 */
+			io_queue_async_work(req);
+		}
 	} else {
 		io_req_complete_failed(req, ret);
 	}
-- 
2.24.0

