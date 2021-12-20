Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D547B8BD
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhLUC5U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:57:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47417 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbhLUC5U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:57:20 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211221025718epoutp0348a0ca5dff405fc0ea0daf2ab008cb6b~CpbtioIQd3025730257epoutp03A
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:57:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211221025718epoutp0348a0ca5dff405fc0ea0daf2ab008cb6b~CpbtioIQd3025730257epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055438;
        bh=iaD7YXlIXUvfbDK5g8qCuc/nFndLZ6rb6BPryMOSuAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxS1Qa6tLleObWW6dvFlFbxk+fANwcDk4suicD8uKkXqXiBZk8ahYL4Kd1pOyw4Sm
         VgkD3TtBdWC4oiTfrcZUSbKdjAMIrezb0Ot6QLdMTHZIlpmlu0tx86tyA017O98AVP
         hpXC59zCTqABeobrsGioElC1Vh7807+tTU/3B50A=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20211221025718epcas5p2137b561b71e9c09be0487c3788d26ba7~CpbtDdnMO1195011950epcas5p2b;
        Tue, 21 Dec 2021 02:57:18 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4JJ1MT2xR1z4x9Q3; Tue, 21 Dec
        2021 02:57:09 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.86.06423.58241C16; Tue, 21 Dec 2021 11:57:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20211220142256epcas5p49e0804ff8b075e8063259f94ccc9ced0~CfJEBW6Wz0645306453epcas5p47;
        Mon, 20 Dec 2021 14:22:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142256epsmtrp1e0dc23ef6074dbf3b6e113f618108991~CfJEAn5082445924459epsmtrp1n;
        Mon, 20 Dec 2021 14:22:56 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-f4-61c142850431
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.85.29871.0C190C16; Mon, 20 Dec 2021 23:22:56 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142252epsmtip13724171da317beeb7bbdc9819b527bf6~CfJAGtPet0040400404epsmtip1k;
        Mon, 20 Dec 2021 14:22:52 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 13/13] nvme: Add async passthru polling support
