Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4EA51B7D3
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 08:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiEEGSB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 02:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244206AbiEEGSA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 02:18:00 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0BC46651
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 23:14:19 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220505061416epoutp0153088ff708e35d98457feef0e6ede8fb~sINN90Z_I1193311933epoutp011
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:14:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220505061416epoutp0153088ff708e35d98457feef0e6ede8fb~sINN90Z_I1193311933epoutp011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651731256;
        bh=UPPBo4YcLGprm4Smu17ifh6PWSS6FRfIukZeOZZOSfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7brt8zd6Rfka+L0qcQVxzWB/ousj8C5NqMu8WOREIylTIOGXepLM3KZYbzxE4zw4
         tQWnfowO0w/9igW08PKHlB6QK/UEnVsrZOd9IbN+2yjBiUtn5nvCSHZCLew9HnQm0q
         FkxlxY/xkeZNdGy1rTps4b0m0EfrZMU+/h6JAgO8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220505061415epcas5p40ddca3705144c9db575a1d9d9d17cc3a~sINNTWL3j2199421994epcas5p4p;
        Thu,  5 May 2022 06:14:15 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Kv3LW3Th9z4x9Pp; Thu,  5 May
        2022 06:14:11 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B6.EC.09827.33B63726; Thu,  5 May 2022 15:14:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b~sILGFEqdO1752117521epcas5p2F;
        Thu,  5 May 2022 06:11:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220505061150epsmtrp1700f68f008a0cf647066d96975dd1494~sILGEOZHp1114811148epsmtrp17;
        Thu,  5 May 2022 06:11:50 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-ea-62736b332cac
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.2C.08924.6AA63726; Thu,  5 May 2022 15:11:50 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220505061148epsmtip2ab5017717d774a965c975ffbbc5d4fa6~sILEb8bOU0662506625epsmtip2d;
        Thu,  5 May 2022 06:11:48 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru on
 char-device.
Date:   Thu,  5 May 2022 11:36:15 +0530
Message-Id: <20220505060616.803816-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505060616.803816-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmlq5xdnGSwfo10hZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ2w+klqwJLyiffo5
        5gbGXs8uRk4OCQETia7WuWxdjFwcQgK7GSVudTxih3A+MUoc/NABlfnMKPF48zY2mJYN64+y
        dDFyACV2MUq84AMJg9XcfWIOEmYT0JS4MLkUJCwiIC/x5fZaFpAxzAJnGSWm3TrEClIjLBAp
        sXSyPUgNi4CqxNZtb9hBbF4BS4llr64xQWySl5h56TtYnFPASqLjaC8LRI2gxMmZT8BsZqCa
        5q2zmUHmSwgs5ZA4t+QYC0Szi8S0w2fZIWxhiVfHt0DZUhIv+9ug7GSJ1u2X2UHukRAokViy
        QB0ibC9xcc9fJpAwM9Ar63fpQ4RlJaaeWscEsZZPovf3E6gzeSV2zIOxFSXuTXrKCmGLSzyc
        sQTK9pB4tPk/EyQ0exkl5k2fzDaBUWEWkndmIXlnFsLqBYzMqxglUwuKc9NTi00LjPJSy+ER
        nJyfu4kRnHa1vHYwPnzwQe8QIxMH4yFGCQ5mJRFe56UFSUK8KYmVValF+fFFpTmpxYcYTYHh
        PZFZSjQ5H5j480riDU0sDUzMzMxMLI3NDJXEeU+nb0gUEkhPLEnNTk0tSC2C6WPi4JRqYFLp
        mHZqm6fLqs1TOE0e8jZOnSLXqXxg9pmcrLTWq19/zLB1tFp0PfXj7w1b7F13mavof9x2dNaD
        uFvvNnzaffz9TsspodH/mFdwxh+ZreEd0TXrWkujQUrrfMfT0Z+cz5hMTuCOvivHxmhRfC9O
        YKt+zplJK7Wmnlg67R3nzYjrVw6Ua3+JFM1LK9ux3M7DwmLK/aKgxRMme91oZWXfW7no5u2V
        N6c3BZ5qFnHM1OCZFqsrfix3u5fMmdDzSpH56knnpXrrdhYuMH3XsneXzQW9XtH9DOw6MeHH
        pXtCjCYXbZt4aFlb1wrnt7v2u+nu1b7e9Ppn2/8ND/LXcHROuKMl8bhZzu5Mjr3DnqUJBopK
        LMUZiYZazEXFiQDqLNbRRAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSvO6yrOIkg/efWSyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymL/sKbvFjQlPGS0OTW5msrj68gC7A7fHxOZ3
        7B47Z91l97h8ttRj06pONo/NS+o9dt9sYPN4v+8qm0ffllWMHp83yQVwRnHZpKTmZJalFunb
        JXBlbD6SWrAkvKJ9+jnmBsZezy5GTg4JAROJDeuPsnQxcnEICexglFj1pZUNIiEu0XztBzuE
        LSyx8t9zdoiij4wSm9q+M3UxcnCwCWhKXJhcClIjIqAosfFjEyNIDbPATUaJx63XmEFqhAXC
        Ja5sZgGpYRFQldi67Q3YTF4BS4llr64xQcyXl5h56TtYnFPASqLjaC9YvRBQzf3u1SwQ9YIS
        J2c+AbOZgeqbt85mnsAoMAtJahaS1AJGplWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmb
        GMHxoaW1g3HPqg96hxiZOBgPMUpwMCuJ8DovLUgS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh
        62S8kEB6YklqdmpqQWoRTJaJg1OqgWnWite7d8a/O+Urnlals0fm6+anC3dGVbMEpCWqq0/e
        uuhlukbZu1X3Xv9dkvbjw6ZzfzJFp+ilvlzHyayd9jPdQ229ZeT2bt+vn2+YCedZv3zvcEQ1
        wIJh79Z5Rifu6nvnsjUmL/Xp/f9hhUWQ0fSDh27M9hMT2Lfl+06zsF9Tn35heHO9OlPY2u3Z
        cotXDRoLbl7dr7pv1qYztwLaWT7uu7x1ZrBD8C/pnp9B65adZq34YbWu99WWCQbaO88t8NsY
        KSHdwrz14vvr9Sy79gsnHvm7YfJ51psrl7gqX1g9oWzrz64vgf7Ja5TUhJ980mx88aLo+gez
        nb8/RvY1vLiyeXWX029ds9Qi7z3+HxhvrFJiKc5INNRiLipOBADlq1qk/gIAAA==
