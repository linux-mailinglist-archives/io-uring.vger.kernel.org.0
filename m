Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258785EF537
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 14:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbiI2MWQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 08:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbiI2MWH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 08:22:07 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64C11514EE
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 05:22:05 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220929122204epoutp0242e36b8896312790c02ee92d2da0cfcb~ZVDUOt57s0648806488epoutp02W
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 12:22:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220929122204epoutp0242e36b8896312790c02ee92d2da0cfcb~ZVDUOt57s0648806488epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664454124;
        bh=LeLI2qR2gM2LLy5jVtD0IFNvJ8xQj6lBm3zf0UZZ7bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XO9e7ZpdQuo/xeUP2pyYS38PynWmDybABUI17s9ILWYzcSNjDO5dwbwFL5p8BwQyw
         hWWdB57hlgVASltqoDczZXv0p5dgZEJpZzTfDJVyVv8awBCp3/Va565HGyYpvVRVxs
         9XLbz5n527O635upkw2nmiej7I7Nf4dbpajHrqdA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220929122203epcas5p3d75fbd3d68a5eb6e028b339c3a7c9d81~ZVDT2FENW2488324883epcas5p3G;
        Thu, 29 Sep 2022 12:22:03 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MdXY52xZVz4x9Q1; Thu, 29 Sep
        2022 12:22:01 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.28.39477.9ED85336; Thu, 29 Sep 2022 21:22:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220929121643epcas5p4c58f6ebb794bde58981272cd33c69f9f~ZU_phy-vt3132331323epcas5p4a;
        Thu, 29 Sep 2022 12:16:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220929121643epsmtrp259370ba348f3564bda783d724a2a1489~ZU_phBCWQ1794617946epsmtrp2Q;
        Thu, 29 Sep 2022 12:16:43 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-66-63358de97895
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.2C.18644.BAC85336; Thu, 29 Sep 2022 21:16:43 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220929121641epsmtip1bb82e7a15dd69eb79f0619061d566220~ZU_oFPM8s3141431414epsmtip1q;
        Thu, 29 Sep 2022 12:16:41 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v11 04/13] nvme: refactor nvme_alloc_request
Date:   Thu, 29 Sep 2022 17:36:23 +0530
Message-Id: <20220929120632.64749-5-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929120632.64749-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmuu7LXtNkgyl/hSyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyM/XfTCqbqVTy7OYelgfGxShcjJ4eEgInExwm9LF2MXBxC
        ArsZJdo/HGaEcD4xSvz99hXK+cwo8b3rLhNMy9KPl6BadjFKTL7/igmu6vy9J8wgVWwC6hJH
        nrcygtgiAkYS+z+dZAUpYha4ySjRfGwf2ChhAVeJ+1uus3cxcnCwCKhKzN9RBRLmFbCUWPnh
        CCPENnmJmZe+s4PYnAJWEouvzWGFqBGUODnzCQuIzQxU07x1NjPIfAmBRg6JT9M/sEM0u0h8
        +b4YapCwxKvjW6DiUhKf3+1lg7DTJX5cfgr1WgHIbVD19hKtp/qZQW5jFtCUWL9LHyIsKzH1
        1DomiL18Er2/n0C18krsmAdjK0m0r5wDZUtI7D3XAGV7SLxfPocVEli9jBLrjz9lnsCoMAvJ
        P7OQ/DMLYfUCRuZVjJKpBcW56anFpgVGeanl8FhOzs/dxAhOq1peOxgfPvigd4iRiYPxEKME
        B7OSCK94gWmyEG9KYmVValF+fFFpTmrxIUZTYHhPZJYSTc4HJva8knhDE0sDEzMzMxNLYzND
        JXHexTO0koUE0hNLUrNTUwtSi2D6mDg4pRqYpIJS8wPYvxy5ZtIrUdtu2FZ0cZ6b93nNC8td
        v5zc7GA/3bWqOU5LoMVS88UMQbM/bPcC573Q4Qq9uzuRQ6U2+5XBIn8WrllqDskb/G1y//73
        ueEacZFTKGT5XcM791rTivO06+QMone7/poj0Hrp0O6Y9mPFhwSn+s26qXCkZUHhlqb65gM1
        k92krgrEzfUvC5g4g2H+9lUHWb+WawvfYXj87czHIPY5jt7XTVbHR07vcMi/FbG2rmxfwNbg
        d4fak7xeXP5VYpdtmmT368qCNtPgopa5b9zeFK80enE8s0rx5bot3gsL5pa8MJ7EmPTy8ozl
        WwW8HnBfebf8t+Rp0SOiXFP42w5O7Kq+LrZeiaU4I9FQi7moOBEAqDYoSTQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSnO7qHtNkg8+fhS2aJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8b+u2kFU/Uqnt2cw9LA+Fili5GT
        Q0LARGLpx0ssXYxcHEICOxgldpzezgSRkJA49XIZI4QtLLHy33N2iKKPjBKvjhxkAUmwCahL
        HHneClYkImAmsfTwGrBJzAL3GSXeNu8GKxIWcJW4v+U6UDcHB4uAqsT8HVUgYV4BS4mVH45A
        LZCXmHnpOzuIzSlgJbH42hxWkHIhoJrtNxUgygUlTs58AjaRGai8eets5gmMArOQpGYhSS1g
        ZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREc9FpaOxj3rPqgd4iRiYPxEKMEB7OS
        CK94gWmyEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxSDUxM
        mutF1mlo7dOptpZ7usKxbFfz1EC+bcrl3gt/Gc5Oc7BaOanu5AaGaDumm4991paqs885qHZX
        dcO1zcZ1UZ3n36/8plh1NPpZj0b1pMRbzD8PCldM0eOoqK75Mmn/8r1vrtVt8D8R/27b+Qm/
        6qeJLHdpluR8sFnfStyby7/h8vZL7zdxs58+ETBjQvpmv3/FXT8O6VlMn7VYZOoFNTGPl/qP
        n/9b+FBNI+vnn9MCP1cu9AqznuUWYMt2fXe3NQ9fOuN1rzTxxKZX30P/W6r3VjYwXji/rOLj
        8yq+RccmmCz5fcbVLHrLfrVNHo8l97IcDzXeYXQlRujAF+v4d8b8dSd9U2ftWpLs8Zdvt+IP
        JZbijERDLeai4kQArbdxIukCAAA=
