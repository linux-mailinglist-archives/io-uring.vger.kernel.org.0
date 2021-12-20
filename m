Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBDE47B8A8
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhLUC40 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:56:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12736 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbhLUC4Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:56:25 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211221025624epoutp019693094ee38dd96080457755c9d2f31a~Cpa7KNK5E1835318353epoutp01K
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:56:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211221025624epoutp019693094ee38dd96080457755c9d2f31a~Cpa7KNK5E1835318353epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055384;
        bh=ZUldHq0a4MM0PQTzu09Hb3trWCm0rWfi963tcz/Zgn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9l9Kx9ryR/2nYTBgBZNlRWvxxLq+DOTNLyaNij/qipS/h0GsgqSJYyqMgRTR/KUC
         z0IPa/UuHQ6pNxWYgpdv/7KyhSdsx3nUaf64nCYgmAa2jlzSyUG/cN1SIhG6jyLtgP
         iJU+qILNuyHkAf2rCLHiAyXS92CeGv0FFr17Fi3I=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20211221025624epcas5p3ebff1d3eb39e17d688bc71255fef8d7c~Cpa6vWKzA2522725227epcas5p3N;
        Tue, 21 Dec 2021 02:56:24 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4JJ1LS6d6Gz4x9Pv; Tue, 21 Dec
        2021 02:56:16 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.59.05590.E4241C16; Tue, 21 Dec 2021 11:56:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142231epcas5p1482c78f91feabdbc3e62341790ab22e1~CfIsP4ciX2429924299epcas5p1v;
        Mon, 20 Dec 2021 14:22:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142231epsmtrp112a72f9309229ce911c426e5fd46f0f6~CfIsPEWMX2445924459epsmtrp1V;
        Mon, 20 Dec 2021 14:22:31 +0000 (GMT)
X-AuditID: b6c32a4b-723ff700000015d6-b3-61c1424ef8bc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        83.85.29871.6A190C16; Mon, 20 Dec 2021 23:22:30 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142228epsmtip18a65d672b0ca5d59d7c46922940d2c31~CfIqVb2s_0040400404epsmtip1g;
        Mon, 20 Dec 2021 14:22:28 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 02/13] nvme: wire-up support for async-passthru on
 char-device.
Date:   Mon, 20 Dec 2021 19:47:23 +0530
Message-Id: <20211220141734.12206-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGJsWRmVeSWpSXmKPExsWy7bCmuq6f08FEg10dohZNE/4yW6y+289m
        sXL1USaLd63nWCw6T19gsjj/9jCTxaRD1xgt9t7Stpi/7Cm7xZqbT1kcuDx2zrrL7tG84A6L
        x+WzpR6bVnWyeWxeUu+x+2YDm0ffllWMHp83yQVwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7
        x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdqKRQlphTChQKSCwuVtK3synKLy1JVcjILy6x
        VUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIztj1YApjwXz/ipbnC5gaGC85djFycEgI
        mEjM2xraxcjFISSwm1Gi+/pVJgjnE6PEhkMn2SCcb4wSt88/BspwgnXM33qdDcQWEtjLKLFk
        hiiE/ZlRYu7jWpCpbAKaEhcml4KERQSiJS48vwZWzizQwSixs9sWxBYW8Jf4fewEI0g5i4Cq
        xOlebpAwr4CFxOInH5khNslLzLz0nR3E5hSwlDg8exkbRI2gxMmZT1ggRspLNG+dDVU/kUOi
        6yIrxF8uErfX8UKEhSVeHd/CDmFLSbzsb4OyiyV+3TnKDPKhBMhl1xtmskAk7CUu7vnLBDKH
        GeiT9bv0IcKyElNPrWOCWMsn0fv7CTRAeCV2zIOxFSXuTXrKCmGLSzycsQTK9pBY23MWGpo9
        jBJzHu5gnsCoMAvJO7OQvDMLYfUCRuZVjJKpBcW56anFpgXGeanl8AhOzs/dxAhOsFreOxgf
        Pfigd4iRiYPxEKMEB7OSCO+W2fsThXhTEiurUovy44tKc1KLDzGaAoN7IrOUaHI+MMXnlcQb
        mlgamJiZmZlYGpsZKonznkrfkCgkkJ5YkpqdmlqQWgTTx8TBKdXAZGP9MCi26O8F+T0u7/XF
        l7OKnfiSGHii52dwypSle9oqqou37Hqv58MymWVjTW91B1eppFXxtxdFqw8pbd0hGcAfu070
        vL5T15P7k1bevnFmt93LuSEHXbs++OwLsP10bsOmx4ZBrgemup05fTA6csGk/FmaNlUp01ar
        /DqSuH3mY1+vp5eFJv5/mX7Aodsrucl4CeO2fbGr5DTi9z78/OL0xRWsr41cvqwrlZNY01fM
        svb393XTnt1OPbZw7qwlEhrOm868m3NXTKbRaROrqFndBXnrV/dWq7vOiI35GpgZacFiEdv8
        oXPSG9c+PVNNOf8lD3ICxYwzb669+bt58m/XCbnxly+8fJa3w3Aa8xQlluKMREMt5qLiRACl
        y/R+OQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnO6yiQcSDfbdMrFomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY9eDKYwF8/0r
        Wp4vYGpgvOTYxcjJISFgIjF/63U2EFtIYDejxPSdsRBxcYnmaz/YIWxhiZX/ngPZXEA1Hxkl
        NixZwNTFyMHBJqApcWFyKUiNiECsxIdfx5hAapgFJgHV9D8AaxYW8JXYPKWDHaSeRUBV4nQv
        N0iYV8BCYvGTj8wQ8+UlZl76DlbOKWApcXj2Mqh7LCROfPjCAlEvKHFy5hMwmxmovnnrbOYJ
        jAKzkKRmIUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHAlamjsYt6/6oHeI
        kYmD8RCjBAezkgjvltn7E4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQ
        WgSTZeLglGpgarly9MDi/Xu2FwY/U2EXPaC9qD3hA4O+29NPsaELrZ9ffn7x1f1ZV1dEB336
        6ik7Z2pl5Cz/97eWGy6MlCrd8DGhf+HprSbmKVO8H8RsNtTdE9UgcOi9QkfQp+bfCZKyHG9k
        F+s8+y//rmXtc96LK2r/v+lJPaYYV2Z13uGqyduSy5Fncr++q3d/qX4i9I2qJuOa5aWMc7a2
        Zvz9ytcv4H/lw29d2VoTYXMZNvvun1e7zYwuz75YPPPMV9WuwMVObSu8BK94MpR8c3YUKJ9x
        +MUpd7MPh+b+2X+Gjc3r6OW71788X3JocXyyXObXbVzn6roKforv+Otd/liXKdfX4pFNy5/j
        jrtEBe2PRz19mKXEUpyRaKjFXFScCABMYHy38wIAAA==
