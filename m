Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE61751B7D2
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 08:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242019AbiEEGR4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 02:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiEEGRz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 02:17:55 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E97946658
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 23:14:16 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220505061414epoutp0356d9b66b2a8d11a5dd31683c3ac76a37~sINMsym980136201362epoutp036
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:14:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220505061414epoutp0356d9b66b2a8d11a5dd31683c3ac76a37~sINMsym980136201362epoutp036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651731254;
        bh=pE3URItCZrhClkQBdt/r6AxVGqMbnhyIJku6b8Gz3B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ch7pD92t4FP0W4RCWPfdVBs8RSoHMW6avoLkZJRHoFM1/Q4x5R9IZU4kmydOJhKqJ
         duGiGVes9IDA2Mq34ZoQqkCuJ3hwIUFPZdwXHwQ2tENXCxsEI7pk1d591CnEpxzFh8
         S73rBUR9MW4ZhGgoFzVmDIpcfj36WvAruAH6YLeA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220505061414epcas5p3a9c5ce19e867369fe2c9a903ca036f68~sINMKKFUv1837018370epcas5p3U;
        Thu,  5 May 2022 06:14:14 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Kv3LV09Rhz4x9Px; Thu,  5 May
        2022 06:14:10 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.B7.09762.F2B63726; Thu,  5 May 2022 15:14:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994~sILETLOlm2071720717epcas5p19;
        Thu,  5 May 2022 06:11:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220505061148epsmtrp14c2ffe7bbb0f128fc098d2222aecbfe5~sILESO0MR1114811148epsmtrp16;
        Thu,  5 May 2022 06:11:48 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-2d-62736b2fd62d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.2C.08924.4AA63726; Thu,  5 May 2022 15:11:48 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220505061146epsmtip21a9162fe6889cd60979e43d6c5fafe16~sILCq8RCG0280502805epsmtip2d;
        Thu,  5 May 2022 06:11:46 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v4 3/5] nvme: refactor nvme_submit_user_cmd()
Date:   Thu,  5 May 2022 11:36:14 +0530
Message-Id: <20220505060616.803816-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505060616.803816-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmuq5+dnGSwe8rrBZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ1zuXchWsEqyorXr
        BnsD4xORLkZODgkBE4kTb34wdTFycQgJ7GaUWHmkkQ0kISTwiVHiyzdliMRnRoltn/tZYTou
        7jjICJHYxSjR9WsBM0QHUNWmRaJdjBwcbAKaEhcml4KERQTkJb7cXssCUs8scJZRYtqtQ2CD
        hAVsJeYtXsYOUs8ioCoxe1IMSJhXwFLixPnpLBC75CVmXvrODmJzClhJdBztZYGoEZQ4OfMJ
        mM0MVNO8dTYzyHwJgYUcEpd3r4c61EXi7d+/ULawxKvjW9ghbCmJl/1tUHayROv2y2A3SAiU
        SCxZoA4Rtpe4uOcvE0iYGeiV9bv0IcKyElNPrWOCWMsn0fv7CRNEnFdixzwYW1Hi3qSnUFvF
        JR7OWAJle0hs2/aHGRJsvYwSV/YeZ5zAqDALyTuzkLwzC2H1AkbmVYySqQXFuempxaYFxnmp
        5fAoTs7P3cQITr1a3jsYHz34oHeIkYmD8RCjBAezkgiv89KCJCHelMTKqtSi/Pii0pzU4kOM
        psDgnsgsJZqcD0z+eSXxhiaWBiZmZmYmlsZmhkrivKfSNyQKCaQnlqRmp6YWpBbB9DFxcEo1
        MJ2+fPZkZ/mDs2YtHqqSse5sQh08vR6zH6x3eLZVV1lOJTT5+QLdtFNXeat8k79YBrRe8Jlr
        UsM0vdsv++OB/Nqpgcs1Zl2wrc7w28HPxOVR2xrL0B964436kvbPFl3MvYkGou2taRHvAiIi
        /0z5Xu3j41uctvEIi8NLRwfhD9L79LL3nRR6rtnybzn7t/5v3z5qx8UYO032jIpM6d4lOZ9f
        k8eLseXg/ovXQ9dJvrl4fVIqc7Cg1Tnza6ezeDcu77DwzF3s1igz48WTy5dsL1vsuGO4QFVv
        4bVyXd/7N080Lngp4/VeMOTX9VuKMy1uqeX1vDsmE+rDOqV1Zf4Blu9BO0q5vNedldGayPZJ
        iaU4I9FQi7moOBEA1FPH+EYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWy7bCSvO6SrOIkgw17OCyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymL/sKbvFjQlPGS0OTW5msrj68gC7A7fHxOZ3
        7B47Z91l97h8ttRj06pONo/NS+o9dt9sYPN4v+8qm0ffllWMHp83yQVwRnHZpKTmZJalFunb
        JXBlXO5dyFawSrKitesGewPjE5EuRk4OCQETiYs7DjJ2MXJxCAnsYJTovzWFESIhLtF87Qc7
        hC0ssfLfc3aIoo+MEodfvmbqYuTgYBPQlLgwuRSkRkRAUWLjxyawQcwCNxklHrdeYwZJCAvY
        SsxbvIwdpJ5FQFVi9qQYkDCvgKXEifPTWSDmy0vMvPQdbBengJVEx9FesLgQUM397tUsEPWC
        EidnPgGzmYHqm7fOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5
        mxjBEaKltYNxz6oPeocYmTgYDzFKcDArifA6Ly1IEuJNSaysSi3Kjy8qzUktPsQozcGiJM57
        oetkvJBAemJJanZqakFqEUyWiYNTqoEpLazaWPdRovxvxzTzw6wbw66VrdPmSJ83u0SlYfX7
        VUnKtbks++MeBVbw1+7z42c5sH9W6kLbpdYatrpGO+6/mjYp9/hX4T/bz898bPF0vamZoPUU
        prOVbhs3rRacVn22bErK51V/Z+k+3cY91bfeUOPih5prC7XvyFmvemP9d36thCar5a9f+26z
        PnF+e3FH4FmnguVb30+adevo77cPvOyCmYO6fjlwh72+wpx81+X6r4JvmfN3lNTPC/BR1FY2
        Zl3JJRez+u+eV7ZiEx4JXMzWe+9w/I3m2pAcppUMUdwmKusksr5mtsfX3FPu+65SsTG3yrot
        bR2ThK93yIKAU/Vu0mKx4V0n6uOlTPKVWIozEg21mIuKEwHedaa0/wIAAA==
