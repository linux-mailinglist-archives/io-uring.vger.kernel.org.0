Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4199A59EAAE
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiHWSNK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbiHWSMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:12:46 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D2D6E8B8
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:25:23 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220823162521epoutp02aa4bfedec9d4ffd13290772ab1254db7~OBgLiDvWp2649926499epoutp021
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 16:25:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220823162521epoutp02aa4bfedec9d4ffd13290772ab1254db7~OBgLiDvWp2649926499epoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661271922;
        bh=JUKbdFo7mf2YbJAJOW6KiaI/iC7zAWCIrdft9OfKayQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDxejuvU17dnMYSQkjfNbXTBpaE2fKw/C0hSiyRidPAbFcwd5Ag1fnbVNtPgaUcg9
         TAPesH9Qy2ccHlwpwxJTuGDdkAnI0qIF9NZmYsrF2yRjGTQpe+HAVbXYCjp3PyR1AU
         4MxvmxsLuE1AVPiCjDjaqerNtfCOZlBykroEe1n4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220823162521epcas5p1f24bd31ad16f2804dafa5f66bdc1fc44~OBgK_rdUX2001420014epcas5p1_;
        Tue, 23 Aug 2022 16:25:21 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MBvht1ygSz4x9Ps; Tue, 23 Aug
        2022 16:25:18 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FC.15.18001.E6FF4036; Wed, 24 Aug 2022 01:25:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220823162517epcas5p2f1b808e60bae4bc1161b2d3a3a388534~OBgHNpxT-1190311903epcas5p2F;
        Tue, 23 Aug 2022 16:25:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220823162517epsmtrp13427c76839105bda0f54348525358e9f~OBgHM390I2268222682epsmtrp1L;
        Tue, 23 Aug 2022 16:25:17 +0000 (GMT)
X-AuditID: b6c32a4a-2c3ff70000004651-02-6304ff6ed0eb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        35.A2.18644.D6FF4036; Wed, 24 Aug 2022 01:25:17 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220823162515epsmtip20aef68abb86220f6289ad6f3f98cc481~OBgFoFOsM2555425554epsmtip27;
        Tue, 23 Aug 2022 16:25:15 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH for-next v3 4/4] nvme: wire up async polling for io
 passthrough commands
