Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B25E47B8B0
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhLUC4q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:56:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13028 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbhLUC4q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:56:46 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211221025644epoutp0168f315aa0e24f00216cef4667df6eafc~CpbOCWrB-1840218402epoutp01Y
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:56:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211221025644epoutp0168f315aa0e24f00216cef4667df6eafc~CpbOCWrB-1840218402epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055404;
        bh=bss9OWagJehTewuWFbdwSOhXbbsGjfeINSnWwzxnnh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPZsbuQEMmLoq0MLmV/IY2HX5HsMXuubluPaCD5A+srVPoySkG7nmIjk20sLnKREO
         lmP8U1U7id3q8TECkgnnPRlTQE5/91pdvS9w7dHrqihi4mEMJ55FqMdIVeEr1nnOsL
         YlIxaVEhqRjgssUfH6PLRvqWCszwofLIewVx4VOM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20211221025644epcas5p292b210d7cc5dfdfa8f79b3bed0d1ac8f~CpbNfxEBe2587925879epcas5p2Q;
        Tue, 21 Dec 2021 02:56:44 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4JJ1Lw3z2rz4x9Px; Tue, 21 Dec
        2021 02:56:40 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.02.46822.86241C16; Tue, 21 Dec 2021 11:56:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20211220142242epcas5p45dddab51a9f20a8ec3d8b8e4f1dda40a~CfI2l8kWO2261322613epcas5p4s;
        Mon, 20 Dec 2021 14:22:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142242epsmtrp1aa7f27bbe814be26ba5fadc58ea0a8e6~CfI2lQtPn2445924459epsmtrp1g;
        Mon, 20 Dec 2021 14:22:42 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-d7-61c142687e44
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B6.85.29871.1B190C16; Mon, 20 Dec 2021 23:22:41 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142239epsmtip182586cf1250a6f94ad6f3bf56893816f~CfI0O3QeY0637906379epsmtip1q;
        Mon, 20 Dec 2021 14:22:39 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 07/13] nvme: enable passthrough with fixed-buffer
Date:   Mon, 20 Dec 2021 19:47:28 +0530
Message-Id: <20211220141734.12206-8-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmlm6G08FEg1PvpCyaJvxltlh9t5/N
        YuXqo0wW71rPsVh0nr7AZHH+7WEmi0mHrjFa7L2lbTF/2VN2izU3n7I4cHnsnHWX3aN5wR0W
        j8tnSz02repk89i8pN5j980GNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnfHo5QGmgmPaFat/r2duYHyg3MXIwSEh
        YCJxtNe7i5GLQ0hgN6NE085PLBDOJ0aJA2+uMEI43xglDn98BZThBOv4/u8WVGIvo8Tj32fY
        QRJCAp8ZJT5dYQEZyyagKXFhcilIWEQgWuLC82tsIDazQAejxM5uWxBbWMBeYuvTt2AzWQRU
        JR6s/g9WwytgIdF45C87xC55iZmXvoPZnAKWEodnL4OqEZQ4OfMJC8RMeYnmrbOZQe6REJjI
        IfF891JmiNdcJL4/cIaYIyzx6vgWqJlSEi/726DsYolfd45C9QLddr1hJtST9hIX9/xlApnD
        DPTL+l36EGFZiamn1jFB7OWT6P39hAkiziuxYx6MrShxb9JTVghbXOLhjCWsEOd4SPyZLgEJ
        th5Gif7NN1kmMCrMQvLOLCTvzELYvICReRWjZGpBcW56arFpgVFeajk8ipPzczcxgpOsltcO
        xocPPugdYmTiYDzEKMHBrCTCu2X2/kQh3pTEyqrUovz4otKc1OJDjKbA8J7ILCWanA9M83kl
        8YYmlgYmZmZmJpbGZoZK4ryn0zckCgmkJ5akZqemFqQWwfQxcXBKNTBlzJebsGWOkWfmkz3N
        Uf+XvH+oUm/DEVBhdfiQg/wpxplNy0T+MlQsCbBLOrPb8/4LxTnzLd68SFL8Xa5bNLXNYvvJ
        oNpL1yVY/I8osmuf5jlUqvkgcdtP7dd/OwPLps374mPKJpCm5aATZ6hfJ6WWcf7e6R1Zc4+W
        ecXx7V7s7Xvsc+ynXTeb32mrCui8/SCVcKWhJ/OLzUWdSrc7ld9ZPDxtrPRDt06LP3Fx+b9n
        n9keHXjh2JWbI+65UKsi+Xnh5Nz2GSK7J+80nD6lOO3/2h9ey+VXHZcMXBDy6NNOVyNuJsmg
        OnXJU2weXcv5zj/UtHzfHZBiPcvCoHvRhilzNC37Vhezfv67hF3wQqYSS3FGoqEWc1FxIgBS
        p/JzOwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWy7bCSnO7GiQcSDb6+t7ZomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr49HLA0wFx7Qr
        Vv9ez9zA+EC5i5GTQ0LAROL7v1uMXYxcHEICuxkl7p9pYYRIiEs0X/vBDmELS6z895wdougj
        o8TPo++Yuxg5ONgENCUuTC4FqRERiJX48OsYE0gNs8AkRokN/Q/AmoUF7CW2Pn3LAmKzCKhK
        PFj9nw3E5hWwkGg88hdqgbzEzEvfwWxOAUuJw7OXgdUIAdWc+PCFBaJeUOLkzCdgNjNQffPW
        2cwTGAVmIUnNQpJawMi0ilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOBq0NHcwbl/1
        Qe8QIxMH4yFGCQ5mJRHeLbP3JwrxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7
        NbUgtQgmy8TBKdXANEN9VTnn/HcdFmI9zzY8u7Nj9RLuVt/Uu9m2L1ff0FVv1MkziUspNorl
        lD5/qU+R+T6D64bHXle3/me1TijWf90UFPHb6IAiY1H0rr+ne6dETQs/WfNwybr3hhYR9d9z
        1XdvEq7qaVVkMlv1eWfKZlfHOKE70d9nGc56//2C5OEjmZfVFPQ8ueOds89lbFD78nN1vXLY
        DKfg3J8pvxUUvvTU/nnFcP/+lKgdE0026i2bab7zo39DYO+eJWKL+KQYgl8yHuBveu9ns6H2
        bPQWN4bXZ/ZEpLb+rni5KOSPF0vJtP+Vu1refUpwmvWk1rxXfzJ3jSvjTt9/p9mnLKyM2dvV
        w+F1LP6V67bOzaoxSizFGYmGWsxFxYkAgFq2cfUCAAA=