Date:   Mon, 20 Dec 2021 19:47:34 +0530
Message-Id: <20211220141734.12206-14-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmum6r08FEg7f/+S2aJvxltlh9t5/N
        YuXqo0wW71rPsVh0nr7AZHH+7WEmi0mHrjFa7L2lbTF/2VN2izU3n7I4cHnsnHWX3aN5wR0W
        j8tnSz02repk89i8pN5j980GNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnXF5c03B5fCKS4vfMTUwLnHvYuTkkBAw
        kXh55gdTFyMXh5DAbkaJH+emsEA4nxglLuy8yQJSJSTwjVHi7Zs6mI6Hu66wQxTtZZTo+/ES
        qv0zo8T2ztusXYwcHGwCmhIXJpeCNIgIREtceH6NDcRmFuhglNjZbQtiCwvYSsybP5cJxGYR
        UJX4fGwLI4jNK2ApcbfhNyvEMnmJmZe+s4PYnEDxw7OXsUHUCEqcnPmEBWKmvETz1tnMIDdI
        CEzlkHi1+gYLyA0SAi4Spx7oQcwRlnh1fAs7hC0l8bK/Dcoulvh15yhUL9Bt1xtmskAk7CUu
        7vnLBDKHGeiX9bv0IcKyElNPrWOC2Msn0fv7CRNEnFdixzwYW1Hi3qSnUPeLSzycsQTK9pA4
        t7UVGro9jBKXb3czT2BUmIXkn1lI/pmFsHoBI/MqRsnUguLc9NRi0wLDvNRyeBwn5+duYgSn
        WS3PHYx3H3zQO8TIxMF4iFGCg1lJhHfL7P2JQrwpiZVVqUX58UWlOanFhxhNgQE+kVlKNDkf
        mOjzSuINTSwNTMzMzEwsjc0MlcR5T6dvSBQSSE8sSc1OTS1ILYLpY+LglGpg4staY9Hcztt3
        bkF2Zmv46eOS4jq/n30TKFE6K5iy+ncw5+3pG1p6ft88vSJr4wTf2k2qf8z2Gjz96vffXKV3
        LatJAf+hhxnHNdi1HS/PtYvae0zx2uHrbzoi1lv3SvU2JnnavZy5uUeYfV+hhW5g8f2d/ooX
        qjNdvfTk3//u4Eu72cXiXt8ZZJ3mE3V9afTcoM0ZvD6P53w7E6CVUpBhpHAuja1VZrPUhq69
        7yZG810tnsi0Pasxzu7T+19psWk//bjumZRfWXg3eXG41uTZ206Jn5slc+596LrwKwkrGd/8
        4A2SO/Sz6J3vRssZS30rb9+6avGm4Hxf+tJasw7FT59mn2i2SjB9ZHH5HsdvJZbijERDLeai
        4kQAvuxsGTwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnO6BiQcSDXYckbBomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr4/LmmoLL4RWX
        Fr9jamBc4t7FyMkhIWAi8XDXFfYuRi4OIYHdjBJ7LkxlhkiISzRf+8EOYQtLrPz3HKroI6PE
        jM/vGbsYOTjYBDQlLkwuBakREYiV+PDrGBNIDbPAJEaJDf0PwJqFBWwl5s2fywRiswioSnw+
        toURxOYVsJS42/CbFWKBvMTMS9/B6jmB4odnL2MDsYUELCROfPjCAlEvKHFy5hMwmxmovnnr
        bOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHAtamjsYt6/6
        oHeIkYmD8RCjBAezkgjvltn7E4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5Ykpqd
        mlqQWgSTZeLglGpgijp7/vuH4x2izj0ztV6bnProIrRv/9fT95ZfYojwP/fV+2/+10zDys1L
        elfECb7Y8S4p+QXjGsHl+aoLzl1j+ZfHw3qrul7IPsh5+YnTa5+J37qWyHi8I2ux0q+W3U8D
        nHZPuFmru8LAuy1Qc7eA7sRvcYfLjkZOu+h4Mmdr/QyLdedX6N5tYI7y8szOLVbMl8iKfqyz
        bP5U2aUzStXXf55y78kW330HVp6Um9lWoer1Xrb0+qqd0hYH1P5ce7N4Ssbic+ejYoxcrRJn
        Zdox/rRZ/nX3Aj5Vtr68pKZku4OLH2+K3rDd6Ej1a8f2VeHsh22F981NWe94OjNsBde/1XcC
        GNuTY5P+cz99Wv6P44wSS3FGoqEWc1FxIgBDf7Ek9AIAAA==
X-CMS-MailID: 20211220142256epcas5p49e0804ff8b075e8063259f94ccc9ced0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142256epcas5p49e0804ff8b075e8063259f94ccc9ced0
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142256epcas5p49e0804ff8b075e8063259f94ccc9ced0@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pankaj Raghav <p.raghav@samsung.com>

IO_URING already has polling support for read and write. This patch
extends that support for uring cmd passthu. The unused flag in
uring_cmd struct is used to indicate if the completion should be polled.
If device side polling is not enabled, then the submission request will
fallback to a non-polled request.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-mq.c                |  3 +-
 drivers/nvme/host/core.c      |  1 +
 drivers/nvme/host/ioctl.c     | 79 ++++++++++++++++++++++++++++++++++-
 drivers/nvme/host/multipath.c |  1 +
 drivers/nvme/host/nvme.h      |  4 ++
 fs/io_uring.c                 | 45 ++++++++++++++++++--
 include/linux/blk-mq.h        |  1 +
 include/linux/io_uring.h      | 10 ++++-
 8 files changed, 135 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c77991688bfd..acfa55c96a43 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1193,7 +1193,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head, rq_end_io_fn *done)
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
 
-static bool blk_rq_is_poll(struct request *rq)
+bool blk_rq_is_poll(struct request *rq)
 {
 	if (!rq->mq_hctx)
 		return false;
@@ -1203,6 +1203,7 @@ static bool blk_rq_is_poll(struct request *rq)
 		return false;
 	return true;
 }
