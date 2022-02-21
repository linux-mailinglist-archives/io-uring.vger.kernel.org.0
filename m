Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945724BE685
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 19:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377509AbiBUORr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 09:17:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377495AbiBUORp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 09:17:45 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703381EAF4
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:21 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21L4ml0Z000908
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8JSelopTzUd3gZTcg3UIsHAtAUYSuIqFSQKhpF++mnI=;
 b=q05daNCgw7JtWrRIB+3JoF5i2vmR9748VjaWTy4b/90FgBQAr9cwigY9Oxi5Td1IkctU
 nhB+RWydF6BKFEcESR1WrlZYt4dCCRWbh/V8FhJl3JO1iJhh3Prx0wMHVehJgkbXpm+i
 fU3pyFqOCW3QOCpGo7y9SK2d72smH05Sce4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eay6212jf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 06:17:20 -0800
Received: from twshared7634.08.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 06:17:18 -0800
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 9E2A346F091A; Mon, 21 Feb 2022 06:17:14 -0800 (PST)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 1/4] io_uring: remove duplicated calls to io_kiocb_ppos
Date:   Mon, 21 Feb 2022 06:16:46 -0800
Message-ID: <20220221141649.624233-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220221141649.624233-1-dylany@fb.com>
References: <20220221141649.624233-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gMZdyX_v3M9TVJUf2uS2i6X_0ZKoWRij
X-Proofpoint-GUID: gMZdyX_v3M9TVJUf2uS2i6X_0ZKoWRij
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0 adultscore=0
 mlxlogscore=741 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210086
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_kiocb_ppos is called in both branches, and it seems that the compiler
does not fuse this. Fusing removes a few bytes from loop_rw_iter.

Before:
$ nm -S fs/io_uring.o | grep loop_rw_iter
0000000000002430 0000000000000124 t loop_rw_iter

After:
$ nm -S fs/io_uring.o | grep loop_rw_iter
0000000000002430 000000000000010d t loop_rw_iter

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77b9c7e4793b..1f9b4466c269 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3400,6 +3400,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb=
 *req, struct iov_iter *iter)
 	struct kiocb *kiocb =3D &req->rw.kiocb;
 	struct file *file =3D req->file;
 	ssize_t ret =3D 0;
+	loff_t *ppos;
=20
 	/*
 	 * Don't support polled IO through this interface, and we can't
@@ -3412,6 +3413,8 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb=
 *req, struct iov_iter *iter)
 	    !(kiocb->ki_filp->f_flags & O_NONBLOCK))
 		return -EAGAIN;
=20
+	ppos =3D io_kiocb_ppos(kiocb);
+
 	while (iov_iter_count(iter)) {
 		struct iovec iovec;
 		ssize_t nr;
@@ -3425,10 +3428,10 @@ static ssize_t loop_rw_iter(int rw, struct io_kio=
cb *req, struct iov_iter *iter)
=20
 		if (rw =3D=3D READ) {
 			nr =3D file->f_op->read(file, iovec.iov_base,
-					      iovec.iov_len, io_kiocb_ppos(kiocb));
+					      iovec.iov_len, ppos);
 		} else {
 			nr =3D file->f_op->write(file, iovec.iov_base,
-					       iovec.iov_len, io_kiocb_ppos(kiocb));
+					       iovec.iov_len, ppos);
 		}
=20
 		if (nr < 0) {
--=20
2.30.2

