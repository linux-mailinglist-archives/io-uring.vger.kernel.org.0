Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348F7522C5A
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 08:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbiEKGbx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 02:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242132AbiEKGbu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 02:31:50 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D758145AE9
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 23:31:47 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220511063142epoutp04529c84161ffb9692caf7437911db3355~t_UKI0RE-2022220222epoutp04u
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:31:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220511063142epoutp04529c84161ffb9692caf7437911db3355~t_UKI0RE-2022220222epoutp04u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652250702;
        bh=q6kFvmKbc6UtI84QXt4177zMhVkTjrIX600K/Wfn2YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFCBGZdz6/NN1w3imJ2gfCC5C9iKAUHWniUsddRHAV4FqbagOXwdNnFqgAoTMJH9H
         XDFX8RXi5ttnQqwDW15M8oCWlLG1w7hLQirXNA2+yCo2j+UTZeWrU/dZjGzTcyYAke
         snWhnwRJOX1TonaOxlFZqsJeWGU6eakfMRoq5OQk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220511063141epcas5p3e14a6024d825010360ba86622bf16e8b~t_UJmoRul0527405274epcas5p33;
        Wed, 11 May 2022 06:31:41 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KylRq20XBz4x9Q4; Wed, 11 May
        2022 06:31:35 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.C0.09762.2485B726; Wed, 11 May 2022 15:31:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220511055314epcas5p42ddbc17608f2677814c07b0d790e1318~t9ykyclMm2292622926epcas5p4C;
        Wed, 11 May 2022 05:53:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220511055314epsmtrp2c51cec1327f89777b416e56e621542e0~t9ykxEhEj1209712097epsmtrp2_;
        Wed, 11 May 2022 05:53:14 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-5d-627b584252b7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B0.D2.08924.A4F4B726; Wed, 11 May 2022 14:53:14 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220511055312epsmtip10d2ba963018c2c69435807f375cae539~t9yi_xpJr2605226052epsmtip12;
        Wed, 11 May 2022 05:53:12 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
Subject: [PATCH v5 4/6] nvme: wire-up uring-cmd support for io-passthru on
 char-device.
Date:   Wed, 11 May 2022 11:17:48 +0530
Message-Id: <20220511054750.20432-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511054750.20432-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKJsWRmVeSWpSXmKPExsWy7bCmhq5TRHWSweTlphZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7JtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzTs3sde8Dyy4vja
        K6wNjFO9uxg5OSQETCRu90xl6mLk4hAS2M0osX/DSmYI5xOjxINPy9hAqoQEPjNKLLhSD9Ox
        efY/VoiiXYwSC5d8ZoFwgIpePF8CNIuDg01AU+LC5FKQBhEBeYkvt9eC1TALnGWUmHbrECtI
        QlggUuLzin8sIDaLgKrE4wsHweK8AhYSk5+vZIXYJi8x89J3dhCbU8BSYsvmeewQNYISJ2c+
        AetlBqpp3job7GwJgaUcEndv/GCBaHaRuLruAzOELSzx6vgWdghbSuLzu71sEHayROv2y+wg
        R0sIlEgsWaAOEbaXuLjnL9gvzEC/rN+lDxGWlZh6ah0TxFo+id7fT5gg4rwSO+bB2IoS9yY9
        hTpfXOLhjCVQtofE781t0IDrYZS42vKLdQKjwiwk78xC8s4shNULGJlXMUqmFhTnpqcWmxYY
        56WWwyM5OT93EyM4/Wp572B89OCD3iFGJg7GQ4wSHMxKIrz7+yqShHhTEiurUovy44tKc1KL
        DzGaAsN7IrOUaHI+MAPklcQbmlgamJiZmZlYGpsZKonznkrfkCgkkJ5YkpqdmlqQWgTTx8TB
        KdXAdG3fp4NKjrEhL9mcf1+32pO2vGAOw/ED6y7cPj/Z+vKtiQxOW08Hb7oULc3oGX3GSmuX
        +6++ph8nFbkXPPqiv3vPmW03ou7MSllrmHs525Fxt2BGh9T3BC4P542HZHbn9ze+Vcpae7Bu
        l+RNNrW4VHXn9CpH8Sn1k55MPq/79rFK0DT3zK9qNknCexbnb5zyLr17Vq1P9QW9A3cmfv0X
        trZ9wUO1TYYBsi+TBdSuyz9fnvmS6cmEL+lsG+stvqkctRXe+HWWiVsW26Ptj9OmPQpaqvZ/
        afY+45Rf+oluH/TYpvZH3fSccSjDc6I2v4FdboTR1FX/DFbF73590Kcwb9PeXYmOUh/Y7rkr
        2Un5f1BiKc5INNRiLipOBADPGa3fSAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnK6Xf3WSweofshZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi/NvDzNZzF/2lN3ixoSnjBaHJjczWVx9eYDdgdtjYvM7
        do+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHm833eVzaNvyypGj8+b5AI4o7hsUlJzMstSi/Tt
        ErgyGnbvYy94HllxfO0V1gbGqd5djJwcEgImEptn/2PtYuTiEBLYwSjxb9FfJoiEuETztR/s
        ELawxMp/z9khij4ySrxY0ADUwcHBJqApcWFyKUiNiICixMaPTYwgNcwCNxklHrdeYwZJCAuE
        S3Sf7wMbyiKgKvH4wkFWEJtXwEJi8vOVrBAL5CVmXvoOtoxTwFJiy+Z5YLYQUM3RJRPZIOoF
        JU7OfMICYjMD1Tdvnc08gVFgFpLULCSpBYxMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLz
        czcxgmNES2sH455VH/QOMTJxMB5ilOBgVhLh3d9XkSTEm5JYWZValB9fVJqTWnyIUZqDRUmc
        90LXyXghgfTEktTs1NSC1CKYLBMHp1QDU937WQ0Sp+6wJmR8Db10r+aupSbrHT3f9JpehhlK
        Of93/VXYlrk87Gva02OvPxaErun4Oqd16TKLUxMO37kvXGX6YF5o7Hkl5y9BChl1gh6PK7dY
        f+Fd8Oe9xJ5a+4dfpyyuFT55kN1z8RmpqTfEFL2U3I+2lGjxflpxMaRe9m38wb+7Fk9cuW32
        9nWrFu4U4bZ7bOE3KeHljpMb1+/TUuBetkhOIX/Li2kT+sw6J0xa/v3Y38suf0Nuz6izrmUq
        u9snNGWD/Y3LV2ITSn8oVyRmp3OtnXnk3FaH4hYbpt67T0qa9Rnd/xuzJD1eq57Sf7LvVY1D
        /qEbVfc/vNonvzr7vPO7HepRBZcv/Txkv2mzEktxRqKhFnNRcSIAx6gF5AADAAA=
