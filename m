Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B716F23ED
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjD2Jmt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjD2Jmr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:42:47 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB3A1FF6
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:42:44 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230429094243epoutp02fca536321b0044a6315610f8f370171b~aXotWLr6U1899418994epoutp023
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:42:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230429094243epoutp02fca536321b0044a6315610f8f370171b~aXotWLr6U1899418994epoutp023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761363;
        bh=dRfZRENbFt4jUmmLDCY0GDG76mzOTIYXuzFg+vYW1II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXEV3j+xMVSJ9X29CF99Z9/ioyF2o09AA1XPXxI+msiA/OYyZ10M0nCU7gCTTwos1
         LllOILUmL72oq9wlJ2ujiheP89Z5kURED05igbLv5cGYl729RnyAc0Ud76ux/o4noV
         WLtiDX6xMzNGFhTVhy/8V16lRUuMaLDCct10pvnk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230429094242epcas5p2ffba7cfbd216c2de1cbe71f31e5e0cb2~aXos5fo592162921629epcas5p2E;
        Sat, 29 Apr 2023 09:42:42 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Q7kzP1Z6fz4x9Pv; Sat, 29 Apr
        2023 09:42:41 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.6C.54880.196EC446; Sat, 29 Apr 2023 18:42:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230429094240epcas5p1a7411f266412244115411b05da509e4a~aXorEo7hX2856928569epcas5p1j;
        Sat, 29 Apr 2023 09:42:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230429094240epsmtrp27997cc90dadd279ba2f8ea78308208f4~aXorD9o1-3077530775epsmtrp2e;
        Sat, 29 Apr 2023 09:42:40 +0000 (GMT)
X-AuditID: b6c32a49-8c5ff7000001d660-7e-644ce6916e7d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.38.27706.096EC446; Sat, 29 Apr 2023 18:42:40 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094238epsmtip2189ff0663bb9fdab14e535acca1e77bc~aXopOsFdO0191201912epsmtip2I;
        Sat, 29 Apr 2023 09:42:38 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 02/12] pci: enable "raw_queues = N" module parameter
