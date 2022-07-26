Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADA35812F2
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 14:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbiGZMPg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 08:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiGZMPf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 08:15:35 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7CB2ED79
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:33 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26Q0rSae010441
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=KWO59xWjmoMjIP0ziR38WUBHz1/YaIRPfNVrsyBGP5I=;
 b=NT6fOEvx65S4D2dHbepJwFZ9Tstg7qGlhazsY1XYC2NkeMinTahMjhaOo4vYGpb+jl13
 /SK3PYil12n/rzAfEQkymoMjxenmz2Q7PSx16fwDpGhKaMrHQS1xKyfLnXS6lNYcnnOq
 wlH/e4SrYCHE6j7mcyrSzL2X7xm87uttqEg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hhxbwny67-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 05:15:32 -0700
Received: from twshared1866.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 05:15:28 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 2AA78397A794; Tue, 26 Jul 2022 05:15:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 5/5] add an example for a UDP server
Date:   Tue, 26 Jul 2022 05:15:02 -0700
Message-ID: <20220726121502.1958288-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220726121502.1958288-1-dylany@fb.com>
References: <20220726121502.1958288-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 1O7wJvfi9Cxft5KXygYuVqZNLUamF3nq
X-Proofpoint-ORIG-GUID: 1O7wJvfi9Cxft5KXygYuVqZNLUamF3nq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_04,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add an example showing off multishot recvmsg and provided buffer rings.
The application is a UDP echo server that responds to all packets with th=
e
same packet.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 .gitignore              |   1 +
 examples/Makefile       |   1 +
 examples/io_uring-udp.c | 388 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 390 insertions(+)
 create mode 100644 examples/io_uring-udp.c

diff --git a/.gitignore b/.gitignore
index b5acffd68c95..7853dbdf1a97 100644
--- a/.gitignore
+++ b/.gitignore
@@ -13,6 +13,7 @@
=20
 /examples/io_uring-cp
 /examples/io_uring-test
+/examples/io_uring-udp
 /examples/link-cp
 /examples/ucontext-cp
=20
diff --git a/examples/Makefile b/examples/Makefile
index 1997a31dcc08..e561e05c1785 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -13,6 +13,7 @@ endif
 example_srcs :=3D \
 	io_uring-cp.c \
 	io_uring-test.c \
+	io_uring-udp.c \
 	link-cp.c \
 	poll-bench.c \
 	send-zerocopy.c
