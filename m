Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F91B5E776C
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 11:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiIWJmW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 05:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiIWJko (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 05:40:44 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BEC130BE1
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 02:39:21 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220923093919epoutp0262054ec7fce95fa393b2c6f05300c2a3~Xc9gmc2sR0973409734epoutp02Z
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 09:39:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220923093919epoutp0262054ec7fce95fa393b2c6f05300c2a3~Xc9gmc2sR0973409734epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663925959;
        bh=+wv6XISGnAc27o3rE7r/Fm0B0PE4UXnQUUZUaQQ4H7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEKqr+Az2MVYSLjVydyBbRKw2wZleI5+GoJhLAOToo0Dg/j1aLaEwvFc/NeF1gOmV
         /ftg3hU2N/PSw9IpvDnqnJ026SycVo/Q9LQKqpQK3jprOxnmnSepQXoAqHpEjIbMcz
         Qb5Zg5rXUfHx5CoH02DxEPD/9c+xW3DVdSc9iyFE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220923093919epcas5p1e33e36305ae05c5c4e89f27eb01723f6~Xc9gWNfva1518415184epcas5p1K;
        Fri, 23 Sep 2022 09:39:19 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MYnD45hmrz4x9Pp; Fri, 23 Sep
        2022 09:39:16 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.B5.39477.4CE7D236; Fri, 23 Sep 2022 18:39:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67~Xc9duRmlY2720327203epcas5p34;
        Fri, 23 Sep 2022 09:39:16 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220923093916epsmtrp16311bc2cb438514028954b269d8a3f97~Xc9dsp7xm0923409234epsmtrp1e;
        Fri, 23 Sep 2022 09:39:16 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-91-632d7ec40c7b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        97.37.18644.4CE7D236; Fri, 23 Sep 2022 18:39:16 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220923093914epsmtip23faffe90e51f735cce8bda46603e53c0~Xc9byj4JC2545425454epsmtip2L;
        Fri, 23 Sep 2022 09:39:14 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v8 3/5] nvme: refactor nvme_alloc_user_request
Date:   Fri, 23 Sep 2022 14:58:52 +0530
Message-Id: <20220923092854.5116-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923092854.5116-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdlhTS/dInW6ywb7TOhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZ9z8c56poNGs4nPDC7YGxl9aXYycHBICJhLNv/YwdTFycQgJ7GaU2N+6Acr5
        xCix/ukdRpAqIYHPjBJn92fBdLw6cY0domgXo8T83dtZ4Ip2XfLrYuTgYBPQlLgwuRQkLCJg
        JLH/00lWkHpmgRmMEqs7XrODJIQF3CVuT2xlBrFZBFQlZu5/xQRi8wqYS3Tv38sIsUxeYual
        72D1nAIWEos234KqEZQ4OfMJ2F5moJrmrbOZIeq/skvs+RYMcoOEgItET5MuRFhY4tXxLewQ
        tpTEy/42KDtZ4tLMc0wQdonE4z0HoWx7idZT/cwgY5iBXlm/Sx9iE59E7+8nTBDTeSU62oQg
        qhUl7k16ygphi0s8nLEEyvaQuLf6DSskpLoZJbrnz2aawCg/C8kDs5A8MAth2wJG5lWMkqkF
        xbnpqcWmBUZ5qeXwWE3Oz93ECE6RWl47GB8++KB3iJGJg/EQowQHs5II7+w7mslCvCmJlVWp
        RfnxRaU5qcWHGE2BITyRWUo0OR+YpPNK4g1NLA1MzMzMTCyNzQyVxHkXz9BKFhJITyxJzU5N
        LUgtgulj4uCUamAS77/+X69hiyeHY5DsAuUsoxLdn3te7UubfnK9893VOTJ7TCVadX7Ubnj6
        bfok03Nru2xcP2jJ98pVf/xoW8lcNV9PTHftaiG9SGMltbd8f77e0zktI/546gndrNtpy9Yq
        zRCX3hnJICXVnPb54v3PM9hi3rVoP9ly+59h/rm8fKPvIRafvfVUv/PvY15zPt/f2CJqcdwt
        p8xbJ9iPRR0WDpc98T3u9cfLT15tX+XJWHtjv/UPY495Vw/cePinQctv3YH38xN1Zn85NlGr
        sumXZsOF7rZbWRn/7zF+2abfkvXOUtXFu/DwIcZf3176Vd4LmRq+qeJQZ+Y112yVfR8Zjn7Z
        ENlmvYDL0Lh18lsdJZbijERDLeai4kQAhZjwTxoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSvO6ROt1kg+2XhSxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBl3Pxznqmg0azic8MLtgbGX1pdjJwcEgImEq9OXGPv
        YuTiEBLYwSjxYt5xFoiEuETztR/sELawxMp/z6GKPjJKfD0+kbWLkYODTUBT4sLkUpAaEQEz
        iaWH17CA1DALzGGUuHx5D1izsIC7xO2JrcwgNouAqsTM/a+YQGxeAXOJ7v17GSEWyEvMvPQd
        rJ5TwEJi0eZbYDVCQDU/Lr1ghKgXlDg58wnYccxA9c1bZzNPYBSYhSQ1C0lqASPTKkbJ1ILi
        3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4CDX0trBuGfVB71DjEwcjIcYJTiYlUR4Z9/RTBbi
        TUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBKXJV6ZFjHCkC
        dYsjpy/929Q950PsjlV6ymon2AVvPZVfvbxS5H3WUa7cBa2m0TvemWy2YJFPa1rcZOQgoPtb
        67x8h5qHnGfiwa/5LyuqxLa+/9Oo7z6ntuRSYzPvvr2X5293Y7r/1PGepSqHjvr+DadWye/O
        Mtl1b3ZJaERap43DI6mKROcd/ewi89s/Kcs/3BqcW5a9ozLkZ+U1cy/9b9ISchzHs6a2G0WH
        6N4PYL4vs12Vawv7jeJetVeHmj0XPlZRLI+KWRIstOX5wlTXeonUcAYxM6ZzPyvuz3/ZdVPV
        XO4u+6aImTYvq1tfbV/bVbz4nvRr9hL9yg9HdFbtOaPi8erNi0NvRVMETs5RYinOSDTUYi4q
        TgQAZP0ATOECAAA=
