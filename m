Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62474BE67F
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 19:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377518AbiBUORy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 09:17:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377511AbiBUORt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 09:17:49 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17061EAF0
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:25 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21LANSdc002488
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=XsWZ+dstq9O1Y74mqKTBcqdLDX5wS+fQHRNAdVW6HtI=;
 b=FU7SzZ/Jra+9EUb9f96ooumawIM+nllcAogPUHOwgQ6+VjhS6bjtwsMZj3eciCQfwHHp
 33wCN6DTt8YkIezFAOpGoU1i7H7ZcJBenSDsxeHkdock0guH/lLGaI2Q/hJSvS9P9AJS
 gWKJ8by1Ls1rCUWVZTkOSEitM2ncZI0ou4Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ec8xnh0ss-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:24 -0800
Received: from twshared26885.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 06:17:23 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id D594D46F0930; Mon, 21 Feb 2022 06:17:16 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 3/4] io_uring: do not recalculate ppos unnecessarily
Date:   Mon, 21 Feb 2022 06:16:48 -0800
Message-ID: <20220221141649.624233-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220221141649.624233-1-dylany@fb.com>
References: <20220221141649.624233-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ZLL67D2Hp1ukquJ-QBdoWcc_ruoJgFwK
X-Proofpoint-ORIG-GUID: ZLL67D2Hp1ukquJ-QBdoWcc_ruoJgFwK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=641 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
index 50b93ff2ee12..abd8c739988e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3066,17 +3066,21 @@ static inline void io_rw_done(struct kiocb *kiocb=
, ssize_t ret)
 	}
 }
=20
-static inline void
+static inline loff_t*
 io_kiocb_update_pos(struct io_kiocb *req, struct kiocb *kiocb)
 {
+	bool is_stream =3D req->file->f_mode & FMODE_STREAM;
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
@@ -3637,6 +3641,7 @@ static int io_read(struct io_kiocb *req, unsigned i=
nt issue_flags)
 	bool force_nonblock =3D issue_flags & IO_URING_F_NONBLOCK;
 	struct io_async_rw *rw;
 	ssize_t ret, ret2;
+	loff_t *ppos;
=20
 	if (!req_has_async_data(req)) {
 		ret =3D io_import_iovec(READ, req, &iovec, s, issue_flags);
@@ -3667,9 +3672,9 @@ static int io_read(struct io_kiocb *req, unsigned i=
nt issue_flags)
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
-	io_kiocb_update_pos(req, kiocb);
+	ppos =3D io_kiocb_update_pos(req, kiocb);
=20
-	ret =3D rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->resu=
lt);
+	ret =3D rw_verify_area(READ, req->file, ppos, req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3768,6 +3773,7 @@ static int io_write(struct io_kiocb *req, unsigned =
int issue_flags)
 	struct kiocb *kiocb =3D &req->rw.kiocb;
 	bool force_nonblock =3D issue_flags & IO_URING_F_NONBLOCK;
 	ssize_t ret, ret2;
+	loff_t *ppos;
=20
 	if (!req_has_async_data(req)) {
 		ret =3D io_import_iovec(WRITE, req, &iovec, s, issue_flags);
@@ -3798,9 +3804,9 @@ static int io_write(struct io_kiocb *req, unsigned =
int issue_flags)
 		kiocb->ki_flags &=3D ~IOCB_NOWAIT;
 	}
=20
-	io_kiocb_update_pos(req, kiocb);
+	ppos =3D io_kiocb_update_pos(req, kiocb);
=20
-	ret =3D rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->res=
ult);
+	ret =3D rw_verify_area(WRITE, req->file, ppos, req->result);
 	if (unlikely(ret))
 		goto out_free;
=20
--=20
2.30.2

