Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D75C518C97
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 20:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbiECSxG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 14:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241660AbiECSw7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 14:52:59 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6853F8A3
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 11:49:19 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220503184915euoutp027c709dd86e6977fa98dacfd2b71888c0~rrN16XfU70971509715euoutp02P
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 18:49:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220503184915euoutp027c709dd86e6977fa98dacfd2b71888c0~rrN16XfU70971509715euoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651603755;
        bh=p+gpF8Lm8vZ6YiSFyLkddSyS0wjX/Rxnrmco6B460tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbTEOcKOIv4jZHSqHX+8bCEf6o9OtSAxV4zDgs+2AUdQY/NYWDeyRHWpraesaPZU/
         VZoEZ7oOCHk1PJN6ndPH1rydYxf2l6BT1QSO0slGBJ26BqHEdjLNjbtvpZ+VmVbqEL
         Jw0w16Xd9g60q8nPrO2mI43Hkg54qdtboXSNrhaA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220503184914eucas1p17c8186c40054540e407fbda0541d2f41~rrN0ybrNm1431714317eucas1p1P;
        Tue,  3 May 2022 18:49:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id CD.0B.09887.A2971726; Tue,  3
        May 2022 19:49:14 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220503184913eucas1p156abb6e2273c8dabc22e87ec8b218a5c~rrN0MyOII2788127881eucas1p1f;
        Tue,  3 May 2022 18:49:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220503184913eusmtrp1329bc145e0819958a2b782c5f939e3f8~rrN0GvZhD2552825528eusmtrp1X;
        Tue,  3 May 2022 18:49:13 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-3c-6271792a6e7e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id FA.F6.09404.92971726; Tue,  3
        May 2022 19:49:13 +0100 (BST)
Received: from localhost (unknown [106.210.248.170]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220503184913eusmtip2937a95bcb6e6c5fe3d62f528d847b313~rrNz3HzPt0186501865eusmtip2k;
        Tue,  3 May 2022 18:49:13 +0000 (GMT)
From:   Pankaj Raghav <p.raghav@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, gost.dev@samsung.com
Subject: [PATCH v3 2/5] block: wire-up support for passthrough plugging
Date:   Tue,  3 May 2022 20:48:28 +0200
Message-Id: <20220503184831.78705-3-p.raghav@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503184831.78705-1-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsWy7djPc7palYVJBnt6hS3mrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8X5t4eZLOYve8pucWPCU0aLQ5ObmSyuvjzA7sDlMbH5HbvHzll3
        2T0uny312LSqk81j85J6j903G9g83u+7yubRt2UVo8fnTXIBnFFcNimpOZllqUX6dglcGXfn
        97AXXFOoeH1xCksDY5N0FyMnh4SAicTLVQvZuhi5OIQEVjBKnHpzlBXC+cIoMatpDzOE85lR
        YnL7CqYuRg6wlobJ+hDx5YwSj5sPQnW8ZJS49vU2WBGbgJZEYyc7yAoRAXmJL7fXsoDUMAts
        Z5R4MvsLK0hCWMBd4t/Ea2A2i4CqxP+prUwgNq+ApcT3F/uYIO6Tl5h56Ts7yExOASuJHfOZ
        IUoEJU7OfMICYjMDlTRvnQ12qITACw6JI6/XskL0ukg0vF3EDGELS7w6voUdwpaROD25hwXC
        rpZ4euM3VHMLo0T/zvVsEF9aS/SdyQExmQU0Jdbv0ocod5R48+0bM0QFn8SNt4IQJ/BJTNo2
        HSrMK9HRJgRRrSSx8+cTqKUSEpeb5kAt9ZCYf6aXfQKj4iwkz8xC8swshL0LGJlXMYqnlhbn
        pqcWG+WllusVJ+YWl+al6yXn525iBCaq0/+Of9nBuPzVR71DjEwcjIcYJTiYlUR4nZcWJAnx
        piRWVqUW5ccXleakFh9ilOZgURLnTc7ckCgkkJ5YkpqdmlqQWgSTZeLglGpgap53hllGe6aL
        21I+k7yPMzjXLrGdz3Dhi+S0sPyCtxuOdgrYzrGazmY8K+CKtd28lVn1/ROSLcRUr5Y9WMLy
        fsmFwPLj+6XFBINrhL361xmlNkoWGaxeH7hK/c+i9gPCt6NuVOs8XW4/f96q7XXvXv/elqI7
        83Cu/YLuvrc7G5a09TXwbU38zmgZP//rtDuBCranropK5s/jkQpyv2sRF2gkfP76Khlvbya3
        M2lJy64mOr3cN+kM1/vUFW8+8M3QSXcKNzCRzM7eMd3n744pG3MeHP+3a21pxPqoPK7PKxf/
        CVuspNCzveeR7S/z2w3PeW9zmIXzb2Rws+5cKZbkrFbVzDbLyeyF4kJxtWcTlViKMxINtZiL
        ihMB4AHeL8MDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t/xe7qalYVJBl9mq1rMWbWN0WL13X42
        i5sHdjJZrFx9lMniXes5Fovzbw8zWcxf9pTd4saEp4wWhyY3M1lcfXmA3YHLY2LzO3aPnbPu
        sntcPlvqsWlVJ5vH5iX1HrtvNrB5vN93lc2jb8sqRo/Pm+QCOKP0bIryS0tSFTLyi0tslaIN
        LYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLLUov07RL0Mu7O72EvuKZQ8friFJYGxibpLkYO
        DgkBE4mGyfpdjFwcQgJLGSUebvrK1sXICRSXkLi9sIkRwhaW+HOtiw2i6DmjxJerh5hBmtkE
        tCQaO9lBakQEFCU2foSoZxY4yCjR28sMYgsLuEv8m3iNFcRmEVCV+D+1lQnE5hWwlPj+Yh8T
        xHx5iZmXvrODjOQUsJLYMR+sVQiopG3iYnaIckGJkzOfsECMl5do3jqbeQKjwCwkqVlIUgsY
        mVYxiqSWFuem5xYb6RUn5haX5qXrJefnbmIERtS2Yz+37GBc+eqj3iFGJg7GQ4wSHMxKIrzO
        SwuShHhTEiurUovy44tKc1KLDzGaAp09kVlKNDkfGNN5JfGGZgamhiZmlgamlmbGSuK8ngUd
        iUIC6YklqdmpqQWpRTB9TBycUg1MSc7fPWRWrfu2nvcO25PtUjfTLz1Rn7dF1dLg2Se9mb7i
        92ROaGyad/47u680u88fz00esipPzZ+daUufeTVXO2GSt8daLqvra94t3JEVZ8mclvKP98X/
        e6vdXhhsCJP6cGzGNLXSB6nmtxWSeI5sTLf78TlOv+C7murtgtjLUVU2Gi7pVTu89t9bFypX
        mvbwo3mK4+w/rvu52Xf8C3gu+D/kGwePpMx771nCbIo2qmLbe1bdcQlvKr6SErtRLiBzt6uB
        j1ZeZX47z4pdkasS30z10tppU9O1QcuC5aex8TS1hth1748+ntJpLXeb4975sw+mqK7gif/c
        IP9nmYgzV4787OPXWxYrzc96f85ciaU4I9FQi7moOBEAwD5RAzEDAAA=
X-CMS-MailID: 20220503184913eucas1p156abb6e2273c8dabc22e87ec8b218a5c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220503184913eucas1p156abb6e2273c8dabc22e87ec8b218a5c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220503184913eucas1p156abb6e2273c8dabc22e87ec8b218a5c
References: <20220503184831.78705-1-p.raghav@samsung.com>
        <CGME20220503184913eucas1p156abb6e2273c8dabc22e87ec8b218a5c@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

Add support for plugging in passthrough path. When plugging is enabled, the
requests are added to a plug instead of getting dispatched to the driver.
And when the plug is finished, the whole batch gets dispatched via
->queue_rqs which turns out to be more efficient. Otherwise dispatching
used to happen via ->queue_rq, one request at a time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c | 90 ++++++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 43 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 84d749511f55..e432e7e8fe20 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2340,6 +2340,40 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 	blk_mq_hctx_mark_pending(hctx, ctx);
 }
 
