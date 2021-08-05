Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00153E157F
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 15:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbhHENQO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 09:16:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19397 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241689AbhHENQN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 09:16:13 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210805131557epoutp02d470e327928e2ee7528b4f77dced59d2~Ya2ePghM_2001820018epoutp02O
        for <io-uring@vger.kernel.org>; Thu,  5 Aug 2021 13:15:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210805131557epoutp02d470e327928e2ee7528b4f77dced59d2~Ya2ePghM_2001820018epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628169357;
        bh=UfNfFP/HvK6UUkMuGKlDLjqiAWDFaJ5zTHIOBYsdYl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flJMXu2et3G3QWT9SZoavVZDVVCo2gw9P0/OTRV6otaZcXdGFs6gdLwA7pbdjuzbr
         ivassKKCQvNOAk+jHaKdTDwyvdG8MvdDyqEsitPN2GJsngXgFCgFDQLwbLUmimmRmt
         X2nbwNxhRSAdB+SuSfoMNEpQgVgUexpKDhXuRdvs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210805131557epcas5p470d35a56b751c80b7451ae714062b233~Ya2dhoWg02580725807epcas5p4J;
        Thu,  5 Aug 2021 13:15:57 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GgTd42ZX4z4x9Pt; Thu,  5 Aug
        2021 13:15:52 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.FB.40257.884EB016; Thu,  5 Aug 2021 22:15:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210805125923epcas5p10e6c1b95475440be68f58244d5a3cb9a~Yan-yGFba2708927089epcas5p1f;
        Thu,  5 Aug 2021 12:59:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210805125923epsmtrp11100e7736400842a8d80ac9904006ac0~Yan-xUa5k3021830218epsmtrp1U;
        Thu,  5 Aug 2021 12:59:23 +0000 (GMT)
X-AuditID: b6c32a49-ed1ff70000019d41-18-610be488f054
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.C5.08394.AA0EB016; Thu,  5 Aug 2021 21:59:22 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210805125921epsmtip1c97de7c8a0c52d5b743e3737d62769dd~Yan_MtK7e0926409264epsmtip1G;
        Thu,  5 Aug 2021 12:59:21 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com, hare@suse.de,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 2/6] nvme: wire-up support for async-passthru on
 char-device.
Date:   Thu,  5 Aug 2021 18:25:35 +0530
Message-Id: <20210805125539.66958-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805125539.66958-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmum7HE+5Eg/1tghZNE/4yW6y+289m
        sWfRJCaLlauPMlm8az3HYvH4zmd2i6P/37JZTDp0jdFi/rKn7BZXpixiduDyuHy21GPTqk42
        j81L6j1232xg8+jbsorRY/Ppao/Pm+QC2KOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
        dQ0tLcyVFPISc1NtlVx8AnTdMnOAjlNSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTk
        FJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGe0LvzPUvAhvmL/+haWBsal/l2MnBwSAiYSO5c+
        Yuti5OIQEtjNKDFrfwc7hPOJUWLSp+VQzjdGiUfrHjPDtNxatoQJIrGXUWLxgovMEM5nRomX
        jWtYuxg5ONgENCUuTC4FaRARMJLY/+kkK0gNs8AiRomt93+DTRIWCJY4/egpC4jNIqAqsfXo
        Q1YQm1fAQuL1i7+sENvkJWZe+s4OYnMKWEp8PrQXqkZQ4uTMJ2C9zEA1zVtngx0hIdDLIdFy
        8x5Us4vEz8vvGSFsYYlXx7ewQ9hSEi/726DsYolfd45CNXcwSlxvmMkCkbCXuLjnLxPIN8xA
        36zfpQ8RlpWYemodE8RiPone30+YIOK8EjvmwdiKEvcmPYW6QVzi4YwlULaHxPdZS6FB18Mo
        cfPrOZYJjAqzkDw0C8lDsxBWL2BkXsUomVpQnJueWmxaYJiXWg6P5+T83E2M4CSr5bmD8e6D
        D3qHGJk4GA8xSnAwK4nwJi/mShTiTUmsrEotyo8vKs1JLT7EaAoM8YnMUqLJ+cA0n1cSb2hi
        aWBiZmZmYmlsZqgkzsse/zVBSCA9sSQ1OzW1ILUIpo+Jg1OqgUl0qanhV+dDq+KuVcdxdWk2
        1SqEv3a+Id+8uCbpr0zSSQ1fc4Yna3bP+lQvxMVmPMstTud5/1y/A9wiDkl9ytvFrvHub7Ba
        f+NLkLJfW86iwDku1VVmq8+5sCyferX6wLbeeA3lGb/XLHOoO56brr2o7vIRscNsPs9P2Gq/
        NpyYmrH4xuyQtYmpLnGnrj9VWP838sOBhHeZzjtiNporv+05ZDRXxnKnxSzu7XNvtGr4xQZ8
        Wdbokl+0ia2zYFFznv2ycBuHzmkiWm9Ud4dqH9sv0Zhy59i3zbs1Z+rnyljYpwWLV9W7WN+a
        Zz3t688zhSfKpq58VRBx+FHNsT6PwOmlrWWzNHs2nCr1uJM5VYmlOCPRUIu5qDgRAHBKaEo7
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWy7bCSnO6qB9yJBr8brSyaJvxltlh9t5/N
        Ys+iSUwWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S2uTFnE7MDlcflsqcemVZ1s
        HpuX1HvsvtnA5tG3ZRWjx+bT1R6fN8kFsEdx2aSk5mSWpRbp2yVwZbQu/M9S8CG+Yv/6FpYG
        xqX+XYycHBICJhK3li1h6mLk4hAS2M0oMbX9CSNEQlyi+doPdghbWGLlv+dgtpDAR0aJvZ2h
        XYwcHGwCmhIXJpeChEUEzCSWHl7DAjKHWWAFo8Tuvt9gc4QFAiXubP7NCmKzCKhKbD36EMzm
        FbCQeP3iLyvEfHmJmZe+g83nFLCU+HxoLyvIfCGgmplbIyDKBSVOznzCAmIzA5U3b53NPIFR
        YBaS1CwkqQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYLDX0tzB+P2VR/0DjEy
        cTAeYpTgYFYS4U1ezJUoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQi
        mCwTB6dUAxPTO/XCp08T1n2+7/kwOu6m7taE98L5nc0zNqyT+ma/dV73Ibtvy+98uxzn0Mt6
        I2Zvz6K1HLoboxTELRTuvAjhKJM39FJY/+7N3j2KZ5yn+P67I5WmpHt19maFXqvT6zi/VzD6
        cG91Xig4Xbvhz/cLV/UrhUW92vbMXXkqwcRZJjW27kfqJZdsFekHSra3rF45cmu9U18j3nur
        MSxLY/OcmCunP2SqRrzWLe49XjhvQekHR8UjisVn2J2LLmvzSQXecvwSZN7IOnWqXMHfhepG
        J27c0qr5FGnBd3Xy8qgdDRPeCt7foTtFY+tdz73rZ7wTY47i9MpqcavMmvPnQ4TUtZXOd2x9
        YjI9Hx5b3qbEUpyRaKjFXFScCACEHMn+7gIAAA==
