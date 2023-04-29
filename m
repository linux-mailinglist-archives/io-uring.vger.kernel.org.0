Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC716F23F3
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjD2JnA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjD2Jm4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:42:56 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2521FFF
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:42:53 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230429094251epoutp030efd0131708c7187dd7a1fde5e4c3462~aXo1V0SqN2944229442epoutp03n
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:42:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230429094251epoutp030efd0131708c7187dd7a1fde5e4c3462~aXo1V0SqN2944229442epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761371;
        bh=DmNoMnErFd30BsWQmdnQWonqLi5WPKhdAEqCyccyvuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ix8x4lb+rtZ0ZDeaQ8HhIP/Ky0T5I+S6Uy5+BDaYY9j6UbBB+VYMDYOgyQ1a/jk/+
         ID79GU7hrYDJ6WUvs13u2Y0z1k7O63nVzgvxwUtqh6cIRnp4jWlf5gBeP5odWicLu8
         AE4HO7/PJsNhU8gQEBM79s3x5zrrCk32AUUOMWqI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230429094251epcas5p127889f83c801d6f9aee5fbe5a4da0ba6~aXo04yuRV2857728577epcas5p1m;
        Sat, 29 Apr 2023 09:42:51 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Q7kzZ1T9rz4x9Pq; Sat, 29 Apr
        2023 09:42:50 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.7C.54880.A96EC446; Sat, 29 Apr 2023 18:42:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230429094249epcas5p18bd717f4e34077c0fcf28458f11de8d1~aXozX1JN72857728577epcas5p1l;
        Sat, 29 Apr 2023 09:42:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230429094249epsmtrp21015735b632716c0a8a450abd4bc8a8a~aXozXJwWV0329503295epsmtrp2Q;
        Sat, 29 Apr 2023 09:42:49 +0000 (GMT)
X-AuditID: b6c32a49-8c5ff7000001d660-90-644ce69a7f9c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.38.27706.996EC446; Sat, 29 Apr 2023 18:42:49 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094247epsmtip294491de44997f253a7fda773fafa9aa2~aXoxX4sIF0191201912epsmtip2K;
        Sat, 29 Apr 2023 09:42:47 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [RFC PATCH 06/12] pci: implement register/unregister functionality
Date:   Sat, 29 Apr 2023 15:09:19 +0530
Message-Id: <20230429093925.133327-7-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmlu6sZz4pBrumsVp8/PqbxaJpwl9m
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8puse71exaLTX9PMjnw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsfOhpcfmJfUeu282sHn0bVnF6PF5k1wAZ1S2TUZqYkpq
        kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QvUoKZYk5pUChgMTi
        YiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iwzbe9ZCo7r
        VUzZKdzA+Ey1i5GTQ0LAROLKu7ssXYxcHEICuxklTq1ZxAbhfGKUuLDyEzOE841RYsbiYyww
        LT9fv4Vq2cso0Xr3BCOE8xmopb+TtYuRg4NNQFPiwuRSkAYRAReJprVTwcYyg0xa9PodK0hC
        WMBbYtGhc2A2i4CqxJ8Fs8FsXgFLif5JmxkhtslLzLz0nR3E5hSwkvg+YzczRI2gxMmZT8Au
        Ygaqad46G+xUCYGlHBIH302BOtVFomvFTChbWOLV8S3sELaUxOd3e9kg7GSJSzPPMUHYJRKP
        9xyEsu0lWk/1M4M8wwz0zPpd+hC7+CR6fz9hAglLCPBKdLQJQVQrStyb9JQVwhaXeDhjCZTt
        IfH61yMwW0igl1FiyQWZCYzys5B8MAvJB7MQli1gZF7FKJlaUJybnlpsWmCYl1oOj9fk/NxN
        jOBUq+W5g/Hugw96hxiZOBgPMUpwMCuJ8PJWuqcI8aYkVlalFuXHF5XmpBYfYjQFBvFEZinR
        5Hxgss8riTc0sTQwMTMzM7E0NjNUEudVtz2ZLCSQnliSmp2aWpBaBNPHxMEp1cA0wdNkooL6
        pdXLG33rnD1vTv+wqjf+emOKx3vmSzMyt3xTyWN138Wixfj0k8+RV1NWsubecfq8N2R568Pi
        r4vPdIo/vH2v/Lm4jRaPpMWKmJpjC5QjdgWsEDe0XZHP2Krg6PtZ9bPVnhmKpXeXZ4SejRDi
        4/10xUNINeV36aqTr6Qt3TbV+F3tfGdhMrl87sSvjVwp+hYawncaZxxd+Pbqqv16QlesLiUx
        psewuIu+/e70vKr+3RGP++m6k0paTHhYmV0Cn13OzLqxQOPFNk2Ja3OP7g7/V5mxuHLjAZ2H
        ObtWs/yTvjrvjNn5P+mHsnWDlFaX1/TlH7xi5zjj56fO5dt/ZHbeXbfg7A7miSKMSizFGYmG
        WsxFxYkA9VRJCT4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWy7bCSvO7MZz4pBk1z1Sw+fv3NYtE04S+z
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWW3WPf6PYvFpr8nmRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2PnQ0mPzknqP3Tcb2Dz6tqxi9Pi8SS6AM4rLJiU1J7Ms
        tUjfLoEr40zbe5aC43oVU3YKNzA+U+1i5OSQEDCR+Pn6LUsXIxeHkMBuRonpB7exQCTEJZqv
        /WCHsIUlVv57zg5R9JFRYubT68xdjBwcbAKaEhcml4LUiAh4SbS/ncUGUsMs8I9R4sH7NjaQ
        hLCAt8SiQ+dYQWwWAVWJPwtmg9m8ApYS/ZM2M0IskJeYeek72DJOASuJ7zN2g80XAqppXBAP
        US4ocXLmE7DbmIHKm7fOZp7AKDALSWoWktQCRqZVjJKpBcW56bnFhgWGeanlesWJucWleel6
        yfm5mxjBUaKluYNx+6oPeocYmTgYDzFKcDArifDyVrqnCPGmJFZWpRblxxeV5qQWH2KU5mBR
        Eue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cB0bIk9J49dgbDp05N5q/oOac6zmln1rEjhTl9N
        emrQoRMHuFsd9bY9kFmsZdvbqrOqb8PB6hVaFSYXpzAvk0ualDjXylj1VvLbG/tMKxdMept2
        M1qSX3CPcVve8raI8P/zW1RmrTfTY72ncG7+glDn8+G+909orDzJb/j9u9OtdywfZ1y5/5/j
        1jIDg3zWfWsN50z4tOjjjO57X/d8aMj9WsZhfkDM5eoDnkfPlljGCklfWXCCYb+Ki+iiaqG/
        e8yFpj9yrZWtmie7IKU83MRx9v/utcpFxROMTPIZdgYWXVO980TmwtYEwf0cMgE8N/zeT+G9
        33+sRkru35385Sxy2t9d17x/LBMltar/9Mk6JZbijERDLeai4kQAGzGqLgEDAAA=
