Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C30757008E
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 13:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiGKL2w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 07:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiGKL2S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 07:28:18 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9AF112C
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 04:08:33 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220711110831epoutp04720321662be173cb183dcb211c43e45b~AwcRc3dDn3101131011epoutp04c
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 11:08:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220711110831epoutp04720321662be173cb183dcb211c43e45b~AwcRc3dDn3101131011epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657537712;
        bh=m3GqGhDnRMO6SHZB5q3Um1iWb54ixNElLDQjpTMW9Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tv3IgMiu+61U7q99p7spKfAA+rWYnkZiY++1NBPpluZkSnNPTlxWw+DfItGnfQwq6
         EUQZFvWvgxv4opAWnMwszZ9rWGtw2dzw6rgtYlsJ/xA+byzKhQ/57ClsSiD16uhudW
         rzIj7moVQlK50EB1lQl0zSzlS3WMzxIrJorfRdHc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220711110831epcas5p4f4775b2b0bd3c707bcac0e7fa428c89e~AwcQkEG1i0533205332epcas5p4J;
        Mon, 11 Jul 2022 11:08:31 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4LhLj85vCVz4x9Pr; Mon, 11 Jul
        2022 11:08:28 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.FA.09662.CA40CC26; Mon, 11 Jul 2022 20:08:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089~AwcNq2VpW0447004470epcas5p3g;
        Mon, 11 Jul 2022 11:08:27 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220711110827epsmtrp2108077060fb37f177ed45746369c0710~AwcNqCQZS2556725567epsmtrp2Q;
        Mon, 11 Jul 2022 11:08:27 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-6e-62cc04ac3d36
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        40.99.08802.BA40CC26; Mon, 11 Jul 2022 20:08:27 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220711110824epsmtip22a8a4c7e13ba3772f371800bb410afc8~AwcK1FtrQ0332603326epsmtip2Q;
        Mon, 11 Jul 2022 11:08:24 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     hch@lst.de, sagi@grimberg.me, kbusch@kernel.org, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Date:   Mon, 11 Jul 2022 16:31:55 +0530
Message-Id: <20220711110155.649153-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711110155.649153-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmhu4aljNJBrMO6Fk0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmcf7tYSaLSYeuMVrsvaVtMX/ZU3aLda/fszjw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHn1bVjF6fN4kF8ARlW2TkZqYklqkkJqX
        nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SrkkJZYk4pUCggsbhYSd/O
        pii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE7Y93/ZYwFf6MrOl6t
        ZmlgnOHTxcjJISFgIrG3Yyt7FyMXh5DAbkaJvWf2sEA4n4Ccz3ehnM+MEvdnLGCDaek6dgqq
        ZRejxIKbyxGq5jX8BspwcLAJaEpcmFwK0iAi4CLR2TSdFaSGWeAuo0TDrtWMIAlhgXiJG83H
        mEFsFgFVib1L5zCB2LwClhLtc6+wQmyTl5h56Ts7iM0pYCUxc/s/RogaQYmTM5+wgNjMQDXN
        W2czgyyQEFjIITGldRMTRLOLxI/zu9ghbGGJV8e3QNlSEp/f7YV6J1ni0sxzUPUlEo/3HISy
        7SVaT/UzgzzDDPTM+l36ELv4JHp/P2ECCUsI8Ep0tAlBVCtK3Jv0FOpkcYmHM5ZA2R4SH+c3
        QwOrl1HizOHpTBMY5WcheWEWkhdmIWxbwMi8ilEytaA4Nz212LTAMC+1HB6zyfm5mxjBaVbL
        cwfj3Qcf9A4xMnEwHmKU4GBWEuH9c/ZUkhBvSmJlVWpRfnxRaU5q8SFGU2AYT2SWEk3OByb6
        vJJ4QxNLAxMzMzMTS2MzQyVxXq+rm5KEBNITS1KzU1MLUotg+pg4OKUamCb5/q/f9mLT/3Xz
        PybOalx5NTvmweP4+Ru/edmwLGzU2OBSOzvWOGDFLTHTz8G3HPx7z1em570+xDQ9c2afrenJ
        WX/4k4WY/3hVZ39WfXT22d6fd1dH2Stzx/3nt6ivYWDsn8+/ZS1n/oYN03V5jM1UlwR7nvCx
        VhWynDQ/M7HljH/9MR8hybfe+ZH3FZJU39/vu9hn/Cs0VFciZO3C6KO7LESXui5/72l5Zf+6
        +pKXcTL6SW+rdxx/deZWaPeDVWHrmT+laD86cn7y3aNzHCQlbiSuCpqiuebDwXXbozx+xC9y
        /zQ3SPSTpK7+qlAPPVb7nTp5802nhTq4TuSpKBKqlLzLxz23zVddMbRruxJLcUaioRZzUXEi
        ADDoqjo8BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWy7bCSvO5qljNJBh/n61s0TfjLbDFn1TZG
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmcf7tYSaLSYeuMVrsvaVtMX/ZU3aLda/fszjw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
        wJWx7v8yxoK/0RUdr1azNDDO8Oli5OSQEDCR6Dp2ir2LkYtDSGAHo0TnilXMEAlxieZrP9gh
        bGGJlf+eQxV9ZJSYtuEdUBEHB5uApsSFyaUgNSICXhIrev4wgdQwCzxllJg8q58RJCEsECvx
        +90ksKEsAqoSe5fOYQKxeQUsJdrnXmGFWCAvMfPSd7BlnAJWEjO3/wPrFQKqOXV3JlS9oMTJ
        mU9YQGxmoPrmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4m
        RnCEaGntYNyz6oPeIUYmDsZDjBIczEoivH/OnkoS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh
        62S8kEB6YklqdmpqQWoRTJaJg1OqgSnWQ+fhva9L9SXK2PcsmD/z7J8vGX9MLycorP4ya5v+
        E7+M/hkcnIFKkyxuHVFQb37cxScfrD5LSa2p4LGFD3vNwWado7/f/1sV9PichnxQeySn/snO
        N6HrG+R22LFbHZn6YlKZ/7JVtw5tXPzw5JUdE3pEjPr/RbgFNz2ROTTlssN6nazMNTlTJsU+
        nJjwYtW00uhy48DJ+39MzDqqxdeWLDFpgQqbirdH/foTzzN+5S7iLtkS2/2JMV09YLJvSvTE
        /zpJR7R2bTghOpu9ateZkz47CupuOhrPrtrz8OmnKRsL/mjmm3vwT2Tv+3Lad6Jl3Muku6fM
        N/49WjtZcGXugZX+az6xLOa5u4Z3U3u+EktxRqKhFnNRcSIAJHDXr/8CAAA=
