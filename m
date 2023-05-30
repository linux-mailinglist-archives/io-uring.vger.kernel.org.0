Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80FB716B61
	for <lists+io-uring@lfdr.de>; Tue, 30 May 2023 19:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjE3Rmf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 May 2023 13:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjE3Rmd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 May 2023 13:42:33 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BADB2
        for <io-uring@vger.kernel.org>; Tue, 30 May 2023 10:42:31 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UGZjvp011482
        for <io-uring@vger.kernel.org>; Tue, 30 May 2023 10:24:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=7ApPjhbD0YCmJA9+SszNafaDNZtkZLNh6kXcyxMsgIs=;
 b=cNJEJ9sESzq+U8rY7Xkot+YAY9g061OqLEzBmI7MsEqRL5fnHWuV2Ns+JzeyRrvuM8Gn
 HEwIsjc0w9HNjs+zo2XLee0Bc2kZPfg7uFLXW08IXvsn6xoFRkQcPfG9mxs1ltDccav/
 t9vhDn+13RBoq9pMWQAIaewwQ6usmdH9brtnggvxaG/5193BaQVr6fFv72OdHYZViLq2
 t6qJDXf7VoZlwcRmJMH9gPcLO9cFPWAGHnOj9F5QQnX7OCLqPAFgeBzbfH0Ps/0Gqz2E
 p8o4sxlIeQXE2zDYw1+NfqCg6uwZc0wTe23tzMUANhNK+F016xY9Wy554beJzvCFkBiA Zw== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qw7mjcm8a-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 May 2023 10:24:20 -0700
Received: from twshared25760.37.frc1.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 10:24:00 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id B7A40194BF687; Tue, 30 May 2023 10:23:48 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <hch@lst.de>, <axboe@kernel.dk>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/2] nvme: improved uring polling
Date:   Tue, 30 May 2023 10:23:43 -0700
Message-ID: <20230530172343.3250958-2-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230530172343.3250958-1-kbusch@meta.com>
References: <20230530172343.3250958-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: aHcFJ-jkWDG-YPqMSDEyhtduwb061nD3
X-Proofpoint-GUID: aHcFJ-jkWDG-YPqMSDEyhtduwb061nD3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_12,2023-05-30_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Drivers can poll requests directly, so use that. We just need to ensure
the driver's request was allocated from a polled hctx, so a special
driver flag is added to struct io_uring_cmd.

The first advantage is unshared and multipath namespaces can use the same
polling callback, and multipath is guaranteed to get the same queue as
the command was submitted on. Previously multipath polling might check
a different path and poll the wrong info.

The other advantage is we don't need a bio payload in order to poll,
allowing commands like 'flush' and 'write zeroes' to be submitted on
the same high priority queue as read and write commands. And using the
request based polling skips the unnecessary bio overhead and xarray hctx
lookup when we have a request.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/ioctl.c     | 68 +++++++++--------------------------
 drivers/nvme/host/multipath.c |  2 +-
 drivers/nvme/host/nvme.h      |  2 --
 include/uapi/linux/io_uring.h |  2 ++
 4 files changed, 20 insertions(+), 54 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d24ea2e051564..3fa9a50433f18 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -505,7 +505,6 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struc=
