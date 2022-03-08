Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E26D4D1C1B
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347933AbiCHPoP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240566AbiCHPoO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:44:14 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6E935DEC
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:43:17 -0800 (PST)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220308154315epoutp02d151865f3198aea9d8e04c480a18f48b~acjdfEKnv2790227902epoutp02W
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:43:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220308154315epoutp02d151865f3198aea9d8e04c480a18f48b~acjdfEKnv2790227902epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754195;
        bh=bAliuuQyhVaAA810mSYAZQpiymJdGdlUpCRULteop00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBvCGODlFm2X1HTgcUvSA5rQCjOSehbcgfhMICfRSnUm4V+iNMLRGe686gc0cdtbh
         v+cT3gZQZT0XnY7/n9uYnVBstC2ao+qsSbdB/Awj0C6qi8EeDbgerjGgOd70T/SAts
         Znvfea8KCr0P9VfOR1f4uI5ErUqExr5FS4f4BJQw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220308154314epcas5p154fd80284aae81f189328339708d8b3a~acjcftWYL2331223312epcas5p1j;
        Tue,  8 Mar 2022 15:43:14 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KCfjq6RmMz4x9Ps; Tue,  8 Mar
        2022 15:43:11 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.BB.05590.F8977226; Wed,  9 Mar 2022 00:43:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220308152725epcas5p36d1ce3269a47c1c22cc0d66bdc2b9eb3~acVoStPq60962409624epcas5p3H;
        Tue,  8 Mar 2022 15:27:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220308152725epsmtrp19bf628287ac3275a95536afe6a11f50e~acVoRyAOv0125001250epsmtrp1h;
        Tue,  8 Mar 2022 15:27:25 +0000 (GMT)
X-AuditID: b6c32a4b-739ff700000015d6-7a-6227798f409f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.51.29871.DD577226; Wed,  9 Mar 2022 00:27:25 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152723epsmtip1c7c06b9e44ad86e6b6710274bccc3639~acVmQMLQy0990109901epsmtip1h;
        Tue,  8 Mar 2022 15:27:23 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 15/17] nvme: wire-up polling for uring-passthru
Date:   Tue,  8 Mar 2022 20:51:03 +0530
Message-Id: <20220308152105.309618-16-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmlm5/pXqSQdcRfYvphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
        5OIToOuWmQP0g5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10v
        L7XEytDAwMgUqDAhO+PJr37Ggkk2FaeaFrE1MF437GLk5JAQMJHYfHobUxcjF4eQwG5GiYVz
        1rCAJIQEPjFKTN/tD5H4xiix6ekzFpiOOzf/MEMU7WWU+PcjH6LoM6NE75JrjF2MHBxsApoS
        FyaXgtSICHhJ3L/9nhWkhlmgi0ni7b77bCAJYQF7iV9NN5hAbBYBVYnGJbvA4rwCVhJbutay
        QSyTl5h56Ts7iM0JFP95aysrRI2gxMmZT8AOYgaqad46mxlkgYTAEQ6JbX/mQF3qInH/xWJW
        CFtY4tXxLewQtpTEy/42KLtY4tedo1DNHYwS1xtmQjXbS1zc85cJ5BtmoG/W79KHCMtKTD21
        jgliMZ9E7+8nTBBxXokd82BsRYl7k55C7RWXeDhjCZTtIfHjwns2SGj1Mkp82bGSfQKjwiwk
        D81C8tAshNULGJlXMUqmFhTnpqcWmxYY56WWw2M5OT93EyM4XWt572B89OCD3iFGJg7GQ4wS
        HMxKIrz3z6skCfGmJFZWpRblxxeV5qQWH2I0BYb4RGYp0eR8YMbIK4k3NLE0MDEzMzOxNDYz
        VBLnPZW+IVFIID2xJDU7NbUgtQimj4mDU6qBaX/Mtf/vYgsCjOamydjPUt7IET45Pu7Sjvn5
        l7smXLBes2PK/BP8l3Y2yMW8/V9g5Tfpcd2/XV/8V6lUTrB2PLqq7uDGtjzGSQGRk8MWzLnU
        whqkN4tl3+IHi/gE7Xee+ev+6oGF2MUbM+54fAm5FrlE0ujtb44VvDZ13Dr7RU+9fNtf9lwn
        94qc+NL1E05/0WETT9ItZpnnMnPC6vkZOxnuf3Hp3n1X4OQcKzNlzj02K9lbWt8c1Tvn0Ca0
        sHRv498rU77vm6KZUuI066uzb968T1ZzzhzYwf58j+nLluUX9xfZb4udvtN/b7fYP7lHlwxm
        Lwqddu3B4dI/or12u0pCM9a/e6xfXz5nhhhPzoNoJZbijERDLeai4kQAT0wRymAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJTvduqXqSwd3tIhbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr48mvfsaCSTYVp5oWsTUwXjfsYuTkkBAwkbhz
        8w9zFyMXh5DAbkaJBftesUAkxCWar/1gh7CFJVb+e84OUfSRUWL52bOMXYwcHGwCmhIXJpeC
        1IgIBEgcbLwMVsMsMINJoqf5M9ggYQF7iV9NN5hAbBYBVYnGJbvYQGxeASuJLV1r2SAWyEvM
        vPQdbBknUPznra2sILaQgKXEinW/oeoFJU7OfAI2kxmovnnrbOYJjAKzkKRmIUktYGRaxSiZ
        WlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHFFamjsYt6/6oHeIkYmD8RCjBAezkgjv/fMq
        SUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwpfEU+jLs
        E637dmnOIfWPPjsnrJz1IWjeq/X/3vw+IMZ48HP2v/LeDSIX6l42zdkksuIgq7mW7VODuQY7
        /EWWJ7QIf+D497D8fk77TCkz2ck/JhcF3al8X1/NtHjfdTs1h51Kyb4HZ/EkFN8+Jb5xTTTP
        0h36DWsupMzOvefud7FmH8cPEXkHedbkf5OXTqtYcfpTlloEc5aH5PWOJ6mdGQ3zNItEQnLX
        3c61PbVhVXwF65tICWe/n1bspUse2+ZMvXxex0SmYR7rdeF3Kv+XJvLHXnti+uzFr/VG0aGL
        OKwmuM33KDxZ4cjx9aN5pkBYfWzYFKuHwhXWx9ceTtm3bcW8gLNsVx4JfLu4JEFJQYmlOCPR
        UIu5qDgRAAG6OioXAwAA
