Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20EF95B3547
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 12:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiIIKb4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 06:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiIIKbx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 06:31:53 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA82649B5E
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 03:31:49 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220909103147epoutp045c6674c67a16e615a0090f1a6ca12aa0~TKpUqwzgj1577515775epoutp043
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 10:31:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220909103147epoutp045c6674c67a16e615a0090f1a6ca12aa0~TKpUqwzgj1577515775epoutp043
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662719507;
        bh=iwCntG/buA6//VKqNuXAbWrgGiDaWC0bADFiQoNYs8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdrwQGAhjWRcs22CXHxot5tGPYA8fgBohq32j0Pox2B0u93NoHTU3numwTv2mD8CP
         sHW4v5WMvdYv17WW3l6B1O6u7Cf5dWfoJQ9ewXsdnXlzLYVgMWxGYjE4u6xSICjn2x
         xPKteFh3t8V/hOLhcBuDfjcMfa7zx7C9DrmBBbH4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220909103147epcas5p4e37f6ea1b82217bbe6fc03bc6ba37dd1~TKpUVTjED2796827968epcas5p4P;
        Fri,  9 Sep 2022 10:31:47 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MPC342YmCz4x9Pr; Fri,  9 Sep
        2022 10:31:44 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.AA.53458.0161B136; Fri,  9 Sep 2022 19:31:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220909103143epcas5p2eda60190cd23b79fb8f48596af3e1524~TKpRLuilw0262302623epcas5p2G;
        Fri,  9 Sep 2022 10:31:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220909103143epsmtrp14a446390ad00524c8bb9ed4deabd9867~TKpRKxZvl1097010970epsmtrp1K;
        Fri,  9 Sep 2022 10:31:43 +0000 (GMT)
X-AuditID: b6c32a4a-caffb7000000d0d2-7a-631b16103a7f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.B1.18644.F061B136; Fri,  9 Sep 2022 19:31:43 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220909103142epsmtip16b732d9bcf4129c4673f669599b95ed7~TKpP1-Gnv1204612046epsmtip1Z;
        Fri,  9 Sep 2022 10:31:42 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v7 3/5] nvme: refactor nvme_alloc_user_request
Date:   Fri,  9 Sep 2022 15:51:34 +0530
Message-Id: <20220909102136.3020-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909102136.3020-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsWy7bCmlq6AmHSyweElLBZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
        JYW8xNxUWyUXnwBdt8wcoLuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrF
        ibnFpXnpenmpJVaGBgZGpkCFCdkZyzcfYyuYqFuxdsVH9gbGv8pdjJwcEgImErO2f2TtYuTi
        EBLYzSjx5+hfJgjnE6PEkrOH2SCcz4wS55pXs8K0bJ87kx0isYtR4vrm9+xwVb33zgA5HBxs
        ApoSFyaXgjSICHhJ3L/9HmwHs8AMRonVHa/ZQRLCAu4S0/80sIHYLAKqEt9a94LFeQXMJU7e
        fsMGsU1eYual72BxTgELicmfr0HVCEqcnPmEBcRmBqpp3jqbGWSBhEAjh8Sf74eYIZpdJD71
        LYc6W1ji1fEt7BC2lMTL/jYoO1ni0sxzTBB2icTjPQehbHuJ1lP9zCDPMAM9s36XPsQuPone
        30+YQMISArwSHW1CENWKEvcmPYXaJC7xcMYSKNtDonHNOxZI+HQzStzcv595AqP8LCQvzELy
        wiyEbQsYmVcxSqYWFOempxabFhjlpZbDYzY5P3cTIzh9anntYHz44IPeIUYmDsZDjBIczEoi
        vKJrJZKFeFMSK6tSi/Lji0pzUosPMZoCw3gis5Rocj4wgeeVxBuaWBqYmJmZmVgamxkqifNO
        0WZMFhJITyxJzU5NLUgtgulj4uCUamCacn/9j5vym4/opM3OsGPzmpXbJa1qELl46i6l5MqA
        XyY7lm+9lmBuzXMj47Hk9NVHDzz5czz8c8FkU24Pg01HmL6+NKuc5SbEqhdYwv7zUq7bg2TW
        8PAzX1++Mb/15/MHhqXr7O5ZvtKqrYjYsrPORF5jw2oBHZvZT59FGelMOnNr+tGkxCKfKmNd
        s3JOhfwnla5bbsg5F0q93vgoLGupHvuWxGjzK6bWv6eeNzfJ8WnuP5zX/N8lWq7ntv2Bht8Z
        +3+G7Oa5kOGtuFp5kYDyxPrkwPg90fVpO3MPz9mxKqWy85B05m6+hJ/pzyz83kldmhv+5sji
        eP3D1Wc6Yurieh7vNfh/o0NgQcsZIU0lluKMREMt5qLiRADoF8acKAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWy7bCSnC6/mHSywcmNOhZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APYoLpuU1JzMstQifbsErozlm4+xFUzUrVi74iN7A+Nf5S5G
        Tg4JAROJ7XNnsncxcnEICexglHh97BUzREJcovnaD3YIW1hi5b/nUEUfGSU+vF3L0sXIwcEm
        oClxYXIpSI2IQIDEwcbLYDXMAnMYJS5f3gPWLCzgLjH9TwMbiM0ioCrxrXUvWJxXwFzi5O03
        bBAL5CVmXvoOFucUsJCY/PkamC0EVPN65ycWiHpBiZMzn4DZzED1zVtnM09gFJiFJDULSWoB
        I9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgwNfS2sG4Z9UHvUOMTByMhxglOJiV
        RHhF10okC/GmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cBU
        L6O9TeKTdtk/05vzf7XYlEs0qd6I4e9i8ZA6prnCTM5KNtMrY/7Dgp/HxJX0PnEIPn3KI/Er
        8lSnmWj3u0vRx1eaMk887jenw/bgMvGMr9VPc6Oa3zNIfVn987/Tockh5zt3Hpzy7t7n9Fnq
        GX8dVaP5jnw2X/dXevkFDmstR3UZyUtRzvIBPCGl4kWRqv+skq27GNZJCFZE8r9csXmZz6rZ
        W184yqicb1ILWGy8Zqrnj3MNXQu4Oj4EFQV93WM/zXzm/2nL/7ZzdfxRzXpkrZhzuJv/Zv2+
        H/9sJmt8VLaS6rxWv7rCwqxnW18mc4fT9NgtLBoWn7gXLfEU/r56aYg15yJf0+W8Pre3KCqx
        FGckGmoxFxUnAgCGjsA36wIAAA==
