Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44AA518C99
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 20:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbiECSxH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 14:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiECSxE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 14:53:04 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845933F8A9
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 11:49:19 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220503184918euoutp01b7ff03d4280ab21528b44934adf0c4de~rrN4ceaCH2548725487euoutp01R
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 18:49:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220503184918euoutp01b7ff03d4280ab21528b44934adf0c4de~rrN4ceaCH2548725487euoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651603758;
        bh=88HOb86KJvnm53+fhe3r1f/MzM6iGynSkXDSUbPCofs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHKLZZAKXjsuQ2oshJ2G1xibWAJy36VyDnEL1R2k949yhAn95E3BXzaAUXrm+O3hX
         L7tMPzFQAYEEenTz5L+szw0DV0yk/OXfj+Vajf2EhEyRecT0gQV3VdsP8jovVk4klY
         HQL0asBvYsVaKn/itxXDX6/m32R4Nxr4IE7wSm4c=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220503184916eucas1p28e59a7cd6f294b8a5619ff967053af5f~rrN2jLtZn1821418214eucas1p26;
        Tue,  3 May 2022 18:49:16 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id E0.B2.10260.C2971726; Tue,  3
        May 2022 19:49:16 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220503184915eucas1p2ae04772900c24ef0b23fd8bedead20ae~rrN2I0lWl0739707397eucas1p2B;
        Tue,  3 May 2022 18:49:15 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220503184915eusmtrp2bbdfcb24a4e38767989bf4c8ab865663~rrN2BnwN32575425754eusmtrp2U;
        Tue,  3 May 2022 18:49:15 +0000 (GMT)
X-AuditID: cbfec7f5-bf3ff70000002814-e5-6271792c3d97
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 3B.80.09522.B2971726; Tue,  3
        May 2022 19:49:15 +0100 (BST)
Received: from localhost (unknown [106.210.248.170]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220503184915eusmtip1f33634ed99285bf95c459a5fee99cd5f~rrN1tXzaI0995709957eusmtip1C;
        Tue,  3 May 2022 18:49:15 +0000 (GMT)
From:   Pankaj Raghav <p.raghav@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v3 4/5] nvme: wire-up uring-cmd support for io-passthru on
 char-device.