+/*
+ * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
+ * queues. This is important for md arrays to benefit from merging
+ * requests.
+ */
+static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
+{
+	if (plug->multiple_queues)
+		return BLK_MAX_REQUEST_COUNT * 2;
+	return BLK_MAX_REQUEST_COUNT;
+}
+
+static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
+{
+	struct request *last = rq_list_peek(&plug->mq_list);
+
+	if (!plug->rq_count) {
+		trace_block_plug(rq->q);
+	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
+		   (!blk_queue_nomerges(rq->q) &&
+		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
+		blk_mq_flush_plug_list(plug, false);
+		trace_block_plug(rq->q);
+	}
+
+	if (!plug->multiple_queues && last && last->q != rq->q)
+		plug->multiple_queues = true;
+	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
+		plug->has_elevator = true;
+	rq->rq_next = NULL;
+	rq_list_add(&plug->mq_list, rq);
+	plug->rq_count++;
+}
+
 /**
  * blk_mq_request_bypass_insert - Insert a request at dispatch list.
  * @rq: Pointer to request to be inserted.
@@ -2353,16 +2387,20 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
 				  bool run_queue)
 {
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
+	struct blk_plug *plug = current->plug;
 
-	spin_lock(&hctx->lock);
-	if (at_head)
-		list_add(&rq->queuelist, &hctx->dispatch);
-	else
-		list_add_tail(&rq->queuelist, &hctx->dispatch);
-	spin_unlock(&hctx->lock);
-
-	if (run_queue)
-		blk_mq_run_hw_queue(hctx, false);
+	if (plug) {
+		blk_add_rq_to_plug(plug, rq);
+	} else {
+		spin_lock(&hctx->lock);
+		if (at_head)
+			list_add(&rq->queuelist, &hctx->dispatch);
+		else
+			list_add_tail(&rq->queuelist, &hctx->dispatch);
+		spin_unlock(&hctx->lock);
+		if (run_queue)
+			blk_mq_run_hw_queue(hctx, false);
+	}
 }
 
 void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
@@ -2676,40 +2714,6 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 		hctx->queue->mq_ops->commit_rqs(hctx);
 }
 
-/*
- * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
- * queues. This is important for md arrays to benefit from merging
- * requests.
- */
-static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
-{
-	if (plug->multiple_queues)
-		return BLK_MAX_REQUEST_COUNT * 2;
-	return BLK_MAX_REQUEST_COUNT;
-}
-
-static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
-{
-	struct request *last = rq_list_peek(&plug->mq_list);
-
-	if (!plug->rq_count) {
-		trace_block_plug(rq->q);
-	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
-		   (!blk_queue_nomerges(rq->q) &&
-		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
-		blk_mq_flush_plug_list(plug, false);
-		trace_block_plug(rq->q);
-	}
-
-	if (!plug->multiple_queues && last && last->q != rq->q)
-		plug->multiple_queues = true;
-	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
-		plug->has_elevator = true;
-	rq->rq_next = NULL;
-	rq_list_add(&plug->mq_list, rq);
-	plug->rq_count++;
-}
-
 static bool blk_mq_attempt_bio_merge(struct request_queue *q,
 				     struct bio *bio, unsigned int nr_segs)
 {
-- 
2.25.1

