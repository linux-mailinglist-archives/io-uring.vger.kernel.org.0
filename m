Return-Path: <io-uring+bounces-13611-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id p/Y2AbSwImq+cAEAu9opvQ
	(envelope-from <io-uring+bounces-13611-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 13:19:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 549B1647AA1
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 13:19:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=qFbhYSZ1;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13611-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13611-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D63F3025D1D
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2026 11:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C196495528;
	Fri,  5 Jun 2026 11:09:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1DB3F8EA2
	for <io-uring@vger.kernel.org>; Fri,  5 Jun 2026 11:09:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780657758; cv=none; b=GQEG6vVUEvswSv8kaeFDM1TaoK/uPTdpp0rFUgPydmSZXP3CmRvOQCh+nr5/1JBpggMHHsk6eVCw2CB90S0RIRQc5ady7Po/T++W+DNKZqHNh9gCpNs98GbqPbk8M5Xw4AbMkwdAECtrsnt1jhTdTy4NqM+zAqQBIItVdfQxj1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780657758; c=relaxed/simple;
	bh=rUz/vhmQXU96sy6uDjHg2HfYwUrrqtA5dI7Y5k08NhQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nBa3AgphGI/HKuEUGg/eOlEQ3ZQnRqVkpfdrrWoZTgWwjBFGSsA2NixEH13h7QPLR5lwUf2PhPD3mnCqyUJSL+GTmZ1/PsVqJpzDnsExfvdwXEW5hHZ67sNrRI7ug9kfXxomG+O/qtGhB646MuEiGeGqcQUj8hrHvZ8K+SJTL3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=qFbhYSZ1; arc=none smtp.client-ip=67.231.145.42
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6553iqdV1988449;
	Fri, 5 Jun 2026 04:09:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=hJgFUkUsfkfKHBKBdg
	dA77A34lNMThgS04mWgVs5Weo=; b=qFbhYSZ1ODvO04+/TUlUxfH1gqet/tmKlr
	zJLF8iDblnCXx6ovBZ8R1UnCvPHaXUQo2nXZr0W/od93vOmqDymwWcnM8T9qiVJq
	y2Z1FiseNM0ZQ02aDD0UZiEKxLAl3m4WKa6csZMrAuQnYU4Qyd/xrvY9Ti+rm5YX
	b4ii32cCST72gE0wfx3O7uoo6FUeTaTBoUutvJUnGIp9BvvsG7yPjyS8xrA1YpbO
	JjkoM1fZq9qP7hPZV9E+rWtVbjSr9+lGk383/MtG3wyqZglcmzg5CXSsMXdqU5/J
	DKGpPy3M02O4fhwE9yhbhwl4BgqHYdoB1CP2rXyBA9AG+smi3jyQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ekbp065f6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 05 Jun 2026 04:09:14 -0700 (PDT)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.41; Fri, 5 Jun
 2026 11:09:12 +0000
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
To: <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
CC: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@meta.com>
Subject: [PATCH liburing] tests/recv-bundle-inc-buf-more: test missing F_BUF_MORE flag with bundle + incremental
Date: Fri, 5 Jun 2026 04:08:24 -0700
Message-ID: <20260605110826.2360963-1-cleger@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDEwOSBTYWx0ZWRfX6rBDKEBvylTy
 yo1ShfTKu+nmfbNx9qaJKJEIVvkQPVWR8MeHZWG5MtyC2t4Du+sJ2r+AZZFxvtcFz/5TkdaPukD
 B4DySZkmRMWS6eTflpaAyd4gVsf5u1wd2POOgXJqe8X5R8f7iW3Hfeoj0oiusVar70Bc7X1GO9u
 MDXYVBkJADNmnbc3TJ5dOH/ZiR5OsxHulj+R+ET7HmBVPDW6iCejsmf8w5K/hU2qedxDK9rG9Er
 Nd/TQiPb98GA58M37dG0vb3EfC2Ons1twNsN/Q3KDPhXN91pZhvlfYPbNwmG8UCU9b/1gOQ/UmE
 fK7wGjGF46HZ9AH1/wcney8FM6K0+pwehSN6gy7ml2NPJ/nYGhlMbnlk01nhGuE1ORfVgebHJFm
 jqNZR/iKUYPr/vCnLN1NHzv7zYFl5rDm0//BqTikhfHKuNj3WSRIOO16yKBbHVrCRLEERmdkgJt
 mXMeKML/fXM2EyfWu7g==
X-Authority-Analysis: v=2.4 cv=dNWWXuZb c=1 sm=1 tr=0 ts=6a22ae5a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=M51BFTxLslgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22
 a=VabnemYjAAAA:8 a=IMKWGIfCFKQpqYdQ1XMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: 3Zfuxl4EcwiM7EKuDSNMp2jdE9rJ2BFZ
X-Proofpoint-GUID: 3Zfuxl4EcwiM7EKuDSNMp2jdE9rJ2BFZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.60 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.56)[subject];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13611-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:cleger@meta.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cleger@meta.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[meta.com:+];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp,meta.com:mid,meta.com:dkim,meta.com:from_mime,meta.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 549B1647AA1

