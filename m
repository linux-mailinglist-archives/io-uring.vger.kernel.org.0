Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15FC573103
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 10:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbiGMI0K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 04:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbiGMIZs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 04:25:48 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD9E29CAA
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 01:23:56 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D4p3In030258
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 01:23:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=sGWRkyqkpVz1RGFjg2PBYP+CEYmUvga0JR8HG3YVf4k=;
 b=doLPhZjHaKHeoe0daAVJLg8o21IcN9rMwH74MzK6ihMKQkQo2QAGCFlQ76tEoyvtRBh4
 Jvr5EtErHJdtGIzvxYXwjvpQ6mKd1lhp+T47VkjSfRJKCAqg4Y0/e1hI+X4uCKX91kY2
 ytZPqM9ufSPLgGvwLrNdkMdoU5JbGYTw/jw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h9h5ftd54-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 01:23:56 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 13 Jul 2022 01:23:54 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id ECB8E2ED8C2D; Wed, 13 Jul 2022 01:23:44 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <io-uring@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 3/3] io_uring: support multishot in recvmsg
Date:   Wed, 13 Jul 2022 01:23:21 -0700
Message-ID: <20220713082321.1445020-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713082321.1445020-1-dylany@fb.com>
References: <20220713082321.1445020-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: sxdU7zW91-MnCaXPbTXhc_QR1kArK1-N
X-Proofpoint-ORIG-GUID: sxdU7zW91-MnCaXPbTXhc_QR1kArK1-N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Similar to multishot recv, this will require provided buffers to be
used. However recvmsg is much more complex than recv as it has multiple
outputs. Specifically flags, name, and control messages.

Support this by introducing a new struct io_uring_recvmsg_out with 4
fields. namelen, controllen and flags match the similar out fields in
msghdr from standard recvmsg(2), payloadlen is the length of the payload
following the header.
This struct is placed at the start of the returned buffer. Based on what
the user specifies in struct msghdr, the next bytes of the buffer will be
name (the next msg_namelen bytes), and then control (the next
msg_controllen bytes). The payload will come at the end. The return value
in the CQE is the total used size of the provided buffer.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/uapi/linux/io_uring.h |   7 ++
 io_uring/net.c                | 178 ++++++++++++++++++++++++++++++----
 io_uring/net.h                |   6 ++
 3 files changed, 172 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 499679134961..4c9b11e2e991 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -613,4 +613,11 @@ struct io_uring_file_index_range {
 	__u64	resv;
 };
=20
+struct io_uring_recvmsg_out {
+	__u32 namelen;
+	__u32 controllen;
+	__u32 payloadlen;
+	__u32 flags;
+};
+
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index 5bc3440a8290..56f734acced6 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -352,6 +352,11 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *re=
q,
 			sr->len =3D iomsg->fast_iov[0].iov_len;
 			iomsg->free_iov =3D NULL;
 		}