X-CMS-MailID: 20220929121643epcas5p4c58f6ebb794bde58981272cd33c69f9f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220929121643epcas5p4c58f6ebb794bde58981272cd33c69f9f
References: <20220929120632.64749-1-anuj20.g@samsung.com>
        <CGME20220929121643epcas5p4c58f6ebb794bde58981272cd33c69f9f@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/nvme/host/ioctl.c | 120 ++++++++++++++++++++++----------------
 1 file changed, 69 insertions(+), 51 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 749f588a1228..0143f62b27c2 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -70,68 +70,69 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
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
-		if (!vec)
-			ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-				GFP_KERNEL);
-		else {
-			struct iovec fast_iov[UIO_FASTIOV];
-			struct iovec *iov = fast_iov;
-			struct iov_iter iter;
-
-			ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
-					UIO_FASTIOV, &iov, &iter);
-			if (ret < 0)
-				goto out;
-			ret = blk_rq_map_user_iov(q, req, NULL, &iter,
-					GFP_KERNEL);
-			kfree(iov);
-		}
-		if (ret)
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
+	if (!vec)
+		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
+			GFP_KERNEL);
+	else {
+		struct iovec fast_iov[UIO_FASTIOV];
+		struct iovec *iov = fast_iov;
+		struct iov_iter iter;
+
+		ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
+				UIO_FASTIOV, &iov, &iter);
+		if (ret < 0)
 			goto out;
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
+
+		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
+		kfree(iov);
+	}
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
-	blk_mq_free_request(req);
-	return ERR_PTR(ret);
+	return ret;
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
@@ -146,11 +147,18 @@ static int nvme_submit_user_cmd(struct request_queue *q,
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
+			goto out;
+	}
+
 	bio = req->bio;
 	ctrl = nvme_req(req)->ctrl;
 
@@ -163,6 +171,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 						meta_len, ret);
 	if (bio)
 		blk_rq_unmap_user(bio);
+out:
 	blk_mq_free_request(req);
 
 	if (effects)
@@ -470,6 +479,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	blk_opf_t rq_flags = 0;
 	blk_mq_req_flags_t blk_flags = 0;
 	void *meta = NULL;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -509,13 +519,18 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
+			goto out_err;
+	}
 
 	if (issue_flags & IO_URING_F_IOPOLL && rq_flags & REQ_POLLED) {
 		if (unlikely(!req->bio)) {
@@ -541,6 +556,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	}
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
+out_err:
+	blk_mq_free_request(req);
+	return ret;
 }
 
 static bool is_ctrl_ioctl(unsigned int cmd)
-- 
2.25.1

