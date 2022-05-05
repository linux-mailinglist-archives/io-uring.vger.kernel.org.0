Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE58151B7D0
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 08:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240558AbiEEGRv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 02:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiEEGRu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 02:17:50 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5689D46651
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 23:14:10 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220505061408epoutp036f5ff62d0742f4ba140b74baf7d04f5b~sINGmLD4l0353303533epoutp03C
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:14:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220505061408epoutp036f5ff62d0742f4ba140b74baf7d04f5b~sINGmLD4l0353303533epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651731248;
        bh=CVed3Z3YZc93hCbD8g1ECRDV0d2jrCr3Ug9GDANzeQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBS+oKzfdeb+Q9Hx64k+M8P/ky6EEFzuCBIhMTunTc8TF8cORNFJiT3YjyiFA1yX4
         ZTQMrGTO5zdH2wIjSI1dC+mol1QIXTwlhqLcoMTa25V/AV6XOopTkRsH76vdoyo0FI
         NXldyO0MH4xMpAcTcYSk6ToKIwgQGF1EBNzQJuW4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220505061407epcas5p3f6421f716036b0a3ef03be1d33ff8344~sINF66aCV1851218512epcas5p3L;
        Thu,  5 May 2022 06:14:07 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Kv3LL5V2lz4x9Q1; Thu,  5 May
        2022 06:14:02 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.B7.09762.A2B63726; Thu,  5 May 2022 15:14:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220505061146epcas5p3919c48d58d353a62a5858ee10ad162a0~sILCl8gSm0533505335epcas5p3V;
        Thu,  5 May 2022 06:11:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220505061146epsmtrp16fc8f6e4f583f50b666af5c11100806d~sILCkDceK1114811148epsmtrp13;
        Thu,  5 May 2022 06:11:46 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-1a-62736b2a90af
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.1A.08853.2AA63726; Thu,  5 May 2022 15:11:46 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220505061144epsmtip297d8cf29f4ae2bfda0913592e76a906f~sILA8EyFn0269602696epsmtip2W;
        Thu,  5 May 2022 06:11:44 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v4 2/5] block: wire-up support for passthrough plugging
Date:   Thu,  5 May 2022 11:36:13 +0530
Message-Id: <20220505060616.803816-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505060616.803816-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmlq5WdnGSQf95bYumCX+ZLeas2sZo
        sfpuP5vFzQM7mSxWrj7KZPGu9RyLxfm3h5ks5i97ym5xY8JTRotDk5uZLK6+PMDuwO0xsfkd
        u8fOWXfZPS6fLfXYtKqTzWPzknqP3Tcb2Dze77vK5tG3ZRWjx+dNcgGcUdk2GamJKalFCql5
        yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDHKimUJeaUAoUCEouLlfTt
        bIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyMyas72EsWCRbsXvR
        L6YGxikSXYycHBICJhIzextZQWwhgd2MEhuecHYxcgHZnxglVj/cwwzhfGOUOP7/JxNMx7UT
        y9ghEnsZJSb9uARV9ZlR4vT0pYxdjBwcbAKaEhcml4I0iAjIS3y5vZYFpIZZ4CyjxLRbh1hB
        aoQF3CUmfvMCqWERUJVobp3CDmLzClhK3Dl7EGqZvMTMS9/B4pwCVhIdR3tZIGoEJU7OfAJm
        MwPVNG+dDXaDhMBCDomeyV1sEM0uEi/ffmKFsIUlXh3fwg5hS0m87G+DspMlWrdfZge5R0Kg
        RGLJAnWIsL3ExT1/mUDCzECvrN+lDxGWlZh6ah0TxFo+id7fT6DO5JXYMQ/GVpS4N+kp1FZx
        iYczlrBCTPeQeH4HGmy9jBJP25tZJjAqzELyzSwk38xC2LyAkXkVo2RqQXFuemqxaYFxXmo5
        PIqT83M3MYJTr5b3DsZHDz7oHWJk4mA8xCjBwawkwuu8tCBJiDclsbIqtSg/vqg0J7X4EKMp
        MLgnMkuJJucDk39eSbyhiaWBiZmZmYmlsZmhkjjvqfQNiUIC6YklqdmpqQWpRTB9TBycUg1M
        vjOkQu2cJ6yTPnL/e+q/ZdkytibCwkfZFZfbXXa8/L3z55kTK06uK2iqmTsvLLRJnGX/sy+L
        Nm0WckyfLHZa/uTvq+3cHIXaL3Z1NzO/dbVhN61JuCPns+WfQPXeP7MeXOzm2Bsi1t+4jXui
        U/Oy9Ff/TQQtZtS4zWmfcI3Zg6md/4OTZqm6nvWWMuW02anxu2T+yqszrFazsRA/Z5seMUNd
        jy3w+sz6gAeJLQ+dFHWF1WrKk85PPv363eS3TGKRm295GlisKFlvf4Lhpr5vZ3dblKHUMz9n
        i841NztSNZP4Djy9K7Qi/uV77k+XfD4v/lh8lKk6s9Bn4s+1/xV3TJp91euux8mek+udv15U
        YinOSDTUYi4qTgQAyvZ7h0YEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvO6irOIkg0krBC2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymL/sKbvFjQlPGS0OTW5msrj68gC7A7fHxOZ3
        7B47Z91l97h8ttRj06pONo/NS+o9dt9sYPN4v+8qm0ffllWMHp83yQVwRnHZpKTmZJalFunb
        JXBlTFjfw1iwSLZi96JfTA2MUyS6GDk5JARMJK6dWMYOYgsJ7GaUeHJfByIuLtF87Qc7hC0s
        sfLfcyCbC6jmI6PEuuc72LoYOTjYBDQlLkwuBakREVCU2PixiRGkhlngJqPE49ZrzCA1wgLu
        EhO/eYHUsAioSjS3TgGbyStgKXHn7EEmiPnyEjMvfQeLcwpYSXQc7WWBuMdS4n73ahaIekGJ
        kzOfgNnMQPXNW2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxN
        jOD40NLcwbh91Qe9Q4xMHIyHGCU4mJVEeJ2XFiQJ8aYkVlalFuXHF5XmpBYfYpTmYFES573Q
        dTJeSCA9sSQ1OzW1ILUIJsvEwSnVwLR1XgUbt65Y6y7nC8FcByXlu+X+BpxsFTM5P33XJL5i
        q7jdx+eJJK0wP8flua1kBnfh411Bfnp3Ypz2Op+/MiMqcXqK985Mm8xz/7YWX1O/NK1jJt+K
        5lOv1te+2ssx96zvhaZJHhzdzH8tFtmvWh92bK33jtOpZS/jy79YhjZdjXicKPRjtszKefkV
        26b03ObiXrpMbc8CmUybNt9L3/qjlr5YWbTHePFWFVHrA1u/BBktNWktNCmSrjiiWsy/vvPX
        kSlLpM/fflnct5Eh5uAB2Wtxp9f/2Kj2R+Lg10l9iWweeRzTVBu4X622PM4ioi8ffkG/LXbF
        0SVK4na3X0i6/j/33uJszs1j6VufX9FVYinOSDTUYi4qTgQAQEi5A/4CAAA=
X-CMS-MailID: 20220505061146epcas5p3919c48d58d353a62a5858ee10ad162a0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505061146epcas5p3919c48d58d353a62a5858ee10ad162a0
References: <20220505060616.803816-1-joshi.k@samsung.com>
        <CGME20220505061146epcas5p3919c48d58d353a62a5858ee10ad162a0@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

