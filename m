Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4756DB402
	for <lists+io-uring@lfdr.de>; Fri,  7 Apr 2023 21:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjDGTRM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Apr 2023 15:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjDGTRL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Apr 2023 15:17:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52082C147
        for <io-uring@vger.kernel.org>; Fri,  7 Apr 2023 12:17:03 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337GhEIq030225
        for <io-uring@vger.kernel.org>; Fri, 7 Apr 2023 12:17:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=NRUfXoo+zRRKwmGsi/Srk58rVRQNCgmkeDuGygd3+t8=;
 b=kDNSLrSU+tNp1M3FXO1PreRyCln4G5QB6Sj6SqR3C+Cj4Nsbq3yYRXcx8aLaiSBBh2UL
 7w8u196u3XX/d3ux9vqO/imUR9MVsXLPBzo8c0MGZH5VyxuX8TiabdH5yciAwDnzlxzY
 IlySIVX4TUaQEa01bhlScb6XLYxs58RiCF5a99SXsciGC4IdwMtDLwQvEj3QAR6mWM7C
 qu7dhG7xxthhNb9QTwtAY77KjbS1zA9XwaywdJsOa+cjZVff61PQFlRO74ei3C7ZbSRn
 YYPbANQj92DoRY4osLkD+vKOsmie/pDOLXlpfMOjlDgXdnVHHmkF6Gf2clGsJG/xGJ52 ug== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3psyun9818-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Apr 2023 12:17:02 -0700
Received: from twshared15216.17.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 7 Apr 2023 12:17:02 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id B210B157B5F82; Fri,  7 Apr 2023 12:16:47 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>
CC:     <sagi@grimberg.me>, <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 2/5] nvme: simplify passthrough bio cleanup
Date:   Fri, 7 Apr 2023 12:16:33 -0700
Message-ID: <20230407191636.2631046-3-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230407191636.2631046-1-kbusch@meta.com>
References: <20230407191636.2631046-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 32QrxKMTfhKs969xKEDaJfyxMFihXo3G
X-Proofpoint-ORIG-GUID: 32QrxKMTfhKs969xKEDaJfyxMFihXo3G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_12,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Set the bio's bi_end_io to handle the cleanup so that uring_cmd doesn't
need this complex pdu->{bio,req} switchero and restore.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/ioctl.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index d24ea2e051564..278c57ee0db91 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -159,6 +159,11 @@ static struct request *nvme_alloc_user_request(struc=
t request_queue *q,
 	return req;
 }
=20
+static void nvme_uring_bio_end_io(struct bio *bio)
+{
+	blk_rq_unmap_user(bio);
+}
+
 static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
 		u32 meta_seed, void **metap, struct io_uring_cmd *ioucmd,
@@ -204,6 +209,7 @@ static int nvme_map_user_request(struct request *req,=
 u64 ubuffer,
 		*metap =3D meta;
 	}
=20
+	bio->bi_end_io =3D nvme_uring_bio_end_io;
 	return ret;
=20
 out_unmap:
@@ -249,8 +255,6 @@ static int nvme_submit_user_cmd(struct request_queue =
*q,
 	if (meta)
 		ret =3D nvme_finish_user_metadata(req, meta_buffer, meta,
 						meta_len, ret);
-	if (bio)
-		blk_rq_unmap_user(bio);
 	blk_mq_free_request(req);
=20
 	if (effects)
@@ -443,10 +447,7 @@ struct nvme_uring_data {
  * Expect build errors if this grows larger than that.
  */
 struct nvme_uring_cmd_pdu {
-	union {
-		struct bio *bio;
-		struct request *req;
-	};
+	struct request *req;
 	u32 meta_len;
 	u32 nvme_status;
 	union {
@@ -482,8 +483,6 @@ static void nvme_uring_task_meta_cb(struct io_uring_c=
md *ioucmd,
 	if (pdu->meta_len)
 		status =3D nvme_finish_user_metadata(req, pdu->u.meta_buffer,
 					pdu->u.meta, pdu->meta_len, status);
-	if (req->bio)
-		blk_rq_unmap_user(req->bio);
 	blk_mq_free_request(req);
=20
 	io_uring_cmd_done(ioucmd, status, result, issue_flags);
@@ -494,9 +493,6 @@ static void nvme_uring_task_cb(struct io_uring_cmd *i=
oucmd,
 {
 	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
=20
-	if (pdu->bio)
-		blk_rq_unmap_user(pdu->bio);
-
 	io_uring_cmd_done(ioucmd, pdu->nvme_status, pdu->u.result, issue_flags)=
;
 }
=20
@@ -507,7 +503,6 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struc=
t request *req,
 	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
 	void *cookie =3D READ_ONCE(ioucmd->cookie);
=20
-	req->bio =3D pdu->bio;
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
 		pdu->nvme_status =3D -EINTR;
 	else
@@ -533,9 +528,6 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(=
struct request *req,
 	struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
 	void *cookie =3D READ_ONCE(ioucmd->cookie);
=20
-	req->bio =3D pdu->bio;
-	pdu->req =3D req;
-
 	/*
 	 * For iopoll, complete it directly.
 	 * Otherwise, move the completion to task work.
@@ -624,8 +616,8 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
struct nvme_ns *ns,
 			req->bio->bi_opf |=3D REQ_POLLED;
 		}
 	}
-	/* to free bio on completion, as req->bio will be null at that time */
-	pdu->bio =3D req->bio;
+
+	pdu->req =3D req;
 	pdu->meta_len =3D d.metadata_len;
 	req->end_io_data =3D ioucmd;
 	if (pdu->meta_len) {
--=20
2.34.1