Add a regression test for a kernel bug where IORING_CQE_F_BUF_MORE was
silently dropped during bundle recv retries with provided buffer rings
+ incremental recv + bundle recv.

The kernel's io_recv_finish() merges CQE flags across retry iterations
using:

  cflags = req->cqe.flags | (cflags & CQE_F_MASK);

CQE_F_MASK did not include IORING_CQE_F_BUF_MORE, so the flag was lost
on the final retry iteration when a buffer entry was partially consumed.
This caused userspace to incorrectly advance its buffer ring head past
an entry the kernel still considers in use.

The test uses non-aligned send chunks (3000 bytes vs 4096-byte buffer
entries) and sqe->len = 0 to avoid MSHOT_CAP blocking the retry path,
then verifies that BUF_MORE is set on every CQE where the cumulative
consumption is not a multiple of the entry size. The retry path
triggering isn't 100% deterministic so we tried forcing that by
prefilling the socket with data at start so that when we read, we are
more likely to receive data and thus trigger a retry.

Signed-off-by: Clément Léger <cleger@meta.com>
Assisted-by: Claude:claude-opus-4.6
---
 test/Makefile                   |   1 +
 test/recv-bundle-inc-buf-more.c | 395 ++++++++++++++++++++++++++++++++
 2 files changed, 396 insertions(+)
 create mode 100644 test/recv-bundle-inc-buf-more.c

diff --git a/test/Makefile b/test/Makefile
index d1cd2470..e11ebff7 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -216,6 +216,7 @@ test_srcs := \
 	read-mshot-empty.c \
 	read-mshot-stdin.c \
 	read-write.c \
+	recv-bundle-inc-buf-more.c \
 	recv-bundle-short-ooo.c \
 	recv-inc-ooo.c \
 	recv-msgall.c \