X-CMS-MailID: 20211220142242epcas5p45dddab51a9f20a8ec3d8b8e4f1dda40a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142242epcas5p45dddab51a9f20a8ec3d8b8e4f1dda40a
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142242epcas5p45dddab51a9f20a8ec3d8b8e4f1dda40a@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support to carry out passthrough command with pre-mapped buffers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/blk-map.c           | 46 +++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/ioctl.c | 30 +++++++++++++++----------
 include/linux/blk-mq.h    |  3 +++
 3 files changed, 67 insertions(+), 12 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 4526adde0156..9aa9864eab55 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -8,6 +8,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/uio.h>
+#include <linux/io_uring.h>
 
 #include "blk.h"
 
@@ -577,6 +578,51 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
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
+	bio->bi_opf |= req_op(rq);
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
index 7d9c51d9c0a8..dc6a5f1b81ca 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -131,8 +131,13 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	return ERR_PTR(ret);
 }
 
+static inline bool nvme_is_fixedb_passthru(struct io_uring_cmd *ioucmd)
+{
+	return ((ioucmd) && (ioucmd->flags & URING_CMD_FIXEDBUFS));
+}
+
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout,
 		struct io_uring_cmd *ioucmd)
@@ -154,8 +159,12 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	nvme_req(req)->flags |= NVME_REQ_USERCMD;
 
 	if (ubuffer && bufflen) {
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-				GFP_KERNEL);
+		if (likely(!nvme_is_fixedb_passthru(ioucmd)))
+			ret = blk_rq_map_user(q, req, NULL, nvme_to_user_ptr(ubuffer),
+					bufflen, GFP_KERNEL);
+		else
+			ret = blk_rq_map_user_fixedb(q, req, ubuffer, bufflen,
+					GFP_KERNEL, ioucmd);
 		if (ret)
 			goto out;
 		bio = req->bio;
@@ -254,9 +263,8 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
-			NULL);
+			io.addr, length, metadata, meta_len,
+			lower_32_bits(io.slba), NULL, 0, NULL);
 }
 
 static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
@@ -308,9 +316,8 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
-			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout, NULL);
+			cmd.addr, cmd.data_len, nvme_to_user_ptr(cmd.metadata),
+			cmd.metadata_len, 0, &result, timeout, NULL);
 
 	if (status >= 0) {
 		if (put_user(result, &ucmd->result))
@@ -355,9 +362,8 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
-			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &cmd.result, timeout, ioucmd);
+			cmd.addr, cmd.data_len, nvme_to_user_ptr(cmd.metadata),
+			cmd.metadata_len, 0, &cmd.result, timeout, ioucmd);
 
 	if (!ioucmd && status >= 0) {
 		if (put_user(cmd.result, &ucmd->result))
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 30e54ab05333..a82b054eebde 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -922,6 +922,9 @@ struct rq_map_data {
 
 int blk_rq_map_user(struct request_queue *, struct request *,
 		struct rq_map_data *, void __user *, unsigned long, gfp_t);
+int blk_rq_map_user_fixedb(struct request_queue *, struct request *,
+		     u64 ubuf, unsigned long, gfp_t,
+		     struct io_uring_cmd *);
 int blk_rq_map_user_iov(struct request_queue *, struct request *,
 		struct rq_map_data *, const struct iov_iter *, gfp_t);
 int blk_rq_unmap_user(struct bio *);
-- 
2.25.1

