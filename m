Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E048A5E7772
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 11:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiIWJm0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 05:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiIWJkp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 05:40:45 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09FD130BF0
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 02:39:25 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220923093924epoutp0467111ce9f20bdeb024d0a78df514d23e~Xc9k-d__M1030110301epoutp04K
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 09:39:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220923093924epoutp0467111ce9f20bdeb024d0a78df514d23e~Xc9k-d__M1030110301epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663925964;
        bh=ONWjb8pj4oI1GKHd8OT2dD1nbK8wwvhuhUNQrEIxjyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbkxbeSYXHOmgPMIPi55SqZ2QEci/jZDmC7o4v+PT638CZYcgPS9G/q1ART40a6xi
         chCbL7fc26DTeH0LvsDwQNOE8inDlL871YKMWvaP8ES1Btu05mF41r6rUw3VROnpkE
         Bsx3gPj5Zeit82lTuywxsKzeX2ZRcaYFwbUWOWHk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220923093923epcas5p11296e5e2f9d8d67fdabec642bc824d08~Xc9j97ed_1642216422epcas5p1R;
        Fri, 23 Sep 2022 09:39:23 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MYnD775nbz4x9Px; Fri, 23 Sep
        2022 09:39:19 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.B1.56352.7CE7D236; Fri, 23 Sep 2022 18:39:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220923093919epcas5p3d019fa1db990101478b8d6673ac0eaa6~Xc9gnKs1e3163431634epcas5p3a;
        Fri, 23 Sep 2022 09:39:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220923093919epsmtrp2de633a6b235faa6f39e7ac3052b9e932~Xc9gmL5Nl1234812348epsmtrp2B;
        Fri, 23 Sep 2022 09:39:19 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-eb-632d7ec7f0a7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EE.FC.14392.7CE7D236; Fri, 23 Sep 2022 18:39:19 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220923093917epsmtip2335f5313b422d05c042b329f3d1477e8~Xc9fFAO-X2705727057epsmtip29;
        Fri, 23 Sep 2022 09:39:17 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v8 4/5] block: add helper to map bvec iterator for
 passthrough
