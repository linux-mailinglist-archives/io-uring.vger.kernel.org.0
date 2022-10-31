Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F0C61383F
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiJaNl7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiJaNl6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBEB101F3
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:56 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFakU007975
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=kCnz8uQ/hWag4I8ws1bxcXGmJng6+FeiSra6gGWm1+E=;
 b=L/PL/Wcdh2dCBoAmXSDU2Hw9D705tySeVDCv86Sm+m3C8m2uAoqgsK7ayKWlc/FqkVSu
 aZzBu/jdIJ5osmqqMYH/eZ4Lw7r2Xm6XEuAjDHcUfCx3QnY3O35FYgt+NNLMTV3lwVKW
 tYw53heDKzmXOoyfsJaZDj02hj/eQTzV+1GcjjJiNVp9m0sRzS0BxQ34AI+6V+ceqnAT
 lhrgmX6jgMn18dnFCzop1GmljKGewxGqCw3IGpCLfNnDaD3bQR5d3wAjfitQTfWKTK9d
 2+L6/GAAj5+V9zbSWGDEWYeKnHNsQHhyn2OARuRBSd3jyIeSv0gjwDwgTdLCR7h8y4Vh lg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh07p697e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:55 -0700
Received: from twshared14438.02.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:55 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E3BDD8A1965C; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 09/12] io_uring: accept retarget_rsrc support
Date:   Mon, 31 Oct 2022 06:41:23 -0700
Message-ID: <20221031134126.82928-10-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: af97CRxj55TuegxBFZBu6YP-4yR7vEKm
X-Proofpoint-ORIG-GUID: af97CRxj55TuegxBFZBu6YP-4yR7vEKm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_15,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add can_retarget_rsrc handler for accept

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/net.c   | 15 +++++++++++++++
 io_uring/net.h   |  1 +
 io_uring/opdef.c |  1 +
 3 files changed, 17 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0fa05ef52dd3..429176f3d191 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -30,6 +30,7 @@ struct io_accept {
 	int				flags;
 	u32				file_slot;
 	unsigned long			nofile;
+	int				retarget_fd;
 };
=20
 struct io_socket {
@@ -1255,6 +1256,15 @@ void io_sendrecv_fail(struct io_kiocb *req)
 		req->cqe.flags |=3D IORING_CQE_F_MORE;
 }
=20
+bool io_accept_can_retarget_rsrc(struct io_kiocb *req)
+{
+	struct io_accept *accept =3D io_kiocb_to_cmd(req, struct io_accept);
+
+	if (accept->retarget_fd < 0)
+		return false;
+	return io_file_peek_fixed(req, accept->retarget_fd) =3D=3D req->file;
+}
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept =3D io_kiocb_to_cmd(req, struct io_accept);
@@ -1285,6 +1295,11 @@ int io_accept_prep(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe)
 		accept->flags =3D (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 	if (flags & IORING_ACCEPT_MULTISHOT)
 		req->flags |=3D REQ_F_APOLL_MULTISHOT;
+
+	if (req->flags & REQ_F_FIXED_FILE)
+		accept->retarget_fd =3D req->cqe.fd;
+	else
+		accept->retarget_fd =3D -1;
 	return 0;
 }
=20
diff --git a/io_uring/net.h b/io_uring/net.h
index 6b5719084494..67fafb94d7de 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -49,6 +49,7 @@ void io_sendrecv_fail(struct io_kiocb *req);
=20
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)=
;
 int io_accept(struct io_kiocb *req, unsigned int issue_flags);
+bool io_accept_can_retarget_rsrc(struct io_kiocb *req);
=20
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)=
;
 int io_socket(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 1a0be5681c7b..7c94f1a4315a 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -207,6 +207,7 @@ const struct io_op_def io_op_defs[] =3D {
 #if defined(CONFIG_NET)
 		.prep			=3D io_accept_prep,
 		.issue			=3D io_accept,
+		.can_retarget_rsrc	=3D io_accept_can_retarget_rsrc,
 #else
 		.prep			=3D io_eopnotsupp_prep,
 #endif
--=20
2.30.2