X-CMS-MailID: 20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

This heavily reuses nvme-mpath infrastructure for block-path.
Block-path operates on bio, and uses that as long-lived object across
requeue attempts. For passthrough interface io_uring_cmd happens to
be such object, so add a requeue list for that.

If path is not available, uring-cmds are added into that list and
resubmitted on discovery of new path. Existing requeue handler
(nvme_requeue_work) is extended to do this resubmission.

For failed commands, failover is done directly (i.e. without first
queuing into list) by resubmitting individual command from task-work
based callback.

Suggested-by: Sagi Grimberg <sagi@grimberg.me>
Co-developed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/ioctl.c     | 141 ++++++++++++++++++++++++++++++++--
 drivers/nvme/host/multipath.c |  36 ++++++++-
 drivers/nvme/host/nvme.h      |  12 +++
 include/linux/io_uring.h      |   2 +
 4 files changed, 182 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index fc02eddd4977..281c21d3c67d 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -340,12 +340,6 @@ struct nvme_uring_data {
 	__u32	timeout_ms;
 };
 
-static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
-		struct io_uring_cmd *ioucmd)
-{
-	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
-}
-
 static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
@@ -448,6 +442,14 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	pdu->meta_buffer = nvme_to_user_ptr(d.metadata);
 	pdu->meta_len = d.metadata_len;
 
+	if (issue_flags & IO_URING_F_MPATH) {
+		req->cmd_flags |= REQ_NVME_MPATH;
+		/*
+		 * we would need the buffer address (d.addr field) if we have
+		 * to retry the command. Store it by repurposing ioucmd->cmd
+		 */
+		ioucmd->cmd = (void *)d.addr;
+	}
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
 }
@@ -665,12 +667,135 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 	int srcu_idx = srcu_read_lock(&head->srcu);
 	struct nvme_ns *ns = nvme_find_path(head);
 	int ret = -EINVAL;
