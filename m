Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A097A306058
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 16:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbhA0P5g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 10:57:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18819 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbhA0PCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 10:02:41 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210127150152epoutp02ceef6d0b93e060677d9898a845095c59~eHusxYiDz0176701767epoutp02d
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 15:01:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210127150152epoutp02ceef6d0b93e060677d9898a845095c59~eHusxYiDz0176701767epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611759712;
        bh=pO46b6W9obv1H6gBClIsMg+byzc2sMOrVYUWjRJ90jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lf0VDXM2j/qAyvu5yA/uNBo1XyPZbck8rGg9A3X45hTRhbN4X81IncwB332OPKSEz
         fvPZkNCkBhm/g64XZPV4wopW3LbK/qmwf/YxFAF7Ddo0g1XDkGAu0LCwEbxx1MgJN2
         oStOHtHQAKHfd/nw13s/RBAa/XdMIcmi19+vBRHc=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210127150150epcas5p465009be64328ebc2f2a9637f6b82852a~eHurf9T9O0195701957epcas5p4H;
        Wed, 27 Jan 2021 15:01:50 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.33.15682.E5081106; Thu, 28 Jan 2021 00:01:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210127150149epcas5p4fa8edd47712f28ccdd9bac5139fc6e61~eHuqHWsvT0195701957epcas5p4E;
        Wed, 27 Jan 2021 15:01:49 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210127150149epsmtrp28a06b6aee45cf1c8892ce385a9d9b16a~eHuqGafX70989109891epsmtrp2u;
        Wed, 27 Jan 2021 15:01:49 +0000 (GMT)
X-AuditID: b6c32a49-8bfff70000013d42-df-6011805edcd2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.97.08745.D5081106; Thu, 28 Jan 2021 00:01:49 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210127150146epsmtip289bc688b734e5aae6e680eb59f388706~eHun2TZcV1918419184epsmtip24;
        Wed, 27 Jan 2021 15:01:46 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me
