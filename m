Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859685B261F
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiIHSqF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiIHSp5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:45:57 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47F9D2B0C
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 11:45:47 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220908184545epoutp04f41f540012b906e2a60b0babce221312~S9vUtOqTI0437804378epoutp048
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 18:45:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220908184545epoutp04f41f540012b906e2a60b0babce221312~S9vUtOqTI0437804378epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662662745;
        bh=PVB0MUD8yijKhOA6MHwkPqGB3DJlypXxBlTGsU/XaIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKTCnRhpu8DMwgiiPIUHYf26YwKqmBmSOWJ0Nks/FCY9LbeHY0XXAWPZO9YNZL7Yw
         +XR2hKYUbDEdUiMDenY9A/x/KxGFZnUYH+UK439CPQRpOHf25XLMClUnI9e5/OsVGe
         AHsq0koyhFAzexXz7tdlNBY78PV7qwEV44lzI6C0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220908184544epcas5p2e6820c44276f93574cce402af6b0fd21~S9vTw0Kfs2042620426epcas5p2K;
        Thu,  8 Sep 2022 18:45:44 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MNp3T6kVrz4x9Pp; Thu,  8 Sep
        2022 18:45:41 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.0B.53458.5583A136; Fri,  9 Sep 2022 03:45:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220908184541epcas5p183b54ed38849da7abdffebade9e8be6c~S9vRIgC1R0840908409epcas5p11;
        Thu,  8 Sep 2022 18:45:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220908184541epsmtrp1d1f075e671545dcc12e7c1ac36849c4e~S9vRHn3ko3080730807epsmtrp1h;
        Thu,  8 Sep 2022 18:45:41 +0000 (GMT)
X-AuditID: b6c32a4a-a5bff7000000d0d2-c2-631a38551d70
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.DD.14392.5583A136; Fri,  9 Sep 2022 03:45:41 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220908184540epsmtip228f4ca907748e9213caff48c350b1241~S9vPylGvS2337123371epsmtip2F;
        Thu,  8 Sep 2022 18:45:39 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v6 5/5] nvme: wire up fixed buffer support for nvme
 passthrough
Date:   Fri,  9 Sep 2022 00:05:11 +0530
Message-Id: <20220908183511.2253-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908183511.2253-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmlm6ohVSyweNmI4s5q7YxWqy+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06PnbPusntcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAHtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMd4+bmArmKFf0NB1ibGC8LNPFyMkhIWAi0XqwhbGLkYtD
        SGA3o8TVb2uYIJxPjBLz9x1gg3C+MUr8/3WDBabl8PpLLBCJvYwS7+ZOZ4dwPjNKfHv7CSjD
        wcEmoClxYXIpSIOIgJfE/dvvWUFqmAVmMEqs7njNDpIQFoiSWLBhKTtIPYuAqsTb84YgYV4B
        c4l1OzrZIZbJS8y89B3M5hSwkLj45SEbRI2gxMmZT8AOYgaqad46mxlkvoTAX3aJ118uMkM0
        u0gs+HwHyhaWeHV8C9RQKYmX/W1QdrLEpZnnmCDsEonHew5C2fYSraf6mUFuYwb6Zf0ufYhd
        fBK9v58wgYQlBHglOtqEIKoVJe5NesoKYYtLPJyxBMr2kJjy+h80ELsZJc5ub2aewCg/C8kL
        s5C8MAth2wJG5lWMkqkFxbnpqcWmBUZ5qeXwiE3Oz93ECE6eWl47GB8++KB3iJGJg/EQowQH
        s5IIr+haiWQh3pTEyqrUovz4otKc1OJDjKbAIJ7ILCWanA9M33kl8YYmlgYmZmZmJpbGZoZK
        4rxTtBmThQTSE0tSs1NTC1KLYPqYODilGpim3q+cKdN5MoU51PBhyH1X2/JdwU22jOekHnP/
        y4j+d+9GkHOJ38ZP76t5+bZa5gU/98uZ+NtBhyPuS+xtngKWJWq6h2b2b2rlehag6HTa90GT
        RWjM8yrXs/9lts0Svclv3eXuKDNptnBC/z3hyhq5+fqzZe5r/pmY4fdb5enjoJxwXr/uI2uj
        ZCf59Vqlb2bZk/kmPeLUjDndm6sT7210fLLjH3PA5aNr7osXTdBaIHFzhWyUwc/n7xwnbGm/
        v1LVo63gKE/t381xbRfkmf/G8O9vsnRPeZ18T3pKHGtu/tGitBP2N1yMktxOSRrueWnFtnyP
        6uxHB7sUn/ItF+Ow7NzNnev8Y/nsnraMM0osxRmJhlrMRcWJAI5wxsonBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWy7bCSvG6ohVSyweJOSYs5q7YxWqy+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06PnbPusntcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8a7x01MBXOUK3qaDjE2MF6W6WLk
        5JAQMJE4vP4SC4gtJLCbUeLxBVeIuLhE87Uf7BC2sMTKf8+BbC6gmo+MEk8XNQA5HBxsApoS
        FyaXgtSICARIHGy8DFbDLDCHUeLy5T1gNcICERKnF5SBmCwCqhJvzxuClPMKmEus29EJNV5e
        Yual72A2p4CFxMUvD9kgzjGXuPZnOjNEvaDEyZlPwM5kBqpv3jqbeQKjwCwkqVlIUgsYmVYx
        SqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgSHvJbmDsbtqz7oHWJk4mA8xCjBwawkwiu6
        ViJZiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqa1t86/
        vtl6bd+MpAWJt4K25E3XCT7BmnrwrzZPqpLUU/W0uU4G99gf2H1RPMk9M5dLI0x8TtCWtrYp
        uhV6gbN+8pR5HFOum2Z3IvnfdK5l5zfMuzz9YUjT9yqmS5+E5YQyKh/sdj6xNbV8SZCe4jqe
        S/FFycbfju0R2RH5ef6mMrbDXDtE1lT95HwicdOzNbbowTOu0G8eVYaPrz6d/5/pV0pi0ZnA
        7ulV0+3FEyfM7NqzvKUr92rxtSXrOTrc5qa6b+g417eYTYT16NeT6zdcOMmr+dy5/EifxR6D
        h2vF3R7MEhe2e+671vWJ3uWcc95GmvoHy5OqPAvTvs7vXXw1umfVRbt/Ggv2/z/iNTldiaU4
        I9FQi7moOBEABz2Cl+gCAAA=