Date:   Tue,  3 May 2022 20:48:30 +0200
Message-Id: <20220503184831.78705-5-p.raghav@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503184831.78705-1-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsWy7djPc7o6lYVJBntm8Vg0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmcf7tYSaL+cueslvcmPCU0eLQ5GYmi6svD7A7
        8HhMbH7H7rFz1l12j8tnSz02repk89i8pN5j980GNo/3+66yefRtWcXo8XmTXABnFJdNSmpO
        Zllqkb5dAlfG9zmL2QuehFYcWWHSwPjKvYuRk0NCwETi5uWvLF2MXBxCAisYJX5//s4M4Xxh
        lJixegNU5jOjxOEdm5lhWo4sesUOkVjOKNF1+hdUy0tGiYPTz7B2MXJwsAloSTR2soM0iAjI
        S3y5vRZsErNAI5PEhTPHwCYJC0RKTJg9kQnEZhFQlVg3ZSlYnFfAUuLercOMENvkJWZe+s4O
        MpNTwEpix3yoEkGJkzOfsIDYzEAlzVtng90gIfCFQ6LjwjlGkHoJAReJKUd4IMYIS7w6voUd
        wpaR+L9zPhOEXS3x9MZvqN4WRon+nevZIHqtJfrO5ICYzAKaEut36UOUO0ocaf7BClHBJ3Hj
        rSDEBXwSk7ZNZ4YI80p0tAlBVCtJ7Pz5BGqphMTlpjksECUeEq9XuUxgVJyF5JVZSF6ZhbB2
        ASPzKkbx1NLi3PTUYuO81HK94sTc4tK8dL3k/NxNjMDEdfrf8a87GFe8+qh3iJGJg/EQowQH
        s5IIr/PSgiQh3pTEyqrUovz4otKc1OJDjNIcLErivMmZGxKFBNITS1KzU1MLUotgskwcnFIN
        TNYNn7MzTonESDx/tTDmlVsYj9jm5xdXTn9444jmT6/Eve6nYsRr/O5/lr/ssuSle023GC8f
        42stTb/29WsV2/jn37YJ3fn/ebfy3vTjgu/WM64w1WQLzui3OPLec3vbR7HpV78zybFOiYz5
        +t31jZ/UZwMfAeEUsVPTT7QavmI4wyHkVq04kytQ917R3B9bRNawVhoZV/ndPBbMK1w3fe6X
        7QWXCsIcn//ef4uxcwPLD8PjmZGfTPlPPW45cOzQsj23LFK4jxxYufPmk4YdaerSFw/lHrv7
        VOXUby5Wq6gzsuXc+1SMWz6u/nPli/0iuWt+H23lLszTKE2Ne7hrRerLXvH/30RstcM7HqlM
        fqjEUpyRaKjFXFScCAAkmxAtywMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t/xu7ralYVJBk1v1C2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzOP/2MJPF/GVP2S1uTHjKaHFocjOTxdWXB9gd
        eDwmNr9j99g56y67x+WzpR6bVnWyeWxeUu+x+2YDm8f7fVfZPPq2rGL0+LxJLoAzSs+mKL+0
        JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS/j+5zF7AVPQiuO
        rDBpYHzl3sXIySEhYCJxZNEr9i5GLg4hgaWMEpPOzGaHSEhI3F7YxAhhC0v8udbFBlH0nFFi
        zb6LQAkODjYBLYnGTrB6EQFFiY0fQeq5OJgFepkkjvfvYAWpERYIl3i82g+khkVAVWLdlKXM
        IDavgKXEvVuHoebLS8y89J0dpJxTwEpix3ywEiGgkraJi9khygUlTs58wgJiMwOVN2+dzTyB
        UWAWktQsJKkFjEyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxAqNs27Gfm3cwznv1Ue8QIxMH
        4yFGCQ5mJRFe56UFSUK8KYmVValF+fFFpTmpxYcYTYHOnsgsJZqcD4zzvJJ4QzMDU0MTM0sD
        U0szYyVxXs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGpuQFGQtuhPyJdCrX2GwuuNS1/+vfw/st
        /Vsko7hmC4svahN7JZNXtHDBW36WpTP7Q/qbYr5mKtyZx5D1x7mcgZmNfer/h7z9O3SuWj0W
        yrsjdXnu/R833d9++dxg88ttSt2pyQJ/ysN+HmrsTr93+t2exYVpri4r5gVWJ83eHBfwOdYo
        Z/WSbct/lcmlKu1Mnsb/b75AvyKf+XEL9fB0+W1Frb0XVLP5dkyqqrA+OJv3JmM0k0bPTLNV
        TNnCE067fFdQ9EwOZli69MfP2b94pOsd8y/8ef/CcVbrV13xvzFPnv/cuqR+V2TvxAm6p6c3
        SO+Jv/iljPvSx/1MWROrJT9lLNht73Z/dnaz1vezR5VYijMSDbWYi4oTAdVPblY7AwAA
X-CMS-MailID: 20220503184915eucas1p2ae04772900c24ef0b23fd8bedead20ae
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220503184915eucas1p2ae04772900c24ef0b23fd8bedead20ae
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220503184915eucas1p2ae04772900c24ef0b23fd8bedead20ae
References: <20220503184831.78705-1-p.raghav@samsung.com>
        <CGME20220503184915eucas1p2ae04772900c24ef0b23fd8bedead20ae@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

Introduce handler for fops->uring_cmd(), implementing async passthru
on char device (/dev/ngX). The handler supports newly introduced
operation NVME_URING_CMD_IO. This operates on a new structure
nvme_uring_cmd, which is similiar to struct nvme_passthru_cmd64 but
without the embedded 8b result field. This is not needed since uring-cmd
allows to return additional result to user-space via big-CQE.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c        |   1 +
 drivers/nvme/host/ioctl.c       | 166 +++++++++++++++++++++++++++++++-
 drivers/nvme/host/multipath.c   |   1 +
 drivers/nvme/host/nvme.h        |   3 +
 include/uapi/linux/nvme_ioctl.h |  25 +++++
 5 files changed, 193 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e1846d04817f..682df98db341 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3699,6 +3699,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.release	= nvme_ns_chr_release,
 	.unlocked_ioctl	= nvme_ns_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.uring_cmd	= nvme_ns_chr_uring_cmd,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 3531de8073a6..e428d692375a 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -26,6 +26,80 @@ static inline void *nvme_meta_from_bio(struct bio *bio)
 	return bip ? bvec_virt(bip->bip_vec) : NULL;
 }
 