X-CMS-MailID: 20220308152725epcas5p36d1ce3269a47c1c22cc0d66bdc2b9eb3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152725epcas5p36d1ce3269a47c1c22cc0d66bdc2b9eb3
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152725epcas5p36d1ce3269a47c1c22cc0d66bdc2b9eb3@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pankaj Raghav <p.raghav@samsung.com>

add .iopoll handler for char device (/dev/ngX), which in turn redirects
to bio_poll to implement polling.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 block/blk-mq.c                |  3 +-
 drivers/nvme/host/core.c      |  1 +
 drivers/nvme/host/ioctl.c     | 79 ++++++++++++++++++++++++++++++++++-
 drivers/nvme/host/multipath.c |  1 +
 drivers/nvme/host/nvme.h      |  4 ++
 include/linux/blk-mq.h        |  1 +
 6 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 29f65eaf3e6b..6b37774b0d59 100644
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
index 4a385001f124..64254771a28e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3671,6 +3671,7 @@ static const struct file_operations nvme_ns_chr_fops = {
 	.unlocked_ioctl	= nvme_ns_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.async_cmd	= nvme_ns_chr_async_cmd,
+	.iopoll		= nvme_iopoll,
 };
 
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index a6712fb3eb98..701feaecabbe 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -37,6 +37,12 @@ static struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(struct io_uring_cmd *ioucmd
 	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
 }
 
+static inline bool is_polling_enabled(struct io_uring_cmd *ioucmd,
+				      struct request *req)
+{
+	return (ioucmd->flags & IO_URING_F_UCMD_POLLED) && blk_rq_is_poll(req);
+}
+
 static void nvme_pt_task_cb(struct io_uring_cmd *ioucmd)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
@@ -71,8 +77,17 @@ static void nvme_end_async_pt(struct request *req, blk_status_t err)
 
 	pdu->req = req;
 	req->bio = bio;
-	/* this takes care of setting up task-work */
-	io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
+
+	/*
+	 * IO can be completed directly (i.e. without task work) if we are
+	 * polling and in the task context already
+	 */
+	if (is_polling_enabled(ioucmd, req)) {
+		nvme_pt_task_cb(ioucmd);
+	} else {
+		/* this takes care of setting up task-work */
+		io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);
+	}
 }
 
 static void nvme_setup_uring_cmd_data(struct request *rq,
@@ -180,6 +195,10 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	if (ioucmd) { /* async dispatch */
 		if (cmd->common.opcode == nvme_cmd_write ||
 				cmd->common.opcode == nvme_cmd_read) {
+			if (bio && is_polling_enabled(ioucmd, req)) {
+				ioucmd->bio = bio;
+				bio->bi_opf |= REQ_POLLED;
+			}
 			nvme_setup_uring_cmd_data(req, ioucmd, meta, meta_buffer,
 					meta_len);
 			blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
@@ -505,6 +524,32 @@ int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd)
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
+	/*
+	 * bio and driver_cb are a part of the same union inside io_uring_cmd
+	 * struct. If driver is loaded without poll queues, completion will be
+	 * IRQ based and driver_cb is populated. We do not want to treat that
+	 * as bio and get into troubles. Avoid this by checking if queue is
+	 * polled and bail out if not.
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
@@ -585,6 +630,36 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
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
+		/*
+		 * bio and driver_cb are part of same union inside io_uring_cmd
+		 * struct. If driver is loaded without poll queues, completion
+		 * will be IRQ based and driver_cb is populated. We do not want
+		 * to treat that as bio and get into troubles. Avoid this by
+		 * checking if queue is polled, and bail out if not.
+		 */
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
index 1d798d09456f..27995358c847 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -460,6 +460,7 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 	.unlocked_ioctl	= nvme_ns_head_chr_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.async_cmd	= nvme_ns_head_chr_async_cmd,
+	.iopoll		= nvme_ns_head_iopoll,
 };
 
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9a3e5093dedc..0be437c25077 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -755,7 +755,11 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 int nvme_ns_chr_async_cmd(struct io_uring_cmd *ioucmd);
+int nvme_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
+		unsigned int flags);
 int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd);
+int nvme_ns_head_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
+			unsigned int flags);
 int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 extern const struct attribute_group *nvme_ns_id_attr_groups[];
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 5f21f71b2529..9f00b2a5a991 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -977,6 +977,7 @@ int blk_rq_map_kern(struct request_queue *, struct request *, void *,
 int blk_rq_append_bio(struct request *rq, struct bio *bio);
 void blk_execute_rq_nowait(struct request *rq, bool at_head,
 		rq_end_io_fn *end_io);
+bool blk_rq_is_poll(struct request *rq);
 blk_status_t blk_execute_rq(struct request *rq, bool at_head);
 
 struct req_iterator {
-- 
2.25.1