X-CMS-MailID: 20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b
References: <20220505060616.803816-1-joshi.k@samsung.com>
        <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce handler for fops->uring_cmd(), implementing async passthru
on char device (/dev/ngX). The handler supports newly introduced
operation NVME_URING_CMD_IO. This operates on a new structure
nvme_uring_cmd, which is similar to struct nvme_passthru_cmd64 but
without the embedded 8b result field. This field is not needed since
uring-cmd allows to return additional result via big-CQE.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c        |   1 +
 drivers/nvme/host/ioctl.c       | 168 +++++++++++++++++++++++++++++++-
 drivers/nvme/host/multipath.c   |   1 +
 drivers/nvme/host/nvme.h        |   5 +
 include/uapi/linux/nvme_ioctl.h |  25 +++++
 5 files changed, 197 insertions(+), 3 deletions(-)

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
index 3531de8073a6..3687cb8d7428 100644
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
+};
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
+		struct io_uring_cmd *ioucmd, unsigned int issue_flags)
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
+	if (issue_flags & IO_URING_F_NONBLOCK) {
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
@@ -424,6 +548,32 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return __nvme_ioctl(ns, cmd, (void __user *)arg);
 }
 
+static void nvme_ns_uring_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
+
+	switch (ioucmd->cmd_op) {
+	case NVME_URING_CMD_IO:
+		ret = nvme_uring_cmd_io(ns->ctrl, ns, ioucmd, issue_flags);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	if (ret != -EIOCBQUEUED)
+		io_uring_cmd_done(ioucmd, ret, 0);
+}
+
+void nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
+			struct nvme_ns, cdev);
+	nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
+}
+
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -490,6 +640,18 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
+void nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+
+	if (ns)
+		nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
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
index a2b53ca63335..761ad6c629c4 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -16,6 +16,7 @@
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
+#include <linux/io_uring.h>
 
 #include <trace/events/block.h>
 
@@ -782,6 +783,10 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
+void nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags);
+void nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags);
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