+	struct device *dev = &head->cdev_device;
+
+	if (likely(ns)) {
+		ret = nvme_ns_uring_cmd(ns, ioucmd,
+				issue_flags | IO_URING_F_MPATH);
+	} else if (nvme_available_path(head)) {
+		struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+		struct nvme_uring_cmd *payload = NULL;
+
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+		/*
+		 * We may requeue two kinds of uring commands:
+		 * 1. command failed post submission. pdu->req will be non-null
+		 * for this
+		 * 2. command that could not be submitted because path was not
+		 * available. For this pdu->req is set to NULL.
+		 */
+		pdu->req = NULL;
+		/*
+		 * passthrough command will not be available during retry as it
+		 * is embedded in io_uring's SQE. Hence we allocate/copy here
+		 */
+		payload = kmalloc(sizeof(struct nvme_uring_cmd), GFP_KERNEL);
+		if (!payload) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+		memcpy(payload, ioucmd->cmd, sizeof(struct nvme_uring_cmd));
+		ioucmd->cmd = payload;
 
-	if (ns)
-		ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
+		spin_lock_irq(&head->requeue_ioucmd_lock);
+		ioucmd_list_add(&head->requeue_ioucmd_list, ioucmd);
+		spin_unlock_irq(&head->requeue_ioucmd_lock);
+		ret = -EIOCBQUEUED;
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+	}
+out_unlock:
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
+
+int nvme_uring_cmd_io_retry(struct nvme_ns *ns, struct request *oreq,
+		struct io_uring_cmd *ioucmd, struct nvme_uring_cmd_pdu *pdu)
+{
+	struct nvme_ctrl *ctrl = ns->ctrl;
+	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
+	struct nvme_uring_data d;
+	struct nvme_command c;
+	struct request *req;
+	struct bio *obio = oreq->bio;
+	void *meta = NULL;
+
+	memcpy(&c, nvme_req(oreq)->cmd, sizeof(struct nvme_command));
+	d.metadata = (__u64)pdu->meta_buffer;
+	d.metadata_len = pdu->meta_len;
+	d.timeout_ms = oreq->timeout;
+	d.addr = (__u64)ioucmd->cmd;
+	if (obio) {
+		d.data_len = obio->bi_iter.bi_size;
+		blk_rq_unmap_user(obio);
+	} else {
+		d.data_len = 0;
+	}
+	blk_mq_free_request(oreq);
+	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
+			d.data_len, nvme_to_user_ptr(d.metadata),
+			d.metadata_len, 0, &meta, d.timeout_ms ?
+			msecs_to_jiffies(d.timeout_ms) : 0,
+			ioucmd->cmd_op == NVME_URING_CMD_IO_VEC, 0, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	req->end_io = nvme_uring_cmd_end_io;
+	req->end_io_data = ioucmd;
+	pdu->bio = req->bio;
+	pdu->meta = meta;
+	req->cmd_flags |= REQ_NVME_MPATH;
+	blk_execute_rq_nowait(req, false);
+	return -EIOCBQUEUED;
+}
+
+void nvme_ioucmd_mpath_retry(struct io_uring_cmd *ioucmd)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head,
+			cdev);
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	unsigned int issue_flags = IO_URING_F_SQE128 | IO_URING_F_CQE32 |
+		IO_URING_F_MPATH;
+	struct device *dev = &head->cdev_device;
+
+	if (likely(ns)) {
+		struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+		struct request *oreq = pdu->req;
+		int ret;
+
+		if (oreq == NULL) {
+			/*
+			 * this was not submitted (to device) earlier. For this
+			 * ioucmd->cmd points to persistent memory. Free that
+			 * up post submission
+			 */
+			const void *cmd = ioucmd->cmd;
+
+			ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
+			kfree(cmd);
+		} else {
+			/*
+			 * this was submitted (to device) earlier. Use old
+			 * request, bio (if it exists) and nvme-pdu to recreate
+			 * the command for the discovered path
+			 */
+			ret = nvme_uring_cmd_io_retry(ns, oreq, ioucmd, pdu);
+		}
+		if (ret != -EIOCBQUEUED)
+			io_uring_cmd_done(ioucmd, ret, 0);
+	} else if (nvme_available_path(head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+		spin_lock_irq(&head->requeue_ioucmd_lock);
+		ioucmd_list_add(&head->requeue_ioucmd_list, ioucmd);
+		spin_unlock_irq(&head->requeue_ioucmd_lock);
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+		io_uring_cmd_done(ioucmd, -EINVAL, 0);
+	}
+	srcu_read_unlock(&head->srcu, srcu_idx);
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f26640ccb955..fe5655d98c36 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -6,6 +6,7 @@
 #include <linux/backing-dev.h>
 #include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
+#include <linux/io_uring.h>
 #include <trace/events/block.h>
 #include "nvme.h"
 
@@ -80,6 +81,17 @@ void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
 			blk_freeze_queue_start(h->disk->queue);
 }
 