X-CMS-MailID: 20211220142231epcas5p1482c78f91feabdbc3e62341790ab22e1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142231epcas5p1482c78f91feabdbc3e62341790ab22e1
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142231epcas5p1482c78f91feabdbc3e62341790ab22e1@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce handlers for fops->async_cmd(), implementing async passthru
on char device (including the multipath one).
The handlers supports NVME_IOCTL_IO64_CMD.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c      |   1 +
 drivers/nvme/host/ioctl.c     | 147 +++++++++++++++++++++++++++++++---
 drivers/nvme/host/multipath.c |   1 +
 drivers/nvme/host/nvme.h      |   5 ++
 4 files changed, 145 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 290f26ed74c2..bce2e93d14a3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3670,6 +3670,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.release	= nvme_ns_chr_release,
 	.unlocked_ioctl	= nvme_ns_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.async_cmd	= nvme_ns_chr_async_cmd,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 22314962842d..7d9c51d9c0a8 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -18,6 +18,84 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 		ptrval = (compat_uptr_t)ptrval;
 	return (void __user *)ptrval;
 }
+/* This overlays struct io_uring_cmd pdu (40 bytes) */
+struct nvme_uring_cmd {
+	u32 ioctl_cmd;
+	u32 meta_len;
+	void __user *argp;
+	union {
+		struct bio *bio;
+		struct request *req;
+	};
+	void *meta; /* kernel-resident buffer */
+	void __user *meta_buffer;
+};
+
+static struct nvme_uring_cmd *nvme_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	return (struct nvme_uring_cmd *)&ioucmd->pdu;
+}
+
+static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
+{
+	struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
+	struct nvme_passthru_cmd64 __user *ptcmd64 = cmd->argp;
+	struct request *req = cmd->req;
+	int status;
+	u64 result;
+
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		status = -EINTR;
+	else
+		status = nvme_req(req)->status;
+	result = le64_to_cpu(nvme_req(req)->result.u64);
+
+	/* we can free request */
+	blk_mq_free_request(req);
+
+	if (cmd->meta) {
+		if (status)
+			if (copy_to_user(cmd->meta_buffer, cmd->meta, cmd->meta_len))
+				status = -EFAULT;
+		kfree(cmd->meta);
+	}
+
+	if (put_user(result, &ptcmd64->result))
+		status = -EFAULT;
+	io_uring_cmd_done(ioucmd, status);
+}
+
+static void nvme_end_async_pt(struct request *req, blk_status_t err)
+{
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
+	/* extract bio before reusing the same field for request */
+	struct bio *bio = cmd->bio;
+
+	cmd->req = req;
+	/* this takes care of setting up task-work */
+	io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
+	blk_rq_unmap_user(bio);
+}
+
+static void nvme_setup_uring_cmd_data(struct request *rq,
+		struct io_uring_cmd *ioucmd, void *meta,
+		void __user *meta_buffer, u32 meta_len, bool write)
+{
+	struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
+
+	/* to free bio on completion, as req->bio will be null at that time */
+	cmd->bio = rq->bio;
+	/* meta update is required only for read requests */
+	if (meta && !write) {
+		cmd->meta = meta;
+		cmd->meta_buffer = meta_buffer;
+		cmd->meta_len = meta_len;
+	} else {
+		cmd->meta = NULL;
+	}
+	rq->end_io_data = ioucmd;
+}
 
 static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 		unsigned len, u32 seed, bool write)
