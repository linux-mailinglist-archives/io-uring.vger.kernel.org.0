Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB594D1C12
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343586AbiCHPnt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347917AbiCHPns (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:48 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EAB275F4
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:51 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220308154249epoutp038b75704d59a770fd4771896eb8f6e096~acjE9lRrd2451824518epoutp03E
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220308154249epoutp038b75704d59a770fd4771896eb8f6e096~acjE9lRrd2451824518epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754169;
        bh=2rlThWeyJ9VUC3jt2jsrqQfe5sVmTxRqTj81niQsLZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omUTmwGREf0oE6FWsAaQV8uHDVsrCHQi+N6CYMxuWlqDYP2sxynxNOw24ZqWaKLoO
         ATlt3MDFcPDldnth+dwgPFcA0i9QyjT5NFCl06BSUCL/RkOV4lr2JP81w3l0gazP79
         emp8/cbtpa1kLXfrRadn4lteT9qRcrFVGlOb0bKk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220308154248epcas5p1ea3697922cad7004de83762173b2b0b0~acjEUFawJ2331223312epcas5p1_;
        Tue,  8 Mar 2022 15:42:48 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KCfjH5RXGz4x9Pq; Tue,  8 Mar
        2022 15:42:43 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.AB.05590.37977226; Wed,  9 Mar 2022 00:42:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220308152714epcas5p4c5a0d16512fd7054c9a713ee28ede492~acVdtyQMf1840518405epcas5p4T;
        Tue,  8 Mar 2022 15:27:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220308152714epsmtrp138c5015c6abd95afe5165a8e81305e9b~acVdtABXk0125001250epsmtrp1Z;
        Tue,  8 Mar 2022 15:27:14 +0000 (GMT)
X-AuditID: b6c32a4b-739ff700000015d6-52-6227797340bb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.96.03370.1D577226; Wed,  9 Mar 2022 00:27:13 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152711epsmtip16a2a58aa2b7d39548f005e0fddf6732a~acVbohUIj3168431684epsmtip1E;
        Tue,  8 Mar 2022 15:27:11 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 10/17] block: wire-up support for plugging
Date:   Tue,  8 Mar 2022 20:50:58 +0530
Message-Id: <20220308152105.309618-11-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJsWRmVeSWpSXmKPExsWy7bCmpm5xpXqSQe9TdYvphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
        5OIToOuWmQP0g5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10v
        L7XEytDAwMgUqDAhO+PL4Q+MBQfkKu79mMDYwDhHsouRk0NCwETi+u5XbF2MXBxCArsZJW5s
        P8MC4XxilLjXv4YdwvnMKLG1fQIrTMuZHTuZIBK7GCW+d3awgyTAqh7uiexi5OBgE9CUuDC5
        FCQsIuAlcf/2e1aQemaBLiaJt/vus4EkhAWsJLasf88MYrMIqEq8m3EBzOYFil+Y85sNYpm8
        xMxL38HmcwLFf97aygpRIyhxcuYTFhCbGaimeetsZpAFEgIHOCRaV76HutRF4mjrciYIW1ji
        1fEt7BC2lMTL/jYou1ji152jUM0djBLXG2ayQCTsJS7u+csE8g0z0Dfrd+lDhGUlpp5axwSx
        mE+i9/cTqPm8EjvmwdiKEvcmPYW6QVzi4YwlULaHxJM3B5khIdfLKDF5bSPbBEaFWUgemoXk
        oVkIqxcwMq9ilEwtKM5NTy02LTDOSy2HR3Nyfu4mRnDC1vLewfjowQe9Q4xMHIyHGCU4mJVE
        eO+fV0kS4k1JrKxKLcqPLyrNSS0+xGgKDPGJzFKiyfnAnJFXEm9oYmlgYmZmZmJpbGaoJM57
        Kn1DopBAemJJanZqakFqEUwfEwenVAOTpG2Tolfbox0TnM+9fq0bHHIq98l2ftb/L+ZG1M0X
        cpMKvJvxcueh3WFpV40fnN98vFr+70kGtr1PF3hqFzNJegqzctZUnSo9OqPmyxOvcyvrakuD
        nDi1efVrJjK8dhHa8zWxaVaKw4/nZ/9PWChgz3CqwyU5f1tJ0xzHf5bn+8SSQ3bPcKz7Fnmc
        QUK59PkVC91ZOg5Rxzo/mV0M+Ge9aMGzw6+/nvD54Jh8XdcpacPZ9KrW1XKnp2h7314kuu/3
        rmfmE9dWK/vvXHxP3+yPspBp1+2AiyujLRNrJm/a/OrdJPmN34vndRp3PU8tc5z3akmWudJM
        g2dLwk86HV0j7z9j3zPWWOFZzXO+KJ3fr8RSnJFoqMVcVJwIAN0QxIxhBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJTvdiqXqSwcc7lhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr48vhD4wFB+Qq7v2YwNjAOEeyi5GTQ0LAROLM
        jp1MILaQwA5GiXWtvhBxcYnmaz/YIWxhiZX/ngPZXEA1Hxkl1i+dx9zFyMHBJqApcWFyKUiN
        iECAxMHGy2A1zAIzmCR6mj+zgCSEBawktqx/zwxiswioSrybcQHM5gWKX5jzmw1igbzEzEvf
        wZZxAsV/3trKCnGQpcSKdRA1vAKCEidnPgGbyQxU37x1NvMERoFZSFKzkKQWMDKtYpRMLSjO
        Tc8tNiwwykst1ytOzC0uzUvXS87P3cQIjictrR2Me1Z90DvEyMTBeIhRgoNZSYT3/nmVJCHe
        lMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYauInfdeNnmtt
        VrlP61G8hM2l5IjvlXeLF+45yNOskMy3MTnywm2G5mCjt+u2TfnH9tTTbmvMjimhWisj79Yc
        b2w4ZhI0Q25v7FKtPx0tRy/q1+VEtEq7/uNcsPJS2tFplbt8Ny3apRN5IkHi18Hm6w/KQ/qn
        xgWWHYpcFeVQWp6y/NOzTz88fUzvVGyLPCuwR7bHkHnXnCwj2b1zGpc9t54yySZveadmZffJ
        nf/sr/GKfVebZeavySkePslH/vfvDXwCPzOE2T5N/OKbcCHLffvOu0+Dc8rPRk7RebtImqfb
        8tfmlulB2n2PJgZbFa979GkND4vAmw0NNXxFn9lbwt+x/Zp0X0dCytbbKEhdiaU4I9FQi7mo
        OBEAk9OYNxYDAAA=
X-CMS-MailID: 20220308152714epcas5p4c5a0d16512fd7054c9a713ee28ede492
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152714epcas5p4c5a0d16512fd7054c9a713ee28ede492
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152714epcas5p4c5a0d16512fd7054c9a713ee28ede492@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

Add support to use plugging if it is enabled, else use default path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c | 90 ++++++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 43 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1adfe4824ef5..29f65eaf3e6b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2326,6 +2326,40 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
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
@@ -2339,16 +2373,20 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
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
@@ -2666,40 +2704,6 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
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