X-CMS-MailID: 20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67
References: <20220923092854.5116-1-joshi.k@samsung.com>
        <CGME20220923093916epcas5p387fdd905413f6d90babecf5d14da5b67@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Separate this out to two functions with reduced number of arguments.
While at it, do bit of refactoring in nvme_add_user_metadata too.
_
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 132 +++++++++++++++++++++-----------------
 1 file changed, 74 insertions(+), 58 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 548aca8b5b9f..9537991deac9 100644
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
@@ -45,8 +46,10 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	bip->bip_iter.bi_sector = seed;
 	ret = bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf));
-	if (ret == len)
+	if (ret == len) {
+		req->cmd_flags |= REQ_INTEGRITY;
 		return buf;
+	}
 	ret = -ENOMEM;
 out_free_meta:
 	kfree(buf);
@@ -65,70 +68,67 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
 }
 
 static struct request *nvme_alloc_user_request(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
-		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, void **metap, unsigned timeout, bool vec,
-		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
+		struct nvme_command *cmd, blk_opf_t rq_flags,
+		blk_mq_req_flags_t blk_flags)
 {
-	bool write = nvme_is_write(cmd);
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
-			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
-					meta_seed, write);
-			if (IS_ERR(meta)) {
-				ret = PTR_ERR(meta);
-				goto out_unmap;
-			}
-			req->cmd_flags |= REQ_INTEGRITY;
-			*metap = meta;
+		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
+		kfree(iov);
+	}
+	if (ret)
+		goto out;
+	bio = req->bio;
+	if (bdev)
+		bio_set_dev(bio, bdev);
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
@@ -141,13 +141,19 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	struct bio *bio;
 	int ret;
 
-	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, &meta, timeout, vec, 0, 0);
+	req = nvme_alloc_user_request(q, cmd, 0, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	bio = req->bio;
+	req->timeout = timeout;
+	if (ubuffer && bufflen) {
+		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
+			meta_len, meta_seed, &meta, vec);
+		if (ret)
+			goto out;
+	}
 
+	bio = req->bio;
 	ret = nvme_execute_passthru_rq(req);
 
 	if (result)
@@ -157,6 +163,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 						meta_len, ret);
 	if (bio)
 		blk_rq_unmap_user(bio);
+out:
 	blk_mq_free_request(req);
 	return ret;
 }
@@ -418,6 +425,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	blk_opf_t rq_flags = 0;
 	blk_mq_req_flags_t blk_flags = 0;
 	void *meta = NULL;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -457,13 +465,18 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
 	req->end_io = nvme_uring_cmd_end_io;
 	req->end_io_data = ioucmd;
 
@@ -486,6 +499,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
+out_err:
+	blk_mq_free_request(req);
+	return ret;
 }
 
 static bool is_ctrl_ioctl(unsigned int cmd)
-- 
2.25.1