X-CMS-MailID: 20230429094249epcas5p18bd717f4e34077c0fcf28458f11de8d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094249epcas5p18bd717f4e34077c0fcf28458f11de8d1
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094249epcas5p18bd717f4e34077c0fcf28458f11de8d1@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Implement the register callback. It checks if any raw-queue is available to
be attached. If found, it returns the qid.
During queue registration, iod and command-id bitmap are also preallocated.

Unregister callback does the opposite and returns the corresponding
queue to the pool of available raw-queues.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/pci.c | 154 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d366a76cc304..b4498e198e8a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -116,6 +116,15 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown);
 static void nvme_delete_io_queues(struct nvme_dev *dev);
 static void nvme_update_attrs(struct nvme_dev *dev);
 
+enum {
+	Q_FREE,
+	Q_ALLOC
+};
+struct rawq_info {
+	int nr_free;
+	int q_state[];
+};
+
 /*
  * Represents an NVM Express device.  Each nvme_dev is a PCI function.
  */
@@ -164,6 +173,8 @@ struct nvme_dev {
 	unsigned int nr_write_queues;
 	unsigned int nr_poll_queues;
 	unsigned int nr_raw_queues;
+	struct mutex rawq_lock;
+	struct rawq_info *rawqi;
 };
 
 static int io_queue_depth_set(const char *val, const struct kernel_param *kp)
@@ -195,6 +206,10 @@ struct nvme_queue {
 	struct nvme_dev *dev;
 	spinlock_t sq_lock;
 	void *sq_cmds;
+	 /* only used for raw queues: */
+	unsigned long *cmdid_bmp;
+	spinlock_t cmdid_lock;
+	struct nvme_iod *iod;
 	 /* only used for poll queues: */
 	spinlock_t cq_poll_lock ____cacheline_aligned_in_smp;
 	struct nvme_completion *cqes;
@@ -1661,6 +1676,141 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled,
 	return result;
 }
 