+static void nvme_ioucmd_failover_req(struct request *req, struct nvme_ns *ns)
+{
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+
+	/* store the request, to reconstruct the command during retry */
+	pdu->req = req;
+	/* retry in original submitter context */
+	io_uring_cmd_execute_in_task(ioucmd, nvme_ioucmd_mpath_retry);
+}
+
 void nvme_failover_req(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
@@ -99,6 +111,11 @@ void nvme_failover_req(struct request *req)
 		queue_work(nvme_wq, &ns->ctrl->ana_work);
 	}
 
+	if (blk_rq_is_passthrough(req)) {
+		nvme_ioucmd_failover_req(req, ns);
+		return;
+	}
+
 	spin_lock_irqsave(&ns->head->requeue_lock, flags);
 	for (bio = req->bio; bio; bio = bio->bi_next) {
 		bio_set_dev(bio, ns->head->disk->part0);
@@ -314,7 +331,7 @@ inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
 	return ns;
 }
 
-static bool nvme_available_path(struct nvme_ns_head *head)
+bool nvme_available_path(struct nvme_ns_head *head)
 {
 	struct nvme_ns *ns;
 
@@ -459,7 +476,9 @@ static void nvme_requeue_work(struct work_struct *work)
 	struct nvme_ns_head *head =
 		container_of(work, struct nvme_ns_head, requeue_work);
 	struct bio *bio, *next;
+	struct io_uring_cmd *ioucmd, *ioucmd_next;
 
+	/* process requeued bios*/
 	spin_lock_irq(&head->requeue_lock);
 	next = bio_list_get(&head->requeue_list);
 	spin_unlock_irq(&head->requeue_lock);
@@ -470,6 +489,21 @@ static void nvme_requeue_work(struct work_struct *work)
 
 		submit_bio_noacct(bio);
 	}
+
+	/* process requeued passthrough-commands */
+	spin_lock_irq(&head->requeue_ioucmd_lock);
+	ioucmd_next = ioucmd_list_get(&head->requeue_ioucmd_list);
+	spin_unlock_irq(&head->requeue_ioucmd_lock);
+
+	while ((ioucmd = ioucmd_next) != NULL) {
+		ioucmd_next = ioucmd->next;
+		ioucmd->next = NULL;
+		/*
+		 * Retry in original submitter context as we would be
+		 * processing the passthrough command again
+		 */
+		io_uring_cmd_execute_in_task(ioucmd, nvme_ioucmd_mpath_retry);
+	}
 }
 
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9d3ff6feda06..125b48e74e72 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -16,6 +16,7 @@
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
+#include <linux/io_uring.h>
 
 #include <trace/events/block.h>
 
@@ -189,6 +190,12 @@ enum {
 	NVME_REQ_USERCMD		= (1 << 1),
 };
 
+static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
+		struct io_uring_cmd *ioucmd)
+{
+	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
+}
+
 static inline struct nvme_request *nvme_req(struct request *req)
 {
 	return blk_mq_rq_to_pdu(req);
@@ -442,6 +449,9 @@ struct nvme_ns_head {
 	struct work_struct	requeue_work;
 	struct mutex		lock;
 	unsigned long		flags;
+	/* for uring-passthru multipath handling */
+	struct ioucmd_list	requeue_ioucmd_list;
+	spinlock_t		requeue_ioucmd_lock;
 #define NVME_NSHEAD_DISK_LIVE	0
 	struct nvme_ns __rcu	*current_path[];
 #endif
@@ -830,6 +840,7 @@ int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
 int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
+void nvme_ioucmd_mpath_retry(struct io_uring_cmd *ioucmd);
 int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 
@@ -844,6 +855,7 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 	return ctrl->ana_log_buf != NULL;
 }
 
+bool nvme_available_path(struct nvme_ns_head *head);
 void nvme_mpath_unfreeze(struct nvme_subsystem *subsys);
 void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
 void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index d734599cbcd7..57f4dfc83316 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -15,6 +15,8 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= 4,
 	IO_URING_F_CQE32		= 8,
 	IO_URING_F_IOPOLL		= 16,
+	/* to indicate that it is a MPATH req*/
+	IO_URING_F_MPATH		= 32,
 };
 
 struct io_uring_cmd {
-- 
2.25.1

