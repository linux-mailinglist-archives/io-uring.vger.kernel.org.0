Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1F34F0FEB
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 09:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377000AbiDDHWR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 03:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiDDHWR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 03:22:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC2024598
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 00:20:20 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 161AC68AFE; Mon,  4 Apr 2022 09:20:17 +0200 (CEST)
Date:   Mon, 4 Apr 2022 09:20:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, pankydev8@gmail.com,
        javier@javigon.com, joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [RFC 5/5] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220404072016.GD444@lst.de>
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150@epcas5p2.samsung.com> <20220401110310.611869-6-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401110310.611869-6-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 01, 2022 at 04:33:10PM +0530, Kanchan Joshi wrote:
> Introduce handler for fops->async_cmd(), implementing async passthru
> on char device (/dev/ngX). The handler supports NVME_IOCTL_IO64_CMD.

I really don't like how this still mixes up ioctls and uring cmds,
as mentioned close to half a dozend times we really should not mix
them up.  Something like this (untested) patch should help to separate
the much better:

---
From e145d515929f086b2dadf8816e1397eb287f8ae0 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Mon, 4 Apr 2022 07:22:33 +0200
Subject: nvme: split the uring cmd path from the regular ioctl path

io_uring async commands are not ioctls, and we should not reuse
opcodes or otherwise pretend that they are the same.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/ioctl.c       | 222 ++++++++++++++++++++------------
 include/uapi/linux/nvme_ioctl.h |   3 +
 2 files changed, 141 insertions(+), 84 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 1d15694d411c0..ea6cfd4321942 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2011-2014, Intel Corporation.
  * Copyright (c) 2017-2021 Christoph Hellwig.
  */
+#include <linux/blk-integrity.h>
 #include <linux/ptrace.h>	/* for force_successful_syscall_return */
 #include <linux/nvme_ioctl.h>
 #include "nvme.h"
@@ -19,6 +20,23 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
 
+static int nvme_ioctl_finish_metadata(struct bio *bio, int ret,
+		void __user *meta_ubuf)
+{
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	if (bip) {
+		void *meta = bvec_virt(bip->bip_vec);
+
+		if (!ret && bio_op(bio) == REQ_OP_DRV_IN &&
+		    copy_to_user(meta_ubuf, meta, bip->bip_vec->bv_len))
+			ret = -EFAULT;
+		kfree(meta);
+	}
+
+	return ret;
+}
+
 /*
  * This overlays struct io_uring_cmd pdu.
  * Expect build errors if this grows larger than that.
@@ -28,9 +46,7 @@ struct nvme_uring_cmd_pdu {
 		struct bio *bio;
 		struct request *req;
 	};
-	void *meta; /* kernel-resident buffer */
 	void __user *meta_buffer;
-	u32 meta_len;
 } __packed;
 
 static struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(struct io_uring_cmd *ioucmd)
@@ -38,12 +54,11 @@ static struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(struct io_uring_cmd *ioucmd
 	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
 }
 
-static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
+static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	struct request *req = pdu->req;
 	struct bio *bio = req->bio;
-	bool write = (req_op(req) == REQ_OP_DRV_OUT);
 	int status;
 	u64 result;
 
@@ -56,12 +71,7 @@ static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
 	blk_mq_free_request(req);
 	blk_rq_unmap_user(bio);
 
-	if (pdu->meta && !status && !write) {
-		if (copy_to_user(pdu->meta_buffer, pdu->meta, pdu->meta_len))
-			status = -EFAULT;
-	}
-	kfree(pdu->meta);
-
+	status = nvme_ioctl_finish_metadata(bio, status, pdu->meta_buffer);
 	result = le64_to_cpu(nvme_req(req)->result.u64);
 	io_uring_cmd_done(ioucmd, status, result);
 }
@@ -77,21 +87,7 @@ static void nvme_end_async_pt(struct request *req, blk_status_t err)
 	req->bio = bio;
 
 	/* this takes care of moving rest of completion-work to task context */
-	io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
-}
-
-static void nvme_setup_uring_cmd_data(struct request *rq,
-		struct io_uring_cmd *ioucmd, void *meta,
-		void __user *meta_buffer, u32 meta_len)
-{
-	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
-
-	/* to free bio on completion, as req->bio will be null at that time */
-	pdu->bio = rq->bio;
-	pdu->meta = meta;
-	pdu->meta_buffer = meta_buffer;
-	pdu->meta_len = meta_len;
-	rq->end_io_data = ioucmd;
+	io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 }
 
 static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
@@ -128,11 +124,10 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 	return ERR_PTR(ret);
 }
 
-static int nvme_submit_user_cmd(struct request_queue *q,
+static struct request *nvme_alloc_user_request(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout,
-		struct io_uring_cmd *ioucmd)
+		u32 meta_seed, unsigned timeout)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -144,7 +139,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 
 	req = nvme_alloc_request(q, cmd, 0);
 	if (IS_ERR(req))
