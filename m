Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E1533D55E
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 15:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhCPODC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 10:03:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42832 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbhCPOCo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 10:02:44 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210316140242epoutp020db942a6999a2f4da43f0a07da1bed4b~s14v3uWJG2937429374epoutp02p
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 14:02:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210316140242epoutp020db942a6999a2f4da43f0a07da1bed4b~s14v3uWJG2937429374epoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615903362;
        bh=akeDu1dcbf20zA+acxip5drXbMvBeQYjrWKxp7SkhRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfEMGRrHM30g8TYE1VHCqp4kzSGNoOZTkwIk+6RlhasiGIhmgRyvfEDSt9s4dBc2j
         bduEx0dM3jixsgsn0PTvZMhjviwkh5lIebnU+OrVY4THTPsA+IahfwppI+880bsF2A
         WF7LIBqHpKiQLVolxnOS/0n6av20bUy3fu8Ysbuo=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210316140241epcas5p12a8acf27b164b7ed9529e41f11b33562~s14uho-FN2091120911epcas5p1P;
        Tue, 16 Mar 2021 14:02:41 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        43.B5.15682.08AB0506; Tue, 16 Mar 2021 23:02:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7~s14uHR0NL0795407954epcas5p3C;
        Tue, 16 Mar 2021 14:02:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210316140240epsmtrp2ac5e06e0b9b7f1a5776e0c375ca85a7b~s14uGXBQf3156531565epsmtrp2I;
        Tue, 16 Mar 2021 14:02:40 +0000 (GMT)
X-AuditID: b6c32a49-8d5ff70000013d42-29-6050ba808565
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.93.13470.08AB0506; Tue, 16 Mar 2021 23:02:40 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210316140238epsmtip2cfe56ce2cc2373dffe29819f94ed2068~s14sTuTbB1114911149epsmtip2e;
        Tue, 16 Mar 2021 14:02:38 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH v3 3/3] nvme: wire up support for async passthrough
Date:   Tue, 16 Mar 2021 19:31:26 +0530
Message-Id: <20210316140126.24900-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316140126.24900-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsWy7bCmpm7DroAEg7d7LSyaJvxltlh9t5/N
        Ytbt1ywWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S22/Z7PbHFlyiJmi9c/TrI5
        8HhcPlvqsWlVJ5vH5iX1HrtvNrB59G1ZxejxeZOcR/uBbqYA9igum5TUnMyy1CJ9uwSujK6L
        u1kLtgZWvHlxlq2B8YtTFyMnh4SAicTUq3/Zuhi5OIQEdjNKtO3byQLhfGKUuPXoBJTzjVFi
        detmNpiWOVMms0Mk9jJKLJm1ixnC+cwocXf+FKAMBwebgKbEhcmlIA0iAgESuw5+ZgKxmQWO
        Mko8WlkNYgsLuEv0TT4JNpRFQFWiaQHINg4OXgELib8XSiF2yUvMvPSdHcTmFLCU2Le3B6yc
        V0BQ4uTMJywQI+UlmrfOBjtBQmAmh8TfXY8ZIZpdJKZe2AxlC0u8Or6FHcKWkvj8bi/UM8US
        v+4chWruYJS43jCTBSJhL3Fxz18mkIOYgX5Zv0sfYhmfRO/vJ2BhCQFeiY42IYhqRYl7k56y
        QtjiEg9nLGGFKPGQeLRFBhI6PYwSPe2rGCcwys9C8sIsJC/MQli2gJF5FaNkakFxbnpqsWmB
        YV5quV5xYm5xaV66XnJ+7iZGcGLS8tzBePfBB71DjEwcjIcYJTiYlUR4TfMCEoR4UxIrq1KL
        8uOLSnNSiw8xSnOwKInz7jB4EC8kkJ5YkpqdmlqQWgSTZeLglGpgElj82LPp7wnhON+UTbOn
        zgmb4Su97NjK2fdXi+3UtNDfubt0w5z2BpfrS58dL1ZzecbPbzHtBmdiwa2lH79XnFq9dvFy
        PbV/jtrac8R+hR7aFVWv2Htp812+mqn7vRUm7hPxnczwfJHA8pdCylUSpiJN5tL3ZnccWppl
        n7VhhxdH46emlSdXuN29Hbzt7WvPs0pvy744vcr05M+oNc2XsQhw9zqy+WuR0cUlV5YHz51n
        lu/gWHvjYgjvhdnhvY7bN3nKOuxf4aorayPy9ttjvtNCdU7uF7eeLPeYxcyzZeWf7RF2yZnt
        WU/7Hvis9r71XfKCcHxW/mIp6YTWhdvVPnKVLLmonDvzvEP2uk2Zr5RYijMSDbWYi4oTAcDV
        N++7AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWy7bCSvG7DroAEg/YmcYumCX+ZLVbf7Wez
        mHX7NYvFytVHmSzetZ5jsXh85zO7xdH/b9ksJh26xmgxf9lTdottv+czW1yZsojZ4vWPk2wO
        PB6Xz5Z6bFrVyeaxeUm9x+6bDWwefVtWMXp83iTn0X6gmymAPYrLJiU1J7MstUjfLoEro+vi
        btaCrYEVb16cZWtg/OLUxcjJISFgIjFnymT2LkYuDiGB3YwSdz/+YodIiEs0X/sBZQtLrPz3
        HKroI6PEx/NtzF2MHBxsApoSFyaXgtSICIRIdM3bxgRSwyxwllFi+eN2RpCEsIC7RN/kk2wg
        NouAqkTTghMsIL28AhYSfy+UQsyXl5h56TvYLk4BS4l9e3vAyoWASqafvARm8woISpyc+YQF
        xGYGqm/eOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMeF
        luYOxu2rPugdYmTiYDzEKMHBrCTCa5oXkCDEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXgh
        gfTEktTs1NSC1CKYLBMHp1QDkw3rq+xKq0WZFTfmbk/1kJ3/fOb2Sy5XrZM/fGj9rd5uX/DY
        WyDi0ybXWeum/DLX0C52uBMu2ap3XJ61X6v4gMzjIxdF8lKXTi1ZmVkhcF9fucfOI1qLrzFG
        TmzSj3Z9h2OKNW8Y/she0c+LPpztnO55l7G6Qqt3SsxGd6kwzhn3lCarstQfec3wIkno9DbD
        FX7TpudJiG4tnFPP32BbvFlyd+wGvcu/9h9+uenDvc8ekd7udga3tsqUGoZsPBQuYmb/Veap
        g9GF7uAMruDZTty5xbrv/0awKLxO3Xq14C/bSpegbBfdlHCBnps906fsnKMzb9emM+nMG2d/
        7+cIsGtJOLio/+6Mnc/ZNm9VYinOSDTUYi4qTgQAENB5ZvoCAAA=
