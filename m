Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74505EF531
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiI2MV5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbiI2MVo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:21:44 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BB2149D23
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:21:42 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220929122140epoutp0401aab60481b1d6b0a8cdd6cba8532f23~ZVC_efN2H0937409374epoutp04Z
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:21:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220929122140epoutp0401aab60481b1d6b0a8cdd6cba8532f23~ZVC_efN2H0937409374epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454100;
        bh=dVPpGsZIImAW+BdashB8ATM4WSqR1Zww/QHHIFBBUjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQ99Bxy7pQnEBHT3Y1N+cqK//HevLlFYEwVxWsSUr+Qjz3P5xk80krqCyPovrq5RV
         rC3UcvUDkI0rhbIX+TrTOo24PRVH8/X0OauXeqTeNXx77jbo8/JDEomMiWpBKT6H29
         ho12+A0dXoGK30rGAEt8Cdh+wsi2PspsTDaI7i08=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220929122140epcas5p3ec76a5862d7faed98da3d6dfedf11cb8~ZVC98H_gP2720827208epcas5p3Z;
        Thu, 29 Sep 2022 12:21:40 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MdXXf2tCQz4x9Px; Thu, 29 Sep
        2022 12:21:38 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F7.B2.26992.2DD85336; Thu, 29 Sep 2022 21:21:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220929121640epcas5p400a71aa51f374f016e2143d0228879bc~ZU_nLF2mP3132331323epcas5p4Y;
        Thu, 29 Sep 2022 12:16:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220929121640epsmtrp165631add7717ec14317e5cef9a082c98~ZU_nKXg2H1820918209epsmtrp1R;
        Thu, 29 Sep 2022 12:16:40 +0000 (GMT)
X-AuditID: b6c32a49-0c7ff70000016970-a0-63358dd2ea2a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C2.43.14392.8AC85336; Thu, 29 Sep 2022 21:16:40 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121639epsmtip1adae630e3d96567c44ab37114f666959~ZU_lzWpes3028630286epsmtip14;
        Thu, 29 Sep 2022 12:16:39 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v11 03/13] nvme: refactor nvme_add_user_metadata
Date:   Thu, 29 Sep 2022 17:36:22 +0530
Message-Id: <20220929120632.64749-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmuu6lXtNkgzevhCxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu0X39R1sDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
        aqvk4hOg65aZA3SSkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQv
        XS8vtcTK0MDAyBSoMCE7Y8OdtSwF00Uq/l2ZwtrAOEugi5GTQ0LARGLithmsXYxcHEICuxkl
        1nz7zAjhfGKU2PCqjw3C+cYocfXPO6YuRg6wlguXcyDiexklXrxeywThfGaUWHllGhvIXDYB
        dYkjz1sZQWwRASOJ/Z9Ogu1gFtjCKNG8bjE7SEJYwFPiwYddYA0sAqoS8x99ZgWxeQUsJWZ9
        +cYOcaC8xMxL38FsTgEricXX5kDVCEqcnPmEBcRmBqpp3jqbGWSBhMBfdollb56zQTS7SDRv
        vA01SFji1fEtULaUxMv+Nig7XeLH5adMEHaBRPOxfYwQtr1E66l+ZpCXmQU0Jdbv0ocIy0pM
        PbWOCWIvn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvPNUDZHhLbTn5ihoRWL6PElUf32SYwKsxC
        8s8sJP/MQli9gJF5FaNkakFxbnpqsWmBYV5qOTyak/NzNzGC06mW5w7Guw8+6B1iZOJgPMQo
        wcGsJMIrXmCaLMSbklhZlVqUH19UmpNafIjRFBjgE5mlRJPzgQk9ryTe0MTSwMTMzMzE0tjM
        UEmcd/EMrWQhgfTEktTs1NSC1CKYPiYOTqkGJmXGyNlrne7LVYXt0PX5t36K17SM6/eUS+0d
        9t4Rvh42Za14VOGrzo6neQt2ckbfCrF7kcg2g0PqwcfPebdiIk5k8EVX7BTTjbm6wenPTKG1
        ryT++vvNi0spUv+qL9Zjz3zmWm7H0yOHNdw0/F4Utvdqmhz3b/x1f5ZubeW767d0zloskIvq
        npP29vyO73MPTT7G6/Zh07PDhdIvcnqCfYS3HKr8Ztd+T38mQ1f3nBwtkyp7gyCFL69XHpO/
        qMXK1r/HpvUGZ/ri/xu+ZkpvcODSXZmgKiO+aurfdDe7vElzE9eYaXI+bzPen98RzBf0KePx
        mU/vDefoB04/f/773cWqU6ZKhRT/z+0/Xsi+UomlOCPRUIu5qDgRAMfNWUEwBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnO6KHtNkg8Uz9CxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpu0X39R1sDpwel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJWx4c5aloLpIhX/rkxhbWCcJdDFyMEhIWAi
        ceFyThcjF4eQwG5Giaevr7J3MXICxSUkTr1cxghhC0us/PecHaLoI6PEyufT2UASbALqEkee
        t4IViQiYSSw9vIYFpIhZYBejxNyt35hBEsICnhIPPuwCa2ARUJWY/+gzK4jNK2ApMevLN6ht
        8hIzL30HszkFrCQWX5vDCnKdEFDN9psKEOWCEidnPmEBsZmBypu3zmaewCgwC0lqFpLUAkam
        VYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwcGupbmDcfuqD3qHGJk4GA8xSnAwK4nw
        iheYJgvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAVL6h
        /d++7utpTWeENW/KPjtrJXVTd85BE5Wz96aHuP/aGRopHrRUZMdRjZLHh5klTYz9DkklcefF
        T9I+uNjtbHLvtYzMs5MkpBR03zzh5csITvOS+BS8i6u5Qdx/4p7VAu8al2rFy8bc/avhO7Xm
        Wt9Gvf85WSWbvgmyzr+yJLHYNyufb+fsI0YzVyx4xTK1v3bjxNqTjx9bzmHc9SP42JQb5nLq
        Mk94V56KncquINLI0Hvize8ndZPf7u2z1vqbZNKok/rdNqP/3ZXLPxcESpTM3vLUUGSFA7/M
        N8XQlK2GC69Hb3aofX5T6NSfyVc/H/6q3CTsdDhk7lQvy71ph5z2qq3J3tKpl+jzY9qiWiWW
        4oxEQy3mouJEAM/6FhPlAgAA