X-CMS-MailID: 20220909103143epcas5p2eda60190cd23b79fb8f48596af3e1524
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220909103143epcas5p2eda60190cd23b79fb8f48596af3e1524
References: <20220909102136.3020-1-joshi.k@samsung.com>
        <CGME20220909103143epcas5p2eda60190cd23b79fb8f48596af3e1524@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Separate this out to two functions with reduced number of arguments.
_
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 116 ++++++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 50 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 548aca8b5b9f..cb2fa4db50dd 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -65,18 +65,10 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
 }
 
 static struct request *nvme_alloc_user_request(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
-		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, void **metap, unsigned timeout, bool vec,
+		struct nvme_command *cmd, unsigned timeout,
 		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)
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
@@ -86,49 +78,61 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 	if (timeout)
 		req->timeout = timeout;
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
+	if (!ubuffer || !bufflen)
+		return 0;
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
+	bio = req->bio;
+	if (ret)
+		goto out_unmap;
+	if (bdev)
+		bio_set_dev(bio, bdev);
+	if (bdev && meta_buffer && meta_len) {
+		meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
+				meta_seed, req_op(req) == REQ_OP_DRV_OUT);
+		if (IS_ERR(meta)) {
+			ret = PTR_ERR(meta);
+			goto out_unmap;
 		}
+		req->cmd_flags |= REQ_INTEGRITY;
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
@@ -141,13 +145,16 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	struct bio *bio;
 	int ret;
 
-	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, &meta, timeout, vec, 0, 0);
+	req = nvme_alloc_user_request(q, cmd, timeout, 0, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	bio = req->bio;
+	ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
+			meta_len, meta_seed, &meta, vec);
+	if (ret)
+		goto out;
 
+	bio = req->bio;
 	ret = nvme_execute_passthru_rq(req);
 
 	if (result)
@@ -157,6 +164,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 						meta_len, ret);
 	if (bio)
 		blk_rq_unmap_user(bio);
+out:
 	blk_mq_free_request(req);
 	return ret;
 }
@@ -418,6 +426,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	blk_opf_t rq_flags = 0;
 	blk_mq_req_flags_t blk_flags = 0;
 	void *meta = NULL;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -457,13 +466,17 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		rq_flags |= REQ_POLLED;
 
 retry:
-	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
-			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, &meta, d.timeout_ms ?
-			msecs_to_jiffies(d.timeout_ms) : 0, vec, rq_flags,
-			blk_flags);
+	req = nvme_alloc_user_request(q, &c,
+			d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0,
+			rq_flags, blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
+
+	ret = nvme_map_user_request(req, nvme_to_user_ptr(d.addr),
+			d.data_len, nvme_to_user_ptr(d.metadata),
+			d.metadata_len, 0, &meta, vec);
+	if (ret)
+		goto out_err;
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

