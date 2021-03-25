Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF72B349793
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 18:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCYRH1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 13:07:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41021 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhCYRHL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 13:07:11 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210325170709epoutp02f3335ca94c2924430083769841a1b377~vpNXPgkCi2414224142epoutp02U
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:07:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210325170709epoutp02f3335ca94c2924430083769841a1b377~vpNXPgkCi2414224142epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616692029;
        bh=M8dkFlSZ9WNpM0etSJMfyLGe/ewk7+VeWSIrHC6ZnqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODBu0y37XvgTc6OV4GYeeWejEYuWbrD3UQ119juKI/fwoxVbnMUTj4PyJGWHreLAs
         N7VLKUvdAUFE0q8NL4Bgq29+jb5XLhCtv7woAOyoLvZML0sBqU0FGTbrv0QtMickR7
         xd2KxMrJmA/KFjqEK5alrNUnvyeJTB+xWP5q7Rrs=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210325170709epcas5p45420770e9cd38fd10b9cd43f49314681~vpNW3SInF0346503465epcas5p4b;
        Thu, 25 Mar 2021 17:07:09 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.07.39068.C33CC506; Fri, 26 Mar 2021 02:07:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210325170708epcas5p259755feb9f0a769e7390a3b6eebc0e01~vpNWF2rF01371213712epcas5p2H;
        Thu, 25 Mar 2021 17:07:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210325170708epsmtrp1ec71f6f64a3ec4973b0804b3669ece1d~vpNWFBPaq2524325243epsmtrp1w;
        Thu, 25 Mar 2021 17:07:08 +0000 (GMT)
X-AuditID: b6c32a4a-625ff7000000989c-20-605cc33ca64a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.C2.08745.C33CC506; Fri, 26 Mar 2021 02:07:08 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210325170706epsmtip205a8b5ead78fa0e47295db186c70c03d~vpNUW44y82804528045epsmtip22;
        Thu, 25 Mar 2021 17:07:06 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH v4 2/2] nvme: wire up support for async passthrough
Date:   Thu, 25 Mar 2021 22:35:40 +0530
Message-Id: <20210325170540.59619-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210325170540.59619-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsWy7bCmuq7N4ZgEg5YfJhZNE/4yW6y+289m
        Mev2axaLlauPMlm8az3HYvH4zmd2i6P/37JZTDp0jdFi/rKn7Bbbfs9ntrgyZRGzxesfJ9kc
        eDwuny312LSqk81j85J6j903G9g8+rasYvT4vEnOo/1AN1MAexSXTUpqTmZZapG+XQJXRsP9
        L6wFC6MqXl3ex97AuNCri5GTQ0LARGLZqj7GLkYuDiGB3YwS/+7ehXI+MUqsvriCHcL5zCgx
        q30GI0zLog2b2SASuxglpvVNZ4WrentnIlCGg4NNQFPiwuRSkAYRgQCJXQc/M4HYzAJHGSUe
        rawGsYUF3CU2zd3JAmKzCKhKbHx/CczmFbCQmHV+MgvEMnmJmZe+s4PYnAKWEjf/NbBC1AhK
        nJz5hAViprxE89bZzCA3SAjM5JDYc/M4O0Szi8SdK3+YIGxhiVfHt0DFpSRe9rdB2cUSv+4c
        hWruYJS43jATarO9xMU9f5lAnmEGemb9Ln2IZXwSvb+fgIUlBHglOtqEIKoVJe5NesoKYYtL
        PJyxhBWixEPizIZoSPD0MEqsfNDOPoFRfhaSF2YheWEWwrIFjMyrGCVTC4pz01OLTQuM8lLL
        9YoTc4tL89L1kvNzNzGCU5OW1w7Ghw8+6B1iZOJgPMQowcGsJMKb5BuTIMSbklhZlVqUH19U
        mpNafIhRmoNFSZx3h8GDeCGB9MSS1OzU1ILUIpgsEwenVAOTQ8seD07noqMn/gnYONWrbIt4
        x8x6JLKK48IaS+UpL21/HPvxZPEclxOLW8wqZbLbC9iP64lMeRjjtoflw7GoDXqpbWasV09m
        pGd+5Dvf0bEzwf6wz8Pbf33UbFIbv65MKdtvzvfl0Zw5BcnRVea+06LaN3yo55xfEDjnwZUN
        hzzXZed6XLjs/D358+4chaQdUXbsd+5W5efN/y6gLhXbyNRnutPh8HlL3/hZ9s9Vui20v+S9
        P/1u6e076S8vvll1MkH2TG2Q87PNJ1m3X1u31DGoguv/Qa0vL2ZctfqwrOXZ70nPDuhJeQmJ
        /zhb+1b/U7HkUo8H23oc58i7i1Vbilf8mqS18++jmxpdn228lViKMxINtZiLihMBXu4k3LwD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvK7N4ZgEg4NLWS2aJvxltlh9t5/N
        Ytbt1ywWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S22/Z7PbHFlyiJmi9c/TrI5
        8HhcPlvqsWlVJ5vH5iX1HrtvNrB59G1ZxejxeZOcR/uBbqYA9igum5TUnMyy1CJ9uwSujIb7
        X1gLFkZVvLq8j72BcaFXFyMnh4SAicSiDZvZuhi5OIQEdjBKLPh8hxUiIS7RfO0HO4QtLLHy
        33N2iKKPjBKHWv8DdXBwsAloSlyYXApSIyIQItE1bxsTSA2zwFlGieWP2xlBEsIC7hKb5u5k
        AbFZBFQlNr6/BGbzClhIzDo/mQVigbzEzEvfwZZxClhK3PzXAHaEEFDNnb0XmSHqBSVOznwC
        Vs8MVN+8dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI4M
        La0djHtWfdA7xMjEwXiIUYKDWUmEN8k3JkGINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FC
        AumJJanZqakFqUUwWSYOTqkGJuFnz5YV1q/gvV4kkFcaf01l4WkFfsl6Qd3zYvNuaKgy8O7Q
        5Go0S7ymM/et6YItM7dnbm1wLNWeGSw6b1Gz/4cL71IdtZzPHl2RHB6WPV1enpctZ6pLg8Af
        nw1W33f/aEg6v3Ff/OlNJwVt3WQPT4vmvhbP/vuPiHr7tf0HLrQrRX5ZzcPTfm+yk6xjzlkx
        HhXXO5MlSh81/HG5Ujo99f4+1oKuez2MZ/9Fzkhd805MqHX2RoXrNzYp7XJLO9vIyFJwbe+W
        QjaZ0uiWlc+rZpe0sun+95lzd7JYxAaPc6wPkxarPEt58616pcLRNrEnjCs/+DB7bnrG8mvX
        3tC9IVzPBRnW3s3M6qkM2awnpMRSnJFoqMVcVJwIAIax8DT7AgAA