Date:   Fri, 23 Sep 2022 14:58:53 +0530
Message-Id: <20220923092854.5116-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923092854.5116-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTQ/d4nW6ywa1DFhZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
        tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqX
        rpeXWmJlaGBgZApUmJCdMeVlM1PBWvWKaQdfsDcwLpHvYuTkkBAwkVhw6x0riC0ksJtR4utC
        ri5GLiD7E6NEz/kJTBDON0aJzu/32WE6tjfMYoZI7GWU2PThLgtE+2dGicubYrsYOTjYBDQl
        LkwuBQmLCBhJ7P90khWknhlkw+q/b8HWCQtESizs+8wEYrMIqEqc33OcGcTmFTCXeHp2ATPE
        MnmJmZe+gy3mFLCQWLT5FhNEjaDEyZlPwPYyA9U0b50NdpCEwF92ibu3VkBd6iKxaMkqJghb
        WOLV8S1QcSmJz+/2skHYyRKXZp6DqimReLznIJRtL9F6qp8Z5BlmoGfW79KH2MUn0fv7CRNI
        WEKAV6KjTQiiWlHi3qSnrBC2uMTDGUugbA+Jm7e2skHCqptR4tqiy4wTGOVnIXlhFpIXZiFs
        W8DIvIpRMrWgODc9tdi0wDgvtRwer8n5uZsYwQlTy3sH46MHH/QOMTJxMB5ilOBgVhLhnX1H
        M1mINyWxsiq1KD++qDQntfgQoykwjCcyS4km5wNTdl5JvKGJpYGJmZmZiaWxmaGSOO/iGVrJ
        QgLpiSWp2ampBalFMH1MHJxSDUz7Vi474NtiXaIkUl/Kt+mDTkz76isZm1MefLqy+APXm3sr
        LwvsUjNpVTVo5XVUWT6fpeFZ0u2nTNdfvOvVZtWzuRvKH6oQfWZK8+M95y6Yy1dXy7pmme9d
        1jvx2wrLPtG6G44MTSdfu8hxy8cwuy5n72HUX9gbzvHz0CSG17d1T9camb2Jbf3nG7Ov9edf
        zZ/zpsSucNU6HVjXMCsm+Inao4n3zdXMZUv8guLWXn6RNskx7UvvotJnz4pEij8oyDqsuaDi
        1XNtY7DJNsE6hcSy4jTrOxymjrEFL9bYHPw2fVLu9Sjb4m5Z+Tfzi69e65Z9ahbL07V53dLC
        YN4nVTX3tVbpJXNWftqp7qk4R4mlOCPRUIu5qDgRAN5eKZIhBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSvO7xOt1kg8sXJC2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJUx5WUzU8Fa9YppB1+wNzAuke9i5OSQEDCR
        2N4wi7mLkYtDSGA3o8TfD/NZIRLiEs3XfrBD2MISK/89Z4co+sgo0f2xm7GLkYODTUBT4sLk
        UpAaEQEziaWH17CA1DALHGSUON/0jQUkISwQLnH88A4mEJtFQFXi/J7jzCA2r4C5xNOzC5gh
        FshLzLz0HWwZp4CFxKLNt8DqhYBqflx6wQhRLyhxcuYTsJnMQPXNW2czT2AUmIUkNQtJagEj
        0ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOBw19Lcwbh91Qe9Q4xMHIyHGCU4mJVE
        eGff0UwW4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgWmS
        R81W02MJK/5dYvOJnMvV5+l0k9XdY+kvjZjl2t7LM5c575C6NjXX9Jr/rVrvU2vlbTR1m8O2
        TU7K4yldO/+EFU/K7VVMVkKCKeal2m5MDvdeBzBt9dhyivNl12ULhodW5/I2MRW0Zci+O13f
        npnx7/Lvj6rWX9f3sbefjf35PWT6a2n2Za0M3ic+uX3ZKcOrwy4RpWXT/8x/v/XcStl3XhK7
        j3REGmRn5+9dquMxLTbZX5TV8cvSI2FyG68t4jA+d9XywTrtLac/r/lVv+1qlGeXsPTfEx9W
        bYpL+bosxjTxe02s9veSrKe1d7ZyL5VM5FkZGzt90XamlMS90cr1Kw1fJR0v/nLN/7xVrhJL
        cUaioRZzUXEiABrJlgbmAgAA
X-CMS-MailID: 20220923093919epcas5p3d019fa1db990101478b8d6673ac0eaa6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220923093919epcas5p3d019fa1db990101478b8d6673ac0eaa6
References: <20220923092854.5116-1-joshi.k@samsung.com>
        <CGME20220923093919epcas5p3d019fa1db990101478b8d6673ac0eaa6@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add blk_rq_map_user_bvec which maps the bvec iterator into a bio and
places that into the request. This helper will be used in nvme for
uring-passthrough with fixed-buffer.
While at it, create another helper bio_map_get to reduce the code
duplication.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-map.c        | 111 +++++++++++++++++++++++++++++++++++++----
 include/linux/blk-mq.h |   1 +
 2 files changed, 102 insertions(+), 10 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 7693f8e3c454..d6265d49b15b 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -241,17 +241,10 @@ static void bio_map_put(struct bio *bio)
 	}
 }
 