X-CMS-MailID: 20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7
References: <20210316140126.24900-1-joshi.k@samsung.com>
        <CGME20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce handler for mq_ops->uring_cmd(), implementing async
passthrough on block-device.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/core.c | 180 ++++++++++++++++++++++++++++++++++-----
 drivers/nvme/host/nvme.h |   3 +
 drivers/nvme/host/pci.c  |   1 +
 3 files changed, 162 insertions(+), 22 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 46c1bb7a89f0..c4f0e54fe9a5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1053,6 +1053,88 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
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
+ * This is carved within the block_uring_cmd, to avoid dynamic allocation.
+ * Care should be taken not to grow this beyond what is available.
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
+inline u64 *ucmd_data_addr(struct io_uring_cmd *ioucmd)
+{
+	return &(((struct block_uring_cmd *)&ioucmd->pdu)->unused[0]);
+}
+
+void ioucmd_task_cb(struct io_uring_cmd *ioucmd)
+{
+	struct uring_cmd_data *ucd;
+	struct nvme_passthru_cmd __user *ptcmd;
+	struct block_uring_cmd *bcmd;
+
+	bcmd = (struct block_uring_cmd *) &ioucmd->pdu;
+	ptcmd = (void __user *) bcmd->addr;
+	ucd = (struct uring_cmd_data *) ucmd_data_addr(ioucmd);
+
+	/* handle meta update */
+	if (ucd->meta) {
+		void __user *umeta = nvme_to_user_ptr(ptcmd->metadata);
+
+		if (!ucd->status)
+			if (copy_to_user(umeta, ucd->meta, ptcmd->metadata_len))
+				ucd->status = -EFAULT;
+		kfree(ucd->meta);
+	}
+	/* handle result update */
+	if (put_user(ucd->result, (u32 __user *)&ptcmd->result))
+		ucd->status = -EFAULT;
+	io_uring_cmd_done(ioucmd, ucd->status);
+}
+
+void nvme_end_async_pt(struct request *req, blk_status_t err)
+{
+	struct io_uring_cmd *ioucmd;
+	struct uring_cmd_data *ucd;
+	struct bio *bio;
+	int ret;
+
+	ioucmd = req->end_io_data;
+	ucd = (struct uring_cmd_data *) ucmd_data_addr(ioucmd);
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
+	ret = uring_cmd_complete_in_task(ioucmd, ioucmd_task_cb);
+	if (ret < 0)
+		kfree(ucd->meta);
+
+	/* unmap pages, free bio, nvme command and request */
+	blk_rq_unmap_user(bio);
+	blk_mq_free_request(req);
+}
+
 static u32 nvme_known_admin_effects(u8 opcode)
 {
 	switch (opcode) {
@@ -1140,10 +1222,27 @@ void nvme_execute_passthru_rq(struct request *rq)
 }
 EXPORT_SYMBOL_NS_GPL(nvme_execute_passthru_rq, NVME_TARGET_PASSTHRU);
 
+static void nvme_setup_uring_cmd_data(struct request *rq,
+		struct io_uring_cmd *ioucmd, void *meta, bool write)
+{
+	struct uring_cmd_data *ucd;
+
+	ucd = (struct uring_cmd_data *) ucmd_data_addr(ioucmd);
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
+		u32 meta_seed, u64 *result, unsigned int timeout,
+		struct io_uring_cmd *ioucmd)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -1179,6 +1278,20 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			req->cmd_flags |= REQ_INTEGRITY;
 		}
 	}