X-CMS-MailID: 20210325170708epcas5p259755feb9f0a769e7390a3b6eebc0e01
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210325170708epcas5p259755feb9f0a769e7390a3b6eebc0e01
References: <20210325170540.59619-1-joshi.k@samsung.com>
        <CGME20210325170708epcas5p259755feb9f0a769e7390a3b6eebc0e01@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce handler for mq_ops->uring_cmd(), implementing async
passthrough on block-device.
The handler supports NVME_IOCTL_IO_CMD and NVME_IOCTL_IO64_CMD.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c | 194 +++++++++++++++++++++++++++++++++------
 drivers/nvme/host/nvme.h |   3 +
 drivers/nvme/host/pci.c  |   1 +
 3 files changed, 171 insertions(+), 27 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 560a72418dd2..58759ddfd203 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1050,6 +1050,96 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	return ERR_PTR(ret);
 }
 
+/*
+ * Convert integer values from ioctl structures to user pointers, silently
+ * ignoring the upper bits in the compat case to match behaviour of 32-bit
+ * kernels.
+ */
+static void __user *nvme_to_user_ptr(uintptr_t ptrval)
+{
+	if (in_compat_syscall())
+		ptrval = (compat_uptr_t)ptrval;
+	return (void __user *)ptrval;
+}
+/*
+ * This is carved within the io_uring_cmd, to avoid dynamic allocation.
+ * Care should be taken not to grow this beyond what is available.
+ * Expect build warning otherwise.
+ */
+struct uring_cmd_data {
+	union {
+		struct bio *bio;
+		u64 result; /* nvme cmd result */
+	};
+	void *meta; /* kernel-resident buffer */
+	int status; /* nvme cmd status */
+};
+
+inline u64 *nvme_ioucmd_data_addr(struct io_uring_cmd *ioucmd)
+{
+	return &(((struct block_uring_cmd *)&ioucmd->pdu)->unused2[1]);
+}
+
+static void nvme_pt_task_cb(struct callback_head *cb)
+{
+	struct uring_cmd_data *ucd;
+	struct nvme_passthru_cmd64 __user *ptcmd64 = NULL;
+	struct block_uring_cmd *bcmd;
+	struct io_uring_cmd *ioucmd;
+
+	ioucmd = io_uring_cbh_to_io_uring_cmd(cb);
+	bcmd = (struct block_uring_cmd *) &ioucmd->pdu;
+	ptcmd64 = (void __user *) bcmd->unused2[0];
+	ucd = (struct uring_cmd_data *) nvme_ioucmd_data_addr(ioucmd);
+
+	if (ucd->meta) {
+		void __user *umeta = nvme_to_user_ptr(ptcmd64->metadata);
+
+		if (!ucd->status)
+			if (copy_to_user(umeta, ucd->meta, ptcmd64->metadata_len))
+				ucd->status = -EFAULT;
+		kfree(ucd->meta);
+	}
+	if (likely(bcmd->ioctl_cmd == NVME_IOCTL_IO64_CMD)) {
+		if (put_user(ucd->result, &ptcmd64->result))
+			ucd->status = -EFAULT;
+	} else {
+		struct nvme_passthru_cmd __user *ptcmd = (void *)bcmd->unused2[0];
+
+		if (put_user(ucd->result, &ptcmd->result))
+			ucd->status = -EFAULT;
+	}
+	io_uring_cmd_done(ioucmd, ucd->status);
+}
+
+static void nvme_end_async_pt(struct request *req, blk_status_t err)
+{
+	struct io_uring_cmd *ioucmd;
+	struct uring_cmd_data *ucd;
+	struct bio *bio;
+	int ret;
+
+	ioucmd = req->end_io_data;
+	ucd = (struct uring_cmd_data *) nvme_ioucmd_data_addr(ioucmd);
+	/* extract bio before reusing the same field for status */
+	bio = ucd->bio;
+
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		ucd->status = -EINTR;
+	else
+		ucd->status = nvme_req(req)->status;
+	ucd->result = le64_to_cpu(nvme_req(req)->result.u64);
+
+	/* this takes care of setting up task-work */
+	ret = io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
+	if (ret < 0)
+		kfree(ucd->meta);
+
+	/* we can unmap pages, free bio and request */
+	blk_rq_unmap_user(bio);
+	blk_mq_free_request(req);
+}
+
 static u32 nvme_known_admin_effects(u8 opcode)
 {
 	switch (opcode) {
@@ -1138,10 +1228,27 @@ void nvme_execute_passthru_rq(struct request *rq)
 }
 EXPORT_SYMBOL_NS_GPL(nvme_execute_passthru_rq, NVME_TARGET_PASSTHRU);
 
+static void nvme_setup_uring_cmd_data(struct request *rq,
+		struct io_uring_cmd *ioucmd, void *meta, bool write)
+{
+	struct uring_cmd_data *ucd;
+
+	ucd = (struct uring_cmd_data *) nvme_ioucmd_data_addr(ioucmd);
+	/* to free bio on completion, as req->bio will be null at that time */
+	ucd->bio = rq->bio;
+	/* meta update is required only for read requests */
+	if (meta && !write)
+		ucd->meta = meta;
+	else
+		ucd->meta = NULL;
+	rq->end_io_data = ioucmd;
+}
+
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout)
+		u32 meta_seed, u64 *result, unsigned timeout,
+		struct io_uring_cmd *ioucmd)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -1177,6 +1284,12 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			req->cmd_flags |= REQ_INTEGRITY;
 		}
 	}