X-CMS-MailID: 20220908184541epcas5p183b54ed38849da7abdffebade9e8be6c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220908184541epcas5p183b54ed38849da7abdffebade9e8be6c
References: <20220908183511.2253-1-joshi.k@samsung.com>
        <CGME20220908184541epcas5p183b54ed38849da7abdffebade9e8be6c@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

if io_uring sends passthrough command with IORING_URING_CMD_FIXED flag,
use the pre-registered buffer to form the bio.
While at it, modify nvme_submit_user_cmd to take ubuffer as plain integer
argument, and do away with nvme_to_user_ptr conversion in callers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 40 ++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index cb2fa4db50dd..e47ef12ce047 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -81,9 +81,10 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 	return req;
 }
 
-static int nvme_map_user_request(struct request *req, void __user *ubuffer,
+static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, void **metap, bool vec)
+		u32 meta_seed, void **metap, struct io_uring_cmd *ioucmd,
+		bool vec)
 {
 	struct request_queue *q = req->q;
 	struct nvme_ns *ns = q->queuedata;
@@ -91,20 +92,33 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 	struct bio *bio = NULL;
 	void *meta = NULL;
 	int ret;
+	bool fixedbufs = ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED);
 
 	if (!ubuffer || !bufflen)
 		return 0;
 
 	if (!vec)
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-			GFP_KERNEL);
+		if (fixedbufs) {
+			struct iov_iter iter;
+
+			ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
+					rq_data_dir(req), &iter, ioucmd);
+			if (ret < 0)
+				goto out;
+			ret = blk_rq_map_user_bvec(req, &iter);
+
+		} else {
+			ret = blk_rq_map_user(q, req, NULL,
+					nvme_to_user_ptr(ubuffer), bufflen,
+					GFP_KERNEL);
+		}
 	else {
 		struct iovec fast_iov[UIO_FASTIOV];
 		struct iovec *iov = fast_iov;
 		struct iov_iter iter;
 
-		ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
-				UIO_FASTIOV, &iov, &iter);
+		ret = import_iovec(rq_data_dir(req), nvme_to_user_ptr(ubuffer),
+				bufflen, UIO_FASTIOV, &iov, &iter);
 		if (ret < 0)
 			goto out;
 		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
@@ -136,7 +150,7 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
@@ -150,7 +164,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		return PTR_ERR(req);
 
 	ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, &meta, vec);
+			meta_len, meta_seed, &meta, NULL, vec);
 	if (ret)
 		goto out;
 
@@ -228,7 +242,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
+			io.addr, length,
 			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
 			false);
 }
@@ -282,7 +296,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &result, timeout, false);
 
@@ -328,7 +342,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &cmd.result, timeout, vec);
 
@@ -472,9 +486,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	ret = nvme_map_user_request(req, nvme_to_user_ptr(d.addr),
+	ret = nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, &meta, vec);
+			d.metadata_len, 0, &meta, ioucmd, vec);
 	if (ret)
 		goto out_err;
 	req->end_io = nvme_uring_cmd_end_io;
-- 
2.25.1

