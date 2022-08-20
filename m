Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B80759AAE8
	for <lists+io-uring@lfdr.de>; Sat, 20 Aug 2022 05:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243946AbiHTDRS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 23:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243929AbiHTDRR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 23:17:17 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C034EA316
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 20:17:16 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220820031714epoutp03197ab70ab3358876e71403f17aaef4f9~M70M0K7HV0169201692epoutp03F
        for <io-uring@vger.kernel.org>; Sat, 20 Aug 2022 03:17:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220820031714epoutp03197ab70ab3358876e71403f17aaef4f9~M70M0K7HV0169201692epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660965434;
        bh=6iGMkVK1xSEOYwHrLOYXH/9ooSN1GQOnQK/XN3hdvq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhD5rrRE2hf7vsa4QRswyWcqJnX/B/isJJX82popVr6dcH8MgalQkNfp2xUb6DlBP
         CFg7WV9IlE3S4VuvfI9PCSMgxTtHMWcM04XqM6p56aO7BXJYh61HM4zly2+UqHkbE5
         VkWbxnQRlV1qxpaW9dl1JpMHk9fdzrrBYEW3KcRw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220820031713epcas5p17a13807e9e25948bba6a6d3ec3cf2196~M70LyC86i2055520555epcas5p1f;
        Sat, 20 Aug 2022 03:17:13 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4M8kLv0wRyz4x9Pr; Sat, 20 Aug
        2022 03:17:11 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.88.49150.63250036; Sat, 20 Aug 2022 12:17:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220820031710epcas5p1b1fd2492ace82c421ec32ce0af5b4086~M70I9Vfw80245702457epcas5p1B;
        Sat, 20 Aug 2022 03:17:10 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220820031710epsmtrp2d8aa3af5d9642df38e4a0291399052dd~M70I7r0R10249702497epsmtrp2P;
        Sat, 20 Aug 2022 03:17:10 +0000 (GMT)
X-AuditID: b6c32a4b-37dff7000000bffe-3e-630052361d24
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.39.08905.63250036; Sat, 20 Aug 2022 12:17:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220820031708epsmtip1c130080dbf69c4f6784c0556f5daa7c4~M70Hc67X41949119491epsmtip1Y;
        Sat, 20 Aug 2022 03:17:08 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v2 3/4] block: add helper to map bvec iterator for
 passthrough
Date:   Sat, 20 Aug 2022 08:36:19 +0530
Message-Id: <20220820030620.59003-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220820030620.59003-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmlq55EEOywcF2RoumCX+ZLVbf7Wez
        uHlgJ5PFytVHmSzetZ5jsTj6/y2bxaRD1xgt9t7Stpi/7Cm7xaHJzUwOXB6Xz5Z6bFrVyeax
        eUm9x+6bDWwe7/ddZfPo27KK0ePzJrkA9qhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
        XUNLC3MlhbzE3FRbJRefAF23zByg45QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5
        BSYFesWJucWleel6eaklVoYGBkamQIUJ2Rnzjt5kLlguWXHyxw/mBsY+kS5GTg4JAROJ83M7
        WLsYuTiEBHYzSnyb/5QZwvnEKLFy33omCOcbo0Tz2wtAZRxgLaf/5kLE9zJKtC64ygQySkjg
        M6PEscNCIDVsApoSFyaXgoRFBIwk9n86CbaBWeACo8S9nTdZQBLCApESrz63gtksAqoS6/9u
        YgHp5RWwkHg3KQTiOnmJmZe+s4PYnAKWEk3LfzOC2LwCghInZz4Ba2UGqmneOhvsaAmBiRwS
        D+5PYIJodpGY1tXOCGELS7w6voUdwpaS+PxuLxuEnSxxaeY5qPoSicd7DkLZ9hKtp/qZQe5h
        Bvpl/S59iF18Er2/nzBBgoFXoqNNCKJaUeLepKesELa4xMMZS6BsD4nvVw6zQ4Kqh1Fi+oLN
        bBMY5WcheWEWkhdmIWxbwMi8ilEytaA4Nz212LTAOC+1HB6tyfm5mxjBKVTLewfjowcf9A4x
        MnEwHmKU4GBWEuG9cedPkhBvSmJlVWpRfnxRaU5q8SFGU2AQT2SWEk3OBybxvJJ4QxNLAxMz
        MzMTS2MzQyVxXq+rm5KEBNITS1KzU1MLUotg+pg4OKUamKL4pOcuf3cxnLVx3vV8HdFgPs7Z
        2c+bry+O57aQXaeWZbTr/gSJvo6Z6V8DmGUXR3WrKz01WuFtVtGQwcUrJN+67svMT5uq7PQP
        V+/Zq557yl63mVfDd5od53KnfZz1z3msCq2dHrnnCa+fKlrpFWAVm/ekN37Xe6VDnC5XvAOT
        2qKvF7PsUdl7b9aHG94WEU+znlhvsHGTO3PStFthy1Yj/YuFs6vObnnsMn/inyOy8iIbk7Os
        601tF+3Lqk1hT9INdFzoFMDsxq4ZM237KXfWluaPHy5q5hX9ZTJ3+iA4mVt86fqshpNfY8R5
        EwS5+KbPk+x8bBuhMC09JSniYa3635Rk4Yln72/xtFFiKc5INNRiLipOBAC8Ft7XKgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWy7bCSnK5ZEEOywfytPBZNE/4yW6y+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i0OTm5kcuDwuny312LSqk81j
        85J6j903G9g83u+7yubRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGfOO3mQuWC5ZcfLHD+YG
        xj6RLkYODgkBE4nTf3O7GDk5hAR2M0rMWScDYksIiEs0X/vBDmELS6z89xzI5gKq+cgocfHt
        PSaQXjYBTYkLk0tBakQEzCSWHl7DAlLDLHCDUWJf7xQmkISwQLjEjk17GEFsFgFVifV/N7GA
        9PIKWEi8mxQCMV9eYual72C7OAUsJZqW/2aEuMdC4vnsF2wgNq+AoMTJmU9YQGxmoPrmrbOZ
        JzAKzEKSmoUktYCRaRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnDwa2nuYNy+6oPe
        IUYmDsZDjBIczEoivDfu/EkS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6Yklqdmpq
        QWoRTJaJg1OqgUn/rtzT6wVhHvfDSt+VJyuWnT4XFS5xU2nfvR9nZ/49bx+/wN/1f+1f7VUX
        Zv5ln9ubpbGmYu7BVt5b7xx1V05c0fdwvyz/5R9qP0U5Zku+/Lxz7/KDDAv3bW3zm3h5fvCl
        gB4vUzbXNBalp3xRBtavpTMeFp06nDVh1f5Vxa/5fLh/Jsid6rM3mJ2seHiK1XtjqwlLizoZ
        LD/eK9LbsXa+/vqmWbzLLu+Qv3jDYcetgxqc/N2Sx2dYHiyqnS65P1orgj1vTny/6sk5Mz7a
        L+t0dvbUa956mmfettX7fKcWvVDuNuFp9flk/sJRy/rTfLmFgV8P+P/1fXFhxqlOHltpBmW/
        xvyUYPumS6e1068rsRRnJBpqMRcVJwIA3KR6G+0CAAA=