+
+		if (req->flags & REQ_F_APOLL_MULTISHOT) {
+			iomsg->namelen =3D msg.msg_namelen;
+			iomsg->controllen =3D msg.msg_controllen;
+		}
 	} else {
 		iomsg->free_iov =3D iomsg->fast_iov;
 		ret =3D __import_iovec(READ, msg.msg_iov, msg.msg_iovlen, UIO_FASTIOV,
@@ -399,6 +404,11 @@ static int __io_compat_recvmsg_copy_hdr(struct io_ki=
ocb *req,
 			sr->len =3D clen;
 			iomsg->free_iov =3D NULL;
 		}
+
+		if (req->flags & REQ_F_APOLL_MULTISHOT) {
+			iomsg->namelen =3D msg.msg_namelen;
+			iomsg->controllen =3D msg.msg_controllen;
+		}
 	} else {
 		iomsg->free_iov =3D iomsg->fast_iov;
 		ret =3D __import_iovec(READ, (struct iovec __user *)uiov, msg.msg_iovl=
en,
@@ -455,8 +465,6 @@ int io_recvmsg_prep(struct io_kiocb *req, const struc=
t io_uring_sqe *sqe)
 	if (sr->msg_flags & MSG_ERRQUEUE)
 		req->flags |=3D REQ_F_CLEAR_POLLIN;
 	if (sr->flags & IORING_RECV_MULTISHOT) {
-		if (req->opcode =3D=3D IORING_OP_RECVMSG)
-			return -EINVAL;
 		if (!(req->flags & REQ_F_BUFFER_SELECT))
 			return -EINVAL;
 		if (sr->msg_flags & MSG_WAITALL)
@@ -483,12 +491,15 @@ static inline void io_recv_prep_retry(struct io_kio=
cb *req)
 }
=20
 /*
- * Finishes io_recv
+ * Finishes io_recv and io_recvmsg.
  *
  * Returns true if it is actually finished, or false if it should run
  * again (for multishot).
  */
-static inline bool io_recv_finish(struct io_kiocb *req, int *ret, unsign=
ed int cflags)
+static inline bool io_recv_finish(struct io_kiocb *req,
+				  int *ret,
+				  unsigned int cflags,
+				  bool multishot_finished)
 {
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 		io_req_set_res(req, *ret, cflags);
@@ -496,7 +507,7 @@ static inline bool io_recv_finish(struct io_kiocb *re=
q, int *ret, unsigned int c
 		return true;
 	}
=20
-	if (*ret > 0) {
+	if (!multishot_finished) {
 		if (io_post_aux_cqe(req->ctx, req->cqe.user_data, *ret,
 				    cflags | IORING_CQE_F_MORE, false)) {
 			io_recv_prep_retry(req);
@@ -518,6 +529,104 @@ static inline bool io_recv_finish(struct io_kiocb *=
req, int *ret, unsigned int c
 	return true;
 }
=20
+static int io_recvmsg_prep_multishot(
+	struct io_async_msghdr *kmsg,
+	struct io_sr_msg *sr,
+	void __user **buf,
+	size_t *len)
+{
+	unsigned long used =3D 0;
+
+	if (*len < sizeof(struct io_uring_recvmsg_out))
+		return -EFAULT;
+	used +=3D sizeof(struct io_uring_recvmsg_out);
+
+	if (kmsg->namelen) {
+		if (kmsg->namelen + used > *len)
+			return -EFAULT;
+		used +=3D kmsg->namelen;
+	}
+	if (kmsg->controllen) {
+		if (kmsg->controllen + used > *len)
+			return -EFAULT;
+		kmsg->msg.msg_control_user =3D (void *)((unsigned long)*buf + used);
+		kmsg->msg.msg_controllen =3D kmsg->controllen;
+		used +=3D kmsg->controllen;
+	}
+	if (used >=3D UINT_MAX)
+		return -EOVERFLOW;
+
+	sr->buf =3D *buf; /* stash for later copy */
+	*buf =3D (void *)((unsigned long)*buf + used);
+	*len -=3D used;
+	kmsg->payloadlen =3D *len;
+	return 0;
+}
+
+struct io_recvmsg_multishot_hdr {
+	struct io_uring_recvmsg_out msg;
+	struct sockaddr_storage addr;
+} __packed;
+
+static int io_recvmsg_multishot(
+	struct socket *sock,
+	struct io_sr_msg *io,
+	struct io_async_msghdr *kmsg,
+	unsigned int flags,
+	bool *finished)
+{
+	int err;
+	int copy_len;
+	struct io_recvmsg_multishot_hdr hdr;
+
+	if (kmsg->namelen)
+		kmsg->msg.msg_name =3D &hdr.addr;
+	kmsg->msg.msg_flags =3D flags & (MSG_CMSG_CLOEXEC|MSG_CMSG_COMPAT);
+	kmsg->msg.msg_namelen =3D 0;
+
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |=3D MSG_DONTWAIT;
+
+	err =3D sock_recvmsg(sock, &kmsg->msg, flags);
+	*finished =3D err <=3D 0;
+	if (err < 0)
+		return err;
+
+	hdr.msg =3D (struct io_uring_recvmsg_out) {
+		.controllen =3D kmsg->controllen - kmsg->msg.msg_controllen,
+		.flags =3D kmsg->msg.msg_flags & ~MSG_CMSG_COMPAT
+	};
+
+	hdr.msg.payloadlen =3D err;
+	if (err > kmsg->payloadlen)
+		err =3D kmsg->payloadlen;
+
+	copy_len =3D sizeof(struct io_uring_recvmsg_out);
+	if (kmsg->msg.msg_namelen > kmsg->namelen)
+		copy_len +=3D kmsg->namelen;
+	else
+		copy_len +=3D kmsg->msg.msg_namelen;
+
+	/*
+	 *      "fromlen shall refer to the value before truncation.."
+	 *                      1003.1g
+	 */
+	hdr.msg.namelen =3D kmsg->msg.msg_namelen;
+
+	/* ensure that there is no gap between hdr and sockaddr_storage */
+	BUILD_BUG_ON(offsetof(struct io_recvmsg_multishot_hdr, addr) !=3D
+		     sizeof(struct io_uring_recvmsg_out));
+	if (copy_to_user(io->buf, &hdr, copy_len)) {
+		*finished =3D true;
+		return -EFAULT;
+	}
+
+	return sizeof(struct io_uring_recvmsg_out) +
+		kmsg->namelen +
+		kmsg->controllen +
+		err;
+}
+
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req);
@@ -527,6 +636,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int iss=
ue_flags)
 	unsigned flags;
 	int ret, min_ret =3D 0;
 	bool force_nonblock =3D issue_flags & IO_URING_F_NONBLOCK;
+	bool multishot_finished =3D true;
=20
 	sock =3D sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -545,16 +655,29 @@ int io_recvmsg(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
=20
+retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
+		size_t len =3D sr->len;
=20
-		buf =3D io_buffer_select(req, &sr->len, issue_flags);
+		buf =3D io_buffer_select(req, &len, issue_flags);
 		if (!buf)
 			return -ENOBUFS;
+
+		if (req->flags & REQ_F_APOLL_MULTISHOT) {
+			ret =3D io_recvmsg_prep_multishot(kmsg, sr,
+							&buf, &len);
+
+			if (ret) {
+				io_kbuf_recycle(req, issue_flags);
+				return ret;
+			}
+		}
+
 		kmsg->fast_iov[0].iov_base =3D buf;
-		kmsg->fast_iov[0].iov_len =3D sr->len;
+		kmsg->fast_iov[0].iov_len =3D len;
 		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov, 1,
-				sr->len);
+				len);
 	}
=20
 	flags =3D sr->msg_flags;
@@ -564,10 +687,22 @@ int io_recvmsg(struct io_kiocb *req, unsigned int i=
ssue_flags)
 		min_ret =3D iov_iter_count(&kmsg->msg.msg_iter);
=20
 	kmsg->msg.msg_get_inq =3D 1;
-	ret =3D __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg, kmsg->uaddr, fla=
gs);
+	if (req->flags & REQ_F_APOLL_MULTISHOT)
+		ret =3D io_recvmsg_multishot(sock, sr, kmsg, flags,
+					   &multishot_finished);
+	else
+		ret =3D __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg, kmsg->uaddr, fl=
ags);
+
 	if (ret < min_ret) {
-		if (ret =3D=3D -EAGAIN && force_nonblock)
-			return io_setup_async_msg(req, kmsg, issue_flags);
+		if (ret =3D=3D -EAGAIN && force_nonblock) {
+			ret =3D io_setup_async_msg(req, kmsg, issue_flags);
+			if (ret =3D=3D -EAGAIN && (req->flags & IO_APOLL_MULTI_POLLED) =3D=3D
+					       IO_APOLL_MULTI_POLLED) {
+				io_kbuf_recycle(req, issue_flags);
+				return IOU_ISSUE_SKIP_COMPLETE;
+			}
+			return ret;
+		}
 		if (ret =3D=3D -ERESTARTSYS)
 			ret =3D -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
@@ -580,11 +715,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int is=
sue_flags)
 		req_set_fail(req);
 	}