+EXPORT_SYMBOL_GPL(blk_rq_is_poll);
 
 static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
 {
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5199adf7ae92..f0697cbe2bf1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3676,6 +3676,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.unlocked_ioctl	= nvme_ns_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.async_cmd	= nvme_ns_chr_async_cmd,
+	.iopoll		= nvme_iopoll,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index bdaf8f317aa8..ce2fe94df3ad 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -31,6 +31,12 @@ struct nvme_uring_cmd {
 	void __user *meta_buffer;
 };
 
+static inline bool is_polling_enabled(struct io_uring_cmd *ioucmd,
+				      struct request *req)
+{
+	return (ioucmd->flags & URING_CMD_POLLED) && blk_rq_is_poll(req);
+}
+
 static struct nvme_uring_cmd *nvme_uring_cmd(struct io_uring_cmd *ioucmd)
 {
 	return (struct nvme_uring_cmd *)&ioucmd->pdu;
@@ -76,8 +82,16 @@ static void nvme_end_async_pt(struct request *req, blk_status_t err)
 
 	cmd->req = req;
 	req->bio = bio;
-	/* this takes care of setting up task-work */
-	io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
+
+	/*IO can be completed immediately when the callback
+	 * is in the same task context
+	 */
+	if (is_polling_enabled(ioucmd, req)) {
+		nvme_pt_task_cb(ioucmd);
+	} else {
+		/* this takes care of setting up task-work */
+		io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
+	}
 }
 
 static void nvme_setup_uring_cmd_data(struct request *rq,
@@ -183,6 +197,12 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		}
 	}
 	if (ioucmd) { /* async dispatch */
+
+		if (bio && is_polling_enabled(ioucmd, req)) {
+			ioucmd->bio = bio;
+			bio->bi_opf |= REQ_POLLED;
+		}
+
 		nvme_setup_uring_cmd_data(req, ioucmd, meta, meta_buffer,
 				meta_len, write);
 		blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
@@ -496,6 +516,32 @@ int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd,
 	return nvme_ns_async_ioctl(ns, ioucmd);
 }
 
+int nvme_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
+		unsigned int flags)
+{
+	struct bio *bio = NULL;
+	struct nvme_ns *ns = NULL;
+	struct request_queue *q = NULL;
+	int ret = 0;
+
+	rcu_read_lock();
+	bio = READ_ONCE(kiocb->private);
+	ns = container_of(file_inode(kiocb->ki_filp)->i_cdev, struct nvme_ns,
+			  cdev);
+	q = ns->queue;
+
+	/* bio and driver_cb are a part of the same union type in io_uring_cmd
+	 * struct. When there are no poll queues, driver_cb is used for IRQ cb
+	 * but polling is performed from the io_uring side. To avoid unnecessary
+	 * polling, a check is added to see if it is a polled queue and return 0
+	 * if it is not.
+	 */
+	if ((test_bit(QUEUE_FLAG_POLL, &q->queue_flags)) && bio && bio->bi_bdev)
+		ret = bio_poll(bio, iob, flags);
+	rcu_read_unlock();
+	return ret;
+}
+
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
@@ -577,6 +623,35 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
+
+int nvme_ns_head_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
+			unsigned int flags)
+{
+	struct bio *bio = NULL;
+	struct request_queue *q = NULL;
+	struct cdev *cdev = file_inode(kiocb->ki_filp)->i_cdev;
+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
+	int srcu_idx = srcu_read_lock(&head->srcu);
+	struct nvme_ns *ns = nvme_find_path(head);
+	int ret = -EWOULDBLOCK;
+
+	if (ns) {
+		bio = READ_ONCE(kiocb->private);
+		q = ns->queue;
+	    /* bio and driver_cb are a part of the same union type in io_uring_cmd
+	     * struct. When there are no poll queues, driver_cb is used for IRQ cb
+	     * but polling is performed from the io_uring side. To avoid unnecessary
+	     * polling, a check is added to see if it is a polled queue and return 0
+	     * if it is not.
+	     */
+		if ((test_bit(QUEUE_FLAG_POLL, &q->queue_flags)) && bio &&
+		    bio->bi_bdev)
+			ret = bio_poll(bio, iob, flags);
+	}
+
+	srcu_read_unlock(&head->srcu, srcu_idx);
+	return ret;
+}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 static int nvme_dev_user_cmd(struct nvme_ctrl *ctrl, void __user *argp)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 1e59c8e06622..df91b2953932 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -424,6 +424,7 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.async_cmd	= nvme_ns_head_chr_async_cmd,
+	.iopoll		= nvme_ns_head_iopoll,
 };
 
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 56a7cc8421fc..730ada8a3e8e 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -752,8 +752,12 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 int nvme_ns_chr_async_cmd(struct io_uring_cmd *ucmd,
 		enum io_uring_cmd_flags flags);
