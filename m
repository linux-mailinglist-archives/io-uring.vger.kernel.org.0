Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966725EF552
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbiI2MYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiI2MYF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:24:05 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E70D01DE
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:24:03 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220929122401epoutp02ee24216f93a9ed917f4900904796e741~ZVFBiIj6E0891408914epoutp02E
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:24:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220929122401epoutp02ee24216f93a9ed917f4900904796e741~ZVFBiIj6E0891408914epoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454241;
        bh=Ed9XhutZ9yja1KBK7s/NhIde4D4RLW0LgjBzhdzQQuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbeZZLbV7rjhuUgAGZYFSbJUzaZAYr0NDNhFvHdBwqyjjMuBErrQC/nXj4Tz33JDP
         5Qv3DsOK/BmYKSS3hNZw585qqhhsgN/ZnTNq0gOqS53dbL3odVqthA2+YkE3U+njES
         ZtF1f8LaVcvOwRwi/KY+lWnLr2ASnvrIYkl96/rE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220929122400epcas5p39665fba01ab3370f40e476dd3bd9b128~ZVFA43Ipd1893018930epcas5p3K;
        Thu, 29 Sep 2022 12:24:00 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MdXbL71dVz4x9Pv; Thu, 29 Sep
        2022 12:23:58 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.AF.56352.E5E85336; Thu, 29 Sep 2022 21:23:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220929121704epcas5p3415fd4782cbcffa7b1e6ddf774bebb03~ZU_9bhHI91775017750epcas5p3N;
        Thu, 29 Sep 2022 12:17:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929121704epsmtrp205ece237de06921f9d1411640ee76168~ZU_9ZoCzH1811218112epsmtrp2a;
        Thu, 29 Sep 2022 12:17:04 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-61-63358e5e3185
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DA.43.14392.0CC85336; Thu, 29 Sep 2022 21:17:04 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121703epsmtip189c153b1e68dc628dac9008781c8f1ed~ZU_8CDj-x3141831418epsmtip1p;
        Thu, 29 Sep 2022 12:17:03 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v11 10/13] nvme: wire up fixed buffer support for
 nvme passthrough