Date:   Sat, 29 Apr 2023 15:09:15 +0530
Message-Id: <20230429093925.133327-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmhu7EZz4pBu8ucVh8/PqbxWL13X42
        i5sHdjJZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYv5y56yW6x7/Z7FYtPfk0wO3B47Z91l
        9zh/byOLx+WzpR6bVnWyeex8aOmxeUm9x+6bDWwefVtWMXp83iQXwBmVbZORmpiSWqSQmpec
        n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKqSQlliTilQKCCxuFhJ386m
        KL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvj3bEfjAUXLCtW7LzH
        2MC4V7+LkZNDQsBEomvBcdYuRi4OIYHdjBL/2nayQDifGCV275oF5XxjlGhafQHI4QBrub4i
        EyK+l1Gi695lqPbPjBIfDm9lBSliE9CUuDC5FGSFiICLRNPaqWwgNcwCFxklej4dYgFJCAt4
        SGxp2MQMYrMIqEosPT2PCcTmFbCUeNYynxniPnmJmZe+s4PYnAJWEt9n7GaGqBGUODnzCdgc
        ZqCa5q2zmUEWSAgs5JDYseoaVLOLxIUjG9ggbGGJV8e3sEPYUhKf3+2FiidLXJp5jgnCLpF4
        vOcglG0v0XqqnxnkGWagZ9bv0ofYxSfR+/sJEyQgeCU62oQgqhUl7k16ygphi0s8nLEEyvaQ
        OH7uFSMkfHoZJf52f2CawCg/C8kLs5C8MAth2wJG5lWMkqkFxbnpqcWmBYZ5qeXwiE3Oz93E
        CE6xWp47GO8++KB3iJGJg/EQowQHs5IIL2+le4oQb0piZVVqUX58UWlOavEhRlNgGE9klhJN
        zgcm+bySeEMTSwMTMzMzE0tjM0MlcV5125PJQgLpiSWp2ampBalFMH1MHJxSDUx5Mn8YONqM
        veO+71yi3td+bsKEP8++JvH236r6cnyq3v1itsp/zZyNr/lETyy2y17E9DIg6se5fndX4S7d
        sykRvNruDytuXCj79O11YMbUM9eN76xgCLzz/dSNK9qKlaEWS45biR+Lmr3z+G/5PMsF6ZM3
        /GFjnPs0OJI9JWr2h029qQe0jhxmtjXYlHKuWuCYiMeFmKIVa0OT169YM9dqZpbktIxrndGm
        HQnsq/3O5NreOlZ/8JwSj+ztowu+qP6N/i035cHfmR1fXA/m/3EM+cy0+/wUA/uPr2PfXErc
        ulL9vaDF6Y8FBac3vM1Mn+/Q9uaRoe0J+Wf9yypUHO3DJjtExhWzlrEq+ags5C5XYinOSDTU
        Yi4qTgQA2KiuFzoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSvO6EZz4pBiteGlh8/PqbxWL13X42
        i5sHdjJZrFx9lMniXes5Fouj/9+yWUw6dI3RYu8tbYv5y56yW6x7/Z7FYtPfk0wO3B47Z91l
        9zh/byOLx+WzpR6bVnWyeex8aOmxeUm9x+6bDWwefVtWMXp83iQXwBnFZZOSmpNZllqkb5fA
        lfHu2A/GgguWFSt23mNsYNyr38XIwSEhYCJxfUVmFyMnh5DAbkaJl7fNQWwJAXGJ5ms/2CFs
        YYmV/54D2VxANR8ZJR50PmcF6WUT0JS4MLkUpEZEwEui/e0sNpAaZoGbjBL7du8FaxYW8JDY
        0rCJGcRmEVCVWHp6HhOIzStgKfGsZT4zxAJ5iZmXvoPVcwpYSXyfsZsZZL4QUE3jgniIckGJ
        kzOfsIDYzEDlzVtnM09gFJiFJDULSWoBI9MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95Pzc
        TYzgyNDS3MG4fdUHvUOMTByMhxglOJiVRHh5K91ThHhTEiurUovy44tKc1KLDzFKc7AoifNe
        6DoZLySQnliSmp2aWpBaBJNl4uCUamDqV540k0+4XPVszeqWxrK1cuk2Pd7z0jedc/bo2Xp3
        7Y/gDR3Wifrx63aV9IbW/WsuNGkX4NOb3Bpsq6i8dcG71q3/11QfXlpu8TJt7oeMgr01Niw7
        TeP843uk1eyuyZxbWjTt5LJl2bNf+uU+t/fWDj2wTHV6pvJ0qRfh4tHOwu+f86vI5gSX2xj5
        b/i9bskqBoZSLye5uxkK7w3FfwVPEz3zelvXCpfSa6mmdXFHbNOvLSmUnn+/6ZENT9ux//fq
        VpV/zj0X3nlHU8k3pDBxqU/h1H0n4hSX9f1PV16pV7RRUNlYZPrKlht/nvNP8juYLXDu2kfH
        RGPDjs83PK4t/PJw508plbV/jPrWFyqxFGckGmoxFxUnAgADuJEk+wIAAA==
X-CMS-MailID: 20230429094240epcas5p1a7411f266412244115411b05da509e4a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094240epcas5p1a7411f266412244115411b05da509e4a
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094240epcas5p1a7411f266412244115411b05da509e4a@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add the infrastructure that carves out N nvme queue-pairs (struct
nvme_queue) which are not registered with the block layer.
The last N entries in dev->nvmeq[] are available to be attached
on demand.
Similar to poll_queues, these are interrupt-disabled.

This patch does not introduce the interface to attach/detach these
queues with any user. That is to be followed in subsequent patches.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/pci.c | 49 +++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3a38ee6ee129..d366a76cc304 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -101,6 +101,10 @@ static unsigned int poll_queues;
 module_param_cb(poll_queues, &io_queue_count_ops, &poll_queues, 0644);
 MODULE_PARM_DESC(poll_queues, "Number of queues to use for polled IO.");
 
