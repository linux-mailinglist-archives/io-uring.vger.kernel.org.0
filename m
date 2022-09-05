Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5C45AD464
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbiIEN7E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbiIEN7B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:59:01 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07015A168
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:58:59 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220905135858epoutp01f09f975aa2aeabe92ee2d897690a1da4~R_5Ei0XtP3023730237epoutp01V
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 13:58:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220905135858epoutp01f09f975aa2aeabe92ee2d897690a1da4~R_5Ei0XtP3023730237epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662386338;
        bh=XgeeoulHQJxbtOhPCDaOvhvAzjNttpjnHeL7vwNSTU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Us5Tb9x50K+7rT36ea0ImqMABDaRfyr5QxYfjXr802wA2Mn8WJY4Lb0lSmmUlTxZ0
         pJ6xC9g8Fvf8466Yg2vWgck46OPvLW7mwXl/ckk6A8of+BZkF//D9DglRtL8MdrgGe
         YmnJSEyl+Q8iUdUwX+BsS5grHyU7QlVNtvEutS+8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220905135857epcas5p1ebae4f92d0dd3946d9a71550fcbbd01a~R_5D__BiE0780107801epcas5p18;
        Mon,  5 Sep 2022 13:58:57 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MLqqz23BYz4x9Pr; Mon,  5 Sep
        2022 13:58:55 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.E4.54060.F9006136; Mon,  5 Sep 2022 22:58:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220905135854epcas5p2256848a964afec41f46502b0114698e2~R_5BgLA2P1747417474epcas5p27;
        Mon,  5 Sep 2022 13:58:54 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220905135854epsmtrp260a934733ec706f1a719387c176229a2~R_5BfY6um0711507115epsmtrp2C;
        Mon,  5 Sep 2022 13:58:54 +0000 (GMT)
X-AuditID: b6c32a4b-be1ff7000000d32c-b4-6316009f7c12
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.2C.18644.E9006136; Mon,  5 Sep 2022 22:58:54 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220905135853epsmtip10b02e02248af028724fb384963abb838~R_5ABMfeE1795917959epsmtip1U;
        Mon,  5 Sep 2022 13:58:53 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v4 4/4] nvme: wire up fixed buffer support for nvme
 passthrough
Date:   Mon,  5 Sep 2022 19:18:33 +0530
Message-Id: <20220905134833.6387-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905134833.6387-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmuu58BrFkg/XveS2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tH35ZVjB6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74svoKY8Ff5Yr3q1tYGxgXynYxcnJICJhIrGnr
        Z+xi5OIQEtjNKHFr239mkISQwCdGieX7pSESnxklDm5ZwwjTsfTWA3aIol2MEr1TTeGK/vxv
        Y+ti5OBgE9CUuDC5FKRGRMBL4v7t96wgNcwgG1b/fcsKkhAWiJLoWdwINpRFQFVi2/PPLCA2
        r4C5xM2L81gglslLzLz0HWwZp4CFxKSu+2wQNYISJ2c+AathBqpp3jqbGWSBhEAnh8SDxi2s
        EM0uElfn3mOHsIUlXh3fAmVLSXx+t5cNwk6WuDTzHBOEXSLxeM9BKNteovVUPzPIM8xAz6zf
        pQ+xi0+i9/cTJpCwhACvREebEES1osS9SU+htopLPJyxBMr2kOjr+AEN3W5Gidvnn7NOYJSf
        heSFWUhemIWwbQEj8ypGydSC4tz01GLTAuO81HJ4vCbn525iBCdRLe8djI8efNA7xMjEwXiI
        UYKDWUmEN2WHSLIQb0piZVVqUX58UWlOavEhRlNgGE9klhJNzgem8bySeEMTSwMTMzMzE0tj
        M0Mlcd4p2ozJQgLpiSWp2ampBalFMH1MHJxSDUwr039K30qpKpm2cal1fAl3yfGLb9+EVH9L
        uPBkrsJf5f39PrtkqzNWbVh8/kxF2J1+ZtvTh3PS/p++VllRqpbeNPWF8b0q5f0uW9j/vZvQ
        mZBgIVznZrp5174NE4qfW59+a7Bg2lJZk4Kg87vXfT1nd/EYg+n5CxIv135a4XZ3ednyjn8N
        /++yNjU/kK5Yu/Vc6dlbmV4Cax89YXO32/wg0+Jp8n+XuRvdSoT75dk85685+frz8nPyb5z3
        ufGlsV+4eKL2rOON454SUzLiHvCViT7qejOJ/8hW3i0sVbYxmx5Iis3U/hDqf9Jm6iaJ9+94
        pgjbhjVYVsyUCj5ySuz7I+ueH1WfTJoTyjy7GApnKLEUZyQaajEXFScCAELZenErBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSnO48BrFkg8c3jCyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWV34PLYOesuu8fls6Ue
        m1Z1snlsXlLvsftmA5tH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZXxZfYWx4K9yxfvVLawN
        jAtluxg5OSQETCSW3nrA3sXIxSEksINR4smB+2wQCXGJ5ms/2CFsYYmV/55DFX1klPj1aiZr
        FyMHB5uApsSFyaUgNSICARIHGy+D1TALHGSUON/0jQUkISwQIXH39XMmEJtFQFVi2/PPYHFe
        AXOJmxfnsUAskJeYeek72DJOAQuJSV0QRwgB1eyZ8ZQRol5Q4uTMJ2D1zED1zVtnM09gFJiF
        JDULSWoBI9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgGNDS2sG4Z9UHvUOMTByM
        hxglOJiVRHhTdogkC/GmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbL
        xMEp1cC0LbM4YdXvmx/TEpJbo9szqw9I/vh11qboy5OPVS75m2U45CXKApWezJzvV7xk4qR3
        kq8q3S/KbFOa3xbxJqZmasiW2cffpXs+6bxzXsnttdq14pe777QpZnYbTQyZrLH00qP9anwu
        DsyaHlGRKSHT7K7J+TQFzXtweVOJ4Tw+TvFrMbFGh1Y//d767at6QufHSe8vLmrPvSaeJ2Eu
        GzTNRGSb0eO9e5R35LKnK8Z8Uqlqyrn7M3xLr993xpxTidukTh+Tct1itqL2nUQgX9Uzu0k1
        Ir+WfJ9RkaWu1pvK+jWAzy2w4JWcsvXpGUs7IlXrTBbrLP6mcmO7c40m3+QrNidPNPWpOvJa
        pdraPFNiKc5INNRiLipOBAC4BqQ88AIAAA==
X-CMS-MailID: 20220905135854epcas5p2256848a964afec41f46502b0114698e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220905135854epcas5p2256848a964afec41f46502b0114698e2
References: <20220905134833.6387-1-joshi.k@samsung.com>
        <CGME20220905135854epcas5p2256848a964afec41f46502b0114698e2@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

