Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816AA61383E
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiJaNl5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiJaNl4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:56 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52EF101F8
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:55 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDFP6L005880
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=5UAK8/r+oYf2G6j07qTXSAPgzd10hopmcm9ZNkR5gs8=;
 b=XgljDSJMesW1btodXNg+MMO7dCwfJjRJMfTcRCcfN0tnQrTEOoI2E6BHGgK+UkEBK0wp
 sKNNG6t62mD7DG9jvfqDsYEBxZynive/fEliiSlxXvB8VtQCi3KYVOYTF1vDCvznFxHs
 +f4PQkQIqNE9pGRYUhFZp7f5lswOA4gbI6oSCqSfz3wMB/c14iz/LeXgj4JDHD6sKSdD
 KY6SZMGfPANnDZws7jU7vgPqWplbKevp9ymPfTtnWUbfoDqP8/f8Tetv9Uu2O5JNqPRa
 PVFLWvx/ruwYvAxsfyAHI967ioIYs+XqBFHDvVkUy3YbtplNbxc4uUag7h+KCwCCYBA0 qw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh1x1xcb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:54 -0700
Received: from twshared2001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:52 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id D8A3B8A1965A; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 08/12] io_uring: recv/recvmsg retarget_rsrc support
Date:   Mon, 31 Oct 2022 06:41:22 -0700
Message-ID: <20221031134126.82928-9-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7UN_yBR63euU9i9LNSM2PX7sV_lFVpZV
X-Proofpoint-GUID: 7UN_yBR63euU9i9LNSM2PX7sV_lFVpZV
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

Add can_retarget_rsrc handler for recv/recvmsg

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/net.c   | 22 +++++++++++++++++++++-
 io_uring/net.h   |  1 +
 io_uring/opdef.c |  2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f4638e79a022..0fa05ef52dd3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -70,6 +70,11 @@ struct io_send_zc_msg {
 	struct io_kiocb		*notif;
 };
=20
+struct io_recv_msg {
+	struct io_sr_msg	sr;
+	int			retarget_fd;
+};
+
=20
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
=20
@@ -547,7 +552,8 @@ int io_recvmsg_prep_async(struct io_kiocb *req)
=20
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe=
)
 {
-	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_recv_msg *rcv =3D io_kiocb_to_cmd(req, struct io_recv_msg);
+	struct io_sr_msg *sr =3D &rcv->sr;
=20
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -572,6 +578,11 @@ int io_recvmsg_prep(struct io_kiocb *req, const stru=
ct io_uring_sqe *sqe)
 		req->flags |=3D REQ_F_APOLL_MULTISHOT;
 	}
=20
+	if (req->flags & REQ_F_FIXED_FILE)
+		rcv->retarget_fd =3D req->cqe.fd;
+	else
+		rcv->retarget_fd =3D -1;
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		sr->msg_flags |=3D MSG_CMSG_COMPAT;
@@ -709,6 +720,15 @@ static int io_recvmsg_multishot(struct socket *sock,=
 struct io_sr_msg *io,
 			kmsg->controllen + err;
 }
=20
+bool io_recv_can_retarget_rsrc(struct io_kiocb *req)
+{
+	struct io_recv_msg *rcv =3D io_kiocb_to_cmd(req, struct io_recv_msg);
+
+	if (rcv->retarget_fd < 0)
+		return false;
+	return io_file_peek_fixed(req, rcv->retarget_fd) =3D=3D req->file;
+}
+
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req, struct io_sr_msg);
diff --git a/io_uring/net.h b/io_uring/net.h
index 5ffa11bf5d2e..6b5719084494 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -43,6 +43,7 @@ int io_recvmsg_prep_async(struct io_kiocb *req);
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe=
);
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags);
 int io_recv(struct io_kiocb *req, unsigned int issue_flags);
+bool io_recv_can_retarget_rsrc(struct io_kiocb *req);
=20
 void io_sendrecv_fail(struct io_kiocb *req);
=20
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 83dc0f9ad3b2..1a0be5681c7b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -178,6 +178,7 @@ const struct io_op_def io_op_defs[] =3D {
 		.prep_async		=3D io_recvmsg_prep_async,
 		.cleanup		=3D io_sendmsg_recvmsg_cleanup,
 		.fail			=3D io_sendrecv_fail,
+		.can_retarget_rsrc	=3D io_recv_can_retarget_rsrc,
 #else
 		.prep			=3D io_eopnotsupp_prep,
 #endif
@@ -340,6 +341,7 @@ const struct io_op_def io_op_defs[] =3D {
 		.prep			=3D io_recvmsg_prep,
 		.issue			=3D io_recv,
 		.fail			=3D io_sendrecv_fail,
+		.can_retarget_rsrc	=3D io_recv_can_retarget_rsrc,
 #else
 		.prep			=3D io_eopnotsupp_prep,
 #endif
--=20
2.30.2