Date:   Thu, 29 Sep 2022 17:36:29 +0530
Message-Id: <20220929120632.64749-11-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmlm5cn2mywZ7nZhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
        tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqX
        rpeXWmJlaGBgZApUmJCd8e7xDaaCHv6Ks5dXMjcwzuHpYuTkkBAwkeg9eYkJxBYS2M0o8WO7
        UBcjF5D9iVHi5qrbLBDON0aJtctPsXUxcoB19M3ygojvZZTY1rKQCcL5zCjx5cYhRpBRbALq
        Ekeet4LZIgJGEvs/nWQFKWIW2MIo0bxuMTtIQlggVmL5m3VgRSwCqhJv1k9lAdnAK2AlcfKN
        AcR58hIzL30HK+cECi++NocVxOYVEJQ4OfMJC4jNDFTTvHU2M8h8CYFGDok5PbcYIZpdJDZ9
        fMQOYQtLvDq+BcqWkvj8bi8bhJ0u8ePyUyYIu0Ci+dg+qF57idZT/cwg9zALaEqs36UPEZaV
        mHpqHRPEXj6J3t9PoFp5JXbMg7GVJNpXzoGyJST2nmuAsj0kmr71QwOrl1Fi47oDjBMYFWYh
        +WcWkn9mIaxewMi8ilEytaA4Nz212LTAOC+1HB7Jyfm5mxjBqVTLewfjowcf9A4xMnEwHmKU
        4GBWEuEVLzBNFuJNSaysSi3Kjy8qzUktPsRoCgzvicxSosn5wGSeVxJvaGJpYGJmZmZiaWxm
        qCTOu3iGVrKQQHpiSWp2ampBahFMHxMHp1QDU0K5UeOnyQrfM5Q063Y+y/l16o7Cl37mYnvN
        u7N5jvf9l4/rDr3UdInP4nGT6l59cxNOncUzz+++yL3P/PAy/uk7NT8caWfNnsC2/FV8wjyz
        paHvs+Nj1LRNZ7TJBx36+JK3z+w409HbDsH+35duvL5f/3Wq3Pz0jbkf5zQc3MrDvmHKZquz
        P/RdW+9fd7hUWBwW2V82WatrQ+SRx8nzVJwipYWetXc2nn4iubR5qfzEBJEjkrV3p8wRMLio
        lc5TmLP111TuYxM6nOJFBAy0M89+EAptvbZ0+YmdCtlsCuKOr3t8/HiuO0vaH9tt8UPK2vHf
        m5QtP/pXvlp0YEmTQZiaGqvO302caW8O8i4xUGIpzkg01GIuKk4EAN2kFjkuBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnO6BHtNkg1t9ahar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3aL7+g42B06Py2dLPTat6mTz2Lyk3mP3
        zQY2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mp49/gGU0EPf8XZyyuZGxjn8HQxcnBICJhI
        9M3y6mLk4hAS2M0osejLC9YuRk6guITEqZfLGCFsYYmV/56zQxR9ZJS4cvQSC0iCTUBd4sjz
        VrAiEQEziaWH17CAFDEL7GKUmLv1GzNIQlggWmJbzy8mEJtFQFXizfqpLCCbeQWsJE6+MYBY
        IC8x89J3dhCbEyi8+NocVpASIQFLie03FUDCvAKCEidnPgFbywxU3rx1NvMERoFZSFKzkKQW
        MDKtYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIDnUtzR2M21d90DvEyMTBeIhRgoNZ
        SYRXvMA0WYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQam
        tvIH5ZqnZJP1NE83fefcYqAUHr9l86m005Ed7p/bgnducbBbsTL709XJ7NsmL7a8q1Lcu9Fi
        +2LBe/k/97blOV16HPvK3qh/Um/EFLlK93cK0q/ef7PLeZFQ1GsX+OqC0m9fc/tTifobc95E
        WHyY8WyxWODp3hjJqrs1dX+uPYh9Hv309v+/Mj6zZnWKfM3tUHf8MUngZMQM89JXfMFx20Mi
        V/VLT/bNOCcZofmgI2TKiT/qXUlvp/X4PZ915ZfLtPiVrV6Nj6q6k7ltJ7g4Xt3+Y2fYFVFm
        Z75+NYZpnqpuMms/9/X1ql9j4mav8rdMPbc7QtYsh/v3gpDW5nNPJnEZVq05OyPZsT5YZoUS
        S3FGoqEWc1FxIgBJBL7I5AIAAA==
X-CMS-MailID: 20220929121704epcas5p3415fd4782cbcffa7b1e6ddf774bebb03
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121704epcas5p3415fd4782cbcffa7b1e6ddf774bebb03
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121704epcas5p3415fd4782cbcffa7b1e6ddf774bebb03@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

if io_uring sends passthrough command with IORING_URING_CMD_FIXED flag,
use the pre-registered buffer for IO (non-vectored variant). Pass the
buffer/length to io_uring and get the bvec iterator for the range. Next,
pass this bvec to block-layer and obtain a bio/request for subsequent
processing.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/ioctl.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 4a7e45a263b6..25a68e8c60db 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -95,21 +95,31 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	void *meta = NULL;
 	int ret;
 
-	if (!vec)
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-			GFP_KERNEL);
-	else {
+	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
+		struct iov_iter iter;
+
+		/* fixedbufs is only for non-vectored io */
+		if (WARN_ON_ONCE(vec))
+			return -EINVAL;
+		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
+				rq_data_dir(req), &iter, ioucmd);
+		if (ret < 0)
+			goto out;
+		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
+	} else if (vec) {
 		struct iovec fast_iov[UIO_FASTIOV];
 		struct iovec *iov = fast_iov;
 		struct iov_iter iter;
 
-		ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
-				UIO_FASTIOV, &iov, &iter);
+		ret = import_iovec(rq_data_dir(req), nvme_to_user_ptr(ubuffer),
+				bufflen, UIO_FASTIOV, &iov, &iter);
 		if (ret < 0)
 			goto out;
-
 		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
 		kfree(iov);
+	} else {
+		ret = blk_rq_map_user(q, req, NULL,
+				nvme_to_user_ptr(ubuffer), bufflen, GFP_KERNEL);
 	}
 	if (ret)
 		goto out;
-- 
2.25.1

