Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F19F5ADFF3
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 08:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238538AbiIFGhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 02:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbiIFGhk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 02:37:40 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDC36F260
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 23:37:39 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220906063738epoutp02bfff9e7fd50ce3ae2689d00c39271ab7~SMhBOoVR_1057810578epoutp02T
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 06:37:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220906063738epoutp02bfff9e7fd50ce3ae2689d00c39271ab7~SMhBOoVR_1057810578epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662446258;
        bh=XgeeoulHQJxbtOhPCDaOvhvAzjNttpjnHeL7vwNSTU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhxRwS1K/YCyB1bwXITEDRTPVxmis+I+c0YZ++VVAnWhiYJDBaSEj4QC7ca5+UCNE
         8Ho21m2takU/Sr4q8UVF9YcEv/QnzuOf3iPRY8gWR096VNi401meVNACV/cXOnb7FE
         /n6UCa2C440UQ++B2Me3qoi/2iRIiL2LACykYkqc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220906063737epcas5p25f2087b6bd8677f33422d7c2d1b8a0d2~SMhAxdepi0869508695epcas5p2c;
        Tue,  6 Sep 2022 06:37:37 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MMG0G5jXQz4x9QB; Tue,  6 Sep
        2022 06:37:34 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.30.53458.EAAE6136; Tue,  6 Sep 2022 15:37:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220906063733epcas5p22984174bd6dbb2571152fea18af90924~SMg9IoAv21760117601epcas5p2E;
        Tue,  6 Sep 2022 06:37:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220906063733epsmtrp1bfd849e42b5ce385a4fc7216879aded6~SMg9H1Umn2539325393epsmtrp1Q;
        Tue,  6 Sep 2022 06:37:33 +0000 (GMT)
X-AuditID: b6c32a4a-a5bff7000000d0d2-99-6316eaae51ae
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.55.14392.DAAE6136; Tue,  6 Sep 2022 15:37:33 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220906063732epsmtip238a7154bf5d5095aaf2b196c833b6cf1~SMg7nFxSy2854328543epsmtip23;
        Tue,  6 Sep 2022 06:37:31 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v5 4/4] nvme: wire up fixed buffer support for nvme
 passthrough
Date:   Tue,  6 Sep 2022 11:57:21 +0530
Message-Id: <20220906062721.62630-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906062721.62630-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsWy7bCmuu66V2LJBv9usVs0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8ruwOWxc9Zddo/LZ0s9
        Nq3qZPPYvKTeY/fNBjaPvi2rGD0+b5ILYI/KtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
        1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCS
        U2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ3xZfUVxoK/yhXvV7ewNjAulO1i5OCQEDCRaJ+r
        0cXIxSEksJtR4saXDSwQzidGic9HbzJDON8YJTqnH2LtYuQE6zjUto4VIrGXUeJ162KwhJDA
        Z0aJQ8+9QcayCWhKXJhcChIWEfCSuH/7PVg9M8iK1X/fgtULC0RJXF11gQnEZhFQlbjf84IR
        xOYVsJBYdbYNapm8xMxL39lBbE4BS4kJJ7+wQdQISpyc+YQFxGYGqmneOpsZor6TQ2L9SSGI
        11wkfv7UgwgLS7w6voUdwpaSeNnfBmUnS1yaeY4Jwi6ReLznIJRtL9F6qp8ZZAwz0Cvrd+lD
        bOKT6P39hAliOq9ER5sQRLWixL1JT6EOFpd4OGMJlO0h8ffmHEZI4PQwSvzpZZzAKD8Lyf2z
        kNw/C2HZAkbmVYySqQXFuempxaYFRnmp5fBITc7P3cQITp9aXjsYHz74oHeIkYmD8RCjBAez
        kghvyg6RZCHelMTKqtSi/Pii0pzU4kOMpsAAnsgsJZqcD0zgeSXxhiaWBiZmZmYmlsZmhkri
        vFO0GZOFBNITS1KzU1MLUotg+pg4OKUamNLv3zcWtj2wYPklxh/dd3S3RDM7/FRw82lSldl4
        8fciDeV95ZlK21d67rxllm2zuiGOYSZbEsPrnae+8AdP9Au1PHO558G0ngn9y4Xk9Gb8nBK7
        dK2W8+7GgF/hLoyr+j7aXV2WHVWTy3Zu/v/i1puCBgf2xv5kM5hgs1WO6YfLol1RKs+XTqqb
        zqa1V+pGldHZVvvdUc0WzqJrVwU6Tu2+t+RW01GB7RW52ho9T1NVP+lOLy8SymC79mjafLWk
        j5+2iJkXfWhdlR4oqLLrwqptL054Zl80SjlZll/Yek7B8GO0N5/u2+ePkjOqS3n3XbtySE7Q
        +/FRrbYa3ZDOE4a2G5vWyaa+aJRV1kjYocRSnJFoqMVcVJwIAHs0lH0oBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSvO7aV2LJBhv/ylk0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8ruwOWxc9Zddo/LZ0s9
        Nq3qZPPYvKTeY/fNBjaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgyviy+gpjwV/liverW1gb
        GBfKdjFyckgImEgcalvHCmILCexmlHi4PAwiLi7RfO0HO4QtLLHy33Mgmwuo5iOjxJ/D09i6
        GDk42AQ0JS5MLgWpEREIkDjYeBmshlngIKPE+aZvLCAJYYEIiRtrzoANYhFQlbjf84IRxOYV
        sJBYdbaNFWKBvMTMS9/BajgFLCUmnPzCBnGQhcSdFXeZIOoFJU7OfAI2kxmovnnrbOYJjAKz
        kKRmIUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHAFamjsYt6/6oHeIkYmD
        8RCjBAezkghvyg6RZCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFk
        mTg4pRqYVjTu+VJaZ9j8edtRh3u1LFGFrMv8Yw7oRis2H2svXXa6+NTnryp6wi0cCbJ3w9yy
        tk61UKm/O6v+fV7m1OLV78J6fVc7tdxefKVmwsNWDaNQqYC8uVkV0a/Vdou94wqRyfC4qJ5+
        dX2N9AzVk8ZX7du3n+CwLl62nvkHz80N4Tl7vzz9EOt6aCLPSbX1zJoLnF5Nk3iX6japkTE7
        XUlJ8nX0p4KTX3mTOf1nXq1c83OL+KTfpWJqanUy1yedW7vj94GOOV81lps+shI54Jw54ZJS
        sPwu0dNJc1mkImZecUoyzcq8fGPBDpUZ8c+2HrH7qGH168DUtQs4NR8zfXZsnLS5M/lwMROf
        7UTz5Zd3K7EUZyQaajEXFScCAE55i7zvAgAA