X-CMS-MailID: 20210805125923epcas5p10e6c1b95475440be68f58244d5a3cb9a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210805125923epcas5p10e6c1b95475440be68f58244d5a3cb9a
References: <20210805125539.66958-1-joshi.k@samsung.com>
        <CGME20210805125923epcas5p10e6c1b95475440be68f58244d5a3cb9a@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce handlers for fops->uring_cmd(), implementing async passthru
on char device (including the multipath one).
The handlers supports NVME_IOCTL_IO_CMD and NVME_IOCTL_IO64_CMD.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c      |   1 +
 drivers/nvme/host/ioctl.c     | 177 +++++++++++++++++++++++++++++++---
 drivers/nvme/host/multipath.c |   1 +
 drivers/nvme/host/nvme.h      |   5 +
 4 files changed, 169 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 11779be42186..58fe7f6c94ba 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3559,6 +3559,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.release	= nvme_ns_chr_release,
 	.unlocked_ioctl	= nvme_ns_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.uring_cmd	= nvme_ns_chr_async_ioctl,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 305ddd415e45..2730c5dfdf78 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -18,6 +18,93 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 		ptrval = (compat_uptr_t)ptrval;
 	return (void __user *)ptrval;
 }
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
+static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
+{
+	struct uring_cmd_data *ucd;
+	struct nvme_passthru_cmd64 __user *ptcmd64 = NULL;
+	struct block_uring_cmd *bcmd;
+
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
+	io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
+
+	/* we can unmap pages, free bio and request */
+	blk_rq_unmap_user(bio);
+	blk_mq_free_request(req);
+}
+
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
+	rq->end_io_data = ioucmd;
+}
 
 static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 		unsigned len, u32 seed, bool write)
@@ -56,7 +143,8 @@ static void *nvme_add_user_metadata(struct bio *bio, void __user *ubuf,
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, u64 *result, unsigned timeout)
+		u32 meta_seed, u64 *result, unsigned timeout,
+		struct io_uring_cmd *ioucmd)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -92,6 +180,12 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 			req->cmd_flags |= REQ_INTEGRITY;
 		}
 	}
+	if (ioucmd) { /* async dispatch */
+		nvme_setup_uring_cmd_data(req, ioucmd, meta, write);
+		blk_execute_rq_nowait(ns ? ns->disk : NULL, req, 0,
+					nvme_end_async_pt);
+		return 0;
+	}
 
 	ret = nvme_execute_passthru_rq(req);
 	if (result)
