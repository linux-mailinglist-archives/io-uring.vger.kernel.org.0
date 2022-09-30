Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BD65F0525
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiI3GpB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiI3Goy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:44:54 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA09411834
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:44:41 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220930064440epoutp030bdb891832d2f799321c5c1db34e27a0~ZkGBCuPHl2850328503epoutp03J
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:44:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220930064440epoutp030bdb891832d2f799321c5c1db34e27a0~ZkGBCuPHl2850328503epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520280;
        bh=cqR0g8fK47YXPZZiJGboAfOg3ijONkyZyl3d/RvlPg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZfkKLXRehJa3sHwe1bRBXG9xELflsBfXx94yjzhLalQfiay/SAh82JMFwsFMFXSK
         iXn4Dk/KbmBUZ2q04XjbGu+KF3DD5lDbCeQNU+8HJhClBADcf/x+ARlFlckvB2C6MB
         A+tG4vBjwDKxz5IT5dQQR9kf3d4wTObRa5PPHkqk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220930064439epcas5p38f7c5aae95dd4174da48e99b858c5329~ZkGAXRrmJ1351713517epcas5p3y;
        Fri, 30 Sep 2022 06:44:39 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Mf11K073Tz4x9Q4; Fri, 30 Sep
        2022 06:44:37 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.BD.39477.25096336; Fri, 30 Sep 2022 15:44:34 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063828epcas5p2bfddb254b0dffde77e99c2acc4440bde~ZkAnH2S_40571405714epcas5p2Q;
        Fri, 30 Sep 2022 06:38:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220930063828epsmtrp27f4756bfbec6a6ce339880f3d5b69fcf~ZkAnG3ouY2225522255epsmtrp2Y;
        Fri, 30 Sep 2022 06:38:28 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-69-633690526e7e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A5.69.14392.4EE86336; Fri, 30 Sep 2022 15:38:28 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063827epsmtip2d2be7b9725dfd98574b953d0f2d94b34~ZkAlvYSsR1763417634epsmtip2L;
        Fri, 30 Sep 2022 06:38:27 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v12 09/12] block: factor out blk_rq_map_bio_alloc
 helper
Date:   Fri, 30 Sep 2022 11:57:46 +0530
Message-Id: <20220930062749.152261-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmum7QBLNkg/179S1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu0X39R1sDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
        aqvk4hOg65aZA3SSkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQv
        XS8vtcTK0MDAyBSoMCE7Y+nDTsaCFQIV21/rNzDO5e1i5OSQEDCRmP7oMWsXIxeHkMBuRom+
        P5OhnE+MEv+3T2SHcL4xSjztu88E0zJt/zFmiMReRonXv65BVX1mlFj/cwojSBWbgLrEkeet
        YLaIgJHE/k8nweYyC2xhlGhet5gdJCEsECyx+H4/K4jNIqAqcX/XO2YQm1fAWmL1r5uMEOvk
        JWZe+g5Uz8HBCRRvXpQDUSIocXLmExYQmxmopHnrbLCLJAR+sktcn/SNFaLXReLP+stsELaw
        xKvjW9ghbCmJz+/2QsXTJX5cfgr1WoFE87F9UHvtJVpP9TOD7GUW0JRYv0sfIiwrMfXUOiaI
        vXwSvb+fQLXySuyYB2MrSbSvnANlS0jsPdcAZXtITP7eDQ3fPkaJK3e+ME1gVJiF5J9ZSP6Z
        hbB6ASPzKkbJ1ILi3PTUYtMCo7zUcngsJ+fnbmIEJ1Mtrx2MDx980DvEyMTBeIhRgoNZSYRX
        vMA0WYg3JbGyKrUoP76oNCe1+BCjKTC8JzJLiSbnA9N5Xkm8oYmlgYmZmZmJpbGZoZI47+IZ
        WslCAumJJanZqakFqUUwfUwcnFINTDlVgU53AuOE7NoWz1HJ9EpZ1ijJ3cf86EL3HvNZrnOe
        3VCcebDMJmG7qVh0c7trv8PWW733/O5et9hVqBhxPups7bbrkreEYwr783smz/Q1n8Hzw+Vs
        +xN2g48CM5fPnrF519EtSx64iMUYPLC+tfnLTN8SkY7UsrW714ToLVHWFO2IWSX89ImCpcqu
        M+pd/Wc0y3Ka/7W/DDDp7F1RkKSzONki4NPWbXapZ4VvHDJqOaWuHHW8+avRJObr7b+P2D8Q
        sJJgub57ntyFO5vYFuW92dA5OTT5fbq66o5b7Kxrd726/ifiwHUmJ06O2f+SPh8WWnSlz3vh
        25+Sirt7bn9sX+02fV/x9YVr736uslBiKc5INNRiLipOBABo6BOYLwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSvO6TPrNkgxlnjS1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu0X39R1sDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJWx9GEnY8EKgYrtr/UbGOfydjFyckgImEhM
        23+MuYuRi0NIYDejxP01O9khEhISp14uY4SwhSVW/nvODlH0kVHiS+M3VpAEm4C6xJHnrWBF
        IgJmEksPr2EBKWIW2MUoMXfrN2aQhLBAoMT144fBilgEVCXu73oHFucVsJZY/esm1AZ5iZmX
        vgNt4ODgBIo3L8oBCQsJWEl83vOeHaJcUOLkzCcsIDYzUHnz1tnMExgFZiFJzUKSWsDItIpR
        MrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzjYtTR3MG5f9UHvECMTB+MhRgkOZiURXvEC
        02Qh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamJZ/dhI/
        pnujY6/b46wwn5g4+5Y7OwKX874OEa962nDiWWFz0sHSrdn/i7Lf3qpT+894XqtQ7EKfdMeT
        HzsCNjYu/G3+5nCMMmew6mG1Hq93PvmB7zKkVxmcrjgiteTN1pPzV3kVFn20PrHbZq9C5PQ2
        1opTM5cpud27fNopwG9P9JQ23Y66rM8SKzzmMk5zdOFhuHN04dy6hPM3OIVvswrLCXVaau9+
        dsKmX+xRnOm0n655sn8ula5bvktvWVL/+arr5s2znR7OmmnC5FMUfGAl54TTuurWMhUiody5
        q5W9JdSCXG/4cm489X95zvUXrNdXvVSoqDS9PcHgwCWny48SVv5ovfeiR195A0u9iRJLcUai
        oRZzUXEiAMlnOMLlAgAA
X-CMS-MailID: 20220930063828epcas5p2bfddb254b0dffde77e99c2acc4440bde
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063828epcas5p2bfddb254b0dffde77e99c2acc4440bde
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063828epcas5p2bfddb254b0dffde77e99c2acc4440bde@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
index 84b13a4158b7..d6ea377394a9 100644
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

