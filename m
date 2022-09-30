Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFBF5F0527
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiI3GpP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiI3GpJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:45:09 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610FC1F9ED
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:44:56 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220930064454epoutp021f1a9da55c2ffd29f96797e786072cd0~ZkGN-7B6E0424704247epoutp027
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:44:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220930064454epoutp021f1a9da55c2ffd29f96797e786072cd0~ZkGN-7B6E0424704247epoutp027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520294;
        bh=tDC98zhUChsoFxyax6OGBO2ZGu3ypq6Y8ZQCxc+Plfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZL+No5DInG82hyUQlmn9tGqHZ8aMqYn84o3M/jWlv9aUaRDh2I9SEaJr93S8jiXgr
         /Hf31PtkgZ3axZA+jBoL7Pd3T+Vx8/oakA5LBURR7feL7iEpehrtRyMchJGv3HBtjT
         PPuJE46zObixyEDYi+QOBOQr/WjTk/HW10QZqD4Q=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220930064453epcas5p30182b25ffd0a63d0d2c10c1a766c6605~ZkGNsxaas2067520675epcas5p3j;
        Fri, 30 Sep 2022 06:44:53 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Mf11Z6kncz4x9QK; Fri, 30 Sep
        2022 06:44:50 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C9.CD.39477.F5096336; Fri, 30 Sep 2022 15:44:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220930063831epcas5p4b6a8559dedd39ef423a0b9a317163969~ZkApTi86I2025120251epcas5p4H;
        Fri, 30 Sep 2022 06:38:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220930063831epsmtrp1de3393fe7c03723a16fede328b3bd0c3~ZkApSranM2641426414epsmtrp14;
        Fri, 30 Sep 2022 06:38:31 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-bb-6336905f0964
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.69.14392.7EE86336; Fri, 30 Sep 2022 15:38:31 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063829epsmtip215b19387b98af7ff187f06f2ff8ba3c2~ZkAnvK22K1483614836epsmtip2P;
        Fri, 30 Sep 2022 06:38:29 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v12 10/12] block: extend functionality to map bvec
 iterator
Date:   Fri, 30 Sep 2022 11:57:47 +0530
Message-Id: <20220930062749.152261-11-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmum78BLNkg5NvzC2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMvxuLC37KVJz6eYG9gfGzWBcjJ4eEgInEgy932LoYuTiE
        BHYzSlw9/4AJwvnEKLHrzVl2COcbo8Tev3vZYVoal6wEs4UE9jJKbHrDAmF/ZpS4Nd8LxGYT
        UJc48ryVEcQWETCS2P/pJCvIIGaBm4wSzcf2Aa3g4BAWCJP4M0MSpIZFQFXi1aeNrCA2r4C1
        xMKNOxkhdslLzLz0nR2knBMo3rwoB6JEUOLkzCdga5mBSpq3zmYGGS8h0MghMevoQSaIXheJ
        A5PfQM0Rlnh1fAvU/VISL/vboOx0iR+Xn0LVF4CcBlVvL9F6qp8ZZC+zgKbE+l36EGFZiamn
        1jFB7OWT6P39BKqVV2LHPBhbSaJ95RwoW0Ji77kGKNtDomHKcmhI9zFKzPg5k3ECo8IsJP/M
        QvLPLITVCxiZVzFKphYU56anFpsWGOWllsOjODk/dxMjOKFqee1gfPjgg94hRiYOxkOMEhzM
        SiK84gWmyUK8KYmVValF+fFFpTmpxYcYTYHhPZFZSjQ5H5jS80riDU0sDUzMzMxMLI3NDJXE
        eRfP0EoWEkhPLEnNTk0tSC2C6WPi4JRqYOKftSZ0/T6jJ/23D7tyf8oSXcp499ezxA1/d9/2
        4lOK/mWQ952lyDxk+TntT/fyd95+W2zpqaq/aKFxjPiayW/e7dnKruC0aWf083CmKzZXIzP9
        K5Pjf0oq3i/yNpnxR2POSm3FxV/n+azn2/hHkGuKJc+6v26xzR9bVeefqtr87ZSW4u+s2cIC
        i1QnFd741CN/XsZY8KaXQfjFhKtP5QzXpQu8eKD8zU7H3i95JnfogcUrJf552y3Y728fOvUU
        /zbP5kUbcz7oKbp+yCo42Tel+Wjq9P1cuTzJKdt3uJqZi6cp3Djc0W9w+etB1zPn5SXfX5m8
        50fVlw0tYo1JE3+JH6l1a/ruMH0+g4Hh9XwlluKMREMt5qLiRADPDXhpMQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvO7zPrNkg0+tfBZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i+7rO9gcuDwuny312LSqk81j
        85J6j903G9g8+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+PvxuKCnzIVp35eYG9g/CzWxcjJ
        ISFgItG4ZCV7FyMXh5DAbkaJS13rWSASEhKnXi5jhLCFJVb+ew5V9JFRYsfO22AJNgF1iSPP
        W8FsEQEziaWH17CAFDEL3GeUeNu8G2ySsECIxMYlt9lAbBYBVYlXnzaygti8AtYSCzfuhNog
        LzHz0negDRwcnEDx5kU5IGEhASuJz3ves0OUC0qcnPkEbCQzUHnz1tnMExgFZiFJzUKSWsDI
        tIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzjstTR3MG5f9UHvECMTB+MhRgkOZiUR
        XvEC02Qh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamNTD
        HQ+tLOorz7Xgsdr4SWuiumfODO5/xjLmPL++qE1xWf8+rHLbql+zMyr+X/VeNZ83sc08ZJWI
        3Sq23nyJV2YGSTfLfNOPtE5yEsibknKIwaxrWsE7lpAL9aeFne4mSK0/GWMWt2ft0bi507a9
        NL/85xjXW+vt3J1fPvqXZKytl9kScmnB9YLGMJc3l0NbF0gGTv5ts2HN6u2SSWeqd386H2A+
        VVL1xoHJS/1bHxmdnTLRfH6IsubE3q91EydNe2BzTLiC8TXjliUCWrJqCxTcin9fz37Q+fDf
        lLPaE+YxfFITtnhW9CvLjHXmgX3+MRcCrEU5mZQLXQpXRwXfqZxqzsp7ZdqpZ9NtnQ7ZH1Vi
        Kc5INNRiLipOBADTsuvS6gIAAA==