diff --git a/test/recv-bundle-inc-buf-more.c b/test/recv-bundle-inc-buf-more.c
new file mode 100644
index 00000000..fc7bac55
--- /dev/null
+++ b/test/recv-bundle-inc-buf-more.c
@@ -0,0 +1,395 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Test that IORING_CQE_F_BUF_MORE survives bundle recv retries with
+ * incremental provided buffer rings.
+ *
+ * Bug: io_recv_finish() merges CQE flags across bundle retry iterations
+ * using:
+ *
+ *   cflags = req->cqe.flags | (cflags & CQE_F_MASK);
+ *
+ * CQE_F_MASK did not include IORING_CQE_F_BUF_MORE, so the flag was
+ * silently dropped on the final retry iteration when a buffer entry was
+ * partially consumed.  Userspace would then wrongfully advance its
+ * buffer ring head past an entry the kernel still considers in use.
+ *
+ * To trigger the bundle retry path reliably:
+ *
+ * 1. Use sqe->len = 0 so that mshot_len = 0 and IORING_RECV_MSHOT_CAP
+ *    is never set (it would prevent retries via IORING_RECV_NO_RETRY).
+ *
+ * 2. Use multiple small buffer entries in an incremental buffer ring.
+ *    On multishot continuation calls, msg_inq from the previous recv
+ *    limits max_len, which provides fewer entries than available, so
+ *    REQ_F_BL_EMPTY is not set.
+ *
+ * 3. Use a sender thread that fills the socket and continues sending
+ *    so that after a recv that consumes the limited buffer, msg_inq > 1
+ *    (more data arrived), triggering the bundle retry.
+ *
+ * When the retry's first iteration fully consumes one or more entries
+ * and the second iteration partially consumes the next, BUF_MORE must
+ * be set.  On the buggy kernel, the merge drops it.
+ *
+ * Fixed by adding IORING_CQE_F_BUF_MORE to CQE_F_MASK.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <pthread.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+#include <arpa/inet.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+/*
+ * Multiple small entries: the kernel will provide a subset when
+ * max_len < total capacity, leaving entries for the retry.
+ */
+#define NR_BUFS		256
+#define BUF_ENTRY_SIZE	4096
+#define TOTAL_BUF_SIZE	(NR_BUFS * BUF_ENTRY_SIZE)	/* 1 MB */
+#define BUF_BGID	1
+#define BUF_MASK	(NR_BUFS - 1)
+
+/*
+ * Total data to send per iteration.  Must be less than TOTAL_BUF_SIZE
+ * so the buffer ring is never fully consumed in a single iteration.
+ */
+#define TOTAL_SEND	(512 * 1024)
+
+/*
+ * The sender pre-fills the socket with this much data before the
+ * receiver arms the multishot recv.  This ensures msg_inq is non-zero
+ * from the start and that data keeps arriving during recv processing,
+ * making the bundle retry path much more likely to fire.
+ */
+#define PREFILL_SEND	(TOTAL_SEND / 2)
+
+/* Number of iterations to increase the chance of hitting the retry path */
+#define NR_ITERATIONS	20
+
+/*
+ * Intentionally NOT a multiple of BUF_ENTRY_SIZE so that the data
+ * in the TCP receive buffer is not aligned to entry boundaries.
+ * This ensures msg_inq values that cause partial-entry consumption.
+ */
+#define SEND_CHUNK	3000
+
+static int no_bundle_inc;
+
+struct send_data {
+	int fd;
+	int total;
+	int prefill;
+	pthread_barrier_t barrier;
+};
+
+static int send_bytes(int fd, unsigned char *data, int bytes)
+{
+	int sent = 0;
+
+	while (sent < bytes) {
+		int chunk = bytes - sent;
+		int ret;
+
+		if (chunk > SEND_CHUNK)
+			chunk = SEND_CHUNK;
+
+		ret = send(fd, data, chunk, 0);
+		if (ret < 0) {
+			if (errno == EPIPE)
+				return sent;
+			perror("send");
+			return -1;
+		}
+		sent += ret;
+	}
+
+	return sent;
+}
+
+static void *sender_fn(void *arg)
+{
+	struct send_data *sd = arg;
+	unsigned char *data;
+
+	data = malloc(SEND_CHUNK);
+	if (!data)
+		return (void *)(intptr_t)1;
+
+	/*
+	 * Pre-fill the socket with data before the receiver arms the
+	 * multishot recv.  This ensures the recv sees data immediately
+	 * and that continuations have data flowing in, making the
+	 * bundle retry path fire more reliably.
+	 */
+	if (send_bytes(sd->fd, data, sd->prefill) < 0) {
+		free(data);
+		return (void *)(intptr_t)1;
+	}
+
+	/* Signal receiver that data is ready */
+	pthread_barrier_wait(&sd->barrier);
+
+	/* Continue sending the rest */
+	if (send_bytes(sd->fd, data, sd->total - sd->prefill) < 0) {
+		free(data);
+		return (void *)(intptr_t)1;
+	}
+
+	/* Signal EOF */
+	shutdown(sd->fd, SHUT_WR);
+	free(data);
+	return NULL;
+}
+
+static int arm_recv(struct io_uring *ring, int fd)
+{
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	/*
+	 * sqe->len = 0: critical for avoiding MSHOT_CAP which would
+	 * block the retry path via IORING_RECV_NO_RETRY.
+	 */
+	io_uring_prep_recv_multishot(sqe, fd, NULL, 0, 0);
+	sqe->ioprio |= IORING_RECVSEND_BUNDLE;
+	sqe->buf_group = BUF_BGID;
+	sqe->flags |= IOSQE_BUFFER_SELECT;
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return 1;
+	}
+	return 0;
+}
+
+static int test(void)
+{
+	struct io_uring_buf_ring *br;
+	struct io_uring_params p = { };
+	struct io_uring ring;
+	struct send_data sd;
+	pthread_t sender;
+	unsigned char *buf;
+	int fds[2];
+	int ret, val;
+	int recv_bytes = 0;
+	int buf_more_missing = 0;
+	int partial_cqes = 0;
+	void *tret;
+
+	p.cq_entries = 4096;
+	p.flags = IORING_SETUP_CQSIZE;
+	ret = io_uring_queue_init_params(16, &ring, &p);
+	if (ret) {
+		fprintf(stderr, "ring init: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (!(p.features & IORING_FEAT_RECVSEND_BUNDLE)) {
+		io_uring_queue_exit(&ring);
+		return T_EXIT_SKIP;
+	}
+
+	if (posix_memalign((void **)&buf, 4096, TOTAL_BUF_SIZE)) {
+		io_uring_queue_exit(&ring);
+		return T_EXIT_FAIL;
+	}
+	memset(buf, 0, TOTAL_BUF_SIZE);
+
+	br = io_uring_setup_buf_ring(&ring, NR_BUFS, BUF_BGID,
+				     IOU_PBUF_RING_INC, &ret);
+	if (!br) {
+		free(buf);
+		io_uring_queue_exit(&ring);
+		if (ret == -EINVAL) {
+			no_bundle_inc = 1;
+			return T_EXIT_SKIP;
+		}
+		fprintf(stderr, "buf ring setup: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	for (int i = 0; i < NR_BUFS; i++) {
+		io_uring_buf_ring_add(br, buf + i * BUF_ENTRY_SIZE,
+				      BUF_ENTRY_SIZE, i, BUF_MASK, i);
+	}
+	io_uring_buf_ring_advance(br, NR_BUFS);
+
+	ret = t_create_socket_pair(fds, true);
+	if (ret) {
+		fprintf(stderr, "socket pair: %d\n", ret);
+		goto fail;
+	}
+
+	val = 1;
+	setsockopt(fds[1], IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
+
+	/* Start sender thread */
+	sd.fd = fds[1];
+	sd.total = TOTAL_SEND;
+	sd.prefill = PREFILL_SEND;
+	pthread_barrier_init(&sd.barrier, NULL, 2);
+
+	ret = pthread_create(&sender, NULL, sender_fn, &sd);
+	if (ret) {
+		fprintf(stderr, "pthread_create: %d\n", ret);
+		goto fail;
+	}
+
+	/* Wait for sender to pre-fill the socket, then arm recv */
+	pthread_barrier_wait(&sd.barrier);
+	if (arm_recv(&ring, fds[0]))
+		goto join_fail;
+
+	/* Collect completions */
+	while (recv_bytes < TOTAL_SEND) {
+		struct io_uring_cqe *cqe;
+		struct __kernel_timespec ts = { .tv_sec = 10, };
+
+		ret = io_uring_wait_cqe_timeout(&ring, &cqe, &ts);
+		if (ret) {
+			fprintf(stderr, "wait: %d (recv'd %d/%d)\n",
+				ret, recv_bytes, TOTAL_SEND);
+			goto join_fail;
+		}
+
+		if (cqe->res == -ENOBUFS) {
+			io_uring_cqe_seen(&ring, cqe);
+			continue;
+		}
+		if (cqe->res == -EINVAL) {
+			io_uring_cqe_seen(&ring, cqe);
+			no_bundle_inc = 1;
+			pthread_join(sender, NULL);
+			close(fds[0]);
+			close(fds[1]);
+			free(buf);
+			io_uring_queue_exit(&ring);
+			return T_EXIT_SKIP;
+		}
+		if (cqe->res <= 0) {
+			if (cqe->res == 0 && recv_bytes >= TOTAL_SEND) {
+				io_uring_cqe_seen(&ring, cqe);
+				break;
+			}
+			fprintf(stderr, "recv error: res=%d recv=%d\n",
+				cqe->res, recv_bytes);
+			io_uring_cqe_seen(&ring, cqe);
+			goto join_fail;
+		}
+
+		if (!(cqe->flags & IORING_CQE_F_BUFFER)) {
+			fprintf(stderr, "IORING_CQE_F_BUFFER not set\n");
+			io_uring_cqe_seen(&ring, cqe);
+			goto join_fail;
+		}
+
+		/*
+		 * If the total bytes consumed so far is not a multiple of
+		 * BUF_ENTRY_SIZE, the last buffer entry was only partially
+		 * used and BUF_MORE must be set.  We check the cumulative
+		 * total (not just cqe->res) because a previous CQE may
+		 * have partially consumed an entry that this CQE finishes.
+		 *
+		 * On a buggy kernel where the bundle retry drops BUF_MORE
+		 * from the merge, this check catches the regression.
+		 *
+		 * Note: only check when the buffer ring hasn't been
+		 * fully consumed (recv_bytes + cqe->res < TOTAL_BUF_SIZE).
+		 */
+		if (((recv_bytes + cqe->res) % BUF_ENTRY_SIZE) != 0 &&
+		    (recv_bytes + cqe->res) < TOTAL_BUF_SIZE) {
+			partial_cqes++;
+			if (!(cqe->flags & IORING_CQE_F_BUF_MORE)) {
+				fprintf(stderr,
+					"FAIL: BUF_MORE not set after partial "
+					"entry consumption!\n"
+					"  cqe->res=%d flags=0x%x "
+					"recv_bytes=%d\n",
+					cqe->res, cqe->flags, recv_bytes);
+				buf_more_missing = 1;
+			}
+		}
+
+		recv_bytes += cqe->res;
+
+		if (!(cqe->flags & IORING_CQE_F_MORE) &&
+		    recv_bytes < TOTAL_SEND) {
+			io_uring_cqe_seen(&ring, cqe);
+			if (arm_recv(&ring, fds[0]))
+				goto join_fail;
+			continue;
+		}
+
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	pthread_join(sender, &tret);
+
+	if (tret) {
+		fprintf(stderr, "sender thread failed\n");
+		goto fail;
+	}
+
+	if (buf_more_missing)
+		goto fail;
+
+	/*
+	 * If no partial-entry CQEs were seen, the retry path was
+	 * likely not exercised.  Return -1 so the caller can retry.
+	 */
+	if (!partial_cqes)
+		ret = -1;
+	else
+		ret = T_EXIT_PASS;
+
+	goto out;
+
+join_fail:
+	pthread_join(sender, NULL);
+fail:
+	ret = T_EXIT_FAIL;
+out:
+	close(fds[0]);
+	close(fds[1]);
+	free(buf);
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int i, ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	/*
+	 * The retry path depends on TCP timing and is not fully deterministic.
+	 * Loop until we get a definitive result: PASS means partial-entry
+	 * CQEs were seen and BUF_MORE was correctly set on all of them.
+	 * FAIL/SKIP stop immediately.  -1 means inconclusive (no partial
+	 * CQEs seen), so retry.  If all iterations are inconclusive, fail.
+	 */
+	for (i = 0; i < NR_ITERATIONS; i++) {
+		ret = test();
+		if (ret == T_EXIT_PASS || ret == T_EXIT_FAIL ||
+		    ret == T_EXIT_SKIP)
+			return ret;
+	}
+
+	fprintf(stderr, "no partial-entry CQEs seen after %d iterations\n",
+		NR_ITERATIONS);
+	return T_EXIT_FAIL;
+}
--
2.53.0-Meta