-		return PTR_ERR(req);
+		return req;
 
 	if (timeout)
 		req->timeout = timeout;
@@ -169,28 +164,47 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		}
 	}
 
-	if (ioucmd) { /* async dispatch */
-		nvme_setup_uring_cmd_data(req, ioucmd, meta, meta_buffer,
-				meta_len);
-		blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
-		return -EIOCBQUEUED;
-	}
+	return req;
+
+out_unmap:
+	if (bio)
+		blk_rq_unmap_user(bio);
+out:
+	blk_mq_free_request(req);
+	return ERR_PTR(ret);
+}
+
+static int nvme_execute_user_rq(struct request *req,
+		void __user *meta_buffer, u64 *result)
+{
+	struct bio *bio = req->bio;
+	int ret;
+
 	ret = nvme_execute_passthru_rq(req);
+
 	if (result)
 		*result = le64_to_cpu(nvme_req(req)->result.u64);
-	if (meta && !ret && !write) {
-		if (copy_to_user(meta_buffer, meta, meta_len))
-			ret = -EFAULT;
-	}
-	kfree(meta);
- out_unmap:
+	ret = nvme_ioctl_finish_metadata(bio, ret, meta_buffer);
+
 	if (bio)
 		blk_rq_unmap_user(bio);
- out:
 	blk_mq_free_request(req);
 	return ret;
 }
 
+static int nvme_submit_user_cmd(struct request_queue *q,
+		struct nvme_command *cmd, void __user *ubuffer,
+		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
+		u32 meta_seed, u64 *result, unsigned timeout)
+{
+	struct request *req;
+
+	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
+			meta_len, meta_seed, timeout);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	return nvme_execute_user_rq(req, meta_buffer, result);
+}
 
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
@@ -252,7 +266,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
 	return nvme_submit_user_cmd(ns->queue, &c,
 			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0, NULL);
+			metadata, meta_len, lower_32_bits(io.slba), NULL, 0);
 }
 
 static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
@@ -306,7 +320,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout, NULL);
+			0, &result, timeout);
 
 	if (status >= 0) {
 		if (put_user(result, &ucmd->result))
@@ -317,57 +331,98 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 }
 
 static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd64 __user *ucmd,
-			struct io_uring_cmd *ioucmd)
+			struct nvme_passthru_cmd64 __user *ucmd)
 {
-	struct nvme_passthru_cmd64 cmd, *cptr;
+	struct nvme_passthru_cmd64 cmd;
 	struct nvme_command c;
 	unsigned timeout = 0;
 	int status;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	if (!ioucmd) {
-		if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
-			return -EFAULT;
-		cptr = &cmd;
-	} else {
-		cptr = (struct nvme_passthru_cmd64 *)ioucmd->cmd;
-	}
-	if (cptr->flags)
+	if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
+		return -EFAULT;
+	if (cmd.flags)
 		return -EINVAL;
-	if (!nvme_validate_passthru_nsid(ctrl, ns, cptr->nsid))
+	if (!nvme_validate_passthru_nsid(ctrl, ns, cmd.nsid))
 		return -EINVAL;
 
 	memset(&c, 0, sizeof(c));
-	c.common.opcode = cptr->opcode;
-	c.common.flags = cptr->flags;
-	c.common.nsid = cpu_to_le32(cptr->nsid);
-	c.common.cdw2[0] = cpu_to_le32(cptr->cdw2);
-	c.common.cdw2[1] = cpu_to_le32(cptr->cdw3);
-	c.common.cdw10 = cpu_to_le32(cptr->cdw10);
-	c.common.cdw11 = cpu_to_le32(cptr->cdw11);
-	c.common.cdw12 = cpu_to_le32(cptr->cdw12);
-	c.common.cdw13 = cpu_to_le32(cptr->cdw13);
-	c.common.cdw14 = cpu_to_le32(cptr->cdw14);
-	c.common.cdw15 = cpu_to_le32(cptr->cdw15);
-
-	if (cptr->timeout_ms)
-		timeout = msecs_to_jiffies(cptr->timeout_ms);
+	c.common.opcode = cmd.opcode;
+	c.common.flags = cmd.flags;
+	c.common.nsid = cpu_to_le32(cmd.nsid);
+	c.common.cdw2[0] = cpu_to_le32(cmd.cdw2);
+	c.common.cdw2[1] = cpu_to_le32(cmd.cdw3);
+	c.common.cdw10 = cpu_to_le32(cmd.cdw10);
+	c.common.cdw11 = cpu_to_le32(cmd.cdw11);
+	c.common.cdw12 = cpu_to_le32(cmd.cdw12);
+	c.common.cdw13 = cpu_to_le32(cmd.cdw13);
+	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
+	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
+
+	if (cmd.timeout_ms)
+		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
-			nvme_to_user_ptr(cptr->addr), cptr->data_len,
-			nvme_to_user_ptr(cptr->metadata), cptr->metadata_len,
-			0, &cptr->result, timeout, ioucmd);
+			nvme_to_user_ptr(cmd.addr), cmd.data_len,
+			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
+			0, &cmd.result, timeout);
 
