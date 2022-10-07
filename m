Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F965F7FCC
	for <lists+io-uring@lfdr.de>; Fri,  7 Oct 2022 23:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJGVU3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 7 Oct 2022 17:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJGVUW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Oct 2022 17:20:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C9DB1FA
        for <io-uring@vger.kernel.org>; Fri,  7 Oct 2022 14:19:49 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297I5iNu008508
        for <io-uring@vger.kernel.org>; Fri, 7 Oct 2022 14:19:49 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k26gy86pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 07 Oct 2022 14:19:48 -0700
Received: from twshared26370.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 14:19:48 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 213B321DB08A5; Fri,  7 Oct 2022 14:19:45 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <io-uring@vger.kernel.org>
Subject: [RFC] liburing: add an example for a TCP/UDP ZC RX server.
Date:   Fri, 7 Oct 2022 14:19:45 -0700
Message-ID: <20221007211945.185583-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: rB6vZ-kps5VwSOtQbuIylMRxVsFe4bOc
X-Proofpoint-ORIG-GUID: rB6vZ-kps5VwSOtQbuIylMRxVsFe4bOc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        SPOOFED_FREEMAIL,SPOOF_GMAIL_MID autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a WIP sample application that demonstrates the use of 
the API in the pevious RFC series.  This is for demonstration
purposes only!

copy io_uring-udp.c and make it handle TCP.

Wire up a simple example of the recvzc opcode.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 examples/Makefile       |   3 +-
 examples/io_uring-net.c | 835 ++++++++++++++++++++++++++++++++++++++++
 src/include/liburing.h  |   3 +
 src/register.c          |  29 ++
 4 files changed, 869 insertions(+), 1 deletion(-)
 create mode 100644 examples/io_uring-net.c

diff --git a/examples/Makefile b/examples/Makefile
index e561e05..c279acf 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -16,7 +16,8 @@ example_srcs := \
 	io_uring-udp.c \
 	link-cp.c \
 	poll-bench.c \
-	send-zerocopy.c
+	send-zerocopy.c \
+	io_uring-net.c
 
 all_targets :=
 