Date:   Tue, 23 Aug 2022 21:44:43 +0530
Message-Id: <20220823161443.49436-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823161443.49436-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEJsWRmVeSWpSXmKPExsWy7bCmlm7ef5Zkg78d3BZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi6P/37JZTDp0jdFi7y1ti/nLnrJbHJrczOTA7bFz1l12
        j8tnSz02repk89i8pN5j980GNo/3+66yefRtWcXo8XmTXABHVLZNRmpiSmqRQmpecn5KZl66
        rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtCZSgpliTmlQKGAxOJiJX07m6L80pJU
        hYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjH+/WtkKpptU7O5/wNjAeFq7
        i5GTQ0LAROLUi4/MXYxcHEICuxkl/txrYgdJCAl8YpR4O0kFIvGZUWLJhd+MMB0Xj8xhgkjs
        YpRYf/woC1xV56G5QBkODjYBTYkLk0tBGkQEvCTu337PClLDLHCBUeLezpssIAlhgSiJ1g3/
        wNaxCKhKnPy+AizOK2Ahcap7HyvENnmJmZe+s4PM5BSwlDh9UA6iRFDi5MwnYOXMQCXNW2eD
        vSAhMJVDov/tShaIXheJrys2MUPYwhKvjm9hh7ClJF72t0HZyRKXZp5jgrBLJB7vOQhl20u0
        nupnBtnLDPTL+l36ELv4JHp/PwF7UUKAV6KjTQiiWlHi3qSnUBeLSzycsQTK9pDoPDyJFRI8
        PYwSDQ+6mCcwys9C8sIsJC/MQti2gJF5FaNkakFxbnpqsWmBUV5qOTxek/NzNzGCE6uW1w7G
        hw8+6B1iZOJgPMQowcGsJMJrdYwlWYg3JbGyKrUoP76oNCe1+BCjKTCIJzJLiSbnA1N7Xkm8
        oYmlgYmZmZmJpbGZoZI47xRtxmQhgfTEktTs1NSC1CKYPiYOTqkGJpel9hpv5AP0yjT6ly7z
        uqfvWfttefSSd5lXmtgvvTl+hz3m69aPQS9esnpd/3z1XSRrte7tBS0ZJ9Q2JhfOFd68yD2u
        xPZy6bSV99aYLr4u28eVL3VhUlv9+etS+1z5s2P+a932dmviFQx2npHbefi+V9zUU7ePCqV8
        ttV94Xq06Hu08Satlu0nGmR+akw743WlszxD7rXDybWLbq9t5Hu99PG02yfqNH7ksJctlgl6
        c7BmpcaLivci1UK+flPfPRHtO89ok7Dk++IeuySO3qr5O3TjOs1+/fDnWeT475ZGksBKhuT1
        b6bsS5HJ2rT+TPWatjvpc15/DFh05cd0jjV8cvMSXt+tn7xCcU6CaKMSS3FGoqEWc1FxIgCU
        YcOINQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvG7uf5Zkg10n+S2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWW3ODS5mcmB22PnrLvs
        HpfPlnpsWtXJ5rF5Sb3H7psNbB7v911l8+jbsorR4/MmuQCOKC6blNSczLLUIn27BK6Mf79a
        2Qqmm1Ts7n/A2MB4WruLkZNDQsBE4uKROUwgtpDADkaJ24usIeLiEs3XfrBD2MISK/89B7K5
        gGo+MkpsubGCtYuRg4NNQFPiwuRSkBoRgQCJg42XwWqYBW4wSuzrnQI2VFggQmLzxvOsIDaL
        gKrEye8rWEBsXgELiVPd+1ghFshLzLz0nR1kJqeApcTpg3IQ91hI/NnUwAZRLihxcuYTsFZm
        oPLmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnBMaGnt
        YNyz6oPeIUYmDsZDjBIczEoivFbHWJKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCe
        WJKanZpakFoEk2Xi4JRqYIr9bXaPw+qCxrNzPqwyjbenH9BxXnA0xtC5u0q7rsh11+2aazKL
        m/gbizJ+XBXy3254YdOHH5oSXf+OfJXRuJ5xdNXVq0fjr99kX3bcoSlDfuJin+6dtyz6PUwO
        v5Gtq/3/++LHo5lvG+/rGq17YjW/a5rd3v7N4lOEXG/YbZ/ANfvSVtPgzliPZMZTkv+ilRtl
        W/cHTnv7xPHBjLoNZ6JaHoW3PWwQLNieudS5rJuf4WlH3Elf1QKhmM0vVWOY9Lesnui8XSMv
        8Jf1omQeqSjddRuMvFUntz0LZFj35dRyBfmrm3NjXCMrRDg0ltxiK9zvYHdkzmX21L1vTued
        PTZBzPtJ1KKHylP1A0MNxJRYijMSDbWYi4oTAQTShw34AgAA
X-CMS-MailID: 20220823162517epcas5p2f1b808e60bae4bc1161b2d3a3a388534
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220823162517epcas5p2f1b808e60bae4bc1161b2d3a3a388534
References: <20220823161443.49436-1-joshi.k@samsung.com>
        <CGME20220823162517epcas5p2f1b808e60bae4bc1161b2d3a3a388534@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Store a cookie during submission, and use that to implement
completion-polling inside the ->uring_cmd_iopoll handler.
This handler makes use of existing bio poll facility.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/core.c      |  1 +
 drivers/nvme/host/ioctl.c     | 73 ++++++++++++++++++++++++++++++++---
 drivers/nvme/host/multipath.c |  1 +
 drivers/nvme/host/nvme.h      |  2 +
 4 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index af367b22871b..7ac0deb8bbf8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3976,6 +3976,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.unlocked_ioctl	= nvme_ns_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.uring_cmd	= nvme_ns_chr_uring_cmd,
+	.uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 27614bee7380..7756b439a688 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -391,11 +391,19 @@ static void nvme_uring_cmd_end_io(struct request *req, blk_status_t err)
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	/* extract bio before reusing the same field for request */
 	struct bio *bio = pdu->bio;