X-CMS-MailID: 20220820031710epcas5p1b1fd2492ace82c421ec32ce0af5b4086
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220820031710epcas5p1b1fd2492ace82c421ec32ce0af5b4086
References: <20220820030620.59003-1-joshi.k@samsung.com>
        <CGME20220820031710epcas5p1b1fd2492ace82c421ec32ce0af5b4086@epcas5p1.samsung.com>
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
places that into the request.
This helper is to be used in nvme for uring-passthrough with
fixed-buffer.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-map.c        | 71 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  1 +
 2 files changed, 72 insertions(+)

diff --git a/block/blk-map.c b/block/blk-map.c
index d0ff80a9902e..ee17cc78bf00 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -611,6 +611,77 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
+/* Prepare bio for passthrough IO given an existing bvec iter */
+int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter)
+{
+	struct request_queue *q = rq->q;
+	size_t iter_count, nr_segs;
+	struct bio *bio;
+	struct bio_vec *bv, *bvec_arr, *bvprvp = NULL;
+	struct queue_limits *lim = &q->limits;
+	unsigned int nsegs = 0, bytes = 0;
+	int ret, i;
+
+	iter_count = iov_iter_count(iter);
+	nr_segs = iter->nr_segs;
+
+	if (!iter_count || (iter_count >> 9) > queue_max_hw_sectors(q))
+		return -EINVAL;
+	if (nr_segs > queue_max_segments(q))
+		return -EINVAL;
+	if (rq->cmd_flags & REQ_POLLED) {
+		blk_opf_t opf = rq->cmd_flags | REQ_ALLOC_CACHE;
+
+		/* no iovecs to alloc, as we already have a BVEC iterator */
+		bio = bio_alloc_bioset(NULL, 0, opf, GFP_KERNEL,
+					&fs_bio_set);
+		if (!bio)
+			return -ENOMEM;
+	} else {
+		bio = bio_kmalloc(0, GFP_KERNEL);
+		if (!bio)
+			return -ENOMEM;
+		bio_init(bio, NULL, bio->bi_inline_vecs, 0, req_op(rq));
+	}
+	bio_iov_bvec_set(bio, iter);
+	blk_rq_bio_prep(rq, bio, nr_segs);
+
+	/* loop to perform a bunch of sanity checks */
+	bvec_arr = (struct bio_vec *)iter->bvec;
+	for (i = 0; i < nr_segs; i++) {
+		bv = &bvec_arr[i];
+		/*
+		 * If the queue doesn't support SG gaps and adding this
+		 * offset would create a gap, disallow it.
+		 */
+		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset)) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+
+		/* check full condition */
+		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+
+		if (bytes + bv->bv_len <= iter_count &&
+				bv->bv_offset + bv->bv_len <= PAGE_SIZE) {
+			nsegs++;
+			bytes += bv->bv_len;
+		} else {
+			ret = -EINVAL;
+			goto out_free;
+		}
+		bvprvp = bv;
+	}
+	return 0;
+out_free:
+	bio_map_put(bio);
+	return ret;
+}
+EXPORT_SYMBOL(blk_rq_map_user_bvec);
+
 /**
  * blk_rq_unmap_user - unmap a request with user data
  * @bio:	       start of bio list
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 9d1af7a0a401..890c342ab3f3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -971,6 +971,7 @@ struct rq_map_data {
 	bool from_user;
 };
 
+int blk_rq_map_user_bvec(struct request *rq, struct iov_iter *iter);
 int blk_rq_map_user(struct request_queue *, struct request *,
 		struct rq_map_data *, void __user *, unsigned long, gfp_t);
 int blk_rq_map_user_iov(struct request_queue *, struct request *,
-- 
2.25.1

