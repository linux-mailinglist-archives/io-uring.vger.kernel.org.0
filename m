Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5954BA54C
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 16:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbiBQP7A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 10:59:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242701AbiBQP7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 10:59:00 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D488B163074
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:58:45 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21H4JVVl000531
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:58:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=gk/AAGRBn6/p51lPCZf29dhcm9A0ylWNixDxMjO056E=;
 b=iHEB+6HLJdAUaeXmS97HGXQcrcnA4RezGcNGALE0rKj9LZQ0+o7LFYC8lGBLpFv1ZtRP
 EkoYiqfc5wdW8kmnCQHHzQF/9me1qwjwtnushzMxQn+ReZQVIR5XB4Ex26hfQMKNm1aH
 6o2krxsynjqkR46WKwNOXeKaqGYK8OgXQIc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e9f7rbnpa-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 07:58:45 -0800
Received: from twshared0983.05.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 07:58:42 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 663F7439529F; Thu, 17 Feb 2022 07:58:31 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 3/3] io_uring: do not recalculate ppos unnecessarily
Date:   Thu, 17 Feb 2022 07:58:15 -0800
Message-ID: <20220217155815.2518717-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220217155815.2518717-1-dylany@fb.com>
References: <20220217155815.2518717-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: IHimentit2Aq6M91rLHUPJN3e4ZKSwWZ
X-Proofpoint-ORIG-GUID: IHimentit2Aq6M91rLHUPJN3e4ZKSwWZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_06,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501 mlxlogscore=677
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
index 6644d3d87934..6c096fa24c82 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3616,17 +3616,21 @@ static bool need_read_all(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
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
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
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

