Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3545ECB94
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 19:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbiI0Rtc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 13:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbiI0RtC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 13:49:02 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E962315E469
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 10:46:41 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220927174640epoutp02734259e8ac1bcce3a17a88b717d2c3cf~YyMKbNKh_2537825378epoutp02b
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 17:46:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220927174640epoutp02734259e8ac1bcce3a17a88b717d2c3cf~YyMKbNKh_2537825378epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664300800;
        bh=xEHA1PhpFtWG0bamSbFFyJGRJOLAAuhGzUa6LLwM4SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjKE6AjJubZKg+j+63mSjkxyKa9dpSLPTsOQx2XQJlQ3prTbVZTtN1ut3TNQehWJn
         HXsnY5nn/HZ8YM6NEbMefbz8mLFxe2aMUEyfp9s66S7SF4v3szaRvv6dLsPlgaEtxo
         Tv3ZmSoZvfMPEz79qPqWDZnzjAyk7WZG+H3MqRRA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220927174639epcas5p2d94a2597aa407e700a65c11c5b9b6c46~YyMJ29C0r2853728537epcas5p2O;
        Tue, 27 Sep 2022 17:46:39 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4McRrY1wy7z4x9Pt; Tue, 27 Sep
        2022 17:46:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.79.56352.DF633336; Wed, 28 Sep 2022 02:46:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220927174636epcas5p49008baa36dcbf2f61c25ba89c4707c0c~YyMG0XIEE2946929469epcas5p4D;
        Tue, 27 Sep 2022 17:46:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220927174636epsmtrp2d16573a4fe29b03e73e94de28c4adeb3~YyMGzsgzj3251332513epsmtrp2i;
        Tue, 27 Sep 2022 17:46:36 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-cf-633336fdf2f9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5A.1D.14392.CF633336; Wed, 28 Sep 2022 02:46:36 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220927174635epsmtip1d56f5406bd01b5799d6d248bf9d2a2a2~YyMFajd1t0699506995epsmtip1k;
        Tue, 27 Sep 2022 17:46:34 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v10 5/7] block: factor out bio_map_get helper
Date:   Tue, 27 Sep 2022 23:06:08 +0530
Message-Id: <20220927173610.7794-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927173610.7794-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42LZdlhTU/evmXGyQd9CDovVd/vZLG4e2Mlk
        sXL1USaLd63nWCyO/n/LZjHp0DVGi723tC3mL3vK7sDhcflsqcemVZ1sHpuX1HvsvtnA5tG3
        ZRWjx+dNcgFsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
        um6ZOUDXKCmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkus
        DA0MjEyBChOyMw71JxTs4a+Y0XOSuYFxD08XIyeHhICJRPOmp6xdjFwcQgK7GSWur1zPBOF8
        YpQ4fnIVO4TzjVFi+9NXjDAt0579YoNI7GWU+LYLJAHifGaU2HVjHpDDwcEmoClxYXIpSIOI
        gJHE/k8nwXYwC8xglFjd8ZodJCEs4Cax7OpEVhCbRUBVoqn7FVicV8BcYs/0k2wQ2+QlZl76
        zg4yk1PAQuLwx0yIEkGJkzOfsIDYzEAlzVtnM4PMlxD4yi5xbv5RVoheF4mj574zQdjCEq+O
        b2GHsKUkPr/bCzU/WeLSzHNQNSUSj/cchLLtJVpP9TOD7GUG+mX9Ln2IXXwSvb+fMIGEJQR4
        JTrahCCqFSXuTXoKtVVc4uGMJVC2h8S8l5uhYdXNKDFt+lzWCYzys5C8MAvJC7MQti1gZF7F
        KJlaUJybnlpsWmCcl1oOj9fk/NxNjOA0qeW9g/HRgw96hxiZOBgPMUpwMCuJ8P4+apgsxJuS
        WFmVWpQfX1Sak1p8iNEUGMQTmaVEk/OBiTqvJN7QxNLAxMzMzMTS2MxQSZx38QytZCGB9MSS
        1OzU1ILUIpg+Jg5OqQYmr/K+v3OmiXROirORqj1ZfPiA4OxX0nxP2pUr7+eXzYo9J8qr9Nk5
        16eyvyZ+ekLrKeuMKyaChy6+9eb6afalWlu7okm0XZux+fsWM84Jpjf6zqj6PPk2k4en7+tm
        iZszugPOu55nfqU779We5svZrHsnmiUcXHFU++OUByplyxQ57jB7yYrZrb2SmLTo9Obp8mHW
        kd3ul///bHQxM72zX9bCXJ93271wn6kizn+9QyaprZp/XTCk7f6DU2/nL2Pa9pIpvbtpHovm
        sfRHlR2qiXlf5ORbmM7LVwquTqlrYvVinZNfeERv0b4Jp145ZTnaLTklqHz2lvgKySd3zl/q
        zX1jvWNPyt7k7RERye5KLMUZiYZazEXFiQBa+LN/HAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSnO4fM+Nkg1nz5SxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBlHOpPKNjDXzGj5yRzA+Meni5GTg4JAROJac9+sXUx
        cnEICexmlHhwcw4zREJcovnaD3YIW1hi5b/nYLaQwEdGidMnOboYOTjYBDQlLkwuBQmLCJhJ
        LD28hgVkDrPAHEaJy5f3gNULC7hJLLs6kRXEZhFQlWjqfgUW5xUwl9gz/SQbxHx5iZmXvrOD
        zOQUsJA4/DETYpW5xNZNH1ggygUlTs58AmYzA5U3b53NPIFRYBaS1CwkqQWMTKsYJVMLinPT
        c4sNCwzzUsv1ihNzi0vz0vWS83M3MYLDW0tzB+P2VR/0DjEycTAeYpTgYFYS4f191DBZiDcl
        sbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqY+rvoPX2YYh88V
        17n/4L/Wg/yVs+uYp+09oi70ZofR5jcNvhnX3m2xZOk+++ZJa51z6aOibxklx+/6v9Su2FB6
        WswuyUFsp+xaDfUnjnY68zP2vzDqKytJnbJA8l3Xycnh7Ft/vOsvX256vPol+/1g1ULhxdY5
        gt+Dq0pe7YlYIKxzyur1R4s2ljW/bd6vnyMf+bTu1odKP+O4v+paxwxq+Gy/xHzLtPmSZiW+
        /Oa/cwXL9z1K7K+fd9lh39oXq3L2TE3SWb5vyZ+l8idU70y9usn96rcXSeX71NsbmeTb5k11
        EVlxVvvb2d6LvvxLg0JnXu+sDnyg3sXtmLojJ2j9pP6MS/ck90ZOUfNdbH9eiaU4I9FQi7mo
        OBEAQSjLqN4CAAA=
X-CMS-MailID: 20220927174636epcas5p49008baa36dcbf2f61c25ba89c4707c0c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174636epcas5p49008baa36dcbf2f61c25ba89c4707c0c
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174636epcas5p49008baa36dcbf2f61c25ba89c4707c0c@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move bio allocation logic from bio_map_user_iov to a new helper
bio_map_get. It is named so because functionality is opposite of what is
done inside bio_map_put. This is a prep patch.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-map.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 7693f8e3c454..a7838879e28e 100644
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
-- 
2.25.1