+static unsigned int raw_queues;
+module_param_cb(raw_queues, &io_queue_count_ops, &raw_queues, 0644);
+MODULE_PARM_DESC(raw_queues, "Number of polled, unmanaged queues.");
+
 static bool noacpi;
 module_param(noacpi, bool, 0444);
 MODULE_PARM_DESC(noacpi, "disable acpi bios quirks");
@@ -159,6 +163,7 @@ struct nvme_dev {
 	unsigned int nr_allocated_queues;
 	unsigned int nr_write_queues;
 	unsigned int nr_poll_queues;
+	unsigned int nr_raw_queues;
 };
 
 static int io_queue_depth_set(const char *val, const struct kernel_param *kp)
@@ -209,6 +214,7 @@ struct nvme_queue {
 #define NVMEQ_SQ_CMB		1
 #define NVMEQ_DELETE_ERROR	2
 #define NVMEQ_POLLED		3
+#define NVMEQ_RAW		4
 	__le32 *dbbuf_sq_db;
 	__le32 *dbbuf_cq_db;
 	__le32 *dbbuf_sq_ei;
@@ -1599,7 +1605,8 @@ static int nvme_setup_io_queues_trylock(struct nvme_dev *dev)
 	return 0;
 }
 
-static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
+static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled,
+				bool rawq)
 {
 	struct nvme_dev *dev = nvmeq->dev;
 	int result;
@@ -1613,8 +1620,11 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 	 */
 	if (!polled)
 		vector = dev->num_vecs == 1 ? 0 : qid;
-	else
+	else {
 		set_bit(NVMEQ_POLLED, &nvmeq->flags);
+		if (rawq)
+			set_bit(NVMEQ_RAW, &nvmeq->flags);
+	}
 
 	result = adapter_alloc_cq(dev, qid, nvmeq, vector);
 	if (result)
@@ -1770,7 +1780,7 @@ static int nvme_pci_configure_admin_queue(struct nvme_dev *dev)
 
 static int nvme_create_io_queues(struct nvme_dev *dev)
 {
-	unsigned i, max, rw_queues;
+	unsigned i, max, rw_queues, rw_poll_queues;
 	int ret = 0;
 
 	for (i = dev->ctrl.queue_count; i <= dev->max_qid; i++) {
@@ -1781,17 +1791,20 @@ static int nvme_create_io_queues(struct nvme_dev *dev)
 	}
 
 	max = min(dev->max_qid, dev->ctrl.queue_count - 1);
-	if (max != 1 && dev->io_queues[HCTX_TYPE_POLL]) {
+	if (max != 1 &&
+		(dev->io_queues[HCTX_TYPE_POLL] || dev->nr_raw_queues)) {
 		rw_queues = dev->io_queues[HCTX_TYPE_DEFAULT] +
 				dev->io_queues[HCTX_TYPE_READ];
+		rw_poll_queues = rw_queues + dev->io_queues[HCTX_TYPE_POLL];
 	} else {
 		rw_queues = max;
+		rw_poll_queues = max;
 	}
-
 	for (i = dev->online_queues; i <= max; i++) {
 		bool polled = i > rw_queues;
+		bool rawq = i > rw_poll_queues;
 
-		ret = nvme_create_queue(&dev->queues[i], i, polled);
+		ret = nvme_create_queue(&dev->queues[i], i, polled, rawq);
 		if (ret)
 			break;
 	}
@@ -2212,7 +2225,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
 		.calc_sets	= nvme_calc_irq_sets,
 		.priv		= dev,
 	};
-	unsigned int irq_queues, poll_queues;
+	unsigned int irq_queues, poll_queues, raw_queues;
 
 	/*
 	 * Poll queues don't need interrupts, but we need at least one I/O queue
@@ -2220,6 +2233,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
 	 */
 	poll_queues = min(dev->nr_poll_queues, nr_io_queues - 1);
 	dev->io_queues[HCTX_TYPE_POLL] = poll_queues;
+	raw_queues = dev->nr_raw_queues;
 
 	/*
 	 * Initialize for the single interrupt case, will be updated in
@@ -2235,7 +2249,7 @@ static int nvme_setup_irqs(struct nvme_dev *dev, unsigned int nr_io_queues)
 	 */
 	irq_queues = 1;
 	if (!(dev->ctrl.quirks & NVME_QUIRK_SINGLE_VECTOR))
-		irq_queues += (nr_io_queues - poll_queues);
+		irq_queues += (nr_io_queues - poll_queues - raw_queues);
 	return pci_alloc_irq_vectors_affinity(pdev, 1, irq_queues,
 			      PCI_IRQ_ALL_TYPES | PCI_IRQ_AFFINITY, &affd);
 }
@@ -2248,7 +2262,9 @@ static unsigned int nvme_max_io_queues(struct nvme_dev *dev)
 	 */
 	if (dev->ctrl.quirks & NVME_QUIRK_SHARED_TAGS)
 		return 1;
-	return num_possible_cpus() + dev->nr_write_queues + dev->nr_poll_queues;
+
+	return num_possible_cpus() + dev->nr_write_queues + dev->nr_poll_queues
+		+ dev->nr_raw_queues;
 }
 
 static int nvme_setup_io_queues(struct nvme_dev *dev)
