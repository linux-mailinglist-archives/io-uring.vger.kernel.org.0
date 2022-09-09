Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FBA5B3545
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 12:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiIIKcA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 06:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiIIKb4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 06:31:56 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096969C21C
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 03:31:53 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220909103152epoutp047135953dcd4a1061c095870e48005204~TKpY8uM_g1557415574epoutp04D
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 10:31:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220909103152epoutp047135953dcd4a1061c095870e48005204~TKpY8uM_g1557415574epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662719512;
        bh=hepCkLsLawcUW6NPOu6/Vf5Idoa6NAsOreUa0e5m0PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddutFD1Yfz1DR1yND3horf0XCZGiQSlzKI5TLhximJiS9EAksY9fUYtFQs5RXarnv
         lWfsfHry6KstsvmUJnWq517gYJAonaxoaEPhWzfllqC1FA5xMxOL7EB446F8jIxKwI
         p3kAHR3HbK2USYgpcB8ssNdbrOHpuWmRX6IB8Tyk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220909103151epcas5p11c4bfec887a9c1c56f3870954935e776~TKpYiMDZD0657806578epcas5p1B;
        Fri,  9 Sep 2022 10:31:51 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MPC391478z4x9Px; Fri,  9 Sep
        2022 10:31:49 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.DB.59633.3161B136; Fri,  9 Sep 2022 19:31:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd~TKpUeiPhJ0487204872epcas5p24;
        Fri,  9 Sep 2022 10:31:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220909103147epsmtrp251d15f3adaaef49f00bb220fdd1bfb82~TKpUbpCPC1218912189epsmtrp2T;
        Fri,  9 Sep 2022 10:31:47 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-b3-631b1613a845
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.B1.18644.3161B136; Fri,  9 Sep 2022 19:31:47 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220909103145epsmtip1bdea779def076df2f0443c6d2a1f1062~TKpSgLoFj3150731507epsmtip1V;
        Fri,  9 Sep 2022 10:31:45 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v7 4/5] block: add helper to map bvec iterator for
 passthrough