Cc:     linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [RFC PATCH 3/4] nvme: add async ioctl support
Date:   Wed, 27 Jan 2021 20:30:28 +0530
Message-Id: <20210127150029.13766-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127150029.13766-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsWy7bCmpm5cg2CCQfdTTYvf06ewWjRN+Mts
        sfpuP5vFytVHmSzetZ5jsXh85zO7xdH/b9ksJh26xmixZ+9JFovLu+awWcxf9pTdYtvv+cwW
        V6YsYrZY9/o9i8XrHyfZHPg9zt/byOJx+Wypx6ZVnWwem5fUe+y+2cDm0bdlFaPH501yAexR
        XDYpqTmZZalF+nYJXBmP9s5lL+hvZ6xoOpLXwNia18XIySEhYCLxeMdvpi5GLg4hgd2MElMW
        n2WHcD4xShxpvcAG4XxmlLj0eQETTMuS1x8ZQWwhgV2MEtN3i8AVzTw/i6WLkYODTUBT4sLk
        UpAaEQEXiQu/D4BNZRaYyCTx7UUv2CBhATOJJT372UFsFgFViZb/F5hBbF4BC4kD726wQCyT
        l5h56TtYDaeApcSVbZtYIWoEJU7OfAJWwwxU07x1NjPIAgmBlRwSx+63M0I0u0g0z/rBDmEL
        S7w6vgXKlpL4/G4vG4RdLPHrzlGo5g5GiesNM6E220tc3POXCeQbZqBv1u/Sh1jGJ9H7+wlY
        WEKAV6KjTQiiWlHi3qSnrBC2uMTDGUugbA+J7uProYHVwyixe2PyBEb5WUhemIXkhVkIyxYw
        Mq9ilEwtKM5NTy02LTDMSy3XK07MLS7NS9dLzs/dxAhOXFqeOxjvPvigd4iRiYPxEKMEB7OS
        CK+dgmCCEG9KYmVValF+fFFpTmrxIUZpDhYlcd4dBg/ihQTSE0tSs1NTC1KLYLJMHJxSDUzt
        d161HexwFfE58ujK7jL5fdzzuLaeeHhRU7SxUXC367klX9qXqMd0v17HHHRz87n5vzdZ2+fp
        fwm/fc/9in+SXou/saALR6nizij2R3Nu6rUlVEhN3Rj4fNK2U+cj8tSnvP7712VxgsA//YC8
        O2zdMzsedfQHdkzVN3oy6cU676OcxbLeki6zHhg93/5xnpzTuWDb8CmXal/zXFtdllAeNKmv
        /vj7Gf8KGu14flowiS8vTxHlT1CcHuaQl+biWOFx0tt688bT0eXu269ZFLyT03264ulu5bfH
        ewzyf57ScvBmWWLtGrmj4PV7fuXZxw90NGv0u32Lt9u2q9GuZo1kxEa56oxlOr+mnTzHb6LE
        UpyRaKjFXFScCAAHW4I6ywMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWy7bCSvG5sg2CCwdO77Ba/p09htWia8JfZ
        YvXdfjaLlauPMlm8az3HYvH4zmd2i6P/37JZTDp0jdFiz96TLBaXd81hs5i/7Cm7xbbf85kt
        rkxZxGyx7vV7FovXP06yOfB7nL+3kcXj8tlSj02rOtk8Ni+p99h9s4HNo2/LKkaPz5vkAtij
        uGxSUnMyy1KL9O0SuDIe7Z3LXtDfzljRdCSvgbE1r4uRk0NCwERiyeuPjF2MXBxCAjsYJY7c
        n84MkRCXaL72gx3CFpZY+e85mC0k8JFRoucFaxcjBwebgKbEhcmlIKaIgJfEtqWGIBXMArOZ
        JBp/RYLYwgJmEkt69oN1sgioSrT8vwA2nVfAQuLAuxssENPlJWZe+g5WwylgKXFl2yZWiE0W
        Eu8nPGSDqBeUODnzCQvEfHmJ5q2zmScwCsxCkpqFJLWAkWkVo2RqQXFuem6xYYFRXmq5XnFi
        bnFpXrpecn7uJkZwxGhp7WDcs+qD3iFGJg7GQ4wSHMxKIrx2CoIJQrwpiZVVqUX58UWlOanF
        hxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTDNVPr69V3ejqc5JnueLbgky+a4pvWK
        uLXnnlmyb1O4Ev/ffzfPd+qep+ZXN7ddv7ZO1zRJobdVNEmDPcCLrTY5sH/aybPmyqzF/1w3
        vBKUKuxzTVi7OaQ1VS+5Y8qmX0ZdU+0vn+5TCk479vnif9mnlxYqHTiw22DjlXXZddPaVrcb
        /DNtEFFk10sI2uYVXGR1+6KU6KPD1x7OOLv7/OTpNbsKfJgXhEU4tamuFFkgt8D1upHJd3/x
        oH+3RecoJihF8/eXvYjpfrbQ6naYwPaaYB45ViPVlR2bHRvuKLPXeDWvmWGyXjpDpVGkMi8n
        o3DVVh1W2x83jQzla9zWsXa67Vl1c+UChvWiF1MZSpRYijMSDbWYi4oTAftuRV0HAwAA
X-CMS-MailID: 20210127150149epcas5p4fa8edd47712f28ccdd9bac5139fc6e61
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210127150149epcas5p4fa8edd47712f28ccdd9bac5139fc6e61
References: <20210127150029.13766-1-joshi.k@samsung.com>
        <CGME20210127150149epcas5p4fa8edd47712f28ccdd9bac5139fc6e61@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add async_ioctl handler that implements asynchronous handling of ioctl