diff --git a/examples/io_uring-net.c b/examples/io_uring-net.c
new file mode 100644
index 0000000..c569437
--- /dev/null
+++ b/examples/io_uring-net.c
@@ -0,0 +1,835 @@
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
+#include <net/if.h>
+#include <error.h>
+
+#include "liburing.h"
+
+#if 0
+/* XXX temp development hack */
+struct io_uring_zctap_iov {
+	__u32	off;
+	__u32	len;
+	__u16	bgid;
+	__u16	bid;
+	__u16	ifq_id;
+	__u16	resv;
+};
+
+#define IORING_OP_PROVIDE_IFQ_REGION	(IORING_OP_URING_CMD + 2)
+#define IORING_OP_RECV_ZC		(IORING_OP_URING_CMD + 3)
+#endif
+
+#define FRAME_REGION_SIZE	(8192 * 4096)
+#define FILL_QUEUE_ENTRIES	4096
+#define COPY_QUEUE_ENTRIES	256
+#define COPY_BUF_SIZE		4096
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
+	struct io_uring_buf_ring *fillq;
+	struct io_uring_buf_ring *copyq;
+	unsigned char *buffer_base;
+	unsigned char *copy_base;
+	unsigned char *frame_base;
+	struct msghdr msg;
+	int buf_shift;
+	int af;
+	int queue_id;
+	int ifq_id;
+	bool verbose;
+	bool udp;
+	char *ifname;
+	struct sendmsg_ctx send[BUFFERS];
+	size_t buf_ring_size;
+	size_t fillq_size;
+	size_t copyq_size;
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
+/* buffer pool for metadata, etc.  BGID 0. */
+static int setup_buffer_pool(struct ctx *ctx)
+{
+	int ret, i;
+	void *mapped;
+	struct io_uring_buf_reg reg;
+
+	/* maps:
+	 *	BUFFER x (struct io_ring_buf)
+	 *	BUFFER x (buffer_size) (4K, by default)
+	 * buffer_ring is first part.
+	 * buffer_base is second part.
+	 *
+	 * register_buf_ring() registers the ring
+	 *
+	 * buffers are then provided:
+	 *   io_uring_buf_ring_add(ring, addr, len, buf_id)
+	 * io_uring_buf_ring_advance(ctx->buf_ring, BUFFERS);
+	 */
+
+	ctx->buf_ring_size = (sizeof(struct io_uring_buf) + buffer_size(ctx)) * BUFFERS;
+	mapped = mmap(NULL, ctx->buf_ring_size, PROT_READ | PROT_WRITE,
+		      MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (mapped == MAP_FAILED) {
+		fprintf(stderr, "buf_ring mmap: %s\n", strerror(errno));
+		return -1;
+	}
+	ctx->buf_ring = (struct io_uring_buf_ring *)mapped;
+
+	io_uring_buf_ring_init(ctx->buf_ring);
+
+	reg = (struct io_uring_buf_reg) {
+		.ring_addr = (unsigned long)ctx->buf_ring,
+		.ring_entries = BUFFERS,
+		.bgid = 0
+	};
+	ctx->buffer_base = (unsigned char *)ctx->buf_ring +
+			   sizeof(struct io_uring_buf) * BUFFERS;
+	printf("metadata base region: %p, group %d\n", ctx->buffer_base, 0);
+
+	ret = io_uring_register_buf_ring(&ctx->ring, &reg, 0);
+	if (ret) {
+		fprintf(stderr, "buf_ring init failed: %s\n"
+				"NB This requires a kernel version >= 6.0\n",
+				strerror(-ret));
+		return ret;
+	}
+
+	for (i = 0; i < BUFFERS; i++) {
+		io_uring_buf_ring_add(ctx->buf_ring, get_buffer(ctx, i), buffer_size(ctx), i,
+				      io_uring_buf_ring_mask(BUFFERS), i);
+	}
+	io_uring_buf_ring_advance(ctx->buf_ring, BUFFERS);
+
+	return 0;
+}
+
+/* fill queue used for returning packet store buffers. BGID 1 */
+static int setup_fill_queue(struct ctx *ctx)
+{
+	struct io_uring_buf_reg reg;
+	void *area;
+	int ret;
+
+	ctx->fillq_size = sizeof(struct io_uring_buf) * FILL_QUEUE_ENTRIES;
+	area = mmap(NULL, ctx->fillq_size, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (area == MAP_FAILED)
+		error(1, errno, "fill queue mmap");
+
+	ctx->fillq = (struct io_uring_buf_ring *)area;
+
+	io_uring_buf_ring_init(ctx->fillq);
+
+	reg = (struct io_uring_buf_reg) {
+		.ring_addr = (unsigned long)ctx->fillq,
+		.ring_entries = FILL_QUEUE_ENTRIES,
+		.bgid = 1,
+	};
+
+	/* flags is unused */
+	ret = io_uring_register_buf_ring(&ctx->ring, &reg, 0);
+	if (ret) {
+		error(0, -ret, "fillq register failed");
+		fprintf(stderr, "NB This requires a kernel version >= 6.0\n");
+		exit(1);
+	}
+
+	return 0;
+}
+
+/* copy pool for system pages, BGID 2 */
+static int setup_copy_pool(struct ctx *ctx)
+{
+	struct io_uring_buf_reg reg;
+	void *area;
+	int i, ret;
+
+	ctx->copyq_size = (sizeof(struct io_uring_buf) + COPY_BUF_SIZE) *
+			  COPY_QUEUE_ENTRIES;
+	area = mmap(NULL, ctx->copyq_size, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (area == MAP_FAILED)
+		error(1, errno, "coyp queue mmap");
+
+	ctx->copyq = (struct io_uring_buf_ring *)area;
+
+	io_uring_buf_ring_init(ctx->copyq);
+
+	reg = (struct io_uring_buf_reg) {
+		.ring_addr = (unsigned long)ctx->copyq,
+		.ring_entries = COPY_QUEUE_ENTRIES,
+		.bgid = 2,
+	};
+
+	/* flags is unused */
+	ret = io_uring_register_buf_ring(&ctx->ring, &reg, 0);
+	if (ret)
+		error(1, -ret, "copyq ring register failed");
+
+	area += sizeof(struct io_uring_buf) * COPY_QUEUE_ENTRIES;
+	ctx->copy_base = area;
+	printf("copy base region: %p, group %d\n", area, 2);
+
+	for (i = 0; i < COPY_QUEUE_ENTRIES; i++) {
+		io_uring_buf_ring_add(ctx->copyq, area + i * COPY_BUF_SIZE,
+			COPY_BUF_SIZE, i,
+			io_uring_buf_ring_mask(COPY_QUEUE_ENTRIES), i);
+	}
+	io_uring_buf_ring_advance(ctx->copyq, COPY_QUEUE_ENTRIES);
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
+	params.cq_entries = QD * 8;
+	params.flags = IORING_SETUP_SUBMIT_ALL | IORING_SETUP_COOP_TASKRUN |
+		       IORING_SETUP_CQSIZE;
+
+	ret = io_uring_queue_init_params(QD, &ctx->ring, &params);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init failed: %s\n"
+				"NB: This requires a kernel version >= 6.0\n",
+				strerror(-ret));
+		return ret;
+	}
+
+	ret = setup_buffer_pool(ctx);
+	if (ret)
+		io_uring_queue_exit(&ctx->ring);
+
+	memset(&ctx->msg, 0, sizeof(ctx->msg));
+	ctx->msg.msg_namelen = sizeof(struct sockaddr_storage);
+	ctx->msg.msg_controllen = CONTROLLEN;
+	return ret;
+}
+
+static int setup_sock(struct ctx *ctx, int port)
+{
+	int ret;
+	int fd;
+	uint16_t nport = port <= 0 ? 0 : htons(port);
+	int one = 1;
+	int flags = 0; /* SOCK_NONBLOCK */
+
+	if (ctx->udp)
+		fd = socket(ctx->af, SOCK_DGRAM | flags, IPPROTO_UDP);
+	else
+		fd = socket(ctx->af, SOCK_STREAM | flags, IPPROTO_TCP);
+	if (fd < 0) {
+		fprintf(stderr, "sock_init: %s\n", strerror(errno));
+		return -1;
+	}
+
+	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));
+	if (ret) {
+		fprintf(stderr, "setsockopt: %s\n", strerror(errno));
+		close(fd);
+		return -1;
+	}
+
+	if (ctx->af == AF_INET6) {
+		struct sockaddr_in6 addr6 = {
+			.sin6_family = ctx->af,
+			.sin6_port = nport,
+			.sin6_addr = IN6ADDR_ANY_INIT
+		};
+
+		ret = bind(fd, (struct sockaddr *) &addr6, sizeof(addr6));
+	} else {
+		struct sockaddr_in addr = {
+			.sin_family = ctx->af,
+			.sin_port = nport,
+			.sin_addr = { INADDR_ANY }
+		};
+
+		ret = bind(fd, (struct sockaddr *) &addr, sizeof(addr));
+	}
+
+	if (ret) {
+		fprintf(stderr, "sock_bind: %s\n", strerror(errno));
+		close(fd);
+		return -1;
+	}
+
+	if (port <= 0) {
+		int port;
+		struct sockaddr_storage s;
+		socklen_t sz = sizeof(s);
+
+		if (getsockname(fd, (struct sockaddr *)&s, &sz)) {
+			fprintf(stderr, "getsockname failed\n");
+			close(fd);
+			return -1;
+		}
+
+		port = ntohs(((struct sockaddr_in *)&s)->sin_port);
+		fprintf(stderr, "port bound to %d\n", port);
+	}
+
+	if (!ctx->udp) {
+		ret = listen(fd, 1);
+		if (ret) {
+			fprintf(stderr, "listen: %s\n", strerror(errno));
+			close(fd);
+			return -1;
+		}
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
+	*sqe = io_uring_get_sqe(&ctx->ring);
+
+	if (!*sqe) {
+		io_uring_submit(&ctx->ring);
+		*sqe = io_uring_get_sqe(&ctx->ring);
+	}
+	if (!*sqe) {
+		fprintf(stderr, "cannot get sqe\n");
+		return true;
+	}
+	return false;
+}
+
+static int wait_accept(struct ctx *ctx, int fd, int *clientfd)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	if (get_sqe(ctx, &sqe))
+		return -1;
+
+	io_uring_prep_accept(sqe, fd, NULL, NULL, 0);
+	ret = io_uring_submit(&ctx->ring);
+	if (ret == -1) {
+		fprintf(stderr, "cannot submit accept\n");
+		return true;
+	}
+
+	ret = io_uring_wait_cqe(&ctx->ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "accept wait_cqe\n");
+		return true;
+	}
+	*clientfd = cqe->res;
+	io_uring_cqe_seen(&ctx->ring, cqe);
+
+	return false;
+}
+
+/* adds one SQE for RECVMSG, as multishot */
+static int add_recv(struct ctx *ctx, int idx)
+{
+	struct io_uring_sqe *sqe;
+
+	if (get_sqe(ctx, &sqe))
+		return -1;
+
+	io_uring_prep_recvmsg_multishot(sqe, idx, &ctx->msg, MSG_TRUNC);
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	sqe->flags |= IOSQE_BUFFER_SELECT;
+	sqe->buf_group = 1;
+	io_uring_sqe_set_data64(sqe, BUFFERS + 1);
+	return 0;
+}
+
+static void recycle_buffer(struct ctx *ctx, int idx)
+{
+	io_uring_buf_ring_add(ctx->buf_ring, get_buffer(ctx, idx), buffer_size(ctx), idx,
+			      io_uring_buf_ring_mask(BUFFERS), 0);
+	io_uring_buf_ring_advance(ctx->buf_ring, 1);
+}
+
+static int process_cqe_send(struct ctx *ctx, struct io_uring_cqe *cqe)
+{
+	int idx = cqe->user_data;
+
+	if (cqe->res < 0)
+		fprintf(stderr, "bad send %s\n", strerror(-cqe->res));
+	recycle_buffer(ctx, idx);
+	return 0;
+}
+
+static void
+hex_dump(void *data, size_t length, uint64_t addr)
+{
+	const unsigned char *address = data;
+	const unsigned char *line = address;
+	size_t line_size = 16;
+	unsigned char c;
+	char buf[32];
+	int i = 0;
+
+	sprintf(buf, "addr=0x%lx", addr);
+	printf("length = %zu\n", length);
+	printf("%s | ", buf);
+	while (length-- > 0) {
+		printf("%02X ", *address++);
+		if (!(++i % line_size) || (length == 0 && i % line_size)) {
+			if (length == 0) {
+				while (i++ % line_size)
+					printf("__ ");
+			}
+			printf(" | ");	/* right close */
+			while (line < address) {
+				c = *line++;
+				printf("%c", (c < 33 || c == 255) ? 0x2E : c);
+			}
+			printf("\n");
+			if (length > 0)
+				printf("%s | ", buf);
+		}
+	}
+	printf("\n");
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
+		ret = add_recv(ctx, fdidx);
+		if (ret)
+			return ret;
+	}
+
+	if (cqe->res == -ENOBUFS)
+		return 0;
+
+	if (!(cqe->flags & IORING_CQE_F_BUFFER) || cqe->res < 0) {
+		fprintf(stderr, "recv cqe bad res %d\n", cqe->res);
+		if (cqe->res == -EFAULT || cqe->res == -EINVAL)
+			fprintf(stderr,
+				"NB: This requires a kernel version >= 6.0\n");
+		return -1;
+	}
+	idx = cqe->flags >> 16;
+
+	/* at the moment, 'res' returned here is # of bytes read */
+	printf("user_data: %llx\n", cqe->user_data);
+	printf("res (error/buflen): %d\n", cqe->res);
+	printf("flags: %x\n", cqe->flags);
+
+	{
+		struct io_uring_zctap_iov *zov;
+		void *base, *addr;
+		int count, total;
+		int i;
+
+		/* cqe flags contains the buffer index */
+		addr = get_buffer(ctx, cqe->flags >> 16);
+
+		count = cqe->res / sizeof(*zov);
+		total = 0;
+		zov = addr;
+		for (i = 0; i < count; i++)
+			total += zov[i].len;
+
+		printf("Buffer address: %p\n", addr);
+		printf("data length: %d, vectors:%d\n", total, count);
+		hex_dump(addr, cqe->res, 0);
+
+		for (i = 0; i < count; i++) {
+			printf("%d: q:%d g:%d id:%d off:%d len:%d\n",
+				i, zov[i].ifq_id, zov[i].bgid, zov[i].bid,
+				zov[i].off, zov[i].len);
+			if (zov->bgid == 2) {
+				base = ctx->copy_base;
+				addr = base + zov[i].bid * COPY_BUF_SIZE;
+			} else {
+				/* should be frame area, PAGE_SIZE */
+				base = ctx->copy_base;
+				addr = base + zov[i].bid * PAGE_SIZE;
+			}
+			printf("ADDR: %p\n", addr + zov[i].off);
+			hex_dump(addr + zov[i].off, zov[i].len, i);
+		}
+	}
+
+
+	printf("exiting!\n");
+	exit(1);
+
+
+#if 0
+	o = io_uring_recvmsg_validate(get_buffer(ctx, cqe->flags >> 16),
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
+		r = io_uring_recvmsg_payload_length(o, cqe->res, &ctx->msg);
+		fprintf(stderr, "truncated msg need %u received %u\n",
+				o->payloadlen, r);
+		recycle_buffer(ctx, idx);
+		return 0;
+	}
+
+	if (io_uring_recvmsg_payload_length(o, cqe->res, &ctx->msg) == 0) {
+		fprintf(stderr, "0 byte recv, assuming EOF.\n");
+		return -1;
+	}
+
+	if (ctx->verbose) {
+		char buff[INET6_ADDRSTRLEN + 1];
+		const char *name;
+		struct sockaddr_in *addr = io_uring_recvmsg_name(o);
+
+		name = inet_ntop(ctx->af, addr, buff, sizeof(buff));
+		if (!name)
+			name = "<INVALID>";
+		fprintf(stderr, "received %u bytes %d from %s:%d\n",
+			io_uring_recvmsg_payload_length(o, cqe->res, &ctx->msg),
+			o->namelen, name, (int)ntohs(addr->sin_port));
+	}
+
+	if (get_sqe(ctx, &sqe))
+		return -1;
+
+	ctx->send[idx].iov = (struct iovec) {
+		.iov_base = io_uring_recvmsg_payload(o, &ctx->msg),
+		.iov_len =
+			io_uring_recvmsg_payload_length(o, cqe->res, &ctx->msg)
+	};
+	ctx->send[idx].msg = (struct msghdr) {
+		.msg_namelen = o->namelen,
+		.msg_name = io_uring_recvmsg_name(o),
+		.msg_control = NULL,
+		.msg_controllen = 0,
+		.msg_iov = &ctx->send[idx].iov,
+		.msg_iovlen = 1
+	};
+
+	io_uring_prep_sendmsg(sqe, fdidx, &ctx->send[idx].msg, 0);
+	io_uring_sqe_set_data64(sqe, idx);
+	sqe->flags |= IOSQE_FIXED_FILE;
+#endif
+
+	return 0;
+}
+
+static int process_cqe(struct ctx *ctx, struct io_uring_cqe *cqe, int fdidx)
+{
+	if (cqe->user_data < BUFFERS)
+		return process_cqe_send(ctx, cqe);
+	else
+		return process_cqe_recv(ctx, cqe, fdidx);
+}
+
+int
+io_zctap_ifq(struct ctx *ctx)
+{
+	__u16 qid, ifq_id;
+	int ifindex, bgid;
+	int ret;
+
+	/* API for register_ifq:
+	 *  ifindex	- network device index
+	 *  qid		- desired/targeted qid
+	 *  ifq_id	- GLOBAL io_uring ifq number.
+	 *  bgid	- fill queue id
+	 */
+
+	bgid = 1;
+	qid = ctx->queue_id;
+
+	ifindex = if_nametoindex(ctx->ifname);
+	if (!ifindex) {
+		fprintf(stderr, "Interface %s does not exist\n", ctx->ifname);
+		return -1;
+	}
+	ret = io_uring_register_ifq(&ctx->ring, ifindex, &qid, &ifq_id, bgid);
+
+	if (ret) {
+		fprintf(stderr, "register_ifq failed: %s\n", strerror(-ret));
+		return -1;
+	}
+	fprintf(stderr, "registered ifq:%d, qid:%d  r=%d\n", ifq_id, qid, ret);
+	ctx->queue_id = qid;
+	ctx->ifq_id = ifq_id;
+	return ret;
+}
+
+static void
+io_complete_sqe(struct io_uring *ring, struct io_uring_sqe *sqe,
+		const char *what)
+{
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	ret = io_uring_submit(ring);
+	if (ret < 0)
+		error(1, -ret, "submit failed");
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret)
+		error(1, -ret, "wait_cqe failed");
+
+	if (cqe->res < 0)
+		error(1, -cqe->res, "Bad SQE '%s'", what);
+
+	io_uring_cqe_seen(ring, cqe);
+}
+
+/* submits a SQE for provide region */
+int io_provide_region(struct ctx *ctx)
+{
+	struct io_uring_sqe *sqe;
+	struct iovec iov;
+	void *area;
+	int ret;
+
+	area = mmap(NULL, FRAME_REGION_SIZE, PROT_READ | PROT_WRITE,
+		      MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (area == MAP_FAILED)
+		error(1, errno, "frame_region mmap");
+
+	/* register (mmap) this buffer area with the kernel */
+	printf("frame base region: %p, group %d\n", area, 0);
+	ctx->frame_base = area;
+
+	iov.iov_base = area;
+	iov.iov_len = FRAME_REGION_SIZE;
+	ret = io_uring_register_buffers(&ctx->ring, &iov, 1);
+	if (ret)
+		error(1, -ret, "register_buffers");
+
+	if (get_sqe(ctx, &sqe))
+		return -1;
+
+	/* API for provide_ifq_region:
+	 *  fd		= ifq_id identifier
+	 *  area	= mmap'd area
+	 *  len		= length of area
+	 *
+	 * area/len refer to a previously mapped buffer area
+	 */
+	io_uring_prep_rw(IORING_OP_PROVIDE_IFQ_REGION, sqe, ctx->ifq_id,
+			 area, FRAME_REGION_SIZE, 0);
+
+	/* buf_group -> buf_index, selects from user_bufs */
+	sqe->flags |= IOSQE_BUFFER_SELECT;
+	sqe->buf_group = 0;
+
+	io_uring_sqe_set_data64(sqe, BUFFERS + 1);
+
+	io_complete_sqe(&ctx->ring, sqe, "ifq region");
+
+	return 0;
+}
+
+/* adds one SQE for RECVZC */
+static int add_recvzc(struct ctx *ctx, int idx_sockfd)
+{
+	struct io_uring_sqe *sqe;
+	__u64 readlen, copy_bgid;
+
+	if (get_sqe(ctx, &sqe))
+		return -1;
+
+	/* API for RECV_ZC:
+	 *  fd		= sockfd (or registered file index)
+	 *  addr/len	= immediate metadata buffer.
+	 *		  not used if BUFFER_SELECT flag is set.
+	 *  buf_group	= group to obtain metadata buffer if BUFFER_SELECT.
+	 *  ioprio	= io_uring recvmsg flags (aka MULTISHOT)
+	 *  msg_flags	= recvmsg flags (MSG_DONTWAIT, etc)
+	 *  addr3	= <32>data_len | <16>copy_bgid | <ifq_id> 
+	 */
+
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, idx_sockfd, NULL, 0, 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	sqe->flags |= IOSQE_BUFFER_SELECT;
+	sqe->buf_group = 0;
+
+	readlen = 800000;
+	copy_bgid = 2;
+	sqe->addr3 = (readlen << 32) | (copy_bgid << 16) | ctx->ifq_id;
+
+	io_uring_sqe_set_data64(sqe, BUFFERS + 1);
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct ctx ctx = {
+		.af		= AF_INET6,
+		.buf_shift	= BUF_SHIFT,
+		.ifname		= "eth0",
+		.queue_id	= -1,
+	};
+	int ret;
+	int port = -1;
+	int sockfd, clientfd;
+	int opt;
+	struct io_uring_cqe *cqes[CQES];
+	unsigned int count, i;
+
+	while ((opt = getopt(argc, argv, "46b:i:p:q:uv")) != -1) {
+		switch (opt) {
+		case '4':
+			ctx.af = AF_INET;
+			break;
+		case '6':
+			ctx.af = AF_INET6;
+			break;
+		case 'b':
+			ctx.buf_shift = atoi(optarg);
+			break;
+		case 'i':
+			ctx.ifname = optarg;
+			break;
+		case 'p':
+			port = atoi(optarg);
+			break;
+		case 'q':
+			ctx.queue_id = atoi(optarg);
+			break;
+		case 'u':
+			ctx.udp = true;
+			break;
+		case 'v':
+			ctx.verbose = true;
+			break;
+		default:
+			fprintf(stderr, "Usage: %s [-4] [-6] [-p port] [-u] "
+					"[-i ifname] [-q queue_id] "
+					"[-b log2(BufferSize)] [-v]\n",
+					argv[0]);
+			exit(-1);
+		}
+	}
+
+	if (ctx.verbose) {
+		fprintf(stderr, "%s %s\n", 
+			ctx.af == AF_INET ? "IPv4" : "IPv6",
+			ctx.udp ? "UDP" : "TCP");
+	}
+
+	sockfd = setup_sock(&ctx, port);
+	if (sockfd < 0)
+		return 1;
+
+	if (setup_context(&ctx)) {
+		close(sockfd);
+		return 1;
+	}
+
+	ret = setup_fill_queue(&ctx);
+	if (ret)
+		return 1;
+
+	ret = io_zctap_ifq(&ctx);
+	if (ret)
+		return 1;
+
+	ret = io_provide_region(&ctx);
+	if (ret)
+		return 1;
+
+	ret = setup_copy_pool(&ctx);
+	if (ret)
+		return 1;
+
+	clientfd = sockfd;
+	if (!ctx.udp) {
+		ret = wait_accept(&ctx, sockfd, &clientfd);
+		if (ret) {
+			fprintf(stderr, "wait_accept: %s\n", strerror(-ret));
+			return -1;
+		}
+	}
+
+	/* optimization: register clientfd as file 0, avoiding lookups */
+	ret = io_uring_register_files(&ctx.ring, &clientfd, 1);
+	if (ret) {
+		fprintf(stderr, "register files: %s\n", strerror(-ret));
+		return -1;
+	}
+
+//	ret = add_recv(&ctx, 0);
+	ret = add_recvzc(&ctx, 0);
+	if (ret)
+		return 1;
+
+	while (true) {
+		ret = io_uring_submit_and_wait(&ctx.ring, 1);
+		if (ret == -EINTR)
+			continue;
+		if (ret < 0) {
+			fprintf(stderr, "submit and wait failed %d\n", ret);
+			break;
+		}
+
+		count = io_uring_peek_batch_cqe(&ctx.ring, &cqes[0], CQES);
+		for (i = 0; i < count; i++) {
+			ret = process_cqe(&ctx, cqes[i], 0);
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
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 902f26a..d8aa6dc 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -235,6 +235,9 @@ int io_uring_register_sync_cancel(struct io_uring *ring,
 int io_uring_register_file_alloc_range(struct io_uring *ring,
 					unsigned off, unsigned len);
 
+int io_uring_register_ifq(struct io_uring *ring, int ifindex,
+			  __u16 *queue_id, __u16 *ifq_id, __u16 bgid);
+
 int io_uring_get_events(struct io_uring *ring);
 int io_uring_submit_and_get_events(struct io_uring *ring);
 
diff --git a/src/register.c b/src/register.c
index 0a2e5af..283a9f0 100644
--- a/src/register.c
+++ b/src/register.c
@@ -364,3 +364,32 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 				       IORING_REGISTER_FILE_ALLOC_RANGE, &range,
 				       0);
 }
+
+#if 0 /* XXX temp development hack */
+#define IORING_REGISTER_IFQ		26
+
+struct io_uring_ifq_req {
+	__u32	ifindex;
+	__u16	queue_id;
+	__u16	ifq_id;
+	__u16	fill_bgid;
+        __u16   __pad[3];
+};
+#endif
+
+int io_uring_register_ifq(struct io_uring *ring, int ifindex,
+			  __u16 *queue_id, __u16 *ifq_id, __u16 bgid)
+{
+	struct io_uring_ifq_req reg = {
+		.ifindex = ifindex,
+		.queue_id = *queue_id,
+		.fill_bgid = bgid,
+	};
+	int ret;
+
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_IFQ,
+				      &reg, 1);
+	*queue_id = reg.queue_id;
+	*ifq_id = reg.ifq_id;
+	return ret;
+}
-- 
2.30.2

