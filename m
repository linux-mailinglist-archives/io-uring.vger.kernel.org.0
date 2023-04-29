Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8DD6F2402
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjD2JnV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjD2JnT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:43:19 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A06213C
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:43:06 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230429094304epoutp04c18878018024ee925cfc4ca07d65a2c6~aXpBLpvQE0828308283epoutp04u
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:43:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230429094304epoutp04c18878018024ee925cfc4ca07d65a2c6~aXpBLpvQE0828308283epoutp04u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761384;
        bh=d3noo7PR5uc2q/xqQsl9I4ZjiH2gFhIOu9fepDFlxqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkH0+yGiDtaZmPDeXGOk9vErTxtNuuTRLA/3adNvrX1pwAAr+fhme4BQEMpEvwFu0
         xToDq/bKFePIkshLbPL5TzlPuD9MSGlN4M4aKyYky8nRPVQyTzKl8ujujWlYYI42EE
         AMGgrA/Ax1Px75K0tadVfNIdhrE7o/Snhx9EO/lM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230429094303epcas5p2381f3f7bb217f5befbe78921fac9b3df~aXpAMKyhw2905329053epcas5p2N;
        Sat, 29 Apr 2023 09:43:03 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Q7kzp23nFz4x9Pt; Sat, 29 Apr
        2023 09:43:02 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.60.55646.6A6EC446; Sat, 29 Apr 2023 18:43:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230429094301epcas5p48cf45da2f83d9ca8140ee777c7446d11~aXo_k5l0I1668816688epcas5p4_;
        Sat, 29 Apr 2023 09:43:01 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230429094301epsmtrp2cf3e99dba583ba2eff31e2746ba61602~aXo_j9YsY3077530775epsmtrp2g;
        Sat, 29 Apr 2023 09:43:01 +0000 (GMT)
X-AuditID: b6c32a4b-b71fa7000001d95e-03-644ce6a66daa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B7.29.28392.5A6EC446; Sat, 29 Apr 2023 18:43:01 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094259epsmtip2b406d2d3e0d312d53ec8b113ae791d71~aXo8eZn4W0575905759epsmtip2V;
        Sat, 29 Apr 2023 09:42:59 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [RFC PATCH 12/12] pci: implement submission/completion for rawq
 commands
Date:   Sat, 29 Apr 2023 15:09:25 +0530
Message-Id: <20230429093925.133327-13-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmlu6yZz4pBo+X8Fp8/PqbxaJpwl9m
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8puse71exaLTX9PMjnw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsfOhpcfmJfUeu282sHn0bVnF6PF5k1wAZ1S2TUZqYkpq
        kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QvUoKZYk5pUChgMTi
        YiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IzWj8+YCy64
        V5zbcZKpgfGCVRcjJ4eEgInEn5/rGLsYuTiEBHYzSlzqW88E4XxilDjRfokZwvnMKHG86zET
        TMuRLZ9ZIRK7GCUO7DrMAlc1ddMGoGEcHGwCmhIXJpeCNIgIuEg0rZ3KBlLDLPCNUWLR63es
        IDXCAsES7XeiQGpYBFQldky/zA5i8wpYSXxbNJkVYpm8xMxL38HinEDx7zN2M0PUCEqcnPmE
        BcRmBqpp3job7FIJgaUcEq+7pkA1u0i8+3yfGcIWlnh1fAs7hC0l8fndXjYIO1ni0sxzUJ+V
        SDzecxDKtpdoPdXPDHInM9Av63fpQ+zik+j9/YQJJCwhwCvR0SYEUa0ocW/SU6it4hIPZyyB
        sj0k+vcuBjtTSKCXUeLRl9wJjPKzkHwwC8kHsxCWLWBkXsUomVpQnJueWmxaYJyXWg6P1+T8
        3E2M4FSr5b2D8dGDD3qHGJk4GA8xSnAwK4nw8la6pwjxpiRWVqUW5ccXleakFh9iNAUG8URm
        KdHkfGCyzyuJNzSxNDAxMzMzsTQ2M1QS51W3PZksJJCeWJKanZpakFoE08fEwSnVwOSZm/3g
        xdFbJZrMokKd0hO8Ngj+FPyw2WbDjsv1/1L7k+xdhKYdvX7mzFrlwkl/Liuf3ahSutH9cO89
        vjdit7+kXVOr4ZxX1roo+3nX58YN61wcXS9P36J91niLrlPyRZ33z328txxaoPkgLcNzi2BX
        ELP68UbWW3I3ZC9rzFs00bJsj6LijlyNFTZ/iwVYdl/1bslrOPH9qAPThXcP1jm2cK5eMPng
        B2Gh14py+8IaTtcYvU3LMfl67HiP77u1No3zF3y0DPN4l/H/b2LLOabvpcaKB5YGmc9Yksp8
        cN2ymFVRATlGhfMWXknXZzrjOSHvhxXj8d7Vh2Sle2TvPxblmLglUK2dXTRl2jZuzUIlluKM
        REMt5qLiRAB2hJK0PgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSvO7SZz4pBttnaVh8/PqbxaJpwl9m
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8puse71exaLTX9PMjnw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsfOhpcfmJfUeu282sHn0bVnF6PF5k1wAZxSXTUpqTmZZ
        apG+XQJXRuvHZ8wFF9wrzu04ydTAeMGqi5GTQ0LAROLIls+sILaQwA5GicuzSiDi4hLN136w
        Q9jCEiv/PQeyuYBqPjJKnO/sYe5i5OBgE9CUuDC5FKRGRMBLov3tLDaQGmaBf4wSD963sYEk
        hAUCJTq3rWEBsVkEVCV2TL8MNpRXwEri26LJrBAL5CVmXvoOFucEin+fsRtsvpCApUTjgniI
        ckGJkzOfgI1hBipv3jqbeQKjwCwkqVlIUgsYmVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl
        5+duYgRHiZbWDsY9qz7oHWJk4mA8xCjBwawkwstb6Z4ixJuSWFmVWpQfX1Sak1p8iFGag0VJ
        nPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA5P14kcvMw23CDEmxEfYfjZa9m3fvM4Fx/4LsT/t
        KrJJkPuzIOji6/0folzrbteYltiU/btml+B2r5/L8YS57P+E681zg7rEGrenXjkqeFlnocer
        iibV80VZBzVOPirRklxcqVT5UXJmOPdLieV8BdY3udrz/C85FiqVPzXo+PhgzeSyzMDDMxM6
        wlpyJ+cqqHuVe3VLr+MskjV4+/akZoBdNVfj6Ucb9SM+3bicwNqbMZv5lsKb21symoMvL/JN
        8t39+73fk8NFeREH3Ofervn38r+DT9GrniViLyce1Jz8bvb7sJ+iOxdNlToQb2zrPaXrzuvp
        4TN0912TlHgf8WB27vUfqz60ultt/mv/ebUSS3FGoqEWc1FxIgC7JmW2AQMAAA==
