Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A10261FC71
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 19:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiKGSAO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 13:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbiKGR7s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 12:59:48 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35D52A944
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 09:56:24 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7Glivp023222
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 09:56:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=L3jw1UOj6ixjglp00dy1V087hjPkrNjvSa5Six2yGI0=;
 b=M9ZqP5hok/+fvIkhOQjZnDGyICKctDvZD2af06hYRhVQrIT0I5R1DwRvlKCf/iwVMeot
 rOMpxVG2phTo7Fd6Uo1xnrNJ8keushyttYBf70d3Q/K7ZzrxZ+FuN2rUNLTXzEO8tGwp
 IB/7roO7MZ1RswdW3hQ/SonoJEaCrltoU3uGWjTuf+yWw0CxokdpWL8JjGCTvmPQSMXO
 J7EtxuaOOQ5Da/56zqXZYAXggZWHAcmgb7EyTlRCi4lT+LzM9wlDKx1wd50+mL/Cg70W
 v5nHCwXQFaqCO4tLF4LCKyKOraPGt+gT9sK8epBYU/ctZM23trjAHzCrISX6LXHuBwaa aQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knnbyrfye-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 09:56:22 -0800
Received: from twshared5287.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 09:56:20 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 7EDBDADF1C9B; Mon,  7 Nov 2022 09:56:11 -0800 (PST)
From:   Keith Busch <kbusch@meta.com>
To:     <viro@zeniv.linux.org.uk>, <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>
CC:     <asml.silence@gmail.com>, <linux-fsdevel@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/4] io_uring: switch network send/recv to ITER_UBUF
Date:   Mon, 7 Nov 2022 09:56:08 -0800
Message-ID: <20221107175610.349807-3-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107175610.349807-1-kbusch@meta.com>
References: <20221107175610.349807-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 5qVPEtRoFFygW6Rg0P03xJCuQZVZxqvU
X-Proofpoint-GUID: 5qVPEtRoFFygW6Rg0P03xJCuQZVZxqvU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

This is more efficient than ITER_IOVEC.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
[merged to 6.1]
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/net.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 9a07e79cc0e6..12c68b5ec62d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -170,7 +170,7 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	if (async_msg->msg.msg_name)
 		async_msg->msg.msg_name =3D &async_msg->addr;
 	/* if were using fast_iov, set it to the new one */
-	if (!kmsg->free_iov) {
+	if (iter_is_iovec(&kmsg->msg.msg_iter) && !kmsg->free_iov) {
 		size_t fast_idx =3D kmsg->msg.msg_iter.iov - kmsg->fast_iov;
 		async_msg->msg.msg_iter.iov =3D &async_msg->fast_iov[fast_idx];
 	}
@@ -333,7 +333,6 @@ int io_send(struct io_kiocb *req, unsigned int issue_=
flags)
 	struct sockaddr_storage __address;
 	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
-	struct iovec iov;
 	struct socket *sock;
 	unsigned flags;
 	int min_ret =3D 0;
@@ -367,7 +366,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_=
flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
=20
-	ret =3D import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_ite=
r);
+	ret =3D import_ubuf(WRITE, sr->buf, sr->len, &msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
=20
@@ -752,10 +751,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int is=
sue_flags)
 			}
 		}
=20
-		kmsg->fast_iov[0].iov_base =3D buf;
-		kmsg->fast_iov[0].iov_len =3D len;
-		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov, 1,
-				len);
+		iov_iter_ubuf(&kmsg->msg.msg_iter, READ, buf, len);
 	}
=20
 	flags =3D sr->msg_flags;
@@ -824,7 +820,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_=
flags)
 	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
 	struct socket *sock;
-	struct iovec iov;
 	unsigned int cflags;
 	unsigned flags;
 	int ret, min_ret =3D 0;
@@ -849,7 +844,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_=
flags)
 		sr->buf =3D buf;
 	}
=20
-	ret =3D import_single_range(READ, sr->buf, len, &iov, &msg.msg_iter);
+	ret =3D import_ubuf(READ, sr->buf, len, &msg.msg_iter);
 	if (unlikely(ret))
 		goto out_free;
=20
--=20
2.30.2