@@ -2265,6 +2281,7 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	 */
 	dev->nr_write_queues = write_queues;
 	dev->nr_poll_queues = poll_queues;
+	dev->nr_raw_queues = raw_queues;
 
 	nr_io_queues = dev->nr_allocated_queues - 1;
 	result = nvme_set_queue_count(&dev->ctrl, &nr_io_queues);
@@ -2329,7 +2346,8 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 
 	dev->num_vecs = result;
 	result = max(result - 1, 1);
-	dev->max_qid = result + dev->io_queues[HCTX_TYPE_POLL];
+	dev->max_qid = result + dev->io_queues[HCTX_TYPE_POLL] +
+			dev->nr_raw_queues;
 
 	/*
 	 * Should investigate if there's a performance win from allocating
@@ -2356,10 +2374,11 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 		nvme_suspend_io_queues(dev);
 		goto retry;
 	}
-	dev_info(dev->ctrl.device, "%d/%d/%d default/read/poll queues\n",
+	dev_info(dev->ctrl.device, "%d/%d/%d/%d default/read/poll queues/raw queues\n",
 					dev->io_queues[HCTX_TYPE_DEFAULT],
 					dev->io_queues[HCTX_TYPE_READ],
-					dev->io_queues[HCTX_TYPE_POLL]);
+					dev->io_queues[HCTX_TYPE_POLL],
+					dev->nr_raw_queues);
 	return 0;
 out_unlock:
 	mutex_unlock(&dev->shutdown_lock);
@@ -2457,7 +2476,8 @@ static unsigned int nvme_pci_nr_maps(struct nvme_dev *dev)
 
 static void nvme_pci_update_nr_queues(struct nvme_dev *dev)
 {
-	blk_mq_update_nr_hw_queues(&dev->tagset, dev->online_queues - 1);
+	blk_mq_update_nr_hw_queues(&dev->tagset,
+			dev->online_queues - dev->nr_raw_queues - 1);
 	/* free previously allocated queues that are no longer usable */
 	nvme_free_queues(dev, dev->online_queues);
 }
@@ -2921,6 +2941,7 @@ static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
 
 	dev->nr_write_queues = write_queues;
 	dev->nr_poll_queues = poll_queues;
+	dev->nr_raw_queues = raw_queues;
 	dev->nr_allocated_queues = nvme_max_io_queues(dev) + 1;
 	dev->queues = kcalloc_node(dev->nr_allocated_queues,
 			sizeof(struct nvme_queue), GFP_KERNEL, node);
@@ -3034,7 +3055,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (dev->online_queues > 1) {
 		nvme_alloc_io_tag_set(&dev->ctrl, &dev->tagset, &nvme_mq_ops,
 				nvme_pci_nr_maps(dev), sizeof(struct nvme_iod),
-				dev->ctrl.queue_count);
+				dev->ctrl.queue_count - dev->nr_raw_queues);
 		nvme_dbbuf_set(dev);
 	}
 
-- 
2.25.1