X-CMS-MailID: 20230429094301epcas5p48cf45da2f83d9ca8140ee777c7446d11
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094301epcas5p48cf45da2f83d9ca8140ee777c7446d11
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094301epcas5p48cf45da2f83d9ca8140ee777c7446d11@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Implement ->queue_uring_cmd and ->poll_uring_cmd for leaner submission
and completion. Both operate on "struct io_uring_cmd" directly, without
having to take hoops involving request and bio.

This is currently enabled for small (single segement length), premapped
(fixedbufs) IOs.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/pci.c | 194 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 192 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 30d7a1a6eaab..ca0580c4e977 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -28,6 +28,8 @@
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/sed-opal.h>
 #include <linux/pci-p2pdma.h>
+#include <linux/nvme_ioctl.h>
+#include <linux/io_uring.h>
 
 #include "trace.h"
 #include "nvme.h"
@@ -210,6 +212,7 @@ struct nvme_queue {
 	unsigned long *cmdid_bmp;
 	spinlock_t cmdid_lock;
 	struct nvme_iod *iod;
+	u8	reg_id;
 	 /* only used for poll queues: */
 	spinlock_t cq_poll_lock ____cacheline_aligned_in_smp;
 	struct nvme_completion *cqes;
@@ -249,7 +252,11 @@ union nvme_descriptor {
  * to the actual struct scatterlist.
  */
 struct nvme_iod {
-	struct nvme_request req;
+	union {
+		struct nvme_request req;
+		/* for raw-queue */
+		struct io_uring_cmd *ioucmd;
+	};
 	struct nvme_command cmd;
 	bool aborted;
 	s8 nr_allocations;	/* PRP list pool allocations. 0 means small
@@ -1025,6 +1032,13 @@ static inline void nvme_ring_cq_doorbell(struct nvme_queue *nvmeq)
 		writel(head, nvmeq->q_db + nvmeq->dev->db_stride);
 }
 
+static void nvme_pci_put_cmdid(struct nvme_queue *nvmeq, int id)
+{
+	spin_lock(&nvmeq->cmdid_lock);
+	clear_bit(id, nvmeq->cmdid_bmp);
+	spin_unlock(&nvmeq->cmdid_lock);
+}
+
 static inline struct blk_mq_tags *nvme_queue_tagset(struct nvme_queue *nvmeq)
 {
 	if (!nvmeq->qid)
@@ -1032,6 +1046,37 @@ static inline struct blk_mq_tags *nvme_queue_tagset(struct nvme_queue *nvmeq)
 	return nvmeq->dev->tagset.tags[nvmeq->qid - 1];
 }
 
+static inline struct nvme_uring_direct_pdu *nvme_uring_cmd_direct_pdu(
+		struct io_uring_cmd *ioucmd)
+{
+	return (struct nvme_uring_direct_pdu *)&ioucmd->pdu;
+}
+
+static inline void nvme_handle_cqe_rawq(struct nvme_queue *nvmeq,
+					struct nvme_completion *cqe,
+					__u16 command_id)
+{
+	struct nvme_dev *dev = nvmeq->dev;
+	u32 status = le16_to_cpu(cqe->status) >> 1;
+	u64 result = cqe->result.u64;
+	struct nvme_iod *iod;
+	int id, reg_id;
+
+	reg_id = nvme_genctr_from_cid(command_id);
+	/* we should not encounter completions from past registration*/
+	WARN_ON_ONCE(nvmeq->reg_id != reg_id);
+
+	id = nvme_tag_from_cid(command_id);
+	iod = &nvmeq->iod[id];
+
+	if (iod->dma_len)
+		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
+		nvme_is_write(&iod->cmd) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+
+	nvme_pci_put_cmdid(nvmeq, id);
+	io_uring_cmd_done(iod->ioucmd, status, result, IO_URING_F_UNLOCKED);
+}
+
 static inline void nvme_handle_cqe(struct nvme_queue *nvmeq,
 				   struct io_comp_batch *iob, u16 idx)
 {
@@ -1039,6 +1084,9 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq,
 	__u16 command_id = READ_ONCE(cqe->command_id);
 	struct request *req;
 
+	if (test_bit(NVMEQ_RAW, &nvmeq->flags))
+		return nvme_handle_cqe_rawq(nvmeq, cqe, command_id);
+
 	/*
 	 * AEN requests are special as they don't time out and can
 	 * survive any kind of queue freeze and often don't respond to
@@ -1151,6 +1199,25 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	return found;
 }
 
+static int nvme_poll_uring_cmd(struct io_uring_cmd *ioucmd, int qid,
+			       struct io_comp_batch *iob)
+
+{
+	struct nvme_uring_direct_pdu *pdu = nvme_uring_cmd_direct_pdu(ioucmd);
+	struct nvme_dev *dev = to_nvme_dev(pdu->ns->ctrl);
+	struct nvme_queue *nvmeq = &dev->queues[qid];
+	bool found;
+
+	if (!nvme_cqe_pending(nvmeq))
+		return 0;
+
+	spin_lock(&nvmeq->cq_poll_lock);
+	found = nvme_poll_cq(nvmeq, iob);
+	spin_unlock(&nvmeq->cq_poll_lock);
+
+	return found;
+}
+
 static void nvme_pci_submit_async_event(struct nvme_ctrl *ctrl)
 {
 	struct nvme_dev *dev = to_nvme_dev(ctrl);
@@ -1762,6 +1829,22 @@ static int nvme_pci_alloc_cmdid_bmp(struct nvme_queue *nvmeq)
 	return 0;
 }
 
+static int nvme_pci_get_cmdid(struct nvme_queue *nvmeq)
+{
+	int id = 0, size = nvmeq->q_depth - 1;
+
+	spin_lock(&nvmeq->cmdid_lock);
+	id = find_first_zero_bit(nvmeq->cmdid_bmp, size);
+	if (id >= size) {
+		id = -EBUSY;
+		goto unlock;
+	}
+	set_bit(id, nvmeq->cmdid_bmp);
+unlock:
+	spin_unlock(&nvmeq->cmdid_lock);
+	return id;
+}
+
 static int nvme_pci_alloc_iod_array(struct nvme_queue *nvmeq)
 {
 	if (!test_bit(NVMEQ_RAW, &nvmeq->flags))
@@ -1793,13 +1876,17 @@ static int nvme_pci_register_queue(void *data)
 	struct nvme_ns *ns = (struct nvme_ns *) data;
 	struct nvme_dev *dev = to_nvme_dev(ns->ctrl);
 	int qid, ret;
+	struct nvme_queue *nvmeq;
 
 	qid = nvme_pci_get_rawq(dev);
 	if (qid > 0) {
 		/* setup command-id bitmap and iod array */
-		ret = nvme_pci_setup_rawq(&dev->queues[qid]);
+		nvmeq = &dev->queues[qid];
+		ret = nvme_pci_setup_rawq(nvmeq);
 		if (ret < 0)
 			qid = ret;
+		else
+			nvmeq->reg_id++;
 	}
 	return qid;
 }
@@ -1812,6 +1899,107 @@ static int nvme_pci_unregister_queue(void *data, int qid)
 	return nvme_pci_put_rawq(dev, qid);
 }
 
