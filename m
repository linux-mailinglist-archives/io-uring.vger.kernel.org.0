Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18AC5ECB92
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 19:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiI0Rtb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 13:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiI0RtA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 13:49:00 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D0FC8432
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 10:46:39 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220927174637epoutp03b43defb46c563e0e513c1363f8707ebf~YyMH2qnI63168031680epoutp03D
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 17:46:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220927174637epoutp03b43defb46c563e0e513c1363f8707ebf~YyMH2qnI63168031680epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664300797;
        bh=OWfX54HqbvG9emkZ5yG9m2A9p0d53tVfjUM9ft+8e3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6gE+UyDo0EWwXCPLeGcheXd9xcTdXGbQb2dSSusXf+36E34SgXM7aYPg/i/+JNrB
         4D86S3I8grNNB8MIlBFzYCfvPPo7jUeNVuBdZY2/67ClMQiWuLeOGg5sBKwShDLgKP
         YqBVP3pNuOATvaD4ytNMyEIZjSgsPElN+uwVejlc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220927174637epcas5p389de44897f5bc729b521d7a889e59ab7~YyMHcUzyY2603326033epcas5p30;
        Tue, 27 Sep 2022 17:46:37 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4McRrV5Vxsz4x9Pw; Tue, 27 Sep
        2022 17:46:34 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        64.1F.39477.AF633336; Wed, 28 Sep 2022 02:46:34 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220927174633epcas5p4d492bdebde981e2c019e30c47cf00869~YyMEZTz5x2946229462epcas5p4E;
        Tue, 27 Sep 2022 17:46:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220927174633epsmtrp2bc3676dfacf0cb26cbc2a3aaaec08337~YyMEYjynK3251332513epsmtrp2h;
        Tue, 27 Sep 2022 17:46:33 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-93-633336faf885
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A9.1D.14392.9F633336; Wed, 28 Sep 2022 02:46:33 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220927174632epsmtip1ee91eb40496b2853f7e8867313b472f1~YyMDB-hgn0699206992epsmtip1T;
        Tue, 27 Sep 2022 17:46:32 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v10 4/7] nvme: refactor nvme_alloc_request
