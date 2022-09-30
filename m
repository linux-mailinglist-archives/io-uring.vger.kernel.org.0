Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264FC5F052B
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 08:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiI3GpU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 02:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiI3GpL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 02:45:11 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A86A36DF0
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 23:45:07 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220930064505epoutp0219055a1f82045ccb611b59fcd51d0062~ZkGYWz7ZG0425104251epoutp026
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:45:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220930064505epoutp0219055a1f82045ccb611b59fcd51d0062~ZkGYWz7ZG0425104251epoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664520305;
        bh=CK6y+4CJTbXEJ0DmfDZkP4QxoZPfh+zQGIa6zysu96A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgc7gzoQIEwehF9HQbRgpqbXm0F955ummTBavvjmnJJnFa9Qaz0XLNqs51SoHJXnB
         1Bd9F7fy5trVYi/X2jjyw6AdqBvyt6SancrIusDyofk562H+pkbzpxzn2sih+K9FZ6
         n4G35sNDHZLzG8rPXRtqypuT9Zca+ZlJIgXjDdRk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220930064504epcas5p387d9215a71fc1001602b342944e40c8f~ZkGXni4yE2565825658epcas5p3e;
        Fri, 30 Sep 2022 06:45:04 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Mf11p5r3jz4x9Pp; Fri, 30 Sep
        2022 06:45:02 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        80.42.56352.E6096336; Fri, 30 Sep 2022 15:45:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220930063833epcas5p40fbff95f9d132f5a42dda80d307426e9~ZkArb25FD2024220242epcas5p4O;
        Fri, 30 Sep 2022 06:38:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220930063833epsmtrp1912c3123d85a5da197775af2451df46c~ZkArbLujp2657326573epsmtrp1i;
        Fri, 30 Sep 2022 06:38:33 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-cd-6336906e21ce
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.69.14392.9EE86336; Fri, 30 Sep 2022 15:38:33 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220930063831epsmtip2804e2adf4659edb5c4242e57518e9635~ZkAp4CasY1483614836epsmtip2Q;
        Fri, 30 Sep 2022 06:38:31 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v12 11/12] nvme: pass ubuffer as an integer
