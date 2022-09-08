Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8525B261C
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiIHSpy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiIHSpu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:45:50 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AC2AA353
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 11:45:41 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220908184538epoutp033b5f36b23ad61107ec64e072c5fb1689~S9vOxWkUL3155431554epoutp03F
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 18:45:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220908184538epoutp033b5f36b23ad61107ec64e072c5fb1689~S9vOxWkUL3155431554epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662662739;
        bh=iwCntG/buA6//VKqNuXAbWrgGiDaWC0bADFiQoNYs8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhNgECboZD4Qf7Y+K5MVLmDEWUipMWjqGB62G3XyhxLVa+G2jnkRYEKErKPv2BTdt
         qXvgWJwYnJsOuGfjGEQRpcEbZcpr56BWstmUtEYwF/+04MRCXAc/KuAYNCk7oWvfss
         4SkXFNq29wHekTaQnPQ3oUVeDp+LSTqd/kMVH8xQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220908184538epcas5p1b71c01e356e2dd7a0ca0daaa1cce0672~S9vOJZK622308423084epcas5p1N;
        Thu,  8 Sep 2022 18:45:38 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MNp3N1qvLz4x9Pt; Thu,  8 Sep
        2022 18:45:36 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.49.54060.0583A136; Fri,  9 Sep 2022 03:45:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220908184535epcas5p1e1f3d8b646d88079c3a7840f79e59508~S9vLonLK00840908409epcas5p1y;
        Thu,  8 Sep 2022 18:45:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220908184535epsmtrp18d7713c7a989ffbf7ac50509cd1e61ad~S9vLnymUV3080730807epsmtrp1f;
        Thu,  8 Sep 2022 18:45:35 +0000 (GMT)
X-AuditID: b6c32a4b-e33fb7000000d32c-d4-631a38505aa4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.DD.14392.F483A136; Fri,  9 Sep 2022 03:45:35 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220908184534epsmtip23a1089d549cf64d4ca50d13174d1cb8a~S9vKSKsR32413824138epsmtip2a;
        Thu,  8 Sep 2022 18:45:34 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v6 3/5] nvme: refactor nvme_alloc_user_request
Date:   Fri,  9 Sep 2022 00:05:09 +0530
Message-Id: <20220908183511.2253-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220908183511.2253-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmlm6AhVSywcqH7BZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
        JYW8xNxUWyUXnwBdt8wcoLuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrF
        ibnFpXnpenmpJVaGBgZGpkCFCdkZyzcfYyuYqFuxdsVH9gbGv8pdjJwcEgImEj9PH2TrYuTi
        EBLYzSjxYWUnlPOJUeL4ydPsEM43RomeZbMZYVp+zNrHDJHYyyjRMeUNVNVnRolvrx6ydDFy
        cLAJaEpcmFwK0iAi4CVx//Z7VpAaZoEZjBKrO16zg9QIC7hLNB6yBalhEVCV6D9xjxnE5hUw
        l3g0/Ts7xDJ5iZmXIGxOAQuJi18eskHUCEqcnPmEBcRmBqpp3job7CAJgb/sEtc+vmSDaHaR
        OH59DQuELSzx6vgWqKFSEi/726DsZIlLM88xQdglEo/3HISy7SVaT/Uzg9zJDPTL+l36ELv4
        JHp/P2ECCUsI8Ep0tAlBVCtK3Jv0lBXCFpd4OGMJlO0hcWfDF2hYdTNKzFvQyT6BUX4Wkhdm
        IXlhFsK2BYzMqxglUwuKc9NTi00LjPNSy+ERm5yfu4kRnDy1vHcwPnrwQe8QIxMH4yFGCQ5m
        JRFe0bUSyUK8KYmVValF+fFFpTmpxYcYTYFhPJFZSjQ5H5i+80riDU0sDUzMzMxMLI3NDJXE
        eadoMyYLCaQnlqRmp6YWpBbB9DFxcEo1MD31VRFPflTIZphqsb6xrsuHaWpll/nPtHtaC+sM
        Tu/fbnJAaCv78oeMsT8j5HtWnW5bOeVzkpXORm3V1hued9ry1dys7GSWhS6qP77+25dtass5
        DS0iY794xBU7PPe9YOa+LLwuImze+Z8ZQdcff4vfdrS6d8MRu6MOOjfPi6dd4Z/JofjF0CpA
        9PaXx8FZs/IiYxWXzC+vqUn389x6IFTn/xm5X+sEms16NLNvr1plcFNv8dErsXss9Lbq15wU
        d/vuEX7zeUJOwBMti2Kfuxl/T1rd43XY4MP3sfVB8uYi12XnrvRLb5HYLGdewlLK2SN/Jcbj
        Q6XI/02VCqubHXSnTy7Ydb9h696sGU8WKrEUZyQaajEXFScCAMggBiQnBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSvK6/hVSywZvXMhZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsDpweO2fdZfe4fLbUY9OqTjaP
        zUvqPXbfbGDz6NuyitHj8ya5APYoLpuU1JzMstQifbsErozlm4+xFUzUrVi74iN7A+Nf5S5G
        Tg4JAROJH7P2MYPYQgK7GSXaZgtCxMUlmq/9YIewhSVW/nsOZHMB1XxklNj/+SpTFyMHB5uA
        psSFyaUgNSICARIHGy+D1TALzGGUuHx5DztIjbCAu0TjIVuQGhYBVYn+E/fAdvEKmEs8mv4d
        ar68xMxLEDangIXExS8P2SDuMZe49mc6VL2gxMmZT1hAbGag+uats5knMArMQpKahSS1gJFp
        FaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcNBrae5g3L7qg94hRiYOxkOMEhzMSiK8
        omslkoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgal+x
        9Oa23mmRpx2LeSx59nK8TVdJKpwXYsgd6XPCKVRM+9zXh85FK/5oCvpfXX/8+XWdIuduzu1r
        YtmvtJis/xc6+bn37qs7W5bsjPwXeKJu+qnMHMYJjx4c318cOdt56cG2BlnBJ2/YExJruo6X
        8ITt53kefXZeyL9v2jw/7OyZND9eUl5rNnNryVvTJDn/WfmPq+LTVNVnbjf4+vfZsw/524UF
        3lyddtuor+nMgukfOLwt9M+0/yie63M7Slw6qnL9JYk3C3NaIxdI9goFa+x4Uvn20Qq9y+5y
        AmwqO0o3vpLcysw17cPhILcNR2w7lDve1k7ba2mpvkdm8alrPn8iznzrur5adPdzsdAdS5VY
        ijMSDbWYi4oTAUsPDlrpAgAA
X-CMS-MailID: 20220908184535epcas5p1e1f3d8b646d88079c3a7840f79e59508
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220908184535epcas5p1e1f3d8b646d88079c3a7840f79e59508
References: <20220908183511.2253-1-joshi.k@samsung.com>
        <CGME20220908184535epcas5p1e1f3d8b646d88079c3a7840f79e59508@epcas5p1.samsung.com>
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

