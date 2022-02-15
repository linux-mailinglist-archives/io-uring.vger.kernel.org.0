Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2974B5EF9
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 01:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiBOAVq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 19:21:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiBOAVp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 19:21:45 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9811070A6
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 16:21:35 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 21EKsXXt026492
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 16:21:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ynEAjDxLFX/0YITX75d7F1VJ3XLGLWEk5W5R3IbUC0Q=;
 b=aEu+dBwOv9X+H2eZ2k5eofHD2Bcc7EupmcfIct/F5B6nsWqAJfzZlCEOsfvjlgXkUfl4
 2bs0dMdQ8L6amDMd3VywmQmMRp50J+xbOQcXg98BBv75CpGr/ZZLrMW2Hjx2/YR1dwgI
 z56ixPy3kD81QtCybdVAt0ivZgfzhU5hj/o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e7q2ecwnu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 16:21:35 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 16:21:34 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 445D7AC1ADCA; Mon, 14 Feb 2022 16:21:27 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>
Subject: [PATCH v2 2/2] io-uring: Copy path name during prepare stage for statx
Date:   Mon, 14 Feb 2022 16:21:21 -0800
Message-ID: <20220215002121.2049686-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220215002121.2049686-1-shr@fb.com>
References: <20220215002121.2049686-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ND3JNn1MAothGPK8piZNEXH2W_8O4zub
X-Proofpoint-ORIG-GUID: ND3JNn1MAothGPK8piZNEXH2W_8O4zub
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=784 phishscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202150000
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

One of the key architectual tenets is to keep the parameters for
io-uring stable. After the call has been submitted, its value can
be changed. Unfortunaltely this is not the case for the current statx
implementation.

This changes replaces the const char * filename pointer in the io_statx
structure with a struct filename *. In addition it also creates the
filename object during the prepare phase.

With this change, the opcode also needs to invoke cleanup, so the
filename object gets freed after processing the request.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77b9c7e4793b..28b09b163df1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -642,7 +642,7 @@ struct io_statx {
 	int				dfd;
 	unsigned int			mask;
 	unsigned int			flags;
-	const char __user		*filename;
+	struct filename			*filename;
 	struct statx __user		*buffer;
 };
=20
@@ -4721,6 +4721,8 @@ static int io_fadvise(struct io_kiocb *req, unsigne=
d int issue_flags)
=20
 static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe=
 *sqe)
 {
+	const char __user *path;
+
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
@@ -4730,10 +4732,22 @@ static int io_statx_prep(struct io_kiocb *req, co=
nst struct io_uring_sqe *sqe)
=20
 	req->statx.dfd =3D READ_ONCE(sqe->fd);
 	req->statx.mask =3D READ_ONCE(sqe->len);
-	req->statx.filename =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
+	path =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->statx.buffer =3D u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	req->statx.flags =3D READ_ONCE(sqe->statx_flags);
=20
+	req->statx.filename =3D getname_flags(path,
+					getname_statx_lookup_flags(req->statx.flags),
+					NULL);
+
+	if (IS_ERR(req->statx.filename)) {
+		int ret =3D PTR_ERR(req->statx.filename);
+
+		req->statx.filename =3D NULL;
+		return ret;
+	}
+
+	req->flags |=3D REQ_F_NEED_CLEANUP;
 	return 0;
 }
=20
@@ -6708,6 +6722,10 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->hardlink.oldpath);
 			putname(req->hardlink.newpath);
 			break;
+		case IORING_OP_STATX:
+			if (req->statx.filename)
+				putname(req->statx.filename);
+			break;
 		}
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
--=20
2.30.2

