Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1E3522C55
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 08:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242104AbiEKGbh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 02:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiEKGbe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 02:31:34 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BC93C496
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 23:31:32 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220511063131epoutp022f15d6ee11045b760f622e95d220107a~t_T-e0Kbc1692916929epoutp02t
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:31:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220511063131epoutp022f15d6ee11045b760f622e95d220107a~t_T-e0Kbc1692916929epoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652250691;
        bh=CVed3Z3YZc93hCbD8g1ECRDV0d2jrCr3Ug9GDANzeQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pG7Hzh1YfOEdc0uDQ4m8q1xl7iOoExkW8qaBW1fo/ySJLobbnL0uPSEFF99n/ZcU+
         k+l8v4dA0jckTEwAUbcMd98RtRisvbnPAjMR836Zx89Y546330SHQ+r6ZFNCQkcPZa
         D9M2tVaKmYSu0O/XDkVyqNS29JaUUUPabF4SXvgs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220511063130epcas5p126799c2e1b7efad56d97f0272adb24c5~t_T_2QGz90991709917epcas5p1s;
        Wed, 11 May 2022 06:31:30 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KylRc4Z8mz4x9QT; Wed, 11 May
        2022 06:31:24 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        26.76.09827.5385B726; Wed, 11 May 2022 15:31:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286~t9yhBOnmA2071120711epcas5p4E;
        Wed, 11 May 2022 05:53:10 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220511055310epsmtrp209c668ce4d1bbc85ab74c7ba57aac730~t9yhASJIT1209712097epsmtrp27;
        Wed, 11 May 2022 05:53:10 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-60-627b58352887
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        06.28.11276.64F4B726; Wed, 11 May 2022 14:53:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220511055308epsmtip1a11e87aa26ec24c7f149dfe63e68547b~t9yfSqZ9C2613826138epsmtip13;
        Wed, 11 May 2022 05:53:08 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v5 2/6] block: wire-up support for passthrough plugging
Date:   Wed, 11 May 2022 11:17:46 +0530
Message-Id: <20220511054750.20432-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511054750.20432-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCJsWRmVeSWpSXmKPExsWy7bCmlq5pRHWSwbJfBhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ0xY38NYsEi2Yvei
        X0wNjFMkuhg5OSQETCT+zepn7WLk4hAS2M0ocfrkVnYI5xOjxIGr79ggnG+MEtu+9bPAtHy8
        9RgqsZdRYnHnXSYI5zOjxKzeQ0D9HBxsApoSFyaXgjSICMhLfLm9lgWkhlngLKPEtFuHWEES
        wgLuEreuvWYDsVkEVCW2nL8PZvMKWEis3DyfHWKbvMTMS9/BbE4BS4ktm+exQ9QISpyc+QTs
        Imagmuats5lBFkgIzOWQmLGxhRWi2UXi6qvvULawxKvjW6CGSkl8freXDcJOlmjdfhnsaAmB
        EoklC9QhwvYSF/f8ZQIJMwP9sn6XPkRYVmLqqXVMEGv5JHp/P2GCiPNK7JgHYytK3Jv0FGqr
        uMTDGUtYIaZ7SJxqygYJCwn0MErsf2c6gVFhFpJnZiF5ZhbC4gWMzKsYJVMLinPTU4tNC4zy
        UsvhcZycn7uJEZx8tbx2MD588EHvECMTB+MhRgkOZiUR3v19FUlCvCmJlVWpRfnxRaU5qcWH
        GE2BoT2RWUo0OR+Y/vNK4g1NLA1MzMzMTCyNzQyVxHlPp29IFBJITyxJzU5NLUgtgulj4uCU
        amAqEp8tmJNxNaHSesqewNiql7OuSzkETlqz8kDNb12JdWsZzLbf/3VwRssJld6363WP907s
        /ifQHbDi6UqhpHzLv8fq5k7cnzgpyu7ty9aX1RWKlt1MN3afnrs2Jvu/wSVzicB766aZdtpP
        09+a+Kzy8F7HT+EOHY8uffMIt+bSfnKquX5ZDF+gaLOSzPO1HH5l3FwtRXtDOF78VNJ67/jg
        5oqI9Dttv8SW3hQ6uWbBMh6Vs92epg/Dax0NjthpNn6Of7c94+bqV/vdrDYs6wxZf/z+rM2F
        sl9ecZ9Z7D772BXH3GOCUWYtsUEL23d6HnHtUX3/MlLsiZ32dT3/tKUnjC5uPXmsxnryr4JH
        81MzlFiKMxINtZiLihMBwLxtJEcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnK6bf3WSwYH1chZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        ErgyJqzvYSxYJFuxe9EvpgbGKRJdjJwcEgImEh9vPWbrYuTiEBLYzSjx4tRndoiEuETztR9Q
        trDEyn/P2SGKPjJKLJ14hLGLkYODTUBT4sLkUpAaEQFFiY0fmxhBapgFbjJKPG69xgySEBZw
        l7h17TUbiM0ioCqx5fx9MJtXwEJi5eb5UAvkJWZe+g5mcwpYSmzZPA/MFgKqObpkIlS9oMTJ
        mU9YQGxmoPrmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4m
        RnCMaGnuYNy+6oPeIUYmDsZDjBIczEoivPv7KpKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817o
        OhkvJJCeWJKanZpakFoEk2Xi4JRqYCrY+mnV4Sk+8iemWyarbFgVfjbY8YZ7eKhqf0vLPo5T
        lV181nonHk58LHbE9PnEwPfLXqpsNtbNt85bsGJ1mz4DS2rWVMbr1qL9E06mMe9u2P8rZKnJ
        n1ViJptDG5eps6R+M2/s013O9/hscLvSDXvlc7lyi6Zv/KtWYflru5JsuafXdBP+iF36h36o
        7e5XMpf3TNzAMlXuctKpRTe+NLQc//44rGvpz8DbeSVb3kkXy1ps8rTQX+uYNYNXZ/m5dd5F
        M/hYVew2ciQuMCn7l7TsB2eK1CL3DeECQr8/Wx+7UrqtcXJn94ej007vvLpIXthbvlvB7HPB
        h5e8d+7+fyd6OyZRekHjW1Xm0nK3SCWW4oxEQy3mouJEABLTXrAAAwAA
X-CMS-MailID: 20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286
References: <20220511054750.20432-1-joshi.k@samsung.com>
        <CGME20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 73 +++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 34 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 84d749511f55..2cf011b57cf9 100644
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
@@ -2353,7 +2387,12 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
 				  bool run_queue)
 {
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
+	struct blk_plug *plug = current->plug;
 
+	if (plug) {
+		blk_add_rq_to_plug(plug, rq);
+		return;
+	}
 	spin_lock(&hctx->lock);
 	if (at_head)
 		list_add(&rq->queuelist, &hctx->dispatch);
@@ -2676,40 +2715,6 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
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