-	if (!ioucmd && status >= 0) {
-		if (put_user(cptr->result, &ucmd->result))
+	if (status >= 0) {
+		if (put_user(cmd.result, &ucmd->result))
 			return -EFAULT;
 	}
 
 	return status;
 }
 
+static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
+		struct io_uring_cmd *ioucmd)
+{
+	struct nvme_passthru_cmd64 *cmd =
+		(struct nvme_passthru_cmd64 *)ioucmd->cmd;
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
+	struct nvme_command c;
+	struct request *req;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (cmd->flags || cmd->result)
+		return -EINVAL;
+	if (!nvme_validate_passthru_nsid(ctrl, ns, cmd->nsid))
+		return -EINVAL;
+
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
+			msecs_to_jiffies(cmd->timeout_ms) : 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	/* to free bio on completion, as req->bio will be null at that time */
+	pdu->bio = req->bio;
+	pdu->meta_buffer = nvme_to_user_ptr(cmd->metadata);
+	req->end_io_data = ioucmd;
+
+	blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
+	return -EIOCBQUEUED;
+}
+
 static bool is_ctrl_ioctl(unsigned int cmd)
 {
 	if (cmd == NVME_IOCTL_ADMIN_CMD || cmd == NVME_IOCTL_ADMIN64_CMD)
@@ -384,7 +439,7 @@ static int nvme_ctrl_ioctl(struct nvme_ctrl *ctrl, unsigned int cmd,
 	case NVME_IOCTL_ADMIN_CMD:
 		return nvme_user_cmd(ctrl, NULL, argp);
 	case NVME_IOCTL_ADMIN64_CMD:
-		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
+		return nvme_user_cmd64(ctrl, NULL, argp);
 	default:
 		return sed_ioctl(ctrl->opal_dev, cmd, argp);
 	}
@@ -428,7 +483,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
 	case NVME_IOCTL_SUBMIT_IO:
 		return nvme_submit_io(ns, argp);
 	case NVME_IOCTL_IO64_CMD:
-		return nvme_user_cmd64(ns->ctrl, ns, argp, NULL);
+		return nvme_user_cmd64(ns->ctrl, ns, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -457,13 +512,13 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return __nvme_ioctl(ns, cmd, (void __user *)arg);
 }
 
-static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
+static int nvme_ns_async_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
 {
 	int ret;
 
 	switch (ioucmd->cmd_op) {
-	case NVME_IOCTL_IO64_CMD:
-		ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);
+	case NVME_URING_CMD_IO:
+		ret = nvme_uring_cmd_io(ns->ctrl, ns, ioucmd);
 		break;
 	default:
 		ret = -ENOTTY;
@@ -476,10 +531,9 @@ int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd)
 {
 	struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
 			struct nvme_ns, cdev);
-	return nvme_ns_async_ioctl(ns, ioucmd);
+	return nvme_ns_async_cmd(ns, ioucmd);
 }
 
-
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -556,7 +610,7 @@ int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd)
 	int ret = -EWOULDBLOCK;
 
 	if (ns)
-		ret = nvme_ns_async_ioctl(ns, ioucmd);
+		ret = nvme_ns_async_cmd(ns, ioucmd);
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
@@ -605,7 +659,7 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 	case NVME_IOCTL_ADMIN_CMD:
 		return nvme_user_cmd(ctrl, NULL, argp);
 	case NVME_IOCTL_ADMIN64_CMD:
-		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
+		return nvme_user_cmd64(ctrl, NULL, argp);
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
diff --git a/include/uapi/linux/nvme_ioctl.h b/include/uapi/linux/nvme_ioctl.h
index d99b5a7726980..39c9d3ecfef88 100644
--- a/include/uapi/linux/nvme_ioctl.h
+++ b/include/uapi/linux/nvme_ioctl.h
@@ -79,4 +79,7 @@ struct nvme_passthru_cmd64 {
 #define NVME_IOCTL_ADMIN64_CMD	_IOWR('N', 0x47, struct nvme_passthru_cmd64)
 #define NVME_IOCTL_IO64_CMD	_IOWR('N', 0x48, struct nvme_passthru_cmd64)
 
+/* io_uring async commands: */
+#define NVME_URING_CMD_IO	_IOWR('N', 0x80, struct nvme_passthru_cmd64)
+
 #endif /* _UAPI_LINUX_NVME_IOCTL_H */
-- 
2.30.2