operation. If requested ioctl opcode does not involve submitting a
command to device (e.g. NVME_IOCTL_ID), it is made to return instantly.
Otherwise, ioctl-completion is decoupled from submission, and
-EIOCBQUEUED is returned post submission. When completion arrives from
device, nvme calls the ioctl-completion handler supplied by upper-layer.
But there is execption to that. An ioctl completion may also require
updating certain ioctl-specific user buffers/fields which can be
accessed only in context of original submitter-task. For such ioctl,
nvme-completion schedules a task-work which first updates ioctl-specific
buffers/fields and after that invokes the ioctl-completion handler.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c | 347 +++++++++++++++++++++++++++++++--------
 1 file changed, 280 insertions(+), 67 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 200bdd672c28..57f3040bae34 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -21,6 +21,7 @@
 #include <linux/nvme_ioctl.h>
 #include <linux/pm_qos.h>
 #include <asm/unaligned.h>
+#include <linux/task_work.h>
 
 #include "nvme.h"
 #include "fabrics.h"
@@ -1092,7 +1093,107 @@ static void nvme_passthru_end(struct nvme_ctrl *ctrl, u32 effects)
 	}
 }
 
-void nvme_execute_passthru_rq(struct request *rq)
+struct async_pt_desc {
+	struct bio *bio;
+	int status; /* command status */
+	u64 result; /* nvme cmd result */
+	void __user *res_ptr; /* can be null, 32bit addr or 64 bit addr */
+	void __user *meta_ptr;
+	void *meta; /* kernel-space resident buffer */
+	unsigned metalen; /* length of meta */
+	bool is_res64 : 1; /* res_ptr refers to 64bit of space */
+	bool is_write : 1;
+	bool is_taskwork : 1;
+};
+
+static int nvme_add_task_work(struct task_struct *tsk,
+			struct callback_head *twork,
+			task_work_func_t work_func)
+{
+	int ret;
+
+	get_task_struct(tsk);
+	init_task_work(twork, work_func);
+	ret = task_work_add(tsk, twork, TWA_SIGNAL);
+	if (!ret)
+		wake_up_process(tsk);
+	return ret;
+}
+
+static void async_pt_update_work(struct callback_head *cbh)
+{
+	struct pt_ioctl_ctx *ptioc;
+	struct async_pt_desc *ptd;
+	struct task_struct *tsk;
+	int ret;
+
+	ptioc = container_of(cbh, struct pt_ioctl_ctx, pt_work);
+	ptd = ptioc->ioc_data;
+	tsk = ptioc->task;
+
+	/* handle meta update */
+	if (ptd->meta) {
+		if (!ptd->status && !ptd->is_write)
+			if (copy_to_user(ptd->meta_ptr, ptd->meta, ptd->metalen))
+				ptd->status = -EFAULT;
+		kfree(ptd->meta);
+	}
+	/* handle result update */
+	if (ptd->res_ptr) {
+		if (!ptd->is_res64)
+			ret = put_user(ptd->result, (u32 __user *)ptd->res_ptr);
+		else
+			ret = put_user(ptd->result, (u64 __user *)ptd->res_ptr);
+		if (ret)
+			ptd->status = -EFAULT;
+	}
+
+	ptioc->pt_complete(ptioc, ptd->status);
+	put_task_struct(tsk);
+	kfree(ptd);
+}
+
+static void nvme_end_async_pt(struct request *req, blk_status_t err)
+{
+	struct pt_ioctl_ctx *ptioc;
+	struct async_pt_desc *ptd;
+	struct bio *bio;
+
+	ptioc = req->end_io_data;
+	ptd = ptioc->ioc_data;
+
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		ptd->status = -EINTR;
+	else
+		ptd->status = nvme_req(req)->status;
+
+	ptd->result = le64_to_cpu(nvme_req(req)->result.u64);
+	bio = ptd->bio;
+	/* setup task work if needed */
+	if (ptd->is_taskwork) {
+		int ret = nvme_add_task_work(ptioc->task, &ptioc->pt_work,
+				async_pt_update_work);
+		/* update failure if task-work could not be setup */
+		if (ret < 0) {
+			put_task_struct(ptioc->task);
+			ptioc->pt_complete(ptioc, ret);
+			kfree(ptd->meta);
+			kfree(ptd);
+		}
+	} else {
+		/* return status via callback, nothing else to update */
+		ptioc->pt_complete(ptioc, ptd->status);
+		kfree(ptd);
+	}
+
+	/* unmap pages, free bio, nvme command and request */
+	blk_rq_unmap_user(bio);
+	kfree(nvme_req(req)->cmd);
+	blk_mq_free_request(req);
+}
+
+
+void nvme_execute_passthru_rq_common(struct request *rq, int async)
 {
 	struct nvme_command *cmd = nvme_req(rq)->cmd;
 	struct nvme_ctrl *ctrl = nvme_req(rq)->ctrl;
@@ -1101,15 +1202,52 @@ void nvme_execute_passthru_rq(struct request *rq)
 	u32 effects;
 
 	effects = nvme_passthru_start(ctrl, ns, cmd->common.opcode);
-	blk_execute_rq(rq->q, disk, rq, 0);
+	if (!async)
+		blk_execute_rq(rq->q, disk, rq, 0);
+	else
+		blk_execute_rq_nowait(rq->q, disk, rq, 0, nvme_end_async_pt);
 	nvme_passthru_end(ctrl, effects);
 }
