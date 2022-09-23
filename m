Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9FDC5E7775
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 11:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiIWJm1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 05:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbiIWJkp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 05:40:45 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA8DB8D
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 02:39:28 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220923093927epoutp039b234e44f788e4ea3aeae8a1fb0c3083~Xc9n5R55s2853728537epoutp03d
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 09:39:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220923093927epoutp039b234e44f788e4ea3aeae8a1fb0c3083~Xc9n5R55s2853728537epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663925967;
        bh=uEbCqf/3/kIIaWvtuL4qPxWr9CHf3MDamuEGmk0zZZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkWUI0K/JW40PJ5otFzQ5KU4KAkw4Z/24yLJ+n7zlgxf/S6u9/FjoBO+3YpGxL9IJ
         DtoXhTlXAJxBvJH6gOx3BZ650mbEzmxav8E7+ukPXVUEMnnUy7luthcGB+IPOUgSFD
         Dh0/motGMUXkIrdye9OPoqmyGt9AWwWKILwR8cQw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220923093927epcas5p47affb341ee557ba0ce3e17b7614b8d58~Xc9nn2iy30959609596epcas5p4M;
        Fri, 23 Sep 2022 09:39:27 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MYnDD2wn8z4x9Q1; Fri, 23 Sep
        2022 09:39:24 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.B5.39477.CCE7D236; Fri, 23 Sep 2022 18:39:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220923093924epcas5p1e1723a3937cb3331c77e55bd1a785e57~Xc9kyfmUH1084110841epcas5p1I;
        Fri, 23 Sep 2022 09:39:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220923093924epsmtrp2e167e498a3f7e874623eb5580b477445~Xc9kxwzQ61242312423epsmtrp27;
        Fri, 23 Sep 2022 09:39:24 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-ad-632d7eccee18
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        89.37.18644.BCE7D236; Fri, 23 Sep 2022 18:39:23 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220923093921epsmtip2e025e3a47044e60cae35a5009e6eb30b~Xc9iyekxE2705227052epsmtip2a;
        Fri, 23 Sep 2022 09:39:21 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v8 5/5] nvme: wire up fixed buffer support for nvme
 passthrough
