Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E237CE121
	for <lists+io-uring@lfdr.de>; Wed, 18 Oct 2023 17:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjJRPYw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Oct 2023 11:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbjJRPYv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Oct 2023 11:24:51 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F5210F
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:24:48 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 39I84NIe015181
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:24:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=ic7A44rt4K/WcfaYrUmFA/FKaGJZgx0TCYOoC0ab5ks=;
 b=d/A6rj8Vsy4sJ0MT7KemWmd+/ewipJ59CpGgPa7Q0RWyQa4hlolzZkuwf5GzVNL6Ffsc
 FU7olrSfv7YIybZzH8crK1qqqKjt1+z4+89q4Ymyzj4RVkVMxURYD5Mu42dr7ukRQZwi
 YuRCC5RYMDZ+Koe2+TcmlrglktVqvIuVfJKpzfh74k30NUf67Znk82URS0WSStKZZfOS
 OPSUIUWTZLxRPk5eEtvd2haOXbZFLOfj41pityo04Fn2mc8Pv8ue4lU+LnUnsfU+H745
 nkQczAs645ohup1yNGXRGu84n247b3y8SpEIF872a/b4yK9ZaXz5dlk3wfrHAKw4BI2r kg== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3ttbhatctk-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 Oct 2023 08:24:47 -0700
Received: from twshared34392.14.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 18 Oct 2023 08:24:32 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 57D5C205F4408; Wed, 18 Oct 2023 08:24:21 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/4] nvme: use bio_integrity_map_user
Date:   Wed, 18 Oct 2023 08:18:41 -0700
Message-ID: <20231018151843.3542335-3-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231018151843.3542335-1-kbusch@meta.com>
References: <20231018151843.3542335-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: KWW97MCWd4zimF_hQUsZuqtHbQOGg3xh
X-Proofpoint-ORIG-GUID: KWW97MCWd4zimF_hQUsZuqtHbQOGg3xh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_13,2023-10-18_01,2023-05-22_02
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Map user metadata buffers directly instead of maintaining a complicated
copy buffer.

Now that the bio tracks the metadata through its bip, nvme doesn't need
special metadata handling, callbacks, or additional fields in the pdu.
This greatly simplifies passthrough handling and avoids a "might_fault"
copy_to_user in the completion path. This also creates pdu space to
track the original request separately from its bio, further simplifying
polling without relying on special iouring fields.

The downside is that nvme requires the metadata buffer be physically
contiguous, so user space will need to utilize huge pages if the buffer
needs to span multiple pages. In practice, metadata payload sizes are a
small fraction of the main payload, so this shouldn't be a problem.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/ioctl.c | 174 ++++++--------------------------------
 1 file changed, 27 insertions(+), 147 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d8ff796fd5f21..a4889536ca4c6 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -96,52 +96,17 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval=
)
 	return (void __user *)ptrval;
 }