+
+void nvme_execute_passthru_rq(struct request *rq)
+{
+	return nvme_execute_passthru_rq_common(rq, 0);
+}
 EXPORT_SYMBOL_NS_GPL(nvme_execute_passthru_rq, NVME_TARGET_PASSTHRU);
 
+static int setup_async_pt_desc(struct request *rq, struct pt_ioctl_ctx *ptioc,
+		void __user *resptr, void __user *meta_buffer, void *meta,
+		unsigned meta_len, bool write, bool is_res64)
+{
+	struct async_pt_desc *ptd;
+
+	ptd = kzalloc(sizeof(struct async_pt_desc), GFP_KERNEL);
+	if (!ptd)
+		return -ENOMEM;
+
+	/* to free bio on completion, as req->bio will be null at that time */
+	ptd->bio = rq->bio;
+	ptd->res_ptr = resptr;
+	ptd->is_write = write;
+	ptd->is_res64 = is_res64;
+	if (meta) {
+		ptd->meta_ptr = meta_buffer;
+		ptd->meta = meta;
+		ptd->metalen = meta_len;
+	}
+	if (resptr)
+		ptd->is_taskwork = 1;
+
+	ptioc->ioc_data = ptd;
+	rq->end_io_data = ptioc;
+	return 0;
+}
+
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout)
+		u32 meta_seed, u64 *result, unsigned timeout,
+		struct pt_ioctl_ctx *ptioc, bool is_res64)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -1145,6 +1283,18 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		}
 	}
 
+	if (ptioc) { /* async handling */
+		ret = setup_async_pt_desc(req, ptioc, result, meta_buffer,
+			       meta, meta_len, write, is_res64);
+		if (ret) {
+			kfree(meta);
+			goto out_unmap;
+		}
+		/* send request for async processing */
+		nvme_execute_passthru_rq_common(req, 1);
+		return ret;
+	}
+	/* sync handling */
 	nvme_execute_passthru_rq(req);
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
 		ret = -EINTR;
@@ -1521,10 +1671,11 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 	return (void __user *)ptrval;
 }
 
-static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
+static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio,
+			struct pt_ioctl_ctx *ptioc)
 {
 	struct nvme_user_io io;
-	struct nvme_command c;
+	struct nvme_command c, *cptr;
 	unsigned length, meta_len;
 	void __user *metadata;
 
@@ -1554,31 +1705,42 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 			return -EINVAL;
 	}
 