diff --git a/examples/io_uring-udp.c b/examples/io_uring-udp.c
new file mode 100644
index 000000000000..77472df3d224
--- /dev/null
+++ b/examples/io_uring-udp.c
@@ -0,0 +1,388 @@
+/* SPDX-License-Identifier: MIT */
+
+#include <stdio.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/mman.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/udp.h>
+#include <arpa/inet.h>
+
+#include "liburing.h"
+
+#define QD 64
+#define BUF_SHIFT 12 /* 4k */
+#define CQES (QD * 16)
+#define BUFFERS CQES
+#define CONTROLLEN 0
+
+struct sendmsg_ctx {
+	struct msghdr msg;
+	struct iovec iov;
+};
+
+struct ctx {
+	struct io_uring ring;
+	struct io_uring_buf_ring *buf_ring;
+	unsigned char *buffer_base;
+	struct msghdr msg;
+	int buf_shift;
+	int af;
+	bool verbose;
+	struct sendmsg_ctx send[BUFFERS];
+	size_t buf_ring_size;
+};
+
+static size_t buffer_size(struct ctx *ctx)
+{
+	return 1U << ctx->buf_shift;
+}
+
+static unsigned char *get_buffer(struct ctx *ctx, int idx)
+{
+	return ctx->buffer_base + (idx << ctx->buf_shift);
+}
+
+static int setup_buffer_pool(struct ctx *ctx)
+{
+	int ret, i;
+	void *mapped;
+	struct io_uring_buf_reg reg =3D { .ring_addr =3D 0,
+					.ring_entries =3D BUFFERS,
+					.bgid =3D 0 };
+
+	ctx->buf_ring_size =3D (sizeof(struct io_uring_buf) + buffer_size(ctx))=
 * BUFFERS;
+	mapped =3D mmap(NULL, ctx->buf_ring_size, PROT_READ | PROT_WRITE,
+		      MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (mapped =3D=3D MAP_FAILED) {
+		fprintf(stderr, "buf_ring mmap: %s\n", strerror(errno));
+		return -1;
+	}
+	ctx->buf_ring =3D (struct io_uring_buf_ring *)mapped;
+
+	io_uring_buf_ring_init(ctx->buf_ring);
+
+	reg =3D (struct io_uring_buf_reg) {
+		.ring_addr =3D (unsigned long)ctx->buf_ring,
+		.ring_entries =3D BUFFERS,
+		.bgid =3D 0
+	};
+	ctx->buffer_base =3D (unsigned char *)ctx->buf_ring +
+			   sizeof(struct io_uring_buf) * BUFFERS;
+
+	ret =3D io_uring_register_buf_ring(&ctx->ring, &reg, 0);
+	if (ret) {
+		fprintf(stderr, "buf_ring init: %s\n", strerror(-ret));
+		return ret;
+	}
+
+	for (i =3D 0; i < BUFFERS; i++) {
+		io_uring_buf_ring_add(ctx->buf_ring, get_buffer(ctx, i), buffer_size(c=
tx), i,
+				      io_uring_buf_ring_mask(BUFFERS), i);
+	}
+	io_uring_buf_ring_advance(ctx->buf_ring, BUFFERS);
+
+	return 0;
+}
+
+static int setup_context(struct ctx *ctx)
+{
+	struct io_uring_params params;
+	int ret;
+
+	memset(&params, 0, sizeof(params));
+	params.cq_entries =3D QD * 8;
+	params.flags =3D IORING_SETUP_SUBMIT_ALL | IORING_SETUP_COOP_TASKRUN |
+		       IORING_SETUP_CQSIZE;
+
+	ret =3D io_uring_queue_init_params(QD, &ctx->ring, &params);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return ret;
+	}
+
+	ret =3D setup_buffer_pool(ctx);
+	if (ret)
+		io_uring_queue_exit(&ctx->ring);
+
+	memset(&ctx->msg, 0, sizeof(ctx->msg));
+	ctx->msg.msg_namelen =3D sizeof(struct sockaddr_storage);
+	ctx->msg.msg_controllen =3D CONTROLLEN;
+	return ret;
+}
+
+static int setup_sock(int af, int port)
+{
+	int ret;
+	int fd;
+	uint16_t nport =3D port <=3D 0 ? 0 : htons(port);
+
+	fd =3D socket(af, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		fprintf(stderr, "sock_init: %s\n", strerror(errno));
+		return -1;
+	}
+
+	if (af =3D=3D AF_INET6) {
+		struct sockaddr_in6 addr6 =3D {
+			.sin6_family =3D af,
+			.sin6_port =3D nport,
+			.sin6_addr =3D IN6ADDR_ANY_INIT
+		};
+
+		ret =3D bind(fd, &addr6, sizeof(addr6));
+	} else {
+		struct sockaddr_in addr =3D {
+			.sin_family =3D af,
+			.sin_port =3D nport,
+			.sin_addr =3D { INADDR_ANY }
+		};
+
+		ret =3D bind(fd, &addr, sizeof(addr));
+	}
+
+	if (ret) {
+		fprintf(stderr, "sock_bind: %s\n", strerror(errno));
+		close(fd);
+		return -1;
+	}
+
+	if (port <=3D 0) {
+		int port;
+		struct sockaddr_storage s;
+		socklen_t sz =3D sizeof(s);
+
+		if (getsockname(fd, (struct sockaddr *)&s, &sz)) {
+			fprintf(stderr, "getsockname failed\n");
+			close(fd);
+			return -1;
+		}
+
+		port =3D ntohs(((struct sockaddr_in *)&s)->sin_port);
+		fprintf(stderr, "port bound to %d\n", port);
+	}
+
+	return fd;
+}
+
+static void cleanup_context(struct ctx *ctx)
+{
+	munmap(ctx->buf_ring, ctx->buf_ring_size);
+	io_uring_queue_exit(&ctx->ring);
+}
+
+static bool get_sqe(struct ctx *ctx, struct io_uring_sqe **sqe)
+{
+	*sqe =3D io_uring_get_sqe(&ctx->ring);
+
+	if (!*sqe) {
+		io_uring_submit(&ctx->ring);
+		*sqe =3D io_uring_get_sqe(&ctx->ring);
+	}
+	if (!*sqe) {
+		fprintf(stderr, "cannot get sqe\n");
+		return true;
+	}
+	return false;
+}
+
+static int add_recv(struct ctx *ctx, int idx)
+{
+	struct io_uring_sqe *sqe;
+
+	if (get_sqe(ctx, &sqe))
+		return -1;
+
+	io_uring_prep_recvmsg_multishot(sqe, idx, &ctx->msg, MSG_TRUNC);
+	sqe->flags |=3D IOSQE_FIXED_FILE;
+
+	sqe->flags |=3D IOSQE_BUFFER_SELECT;
+	sqe->buf_group =3D 0;
+	io_uring_sqe_set_data64(sqe, BUFFERS + 1);
+	return 0;
+}
+
+static void recycle_buffer(struct ctx *ctx, int idx)
+{
+	io_uring_buf_ring_add(ctx->buf_ring, get_buffer(ctx, idx), buffer_size(=
ctx), idx,
+			      io_uring_buf_ring_mask(BUFFERS), 0);
+	io_uring_buf_ring_advance(ctx->buf_ring, 1);
+}
+
+static int process_cqe_send(struct ctx *ctx, struct io_uring_cqe *cqe)
+{
+	int idx =3D cqe->user_data;
+
+	if (cqe->res < 0)
+		fprintf(stderr, "bad send %s\n", strerror(-cqe->res));
+	recycle_buffer(ctx, idx);
+	return 0;
+}
+
+static int process_cqe_recv(struct ctx *ctx, struct io_uring_cqe *cqe,
+			    int fdidx)
+{
+	int ret, idx;
+	struct io_uring_recvmsg_out *o;
+	struct io_uring_sqe *sqe;
+
+	if (!(cqe->flags & IORING_CQE_F_MORE)) {
+		ret =3D add_recv(ctx, fdidx);
+		if (ret)
+			return ret;
+	}
+
+	if (cqe->res =3D=3D -ENOBUFS)
+		return 0;
+
+	if (!(cqe->flags & IORING_CQE_F_BUFFER) || cqe->res < 0) {
+		fprintf(stderr, "bad res %d\n", cqe->res);
+		return -1;
+	}
+	idx =3D cqe->flags >> 16;
+
+	o =3D io_uring_recvmsg_validate(get_buffer(ctx, cqe->flags >> 16),
+				      cqe->res, &ctx->msg);
+	if (!o) {
+		fprintf(stderr, "bad recvmsg\n");
+		return -1;
+	}
+	if (o->namelen > ctx->msg.msg_namelen) {
+		fprintf(stderr, "truncated name\n");
+		recycle_buffer(ctx, idx);
+		return 0;
+	}
+	if (o->flags & MSG_TRUNC) {
+		unsigned int r;
+
+		r =3D io_uring_recvmsg_payload_length(o, cqe->res, &ctx->msg);
+		fprintf(stderr, "truncated msg need %u received %u\n",
+				o->payloadlen, r);
+		recycle_buffer(ctx, idx);
+		return 0;
+	}
+
+	if (ctx->verbose) {
+		char buff[INET6_ADDRSTRLEN + 1];
+		const char *name;
+		struct sockaddr_in *addr =3D io_uring_recvmsg_name(o);
+
+		name =3D inet_ntop(ctx->af, addr, buff, sizeof(buff));
+		if (!name)
+			name =3D "<INVALID>";
+		fprintf(stderr, "received %u bytes %d from %s:%d\n",
+			io_uring_recvmsg_payload_length(o, cqe->res, &ctx->msg),
+			o->namelen, name, (int)ntohs(addr->sin_port));
+	}
+
+	if (get_sqe(ctx, &sqe))
+		return -1;
+
+	ctx->send[idx].iov =3D (struct iovec) {
+		.iov_base =3D io_uring_recvmsg_payload(o, &ctx->msg),
+		.iov_len =3D
+			io_uring_recvmsg_payload_length(o, cqe->res, &ctx->msg)
+	};
+	ctx->send[idx].msg =3D (struct msghdr) {
+		.msg_namelen =3D o->namelen,
+		.msg_name =3D io_uring_recvmsg_name(o),
+		.msg_control =3D NULL,
+		.msg_controllen =3D 0,
+		.msg_iov =3D &ctx->send[idx].iov,
+		.msg_iovlen =3D 1
+	};
+
+	io_uring_prep_sendmsg(sqe, fdidx, &ctx->send[idx].msg, 0);
+	io_uring_sqe_set_data64(sqe, idx);
+	sqe->flags |=3D IOSQE_FIXED_FILE;
+
+	return 0;
+}
+static int process_cqe(struct ctx *ctx, struct io_uring_cqe *cqe, int fd=
idx)
+{
+	if (cqe->user_data < BUFFERS)
+		return process_cqe_send(ctx, cqe);
+	else
+		return process_cqe_recv(ctx, cqe, fdidx);
+}
+
+int main(int argc, char *argv[])
+{
+	struct ctx ctx;
+	int ret;
+	int port =3D -1;
+	int sockfd;
+	int opt;
+	struct io_uring_cqe *cqes[CQES];
+	unsigned int count, i;
+
+	memset(&ctx, 0, sizeof(ctx));
+	ctx.verbose =3D false;
+	ctx.af =3D AF_INET;
+	ctx.buf_shift =3D BUF_SHIFT;
+
+	while ((opt =3D getopt(argc, argv, "6vp:b:")) !=3D -1) {
+		switch (opt) {
+		case '6':
+			ctx.af =3D AF_INET6;
+			break;
+		case 'p':
+			port =3D atoi(optarg);
+			break;
+		case 'b':
+			ctx.buf_shift =3D atoi(optarg);
+			break;
+		case 'v':
+			ctx.verbose =3D true;
+			break;
+		default:
+			fprintf(stderr, "Usage: %s [-p port] "
+					"[-b log2(BufferSize)] [-6] [-v]\n",
+					argv[0]);
+			exit(-1);
+		}
+	}
+
+	sockfd =3D setup_sock(ctx.af, port);
+	if (sockfd < 0)
+		return 1;
+
+	if (setup_context(&ctx)) {
+		close(sockfd);
+		return 1;
+	}
+
+	ret =3D io_uring_register_files(&ctx.ring, &sockfd, 1);
+	if (ret) {
+		fprintf(stderr, "register files: %s\n", strerror(-ret));
+		return -1;
+	}
+
+	ret =3D add_recv(&ctx, 0);
+	if (ret)
+		return 1;
+
+	while (true) {
+		ret =3D io_uring_submit_and_wait(&ctx.ring, 1);
+		if (ret =3D=3D -EINTR)
+			continue;
+		if (ret < 0) {
+			fprintf(stderr, "submit and wait failed %d\n", ret);
+			break;
+		}
+
+		count =3D io_uring_peek_batch_cqe(&ctx.ring, &cqes[0], CQES);
+		for (i =3D 0; i < count; i++) {
+			ret =3D process_cqe(&ctx, cqes[i], 0);
+			if (ret)
+				goto cleanup;
+		}
+		io_uring_cq_advance(&ctx.ring, count);
+	}
+
+cleanup:
+	cleanup_context(&ctx);
+	close(sockfd);
+	return ret;
+}
--=20
2.30.2