@@ -170,7 +264,8 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
 	return nvme_submit_user_cmd(ns->queue, &c,
 			nvme_to_user_ptr(io.addr), length,
-			metadata, meta_len, lower_32_bits(io.slba), NULL, 0);
+			metadata, meta_len, lower_32_bits(io.slba), NULL, 0,
+			NULL);
 }
 
 static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
@@ -188,7 +283,8 @@ static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
 }
 
 static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd __user *ucmd)
+			struct nvme_passthru_cmd __user *ucmd,
+			struct io_uring_cmd *ioucmd)
 {
 	struct nvme_passthru_cmd cmd;
 	struct nvme_command c;
@@ -224,9 +320,9 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
@@ -235,7 +331,8 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 }
 
 static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
-			struct nvme_passthru_cmd64 __user *ucmd)
+			struct nvme_passthru_cmd64 __user *ucmd,
+			struct io_uring_cmd *ioucmd)
 {
 	struct nvme_passthru_cmd64 cmd;
 	struct nvme_command c;
@@ -270,9 +367,9 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
@@ -294,9 +391,9 @@ static int nvme_ctrl_ioctl(struct nvme_ctrl *ctrl, unsigned int cmd,
 {
 	switch (cmd) {
 	case NVME_IOCTL_ADMIN_CMD:
-		return nvme_user_cmd(ctrl, NULL, argp);
+		return nvme_user_cmd(ctrl, NULL, argp, NULL);
 	case NVME_IOCTL_ADMIN64_CMD:
-		return nvme_user_cmd64(ctrl, NULL, argp);
+		return nvme_user_cmd64(ctrl, NULL, argp, NULL);
 	default:
 		return sed_ioctl(ctrl->opal_dev, cmd, argp);
 	}
@@ -328,7 +425,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		force_successful_syscall_return();
 		return ns->head->ns_id;
 	case NVME_IOCTL_IO_CMD:
-		return nvme_user_cmd(ns->ctrl, ns, argp);
+		return nvme_user_cmd(ns->ctrl, ns, argp, NULL);
 	/*
 	 * struct nvme_user_io can have different padding on some 32-bit ABIs.
 	 * Just accept the compat version as all fields that are used are the
@@ -340,7 +437,7 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned int cmd,
 	case NVME_IOCTL_SUBMIT_IO:
 		return nvme_submit_io(ns, argp);
 	case NVME_IOCTL_IO64_CMD:
-		return nvme_user_cmd64(ns->ctrl, ns, argp);
+		return nvme_user_cmd64(ns->ctrl, ns, argp, NULL);
 	default:
 		if (!ns->ndev)
 			return -ENOTTY;
@@ -371,6 +468,41 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return __nvme_ioctl(ns, cmd, (void __user *)arg);
 }
 
+static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
+{
+	struct block_uring_cmd *bcmd = (struct block_uring_cmd *)&ioucmd->pdu;
+	void __user *argp = (void __user *) bcmd->unused2[0];
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct uring_cmd_data) >
+			sizeof(struct block_uring_cmd) -
+			offsetof(struct block_uring_cmd, unused2[1]));
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
+	return ret;
+}
+
+int nvme_ns_chr_async_ioctl(struct io_uring_cmd *ioucmd,
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
@@ -387,6 +519,21 @@ static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 	return ret;
 }
 
+int nvme_ns_head_chr_async_ioctl(struct io_uring_cmd *ioucmd,
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
 int nvme_ns_head_ioctl(struct block_device *bdev, fmode_t mode,
 		unsigned int cmd, unsigned long arg)
 {
@@ -463,7 +610,7 @@ static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
 	kref_get(&ns->kref);
 	up_read(&ctrl->namespaces_rwsem);
 
-	ret = nvme_user_cmd(ctrl, ns, argp);
+	ret = nvme_user_cmd(ctrl, ns, argp, NULL);
 	nvme_put_ns(ns);
 	return ret;
 
@@ -480,9 +627,9 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 
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
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 0ea5298469c3..e89a6334249a 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -403,6 +403,7 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 	.release	= nvme_ns_head_chr_release,
 	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.uring_cmd	= nvme_ns_head_chr_async_ioctl,
 };
 
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 18ef8dd03a90..e43e73eda4c6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -17,6 +17,7 @@
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
+#include <linux/io_uring.h>
 
 #include <trace/events/block.h>
 
@@ -688,6 +689,10 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
+int nvme_ns_chr_async_ioctl(struct io_uring_cmd *ucmd,
+		enum io_uring_cmd_flags flags);
+int nvme_ns_head_chr_async_ioctl(struct io_uring_cmd *ucmd,
+		enum io_uring_cmd_flags flags);
 int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 extern const struct attribute_group *nvme_ns_id_attr_groups[];
-- 
2.25.1

