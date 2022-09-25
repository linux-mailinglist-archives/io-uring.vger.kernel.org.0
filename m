Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC485E95F3
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 22:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbiIYUd6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 16:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbiIYUdv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 16:33:51 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBAD2C66A
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 13:33:46 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220925203344epoutp0276851c72a4a6edf998537fad4c3dbb95~YNLdclxAz0567005670epoutp02r
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 20:33:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220925203344epoutp0276851c72a4a6edf998537fad4c3dbb95~YNLdclxAz0567005670epoutp02r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664138024;
        bh=3A/lgcvkDGVjeLIHZ4//Y527GGsAiDQHEVnPedJDOak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTO6wvIjGoc/6gToX9oFuSDO/RwibMHGuoR1HD9IrM2PtDcpUyWHIUxqIzMTnzn/x
         ZkqWzfSI7ALRKQyz/1GmIW7ua9jAmf3//0FvbTiQoeHIY/18WBpGTijYuklLsssRps
         4rq5WYz0dZB9MphJ4F5tBq2/KJTYjHxj4dKjbYow=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220925203343epcas5p43cb2a8a5a1be684719c3999ac01d90e0~YNLcXUpGs2832328323epcas5p4C;
        Sun, 25 Sep 2022 20:33:43 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MbHfF1NmBz4x9Pq; Sun, 25 Sep
        2022 20:33:41 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.AF.26992.42BB0336; Mon, 26 Sep 2022 05:33:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220925203340epcas5p21bd73962a73c36c7bd56841299c0d229~YNLZy-Zs10635906359epcas5p2b;
        Sun, 25 Sep 2022 20:33:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220925203340epsmtrp21c70fa682ece6af7df1b29015edba3b1~YNLZyUb9Q1586315863epsmtrp2N;
        Sun, 25 Sep 2022 20:33:40 +0000 (GMT)
X-AuditID: b6c32a49-319fb70000016970-33-6330bb245163
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.1A.18644.42BB0336; Mon, 26 Sep 2022 05:33:40 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220925203338epsmtip1f20161add80368655d19994a5028e4c0~YNLXi3WkZ3161131611epsmtip1X;
        Sun, 25 Sep 2022 20:33:37 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next v9 7/7] nvme: wire up fixed buffer support for nvme
 passthrough
Date:   Mon, 26 Sep 2022 01:53:04 +0530
Message-Id: <20220925202304.28097-8-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220925202304.28097-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTQ1d1t0Gywdt9zBar7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLSoWuMFntvaVvMX/aU3YHD4/LZUo9NqzrZPDYvqffYfbOBzaNv
        yypGj8+b5ALYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
        dN0yc4CuUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZY
        GRoYGJkCFSZkZ7y/2s5e8EO14vSXFSwNjG/luhg5OSQETCS2zdzL0sXIxSEksJtRYtuS+UwQ
        zidGiR+r1jJCOJ8ZJb6ensUK03Jj7gpmEFtIYBejxJ2HqXBF1443s3UxcnCwCWhKXJhcClIj
        ImAksf/TSVaQGmaBGYwSqztes4PUCAtESaz7XQFSwyKgKrHs3VcWEJtXwEJi6bRpTBC75CVm
        XvrODmJzClhKPJm7lRmiRlDi5MwnYPXMQDXNW2czg8yXEPjILvH8aRfYDRICLhILdplBzBGW
        eHV8CzuELSXx+d1eNgg7WeLSzHNQu0okHu85CGXbS7Se6mcGGcMM9Mr6XfoQq/gken8/YYKY
        zivR0SYEUa0ocW/SU2joiEs8nLEEyvaQ2NfVxA4JnR5GibVTH7FNYJSfheSDWUg+mIWwbQEj
        8ypGydSC4tz01GLTAsO81HJ4tCbn525iBCdJLc8djHcffNA7xMjEwXiIUYKDWUmEN+WibrIQ
        b0piZVVqUX58UWlOavEhRlNgEE9klhJNzgem6bySeEMTSwMTMzMzE0tjM0Mlcd7FM7SShQTS
        E0tSs1NTC1KLYPqYODilGpgsS7wSdi/Wm/2OzVVXb32gw7ZiqT+cl9s2Xbup9dVD8+239SrB
        Bi5MTLO4Gxmeres2WazWuvz7khfCc6+2MqnxL203zuSTOeysW+c7a0WfYt2sU5JH5+3coPRL
        i1d02+PXLh01CmlC5rJFH5xfXH7FIsm1fGniX8F/8Z+m/T12KyzlJF9VjKF5EEdSzandrgWP
        hCa+rGOxEgzYHRG0z2cNe/261LiTk65/DywQerHjjFnwVecpPIIe6pnq8bsrlN4tuPcvKEPL
        pvSBjumyqL9hbBkp09qm39my7PKupO8zbK1yHO0e+jzQ8+9IXcO6Ys5f9YUXDp8PCo0Ndl+V
        q1Wx7NXP5VbTWYxTOE5OnaHEUpyRaKjFXFScCAD9rXHUGwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSnK7KboNkg4UTJCxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8WkQ9cYLfbe0raYv+wpuwOHx+WzpR6bVnWyeWxeUu+x+2YDm0ff
        llWMHp83yQWwRXHZpKTmZJalFunbJXBlvL/azl7wQ7Xi9JcVLA2Mb+W6GDk5JARMJG7MXcHc
        xcjFISSwg1Fi39wdTBAJcYnmaz/YIWxhiZX/nrNDFH1klJjX/xHI4eBgE9CUuDC5FKRGRMBM
        YunhNSwgNcwCcxglLl/eA9YsLBAhsWrSO2YQm0VAVWLZu68sIDavgIXE0mnToJbJS8y89B2s
        nlPAUuLJ3K3MIPOFgGq2nteCKBeUODnzCVgrM1B589bZzBMYBWYhSc1CklrAyLSKUTK1oDg3
        PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4xLW0djDuWfVB7xAjEwfjIUYJDmYlEd6Ui7rJQrwp
        iZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTBJ8Pc/82H/9q9j
        3VPdl/+iNy09xMbVMVM5Nv7N8e2yN0U+vlLR6edlSTh7+KEES9er6G/SLQuaYvwivY8xfQty
        u18m9n7XLP2d/+TnTXRuV1dXda87tXbXXp7A7k7ljYHC9Zqtb/fxxhUZXKlsuCY6abFHzhIO
        gzaRZ2xrl82rK/zHts6zotBi0o/OU89v8VSuWNaaJbTCKfkY6wWmp9f/LGO6KBPIbcN2dGLz
        9r7UsEqJk9O0ZNuLNQxeidjN4Gy+E1LynzvNWc99QZMmZ526y5P50vrRLP6KCwWy9XpW2U1b
        3qY28wRXZPeZBMHoSS0s83fwu3Kd/cejVpN1IeexSN7xKAXFeoXjvo5rlViKMxINtZiLihMB
        yUEp0eACAAA=