Date:   Fri, 23 Sep 2022 14:58:54 +0530
Message-Id: <20220923092854.5116-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923092854.5116-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTQ/dMnW6ywZelohar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZ6zdfoypYKFyRePiL2wNjLdkuhg5OSQETCTuHF/C2MXIxSEksJtRYsnOPSwQ
        zidGiU/btzJBOJ8ZJU6cfswI0zJx0npmiMQuRommw9uZ4apOf28GauHgYBPQlLgwuRSkQUTA
        SGL/p5OsIDXMAjMYJVZ3vGYHSQgLREm8mfCUCcRmEVCV+LXrNiuIzStgLvF+yiw2iG3yEjMv
        fQer5xSwkFi0+RYTRI2gxMmZT1hAbGagmuats5kh6n+yS8x+7w5hu0h8f7SGCcIWlnh1fAs7
        hC0l8fndXqj5yRKXZp6DqimReLznIJRtL9F6qp8Z5BdmoF/W79KHWMUn0fv7CdiLEgK8Eh1t
        QhDVihL3Jj1lhbDFJR7OWAJle0js75kIDdFuRokzG46yT2CUn4Xkg1lIPpiFsG0BI/MqRsnU
        guLc9NRi0wKjvNRyeMQm5+duYgQnSi2vHYwPH3zQO8TIxMF4iFGCg1lJhHf2Hc1kId6UxMqq
        1KL8+KLSnNTiQ4ymwCCeyCwlmpwPTNV5JfGGJpYGJmZmZiaWxmaGSuK8i2doJQsJpCeWpGan
        phakFsH0MXFwSjUw+axJOfRtRYfcirxvLbHcMxdExr6Un2r/Y/4R5/Nhc+TeH+VeUXxC3WZS
        /KpOsVnfXawn2NnqnHzHFGB1PvBwyERXjSAVrX0Tj9rwrXHuuLyQUVC1vUacJ+j29GcRissn
        f9eZ08d2bplCbOa9l7FhultMNUzDThyWUHFLn5Ps6XhrSRu3r8S+VavWbTmRFKz94+P+KGWj
        XT2ae2bO9Hkku/KBOKu51+39Wl8Nfun/fHVe5dXdj7ryD5YkvHW4cXmK9NyenuMr5X30r9kz
        it3QfOfG3S4WGL5q3stLfKs25Qi8Do4w16nR1nAPUZu4kOHnE2XJc6+yXi+Wl9Bodzv2tyVz
        oW77rCM/7qipsX2er8RSnJFoqMVcVJwIALXn3pkdBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSvO7pOt1kg899Zhar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorhsUlJzMstSi/TtErgy1m4/xlSwULmicfEXtgbGWzJdjJwcEgImEhMnrWfu
        YuTiEBLYwSjRtOg/C0RCXKL52g92CFtYYuW/5+wQRR8ZJbYsXgtUxMHBJqApcWFyKUiNiICZ
        xNLDa1hAapgF5jBKXL68hx2kRlggQuLFEWeQGhYBVYlfu26zgti8AuYS76fMYoOYLy8x89J3
        sF2cAhYSizbfYgKxhYBqflx6wQhRLyhxcuYTsNuYgeqbt85mnsAoMAtJahaS1AJGplWMkqkF
        xbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMEhrqW1g3HPqg96hxiZOBgPMUpwMCuJ8M6+o5ks
        xJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUAxNTyRHl31Nm
        LXO8WvhzQthW7YVigdMUC8szX0y+2+sZ9sH53BuGQDWN7W9N3ea0n1nDPnXW0ZWdTzK4Nx71
        2bIkmolTyM66d4bnYoEb3Xe8lnDmSL417HkVumTyBKHn6hkyvAxMsjKHAlN0dn049fFTmsk3
        1suW2Rull6XlpQjZ+bHx2nNde1fNVMjncTT/wIWGE1Fqm4xfn3hp6HHm3YMLNqsYvAM7u1bE
        Ttl16tbNX8o/QhVS24/d4LZcdGDX8c0f9XnObvv+0Kf09JP/m6Sedy67cU0xoPs1tz7DPKcb
        E43vd+j6hm803967mu/3QsH/f5gD0r4LWrsyS7/747Dh6rM7LzcoF4XmqQhsXW6hxFKckWio
        xVxUnAgACarZSOACAAA=
X-CMS-MailID: 20220923093924epcas5p1e1723a3937cb3331c77e55bd1a785e57
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220923093924epcas5p1e1723a3937cb3331c77e55bd1a785e57
References: <20220923092854.5116-1-joshi.k@samsung.com>
        <CGME20220923093924epcas5p1e1723a3937cb3331c77e55bd1a785e57@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/nvme/host/ioctl.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 9537991deac9..0464a89c8f5a 100644
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
@@ -91,17 +92,29 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 	struct bio *bio = NULL;
 	void *meta = NULL;
 	int ret;
+	bool fixedbufs = ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED);
 
 	if (!vec)
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-			GFP_KERNEL);
+		if (!fixedbufs)
+			ret = blk_rq_map_user(q, req, NULL,
+					nvme_to_user_ptr(ubuffer), bufflen,
+					GFP_KERNEL);
+		else {
+			struct iov_iter iter;
+
+			ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
+					rq_data_dir(req), &iter, ioucmd);
+			if (ret < 0)
+				goto out;
+			ret = blk_rq_map_user_bvec(req, &iter);
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
@@ -132,7 +145,7 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
@@ -148,7 +161,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	req->timeout = timeout;
 	if (ubuffer && bufflen) {
 		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, &meta, vec);
+			meta_len, meta_seed, &meta, NULL, vec);
 		if (ret)
 			goto out;
 	}
@@ -227,7 +240,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
+			io.addr, length,
 			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
 			false);
 }
@@ -281,7 +294,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &result, timeout, false);
 
@@ -327,7 +340,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &cmd.result, timeout, vec);
 
@@ -471,9 +484,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	req->timeout = d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0;
 
 	if (d.addr && d.data_len) {
-		ret = nvme_map_user_request(req, nvme_to_user_ptr(d.addr),
+		ret = nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, &meta, vec);
+			d.metadata_len, 0, &meta, ioucmd, vec);
 		if (ret)
 			goto out_err;
 	}
-- 
2.25.1