Date:   Fri, 30 Sep 2022 11:57:48 +0530
Message-Id: <20220930062749.152261-12-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmum7eBLNkgysr9CyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMe1vLCqbJVTScn8/YwPheoouRk0NCwETiyJ1dbF2MXBxC
        ArsZJRrX7WKHcD4xSpy8sgYq841R4uP6O6wwLS0LjkBV7WWUOHr+MyuE85lR4lvPFmaQKjYB
        dYkjz1sZQWwRASOJ/Z9OghUxC9xklGg+to8JJCEs4CLx5OYTsCIWAVWJh/v3AtkcHLwC1hIH
        DyVCbJOXmHnpOztImBMo3LwoByTMKyAocXLmExYQmxmopHnrbGaQ8RICjRwS525OgLrURaLn
        /ytmCFtY4tXxLewQtpTEy/42KDtd4sflp0wQdgHIaYwQtr1E66l+ZpC9zAKaEut36UOEZSWm
        nlrHBLGXT6L39xOoVl6JHfNgbCWJ9pVzoGwJib3nGqBsD4kVC/qYIWHVxyjR9e4O0wRGhVlI
        /pmF5J9ZCKsXMDKvYpRMLSjOTU8tNi0wzksth0dycn7uJkZwUtXy3sH46MEHvUOMTByMhxgl
        OJiVRHjFC0yThXhTEiurUovy44tKc1KLDzGaAoN7IrOUaHI+MK3nlcQbmlgamJiZmZlYGpsZ
        KonzLp6hlSwkkJ5YkpqdmlqQWgTTx8TBKdXAtKdxv1F3wLnDZaxhNbFNmwTjNuQfOcSUsusv
        V4L39/Oz1lU8YJqV4xc25eVy7dfv3M1z2HefOq5y99prh58NRT7THbalRzUodCydKKS1xUl2
        Qs8djtRNNx+tE1xzwnl3y923ty639O0ujz1kxLPfWvNtOKNnWyVr95rLDA46vl31nO/VWB47
        sez/7b/3fIG80I/d6/U+yJZqzEnmPndqD/f22G6Gyy2eTiotOZ51W1T9Dx5t6d+oes8swoLz
        iNo+vRMFz2WkOuyKJHtOS73V+9zQeH//pOL0OzHGzEdaHjI6BK5YY3Gx/blv/E++rd9DW5VP
        hOUZfMqfynns2RMZiT0xS+3bTl9Z8bm1X0BWiaU4I9FQi7moOBEAmJY93DMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSvO7LPrNkg22PFSyaJvxltlh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFt3Xd7A5cHlcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8a9rWUF0+QqGs7PZ2xgfC/RxcjJ
        ISFgItGy4Ah7FyMXh5DAbkaJyxe6mCESEhKnXi5jhLCFJVb+ew5V9JFRYsqSfjaQBJuAusSR
        561gRSICZhJLD69hASliFrjPKPG2eTcLSEJYwEXiyc0nYEUsAqoSD/fvBbI5OHgFrCUOHkqE
        WCAvMfPSd3aQMCdQuHlRDkhYSMBK4vOe9+wgNq+AoMTJmU/AJjIDlTdvnc08gVFgFpLULCSp
        BYxMqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgoNeS3MH4/ZVH/QOMTJxMB5ilOBg
        VhLhFS8wTRbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qB
        ydw3/JX770N18hvfX6sO2LzyujC7vK2eO9+D036MDx7Z9UsxLKqPU2jh//fF/7SF8bcLjgKN
        11drv9ezMfxh79V0PuJe371Pf4WqgwrkbvWbvXP73VUy9eorQc+g8xsT/uqkhoScvrVPKcuC
        e/vrC43Tt/PdDz1d82DX31/Lw3oWfuhzCJovJXvnUahwuWNUx7RQn+jeuJ8OTLcvLVLyKErY
        nVlhoFMr6MN2xtTun7mk0aPjR43uhPZ3GW602HrIk/FH58Fl7wqj97taGF7hfKAhxZRVr3Dl
        zpnDs66X6k9Wn1F3dI+iyTvzs+2P1zC8Fah/8vVcjZn0yoYt80Q+1O5qvfDe/PxUhWXcnxkO
        K7EUZyQaajEXFScCAJ2CE+bpAgAA
X-CMS-MailID: 20220930063833epcas5p40fbff95f9d132f5a42dda80d307426e9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220930063833epcas5p40fbff95f9d132f5a42dda80d307426e9
References: <20220930062749.152261-1-anuj20.g@samsung.com>
        <CGME20220930063833epcas5p40fbff95f9d132f5a42dda80d307426e9@epcas5p4.samsung.com>
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

This is a prep patch. Modify nvme_submit_user_cmd and
nvme_map_user_request to take ubuffer as plain integer
argument, and do away with nvme_to_user_ptr conversion in callers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/ioctl.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 3f1e7af19716..7a41caa9bfd2 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -83,9 +83,10 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
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
@@ -94,8 +95,8 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 	void *meta = NULL;
 	int ret;
 
-	ret = blk_rq_map_user_io(req, NULL, ubuffer, bufflen, GFP_KERNEL, vec,
-			0, 0, rq_data_dir(req));
+	ret = blk_rq_map_user_io(req, NULL, nvme_to_user_ptr(ubuffer), bufflen,
+			GFP_KERNEL, vec, 0, 0, rq_data_dir(req));
 
 	if (ret)
 		goto out;
@@ -124,7 +125,7 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
@@ -142,7 +143,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	req->timeout = timeout;
 	if (ubuffer && bufflen) {
 		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-				meta_len, meta_seed, &meta, vec);
+				meta_len, meta_seed, &meta, NULL, vec);
 		if (ret)
 			return ret;
 	}
@@ -226,7 +227,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
+			io.addr, length,
 			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
 			false);
 }
@@ -280,7 +281,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &result, timeout, false);
 
@@ -326,7 +327,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &cmd.result, timeout, vec);
 
@@ -512,9 +513,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	req->timeout = d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0;
 
 	if (d.addr && d.data_len) {
-		ret = nvme_map_user_request(req, nvme_to_user_ptr(d.addr),
+		ret = nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, &meta, vec);
+			d.metadata_len, 0, &meta, ioucmd, vec);
 		if (ret)
 			return ret;
 	}
-- 
2.25.1

