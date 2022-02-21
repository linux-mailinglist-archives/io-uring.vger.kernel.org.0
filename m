Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793374BDCBC
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 18:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377507AbiBUORs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 09:17:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377521AbiBUORq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 09:17:46 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657651EAF6
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:23 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21LAFiJu026086
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=61rzr/XC//QWTgQarhzaCqWt4vh91P2MKvAjSBOBxTU=;
 b=irBj/A1itCRO9GYL3E36OrELiZxfRB0le7IChONuTQ5CB4M669pVbX95tIrgQwamCoXQ
 BMrp/TTy8cgE2jGzNCUWu3pjmSuVlKf791Hc7GHsk4m6ukbvvh2gE04odAFSbO0QrVZ1
 +omIkt+1QzH9b86492+/XvvR21RFsks4pHo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ec8tk137f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:23 -0800
Received: from twshared33860.05.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 06:17:22 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 8A5D246F091F; Mon, 21 Feb 2022 06:17:15 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 2/4] io_uring: update kiocb->ki_pos at execution time
Date:   Mon, 21 Feb 2022 06:16:47 -0800
Message-ID: <20220221141649.624233-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220221141649.624233-1-dylany@fb.com>
References: <20220221141649.624233-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ss_HWyWtYVb_DZY3O6T3xrdln9FGJBPI
X-Proofpoint-ORIG-GUID: ss_HWyWtYVb_DZY3O6T3xrdln9FGJBPI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210086
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Update kiocb->ki_pos at execution time rather than in io_prep_rw().
io_prep_rw() happens before the job is enqueued to a worker and so the
offset might be read multiple times before being executed once.

Ensures that the file position in a set of _linked_ SQEs will be only
obtained after earlier SQEs have completed, and so will include their
incremented file position.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f9b4466c269..50b93ff2ee12 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3000,14 +3000,6 @@ static int io_prep_rw(struct io_kiocb *req, const =
struct io_uring_sqe *sqe)
 		req->flags |=3D io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
=20
 	kiocb->ki_pos =3D READ_ONCE(sqe->off);
-	if (kiocb->ki_pos =3D=3D -1) {
-		if (!(file->f_mode & FMODE_STREAM)) {
-			req->flags |=3D REQ_F_CUR_POS;
-			kiocb->ki_pos =3D file->f_pos;
-		} else {
-			kiocb->ki_pos =3D 0;
-		}
-	}
 	kiocb->ki_flags =3D iocb_flags(file);
 	ret =3D kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
 	if (unlikely(ret))
@@ -3074,6 +3066,19 @@ static inline void io_rw_done(struct kiocb *kiocb,=
 ssize_t ret)
 	}
 }
=20
+static inline void
+io_kiocb_update_pos(struct io_kiocb *req, struct kiocb *kiocb)
+{
+	if (kiocb->ki_pos =3D=3D -1) {
+		if (!(req->file->f_mode & FMODE_STREAM)) {
+			req->flags |=3D REQ_F_CUR_POS;
+			kiocb->ki_pos =3D req->file->f_pos;
+		} else {
+			kiocb->ki_pos =3D 0;
+		}
+	}
+}
+
 static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 		       unsigned int issue_flags)
 {
@@ -3662,6 +3667,8 @@ static int io_read(struct io_kiocb *req, unsigned i=
nt issue_flags)
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
+	io_kiocb_update_pos(req, kiocb);
+
 	ret =3D rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->resu=
lt);
 	if (unlikely(ret)) {
 		kfree(iovec);
@@ -3791,6 +3798,8 @@ static int io_write(struct io_kiocb *req, unsigned =
int issue_flags)
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
+	io_kiocb_update_pos(req, kiocb);
+
 	ret =3D rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->res=
ult);
 	if (unlikely(ret))
 		goto out_free;
--=20
2.30.2