X-CMS-MailID: 20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994
References: <20220505060616.803816-1-joshi.k@samsung.com>
        <CGME20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994@epcas5p1.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Divide the work into two helpers, namely nvme_alloc_user_request and
nvme_execute_user_rq. This is a prep patch, to help wiring up
uring-cmd support in nvme.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/ioctl.c | 47 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 554566371ffa..3531de8073a6 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -19,6 +19,13 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
 
+static inline void *nvme_meta_from_bio(struct bio *bio)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	return bip ? bvec_virt(bip->bip_vec) : NULL;
+}
+
 static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 		unsigned len, u32 seed, bool write)
 {
@@ -53,10 +60,10 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	return ERR_PTR(ret);
 }
 
-static int nvme_submit_user_cmd(struct request_queue *q,
+static struct request *nvme_alloc_user_request(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
+		u32 meta_seed, unsigned timeout, bool vec)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -68,7 +75,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 
 	req = blk_mq_alloc_request(q, nvme_req_op(cmd), 0);
 	if (IS_ERR(req))
-		return PTR_ERR(req);
+		return req;
 	nvme_init_request(req, cmd);
 
 	if (timeout)
@@ -108,7 +115,26 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		}
 	}
 
+	return req;
+
+out_unmap:
+	if (bio)
+		blk_rq_unmap_user(bio);
+out:
+	blk_mq_free_request(req);
+	return ERR_PTR(ret);
+}
+
+static int nvme_execute_user_rq(struct request *req, void __user *meta_buffer,
+		unsigned meta_len, u64 *result)
+{
+	struct bio *bio = req->bio;
+	bool write = bio_op(bio) == REQ_OP_DRV_OUT;
+	int ret;
+	void *meta = nvme_meta_from_bio(bio);
+
 	ret = nvme_execute_passthru_rq(req);
+
 	if (result)
 		*result = le64_to_cpu(nvme_req(req)->result.u64);
 	if (meta && !ret && !write) {
@@ -116,14 +142,25 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			ret = -EFAULT;
 	}
 	kfree(meta);
- out_unmap:
 	if (bio)
 		blk_rq_unmap_user(bio);
- out:
 	blk_mq_free_request(req);
 	return ret;
 }
 
+static int nvme_submit_user_cmd(struct request_queue *q,
+		struct nvme_command *cmd, void __user *ubuffer,
+		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
+		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
+{
+	struct request *req;
+
+	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
+			meta_len, meta_seed, timeout, vec);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	return nvme_execute_user_rq(req, meta_buffer, meta_len, result);
+}
 
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
-- 
2.25.1