+int nvme_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
+		unsigned int flags);
 int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ucmd,
 		enum io_uring_cmd_flags flags);
+int nvme_ns_head_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
+			unsigned int flags);
 int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 extern const struct attribute_group *nvme_ns_id_attr_groups[];
diff --git a/fs/io_uring.c b/fs/io_uring.c
index f77dde1bdc75..ae2e7666622e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2655,7 +2655,20 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
-		ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob, poll_flags);
+		if (req->opcode == IORING_OP_URING_CMD ||
+		    req->opcode == IORING_OP_URING_CMD_FIXED) {
+			/* uring_cmd structure does not contain kiocb struct */
+			struct kiocb kiocb_uring_cmd;
+
+			kiocb_uring_cmd.private = req->uring_cmd.bio;
+			kiocb_uring_cmd.ki_filp = req->uring_cmd.file;
+			ret = req->uring_cmd.file->f_op->iopoll(&kiocb_uring_cmd,
+			      &iob, poll_flags);
+		} else {
+			ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob,
+							   poll_flags);
+		}
+
 		if (unlikely(ret < 0))
 			return ret;
 		else if (ret)
@@ -2768,6 +2781,15 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    wq_list_empty(&ctx->iopoll_list))
 				break;
 		}
+
+		/*
+		 * In some scenarios, completion callback has been queued up to be
+		 * completed in-task context but polling happens in the same task
+		 * not giving a chance for the completion callback to complete.
+		 */
+		if (current->task_works)
+			io_run_task_work();
+
 		ret = io_do_iopoll(ctx, !min);
 		if (ret < 0)
 			break;
@@ -4122,6 +4144,14 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static void io_complete_uring_cmd_iopoll(struct io_kiocb *req, long res)
+{
+	WRITE_ONCE(req->result, res);
+	/* order with io_iopoll_complete() checking ->result */
+	smp_wmb();
+	WRITE_ONCE(req->iopoll_completed, 1);
+}
+
 /*
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
@@ -4132,7 +4162,11 @@ void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
 
 	if (ret < 0)
 		req_set_fail(req);
-	io_req_complete(req, ret);
+
+	if (req->uring_cmd.flags & URING_CMD_POLLED)
+		io_complete_uring_cmd_iopoll(req, ret);
+	else
+		io_req_complete(req, ret);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
@@ -4147,8 +4181,11 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 		return -EOPNOTSUPP;
 
 	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
-		printk_once(KERN_WARNING "io_uring: iopoll not supported!\n");
-		return -EOPNOTSUPP;
+		req->uring_cmd.flags = URING_CMD_POLLED;
+		req->uring_cmd.bio = NULL;
+		req->iopoll_completed = 0;
+	} else {
+		req->uring_cmd.flags = 0;
 	}
 
 	cmd->op = READ_ONCE(csqe->op);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index e35a5d835b1f..2233ccf41c19 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -933,6 +933,7 @@ int blk_rq_map_kern(struct request_queue *, struct request *, void *,
 int blk_rq_append_bio(struct request *rq, struct bio *bio);
 void blk_execute_rq_nowait(struct request *rq, bool at_head,
 		rq_end_io_fn *end_io);
+bool blk_rq_is_poll(struct request *rq);
 blk_status_t blk_execute_rq(struct request *rq, bool at_head);
 
 struct req_iterator {
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 07732bc850af..bbc9c4ea19c3 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -6,6 +6,7 @@
 #include <linux/xarray.h>
 
 enum {
+	URING_CMD_POLLED = (1 << 0),
 	URING_CMD_FIXEDBUFS = (1 << 1),
 };
 /*
@@ -17,8 +18,13 @@ struct io_uring_cmd {
 	__u16		op;
 	__u16		flags;
 	__u32		len;
-	/* used if driver requires update in task context*/
-	void (*driver_cb)(struct io_uring_cmd *cmd);
+	union {
+		void *bio; // Used for polling based completion
+
+		/* used if driver requires update in task context for IRQ based completion*/
+		void (*driver_cb)(struct io_uring_cmd *cmd);
+	};
+
 	__u64		pdu[5];	/* 40 bytes available inline for free use */
 };
 
-- 
2.25.1