t request *req,
 {
 	struct io_uring_cmd *ioucmd =3D req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
-	void *cookie =3D READ_ONCE(ioucmd->cookie);
=20
 	req->bio =3D pdu->bio;
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
@@ -518,9 +517,10 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(stru=
ct request *req,
 	 * For iopoll, complete it directly.
 	 * Otherwise, move the completion to task work.
 	 */
-	if (cookie !=3D NULL && blk_rq_is_poll(req))
+	if (blk_rq_is_poll(req)) {
+		WRITE_ONCE(ioucmd->cookie, NULL);
 		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
-	else
+	} else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
=20
 	return RQ_END_IO_FREE;
@@ -531,7 +531,6 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(=
struct request *req,
 {
 	struct io_uring_cmd *ioucmd =3D req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
-	void *cookie =3D READ_ONCE(ioucmd->cookie);
=20
 	req->bio =3D pdu->bio;
 	pdu->req =3D req;
@@ -540,9 +539,10 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io_meta=
(struct request *req,
 	 * For iopoll, complete it directly.
 	 * Otherwise, move the completion to task work.
 	 */
-	if (cookie !=3D NULL && blk_rq_is_poll(req))
+	if (blk_rq_is_poll(req)) {
+		WRITE_ONCE(ioucmd->cookie, NULL);
 		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
-	else
+	} else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_meta_cb);
=20
 	return RQ_END_IO_NONE;
@@ -599,7 +599,6 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
struct nvme_ns *ns,
 	if (issue_flags & IO_URING_F_IOPOLL)
 		rq_flags |=3D REQ_POLLED;
=20
-retry:
 	req =3D nvme_alloc_user_request(q, &c, rq_flags, blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -613,17 +612,11 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl=
, struct nvme_ns *ns,
 			return ret;
 	}
=20
-	if (issue_flags & IO_URING_F_IOPOLL && rq_flags & REQ_POLLED) {
-		if (unlikely(!req->bio)) {
-			/* we can't poll this, so alloc regular req instead */
-			blk_mq_free_request(req);
-			rq_flags &=3D ~REQ_POLLED;
-			goto retry;
-		} else {
-			WRITE_ONCE(ioucmd->cookie, req->bio);
-			req->bio->bi_opf |=3D REQ_POLLED;
-		}
+	if (blk_rq_is_poll(req)) {
+		ioucmd->flags |=3D IORING_URING_CMD_POLLED;
+		WRITE_ONCE(ioucmd->cookie, req);
 	}
+
 	/* to free bio on completion, as req->bio will be null at that time */
 	pdu->bio =3D req->bio;
 	pdu->meta_len =3D d.metadata_len;
@@ -782,18 +775,16 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cm=
d *ioucmd,
 				 struct io_comp_batch *iob,
 				 unsigned int poll_flags)
 {
-	struct bio *bio;
+	struct request *req;
 	int ret =3D 0;
-	struct nvme_ns *ns;
-	struct request_queue *q;
+
+	if (!(ioucmd->flags & IORING_URING_CMD_POLLED))
+		return 0;
=20
 	rcu_read_lock();
-	bio =3D READ_ONCE(ioucmd->cookie);
-	ns =3D container_of(file_inode(ioucmd->file)->i_cdev,
-			struct nvme_ns, cdev);
-	q =3D ns->queue;
-	if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
-		ret =3D bio_poll(bio, iob, poll_flags);
+	req =3D READ_ONCE(ioucmd->cookie);
+	if (req && blk_rq_is_poll(req))
+		ret =3D blk_rq_poll(req, iob, poll_flags);
 	rcu_read_unlock();
 	return ret;
 }
@@ -885,31 +876,6 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *=
ioucmd,
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
-
-int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
-				      struct io_comp_batch *iob,
-				      unsigned int poll_flags)
-{
-	struct cdev *cdev =3D file_inode(ioucmd->file)->i_cdev;
-	struct nvme_ns_head *head =3D container_of(cdev, struct nvme_ns_head, c=
dev);
-	int srcu_idx =3D srcu_read_lock(&head->srcu);
-	struct nvme_ns *ns =3D nvme_find_path(head);
-	struct bio *bio;
-	int ret =3D 0;
-	struct request_queue *q;
-
-	if (ns) {
-		rcu_read_lock();
-		bio =3D READ_ONCE(ioucmd->cookie);
-		q =3D ns->queue;
-		if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio
-				&& bio->bi_bdev)
-			ret =3D bio_poll(bio, iob, poll_flags);
-		rcu_read_unlock();
-	}
-	srcu_read_unlock(&head->srcu, srcu_idx);
-	return ret;
-}
 #endif /* CONFIG_NVME_MULTIPATH */
=20
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_f=
lags)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.=
c
index 9171452e2f6d4..f17be1c72f4de 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -470,7 +470,7 @@ static const struct file_operations nvme_ns_head_chr_=
fops =3D {
 	.unlocked_ioctl	=3D nvme_ns_head_chr_ioctl,
 	.compat_ioctl	=3D compat_ptr_ioctl,
 	.uring_cmd	=3D nvme_ns_head_chr_uring_cmd,
-	.uring_cmd_iopoll =3D nvme_ns_head_chr_uring_cmd_iopoll,
+	.uring_cmd_iopoll =3D nvme_ns_chr_uring_cmd_iopoll,
 };
=20
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index bf46f122e9e1e..ca4ea89333660 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -847,8 +847,6 @@ long nvme_dev_ioctl(struct file *file, unsigned int c=
md,
 		unsigned long arg);
 int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
 		struct io_comp_batch *iob, unsigned int poll_flags);
-int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
-		struct io_comp_batch *iob, unsigned int poll_flags);
 int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
 int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 0716cb17e4360..f8d6ffe78073e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -232,8 +232,10 @@ enum io_uring_op {
  * sqe->uring_cmd_flags
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
+ * IORING_URING_CMD_POLLED	driver use only
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
+#define IORING_URING_CMD_POLLED	(1U << 31)
=20
=20
 /*
--=20
2.34.1