X-CMS-MailID: 20220925203340epcas5p21bd73962a73c36c7bd56841299c0d229
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220925203340epcas5p21bd73962a73c36c7bd56841299c0d229
References: <20220925202304.28097-1-joshi.k@samsung.com>
        <CGME20220925203340epcas5p21bd73962a73c36c7bd56841299c0d229@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

if io_uring sends passthrough command with IORING_URING_CMD_FIXED flag,
use the pre-registered buffer for IO (non-vectored variant). Pass the
buffer/length to io_uring and get the bvec iterator for the range. Next,
pass this bvec to block-layer helper and obtain a bio/request for
subsequent processing.
While at it, modify nvme_submit_user_cmd to take ubuffer as plain integer
argument, and do away with nvme_to_user_ptr conversion in callers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/ioctl.c | 44 +++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index b9f17dc87de9..505a548d4da5 100644
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
@@ -93,23 +94,34 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 	struct bio *bio = NULL;
 	void *meta = NULL;
 	int ret;
+	bool fixedbufs = ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED);
 
-	if (!vec)
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
-			GFP_KERNEL);
-	else {
+	if (vec) {
 		struct iovec fast_iov[UIO_FASTIOV];
 		struct iovec *iov = fast_iov;
 		struct iov_iter iter;
 
-		ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
-				UIO_FASTIOV, &iov, &iter);
+		/* fixedbufs is only for non-vectored io */
+		WARN_ON_ONCE(fixedbufs);
+		ret = import_iovec(rq_data_dir(req), nvme_to_user_ptr(ubuffer),
+				bufflen, UIO_FASTIOV, &iov, &iter);
 		if (ret < 0)
 			goto out;
 
 		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
 		kfree(iov);
-	}
+	} else if (fixedbufs) {
+		struct iov_iter iter;
+
+		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
+				rq_data_dir(req), &iter, ioucmd);
+		if (ret < 0)
+			goto out;
+		ret = blk_rq_map_user_bvec(req, &iter);
+	} else
+		ret = blk_rq_map_user(q, req, NULL,
+					nvme_to_user_ptr(ubuffer), bufflen,
+					GFP_KERNEL);
 	if (ret)
 		goto out;
 	bio = req->bio;
@@ -136,7 +148,7 @@ static int nvme_map_user_request(struct request *req, void __user *ubuffer,
 }
 
 static int nvme_submit_user_cmd(struct request_queue *q,
-		struct nvme_command *cmd, void __user *ubuffer,
+		struct nvme_command *cmd, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, u64 *result, unsigned timeout, bool vec)
 {
@@ -152,7 +164,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	req->timeout = timeout;
 	if (ubuffer && bufflen) {
 		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-				meta_len, meta_seed, &meta, vec);
+				meta_len, meta_seed, &meta, NULL, vec);
 		if (ret)
 			goto out;
 	}
@@ -231,7 +243,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.appmask = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c,
-			nvme_to_user_ptr(io.addr), length,
+			io.addr, length,
 			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
 			false);
 }
@@ -285,7 +297,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &result, timeout, false);
 
@@ -331,7 +343,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			cmd.addr, cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
 			0, &cmd.result, timeout, vec);
 
@@ -475,9 +487,9 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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

