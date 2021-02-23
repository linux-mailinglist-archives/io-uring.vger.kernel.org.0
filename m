Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933E73223F6
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhBWCBK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhBWCBH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:01:07 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C4CC06178C
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:52 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id h98so16185622wrh.11
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bsqn+4LV14kwuMRdrdvi78IdLT2vI0UBacpxnSzhKq0=;
        b=Bg6pgksu6qY+ANIrCi9+eNxgI+iz1cGpyzgkOX40ss5gwEcclcAf7GNGBdX6vpW9/T
         aE6e0/jo/INlIkFBZcDc58UFqKZSJDv3mIOKPCVjtxrVjLYVRU3VbjSu1CM/rVKM0b9I
         hkVLtbAXqc5Yq/TQtCwk48rB/v+uu/BA2dOZSqMFIDBzpU6v+Ll+FHDK/K21wZAGidf8
         YujaTvAkf8EuvZdb+1+iTgL2aZl8NExCKbSStxevfaem4sU0ZJGXZxgspXfCbf9//4Yq
         dHGK8s810f1Czl3xzA82dncbww2a39lF1+YRPHyZ9FfAW6wMvV74qfv447M+hLS2z3ye
         frgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bsqn+4LV14kwuMRdrdvi78IdLT2vI0UBacpxnSzhKq0=;
        b=sdgLCafrNukXdaXFQl4rDNFlxtexzKNA3simhRPUpwLgfkaNHIN8WNtGv1s2VNZ7R/
         tYLsPhwIYANUNpvTK15Zamg/CwZn7ObYtpYFvYtdvO0MEwi87Y/HcZD8f8g6v190vPjJ
         uv65dRriwFPBndsSbhPA/OMb0fmXgogcD/RypomOKEKNLAOr1pIOU4NsvMilFoy/oA9k
         KEom7LIzsfbICvkZbfp8G6Besk4FxmEHRaCWYEfsSwnR5LCXdjcPilzbycmAewffcB1O
         jNyAua4riFKXWNd0wf2aldo8A3DS4K0ovCDejWyCIaCpPcb6ebTNISTHczmGgXEfWFhP
         NSFQ==
X-Gm-Message-State: AOAM530eDMQXFy0GQd0J+cxW10WAIeNrFylbMhOAeIpqcKfdI+1lMKli
        GbSmoJLjBfZd2q6ScaIkHis=
X-Google-Smtp-Source: ABdhPJwY4Xu8CUa5ebakNB6ouzW+gPLHaPbrTJYDtY3kAs4SskMPUP9OKXpkvzFMs3eNweeKkUxyvg==
X-Received: by 2002:a05:6000:1111:: with SMTP id z17mr24811228wrw.404.1614045590926;
        Mon, 22 Feb 2021 17:59:50 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/13] io_uring: add a helper failing not issued requests
Date:   Tue, 23 Feb 2021 01:55:40 +0000
Message-Id: <6acbcf6cb74efa1b4cce17771b31d02f37c74a0f.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a simple helper doing CQE posting, marking request for link-failure,
and putting both submission and completion references.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0f85506448ac..692fe7399c94 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1592,8 +1592,8 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static inline void io_req_complete_post(struct io_kiocb *req, long res,
-					unsigned int cflags)
+static void io_req_complete_post(struct io_kiocb *req, long res,
+				 unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
@@ -1646,6 +1646,13 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
 	__io_req_complete(req, 0, res, 0);
 }
 
+static void io_req_complete_failed(struct io_kiocb *req, long res)
+{
+	req_set_fail_links(req);
+	io_put_req(req);
+	io_req_complete_post(req, res, 0);
+}
+
 static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
@@ -6258,9 +6265,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			io_put_req(req);
 		}
 	} else {
-		req_set_fail_links(req);
-		io_put_req(req);
-		io_req_complete(req, ret);
+		io_req_complete_failed(req, ret);
 	}
 	if (linked_timeout)
 		io_queue_linked_timeout(linked_timeout);
@@ -6274,9 +6279,7 @@ static void io_queue_sqe(struct io_kiocb *req)
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 fail_req:
-			req_set_fail_links(req);
-			io_put_req(req);
-			io_req_complete(req, ret);
+			io_req_complete_failed(req, ret);
 		}
 	} else if (req->flags & REQ_F_FORCE_ASYNC) {
 		ret = io_req_defer_prep(req);
@@ -6393,13 +6396,11 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
 fail_req:
-		io_put_req(req);
-		io_req_complete(req, ret);
+		io_req_complete_failed(req, ret);
 		if (link->head) {
 			/* fail even hard links since we don't submit */
 			link->head->flags |= REQ_F_FAIL_LINK;
-			io_put_req(link->head);
-			io_req_complete(link->head, -ECANCELED);
+			io_req_complete_failed(link->head, -ECANCELED);
 			link->head = NULL;
 		}
 		return ret;
@@ -8591,9 +8592,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	while (!list_empty(&list)) {
 		de = list_first_entry(&list, struct io_defer_entry, list);
 		list_del_init(&de->list);
-		req_set_fail_links(de->req);
-		io_put_req(de->req);
-		io_req_complete(de->req, -ECANCELED);
+		io_req_complete_failed(de->req, -ECANCELED);
 		kfree(de);
 	}
 }
-- 
2.24.0

