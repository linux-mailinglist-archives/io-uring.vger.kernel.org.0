Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B434D1C05
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238764AbiCHPnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347982AbiCHPnj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:39 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE4E19C08
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:37 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220308154235epoutp0359f94ff0c0886e2e1b0e7f0a79ebeb83~aci3-mYBJ2455624556epoutp03M
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220308154235epoutp0359f94ff0c0886e2e1b0e7f0a79ebeb83~aci3-mYBJ2455624556epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754155;
        bh=xggqX2s11RagKw4Q7ebC+vgPojKy+SUye6vkSA58oIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUBprxDBEA1meGt24m5+fi32r1T+0Dx/5sWsfVK1EzaOKrEddx5QdA8Ws2qcjycCa
         75700AJdOOkHEyCFcXPXnFiJbUJlUGEEt4Avf4Et6ELD6IsYJnQ7DLchDqIz0ozChU
         xTRjvj9/Qtd5Uf34suG0s0gw9Yr3XJF8cxzSbnSU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220308154234epcas5p213c09e68f69d6e005bc050a6bb38bb18~aci3YCqRz2884128841epcas5p2k;
        Tue,  8 Mar 2022 15:42:34 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KCfj3309Mz4x9Pv; Tue,  8 Mar
        2022 15:42:31 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.57.06423.76977226; Wed,  9 Mar 2022 00:42:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152709epcas5p1f9d274a0214dc462c22c278a72d8697c~acVZbAWje1997519975epcas5p1T;
        Tue,  8 Mar 2022 15:27:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220308152709epsmtrp198e5583e2cca027f550c02dfb6f25123~acVZaLrYR0125001250epsmtrp1W;
        Tue,  8 Mar 2022 15:27:09 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-f6-622779675e51
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.96.03370.DC577226; Wed,  9 Mar 2022 00:27:09 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152707epsmtip153ad2d104b96e7f2f57cb6e851c5fda1~acVXZd2Mt3168431684epsmtip1D;
        Tue,  8 Mar 2022 15:27:07 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 08/17] nvme: enable passthrough with fixed-buffer
Date:   Tue,  8 Mar 2022 20:50:56 +0530
Message-Id: <20220308152105.309618-9-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmhm56pXqSwc9ZQhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AKyrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
        ycUnQNctMwfoByWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpe
        XmqJlaGBgZEpUGFCdsafbxfZC15oVWzd9JW1gXG2chcjJ4eEgInEibN7GbsYuTiEBHYzSrz5
        2s8OkhAS+MQocWGzHETiM6PEsSf9rDAd21f0MkEkdjFKTN/2nBWu6ui6KyxdjBwcbAKaEhcm
        l4I0iAh4Sdy//R6shlmgi0ni7b77bCAJYQFHiembH4KtYxFQldiw6yNYL6+ApcT7yZ4Qy+Ql
        Zl76DlbCKWAl8fPWVrAjeAUEJU7OfMICYjMD1TRvnc0MMl9C4AiHxOtZP5khml0kHt28zQJh
        C0u8Or6FHcKWknjZ3wZlF0v8unMUqrmDUeJ6w0yoBnuJi3v+MoEcxAz0zPpd+hBhWYmpp9Yx
        QSzmk+j9/YQJIs4rsWMejK0ocW/SU2hoiUs8nLEEyvaQ2L1lFzSwehklrq47zziBUWEWkodm
        IXloFsLqBYzMqxglUwuKc9NTi00LDPNSy+GxnJyfu4kRnK61PHcw3n3wQe8QIxMH4yFGCQ5m
        JRHe++dVkoR4UxIrq1KL8uOLSnNSiw8xmgIDfCKzlGhyPjBj5JXEG5pYGpiYmZmZWBqbGSqJ
        855O35AoJJCeWJKanZpakFoE08fEwSnVwKTFUVC5qOnBcQuvjdwJrV5cFt9O/P3oWSN+eANP
        tea56BbfIxJxt7SvmM5LFYl8ePthyIQqr77pHjFGd19UzDxTZn154/Ow1Spd88K8LCwN3WTY
        vVPyfpusS6x+a9dkaeGsx39q4tS7ZxSVn4sbCXyYXPTI2fPn2aW2e1bJifqqax7bvNpp0RfO
        jTOnivFIHPvsKHdAeY2wT3X1W9aADXtc+iKNjditp0RuXb97WdtXXcPvbhOZ2fZfsV+S8cvy
        Z1XMvgn8F1pq7u/Qz5rWwyLusmHi+Q8TuS68Douo5OJ+kpDa2+HRNOP4gush+Sz62u2ZHWzf
        jdcrMTTOFj3vEKFwRuTPbsFdaYfn7tGKU2Ipzkg01GIuKk4EAEmmsJ9gBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTvdsqXqSwZzHYhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr48+3i+wFL7Qqtm76ytrAOFu5i5GTQ0LARGL7
        il4mEFtIYAejxJ2NfBBxcYnmaz/YIWxhiZX/ngPZXEA1Hxklpj3eCtTAwcEmoClxYXIpSI2I
        QIDEwcbLYDXMAjOYJHqaP7OAJIQFHCWmb34INohFQFViw66PLCC9vAKWEu8ne0LMl5eYeek7
        WAmngJXEz1tbWSHusZRYse43G4jNKyAocXLmE7CRzED1zVtnM09gFJiFJDULSWoBI9MqRsnU
        guLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgaNLS2sG4Z9UHvUOMTByMhxglOJiVRHjvn1dJ
        EuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoHpSAur+syc
        h1sXL3p/ZL2uLOexL1f8j6rk3isyX3c9wvzkJqZ32lc6l0v/ajGaYhr2etv8dccXSh+flsGU
        v8pt34FtBtMLnXPtSnU9GLIkDQyXGGx88fJDvjN7/H3z/EsVpSzn3TZoWDNf/n3vwZQPTAst
        j+4UmMwxTdTvaa3kj2Prl/8IKrbq4O/g4f/54Fz83v5pz/7PnbCNJ7zshpGYwKqW21yLD/n7
        7Zr1PeLfrJ0W0yfp7qgRdpA32Wfz6ur6vN27p+Q9l1OWt/df5pFV2rl+jjNrzMZ4/4bP13na
        nmcLml3prpMt+/Qs/MYUpqtCFpoJj/4L7ZrF8XvrKTGZsn8Ha/adnyHvp3FuwewyXSWW4oxE
        Qy3mouJEAAC9jsYVAwAA