-	memset(&c, 0, sizeof(c));
-	c.rw.opcode = io.opcode;
-	c.rw.flags = io.flags;
-	c.rw.nsid = cpu_to_le32(ns->head->ns_id);
-	c.rw.slba = cpu_to_le64(io.slba);
-	c.rw.length = cpu_to_le16(io.nblocks);
-	c.rw.control = cpu_to_le16(io.control);
-	c.rw.dsmgmt = cpu_to_le32(io.dsmgmt);
-	c.rw.reftag = cpu_to_le32(io.reftag);
-	c.rw.apptag = cpu_to_le16(io.apptag);
-	c.rw.appmask = cpu_to_le16(io.appmask);
-
-	return nvme_submit_user_cmd(ns->queue, &c,
+	if (!ptioc)
+		cptr = &c;
+	else { /* for async - allocate cmd dynamically */
+		cptr = kmalloc(sizeof(struct nvme_command), GFP_KERNEL);
+		if (!cptr)
+			return -ENOMEM;
+	}
+
+	memset(cptr, 0, sizeof(c));
+	cptr->rw.opcode = io.opcode;
+	cptr->rw.flags = io.flags;
+	cptr->rw.nsid = cpu_to_le32(ns->head->ns_id);
+	cptr->rw.slba = cpu_to_le64(io.slba);
+	cptr->rw.length = cpu_to_le16(io.nblocks);
+	cptr->rw.control = cpu_to_le16(io.control);
+	cptr->rw.dsmgmt = cpu_to_le32(io.dsmgmt);
+	cptr->rw.reftag = cpu_to_le32(io.reftag);
+	cptr->rw.apptag = cpu_to_le16(io.apptag);
+	cptr->rw.appmask = cpu_to_le16(io.appmask);
+
+	return nvme_submit_user_cmd(ns->queue, cptr,
 			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0);
+			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
+			ptioc, 0);
 }
 
 static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd __user *ucmd)
+			struct nvme_passthru_cmd __user *ucmd,
+			struct pt_ioctl_ctx *ptioc)
 {
 	struct nvme_passthru_cmd cmd;
-	struct nvme_command c;
+	struct nvme_command c, *cptr;
 	unsigned timeout = 0;
 	u64 result;
 	int status;
+	void *resptr;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -1586,43 +1748,61 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		return -EFAULT;
 	if (cmd.flags)
 		return -EINVAL;
+	if (!ptioc) {
+		cptr = &c;
+		resptr = &result;
+	} else {
+		/*
+		 * for async - (a) allocate cmd dynamically
+		 * (b) use user-space result addr
+		 */
+		cptr = kmalloc(sizeof(struct nvme_command), GFP_KERNEL);
+		if (!cptr)
+			return -ENOMEM;
+		resptr = &ucmd->result;
+	}
 
-	memset(&c, 0, sizeof(c));
-	c.common.opcode = cmd.opcode;
-	c.common.flags = cmd.flags;
-	c.common.nsid = cpu_to_le32(cmd.nsid);
-	c.common.cdw2[0] = cpu_to_le32(cmd.cdw2);
-	c.common.cdw2[1] = cpu_to_le32(cmd.cdw3);
-	c.common.cdw10 = cpu_to_le32(cmd.cdw10);
-	c.common.cdw11 = cpu_to_le32(cmd.cdw11);
-	c.common.cdw12 = cpu_to_le32(cmd.cdw12);
-	c.common.cdw13 = cpu_to_le32(cmd.cdw13);
-	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
-	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
+	memset(cptr, 0, sizeof(c));
+	cptr->common.opcode = cmd.opcode;
+	cptr->common.flags = cmd.flags;
+	cptr->common.nsid = cpu_to_le32(cmd.nsid);
+	cptr->common.cdw2[0] = cpu_to_le32(cmd.cdw2);
+	cptr->common.cdw2[1] = cpu_to_le32(cmd.cdw3);
+	cptr->common.cdw10 = cpu_to_le32(cmd.cdw10);
+	cptr->common.cdw11 = cpu_to_le32(cmd.cdw11);
+	cptr->common.cdw12 = cpu_to_le32(cmd.cdw12);
+	cptr->common.cdw13 = cpu_to_le32(cmd.cdw13);
+	cptr->common.cdw14 = cpu_to_le32(cmd.cdw14);
+	cptr->common.cdw15 = cpu_to_le32(cmd.cdw15);
 
 	if (cmd.timeout_ms)
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
-	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
+	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, cptr,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout);
+			0, resptr, timeout, ptioc, 0);
 
