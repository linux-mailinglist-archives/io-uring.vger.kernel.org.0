Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA3A5ADFEC
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 08:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238527AbiIFGhj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 02:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238532AbiIFGhi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 02:37:38 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF1470E60
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 23:37:36 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220906063735epoutp021efd5e9b3b6682665778a6f5679e0a5c~SMg_X2JR-0973709737epoutp02x
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 06:37:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220906063735epoutp021efd5e9b3b6682665778a6f5679e0a5c~SMg_X2JR-0973709737epoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662446255;
        bh=G67kfqT7ju2Wy37bOXw+s0IVht5UeVvdSkoq3vkdofw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lql+RvN+VdE5u2uB8dbtgBVhHHRVdurTeQHM53bWxRqH72ixLPTNUGvkwyuAofaCP
         L6bNGYQQiIGpZlzLpRodqUHSqmqx5OrIeXJGRsISi9F5qAHWr66v9/RyBeLK8XVoSL
         wRuteXYsJpz5WZ9c7kOV5QbNN1no7c+o3Dp0EQwM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220906063734epcas5p374f2717a219d00fff50e928f644c2725~SMg9k4Mq32989229892epcas5p3S;
        Tue,  6 Sep 2022 06:37:34 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MMG0B6sf1z4x9Pr; Tue,  6 Sep
        2022 06:37:30 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.52.59633.9AAE6136; Tue,  6 Sep 2022 15:37:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9~SMg5IAD8j2227522275epcas5p1V;
        Tue,  6 Sep 2022 06:37:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220906063729epsmtrp247de0d18917e22757c0db90c93905238~SMg5HJfbd1358713587epsmtrp2k;
        Tue,  6 Sep 2022 06:37:29 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-c2-6316eaa9ddb4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.45.14392.9AAE6136; Tue,  6 Sep 2022 15:37:29 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220906063727epsmtip28c5de2a68bdf494c3bc79397d0fb1a28~SMg3n46h12854028540epsmtip21;
        Tue,  6 Sep 2022 06:37:27 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v5 3/4] block: add helper to map bvec iterator for
 passthrough
Date:   Tue,  6 Sep 2022 11:57:20 +0530
Message-Id: <20220906062721.62630-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906062721.62630-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmuu7KV2LJBl9uals0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8ruwOWxc9Zddo/LZ0s9
        Nq3qZPPYvKTeY/fNBjaPvi2rGD0+b5ILYI/KtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
        1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCS
        U2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ0x5w9rwX7limfbm9gbGBfLdDFyckgImEjMXDKT
        pYuRi0NIYDejxIX1q1khnE+MEscerIDKfGOU+H1kBStMy/afsxkhEnsZJa5dX84O4XxmlDj9
        4DJQFQcHm4CmxIXJpSANIgJeEvdvvwcbywyyY/Xft2CThAUiJa6+XcAIYrMIqEr833ONCcTm
        FbCQ6Ny4DWqbvMTMS9/ZQWxOAUuJCSe/sEHUCEqcnPmEBcRmBqpp3jqbGaK+k0Ni2gwzCNtF
        Yt/Hr+wQtrDEq+NboGwpic/v9rJB2MkSl2aeY4KwSyQe7zkIZdtLtJ7qZwb5hRnol/W79CFW
        8Un0/n7CBBKWEOCV6GgTgqhWlLg36SnUxeISD2csgbI9JGYfm8sECZ4eRon9xy6xTWCUn4Xk
        g1lIPpiFsG0BI/MqRsnUguLc9NRi0wLDvNRyeLwm5+duYgQnUS3PHYx3H3zQO8TIxMF4iFGC
        g1lJhDdlh0iyEG9KYmVValF+fFFpTmrxIUZTYBBPZJYSTc4HpvG8knhDE0sDEzMzMxNLYzND
        JXHeKdqMyUIC6YklqdmpqQWpRTB9TBycUg1Mq28t/Rd5auc/N+e2SQJfWM/Mj3Lw/FoomaWz
        /HRW6LJrl77MaC/m1+Et0FfcuSbT+MoB7shlH1XOKmip8Z3Y/P/nvX3H4/i1La67+/9O5r6m
        nRw9wf5BW+oVNpEnrm9Wp1VohrJscxFovTx9VWR3hEfbYr3ri6Iq+G+YzomZfHDzK8294i82
        bDXY1+nZYvboWd/OEp7jnM/2rQw33ssYtEpu4goTv7izk5jPz+i8kPVoiqhczf+C++rTlLfP
        Kwlc2G7PxNh8WDhg0St+P7fwFbGcDapfjumc+3Z518S5T06dSsoIOOsg2tZ+TWeX2qc3T73f
        6z+zXaYaW1XncDb62+3opYXJG6d8i/S58CinXImlOCPRUIu5qDgRAMR8x8krBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWy7bCSvO7KV2LJBu++8lo0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8ruwOWxc9Zddo/LZ0s9
        Nq3qZPPYvKTeY/fNBjaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgypjzh7Vgv3LFs+1N7A2M
        i2W6GDk5JARMJLb/nM3YxcjFISSwm1FixdyfzBAJcYnmaz/YIWxhiZX/noPZQgIfGSXWvLfu
        YuTgYBPQlLgwuRQkLCIQIHGw8TI7yBxmgYOMEuebvrGAJIQFwiUaFzYygtgsAqoS//dcYwKx
        eQUsJDo3bmOFmC8vMfPSd7D5nAKWEhNOfmGD2GUhcWfFXah6QYmTM5+AzWQGqm/eOpt5AqPA
        LCSpWUhSCxiZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBIe/luYOxu2rPugdYmTi
        YDzEKMHBrCTCm7JDJFmINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUw
        WSYOTqkGJnaziMIeDyEl/xnxXmIpxjONvj69MpFR81BqTm1SJPP9hKIDpn4bL9zl2Dh/feTK
        O/IGrzZyqR+Q03nLtdk/7+V6jUQdRa+ATy2hag/MU3KPmFkdn8PsP/OBO9v9WwbfLj6eZuOr
        I55hOYchPW0rv+qB8O5H+yNzeBcVsh35dSB/xt87MQs/GV6esYut5dJsW8cjR77VeF23DU04
        rKq7qd39zt2pLw1vPbzms32Tys9NFwx0bz+xNE+y3MTOnftctLrc6efTGzZH5JeWv4248J/9
        QFRm9cnjAYf+f9+t5f8uolm2KyvoQUhZqErCnsVZVRxbihv/7fx/V78rKjrmRczWe9e3Nqot
        XdJZ0ntyuhJLcUaioRZzUXEiAKmXUSTuAgAA
X-CMS-MailID: 20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9
References: <20220906062721.62630-1-joshi.k@samsung.com>
        <CGME20220906063729epcas5p1bf05e6873de0f7246234380d66c21fb9@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 block/blk-map.c        | 94 +++++++++++++++++++++++++++++++++++++-----
 include/linux/blk-mq.h |  1 +
 2 files changed, 85 insertions(+), 10 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index f3768876d618..e2f268167342 100644
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
@@ -612,6 +623,69 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
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

