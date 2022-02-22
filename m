Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4BC4BF6BF
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 11:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiBVKzv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 05:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiBVKzp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 05:55:45 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB30158EA5
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 02:55:19 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21M4Eqe9019915
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 02:55:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9nnffLrIHYsDD7u0rLUN7PtBErPVZoq2VW3+Ud2kIXs=;
 b=bBG3XPEtjKKwNMJBoCEp6XV7lkzo9JxJXFbJJw/4Og31+9U7XpsEEn0S1P1notujNDxI
 OZFoTUIppIkigXNDF3b+FBtIj/V4yF+WclDGMs+gHgI/FIUVt3ywH3mlXVsdxImYLA/l
 iS4f4ViZ8+CoYchfeSjYSdXrc5/qLNFrOx4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3ecfsmuft7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 02:55:18 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 02:55:17 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 8015647C3A4F; Tue, 22 Feb 2022 02:55:13 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v3 3/4] io_uring: do not recalculate ppos unnecessarily
Date:   Tue, 22 Feb 2022 02:55:03 -0800
Message-ID: <20220222105504.3331010-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222105504.3331010-1-dylany@fb.com>
References: <20220222105504.3331010-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _lsFEg8z-Kr6OLkl1lDO-UOfB1TTYHiU
X-Proofpoint-ORIG-GUID: _lsFEg8z-Kr6OLkl1lDO-UOfB1TTYHiU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=643 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220064
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

There is a slight optimisation to be had by calculating the correct pos
pointer inside io_kiocb_update_pos and then using that later.

It seems code size drops by a bit:
000000000000a1b0 0000000000000400 t io_read
000000000000a5b0 0000000000000319 t io_write

vs
000000000000a1b0 00000000000003f6 t io_read
000000000000a5b0 0000000000000310 t io_write

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aba2a426a2d1..8954d82def36 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3066,18 +3066,22 @@ static inline void io_rw_done(struct kiocb *kiocb=
, ssize_t ret)
 	}
 }
=20
-static inline void io_kiocb_update_pos(struct io_kiocb *req)
+static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
 	struct kiocb *kiocb =3D &req->rw.kiocb;
+	bool is_stream =3D req->file->f_mode & FMODE_STREAM;
=20
 	if (kiocb->ki_pos =3D=3D -1) {
-		if (!(req->file->f_mode & FMODE_STREAM)) {
+		if (!is_stream) {
 			req->flags |=3D REQ_F_CUR_POS;
 			kiocb->ki_pos =3D req->file->f_pos;
+			return &kiocb->ki_pos;
 		} else {
 			kiocb->ki_pos =3D 0;
+			return NULL;
 		}
 	}
+	return is_stream ? NULL : &kiocb->ki_pos;
 }
=20
 static void kiocb_done(struct io_kiocb *req, ssize_t ret,
@@ -3638,6 +3642,7 @@ static int io_read(struct io_kiocb *req, unsigned i=
nt issue_flags)
 	bool force_nonblock =3D issue_flags & IO_URING_F_NONBLOCK;
 	struct io_async_rw *rw;
 	ssize_t ret, ret2;
+	loff_t *ppos;
=20
 	if (!req_has_async_data(req)) {
 		ret =3D io_import_iovec(READ, req, &iovec, s, issue_flags);
@@ -3668,9 +3673,9 @@ static int io_read(struct io_kiocb *req, unsigned i=
nt issue_flags)
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
-	io_kiocb_update_pos(req);
+	ppos =3D io_kiocb_update_pos(req);
=20
-	ret =3D rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->resu=
lt);
+	ret =3D rw_verify_area(READ, req->file, ppos, req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3769,6 +3774,7 @@ static int io_write(struct io_kiocb *req, unsigned =
int issue_flags)
 	struct kiocb *kiocb =3D &req->rw.kiocb;
 	bool force_nonblock =3D issue_flags & IO_URING_F_NONBLOCK;
 	ssize_t ret, ret2;
+	loff_t *ppos;
=20
 	if (!req_has_async_data(req)) {
 		ret =3D io_import_iovec(WRITE, req, &iovec, s, issue_flags);
@@ -3799,9 +3805,9 @@ static int io_write(struct io_kiocb *req, unsigned =
int issue_flags)
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
-	io_kiocb_update_pos(req);
+	ppos =3D io_kiocb_update_pos(req);
=20
-	ret =3D rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->res=
ult);
+	ret =3D rw_verify_area(WRITE, req->file, ppos, req->result);
 	if (unlikely(ret))
 		goto out_free;
=20
--=20
2.30.2