+static int nvme_map_io_fb(struct request_queue *q, struct io_uring_cmd *ioucmd,
+			struct nvme_dev *dev, struct nvme_iod *iod,
+			unsigned long addr, unsigned int buf_len)
+{
+	struct nvme_command *cmnd = &iod->cmd;
+	int ret, rw = nvme_is_write(cmnd);
+	struct iov_iter iter;
+	size_t nr_iter, nr_segs;
+	struct bio_vec *bv;
+
+	if (!(ioucmd->flags & IORING_URING_CMD_FIXED))
+		return -EINVAL;
+
+	ret = io_uring_cmd_import_fixed(addr, buf_len, rw, &iter, ioucmd);
+	if (ret < 0)
+		return ret;
+	nr_iter = iov_iter_count(&iter);
+	nr_segs = iter.nr_segs;
+
+	/* device will do these checks anyway, so why do duplicate work? */
+	if (!nr_iter || (nr_iter >> SECTOR_SHIFT) > queue_max_hw_sectors(q))
+		goto err;
+	if (nr_segs > queue_max_segments(q))
+		goto err;
+	/* this will be attempted from regular path instead */
+	if (nr_segs > 1)
+		goto err;
+
+	bv = (struct bio_vec *)&iter.bvec[0];
+	if (bv->bv_offset + bv->bv_len <= NVME_CTRL_PAGE_SIZE * 2)
+		return nvme_setup_prp_simple(dev, iod,
+				(struct nvme_rw_command *)cmnd,
+				bv, rw ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+err:
+	return -EINVAL;
+}
+
+static int nvme_alloc_cmd_from_q(struct nvme_queue *nvmeq, int *cmdid,
+				struct nvme_iod **iod)
+{
+	int id;
+
+	id = nvme_pci_get_cmdid(nvmeq);
+	if (id < 0)
+		return id;
+	*cmdid = id | nvme_cid_install_genctr(nvmeq->reg_id);
+	*iod = &nvmeq->iod[id];
+	return 0;
+}
+
+static int nvme_pci_queue_ucmd(struct io_uring_cmd *ioucmd, int qid)
+{
+	struct nvme_uring_direct_pdu *pdu = nvme_uring_cmd_direct_pdu(ioucmd);
+	struct nvme_ns *ns = pdu->ns;
+	struct nvme_ctrl *ctrl = ns->ctrl;
+	struct nvme_dev *dev = to_nvme_dev(ctrl);
+	struct nvme_command *nvme_cmd;
+	struct nvme_uring_data d;
+	int ret, cmdid;
+	struct nvme_iod *iod;
+	struct nvme_queue *nvmeq = &dev->queues[qid];
+
+	ret = nvme_alloc_cmd_from_q(nvmeq, &cmdid, &iod);
+	if (ret)
+		return ret;
+
+	iod->ioucmd = ioucmd;
+	nvme_cmd = &iod->cmd;
+	ret = nvme_prep_cmd_from_ioucmd(ctrl, ns, ioucmd, nvme_cmd, &d);
+	if (ret)
+		goto out;
+
+	nvme_cmd->common.command_id = cmdid;
+	iod->aborted = false;
+	iod->nr_allocations = -1;
+	iod->sgt.nents = 0;
+	ret = nvme_map_io_fb(ns->queue, ioucmd, dev, iod, d.addr, d.data_len);
+	if  (ret)
+		goto out;
+
+	/*
+	 * since this nvmeq is exclusive to single submitter (io_uring
+	 * follows one-thread-per-ring model), we do not need the lock
+	 * ideally. But we have lifetime difference between io_uring
+	 * and nvme sqe. io_uring SQE can be reused just after submission
+	 * but for nvme we have to wait until completion.
+	 * So if we run out of space, submission will be deferred to
+	 * io_uring worker. So we can't skip the lock.
+	 * But not all is lost! Due to one-thread-per-ring model and
+	 * polled-completion, contention is not common in most cases.
+	 */
+	spin_lock(&nvmeq->sq_lock);
+	nvme_sq_copy_cmd(nvmeq, &iod->cmd);
+	nvme_write_sq_db(nvmeq, true);
+	spin_unlock(&nvmeq->sq_lock);
+	return -EIOCBQUEUED;
+out:
+	nvme_pci_put_cmdid(nvmeq, cmdid);
+	return ret;
+}
+
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
@@ -1832,6 +2020,8 @@ static const struct blk_mq_ops nvme_mq_ops = {
 	.poll		= nvme_poll,
 	.register_queue	= nvme_pci_register_queue,
 	.unregister_queue =  nvme_pci_unregister_queue,
+	.queue_uring_cmd = nvme_pci_queue_ucmd,
+	.poll_uring_cmd	= nvme_poll_uring_cmd,
 };
 
 static void nvme_dev_remove_admin(struct nvme_dev *dev)
-- 
2.25.1