+	if (ioucmd) { /* async handling */
+		u32 effects;
+
+		effects = nvme_command_effects(ns->ctrl, ns, cmd->common.opcode);
+		/* filter commands with non-zero effects, keep it simple for now*/
+		if (effects) {
+			ret = -EOPNOTSUPP;
+			goto out_unmap;
+		}
+		nvme_setup_uring_cmd_data(req, ioucmd, meta, write);
+		blk_execute_rq_nowait(ns ? ns->disk : NULL, req, 0,
+					nvme_end_async_pt);
+		return 0;
+	}
 
 	nvme_execute_passthru_rq(req);
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
@@ -1544,18 +1657,6 @@ static void nvme_enable_aen(struct nvme_ctrl *ctrl)
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
@@ -1616,11 +1717,13 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
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
@@ -1654,9 +1757,9 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
@@ -1698,7 +1801,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &cmd.result, timeout);
+			0, &cmd.result, timeout, NULL);
 
 	if (status >= 0) {
 		if (put_user(cmd.result, &ucmd->result))
@@ -1760,7 +1863,7 @@ static int nvme_handle_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		ret = nvme_user_cmd(ctrl, NULL, argp);
+		ret = nvme_user_cmd(ctrl, NULL, argp, NULL);
 		break;
 	case NVME_IOCTL_ADMIN64_CMD:
 		ret = nvme_user_cmd64(ctrl, NULL, argp);
@@ -1799,7 +1902,7 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 		ret = ns->head->ns_id;
 		break;
 	case NVME_IOCTL_IO_CMD:
-		ret = nvme_user_cmd(ns->ctrl, ns, argp);
+		ret = nvme_user_cmd(ns->ctrl, ns, argp, NULL);
 		break;
 	case NVME_IOCTL_SUBMIT_IO:
 		ret = nvme_submit_io(ns, argp);
@@ -1818,6 +1921,39 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
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
+	void __user *argp = (void __user *) bcmd->addr;
+
+	BUILD_BUG_ON(sizeof(struct uring_cmd_data) >
+			sizeof(struct block_uring_cmd) -
+			offsetof(struct block_uring_cmd, unused));
+
+	ns = nvme_get_ns_from_disk(bdev->bd_disk, &head, &srcu_idx);
+	if (unlikely(!ns))
+		return -EWOULDBLOCK;
+
+	switch (bcmd->ioctl_cmd) {
+	case NVME_IOCTL_IO_CMD:
+		ret = nvme_user_cmd(ns->ctrl, ns, argp, ioucmd);
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
@@ -3309,7 +3445,7 @@ static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
 	kref_get(&ns->kref);
 	up_read(&ctrl->namespaces_rwsem);
 
-	ret = nvme_user_cmd(ctrl, ns, argp);
+	ret = nvme_user_cmd(ctrl, ns, argp, NULL);
 	nvme_put_ns(ns);
 	return ret;
 
@@ -3326,7 +3462,7 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ctrl, NULL, argp);
+		return nvme_user_cmd(ctrl, NULL, argp, NULL);
 	case NVME_IOCTL_ADMIN64_CMD:
 		return nvme_user_cmd64(ctrl, NULL, argp);
 	case NVME_IOCTL_IO_CMD:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 0254aa611dfa..f3daee4a4848 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -19,6 +19,7 @@
 #include <linux/t10-pi.h>
 
 #include <trace/events/block.h>
+#include <linux/io_uring.h>
 
 extern unsigned int nvme_io_timeout;
 #define NVME_IO_TIMEOUT	(nvme_io_timeout * HZ)
@@ -620,6 +621,8 @@ int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout);
 void nvme_start_freeze(struct nvme_ctrl *ctrl);
 
 #define NVME_QID_ANY -1
+int nvme_uring_cmd(struct request_queue *q, struct io_uring_cmd *ucmd,
+		enum io_uring_cmd_flags flags);
 struct request *nvme_alloc_request(struct request_queue *q,
 		struct nvme_command *cmd, blk_mq_req_flags_t flags);
 void nvme_cleanup_cmd(struct request *req);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7b6632c00ffd..6c84dc964259 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1629,6 +1629,7 @@ static const struct blk_mq_ops nvme_mq_ops = {
 	.map_queues	= nvme_pci_map_queues,
 	.timeout	= nvme_timeout,
 	.poll		= nvme_poll,
+	.uring_cmd	= nvme_uring_cmd,
 };
 
 static void nvme_dev_remove_admin(struct nvme_dev *dev)
-- 
2.25.1

