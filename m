Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4777E5F051B
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiI3GoX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiI3GoO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:44:14 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DE6C77E3
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:44:12 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220930064411epoutp043e1f57150c5737e3f06708984b621363~ZkFmCr1_s0756107561epoutp04_
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:44:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220930064411epoutp043e1f57150c5737e3f06708984b621363~ZkFmCr1_s0756107561epoutp04_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520251;
        bh=+erqF/H/+cbelwAdq7fVoTxCoPBYnaLkKBmydd0SmkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sa+ksZH9/OcqJxFgZJCDAykWGOXRk8LVMrd+Ot+SUYUF1dNGDnMnjky5/nzgIWcDL
         oDNriH5RuHRJftoq5QUqY03yMOYZskP7OLQOx668NBkoU2zaQtFJnmyRe8DHuJLCRJ
         4z34DGti1K/eeJCYqw+1W+bWii4Cey4hVOisyrdA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220930064410epcas5p2625b560d79d247e22dcd3095ac796f85~ZkFlnz4Cg2832628326epcas5p2H;
        Fri, 30 Sep 2022 06:44:10 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Mf10m4xPzz4x9Q0; Fri, 30 Sep
        2022 06:44:08 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.7D.39477.83096336; Fri, 30 Sep 2022 15:44:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220930063824epcas5p4f829f3b8673e2603cdc9a799ca44ea6e~ZkAjNiF0e1804318043epcas5p4H;
        Fri, 30 Sep 2022 06:38:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220930063824epsmtrp13c7e3ecc15037231b997c8cfd600f39c~ZkAjMnJ6Y2641426414epsmtrp11;
        Fri, 30 Sep 2022 06:38:24 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-eb-63369038ec43
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.42.18644.0EE86336; Fri, 30 Sep 2022 15:38:24 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063822epsmtip22fc3d2adde5543f8c23de5f85cead259~ZkAhW5p821763417634epsmtip2J;
        Fri, 30 Sep 2022 06:38:22 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v12 07/12] nvme: refactor nvme_alloc_request
Date:   Fri, 30 Sep 2022 11:57:44 +0530
Message-Id: <20220930062749.152261-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmhq7FBLNkg5XfVS2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyM5pmNjAVtahVTL01iaWA8I9fFyMkhIWAi8fLhXOYuRi4O
        IYHdjBKH50xjgnA+MUrMf9nPAuF8ZpS4d/4gO0zL9xWHWSESuxglOh/uY4arWn26lwWkik1A
        XeLI81ZGEFtEwEhi/6eTYB3MAjcZJZqP7WMCSQgLuEocerOXDcRmEVCVWHB8KVicV8BK4t/W
        iywQ6+QlZl76DrSag4NTwFqieVEORImgxMmZT8BKmIFKmrfOBjtCQqCVQ+LMtTusEL0uEvv+
        fYSyhSVeHd8C9YKUxMv+Nig7XeLH5adMEHYByG2MELa9ROupfmaQvcwCmhLrd+lDhGUlpp5a
        xwSxl0+i9/cTqFZeiR3zYGwlifaVc6BsCYm95xqgbA+JloU/oOHbxyjx8dZ19gmMCrOQ/DML
        yT+zEFYvYGRexSiZWlCcm55abFpglJdaDo/m5PzcTYzgxKrltYPx4YMPeocYmTgYDzFKcDAr
        ifCKF5gmC/GmJFZWpRblxxeV5qQWH2I0BYb3RGYp0eR8YGrPK4k3NLE0MDEzMzOxNDYzVBLn
        XTxDK1lIID2xJDU7NbUgtQimj4mDU6qBKS7/ycs01qPLKlRuFl/luHi8R0FpRUtx2IE24xWh
        2ZNuBp6PnGsv7OTsqcF9VlmXxW/f+kBDOd32nvyw93eCXDKDn1/cvvCAgOuF9eF+f52dGwJL
        67cpTPk5KeqpAbOV1M4tNi4nZX7ISG3zD7RV36RT8lt7/bwYBidrd9kFL2f84H2lH2noPIfd
        iit44qRAN+NSudT2siyj8l9siZZzH5gdmmzBnX552aHl0eq33cw8Lymf+fG9rbWJYX76Kd/5
        6x9v7Fd5PIX3ttVH5R9NsVu4Lh4wq+c5tzI3fOsij8S5jhc70nbIOO28lvs89VlbxeOth0J3
        dPW+EN6oqPv/3itmfzX34u7SSV6vvk9XYinOSDTUYi4qTgQAQ2nqhzUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWy7bCSvO6DPrNkg0vT1S2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV0bzzEbGgja1iqmXJrE0MJ6R62Lk
        5JAQMJH4vuIwaxcjF4eQwA5GiWX/P7FBJCQkTr1cxghhC0us/PecHaLoI6PE9BOTmEESbALq
        Ekeet4IViQiYSSw9vIYFpIhZ4D6jxNvm3SwgCWEBV4lDb/aCTWURUJVYcHwpE4jNK2Al8W/r
        RRaIDfISMy99B9rAwcEpYC3RvCgHJCwEVPJ5z3t2iHJBiZMzn4CVMwOVN2+dzTyBUWAWktQs
        JKkFjEyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCA19LawfjnlUf9A4xMnEwHmKU
        4GBWEuEVLzBNFuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNT
        qoFpenKj5j79ne/SqqcycH6/uGSvoZXkpiJJp89utfFv+7x+/4vbvv+xqq/8/ZwDXkctm4qn
        LequLj3K4vc0jW3BGz775CNmZ66+WyBuscmjZrPM1aebj98zqYpaNXnO3Wd9Si6n3oiX+jo0
        LFHieX525fKAp3wxN1puZL65en1ewM2WN99l5s6xtr1ecPpH4pWIk7sTztus9Z72aMcJ72jD
        1JyOkE/HwuYuvu8pOL08NTLi+P/55T+WSrTvd2swPBol/GoHy3IlsQ4lSbvw5FpzR4b6ypA9
        8/91P3v+xyO5dHW3yZ1HfEr+Zb8tpl16LS15j2n+RTupZzLSO6x7TLYq72y//vVShPTFWwaJ
        gdM+K7EUZyQaajEXFScCAGHCyojrAgAA
