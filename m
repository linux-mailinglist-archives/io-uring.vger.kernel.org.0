Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246B05B354C
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 12:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiIIKcS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 06:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiIIKcH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 06:32:07 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE76D125B0B
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 03:32:03 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220909103202epoutp040b1dac06f3637c04c148972c70b2134d~TKpiXaHy31577515775epoutp048
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 10:32:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220909103202epoutp040b1dac06f3637c04c148972c70b2134d~TKpiXaHy31577515775epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662719522;
        bh=PVB0MUD8yijKhOA6MHwkPqGB3DJlypXxBlTGsU/XaIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+W8iH1XcSJjExKHDB0kqWJ4itLNdaGzkMy7FMz7QT0y7nZC3f93MFpiZ3lHyB/Tc
         N8MTrtz+ZDo1TEMud5iRRavyMunB3uRzQvC45s88O45vGK6/718uol1hx+GeFCphuV
         s86S2V59iAOz4v0BTZ4wwD39V7jUhL1wVn0EjVkk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220909103201epcas5p2f5098fb079af197e68324af10e88e95e~TKph2p2fj3133831338epcas5p2b;
        Fri,  9 Sep 2022 10:32:01 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MPC3M1zc8z4x9Pw; Fri,  9 Sep
        2022 10:31:59 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.F6.54060.7161B136; Fri,  9 Sep 2022 19:31:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220909103151epcas5p1e25127c3053ba21e8f8418a701878973~TKpX-x5m92206722067epcas5p1O;
        Fri,  9 Sep 2022 10:31:51 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220909103151epsmtrp18ef8995fae6916182ea9b1190aa20435~TKpX6XEb61097010970epsmtrp1O;
        Fri,  9 Sep 2022 10:31:51 +0000 (GMT)
X-AuditID: b6c32a4b-be1ff7000000d32c-ae-631b1617f45d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.61.14392.6161B136; Fri,  9 Sep 2022 19:31:50 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220909103149epsmtip180e659fe86a3184108a4f787572f3a49~TKpWaiDRA1205012050epsmtip1P;
        Fri,  9 Sep 2022 10:31:49 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v7 5/5] nvme: wire up fixed buffer support for nvme
 passthrough
Date:   Fri,  9 Sep 2022 15:51:36 +0530
Message-Id: <20220909102136.3020-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909102136.3020-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmuq64mHSywZxmGYs5q7YxWqy+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06PnbPusntcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAHtUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
        kkJeYm6qrZKLT4CuW2YO0F1KCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAKTAr3i
        xNzi0rx0vbzUEitDAwMjU6DChOyMd4+bmArmKFf0NB1ibGC8LNPFyMkhIWAi8etdE0sXIxeH
        kMBuRol9bRcYIZxPjBJLzl2Hcr4xSkxr+8kM03Lw0BR2iMReRonnn76zQTifGSVm911g7WLk
        4GAT0JS4MLkUpEFEwEvi/u33rCA1zAIzGCVWd7xmB0kIC0RJrNrbwAJiswioSmx7dAKsl1fA
        XOLy23iIZfISMy99ByvnFLCQmPz5GpjNKyAocXLmE7BWZqCa5q2zmUHmSwg0ckhcm36dDaLZ
        ReLa5TNQVwtLvDq+hR3ClpJ42d8GZSdLXJp5jgnCLpF4vOcglG0v0XqqnxnkHmagX9bv0ofY
        xSfR+/sJE0hYQoBXoqNNCKJaUeLepKesELa4xMMZS6BsD4mtt3dAA7GbUWL36zPsExjlZyF5
        YRaSF2YhbFvAyLyKUTK1oDg3PbXYtMA4L7UcHrHJ+bmbGMHJU8t7B+OjBx/0DjEycTAeYpTg
        YFYS4RVdK5EsxJuSWFmVWpQfX1Sak1p8iNEUGMQTmaVEk/OB6TuvJN7QxNLAxMzMzMTS2MxQ
        SZx3ijZjspBAemJJanZqakFqEUwfEwenVAOT6GT/J3aB7R8uJ+hs+u7bJiZww7aE8VkeL3NR
        5MkNFTPaxSQ6362Jn17S/Uvy7r7FVoxblrYsm9SY8PuHbu/MwxwzVSJb7lzTyT5Ycnhptp6f
        f4du+9+stIh5kzbF31jwTmrT9zrPzc8YNz6L/yrEU/Zq8uLfn9441fySqWyf7zN56UzHeTzP
        xOZabFodPrWocu06bdb7XGVqSzMF4mIDgx5Xz9Uv3GW9NsX+q0GctNOnLMt/1tu/uGgc+KDR
        58Ld+ldey2Tnrmsvjx1bLr52q0cE84HCpbZKG1g6n0T2/mA4dFrSR4T7+atFVxg26ns4Hnw3
        r/GooH5bzXYP/l05i0562+ncDvWuOFtrcmmOEktxRqKhFnNRcSIAlPwAFicEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSnK6YmHSywcdGG4s5q7YxWqy+289m
        cfPATiaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2B06PnbPusntcPlvqsWlVJ5vH
        5iX1HrtvNrB59G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8a7x01MBXOUK3qaDjE2MF6W6WLk
        5JAQMJE4eGgKexcjF4eQwG5GiV39n9kgEuISzdd+sEPYwhIr/z2HKvrIKDF/8RXWLkYODjYB
        TYkLk0tBakQEAiQONl4Gq2EWmMMocfnyHrBmYYEIiRNtL1lAbBYBVYltj06A9fIKmEtcfhsP
        MV9eYual72DlnAIWEpM/XwOzhYBKXu/8BNbKKyAocXLmEzCbGai+eets5gmMArOQpGYhSS1g
        ZFrFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREc9lqaOxi3r/qgd4iRiYPxEKMEB7OS
        CK/oWolkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGphO
        qHZfTXpa3WyduVayafUWT06lQxMepVVxPzyd7NyprlLn0lf3+eTGU6rtjpsM72bpt055zCX/
        4tDBKrUNoqF2p2++SKnaU7TrxeRbKZ86LZ6sPGW5M1shKDnQ7btOY6enyI21E+94f7x8JClg
        s6+P2o9zrp99Wp8VlRZv2Bina1dV9+fZtuwtWxcEl/Rrah86OTXcpEVpS6f0nRmy/6Zbvrzp
        G3VS9XveNpmD/3wC5v2y2x+depm/ruvSlwnnVxy7In/ugOF+zc+p32r3229rmtG4+0PexxqX
        +Swedj2SPrMuHghmERGqPJ8bfGdX9/JC9dKLZ0Tv+65b9bH9nU7l6wLpKO3P6ftn7nKzDlFQ
        YinOSDTUYi4qTgQAK7USGeoCAAA=
X-CMS-MailID: 20220909103151epcas5p1e25127c3053ba21e8f8418a701878973
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103151epcas5p1e25127c3053ba21e8f8418a701878973
References: <20220909102136.3020-1-joshi.k@samsung.com>
        <CGME20220909103151epcas5p1e25127c3053ba21e8f8418a701878973@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

