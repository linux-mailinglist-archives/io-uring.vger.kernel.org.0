Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D055B2620
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiIHSqM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiIHSqF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:46:05 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5508F63F2A
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 11:45:44 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220908184542epoutp03aabd867e6759cef588cf614ee4a4d88d~S9vR4VUAM0315103151epoutp03w
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 18:45:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220908184542epoutp03aabd867e6759cef588cf614ee4a4d88d~S9vR4VUAM0315103151epoutp03w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662662742;
        bh=hepCkLsLawcUW6NPOu6/Vf5Idoa6NAsOreUa0e5m0PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izY10vJLDcmuzuO/Nrq06fndgOn0FQMREEHeHpoi5oXmHXnhgpf/a1iLn/2rqaSof
         bOXI8IIf1D8fP+VKBLVxg4UwDISAGyzDIANdN7df6YiQ9RkoW53r8hqi82O3NnxLcE
         EqYS8GBCKe/j1Jq36XFAVsauHy8qFa8hEhQel4yk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220908184541epcas5p4d6a036bb587c01f62c7838f760f0941e~S9vRVyDm90530505305epcas5p4w;
        Thu,  8 Sep 2022 18:45:41 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MNp3R1sWqz4x9Pq; Thu,  8 Sep
        2022 18:45:39 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.49.54060.3583A136; Fri,  9 Sep 2022 03:45:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220908184538epcas5p378c450bfe07d296a9abc843efe75dfc9~S9vOnjjUs0406904069epcas5p3V;
        Thu,  8 Sep 2022 18:45:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220908184538epsmtrp1161fc4a31213ad0a138f4d6dbcc5eea9~S9vOmrjHa3080730807epsmtrp1g;
        Thu,  8 Sep 2022 18:45:38 +0000 (GMT)
X-AuditID: b6c32a4b-be1ff7000000d32c-d9-631a3853ebb6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.DD.14392.2583A136; Fri,  9 Sep 2022 03:45:38 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220908184537epsmtip220246c38dd98a5fed693dc42c22ba7cb~S9vNNIcW12337123371epsmtip2E;
        Thu,  8 Sep 2022 18:45:37 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v6 4/5] block: add helper to map bvec iterator for
 passthrough
Date:   Fri,  9 Sep 2022 00:05:10 +0530
Message-Id: <20220908183511.2253-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908183511.2253-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmpm6whVSywbn5HBZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrI7cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc2jb8sqRo/Pm+QC2KOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
        dQ0tLcyVFPISc1NtlVx8AnTdMnOAjlNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTk
        FJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGdMXDOTreCaUsX6fdtYGxgfSXcxcnJICJhIXLz8
        m62LkYtDSGA3o8Tq4++ZQRJCAp8YJdZcqO5i5ACyvzFKTIqHqZ/+vh+qfi+jxL/me+wQzmdG
        id3z/7KBNLAJaEpcmFwK0iAi4CVx//Z7VpAaZrAFf9+ygiSEBSIl1u/+yghiswioSlw7eJwF
        xOYVMJdoWNrODrFNXmLmpe9gNqeAhcTFLw/ZIGoEJU7OfAJWzwxU07x1NjPIAgmBVg6J/pW3
        WSCaXSSeH7sCZQtLvDq+BWqolMTL/jYoO1ni0sxzTBB2icTjPQehbHuJ1lP9zCDPMAM9s36X
        PsQuPone30+YQMISArwSHW1CENWKEvcmPWWFsMUlHs5YAmV7SGzf/xoaWN2MEmsv97BPYJSf
        heSFWUhemIWwbQEj8ypGydSC4tz01GLTAuO81HJ4tCbn525iBKdQLe8djI8efNA7xMjEwXiI
        UYKDWUmEV3StRLIQb0piZVVqUX58UWlOavEhRlNgGE9klhJNzgcm8bySeEMTSwMTMzMzE0tj
        M0Mlcd4p2ozJQgLpiSWp2ampBalFMH1MHJxSDUy9AhI75Bw4NKovqF9hunTIKJdB4Ooz28Vq
        jDcOPHhQKatjELC4LaErRPn4yx+L6iPNf0wJXBhkZ7Nmucl3jleFjjVC1x4fK59RKMJ2d5nX
        dcWiJbs1r+xMNEoonrfP+rgzt7PQ7ZoEhoWqWxsv2XJNZVITDV666FliyozN3emOc3ZfCDl0
        cZXEStUfZxdMjE94fMbGWdDJ+Frq7b8RxTzi6537nCu66x593/coa8p1rSJWsUUnv3YseKl1
        dr/v3Qoe7po9OtUdCj3/vCTdZ59ZGb3VofoM77FtNgvi1R1uWV06EpX5osdGJbnoZp1etFzo
        UuMd1go/VjZuSeCdNifAoa1C9JtKwOJnBpJG1UosxRmJhlrMRcWJAHi9itMqBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSvG6QhVSywZOZOhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrI7cHnsnHWX3ePy2VKP
        Tas62Tw2L6n32H2zgc2jb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4MiaumclWcE2pYv2+bawN
        jI+kuxg5OSQETCSmv+9nA7GFBHYzSpyYyw0RF5dovvaDHcIWllj57zmQzQVU85FR4uWro4xd
        jBwcbAKaEhcml4LUiAgESBxsvAxWwyxwkFHifNM3FpCEsEC4xM87f8BsFgFViWsHj4PZvALm
        Eg1L26EWyEvMvPQdzOYUsJC4+OUh1EHmEtf+TGeGqBeUODnzCVgvM1B989bZzBMYBWYhSc1C
        klrAyLSKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4ArQ0dzBuX/VB7xAjEwfjIUYJ
        DmYlEV7RtRLJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBK
        NTAd2KBd5mGRdNVlRtD0i3N3Pe3ZvMPjsALbbUsmpmsPU1wdYr++c1FnsI9/fGHpjadN5ks3
        HrB+23JFS6HArnWH2v3Evomda6S/WWqaekikym4/MyHdOlX+/rFFeufflenHzHvFkWP2Tkpk
        V/HEXo35398JFvldCpwz51R1idZJ6dwP5t2tu438PKyEOhMsig34OU9MCN/Ss1n33U3r6d8L
        V/1Ysuk+f1OixPqeJ+nvp2of82DNuvZZwiz+Ufrtpm+MlzLSeKbv3Tb/5y3Z0052f+qZQvnU
        3Ys1VqZLydze/ey84e3pB2a+49kqN21XkCnD/al1H/VOXZw1ZdKynS9i2f9d2qivoJTS5fhF
        d+9pJZbijERDLeai4kQAvxxbh+8CAAA=
X-CMS-MailID: 20220908184538epcas5p378c450bfe07d296a9abc843efe75dfc9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220908184538epcas5p378c450bfe07d296a9abc843efe75dfc9
References: <20220908183511.2253-1-joshi.k@samsung.com>
        <CGME20220908184538epcas5p378c450bfe07d296a9abc843efe75dfc9@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