X-CMS-MailID: 20220930063831epcas5p4b6a8559dedd39ef423a0b9a317163969
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063831epcas5p4b6a8559dedd39ef423a0b9a317163969
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063831epcas5p4b6a8559dedd39ef423a0b9a317163969@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

Extend blk_rq_map_user_iov so that it can handle bvec iterator, using
the new blk_rq_map_user_bvec function. It maps the pages from bvec
iterator into a bio and place the bio into request.

This helper will be used by nvme for uring-passthrough path when IO is
done using pre-mapped buffers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 4 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index d6ea377394a9..34735626b00f 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -548,6 +548,62 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 }
 EXPORT_SYMBOL(blk_rq_append_bio);
 
+/* Prepare bio for passthrough IO given ITER_BVEC iter */
+static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
+{
+	struct request_queue *q = rq->q;
+	size_t nr_iter = iov_iter_count(iter);
+	size_t nr_segs = iter->nr_segs;
+	struct bio_vec *bvecs, *bvprvp = NULL;
+	struct queue_limits *lim = &q->limits;
+	unsigned int nsegs = 0, bytes = 0;
+	struct bio *bio;
+	size_t i;
+
+	if (!nr_iter || (nr_iter >> SECTOR_SHIFT) > queue_max_hw_sectors(q))
+		return -EINVAL;
+	if (nr_segs > queue_max_segments(q))
+		return -EINVAL;
+
+	/* no iovecs to alloc, as we already have a BVEC iterator */
+	bio = blk_rq_map_bio_alloc(rq, 0, GFP_KERNEL);
+	if (bio == NULL)
+		return -ENOMEM;
+
+	bio_iov_bvec_set(bio, (struct iov_iter *)iter);
+	blk_rq_bio_prep(rq, bio, nr_segs);
+
+	/* loop to perform a bunch of sanity checks */
+	bvecs = (struct bio_vec *)iter->bvec;
+	for (i = 0; i < nr_segs; i++) {
+		struct bio_vec *bv = &bvecs[i];
+
+		/*
+		 * If the queue doesn't support SG gaps and adding this
+		 * offset would create a gap, fallback to copy.
+		 */
+		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset)) {
+			blk_mq_map_bio_put(bio);
+			return -EREMOTEIO;
+		}
+		/* check full condition */
+		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
+			goto put_bio;
+		if (bytes + bv->bv_len > nr_iter)
+			goto put_bio;
+		if (bv->bv_offset + bv->bv_len > PAGE_SIZE)
+			goto put_bio;
+
+		nsegs++;
+		bytes += bv->bv_len;
+		bvprvp = bv;
+	}
+	return 0;
+put_bio:
+	blk_mq_map_bio_put(bio);
+	return -EINVAL;
+}
+
 /**
  * blk_rq_map_user_iov - map user data to a request, for passthrough requests
  * @q:		request queue where request should be inserted
@@ -567,24 +623,35 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			struct rq_map_data *map_data,
 			const struct iov_iter *iter, gfp_t gfp_mask)
 {
-	bool copy = false;
+	bool copy = false, map_bvec = false;
 	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
 	struct bio *bio = NULL;
 	struct iov_iter i;
 	int ret = -EINVAL;
 
-	if (!iter_is_iovec(iter))
-		goto fail;
-
 	if (map_data)
 		copy = true;
 	else if (blk_queue_may_bounce(q))
 		copy = true;
 	else if (iov_iter_alignment(iter) & align)
 		copy = true;
+	else if (iov_iter_is_bvec(iter))
+		map_bvec = true;
+	else if (!iter_is_iovec(iter))
+		copy = true;
 	else if (queue_virt_boundary(q))
 		copy = queue_virt_boundary(q) & iov_iter_gap_alignment(iter);
 
+	if (map_bvec) {
+		ret = blk_rq_map_user_bvec(rq, iter);
+		if (!ret)
+			return 0;
+		if (ret != -EREMOTEIO)
+			goto fail;
+		/* fall back to copying the data on limits mismatches */
+		copy = true;
+	}
+
 	i = *iter;
 	do {
 		if (copy)
-- 
2.25.1