-	if (status >= 0) {
+	if (!ptioc && status >= 0) {
 		if (put_user(result, &ucmd->result))
 			return -EFAULT;
 	}
+	/* async case, free cmd in case of error */
+	if (ptioc && status < 0)
+		kfree(cptr);
 
 	return status;
 }
 
 static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd64 __user *ucmd)
+			struct nvme_passthru_cmd64 __user *ucmd,
+			struct pt_ioctl_ctx *ptioc)
 {
 	struct nvme_passthru_cmd64 cmd;
-	struct nvme_command c;
+	struct nvme_command c, *cptr;
 	unsigned timeout = 0;
 	int status;
+	void *resptr;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -1631,31 +1811,43 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	if (cmd.flags)
 		return -EINVAL;
 
-	memset(&c, 0, sizeof(c));
-	c.common.opcode = cmd.opcode;
-	c.common.flags = cmd.flags;
-	c.common.nsid = cpu_to_le32(cmd.nsid);
-	c.common.cdw2[0] = cpu_to_le32(cmd.cdw2);
-	c.common.cdw2[1] = cpu_to_le32(cmd.cdw3);
-	c.common.cdw10 = cpu_to_le32(cmd.cdw10);
-	c.common.cdw11 = cpu_to_le32(cmd.cdw11);
-	c.common.cdw12 = cpu_to_le32(cmd.cdw12);
-	c.common.cdw13 = cpu_to_le32(cmd.cdw13);
-	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
-	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
+	if (!ptioc) {
+		cptr = &c;
+		resptr = &cmd.result;
+	} else {
+		cptr = kmalloc(sizeof(struct nvme_command), GFP_KERNEL);
+		if (!cptr)
+			return -ENOMEM;
+		resptr = &ucmd->result;
+	}
+
+	memset(cptr, 0, sizeof(struct nvme_command));
+	cptr->common.opcode = cmd.opcode;
+	cptr->common.flags = cmd.flags;
+	cptr->common.nsid = cpu_to_le32(cmd.nsid);
+	cptr->common.cdw2[0] = cpu_to_le32(cmd.cdw2);
+	cptr->common.cdw2[1] = cpu_to_le32(cmd.cdw3);
+	cptr->common.cdw10 = cpu_to_le32(cmd.cdw10);
+	cptr->common.cdw11 = cpu_to_le32(cmd.cdw11);
+	cptr->common.cdw12 = cpu_to_le32(cmd.cdw12);
+	cptr->common.cdw13 = cpu_to_le32(cmd.cdw13);
+	cptr->common.cdw14 = cpu_to_le32(cmd.cdw14);
+	cptr->common.cdw15 = cpu_to_le32(cmd.cdw15);
 
 	if (cmd.timeout_ms)
 		timeout = msecs_to_jiffies(cmd.timeout_ms);
 
-	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
+	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, cptr,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &cmd.result, timeout);
+			0, resptr, timeout, ptioc, 1);
 
-	if (status >= 0) {
+	if (!ptioc && status >= 0) {
 		if (put_user(cmd.result, &ucmd->result))
 			return -EFAULT;
 	}
+	if (ptioc && status < 0)
+		kfree(cptr);
 
 	return status;
 }
@@ -1702,7 +1894,8 @@ static bool is_ctrl_ioctl(unsigned int cmd)
 static int nvme_handle_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 				  void __user *argp,
 				  struct nvme_ns_head *head,