X-CMS-MailID: 20220308152709epcas5p1f9d274a0214dc462c22c278a72d8697c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152709epcas5p1f9d274a0214dc462c22c278a72d8697c
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152709epcas5p1f9d274a0214dc462c22c278a72d8697c@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Add support to carry out passthrough command with pre-mapped buffers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-map.c           | 45 +++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/ioctl.c | 27 ++++++++++++++---------
 include/linux/blk-mq.h    |  2 ++
 3 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 4526adde0156..027e8216e313 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -8,6 +8,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/uio.h>
+#include <linux/io_uring.h>
 
 #include "blk.h"
 
@@ -577,6 +578,50 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
+/* Unlike blk_rq_map_user () this is only for fixed-buffer async passthrough. */
+int blk_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
+		     u64 ubuf, unsigned long len, gfp_t gfp_mask,
+		     struct io_uring_cmd *ioucmd)
+{
+	struct iov_iter iter;
+	size_t iter_count, nr_segs;
+	struct bio *bio;
+	int ret;
+
+	/*
+	 * Talk to io_uring to obtain BVEC iterator for the buffer.
+	 * And use that iterator to form bio/request.
+	 */
+	ret = io_uring_cmd_import_fixed(ubuf, len, rq_data_dir(rq), &iter,
+			ioucmd);
+	if (unlikely(ret < 0))
+		return ret;
+	iter_count = iov_iter_count(&iter);
+	nr_segs = iter.nr_segs;
+
+	if (!iter_count || (iter_count >> 9) > queue_max_hw_sectors(q))
+		return -EINVAL;
+	if (nr_segs > queue_max_segments(q))
+		return -EINVAL;
+	/* no iovecs to alloc, as we already have a BVEC iterator */
+	bio = bio_alloc(gfp_mask, 0);
+	if (!bio)
+		return -ENOMEM;
+
+	ret = bio_iov_iter_get_pages(bio, &iter);
+	if (ret)
+		goto out_free;
+
+	blk_rq_bio_prep(rq, bio, nr_segs);
+	return 0;
+
+out_free:
+	bio_release_pages(bio, false);
+	bio_put(bio);
+	return ret;
+}
+EXPORT_SYMBOL(blk_rq_map_user_fixedb);
+
 /**
  * blk_rq_unmap_user - unmap a request with user data
  * @bio:	       start of bio list
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 1df270b47af5..91d893eedc82 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -123,8 +123,13 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	return ERR_PTR(ret);
 }
 
+static inline bool nvme_is_fixedb_passthru(struct io_uring_cmd *ioucmd)
+{
+	return ((ioucmd) && (ioucmd->flags & IO_URING_F_UCMD_FIXEDBUFS));
+}
+
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout,
 		struct io_uring_cmd *ioucmd)
@@ -152,8 +157,12 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	nvme_req(req)->flags |= NVME_REQ_USERCMD;
 
 	if (ubuffer && bufflen) {
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-				GFP_KERNEL);
+		if (likely(nvme_is_fixedb_passthru(ioucmd)))
+			ret = blk_rq_map_user_fixedb(q, req, ubuffer, bufflen,
+					GFP_KERNEL, ioucmd);
+		else
+			ret = blk_rq_map_user(q, req, NULL, nvme_to_user_ptr(ubuffer),
+					bufflen, GFP_KERNEL);
 		if (ret)
 			goto out;
 		bio = req->bio;
@@ -260,9 +269,8 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
-			NULL);
+			io.addr, length, metadata, meta_len,
+			lower_32_bits(io.slba), NULL, 0, NULL);
 }
 
 static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
@@ -314,9 +322,8 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
-			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout, NULL);
+			cmd.addr, cmd.data_len, nvme_to_user_ptr(cmd.metadata),
+			cmd.metadata_len, 0, &result, timeout, NULL);
 
 	if (status >= 0) {
 		if (put_user(result, &ucmd->result))
@@ -368,7 +375,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cptr->timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cptr->addr), cptr->data_len,
+			cptr->addr, cptr->data_len,
 			nvme_to_user_ptr(cptr->metadata), cptr->metadata_len,
 			0, &cptr->result, timeout, ioucmd);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d319ffa59354..48bcfd194bdc 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -966,6 +966,8 @@ struct rq_map_data {
 
 int blk_rq_map_user(struct request_queue *, struct request *,
 		struct rq_map_data *, void __user *, unsigned long, gfp_t);
+int blk_rq_map_user_fixedb(struct request_queue *, struct request *,
+		     u64 ubuf, unsigned long, gfp_t,  struct io_uring_cmd *);
 int blk_rq_map_user_iov(struct request_queue *, struct request *,
 		struct rq_map_data *, const struct iov_iter *, gfp_t);
 int blk_rq_unmap_user(struct bio *);
-- 
2.25.1