=20
-	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
-	io_netmsg_recycle(req, issue_flags);
-	req->flags &=3D ~REQ_F_NEED_CLEANUP;
 	if (ret > 0)
 		ret +=3D sr->done_io;
 	else if (sr->done_io)
@@ -596,8 +726,18 @@ int io_recvmsg(struct io_kiocb *req, unsigned int is=
sue_flags)
 	if (kmsg->msg.msg_inq)
 		cflags |=3D IORING_CQE_F_SOCK_NONEMPTY;
=20
-	io_req_set_res(req, ret, cflags);
-	return IOU_OK;
+	if (!io_recv_finish(req, &ret, cflags, multishot_finished))
+		goto retry_multishot;
+
+	if (multishot_finished) {
+		io_netmsg_recycle(req, issue_flags);
+		/* fast path, check for non-NULL to avoid function call */
+		if (kmsg->free_iov)
+			kfree(kmsg->free_iov);
+		req->flags &=3D ~REQ_F_NEED_CLEANUP;
+	}
+
+	return ret;
 }
=20
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)
@@ -684,7 +824,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_=
flags)
 	if (msg.msg_inq)
 		cflags |=3D IORING_CQE_F_SOCK_NONEMPTY;
=20
-	if (!io_recv_finish(req, &ret, cflags))
+	if (!io_recv_finish(req, &ret, cflags, ret <=3D 0))
 		goto retry_multishot;
=20
 	return ret;
diff --git a/io_uring/net.h b/io_uring/net.h
index 178a6d8b76e0..db20ce9d6546 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -9,6 +9,12 @@
 struct io_async_msghdr {
 	union {
 		struct iovec		fast_iov[UIO_FASTIOV];
+		struct {
+			struct iovec	fast_iov_one;
+			__kernel_size_t	controllen;
+			int		namelen;
+			__kernel_size_t	payloadlen;
+		};
 		struct io_cache_entry	cache;
 	};
 	/* points to an allocated iov, if NULL we use fast_iov instead */
--=20
2.30.2