+	if (ioucmd) { /* async dispatch */
+		nvme_setup_uring_cmd_data(req, ioucmd, meta, write);
+		blk_execute_rq_nowait(ns ? ns->disk : NULL, req, 0,
+					nvme_end_async_pt);
+		return 0;
+	}
 
 	nvme_execute_passthru_rq(req);
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
@@ -1532,18 +1645,6 @@ static void nvme_enable_aen(struct nvme_ctrl *ctrl)
 	queue_work(nvme_wq, &ctrl->async_event_work);
 }
 
-/*
- * Convert integer values from ioctl structures to user pointers, silently
- * ignoring the upper bits in the compat case to match behaviour of 32-bit
- * kernels.
- */
-static void __user *nvme_to_user_ptr(uintptr_t ptrval)
-{
-	if (in_compat_syscall())
-		ptrval = (compat_uptr_t)ptrval;
-	return (void __user *)ptrval;
-}
-
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
 	struct nvme_user_io io;
@@ -1604,11 +1705,13 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
 	return nvme_submit_user_cmd(ns->queue, &c,
 			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0);
+			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
+			NULL);
 }
 
 static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd __user *ucmd)
+			struct nvme_passthru_cmd __user *ucmd,
+			struct io_uring_cmd *ioucmd)
 {
 	struct nvme_passthru_cmd cmd;
 	struct nvme_command c;
@@ -1642,9 +1745,9 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout);
+			0, &result, timeout, ioucmd);
 
-	if (status >= 0) {
+	if (!ioucmd && status >= 0) {
 		if (put_user(result, &ucmd->result))
 			return -EFAULT;
 	}
@@ -1653,7 +1756,8 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 }
 
 static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd64 __user *ucmd)
+			struct nvme_passthru_cmd64 __user *ucmd,
+			struct io_uring_cmd *ioucmd)
 {
 	struct nvme_passthru_cmd64 cmd;
 	struct nvme_command c;
@@ -1686,9 +1790,9 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &cmd.result, timeout);
+			0, &cmd.result, timeout, ioucmd);
 