=20
-static void *nvme_add_user_metadata(struct request *req, void __user *ub=
uf,
+static int nvme_add_user_metadata(struct request *req, void __user *ubuf=
,
 		unsigned len, u32 seed)
 {
-	struct bio_integrity_payload *bip;
-	int ret =3D -ENOMEM;
-	void *buf;
-	struct bio *bio =3D req->bio;
-
-	buf =3D kmalloc(len, GFP_KERNEL);
-	if (!buf)
-		goto out;
-
-	ret =3D -EFAULT;
-	if ((req_op(req) =3D=3D REQ_OP_DRV_OUT) && copy_from_user(buf, ubuf, le=
n))
-		goto out_free_meta;
-
-	bip =3D bio_integrity_alloc(bio, GFP_KERNEL, 1);
-	if (IS_ERR(bip)) {
-		ret =3D PTR_ERR(bip);
-		goto out_free_meta;
-	}
+	int ret;
=20
-	bip->bip_iter.bi_sector =3D seed;
-	ret =3D bio_integrity_add_page(bio, virt_to_page(buf), len,
-			offset_in_page(buf));
-	if (ret !=3D len) {
-		ret =3D -ENOMEM;
-		goto out_free_meta;
-	}
+	ret =3D bio_integrity_map_user(req->bio, ubuf, len, seed, 1);
+	if (ret)
+		return ret;
=20
 	req->cmd_flags |=3D REQ_INTEGRITY;
-	return buf;
-out_free_meta:
-	kfree(buf);
-out:
-	return ERR_PTR(ret);
-}
-
-static int nvme_finish_user_metadata(struct request *req, void __user *u=
buf,
-		void *meta, unsigned len, int ret)
-{
-	if (!ret && req_op(req) =3D=3D REQ_OP_DRV_IN &&
-	    copy_to_user(ubuf, meta, len))
-		ret =3D -EFAULT;
-	kfree(meta);
-	return ret;
+	return 0;
 }
=20
 static struct request *nvme_alloc_user_request(struct request_queue *q,
@@ -160,14 +125,12 @@ static struct request *nvme_alloc_user_request(stru=
ct request_queue *q,
=20
 static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, void **metap, struct io_uring_cmd *ioucmd,
-		unsigned int flags)
+		u32 meta_seed, struct io_uring_cmd *ioucmd, unsigned int flags)
 {
 	struct request_queue *q =3D req->q;
 	struct nvme_ns *ns =3D q->queuedata;
 	struct block_device *bdev =3D ns ? ns->disk->part0 : NULL;
 	struct bio *bio =3D NULL;
-	void *meta =3D NULL;
 	int ret;
=20
 	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
@@ -194,13 +157,10 @@ static int nvme_map_user_request(struct request *re=
q, u64 ubuffer,
 		bio_set_dev(bio, bdev);
=20
 	if (bdev && meta_buffer && meta_len) {
-		meta =3D nvme_add_user_metadata(req, meta_buffer, meta_len,
+		ret =3D nvme_add_user_metadata(req, meta_buffer, meta_len,
 				meta_seed);
-		if (IS_ERR(meta)) {
-			ret =3D PTR_ERR(meta);
+		if (ret)
 			goto out_unmap;
-		}
-		*metap =3D meta;
 	}
=20
 	return ret;
@@ -221,7 +181,6 @@ static int nvme_submit_user_cmd(struct request_queue =
*q,
 	struct nvme_ns *ns =3D q->queuedata;
 	struct nvme_ctrl *ctrl;
 	struct request *req;
-	void *meta =3D NULL;
 	struct bio *bio;
 	u32 effects;
 	int ret;
@@ -233,7 +192,7 @@ static int nvme_submit_user_cmd(struct request_queue =
*q,
 	req->timeout =3D timeout;
 	if (ubuffer && bufflen) {
 		ret =3D nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-				meta_len, meta_seed, &meta, NULL, flags);
+				meta_len, meta_seed, NULL, flags);
 		if (ret)
 			return ret;
 	}
@@ -245,9 +204,6 @@ static int nvme_submit_user_cmd(struct request_queue =
*q,
 	ret =3D nvme_execute_rq(req, false);
 	if (result)
 		*result =3D le64_to_cpu(nvme_req(req)->result.u64);
-	if (meta)
-		ret =3D nvme_finish_user_metadata(req, meta_buffer, meta,
-						meta_len, ret);
 	if (bio)
 		blk_rq_unmap_user(bio);
 	blk_mq_free_request(req);
@@ -442,19 +398,10 @@ struct nvme_uring_data {
  * Expect build errors if this grows larger than that.
  */
 struct nvme_uring_cmd_pdu {
-	union {
-		struct bio *bio;
-		struct request *req;
-	};
-	u32 meta_len;
-	u32 nvme_status;
-	union {
-		struct {
-			void *meta; /* kernel-resident buffer */
-			void __user *meta_buffer;
-		};
-		u64 result;
-	} u;
+	struct request *req;
+	struct bio *bio;
+	u64 result;
+	int status;
 };
=20
 static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
@@ -463,31 +410,6 @@ static inline struct nvme_uring_cmd_pdu *nvme_uring_=
cmd_pdu(
 	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
 }
=20
-static void nvme_uring_task_meta_cb(struct io_uring_cmd *ioucmd,
-				    unsigned issue_flags)
-{
-	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
-	struct request *req =3D pdu->req;
-	int status;
-	u64 result;
-
-	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
-		status =3D -EINTR;
-	else
-		status =3D nvme_req(req)->status;
-
-	result =3D le64_to_cpu(nvme_req(req)->result.u64);
-
-	if (pdu->meta_len)
-		status =3D nvme_finish_user_metadata(req, pdu->u.meta_buffer,
-					pdu->u.meta, pdu->meta_len, status);
-	if (req->bio)
-		blk_rq_unmap_user(req->bio);
-	blk_mq_free_request(req);
-
-	io_uring_cmd_done(ioucmd, status, result, issue_flags);
-}
-
 static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd,
 			       unsigned issue_flags)
 {
@@ -495,8 +417,7 @@ static void nvme_uring_task_cb(struct io_uring_cmd *i=
oucmd,
=20
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
-
-	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result, issue_flags)=
;
+	io_uring_cmd_done(ioucmd, pdu->status, pdu->result, issue_flags);
 }
=20
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
@@ -505,50 +426,24 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(str=
uct request *req,
 	struct io_uring_cmd *ioucmd =3D req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
=20
-	req->bio =3D pdu->bio;
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
-		pdu->nvme_status =3D -EINTR;
+		pdu->status =3D -EINTR;
 	else
-		pdu->nvme_status =3D nvme_req(req)->status;
-	pdu->u.result =3D le64_to_cpu(nvme_req(req)->result.u64);
+		pdu->status =3D nvme_req(req)->status;
+	pdu->result =3D le64_to_cpu(nvme_req(req)->result.u64);
=20
 	/*
 	 * For iopoll, complete it directly.
 	 * Otherwise, move the completion to task work.
 	 */
-	if (blk_rq_is_poll(req)) {
-		WRITE_ONCE(ioucmd->cookie, NULL);
+	if (blk_rq_is_poll(req))
 		nvme_uring_task_cb(ioucmd, IO_URING_F_UNLOCKED);
-	} else {
+	else
 		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
-	}
=20
 	return RQ_END_IO_FREE;
 }
=20
-static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req=
,
-						     blk_status_t err)
-{
-	struct io_uring_cmd *ioucmd =3D req->end_io_data;
-	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
-
-	req->bio =3D pdu->bio;
-	pdu->req =3D req;
-
-	/*
-	 * For iopoll, complete it directly.
-	 * Otherwise, move the completion to task work.
-	 */
-	if (blk_rq_is_poll(req)) {
-		WRITE_ONCE(ioucmd->cookie, NULL);
-		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
-	} else {
-		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_meta_cb);
-	}
-
-	return RQ_END_IO_NONE;
-}
-
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
@@ -560,7 +455,6 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
struct nvme_ns *ns,
 	struct request *req;
 	blk_opf_t rq_flags =3D REQ_ALLOC_CACHE;
 	blk_mq_req_flags_t blk_flags =3D 0;
-	void *meta =3D NULL;
 	int ret;
=20
 	c.common.opcode =3D READ_ONCE(cmd->opcode);
@@ -608,27 +502,17 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl=
, struct nvme_ns *ns,
 	if (d.addr && d.data_len) {
 		ret =3D nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, &meta, ioucmd, vec);
+			d.metadata_len, 0, ioucmd, vec);
 		if (ret)
 			return ret;
 	}
=20
-	if (blk_rq_is_poll(req)) {
-		ioucmd->flags |=3D IORING_URING_CMD_POLLED;
-		WRITE_ONCE(ioucmd->cookie, req);
-	}
=20
 	/* to free bio on completion, as req->bio will be null at that time */
 	pdu->bio =3D req->bio;
-	pdu->meta_len =3D d.metadata_len;
+	pdu->req =3D req;
 	req->end_io_data =3D ioucmd;
-	if (pdu->meta_len) {
-		pdu->u.meta =3D meta;
-		pdu->u.meta_buffer =3D nvme_to_user_ptr(d.metadata);
-		req->end_io =3D nvme_uring_cmd_end_io_meta;
-	} else {
-		req->end_io =3D nvme_uring_cmd_end_io;
-	}
+	req->end_io =3D nvme_uring_cmd_end_io;
 	blk_execute_rq_nowait(req, false);
 	return -EIOCBQUEUED;
 }
@@ -779,16 +663,12 @@ int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cm=
d *ioucmd,
 				 struct io_comp_batch *iob,
 				 unsigned int poll_flags)
 {
-	struct request *req;
-	int ret =3D 0;
-
-	if (!(ioucmd->flags & IORING_URING_CMD_POLLED))
-		return 0;
+	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
+	struct request *req =3D pdu->req;
=20
-	req =3D READ_ONCE(ioucmd->cookie);
 	if (req && blk_rq_is_poll(req))
-		ret =3D blk_rq_poll(req, iob, poll_flags);
-	return ret;
+		return blk_rq_poll(req, iob, poll_flags);
+	return 0;
 }
 #ifdef CONFIG_NVME_MULTIPATH
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
--=20
2.34.1