X-CMS-MailID: 20220511055314epcas5p42ddbc17608f2677814c07b0d790e1318
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511055314epcas5p42ddbc17608f2677814c07b0d790e1318
References: <20220511054750.20432-1-joshi.k@samsung.com>
        <CGME20220511055314epcas5p42ddbc17608f2677814c07b0d790e1318@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
 drivers/nvme/host/ioctl.c       | 192 +++++++++++++++++++++++++++++++-
 drivers/nvme/host/multipath.c   |   1 +
 drivers/nvme/host/nvme.h        |   4 +
 include/uapi/linux/nvme_ioctl.h |  25 +++++
 5 files changed, 220 insertions(+), 3 deletions(-)

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
index 8d2569b656cc..92d695262d8f 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -5,6 +5,7 @@
  */
 #include <linux/ptrace.h>	/* for force_successful_syscall_return */
 #include <linux/nvme_ioctl.h>
+#include <linux/io_uring.h>
 #include "nvme.h"
 
 /*
@@ -66,7 +67,8 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
 static struct request *nvme_alloc_user_request(struct request_queue *q,
 		struct nvme_command *cmd, void __user *ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, void **metap, unsigned timeout, bool vec)
+		u32 meta_seed, void **metap, unsigned timeout, bool vec,
+		unsigned int rq_flags, blk_mq_req_flags_t blk_flags)
 {
 	bool write = nvme_is_write(cmd);
 	struct nvme_ns *ns = q->queuedata;
@@ -76,7 +78,7 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 	void *meta = NULL;
 	int ret;
 
-	req = blk_mq_alloc_request(q, nvme_req_op(cmd), 0);
+	req = blk_mq_alloc_request(q, nvme_req_op(cmd) | rq_flags, blk_flags);
 	if (IS_ERR(req))
 		return req;
 	nvme_init_request(req, cmd);
@@ -140,7 +142,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	int ret;
 
 	req = nvme_alloc_user_request(q, cmd, ubuffer, bufflen, meta_buffer,
-			meta_len, meta_seed, &meta, timeout, vec);
+			meta_len, meta_seed, &meta, timeout, vec, 0, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -330,6 +332,139 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	return status;
 }
 
+struct nvme_uring_data {
+	__u64	metadata;
+	__u64	addr;
+	__u32	data_len;
+	__u32	metadata_len;
+	__u32	timeout_ms;
+};
+
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
+	int status;
+	u64 result;
+
+	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
+		status = -EINTR;
+	else
+		status = nvme_req(req)->status;
+
+	result = le64_to_cpu(nvme_req(req)->result.u64);
+
+	if (pdu->meta)
+		status = nvme_finish_user_metadata(req, pdu->meta_buffer,
+					pdu->meta, pdu->meta_len, status);
+	if (bio)
+		blk_rq_unmap_user(bio);
+	blk_mq_free_request(req);
+
+	io_uring_cmd_done(ioucmd, status, result);
+}
+
+static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
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
+static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
+		struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
+	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
+	struct nvme_uring_data d;
+	struct nvme_command c;
+	struct request *req;
+	unsigned int rq_flags = 0;
+	blk_mq_req_flags_t blk_flags = 0;
+	void *meta = NULL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	c.common.opcode = READ_ONCE(cmd->opcode);
+	c.common.flags = READ_ONCE(cmd->flags);
+	if (c.common.flags)
+		return -EINVAL;
+
+	c.common.command_id = 0;
+	c.common.nsid = cpu_to_le32(cmd->nsid);
+	if (!nvme_validate_passthru_nsid(ctrl, ns, le32_to_cpu(c.common.nsid)))
+		return -EINVAL;
+
+	c.common.cdw2[0] = cpu_to_le32(READ_ONCE(cmd->cdw2));
+	c.common.cdw2[1] = cpu_to_le32(READ_ONCE(cmd->cdw3));
+	c.common.metadata = 0;
+	c.common.dptr.prp1 = c.common.dptr.prp2 = 0;
+	c.common.cdw10 = cpu_to_le32(READ_ONCE(cmd->cdw10));
+	c.common.cdw11 = cpu_to_le32(READ_ONCE(cmd->cdw11));
+	c.common.cdw12 = cpu_to_le32(READ_ONCE(cmd->cdw12));
+	c.common.cdw13 = cpu_to_le32(READ_ONCE(cmd->cdw13));
+	c.common.cdw14 = cpu_to_le32(READ_ONCE(cmd->cdw14));
+	c.common.cdw15 = cpu_to_le32(READ_ONCE(cmd->cdw15));
+
+	d.metadata = READ_ONCE(cmd->metadata);
+	d.addr = READ_ONCE(cmd->addr);
+	d.data_len = READ_ONCE(cmd->data_len);
+	d.metadata_len = READ_ONCE(cmd->metadata_len);
+	d.timeout_ms = READ_ONCE(cmd->timeout_ms);
+
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		rq_flags = REQ_NOWAIT;
+		blk_flags = BLK_MQ_REQ_NOWAIT;
+	}
+
+	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
+			d.data_len, nvme_to_user_ptr(d.metadata),
+			d.metadata_len, 0, &meta, d.timeout_ms ?
+			msecs_to_jiffies(d.timeout_ms) : 0, 0, rq_flags,
+			blk_flags);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	req->end_io_data = ioucmd;
+
+	/* to free bio on completion, as req->bio will be null at that time */
+	pdu->bio = req->bio;
+	pdu->meta = meta;
+	pdu->meta_buffer = nvme_to_user_ptr(d.metadata);
+	pdu->meta_len = d.metadata_len;
+
+	blk_execute_rq_nowait(req, 0, nvme_uring_cmd_end_io);
+	return -EIOCBQUEUED;
+}
+
 static bool is_ctrl_ioctl(unsigned int cmd)
 {
 	if (cmd == NVME_IOCTL_ADMIN_CMD || cmd == NVME_IOCTL_ADMIN64_CMD)
@@ -421,6 +556,42 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return __nvme_ioctl(ns, cmd, (void __user *)arg);
 }
 
+static int nvme_ns_uring_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd,
+			     unsigned int issue_flags)
+{
+	struct nvme_ctrl *ctrl = ns->ctrl;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
+
+	/* IOPOLL not supported yet */
+	if (issue_flags & IO_URING_F_IOPOLL)
+		return -EOPNOTSUPP;
+
+	/* NVMe passthrough requires bit SQE/CQE support */
+	if ((issue_flags & (IO_URING_F_SQE128|IO_URING_F_CQE32)) !=
+	    (IO_URING_F_SQE128|IO_URING_F_CQE32))
+		return -EOPNOTSUPP;
+
+	switch (ioucmd->cmd_op) {
+	case NVME_URING_CMD_IO:
+		ret = nvme_uring_cmd_io(ctrl, ns, ioucmd, issue_flags);
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+
+	return ret;
+}
+
+int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+{
+	struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
+			struct nvme_ns, cdev);
+
+	return nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
+}
+
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -487,6 +658,21 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
+
+int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	int ret = -EINVAL;
+
+	if (ns)
+		ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
+	srcu_read_unlock(&head->srcu, srcu_idx);
+	return ret;
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
index a2b53ca63335..086ccbdd7003 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -782,6 +782,10 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
+int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags);
+int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
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

