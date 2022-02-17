Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84904BA545
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 16:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242735AbiBQP6z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 10:58:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiBQP6z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 10:58:55 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B79166A7E
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:58:40 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21HFqlJm014623
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:58:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=VcbZneM+CY02OyFP7xSWKNVxWUwSAVX6m7o7iYoKIkc=;
 b=Xvu5lssOITfRZ2QJHIWObbqJh0e8DjgB5umIZ7AaB8JjU/5+aTLc2AQYDEWSvS7R7v0D
 WwBh9qx4JQ9EfsCBH2KXrerSuc2ixUMViwzjdPqTFxfN5RMeezcoi6eDrddA8OHViU2H
 mF8VmTpnQVvQco7gUP93Rz2AuGFuq054uF4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e9dfbc3q3-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:58:40 -0800
Received: from twshared9880.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 07:58:34 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id A8443439526F; Thu, 17 Feb 2022 07:58:29 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 2/3] io_uring: update kiocb->ki_pos at execution time
Date:   Thu, 17 Feb 2022 07:58:14 -0800
Message-ID: <20220217155815.2518717-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220217155815.2518717-1-dylany@fb.com>
References: <20220217155815.2518717-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fQu8A5hVhv-44qmnZi-YbUhKicrYqvCF
X-Proofpoint-GUID: fQu8A5hVhv-44qmnZi-YbUhKicrYqvCF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_06,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 clxscore=1015 suspectscore=0 phishscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170072
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 1f9b4466c269..6644d3d87934 100644
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
@@ -3624,6 +3616,19 @@ static bool need_read_all(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
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
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s =3D &__s;
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

