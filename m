Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC7756582D
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 16:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiGDOBo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 10:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiGDOBi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 10:01:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4FB9FDA
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 07:01:34 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 263NO93w003717
        for <io-uring@vger.kernel.org>; Mon, 4 Jul 2022 07:01:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=HRZfP45TTLNeAY0T+VGcHao3/bX8pqW9AashhZVgTk0=;
 b=XFJ6tox86JFk1rN3RDTZW7Pfnhkcd9SQomycX7AUTXL90ScQkYrvcu59T3ojlhd9buH0
 699c815b9eah97OKQO4OuVmMZY3/q9yTALW/6YpcLGp87+bdoPhDg4ls+YnTub/fuXZv
 J3K06bQKKln+6DfkMQ/tbNxBtR4xiuG8WeU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h2nb5hard-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 07:01:33 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 4 Jul 2022 07:01:30 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A217B288A63D; Mon,  4 Jul 2022 07:01:27 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH] io_uring: disable multishot recvmsg
Date:   Mon, 4 Jul 2022 07:01:06 -0700
Message-ID: <20220704140106.200167-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: vqbQTgNvXVAW0qCHLHLOaJzxSX7Giwxj
X-Proofpoint-ORIG-GUID: vqbQTgNvXVAW0qCHLHLOaJzxSX7Giwxj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_13,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

recvmsg has semantics that do not make it trivial to extend to
multishot. Specifically it has user pointers and returns data in the
original parameter. In order to make this API useful these will need to b=
e
somehow included with the provided buffers.

For now remove multishot for recvmsg as it is not useful.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/net.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index cb08a4b62840..6679069eeef1 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -409,6 +409,8 @@ int io_recvmsg_prep(struct io_kiocb *req, const struc=
t io_uring_sqe *sqe)
 	if (sr->msg_flags & MSG_ERRQUEUE)
 		req->flags |=3D REQ_F_CLEAR_POLLIN;
 	if (sr->flags & IORING_RECV_MULTISHOT) {
+		if (req->opcode =3D=3D IORING_OP_RECVMSG)
+			return -EINVAL;
 		if (!(req->flags & REQ_F_BUFFER_SELECT))
 			return -EINVAL;
 		if (sr->msg_flags & MSG_WAITALL)
@@ -435,7 +437,7 @@ static inline void io_recv_prep_retry(struct io_kiocb=
 *req)
 }
=20
 /*
- * Finishes io_recv and io_recvmsg.
+ * Finishes io_recv
  *
  * Returns true if it is actually finished, or false if it should run
  * again (for multishot).
@@ -477,7 +479,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int iss=
ue_flags)
 	unsigned flags;
 	int ret, min_ret =3D 0;
 	bool force_nonblock =3D issue_flags & IO_URING_F_NONBLOCK;
-	size_t len =3D sr->len;
=20
 	sock =3D sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -496,17 +497,16 @@ int io_recvmsg(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg);
=20
-retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
=20
-		buf =3D io_buffer_select(req, &len, issue_flags);
+		buf =3D io_buffer_select(req, &sr->len, issue_flags);
 		if (!buf)
 			return -ENOBUFS;
 		kmsg->fast_iov[0].iov_base =3D buf;
-		kmsg->fast_iov[0].iov_len =3D len;
+		kmsg->fast_iov[0].iov_len =3D sr->len;
 		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov, 1,
-				len);
+				sr->len);
 	}
=20
 	flags =3D sr->msg_flags;
@@ -518,15 +518,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int is=
sue_flags)
 	kmsg->msg.msg_get_inq =3D 1;
 	ret =3D __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg, kmsg->uaddr, fla=
gs);
 	if (ret < min_ret) {
-		if (ret =3D=3D -EAGAIN && force_nonblock) {
-			ret =3D io_setup_async_msg(req, kmsg);
-			if (ret =3D=3D -EAGAIN && (req->flags & IO_APOLL_MULTI_POLLED) =3D=3D
-					       IO_APOLL_MULTI_POLLED) {
-				io_kbuf_recycle(req, issue_flags);
-				return IOU_ISSUE_SKIP_COMPLETE;
-			}
-			return ret;
-		}
+		if (ret =3D=3D -EAGAIN && force_nonblock)
+			return io_setup_async_msg(req, kmsg);
 		if (ret =3D=3D -ERESTARTSYS)
 			ret =3D -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
@@ -554,10 +547,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int is=
sue_flags)
 	if (kmsg->msg.msg_inq)
 		cflags |=3D IORING_CQE_F_SOCK_NONEMPTY;
=20
-	if (!io_recv_finish(req, &ret, cflags))
-		goto retry_multishot;
-
-	return ret;
+	io_req_set_res(req, ret, cflags);
+	return IOU_OK;
 }
=20
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)

base-commit: d641b3a4a25e8c471d0240dcb6c78efebd12f366
--=20
2.30.2