-				  int srcu_idx)
+				  int srcu_idx,
+				  struct pt_ioctl_ctx *ptioc)
 {
 	struct nvme_ctrl *ctrl = ns->ctrl;
 	int ret;
@@ -1712,21 +1905,24 @@ static int nvme_handle_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		ret = nvme_user_cmd(ctrl, NULL, argp);
+		ret = nvme_user_cmd(ctrl, NULL, argp, ptioc);
 		break;
 	case NVME_IOCTL_ADMIN64_CMD:
-		ret = nvme_user_cmd64(ctrl, NULL, argp);
+		ret = nvme_user_cmd64(ctrl, NULL, argp, ptioc);
 		break;
 	default:
-		ret = sed_ioctl(ctrl->opal_dev, cmd, argp);
+		if (!ptioc)
+			ret = sed_ioctl(ctrl->opal_dev, cmd, argp);
+		else
+			ret = -EOPNOTSUPP; /* RFP: no support for now */
 		break;
 	}
 	nvme_put_ctrl(ctrl);
 	return ret;
 }
 
-static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
-		unsigned int cmd, unsigned long arg)
+static int nvme_async_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg, struct pt_ioctl_ctx *ptioc)
 {
 	struct nvme_ns_head *head = NULL;
 	void __user *argp = (void __user *)arg;
@@ -1743,33 +1939,49 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 	 * deadlock when deleting namespaces using the passthrough interface.
 	 */
 	if (is_ctrl_ioctl(cmd))
-		return nvme_handle_ctrl_ioctl(ns, cmd, argp, head, srcu_idx);
+		return nvme_handle_ctrl_ioctl(ns, cmd, argp, head, srcu_idx, ptioc);
 
 	switch (cmd) {
 	case NVME_IOCTL_ID:
 		force_successful_syscall_return();
 		ret = ns->head->ns_id;
+		if (ptioc)
+			goto put_ns; /* return in sync fashion always */
 		break;
 	case NVME_IOCTL_IO_CMD:
-		ret = nvme_user_cmd(ns->ctrl, ns, argp);
+		ret = nvme_user_cmd(ns->ctrl, ns, argp, ptioc);
 		break;
 	case NVME_IOCTL_SUBMIT_IO:
-		ret = nvme_submit_io(ns, argp);
+		ret = nvme_submit_io(ns, argp, ptioc);
 		break;
 	case NVME_IOCTL_IO64_CMD:
-		ret = nvme_user_cmd64(ns->ctrl, ns, argp);
+		ret = nvme_user_cmd64(ns->ctrl, ns, argp, ptioc);
 		break;
 	default:
+		if (ptioc) {
+			/* RFP- don't support this for now */
+			ret = -EOPNOTSUPP;
+			break;
+		}
 		if (ns->ndev)
 			ret = nvme_nvm_ioctl(ns, cmd, arg);
 		else
 			ret = -ENOTTY;
 	}
-
+	/* if there is no error, return queued for async-ioctl */
+	if (ptioc && ret >= 0)
+		ret = -EIOCBQUEUED;
+ put_ns:
 	nvme_put_ns_from_disk(head, srcu_idx);
 	return ret;
 }
 
+static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg)
+{
+	return nvme_async_ioctl(bdev, mode, cmd, arg, NULL);
+}
+
 #ifdef CONFIG_COMPAT
 struct nvme_user_io32 {
 	__u8	opcode;
@@ -2324,6 +2536,7 @@ EXPORT_SYMBOL_GPL(nvme_sec_submit);
 static const struct block_device_operations nvme_bdev_ops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= nvme_ioctl,
+	.async_ioctl	= nvme_async_ioctl,
 	.compat_ioctl	= nvme_compat_ioctl,
 	.open		= nvme_open,
 	.release	= nvme_release,
@@ -3261,7 +3474,7 @@ static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
 	kref_get(&ns->kref);
 	up_read(&ctrl->namespaces_rwsem);
 
-	ret = nvme_user_cmd(ctrl, ns, argp);
+	ret = nvme_user_cmd(ctrl, ns, argp, NULL);
 	nvme_put_ns(ns);
 	return ret;
 
@@ -3278,9 +3491,9 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 
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
-- 
2.25.1