X-CMS-MailID: 20220930063824epcas5p4f829f3b8673e2603cdc9a799ca44ea6e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063824epcas5p4f829f3b8673e2603cdc9a799ca44ea6e
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063824epcas5p4f829f3b8673e2603cdc9a799ca44ea6e@epcas5p4.samsung.com>
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

nvme_alloc_request expects a large number of parameters.
Split this out into two functions to reduce number of parameters.
First one retains the name nvme_alloc_request, while second one is
named nvme_map_user_request.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/ioctl.c | 90 +++++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index bcaa6b3f97ca..3f1e7af19716 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -70,54 +70,57 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
 }
 
 static struct request *nvme_alloc_user_request(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
-		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, void **metap, unsigned timeout, bool vec,
-		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
+		struct nvme_command *cmd, blk_opf_t rq_flags,
+		blk_mq_req_flags_t blk_flags)
 {
-	struct nvme_ns *ns = q->queuedata;
-	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
 	struct request *req;
-	struct bio *bio = NULL;
-	void *meta = NULL;
-	int ret;
 
 	req = blk_mq_alloc_request(q, nvme_req_op(cmd) | rq_flags, blk_flags);
 	if (IS_ERR(req))
 		return req;
 	nvme_init_request(req, cmd);
-
-	if (timeout)
-		req->timeout = timeout;
 	nvme_req(req)->flags |= NVME_REQ_USERCMD;
+	return req;
+}
 
-	if (ubuffer && bufflen) {
-		ret = blk_rq_map_user_io(req, NULL, ubuffer, bufflen,
-				GFP_KERNEL, vec, 0, 0, rq_data_dir(req));
-		if (ret)
-			goto out;
-		bio = req->bio;
-		if (bdev)
-			bio_set_dev(bio, bdev);
-		if (bdev && meta_buffer && meta_len) {
-			meta = nvme_add_user_metadata(req, meta_buffer,
-					meta_len, meta_seed);
-			if (IS_ERR(meta)) {
-				ret = PTR_ERR(meta);
-				goto out_unmap;
-			}
-			*metap = meta;
+static int nvme_map_user_request(struct request *req, void __user *ubuffer,
+		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
+		u32 meta_seed, void **metap, bool vec)
+{
+	struct request_queue *q = req->q;
+	struct nvme_ns *ns = q->queuedata;
+	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
+	struct bio *bio = NULL;
+	void *meta = NULL;
+	int ret;
+
+	ret = blk_rq_map_user_io(req, NULL, ubuffer, bufflen, GFP_KERNEL, vec,
+			0, 0, rq_data_dir(req));
+
+	if (ret)
+		goto out;
+	bio = req->bio;
+	if (bdev)
+		bio_set_dev(bio, bdev);
+
+	if (bdev && meta_buffer && meta_len) {
+		meta = nvme_add_user_metadata(req, meta_buffer, meta_len,
+				meta_seed);
+		if (IS_ERR(meta)) {
+			ret = PTR_ERR(meta);
+			goto out_unmap;
 		}
+		*metap = meta;
 	}
 
-	return req;
+	return ret;
 
 out_unmap:
 	if (bio)
 		blk_rq_unmap_user(bio);
 out:
 	blk_mq_free_request(req);
-	return ERR_PTR(ret);
+	return ret;
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
@@ -132,11 +135,18 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	u32 effects;
 	int ret;
 
-	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, &meta, timeout, vec, 0, 0);
+	req = nvme_alloc_user_request(q, cmd, 0, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	req->timeout = timeout;
+	if (ubuffer && bufflen) {
+		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
+				meta_len, meta_seed, &meta, vec);
+		if (ret)
+			return ret;
+	}
+
 	bio = req->bio;
 	ctrl = nvme_req(req)->ctrl;
 
@@ -456,6 +466,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	blk_opf_t rq_flags = 0;
 	blk_mq_req_flags_t blk_flags = 0;
 	void *meta = NULL;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -495,13 +506,18 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		rq_flags |= REQ_POLLED;
 
 retry:
-	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
-			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, &meta, d.timeout_ms ?
-			msecs_to_jiffies(d.timeout_ms) : 0, vec, rq_flags,
-			blk_flags);
+	req = nvme_alloc_user_request(q, &c, rq_flags, blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
+	req->timeout = d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0;
+
+	if (d.addr && d.data_len) {
+		ret = nvme_map_user_request(req, nvme_to_user_ptr(d.addr),
+			d.data_len, nvme_to_user_ptr(d.metadata),
+			d.metadata_len, 0, &meta, vec);
+		if (ret)
+			return ret;
+	}
 
 	if (issue_flags & IO_URING_F_IOPOLL && rq_flags & REQ_POLLED) {
 		if (unlikely(!req->bio)) {
-- 
2.25.1