Date:   Tue, 27 Sep 2022 23:06:07 +0530
Message-Id: <20220927173610.7794-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927173610.7794-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkk+LIzCtJLcpLzFFi42LZdlhTQ/eXmXGyQc80bYvVd/vZLG4e2Mlk
        sXL1USaLd63nWCyO/n/LZjHp0DVGi723tC3mL3vK7sDhcflsqcemVZ1sHpuX1HvsvtnA5tG3
        ZRWjx+dNcgFsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
        um6ZOUDXKCmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkus
        DA0MjEyBChOyM9bOvcJecFa3ouHcesYGxiUqXYycHBICJhLvJ11nBrGFBHYzSrxcXNLFyAVk
        f2KU+LfnHQuE841R4t2bVSwwHXvmX2OGSOxllFhw8wsbhPOZUWLWuy1AGQ4ONgFNiQuTS0Ea
        RASMJPZ/OskKUsMsMINRYnXHa3aQhLCAs8SJKQeZQGwWAVWJyZf+sYHYvALmEt93bGSF2CYv
        MfPSd3aQmZwCFhKHP2ZClAhKnJz5BOwgZqCS5q2zwQ6SEPjKLvHqTBsTRK+LRFPjS3YIW1ji
        1fEtULaUxOd3e9kg7GSJSzPPQdWXSDzecxDKtpdoPdUP9gsz0C/rd+lD7OKT6P39hAkkLCHA
        K9HRJgRRrShxb9JTqIvFJR7OWAJle0g82TQLGlbdjBKbv05knMAoPwvJC7OQvDALYdsCRuZV
        jJKpBcW56anFpgVGeanl8HhNzs/dxAhOk1peOxgfPvigd4iRiYPxEKMEB7OSCO/vo4bJQrwp
        iZVVqUX58UWlOanFhxhNgUE8kVlKNDkfmKjzSuINTSwNTMzMzEwsjc0MlcR5F8/QShYSSE8s
        Sc1OTS1ILYLpY+LglGpgYjoQeazPY9KPxYzBabsvubrP4vHiOyx6xFbr2j6OiDP9iX/2sf0+
        eHyVkT9va8QjjpuBGtN9P894XmDzYvcEk+rQd0pyh47vvJ8kyfhwymLTPmsJNh6hoGL3w77n
        NzyedYZDRu/Z6ict3JbnC7i/b+rYueHQz5LLgq0CE7LUl53gehY0aUOW/w9Zh/iXX2e5sMfF
        Gyco5DUy3ipizf21p1Lvw23F1Z6v9n4xWbC5e67eti0v6g+HcU1K3Fk3q/U3s/qbpvf1TBdf
        ZBrfuFGyy8uBQ+mQ2yTP9q8WxXMm9L+QCZBhdt1RH7N0Y00x89tLpiHbD8tbXKkt9nkw45nr
        jg39lzI1hV7M4Wmsq7sXpsRSnJFoqMVcVJwIAAWpIJccBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSnO5PM+NkgwP7jS1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBlrJ17hb3grG5Fw7n1jA2MS1S6GDk5JARMJPbMv8bc
        xcjFISSwm1Fiz74brBAJcYnmaz/YIWxhiZX/nrNDFH1klDj/+CtQBwcHm4CmxIXJpSA1IgJm
        EksPr2EBqWEWmMMocfnyHrBmYQFniRNTDjKB2CwCqhKTL/1jA7F5Bcwlvu/YCLVMXmLmpe/s
        IDM5BSwkDn/MBAkLAZVs3fSBBaJcUOLkzCdgNjNQefPW2cwTGAVmIUnNQpJawMi0ilEytaA4
        Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOMS1NHcwbl/1Qe8QIxMH4yFGCQ5mJRHe30cNk4V4
        UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgineT7d+0tCQ+
        V+ZBv3bGtvPbe12Uj3TPjfvUuqufQ2JV0ETdNI/O/1WuPoz735rpnr74kWtLn0tdmUYL//qN
        iRuVDnd580/gcrkvdu/i5t0vTQot68R5JRf/uML2x+P11TkRF9V+WOdNPdjOxbD2pKGXlqyU
        +LT//5v5HkQv4p3KnBXzc/3/y+dyWS3Mk1kcY47v8dr5Nizpofqi9FCz5dd3LPOKvbJoyZoo
        1qgmw7R2yQ/d79bbaBWKbuyttG19uFv7y6PJ9aJ9RkcXetwxiTTwub/uieki9mU/G06V3VWc
        9yPTLXHv3ishaccMmqZ82MMubcyRHV1Rauef4sBksZRnx8JXt5c/4FCufxeuxFKckWioxVxU
        nAgAHlwmQOACAAA=
X-CMS-MailID: 20220927174633epcas5p4d492bdebde981e2c019e30c47cf00869
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220927174633epcas5p4d492bdebde981e2c019e30c47cf00869
References: <20220927173610.7794-1-joshi.k@samsung.com>
        <CGME20220927174633epcas5p4d492bdebde981e2c019e30c47cf00869@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

nvme_alloc_alloc_request expects a large number of parameters.
Split this out into two functions to reduce number of parameters.
First one retains the name nvme_alloc_request, while second one is
named nvme_map_user_request.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 121 ++++++++++++++++++++++----------------
 1 file changed, 69 insertions(+), 52 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 8f8435b55b95..b9f17dc87de9 100644
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
-			meta = nvme_add_user_metadata(req, meta_buffer, meta_len,
-					meta_seed);
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
@@ -144,13 +145,19 @@ static int nvme_submit_user_cmd(struct request_queue *q,
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
+				meta_len, meta_seed, &meta, vec);
+		if (ret)
+			goto out;
+	}
 
+	bio = req->bio;
 	ret = nvme_execute_passthru_rq(req);
 
 	if (result)
@@ -160,6 +167,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 						meta_len, ret);
 	if (bio)
 		blk_rq_unmap_user(bio);
+out:
 	blk_mq_free_request(req);
 	return ret;
 }
@@ -421,6 +429,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	blk_opf_t rq_flags = 0;
 	blk_mq_req_flags_t blk_flags = 0;
 	void *meta = NULL;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -460,13 +469,18 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
 
@@ -489,6 +503,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
+out_err:
+	blk_mq_free_request(req);
+	return ret;
 }
 
 static bool is_ctrl_ioctl(unsigned int cmd)
-- 
2.25.1