@@ -56,7 +134,8 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout)
+		u32 meta_seed, u64 *result, unsigned timeout,
+		struct io_uring_cmd *ioucmd)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -92,6 +171,12 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			req->cmd_flags |= REQ_INTEGRITY;
 		}
 	}
+	if (ioucmd) { /* async dispatch */
+		nvme_setup_uring_cmd_data(req, ioucmd, meta, meta_buffer,
+				meta_len, write);
+		blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
+		return 0;
+	}
 
 	ret = nvme_execute_passthru_rq(req);
 	if (result)
@@ -170,7 +255,8 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
 	return nvme_submit_user_cmd(ns->queue, &c,
 			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0);
+			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
+			NULL);
 }
 
 static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
@@ -224,7 +310,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			nvme_to_user_ptr(cmd.addr), cmd.data_len,
 			nvme_to_user_ptr(cmd.metadata), cmd.metadata_len,
-			0, &result, timeout);
+			0, &result, timeout, NULL);
 
 	if (status >= 0) {
 		if (put_user(result, &ucmd->result))
@@ -235,7 +321,8 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 }
 
 static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd64 __user *ucmd)
+			struct nvme_passthru_cmd64 __user *ucmd,
+			struct io_uring_cmd *ioucmd)
 {
 	struct nvme_passthru_cmd64 cmd;
 	struct nvme_command c;
@@ -270,9 +357,9 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
@@ -296,7 +383,7 @@ static int nvme_ctrl_ioctl(struct nvme_ctrl *ctrl, unsigned int cmd,
 	case NVME_IOCTL_ADMIN_CMD:
 		return nvme_user_cmd(ctrl, NULL, argp);
 	case NVME_IOCTL_ADMIN64_CMD:
-		return nvme_user_cmd64(ctrl, NULL, argp);
+		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
 	default:
 		return sed_ioctl(ctrl->opal_dev, cmd, argp);
 	}
@@ -340,7 +427,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
 	case NVME_IOCTL_SUBMIT_IO:
 		return nvme_submit_io(ns, argp);
 	case NVME_IOCTL_IO64_CMD:
-		return nvme_user_cmd64(ns->ctrl, ns, argp);
+		return nvme_user_cmd64(ns->ctrl, ns, argp, NULL);
 	default:
 		return -ENOTTY;
 	}
@@ -369,6 +456,33 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return __nvme_ioctl(ns, cmd, (void __user *)arg);
 }
 
+static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
+{
+	struct nvme_uring_cmd *cmd = nvme_uring_cmd(ioucmd);
+	int ret;
+
+	switch (cmd->ioctl_cmd) {
+	case NVME_IOCTL_IO64_CMD:
+		ret = nvme_user_cmd64(ns->ctrl, ns, cmd->argp, ioucmd);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	if (ret >= 0)
+		ret = -EIOCBQUEUED;
+	return ret;
+}
+
+int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd,
+		enum io_uring_cmd_flags flags)
+{
+	struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
+			struct nvme_ns, cdev);
+
+	return nvme_ns_async_ioctl(ns, ioucmd);
+}
+
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -412,6 +526,21 @@ int nvme_ns_head_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
+int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd,
+		enum io_uring_cmd_flags flags)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	int ret = -EWOULDBLOCK;
+
+	if (ns)
+		ret = nvme_ns_async_ioctl(ns, ioucmd);
+	srcu_read_unlock(&head->srcu, srcu_idx);
+	return ret;
+}
+
 long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg)
 {
@@ -480,7 +609,7 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 	case NVME_IOCTL_ADMIN_CMD:
 		return nvme_user_cmd(ctrl, NULL, argp);
 	case NVME_IOCTL_ADMIN64_CMD:
-		return nvme_user_cmd64(ctrl, NULL, argp);
+		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 13e5d503ed07..1e59c8e06622 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -423,6 +423,7 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 	.release	= nvme_ns_head_chr_release,
 	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.async_cmd	= nvme_ns_head_chr_async_cmd,
 };
 
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9b095ee01364..9a901b954a87 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -16,6 +16,7 @@
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
+#include <linux/io_uring.h>
 
 #include <trace/events/block.h>
 
@@ -747,6 +748,10 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
+int nvme_ns_chr_async_cmd(struct io_uring_cmd *ucmd,
+		enum io_uring_cmd_flags flags);
+int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ucmd,
+		enum io_uring_cmd_flags flags);
 int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 extern const struct attribute_group *nvme_ns_id_attr_groups[];
-- 
2.25.1