-static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
+static struct bio *bio_map_get(struct request *rq, unsigned int nr_vecs,
 		gfp_t gfp_mask)
 {
-	unsigned int max_sectors = queue_max_hw_sectors(rq->q);
-	unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
 	struct bio *bio;
-	int ret;
-	int j;
-
-	if (!iov_iter_count(iter))
-		return -EINVAL;
 
 	if (rq->cmd_flags & REQ_POLLED) {
 		blk_opf_t opf = rq->cmd_flags | REQ_ALLOC_CACHE;
@@ -259,13 +252,31 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 		bio = bio_alloc_bioset(NULL, nr_vecs, opf, gfp_mask,
 					&fs_bio_set);
 		if (!bio)
-			return -ENOMEM;
+			return NULL;
 	} else {
 		bio = bio_kmalloc(nr_vecs, gfp_mask);
 		if (!bio)
-			return -ENOMEM;
+			return NULL;
 		bio_init(bio, NULL, bio->bi_inline_vecs, nr_vecs, req_op(rq));
 	}
+	return bio;
+}
+
+static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
+		gfp_t gfp_mask)
+{
+	unsigned int max_sectors = queue_max_hw_sectors(rq->q);
+	unsigned int nr_vecs = iov_iter_npages(iter, BIO_MAX_VECS);
+	struct bio *bio;
+	int ret;
+	int j;
+
+	if (!iov_iter_count(iter))
+		return -EINVAL;
+
+	bio = bio_map_get(rq, nr_vecs, gfp_mask);
+	if (bio == NULL)
+		return -ENOMEM;
 
 	while (iov_iter_count(iter)) {
 		struct page **pages, *stack_pages[UIO_FASTIOV];
@@ -611,6 +622,86 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
+/* Prepare bio for passthrough IO given an existing bvec iter */
+int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter)
+{
+	struct request_queue *q = rq->q;
+	size_t nr_iter, nr_segs, i;
+	struct bio *bio = NULL;
+	struct bio_vec *bv, *bvecs, *bvprvp = NULL;
+	struct queue_limits *lim = &q->limits;
+	unsigned int nsegs = 0, bytes = 0;
+	bool copy = false;
+	int ret;
+	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
+
+	/* see if we need to copy pages due to any weird situation */
+	if (blk_queue_may_bounce(q))
+		copy = true;
+	else if (iov_iter_alignment(iter) & align)
+		copy = true;
+
+	if (copy) {
+		do {
+			ret = bio_copy_user_iov(rq, NULL, iter, GFP_KERNEL);
+			if (ret) {
+				blk_rq_unmap_user(bio);
+				rq->bio = NULL;
+				break;
+			}
+			if (!bio)
+				bio = rq->bio;
+		} while (iov_iter_count(iter));
+
+		return ret;
+	}
+	/* common (non-copy) case handling */
+	nr_iter = iov_iter_count(iter);
+	nr_segs = iter->nr_segs;
+
+	if (!nr_iter || (nr_iter >> SECTOR_SHIFT) > queue_max_hw_sectors(q))
+		return -EINVAL;
+	if (nr_segs > queue_max_segments(q))
+		return -EINVAL;
+
+	/* no iovecs to alloc, as we already have a BVEC iterator */
+	bio = bio_map_get(rq, 0, GFP_KERNEL);
+	if (bio == NULL)
+		return -ENOMEM;
+
+	bio_iov_bvec_set(bio, iter);
+	blk_rq_bio_prep(rq, bio, nr_segs);
+
+	/* loop to perform a bunch of sanity checks */
+	bvecs = (struct bio_vec *)iter->bvec;
+	for (i = 0; i < nr_segs; i++) {
+		bv = &bvecs[i];
+		/*
+		 * If the queue doesn't support SG gaps and adding this
+		 * offset would create a gap, disallow it.
+		 */
+		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset))
+			goto put_bio;
+
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
+	bio_map_put(bio);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(blk_rq_map_user_bvec);
+
 /**
  * blk_rq_unmap_user - unmap a request with user data
  * @bio:	       start of bio list
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 00a15808c137..1a9ae17e49be 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -977,6 +977,7 @@ struct rq_map_data {
 	bool from_user;
 };
 
+int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter);
 int blk_rq_map_user(struct request_queue *, struct request *,
 		struct rq_map_data *, void __user *, unsigned long, gfp_t);
 int blk_rq_map_user_iov(struct request_queue *, struct request *,
-- 
2.25.1