-	if (status >= 0) {
+	if (!ioucmd && status >= 0) {
 		if (put_user(cmd.result, &ucmd->result))
 			return -EFAULT;
 	}
@@ -1748,10 +1852,10 @@ static int nvme_handle_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		ret = nvme_user_cmd(ctrl, NULL, argp);
+		ret = nvme_user_cmd(ctrl, NULL, argp, NULL);
 		break;
 	case NVME_IOCTL_ADMIN64_CMD:
-		ret = nvme_user_cmd64(ctrl, NULL, argp);
+		ret = nvme_user_cmd64(ctrl, NULL, argp, NULL);
 		break;
 	default:
 		ret = sed_ioctl(ctrl->opal_dev, cmd, argp);
@@ -1787,13 +1891,13 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 		ret = ns->head->ns_id;
 		break;
 	case NVME_IOCTL_IO_CMD:
-		ret = nvme_user_cmd(ns->ctrl, ns, argp);
+		ret = nvme_user_cmd(ns->ctrl, ns, argp, NULL);
 		break;
 	case NVME_IOCTL_SUBMIT_IO:
 		ret = nvme_submit_io(ns, argp);
 		break;
 	case NVME_IOCTL_IO64_CMD:
-		ret = nvme_user_cmd64(ns->ctrl, ns, argp);
+		ret = nvme_user_cmd64(ns->ctrl, ns, argp, NULL);
 		break;
 	default:
 		if (ns->ndev)
@@ -1806,6 +1910,42 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
+int nvme_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
+		enum io_uring_cmd_flags flags)
+{
+	struct nvme_ns_head *head = NULL;
+	struct block_device *bdev = I_BDEV(ioucmd->file->f_mapping->host);
+	struct block_uring_cmd *bcmd = (struct block_uring_cmd *)&ioucmd->pdu;
+	struct nvme_ns *ns;
+	int srcu_idx, ret;
+	void __user *argp = (void __user *) bcmd->unused2[0];
+
+	BUILD_BUG_ON(sizeof(struct uring_cmd_data) >
+			sizeof(struct block_uring_cmd) -
+			offsetof(struct block_uring_cmd, unused2[1]));
+
+	ns = nvme_get_ns_from_disk(bdev->bd_disk, &head, &srcu_idx);
+	if (unlikely(!ns))
+		return -EWOULDBLOCK;
+
+	switch (bcmd->ioctl_cmd) {
+	case NVME_IOCTL_IO_CMD:
+		ret = nvme_user_cmd(ns->ctrl, ns, argp, ioucmd);
+		break;
+	case NVME_IOCTL_IO64_CMD:
+		ret = nvme_user_cmd64(ns->ctrl, ns, argp, ioucmd);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	if (ret >= 0)
+		ret = -EIOCBQUEUED;
+	nvme_put_ns_from_disk(head, srcu_idx);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_uring_cmd);
+
 #ifdef CONFIG_COMPAT
 struct nvme_user_io32 {
 	__u8	opcode;
@@ -3299,7 +3439,7 @@ static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
 	kref_get(&ns->kref);
 	up_read(&ctrl->namespaces_rwsem);
 
-	ret = nvme_user_cmd(ctrl, ns, argp);
+	ret = nvme_user_cmd(ctrl, ns, argp, NULL);
 	nvme_put_ns(ns);
 	return ret;
 
@@ -3316,9 +3456,9 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ctrl, NULL, argp);
+		return nvme_user_cmd(ctrl, NULL, argp, NULL);
 	case NVME_IOCTL_ADMIN64_CMD:
-		return nvme_user_cmd64(ctrl, NULL, argp);
+		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index b0863c59fac4..afca7ac8c6b8 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -17,6 +17,7 @@
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
+#include <linux/io_uring.h>
 
 #include <trace/events/block.h>
 
@@ -620,6 +621,8 @@ int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);
 void nvme_start_freeze(struct nvme_ctrl *ctrl);
 
 #define NVME_QID_ANY -1
+int nvme_uring_cmd(struct request_queue *q, struct io_uring_cmd *ucmd,
+		enum io_uring_cmd_flags flags);
 struct request *nvme_alloc_request(struct request_queue *q,
 		struct nvme_command *cmd, blk_mq_req_flags_t flags);
 void nvme_cleanup_cmd(struct request *req);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d47bb18b976a..e8b1d9177148 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1623,6 +1623,7 @@ static const struct blk_mq_ops nvme_mq_ops = {
 	.map_queues	= nvme_pci_map_queues,
 	.timeout	= nvme_timeout,
 	.poll		= nvme_poll,
+	.uring_cmd	= nvme_uring_cmd,
 };
 
 static void nvme_dev_remove_admin(struct nvme_dev *dev)
-- 
2.25.1