+/*
+ * This overlays struct io_uring_cmd pdu.
+ * Expect build errors if this grows larger than that.
+ */
+struct nvme_uring_cmd_pdu {
+	union {
+		struct bio *bio;
+		struct request *req;
+	};
+	void *meta; /* kernel-resident buffer */
+	void __user *meta_buffer;
+	u32 meta_len;
+} __packed;
+
+static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
+		struct io_uring_cmd *ioucmd)
+{
+	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
+}
+
+static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
+{
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	struct request *req = pdu->req;
+	struct bio *bio = req->bio;
+	bool write = req_op(req) == REQ_OP_DRV_OUT;
+	int status;
+	u64 result;
+
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		status = -EINTR;
+	else
+		status = nvme_req(req)->status;
+
+	result = le64_to_cpu(nvme_req(req)->result.u64);
+	blk_mq_free_request(req);
+	if (bio)
+		blk_rq_unmap_user(bio);
+
+	if (pdu->meta && !status && !write) {
+		if (copy_to_user(pdu->meta_buffer, pdu->meta, pdu->meta_len))
+			status = -EFAULT;
+	}
+	kfree(pdu->meta);
+	io_uring_cmd_done(ioucmd, status, result);
+}
+
+static void nvme_end_async_pt(struct request *req, blk_status_t err)
+{
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	/* extract bio before reusing the same field for request */
+	struct bio *bio = pdu->bio;
+
+	pdu->req = req;
+	req->bio = bio;
+	/* this takes care of moving rest of completion-work to task context */
+	io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
+}
+
+static void nvme_setup_uring_cmd_data(struct request *rq,
+		struct io_uring_cmd *ioucmd, void __user *meta_buffer,
+		u32 meta_len)
+{
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+
+	/* to free bio on completion, as req->bio will be null at that time */
+	pdu->bio = rq->bio;
+	pdu->meta = nvme_meta_from_bio(rq->bio);
+	pdu->meta_buffer = meta_buffer;
+	pdu->meta_len = meta_len;
+	rq->end_io_data = ioucmd;
+}
+
 static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 		unsigned len, u32 seed, bool write)
 {
@@ -63,7 +137,8 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 static struct request *nvme_alloc_user_request(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, unsigned timeout, bool vec)
+		u32 meta_seed, unsigned timeout, bool vec, unsigned int rq_flags,
+		blk_mq_req_flags_t blk_flags)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -73,7 +148,7 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 	void *meta = NULL;
 	int ret;
 
-	req = blk_mq_alloc_request(q, nvme_req_op(cmd), 0);
+	req = blk_mq_alloc_request(q, nvme_req_op(cmd) | rq_flags, blk_flags);
 	if (IS_ERR(req))
 		return req;
 	nvme_init_request(req, cmd);
@@ -156,7 +231,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	struct request *req;
 
 	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, timeout, vec);
+			meta_len, meta_seed, timeout, vec, 0, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	return nvme_execute_user_rq(req, meta_buffer, meta_len, result);
@@ -333,6 +408,55 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	return status;
 }
 