X-CMS-MailID: 20220929121640epcas5p400a71aa51f374f016e2143d0228879bc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121640epcas5p400a71aa51f374f016e2143d0228879bc
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121640epcas5p400a71aa51f374f016e2143d0228879bc@epcas5p4.samsung.com>
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

Pass struct request rather than bio. It helps to kill a parameter, and
some processing clean-up too.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/ioctl.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 914b142b6f2b..749f588a1228 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -20,19 +20,20 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
 
-static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
-		unsigned len, u32 seed, bool write)
+static void *nvme_add_user_metadata(struct request *req, void __user *ubuf,
+		unsigned len, u32 seed)
 {
 	struct bio_integrity_payload *bip;
 	int ret = -ENOMEM;
 	void *buf;
+	struct bio *bio = req->bio;
 
 	buf = kmalloc(len, GFP_KERNEL);
 	if (!buf)
 		goto out;
 
 	ret = -EFAULT;
-	if (write && copy_from_user(buf, ubuf, len))
+	if ((req_op(req) == REQ_OP_DRV_OUT) && copy_from_user(buf, ubuf, len))
 		goto out_free_meta;
 
 	bip = bio_integrity_alloc(bio, GFP_KERNEL, 1);
@@ -45,9 +46,13 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	bip->bip_iter.bi_sector = seed;
 	ret = bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf));
-	if (ret == len)
-		return buf;
-	ret = -ENOMEM;
+	if (ret != len) {
+		ret = -ENOMEM;
+		goto out_free_meta;
+	}
+
+	req->cmd_flags |= REQ_INTEGRITY;
+	return buf;
 out_free_meta:
 	kfree(buf);
 out:
@@ -70,7 +75,6 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 		u32 meta_seed, void **metap, unsigned timeout, bool vec,
 		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
 {
-	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
 	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
 	struct request *req;
@@ -110,13 +114,12 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 		if (bdev)
 			bio_set_dev(bio, bdev);
 		if (bdev && meta_buffer && meta_len) {
-			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
-					meta_seed, write);
+			meta = nvme_add_user_metadata(req, meta_buffer,
+					meta_len, meta_seed);
 			if (IS_ERR(meta)) {
 				ret = PTR_ERR(meta);
 				goto out_unmap;
 			}
-			req->cmd_flags |= REQ_INTEGRITY;
 			*metap = meta;
 		}
 	}
-- 
2.25.1