X-CMS-MailID: 20220906063733epcas5p22984174bd6dbb2571152fea18af90924
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220906063733epcas5p22984174bd6dbb2571152fea18af90924
References: <20220906062721.62630-1-joshi.k@samsung.com>
        <CGME20220906063733epcas5p22984174bd6dbb2571152fea18af90924@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

if io_uring sends passthrough command with IO_URING_F_FIXEDBUFS flag,
use the pre-registered buffer to form the bio.
While at it modify nvme_submit_user_cmd to take ubuffer as plain integer
argument, and do away with nvme_to_user_ptr conversion in callers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 548aca8b5b9f..4341d758d6b9 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -65,10 +65,11 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
 }
 
 static struct request *nvme_alloc_user_request(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, void **metap, unsigned timeout, bool vec,
-		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
+		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags,
+		struct io_uring_cmd *ioucmd, bool fixedbufs)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -89,14 +90,27 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 
 	if (ubuffer && bufflen) {
 		if (!vec)
-			ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-				GFP_KERNEL);
+			if (fixedbufs) {
+				struct iov_iter iter;
+
+				ret = io_uring_cmd_import_fixed(ubuffer,
+						bufflen, rq_data_dir(req),
+						&iter, ioucmd);
+				if (ret < 0)
+					goto out;
+				ret = blk_rq_map_user_bvec(req, &iter);
+			} else {
+				ret = blk_rq_map_user(q, req, NULL,
+						nvme_to_user_ptr(ubuffer),
+						bufflen, GFP_KERNEL);
+			}
 		else {
 			struct iovec fast_iov[UIO_FASTIOV];
 			struct iovec *iov = fast_iov;
 			struct iov_iter iter;
 
-			ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
+			ret = import_iovec(rq_data_dir(req),
+					nvme_to_user_ptr(ubuffer), bufflen,
 					UIO_FASTIOV, &iov, &iter);
 			if (ret < 0)
 				goto out;
@@ -132,7 +146,7 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
@@ -142,7 +156,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	int ret;
 
 	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, &meta, timeout, vec, 0, 0);
+			meta_len, meta_seed, &meta, timeout, vec, 0, 0, NULL, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -220,7 +234,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
+			io.addr, length,
 			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
 			false);
 }
@@ -274,7 +288,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &result, timeout, false);
 
@@ -320,7 +334,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &cmd.result, timeout, vec);
 
@@ -457,11 +471,11 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		rq_flags |= REQ_POLLED;
 
 retry:
-	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
+	req = nvme_alloc_user_request(q, &c, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
 			d.metadata_len, 0, &meta, d.timeout_ms ?
 			msecs_to_jiffies(d.timeout_ms) : 0, vec, rq_flags,
-			blk_flags);
+			blk_flags, ioucmd, issue_flags & IO_URING_F_FIXEDBUFS);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	req->end_io = nvme_uring_cmd_end_io;
-- 
2.25.1