+static int setup_rawq_info(struct nvme_dev *dev, int nr_rawq)
+{
+	struct rawq_info *rawqi;
+	int size = sizeof(struct rawq_info) + nr_rawq * sizeof(int);
+
+	rawqi = kzalloc(size, GFP_KERNEL);
+	if (rawqi == NULL)
+		return -ENOMEM;
+	rawqi->nr_free = nr_rawq;
+	dev->rawqi = rawqi;
+	return 0;
+}
+
+static int nvme_pci_get_rawq(struct nvme_dev *dev)
+{
+	int i, qid, nr_rawq;
+	struct rawq_info *rawqi = NULL;
+	int ret = -EINVAL;
+
+	nr_rawq = dev->nr_raw_queues;
+	if (!nr_rawq)
+		return ret;
+
+	mutex_lock(&dev->rawq_lock);
+	if (dev->rawqi == NULL) {
+		ret = setup_rawq_info(dev, nr_rawq);
+		if (ret)
+			goto unlock;
+	}
+	rawqi = dev->rawqi;
+	if (rawqi->nr_free == 0) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+	for (i = 0; i < nr_rawq; i++) {
+		if (rawqi->q_state[i] == Q_FREE) {
+			rawqi->q_state[i] = Q_ALLOC;
+			qid = dev->nr_allocated_queues - nr_rawq - i;
+			rawqi->nr_free--;
+			ret = qid;
+			goto unlock;
+		}
+	}
+unlock:
+	mutex_unlock(&dev->rawq_lock);
+	return ret;
+}
+
+static int nvme_pci_put_rawq(struct nvme_dev *dev, int qid)
+{
+	int i, nr_rawq;
+	struct rawq_info *rawqi = NULL;
+	struct nvme_queue *nvmeq;
+
+	nr_rawq = dev->nr_raw_queues;
+	if (!nr_rawq || dev->rawqi == NULL)
+		return -EINVAL;
+
+	i = dev->nr_allocated_queues - nr_rawq - qid;
+	mutex_lock(&dev->rawq_lock);
+	rawqi = dev->rawqi;
+	if (rawqi->q_state[i] == Q_ALLOC) {
+		rawqi->q_state[i] = Q_FREE;
+		rawqi->nr_free++;
+	}
+	mutex_unlock(&dev->rawq_lock);
+	nvmeq = &dev->queues[qid];
+	kfree(nvmeq->cmdid_bmp);
+	kfree(nvmeq->iod);
+	return 0;
+}
+
+static int nvme_pci_alloc_cmdid_bmp(struct nvme_queue *nvmeq)
+{
+	int size = BITS_TO_LONGS(nvmeq->q_depth) * sizeof(unsigned long);
+
+	if (!test_bit(NVMEQ_RAW, &nvmeq->flags))
+		return -EINVAL;
+	nvmeq->cmdid_bmp = kzalloc(size, GFP_KERNEL);
+	if (!nvmeq->cmdid_bmp)
+		return -ENOMEM;
+	spin_lock_init(&nvmeq->cmdid_lock);
+	return 0;
+}
+
+static int nvme_pci_alloc_iod_array(struct nvme_queue *nvmeq)
+{
+	if (!test_bit(NVMEQ_RAW, &nvmeq->flags))
+		return -EINVAL;
+	nvmeq->iod = kcalloc(nvmeq->q_depth - 1, sizeof(struct nvme_iod),
+				 GFP_KERNEL);
+	if (!nvmeq->iod)
+		return -ENOMEM;
+	return 0;
+}
+
+static int nvme_pci_setup_rawq(struct nvme_queue *nvmeq)
+{
+	int ret;
+
+	ret = nvme_pci_alloc_cmdid_bmp(nvmeq);
+	if (ret)
+		return ret;
+	ret = nvme_pci_alloc_iod_array(nvmeq);
+	if (ret) {
+		kfree(nvmeq->cmdid_bmp);
+		return ret;
+	}
+	return ret;
+}
+
+static int nvme_pci_register_queue(void *data)
+{
+	struct nvme_ns *ns = (struct nvme_ns *) data;
+	struct nvme_dev *dev = to_nvme_dev(ns->ctrl);
+	int qid, ret;
+
+	qid = nvme_pci_get_rawq(dev);
+	if (qid > 0) {
+		/* setup command-id bitmap and iod array */
+		ret = nvme_pci_setup_rawq(&dev->queues[qid]);
+		if (ret < 0)
+			qid = ret;
+	}
+	return qid;
+}
+
+static int nvme_pci_unregister_queue(void *data, int qid)
+{
+	struct nvme_ns *ns = (struct nvme_ns *) data;
+	struct nvme_dev *dev = to_nvme_dev(ns->ctrl);
+
+	return nvme_pci_put_rawq(dev, qid);
+}
+
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
@@ -1679,6 +1829,8 @@ static const struct blk_mq_ops nvme_mq_ops = {
 	.map_queues	= nvme_pci_map_queues,
 	.timeout	= nvme_timeout,
 	.poll		= nvme_poll,
+	.register_queue	= nvme_pci_register_queue,
+	.unregister_queue =  nvme_pci_unregister_queue,
 };
 
 static void nvme_dev_remove_admin(struct nvme_dev *dev)
@@ -2698,6 +2850,7 @@ static void nvme_pci_free_ctrl(struct nvme_ctrl *ctrl)
 	nvme_free_tagset(dev);
 	put_device(dev->dev);
 	kfree(dev->queues);
+	kfree(dev->rawqi);
 	kfree(dev);
 }
 
@@ -2938,6 +3091,7 @@ static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
 		return ERR_PTR(-ENOMEM);
 	INIT_WORK(&dev->ctrl.reset_work, nvme_reset_work);
 	mutex_init(&dev->shutdown_lock);
+	mutex_init(&dev->rawq_lock);
 
 	dev->nr_write_queues = write_queues;
 	dev->nr_poll_queues = poll_queues;
-- 
2.25.1

