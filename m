Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9875EF542
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbiI2MWz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiI2MWp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:22:45 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7139E149D2F
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:22:43 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220929122241epoutp04649850cc0134a33c73847e6989acf8db~ZVD3UtH_g0840708407epoutp04D
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:22:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220929122241epoutp04649850cc0134a33c73847e6989acf8db~ZVD3UtH_g0840708407epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454161;
        bh=W5zR9Q+5gEEdrOHdojR8p3L+nHGhst0iy432lBKcQAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VooxnQpCdcSF2a5T/V1MWz538dRERHsdFG8XkwfweHnQRv9+58x1SgpWqiDtHNnP4
         +pHwVHSjV2p5YcgblhRnk0XH7KIxfZmkjmU6pOHb3PvqnlNcKJUS4n9Ma/aGcRJqAp
         nS2pT3R+Lnu+q+Q3PO3w1uCERNOcup+s8JjS+jUY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220929122241epcas5p40b1b249b6595fc7d3b7686a82565f7a2~ZVD2olSB01885818858epcas5p45;
        Thu, 29 Sep 2022 12:22:41 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MdXYp35QCz4x9Pr; Thu, 29 Sep
        2022 12:22:38 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.68.39477.E0E85336; Thu, 29 Sep 2022 21:22:38 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220929121650epcas5p424925af86ec6941bb53e5c102fd0ffc8~ZU_vrtSGV2903829038epcas5p44;
        Thu, 29 Sep 2022 12:16:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929121650epsmtrp2f9ab656e80b5b3d92c29a895c1679244~ZU_vq_UDM1811218112epsmtrp2F;
        Thu, 29 Sep 2022 12:16:50 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-d7-63358e0ecd41
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.3C.18644.1BC85336; Thu, 29 Sep 2022 21:16:49 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121648epsmtip1869c87726d43726a5bd74fb439227216~ZU_uT09Kl2848328483epsmtip1Z;
        Thu, 29 Sep 2022 12:16:48 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v11 06/13] block: factor out blk_rq_map_bio_alloc
 helper
Date:   Thu, 29 Sep 2022 17:36:25 +0530
Message-Id: <20220929120632.64749-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmpi5fn2mywfw7ohar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
        tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqX
        rpeXWmJlaGBgZApUmJCdsWx1K3vBCoGKO6tnszUwzuXtYuTkkBAwkdj2tou1i5GLQ0hgN6PE
        rf99jBDOJ0aJ+WevMUE4nxklHnyaClTGAdbyY6MLSLeQwC5GiV9f1eBqtmxfzgqSYBNQlzjy
        vJURxBYRMJLY/+kk2ApmgS2MEs3rFrODJIQFgiUOd+xjAbFZBFQlpq++ygZi8wpYSizYM5EN
        4j55iZmXvoPVcwpYSSy+NocVokZQ4uTMJ2C9zEA1zVtnM4MskBD4yy6x5ekrFohmF4klbz6z
        QtjCEq+Ob2GHsKUkPr/bC7UgXeLH5adMEHaBRPOxfYwQtr1E66l+ZpCPmQU0Jdbv0ocIy0pM
        PbWOCWIvn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvPNTBBAs5D4t4sXUhg9TJKXH+8hWkCo8Is
        JO/MQvLOLITNCxiZVzFKphYU56anFpsWGOWllsMjOTk/dxMjOJVqee1gfPjgg94hRiYOxkOM
        EhzMSiK84gWmyUK8KYmVValF+fFFpTmpxYcYTYHhPZFZSjQ5H5jM80riDU0sDUzMzMxMLI3N
        DJXEeRfP0EoWEkhPLEnNTk0tSC2C6WPi4JRqYNJiSlq67Py2Ddv1Gj6Xx0e/tuO2Zuf/WaRg
        spOlizkvLchl9ZVDRcmXFSfcfyDMxm5Y7L7JL6PXKO9e2RG+TXftmPew9JzT2lOxdLlcUeJl
        64i7ZtrtDleX7bCfpaHfnqq28+g7vbsVoXI3t18+flNyklvQrMTveQe9PPuO2MvuuReoy63L
        w+E19W7pj6Vnpuzde/eTlN7tY/NS2hW1vY4u/TVV2lTlfuObby6Cn606mM/FSpY8LQ8K/F7m
        3HnLQTIs2Ejx1pOrX/b/srP7xOQZNWXhvEOTt9ou0/y6Y/ad0Jf6HNdnR/+Z2XBkUQqX4OPs
        W5fL5Jp1NLKuXpL4UPRt76q4+3mT0hY1P9mmekuJpTgj0VCLuag4EQD/wuDfLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnO7GHtNkg6OPTS1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu0X39R1sDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJWxbHUre8EKgYo7q2ezNTDO5e1i5OCQEDCR
        +LHRpYuRi0NIYAejxK75P1m7GDmB4hISp14uY4SwhSVW/nvODlH0kVHiztuZ7CAJNgF1iSPP
        W8GKRATMJJYeXsMCUsQssItRYu7Wb8wgCWGBQImjvx+DTWURUJWYvvoqG4jNK2ApsWDPRDaI
        DfISMy99BxvKKWAlsfjaHFaQ64SAarbfVIAoF5Q4OfMJC4jNDFTevHU28wRGgVlIUrOQpBYw
        Mq1ilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAgOdi2tHYx7Vn3QO8TIxMF4iFGCg1lJ
        hFe8wDRZiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqYT
        ijP0Z55j/Puj88rW7s1NTicrOZzCAtY6NNyZNtH9+lbW5UEMUrr6rqfMmbwUfGfrdfP9Oi71
        dIKgdfnB1MNC3kvUTO7cZv+S613vuPBL9RXz8FSb2T2qZy34RXo/NN8tW5wS+nnjZwOlyvKs
        H5L8xuKOHNZv1B/9sf8QPyVGPdHyyEQTaxUrJX895WxV1YwjIvkfb3/bmPjss/7dvx1+/9ZM
        WGnb+J0xJGU1y8Pn5YczZ/2ynXw7bn3+8/7EtSXFav/MQtW7C/J2H17korNB63rB8R38L4sT
        HuxJ0674H+SftPyHSoRMp42LYnjA2tdT9A2zcrsXH6k8ODmpTqYu+tpyO/+ut4cnim/4ocRS
        nJFoqMVcVJwIANeXzsTlAgAA
X-CMS-MailID: 20220929121650epcas5p424925af86ec6941bb53e5c102fd0ffc8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121650epcas5p424925af86ec6941bb53e5c102fd0ffc8
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121650epcas5p424925af86ec6941bb53e5c102fd0ffc8@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

Move bio allocation logic from bio_map_user_iov to a new helper
blk_rq_map_bio_alloc. It is named so because functionality is opposite
of what is done inside blk_mq_map_bio_put. This is a prep patch.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-map.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index d913ef92a9fe..9e37a03b8a21 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -241,17 +241,10 @@ static void blk_mq_map_bio_put(struct bio *bio)
 	}
 }
 
-static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
-		gfp_t gfp_mask)
+static struct bio *blk_rq_map_bio_alloc(struct request *rq,
+		unsigned int nr_vecs, gfp_t gfp_mask)
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
+	bio = blk_rq_map_bio_alloc(rq, nr_vecs, gfp_mask);
+	if (bio == NULL)
+		return -ENOMEM;
 
 	while (iov_iter_count(iter)) {
 		struct page **pages, *stack_pages[UIO_FASTIOV];
-- 
2.25.1