+	void *cookie = READ_ONCE(ioucmd->cookie);
 
 	pdu->req = req;
 	req->bio = bio;
-	/* this takes care of moving rest of completion-work to task context */
-	io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
+
+	/*
+	 * For iopoll, complete it directly.
+	 * Otherwise, move the completion to task work.
+	 */
+	if (cookie != NULL && blk_rq_is_poll(req))
+		nvme_uring_task_cb(ioucmd);
+	else
+		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 }
 
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
@@ -445,7 +453,10 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		rq_flags = REQ_NOWAIT;
 		blk_flags = BLK_MQ_REQ_NOWAIT;
 	}
+	if (issue_flags & IO_URING_F_IOPOLL)
+		rq_flags |= REQ_POLLED;
 
+retry:
 	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
 			d.data_len, nvme_to_user_ptr(d.metadata),
 			d.metadata_len, 0, &meta, d.timeout_ms ?
@@ -456,6 +467,17 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	req->end_io = nvme_uring_cmd_end_io;
 	req->end_io_data = ioucmd;
 
+	if (issue_flags & IO_URING_F_IOPOLL && rq_flags & REQ_POLLED) {
+		if (unlikely(!req->bio)) {
+			/* we can't poll this, so alloc regular req instead */
+			blk_mq_free_request(req);
+			rq_flags &= ~REQ_POLLED;
+			goto retry;
+		} else {
+			WRITE_ONCE(ioucmd->cookie, req->bio);
+			req->bio->bi_opf |= REQ_POLLED;
+		}
+	}
 	/* to free bio on completion, as req->bio will be null at that time */
 	pdu->bio = req->bio;
 	pdu->meta = meta;
@@ -559,9 +581,6 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 static int nvme_uring_cmd_checks(unsigned int issue_flags)
 {
-	/* IOPOLL not supported yet */
-	if (issue_flags & IO_URING_F_IOPOLL)
-		return -EOPNOTSUPP;
 
 	/* NVMe passthrough requires big SQE/CQE support */
 	if ((issue_flags & (IO_URING_F_SQE128|IO_URING_F_CQE32)) !=
@@ -604,6 +623,23 @@ int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
 	return nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
 }
 
+int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
+{
+	struct bio *bio;
+	int ret = 0;
+	struct nvme_ns *ns;
+	struct request_queue *q;
+
+	rcu_read_lock();
+	bio = READ_ONCE(ioucmd->cookie);
+	ns = container_of(file_inode(ioucmd->file)->i_cdev,
+			struct nvme_ns, cdev);
+	q = ns->queue;
+	if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
+		ret = bio_poll(bio, NULL, 0);
+	rcu_read_unlock();
+	return ret;
+}
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -685,6 +721,29 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
+
+int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	struct bio *bio;
+	int ret = 0;
+	struct request_queue *q;
+
+	if (ns) {
+		rcu_read_lock();
+		bio = READ_ONCE(ioucmd->cookie);
+		q = ns->queue;
+		if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio
+				&& bio->bi_bdev)
+			ret = bio_poll(bio, NULL, 0);
+		rcu_read_unlock();
+	}
+	srcu_read_unlock(&head->srcu, srcu_idx);
+	return ret;
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
@@ -692,6 +751,10 @@ int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
 	struct nvme_ctrl *ctrl = ioucmd->file->private_data;
 	int ret;
 
+	/* IOPOLL not supported yet */
+	if (issue_flags & IO_URING_F_IOPOLL)
+		return -EOPNOTSUPP;
+
 	ret = nvme_uring_cmd_checks(issue_flags);
 	if (ret)
 		return ret;
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 6ef497c75a16..00f2f81e20fa 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -439,6 +439,7 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.uring_cmd	= nvme_ns_head_chr_uring_cmd,
+	.uring_cmd_iopoll = nvme_ns_head_chr_uring_cmd_iopoll,
 };
 
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 1bdf714dcd9e..fdcbc93dea21 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -821,6 +821,8 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
+int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd);
+int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd);
 int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
 int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
-- 
2.25.1