Date:   Fri,  9 Sep 2022 15:51:35 +0530
Message-Id: <20220909102136.3020-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909102136.3020-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmlq6wmHSywZI1+hZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrI7cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc2jb8sqRo/Pm+QC2KOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
        dQ0tLcyVFPISc1NtlVx8AnTdMnOAjlNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTk
        FJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGdMXDOTreCaUsX6fdtYGxgfSXcxcnJICJhIzLh3
        k6mLkYtDSGA3o8SkVw1sEM4nRommtbugnM+MEo2Xl7PAtHxv72OESOxilLhz6jcrXNXVmZuA
        hnFwsAloSlyYXArSICLgJXH/9nuwGmaQHav/vmUFSQgLREp8efoJbCqLgKrE89/nmEFsXgFz
        iR0vvzBDbJOXmHnpOzuIzSlgITH58zV2iBpBiZMzn4D1MgPVNG+dzQyyQEKgk0PiwaJ/UM0u
        ErdmvIY6W1ji1fEt7BC2lMTnd3vZIOxkiUszzzFB2CUSj/cchLLtJVpP9TODPMMM9Mz6XfoQ
        u/gken8/AftRQoBXoqNNCKJaUeLepKesELa4xMMZS6BsD4k1c65AA6ubUeLi0xssExjlZyF5
        YRaSF2YhbFvAyLyKUTK1oDg3PbXYtMAwL7UcHrPJ+bmbGMGJVMtzB+PdBx/0DjEycTAeYpTg
        YFYS4RVdK5EsxJuSWFmVWpQfX1Sak1p8iNEUGMYTmaVEk/OBqTyvJN7QxNLAxMzMzMTS2MxQ
        SZx3ijZjspBAemJJanZqakFqEUwfEwenVAPTREO3SvV1eRod/3tfqOW9CGhbJOsbfyDt1N1t
        FqG2ryZW5blX84htyCi0n6cxM8zv/vn0hevWl+Zfu/DulbwYq6pi7qYXV9LsRGJZXxlXPl5Q
        vSZFvyG7YkeI3Xa9tieTgzmfKCUKHQ/gl7BOqw+ulq8RWPx9hkj26QXr1N7HbD7SdMj+6ClP
        2acHVth+eRJ8/nnbx8AM9dz93M2pYtPONfSx/7tV+qnu5angG0ftMm4s/FBUdUdj5ezVgZd/
        rTcI9G8x3KEbrPJnnZr887lxyot5zBbxT51fNd9y/cmbWlbiT9y/zVYOaVutESJ0MKY+5fn6
        XdO11H61LZ0uoqM17ektLolO+5uO/oc2rzBSYinOSDTUYi4qTgQAENMblC0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSnK6wmHSywe2f/BZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrI7cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc2jb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4MiaumclWcE2pYv2+bawN
        jI+kuxg5OSQETCS+t/cxdjFycQgJ7GCU+PjjDytEQlyi+doPdghbWGLlv+fsEEUfGSWa+74y
        dzFycLAJaEpcmFwKUiMiECBxsPEyWA2zwEFGifNN31hAEsIC4RJdM04yg9gsAqoSz3+fA7N5
        Bcwldrz8wgyxQF5i5qXvYMs4BSwkJn++BmYLAdW83vmJBaJeUOLkzCdgNjNQffPW2cwTGAVm
        IUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOAa0tHYw7ln1Qe8QIxMH
        4yFGCQ5mJRFe0bUSyUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJ
        MnFwSjUw7Z5udJhvw56nxhUrLKxW/j1741jMf0f9APdXelzChz14J+fLxlVkv9B7t0GIO6//
        oNDbrrnrLnb48932it1ycq2U2+S3/106PTe0dhi/u3lKnn35vkc1k5Pids4Lt7FlXrapfWv6
        yTxHxkWHpoQHS1cz7njG6tQjbnDsuMzRvXU5G91T7Cs/pRysKnLPYJjpq+TSueHNucMuTp3n
        thtv/GUjcH1ZnO83K87NH9fM7H1yTXyOy0bnqF6zP8xcOlsNm1lmS8bOqrPiuMn46bjWYxbn
        eNH+s3cWyrGz2fccXSTdazYjt8o8NTMhJaC8crKtidjO4mMiNqJzSvv9fVSaOGZKxUvJdiXc
        2SzkaaDEUpyRaKjFXFScCAA2MWDc8AIAAA==
X-CMS-MailID: 20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd
References: <20220909102136.3020-1-joshi.k@samsung.com>
        <CGME20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 block/blk-map.c        | 87 +++++++++++++++++++++++++++++++++++++-----
 include/linux/blk-mq.h |  1 +
 2 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 7693f8e3c454..5dcfa112f240 100644
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
@@ -611,6 +622,62 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
+/* Prepare bio for passthrough IO given an existing bvec iter */
+int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter)
+{
+	struct request_queue *q = rq->q;
+	size_t nr_iter, nr_segs, i;
+	struct bio *bio;
+	struct bio_vec *bv, *bvecs, *bvprvp = NULL;
+	struct queue_limits *lim = &q->limits;
+	unsigned int nsegs = 0, bytes = 0;
+
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
+			goto out_err;
+
+		/* check full condition */
+		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
+			goto out_err;
+
+		if (bytes + bv->bv_len <= nr_iter &&
+				bv->bv_offset + bv->bv_len <= PAGE_SIZE) {
+			nsegs++;
+			bytes += bv->bv_len;
+		} else
+			goto out_err;
+		bvprvp = bv;
+	}
+	return 0;
+out_err:
+	bio_map_put(bio);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(blk_rq_map_user_bvec);
+
 /**
  * blk_rq_unmap_user - unmap a request with user data
  * @bio:	       start of bio list
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b43c81d91892..83bef362f0f9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -970,6 +970,7 @@ struct rq_map_data {
 	bool from_user;
 };
 
+int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter);
 int blk_rq_map_user(struct request_queue *, struct request *,
 		struct rq_map_data *, void __user *, unsigned long, gfp_t);
 int blk_rq_map_user_iov(struct request_queue *, struct request *,
-- 
2.25.1