+static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
+		struct io_uring_cmd *ioucmd)
+{
+	struct nvme_uring_cmd *cmd =
+		(struct nvme_uring_cmd *)ioucmd->cmd;
+	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
+	struct nvme_command c;
+	struct request *req;
+	unsigned int rq_flags = 0;
+	blk_mq_req_flags_t blk_flags = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+	if (cmd->flags)
+		return -EINVAL;
+	if (!nvme_validate_passthru_nsid(ctrl, ns, cmd->nsid))
+		return -EINVAL;
+
+	if (ioucmd->flags & IO_URING_F_NONBLOCK) {
+		rq_flags = REQ_NOWAIT;
+		blk_flags = BLK_MQ_REQ_NOWAIT;
+	}
+	memset(&c, 0, sizeof(c));
+	c.common.opcode = cmd->opcode;
+	c.common.flags = cmd->flags;
+	c.common.nsid = cpu_to_le32(cmd->nsid);
+	c.common.cdw2[0] = cpu_to_le32(cmd->cdw2);
+	c.common.cdw2[1] = cpu_to_le32(cmd->cdw3);
+	c.common.cdw10 = cpu_to_le32(cmd->cdw10);
+	c.common.cdw11 = cpu_to_le32(cmd->cdw11);
+	c.common.cdw12 = cpu_to_le32(cmd->cdw12);
+	c.common.cdw13 = cpu_to_le32(cmd->cdw13);
+	c.common.cdw14 = cpu_to_le32(cmd->cdw14);
+	c.common.cdw15 = cpu_to_le32(cmd->cdw15);
+
+	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(cmd->addr),
+			cmd->data_len, nvme_to_user_ptr(cmd->metadata),
+			cmd->metadata_len, 0, cmd->timeout_ms ?
+			msecs_to_jiffies(cmd->timeout_ms) : 0, 0, rq_flags,
+			blk_flags);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	nvme_setup_uring_cmd_data(req, ioucmd, nvme_to_user_ptr(cmd->metadata),
+			cmd->metadata_len);
+	blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
+	return -EIOCBQUEUED;
+}
+
 static bool is_ctrl_ioctl(unsigned int cmd)
 {
 	if (cmd == NVME_IOCTL_ADMIN_CMD || cmd == NVME_IOCTL_ADMIN64_CMD)
@@ -424,6 +548,31 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return __nvme_ioctl(ns, cmd, (void __user *)arg);
 }
 
+static void nvme_ns_uring_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
+{
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
+
+	switch (ioucmd->cmd_op) {
+	case NVME_URING_CMD_IO:
+		ret = nvme_uring_cmd_io(ns->ctrl, ns, ioucmd);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	if (ret != -EIOCBQUEUED)
+		io_uring_cmd_done(ioucmd, ret, 0);
+}
+
+void nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
+			struct nvme_ns, cdev);
+	nvme_ns_uring_cmd(ns, ioucmd);
+}
+
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -490,6 +639,17 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
+void nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+
+	if (ns)
+		nvme_ns_uring_cmd(ns, ioucmd);
+	srcu_read_unlock(&head->srcu, srcu_idx);
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index d464fdf978fb..d3e2440d8abb 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -437,6 +437,7 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 	.release	= nvme_ns_head_chr_release,
 	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.uring_cmd	= nvme_ns_head_chr_uring_cmd,
 };
 
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a2b53ca63335..57c9adb97ce9 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -16,6 +16,7 @@
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
+#include <linux/io_uring.h>
 
 #include <trace/events/block.h>
 
@@ -782,6 +783,8 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
+void nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd);
+void nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd);
 int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 extern const struct attribute_group *nvme_ns_id_attr_groups[];
diff --git a/include/uapi/linux/nvme_ioctl.h b/include/uapi/linux/nvme_ioctl.h
index b2e43185e3b5..04e458c649ab 100644
--- a/include/uapi/linux/nvme_ioctl.h
+++ b/include/uapi/linux/nvme_ioctl.h
@@ -70,6 +70,28 @@ struct nvme_passthru_cmd64 {
 	__u64	result;
 };
 
+/* same as struct nvme_passthru_cmd64, minus the 8b result field */
+struct nvme_uring_cmd {
+	__u8	opcode;
+	__u8	flags;
+	__u16	rsvd1;
+	__u32	nsid;
+	__u32	cdw2;
+	__u32	cdw3;
+	__u64	metadata;
+	__u64	addr;
+	__u32	metadata_len;
+	__u32	data_len;
+	__u32	cdw10;
+	__u32	cdw11;
+	__u32	cdw12;
+	__u32	cdw13;
+	__u32	cdw14;
+	__u32	cdw15;
+	__u32	timeout_ms;
+	__u32   rsvd2;
+};
+
 #define nvme_admin_cmd nvme_passthru_cmd
 
 #define NVME_IOCTL_ID		_IO('N', 0x40)
@@ -83,4 +105,7 @@ struct nvme_passthru_cmd64 {
 #define NVME_IOCTL_IO64_CMD	_IOWR('N', 0x48, struct nvme_passthru_cmd64)
 #define NVME_IOCTL_IO64_CMD_VEC	_IOWR('N', 0x49, struct nvme_passthru_cmd64)
 
+/* io_uring async commands: */
+#define NVME_URING_CMD_IO	_IOWR('N', 0x80, struct nvme_uring_cmd)
+
 #endif /* _UAPI_LINUX_NVME_IOCTL_H */
-- 
2.25.1

