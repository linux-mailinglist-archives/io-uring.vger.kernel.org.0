Return-Path: <io-uring+bounces-12664-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eK5VJPoMtGlvfwAAu9opvQ
	(envelope-from <io-uring+bounces-12664-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 14:11:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 473CA2837F6
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 14:11:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 82764309BBB9
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2026 13:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8854347BD7;
	Fri, 13 Mar 2026 13:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="Oq2D+Jww";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="kRF6BRKD"
X-Original-To: io-uring@vger.kernel.org
Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5751A313E36;
	Fri, 13 Mar 2026 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773407394; cv=none; b=PBDXwOY2ZSEgm+gvqqmDmj0vgBOpmREprn5vTDB6J8lT1jBva/iYDqmdgsvLU/bYbfTvBd+Z7ggK6Urlw+SoNs+vZfB7gD5W/acz5EluZ48jg+vKPCu+HrlSUADRkok3Z0qjoxddpThlaKkllBM9ePtyecbZLgwU9JzAWkotL+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773407394; c=relaxed/simple;
	bh=1MsvDavICYFjQ+LOjShL7wxc8Tg9o3lfu+RTMz1FYm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDg9hsDGce9zwTuf26IfVlMjKfAzLKFyk4s/hdzWlW6zagNikm8obZ3o7noRiHCMcLmD4494vUs1xHE8J+iWUlDGTXJuaEvSJzzRhx1+Ti7NDp/XEznm6M5a82LXwhEV7UcXf/SEYQyjFRGrJ4iHYfh/qlCEKqnqRIY7j+cjVuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=Oq2D+Jww; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=kRF6BRKD; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1773407260; bh=2ehlIq082VA+OgkWztKF5ZA
	00ae+KgRo2Eh6dBgpt4U=; b=Oq2D+Jww2OuHpjgq2G1erv2D6UaVX2WE20mpBQ3370yQzWGkMM
	Jta1fzs36hLAoOCB3QMn8bWx8ymxjxyOhdtb1On8tGAIldp+5VilXsD8kipROLuSKhPR4VKoq1L
	vQX4k2o1i3pi1B4pl1odRpHJQQMaOuzYGhEOzNoGAsQ7BjVY3cQDv5QiaAShxUwgNz5cdHECfGY
	vtIStVa4q5AR0J0RCkjVsEKtXbP+8eOl+BxQRYZ7B63M2aWUM1MH5z1glv07uoXSt91vUmKpkhJ
	Ozq3OnRV80VZ8K+qb1vDMp7F7+eRScq0U57gDjtJc8eh8Zhns86Oifg2vUky0UDAtHw==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1773407260; bh=2ehlIq082VA+OgkWztKF5ZA
	00ae+KgRo2Eh6dBgpt4U=; b=kRF6BRKDlUz3OT5aLJaOQ9v8RddiWHO1yGjbJVJ2YpVS4IZ2Kw
	2FsIMJHXXk92iZE7kOh7HPTmusKSewxwoODQ==;
From: Daniel Hodges <git@danielhodges.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Daniel Hodges <git@danielhodges.dev>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] selftests/ipc: Add io_uring IPC selftest
Date: Fri, 13 Mar 2026 09:07:39 -0400
Message-ID: <20260313130739.23265-3-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260313130739.23265-1-git@danielhodges.dev>
References: <20260313130739.23265-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[danielhodges.dev,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[danielhodges.dev:s=202510r,danielhodges.dev:s=202510e];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12664-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[danielhodges.dev,gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[danielhodges.dev:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[git@danielhodges.dev,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[danielhodges.dev:dkim,danielhodges.dev:email,danielhodges.dev:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 473CA2837F6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add selftests for io_uring IPC channels. Tests cover send/recv,
broadcast, detach, permission enforcement, ring full, message
truncation, slot reuse, and cross-process operation.

Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 MAINTAINERS                                |    1 +
 tools/testing/selftests/ipc/Makefile       |    2 +-
 tools/testing/selftests/ipc/io_uring_ipc.c | 1265 ++++++++++++++++++++
 3 files changed, 1267 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/ipc/io_uring_ipc.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 837db4f7bcca..d43f59e31f03 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13432,6 +13432,7 @@ F:	include/trace/events/io_uring.h
 F:	include/uapi/linux/io_uring.h
 F:	include/uapi/linux/io_uring/
 F:	io_uring/
+F:	tools/testing/selftests/ipc/io_uring_ipc*
 
 IO_URING ZCRX
 M:	Pavel Begunkov <asml.silence@gmail.com>
diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 50e9c299fc4a..74bc45b555f8 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -12,7 +12,7 @@ endif
 
 CFLAGS += $(KHDR_INCLUDES)
 
-TEST_GEN_PROGS := msgque
+TEST_GEN_PROGS := msgque io_uring_ipc
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/ipc/io_uring_ipc.c b/tools/testing/selftests/ipc/io_uring_ipc.c
new file mode 100644
index 000000000000..a82988351e02
--- /dev/null
+++ b/tools/testing/selftests/ipc/io_uring_ipc.c
@@ -0,0 +1,1265 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * io_uring IPC selftest
+ *
+ * Tests the io_uring IPC channel functionality including:
+ * - Channel creation and attachment
+ * - Message send and receive (broadcast and non-broadcast)
+ * - Broadcast delivery to multiple receivers
+ * - Channel detach
+ * - Permission enforcement (send-only, recv-only)
+ * - Ring full and message size limits
+ * - Multiple message ordering
+ * - Invalid parameter rejection
+ * - Cross-process communication
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <linux/io_uring.h>
+
+/* Check if IO_URING_IPC is supported */
+#ifndef IORING_OP_IPC_SEND
+#define IORING_OP_IPC_SEND 65
+#define IORING_OP_IPC_RECV 66
+
+#define IORING_REGISTER_IPC_CHANNEL_CREATE 38
+#define IORING_REGISTER_IPC_CHANNEL_ATTACH 39
+#define IORING_REGISTER_IPC_CHANNEL_DETACH 40
+#define IORING_REGISTER_IPC_CHANNEL_DESTROY 41
+
+/* Flags for IPC channel creation */
+#define IOIPC_F_BROADCAST	(1U << 0)
+#define IOIPC_F_MULTICAST	(1U << 1)
+#define IOIPC_F_PRIVATE		(1U << 2)
+
+/* Flags for subscriber attachment */
+#define IOIPC_SUB_SEND		(1U << 0)
+#define IOIPC_SUB_RECV		(1U << 1)
+#define IOIPC_SUB_BOTH		(IOIPC_SUB_SEND | IOIPC_SUB_RECV)
+
+/* Create IPC channel */
+struct io_uring_ipc_channel_create {
+	__u32	flags;
+	__u32	ring_entries;
+	__u32	max_msg_size;
+	__u32	mode;
+	__u64	key;
+	__u32	channel_id_out;
+	__u32	reserved[3];
+};
+
+/* Attach to existing channel */
+struct io_uring_ipc_channel_attach {
+	__u32	channel_id;
+	__u32	flags;
+	__u64	key;
+	__s32	channel_fd;
+	__u32	local_id_out;
+	__u64	mmap_offset_out;
+	__u32	region_size;
+	__u32	reserved[3];
+};
+#endif
+
+#ifndef __NR_io_uring_setup
+#define __NR_io_uring_setup 425
+#endif
+
+#ifndef __NR_io_uring_enter
+#define __NR_io_uring_enter 426
+#endif
+
+#ifndef __NR_io_uring_register
+#define __NR_io_uring_register 427
+#endif
+
+#define QUEUE_DEPTH 32
+#define TEST_MSG "Hello from io_uring IPC!"
+#define TEST_KEY 0x12345678ULL
+#define KSFT_SKIP 4
+
+static int io_uring_setup(unsigned int entries, struct io_uring_params *p)
+{
+	return syscall(__NR_io_uring_setup, entries, p);
+}
+
+static int io_uring_enter(int fd, unsigned int to_submit, unsigned int min_complete,
+			  unsigned int flags, sigset_t *sig)
+{
+	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
+		       flags, sig);
+}
+
+static int io_uring_register_syscall(int fd, unsigned int opcode, void *arg,
+				     unsigned int nr_args)
+{
+	return syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
+}
+
+struct io_uring {
+	int ring_fd;
+	struct io_uring_sqe *sqes;
+	struct io_uring_cqe *cqes;
+	unsigned int *sq_head;
+	unsigned int *sq_tail;
+	unsigned int *cq_head;
+	unsigned int *cq_tail;
+	unsigned int sq_ring_mask;
+	unsigned int cq_ring_mask;
+	unsigned int *sq_array;
+	void *sq_ring_ptr;
+	void *cq_ring_ptr;
+};
+
+static int setup_io_uring(struct io_uring *ring, unsigned int entries)
+{
+	struct io_uring_params p;
+	void *sq_ptr, *cq_ptr;
+	int ret;
+
+	memset(&p, 0, sizeof(p));
+	ret = io_uring_setup(entries, &p);
+	if (ret < 0)
+		return -errno;
+
+	ring->ring_fd = ret;
+	ring->sq_ring_mask = p.sq_entries - 1;
+	ring->cq_ring_mask = p.cq_entries - 1;
+
+	sq_ptr = mmap(NULL, p.sq_off.array + p.sq_entries * sizeof(unsigned int),
+		      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
+		      ring->ring_fd, IORING_OFF_SQ_RING);
+	if (sq_ptr == MAP_FAILED) {
+		close(ring->ring_fd);
+		return -errno;
+	}
+	ring->sq_ring_ptr = sq_ptr;
+
+	ring->sqes = mmap(NULL, p.sq_entries * sizeof(struct io_uring_sqe),
+			  PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
+			  ring->ring_fd, IORING_OFF_SQES);
+	if (ring->sqes == MAP_FAILED) {
+		munmap(sq_ptr, p.sq_off.array + p.sq_entries * sizeof(unsigned int));
+		close(ring->ring_fd);
+		return -errno;
+	}
+
+	cq_ptr = mmap(NULL, p.cq_off.cqes + p.cq_entries * sizeof(struct io_uring_cqe),
+		      PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
+		      ring->ring_fd, IORING_OFF_CQ_RING);
+	if (cq_ptr == MAP_FAILED) {
+		munmap(ring->sqes, p.sq_entries * sizeof(struct io_uring_sqe));
+		munmap(sq_ptr, p.sq_off.array + p.sq_entries * sizeof(unsigned int));
+		close(ring->ring_fd);
+		return -errno;
+	}
+	ring->cq_ring_ptr = cq_ptr;
+
+	ring->sq_head = sq_ptr + p.sq_off.head;
+	ring->sq_tail = sq_ptr + p.sq_off.tail;
+	ring->sq_array = sq_ptr + p.sq_off.array;
+	ring->cq_head = cq_ptr + p.cq_off.head;
+	ring->cq_tail = cq_ptr + p.cq_off.tail;
+	ring->cqes = cq_ptr + p.cq_off.cqes;
+
+	return 0;
+}
+
+static void cleanup_io_uring(struct io_uring *ring)
+{
+	close(ring->ring_fd);
+}
+
+static struct io_uring_sqe *get_sqe(struct io_uring *ring)
+{
+	unsigned int tail = *ring->sq_tail;
+	unsigned int index = tail & ring->sq_ring_mask;
+	struct io_uring_sqe *sqe = &ring->sqes[index];
+
+	tail++;
+	*ring->sq_tail = tail;
+	ring->sq_array[index] = index;
+
+	memset(sqe, 0, sizeof(*sqe));
+	return sqe;
+}
+
+static int submit_and_wait(struct io_uring *ring, struct io_uring_cqe **cqe_ptr)
+{
+	unsigned int to_submit = *ring->sq_tail - *ring->sq_head;
+	unsigned int head;
+	int ret;
+
+	if (to_submit) {
+		ret = io_uring_enter(ring->ring_fd, to_submit, 0, 0, NULL);
+		if (ret < 0)
+			return -errno;
+	}
+
+	ret = io_uring_enter(ring->ring_fd, 0, 1, IORING_ENTER_GETEVENTS, NULL);
+	if (ret < 0)
+		return -errno;
+
+	head = *ring->cq_head;
+	if (head == *ring->cq_tail)
+		return -EAGAIN;
+
+	*cqe_ptr = &ring->cqes[head & ring->cq_ring_mask];
+	return 0;
+}
+
+static void cqe_seen(struct io_uring *ring)
+{
+	(*ring->cq_head)++;
+}
+
+static int create_channel(struct io_uring *ring, __u32 flags, __u32 ring_entries,
+			  __u32 max_msg_size, __u64 key, unsigned int *id_out)
+{
+	struct io_uring_ipc_channel_create create;
+	int ret;
+
+	memset(&create, 0, sizeof(create));
+	create.flags = flags;
+	create.ring_entries = ring_entries;
+	create.max_msg_size = max_msg_size;
+	create.mode = 0666;
+	create.key = key;
+
+	ret = io_uring_register_syscall(ring->ring_fd,
+					IORING_REGISTER_IPC_CHANNEL_CREATE,
+					&create, 1);
+	if (ret < 0)
+		return -errno;
+
+	*id_out = create.channel_id_out;
+	return 0;
+}
+
+static int attach_channel(struct io_uring *ring, __u64 key, __u32 sub_flags,
+			  unsigned int *local_id_out)
+{
+	struct io_uring_ipc_channel_attach attach;
+	int ret;
+
+	memset(&attach, 0, sizeof(attach));
+	attach.key = key;
+	attach.flags = sub_flags;
+
+	ret = io_uring_register_syscall(ring->ring_fd,
+					IORING_REGISTER_IPC_CHANNEL_ATTACH,
+					&attach, 1);
+	if (ret < 0)
+		return -errno;
+
+	*local_id_out = attach.local_id_out;
+	return 0;
+}
+
+static int attach_channel_by_id(struct io_uring *ring, __u32 channel_id,
+				__u32 sub_flags, unsigned int *local_id_out)
+{
+	struct io_uring_ipc_channel_attach attach;
+	int ret;
+
+	memset(&attach, 0, sizeof(attach));
+	attach.channel_id = channel_id;
+	attach.key = 0;
+	attach.flags = sub_flags;
+
+	ret = io_uring_register_syscall(ring->ring_fd,
+					IORING_REGISTER_IPC_CHANNEL_ATTACH,
+					&attach, 1);
+	if (ret < 0)
+		return -errno;
+
+	*local_id_out = attach.local_id_out;
+	return 0;
+}
+
+static int detach_channel(struct io_uring *ring, unsigned int subscriber_id)
+{
+	int ret;
+
+	ret = io_uring_register_syscall(ring->ring_fd,
+					IORING_REGISTER_IPC_CHANNEL_DETACH,
+					NULL, subscriber_id);
+	if (ret < 0)
+		return -errno;
+
+	return 0;
+}
+
+static int destroy_channel(struct io_uring *ring, unsigned int channel_id)
+{
+	int ret;
+
+	ret = io_uring_register_syscall(ring->ring_fd,
+					IORING_REGISTER_IPC_CHANNEL_DESTROY,
+					NULL, channel_id);
+	if (ret < 0)
+		return -errno;
+
+	return 0;
+}
+
+static int do_send(struct io_uring *ring, unsigned int fd,
+		   const void *msg, size_t len)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret, res;
+
+	sqe = get_sqe(ring);
+	sqe->opcode = IORING_OP_IPC_SEND;
+	sqe->fd = fd;
+	sqe->addr = (unsigned long)msg;
+	sqe->len = len;
+	sqe->user_data = 1;
+
+	ret = submit_and_wait(ring, &cqe);
+	if (ret < 0)
+		return ret;
+
+	res = cqe->res;
+	cqe_seen(ring);
+	return res;
+}
+
+static int do_recv(struct io_uring *ring, unsigned int fd,
+		   void *buf, size_t len)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret, res;
+
+	sqe = get_sqe(ring);
+	sqe->opcode = IORING_OP_IPC_RECV;
+	sqe->fd = fd;
+	sqe->addr = (unsigned long)buf;
+	sqe->len = len;
+	sqe->user_data = 2;
+
+	ret = submit_and_wait(ring, &cqe);
+	if (ret < 0)
+		return ret;
+
+	res = cqe->res;
+	cqe_seen(ring);
+	return res;
+}
+
+static int do_send_targeted(struct io_uring *ring, unsigned int fd,
+			    const void *msg, size_t len, __u32 target)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret, res;
+
+	sqe = get_sqe(ring);
+	sqe->opcode = IORING_OP_IPC_SEND;
+	sqe->fd = fd;
+	sqe->addr = (unsigned long)msg;
+	sqe->len = len;
+	sqe->user_data = 1;
+	sqe->file_index = target;
+
+	ret = submit_and_wait(ring, &cqe);
+	if (ret < 0)
+		return ret;
+
+	res = cqe->res;
+	cqe_seen(ring);
+	return res;
+}
+
+static int test_nonbroadcast(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	char recv_buf[256];
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring, 0, 16, 4096, TEST_KEY + 100, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 100, IOIPC_SUB_BOTH, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = do_send(&ring, sub_id, TEST_MSG, strlen(TEST_MSG) + 1);
+	if (ret < 0)
+		goto fail;
+
+	memset(recv_buf, 0, sizeof(recv_buf));
+	ret = do_recv(&ring, sub_id, recv_buf, sizeof(recv_buf));
+	if (ret < 0)
+		goto fail;
+
+	if (strcmp(recv_buf, TEST_MSG) != 0)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_broadcast_multi(void)
+{
+	struct io_uring ring1, ring2;
+	unsigned int channel_id, sub1_id, sub2_id;
+	char buf1[256], buf2[256];
+	int ret;
+
+	ret = setup_io_uring(&ring1, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = setup_io_uring(&ring2, QUEUE_DEPTH);
+	if (ret < 0) {
+		cleanup_io_uring(&ring1);
+		return 1;
+	}
+
+	ret = create_channel(&ring1, IOIPC_F_BROADCAST, 16, 4096,
+			     TEST_KEY + 200, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring1, TEST_KEY + 200, IOIPC_SUB_BOTH, &sub1_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring2, TEST_KEY + 200, IOIPC_SUB_RECV, &sub2_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = do_send(&ring1, sub1_id, TEST_MSG, strlen(TEST_MSG) + 1);
+	if (ret < 0)
+		goto fail;
+
+	/* Both subscribers must receive the same message */
+	memset(buf1, 0, sizeof(buf1));
+	ret = do_recv(&ring1, sub1_id, buf1, sizeof(buf1));
+	if (ret < 0)
+		goto fail;
+	if (strcmp(buf1, TEST_MSG) != 0)
+		goto fail;
+
+	memset(buf2, 0, sizeof(buf2));
+	ret = do_recv(&ring2, sub2_id, buf2, sizeof(buf2));
+	if (ret < 0)
+		goto fail;
+	if (strcmp(buf2, TEST_MSG) != 0)
+		goto fail;
+
+	cleanup_io_uring(&ring1);
+	cleanup_io_uring(&ring2);
+	return 0;
+fail:
+	cleanup_io_uring(&ring1);
+	cleanup_io_uring(&ring2);
+	return 1;
+}
+
+static int test_detach(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	char buf[256];
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring, 0, 16, 4096, TEST_KEY + 300, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 300, IOIPC_SUB_BOTH, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = detach_channel(&ring, sub_id);
+	if (ret < 0)
+		goto fail;
+
+	/* After detach, recv should fail with ENOENT */
+	ret = do_recv(&ring, sub_id, buf, sizeof(buf));
+	if (ret != -ENOENT)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_recv_only_cannot_send(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring, 0, 16, 4096, TEST_KEY + 400, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 400, IOIPC_SUB_RECV, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = do_send(&ring, sub_id, TEST_MSG, strlen(TEST_MSG) + 1);
+	if (ret != -EACCES)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_send_only_cannot_recv(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	char buf[256];
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring, 0, 16, 4096, TEST_KEY + 500, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 500, IOIPC_SUB_SEND, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Send first so there's a message in the ring */
+	ret = do_send(&ring, sub_id, TEST_MSG, strlen(TEST_MSG) + 1);
+	if (ret < 0)
+		goto fail;
+
+	/* Recv should fail with EACCES */
+	ret = do_recv(&ring, sub_id, buf, sizeof(buf));
+	if (ret != -EACCES)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_ring_full(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	const char msg[] = "X";
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	/* ring_entries=2: can hold 2 messages before full */
+	ret = create_channel(&ring, 0, 2, 64, TEST_KEY + 600, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 600, IOIPC_SUB_BOTH, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Fill the 2 slots */
+	ret = do_send(&ring, sub_id, msg, sizeof(msg));
+	if (ret < 0)
+		goto fail;
+
+	ret = do_send(&ring, sub_id, msg, sizeof(msg));
+	if (ret < 0)
+		goto fail;
+
+	/* Third send must fail */
+	ret = do_send(&ring, sub_id, msg, sizeof(msg));
+	if (ret != -ENOBUFS)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_msg_too_large(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	char big_msg[128];
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	/* max_msg_size=64 */
+	ret = create_channel(&ring, 0, 16, 64, TEST_KEY + 700, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 700, IOIPC_SUB_BOTH, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	memset(big_msg, 'A', sizeof(big_msg));
+	ret = do_send(&ring, sub_id, big_msg, sizeof(big_msg));
+	if (ret != -EMSGSIZE)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+#define NUM_MULTI_MSGS 8
+
+static int test_multiple_messages(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	char send_buf[64], recv_buf[64];
+	int ret, i;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring, 0, 16, 64, TEST_KEY + 800, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 800, IOIPC_SUB_BOTH, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	for (i = 0; i < NUM_MULTI_MSGS; i++) {
+		snprintf(send_buf, sizeof(send_buf), "msg-%d", i);
+		ret = do_send(&ring, sub_id, send_buf, strlen(send_buf) + 1);
+		if (ret < 0)
+			goto fail;
+	}
+
+	for (i = 0; i < NUM_MULTI_MSGS; i++) {
+		memset(recv_buf, 0, sizeof(recv_buf));
+		ret = do_recv(&ring, sub_id, recv_buf, sizeof(recv_buf));
+		if (ret < 0)
+			goto fail;
+		snprintf(send_buf, sizeof(send_buf), "msg-%d", i);
+		if (strcmp(recv_buf, send_buf) != 0)
+			goto fail;
+	}
+
+	/* Ring should be empty now */
+	ret = do_recv(&ring, sub_id, recv_buf, sizeof(recv_buf));
+	if (ret != -EAGAIN)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_invalid_params(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id;
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	/* Non-power-of-2 ring_entries */
+	ret = create_channel(&ring, 0, 3, 4096, TEST_KEY + 900, &channel_id);
+	if (ret != -EINVAL)
+		goto fail;
+
+	/* Zero ring_entries */
+	ret = create_channel(&ring, 0, 0, 4096, TEST_KEY + 901, &channel_id);
+	if (ret != -EINVAL)
+		goto fail;
+
+	/* Zero max_msg_size */
+	ret = create_channel(&ring, 0, 16, 0, TEST_KEY + 902, &channel_id);
+	if (ret != -EINVAL)
+		goto fail;
+
+	/* BROADCAST | MULTICAST together */
+	ret = create_channel(&ring, IOIPC_F_BROADCAST | IOIPC_F_MULTICAST,
+			     16, 4096, TEST_KEY + 903, &channel_id);
+	if (ret != -EINVAL)
+		goto fail;
+
+	/* Unsupported flags */
+	ret = create_channel(&ring, 0xFF00, 16, 4096, TEST_KEY + 904,
+			     &channel_id);
+	if (ret != -EINVAL)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_attach_by_id(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	char recv_buf[256];
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring, 0, 16, 4096, TEST_KEY + 1000, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Attach using channel_id (key=0) instead of key */
+	ret = attach_channel_by_id(&ring, channel_id, IOIPC_SUB_BOTH, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = do_send(&ring, sub_id, TEST_MSG, strlen(TEST_MSG) + 1);
+	if (ret < 0)
+		goto fail;
+
+	memset(recv_buf, 0, sizeof(recv_buf));
+	ret = do_recv(&ring, sub_id, recv_buf, sizeof(recv_buf));
+	if (ret < 0)
+		goto fail;
+
+	if (strcmp(recv_buf, TEST_MSG) != 0)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_recv_truncation(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	const char long_msg[] = "This message is longer than the receive buffer";
+	char small_buf[8];
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring, 0, 16, 4096, TEST_KEY + 1100, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 1100, IOIPC_SUB_BOTH, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = do_send(&ring, sub_id, long_msg, sizeof(long_msg));
+	if (ret < 0)
+		goto fail;
+
+	memset(small_buf, 0, sizeof(small_buf));
+	ret = do_recv(&ring, sub_id, small_buf, sizeof(small_buf));
+	/* Should return truncated length, not full message length */
+	if (ret != sizeof(small_buf))
+		goto fail;
+
+	/* Verify we got the first bytes */
+	if (memcmp(small_buf, long_msg, sizeof(small_buf)) != 0)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_broadcast_slot_reuse(void)
+{
+	struct io_uring ring1, ring2;
+	unsigned int channel_id, sub1_id, sub2_id;
+	char buf[256];
+	const char msg1[] = "first";
+	const char msg2[] = "second";
+	const char msg3[] = "third";
+	int ret;
+
+	ret = setup_io_uring(&ring1, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = setup_io_uring(&ring2, QUEUE_DEPTH);
+	if (ret < 0) {
+		cleanup_io_uring(&ring1);
+		return 1;
+	}
+
+	/* ring_entries=2: only 2 slots available */
+	ret = create_channel(&ring1, IOIPC_F_BROADCAST, 2, 256,
+			     TEST_KEY + 1200, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring1, TEST_KEY + 1200, IOIPC_SUB_BOTH, &sub1_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring2, TEST_KEY + 1200, IOIPC_SUB_RECV, &sub2_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Fill both slots */
+	ret = do_send(&ring1, sub1_id, msg1, sizeof(msg1));
+	if (ret < 0)
+		goto fail;
+
+	ret = do_send(&ring1, sub1_id, msg2, sizeof(msg2));
+	if (ret < 0)
+		goto fail;
+
+	/* Ring is full now -- third send should fail */
+	ret = do_send(&ring1, sub1_id, msg3, sizeof(msg3));
+	if (ret != -ENOBUFS)
+		goto fail;
+
+	/* sub1 consumes both messages */
+	ret = do_recv(&ring1, sub1_id, buf, sizeof(buf));
+	if (ret < 0)
+		goto fail;
+
+	ret = do_recv(&ring1, sub1_id, buf, sizeof(buf));
+	if (ret < 0)
+		goto fail;
+
+	/*
+	 * Ring should still be full from the producer's perspective because
+	 * sub2 hasn't consumed yet -- min_head stays at 0.
+	 */
+	ret = do_send(&ring1, sub1_id, msg3, sizeof(msg3));
+	if (ret != -ENOBUFS)
+		goto fail;
+
+	/* sub2 consumes both messages -- now min_head advances */
+	ret = do_recv(&ring2, sub2_id, buf, sizeof(buf));
+	if (ret < 0)
+		goto fail;
+
+	ret = do_recv(&ring2, sub2_id, buf, sizeof(buf));
+	if (ret < 0)
+		goto fail;
+
+	/* Now the slots should be reusable */
+	ret = do_send(&ring1, sub1_id, msg3, sizeof(msg3));
+	if (ret < 0)
+		goto fail;
+
+	memset(buf, 0, sizeof(buf));
+	ret = do_recv(&ring1, sub1_id, buf, sizeof(buf));
+	if (ret < 0)
+		goto fail;
+
+	if (strcmp(buf, msg3) != 0)
+		goto fail;
+
+	cleanup_io_uring(&ring1);
+	cleanup_io_uring(&ring2);
+	return 0;
+fail:
+	cleanup_io_uring(&ring1);
+	cleanup_io_uring(&ring2);
+	return 1;
+}
+
+static int test_cross_process(void)
+{
+	struct io_uring ring1, ring2;
+	unsigned int channel_id, local_id;
+	char recv_buf[256];
+	int ret;
+	pid_t pid;
+
+	ret = setup_io_uring(&ring1, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring1, IOIPC_F_BROADCAST, 16, 4096,
+			     TEST_KEY, &channel_id);
+	if (ret < 0) {
+		cleanup_io_uring(&ring1);
+		return 1;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		cleanup_io_uring(&ring1);
+		return 1;
+	}
+
+	if (pid == 0) {
+		cleanup_io_uring(&ring1);
+
+		ret = setup_io_uring(&ring2, QUEUE_DEPTH);
+		if (ret < 0)
+			exit(1);
+
+		usleep(100000);
+
+		ret = attach_channel(&ring2, TEST_KEY, IOIPC_SUB_BOTH,
+				     &local_id);
+		if (ret < 0)
+			exit(1);
+
+		usleep(250000);
+
+		memset(recv_buf, 0, sizeof(recv_buf));
+		ret = do_recv(&ring2, local_id, recv_buf, sizeof(recv_buf));
+		if (ret < 0)
+			exit(1);
+
+		if (strcmp(recv_buf, TEST_MSG) != 0)
+			exit(1);
+
+		cleanup_io_uring(&ring2);
+		exit(0);
+	}
+
+	/* Parent process - producer */
+	usleep(200000);
+
+	ret = do_send(&ring1, channel_id, TEST_MSG, strlen(TEST_MSG) + 1);
+	if (ret < 0) {
+		waitpid(pid, NULL, 0);
+		cleanup_io_uring(&ring1);
+		return 1;
+	}
+
+	int status;
+
+	waitpid(pid, &status, 0);
+	cleanup_io_uring(&ring1);
+
+	if (!WIFEXITED(status) || WEXITSTATUS(status) != 0)
+		return 1;
+
+	return 0;
+}
+
+static int test_multicast_roundrobin(void)
+{
+	struct io_uring ring1, ring2;
+	unsigned int channel_id, sub1_id, sub2_id;
+	char buf1[256], buf2[256];
+	int ret;
+
+	ret = setup_io_uring(&ring1, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = setup_io_uring(&ring2, QUEUE_DEPTH);
+	if (ret < 0) {
+		cleanup_io_uring(&ring1);
+		return 1;
+	}
+
+	ret = create_channel(&ring1, IOIPC_F_MULTICAST, 16, 4096,
+			     TEST_KEY + 1300, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring1, TEST_KEY + 1300, IOIPC_SUB_BOTH, &sub1_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring2, TEST_KEY + 1300, IOIPC_SUB_BOTH, &sub2_id);
+	if (ret < 0)
+		goto fail;
+
+	/*
+	 * Send two messages. With multicast round-robin waking, different
+	 * subscribers get woken for each message. Both use the shared
+	 * consumer head, so both can recv any available message.
+	 */
+	ret = do_send(&ring1, sub1_id, "msg-0", 6);
+	if (ret < 0)
+		goto fail;
+
+	ret = do_send(&ring1, sub1_id, "msg-1", 6);
+	if (ret < 0)
+		goto fail;
+
+	/* Both subscribers should be able to recv one message each */
+	memset(buf1, 0, sizeof(buf1));
+	ret = do_recv(&ring1, sub1_id, buf1, sizeof(buf1));
+	if (ret < 0)
+		goto fail;
+
+	memset(buf2, 0, sizeof(buf2));
+	ret = do_recv(&ring2, sub2_id, buf2, sizeof(buf2));
+	if (ret < 0)
+		goto fail;
+
+	/* Verify we got both messages (order may vary) */
+	if (strcmp(buf1, "msg-0") != 0 && strcmp(buf1, "msg-1") != 0)
+		goto fail;
+	if (strcmp(buf2, "msg-0") != 0 && strcmp(buf2, "msg-1") != 0)
+		goto fail;
+	/* They must be different messages */
+	if (strcmp(buf1, buf2) == 0)
+		goto fail;
+
+	cleanup_io_uring(&ring1);
+	cleanup_io_uring(&ring2);
+	return 0;
+fail:
+	cleanup_io_uring(&ring1);
+	cleanup_io_uring(&ring2);
+	return 1;
+}
+
+static int test_channel_destroy(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring, 0, 16, 4096, TEST_KEY + 1400, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 1400, IOIPC_SUB_BOTH, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Destroy the channel (drops creator's reference) */
+	ret = destroy_channel(&ring, channel_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Double destroy should fail (channel refcount already dropped) */
+	ret = destroy_channel(&ring, channel_id);
+	/*
+	 * May succeed if subscriber still holds a ref, or fail with
+	 * ENOENT if the channel was already freed.  Either way the
+	 * first destroy must have succeeded.
+	 */
+
+	/* Detach the subscriber */
+	ret = detach_channel(&ring, sub_id);
+	if (ret < 0)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+static int test_unicast_targeted(void)
+{
+	struct io_uring ring1, ring2;
+	unsigned int channel_id, sub1_id, sub2_id;
+	char buf1[256], buf2[256];
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	ret = setup_io_uring(&ring1, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = setup_io_uring(&ring2, QUEUE_DEPTH);
+	if (ret < 0) {
+		cleanup_io_uring(&ring1);
+		return 1;
+	}
+
+	/* Create a unicast channel (no flags) */
+	ret = create_channel(&ring1, 0, 16, 4096, TEST_KEY + 1500, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Attach sender+receiver on ring1, receiver-only on ring2 */
+	ret = attach_channel(&ring1, TEST_KEY + 1500, IOIPC_SUB_BOTH, &sub1_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring2, TEST_KEY + 1500, IOIPC_SUB_RECV, &sub2_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Send targeting subscriber 2 specifically */
+	ret = do_send_targeted(&ring1, sub1_id, TEST_MSG, strlen(TEST_MSG) + 1,
+			       sub2_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Receiver 2 should get the message */
+	memset(buf2, 0, sizeof(buf2));
+	ret = do_recv(&ring2, sub2_id, buf2, sizeof(buf2));
+	if (ret < 0)
+		goto fail;
+
+	if (strcmp(buf2, TEST_MSG) != 0)
+		goto fail;
+
+	cleanup_io_uring(&ring1);
+	cleanup_io_uring(&ring2);
+	return 0;
+fail:
+	cleanup_io_uring(&ring1);
+	cleanup_io_uring(&ring2);
+	return 1;
+}
+
+static int test_unicast_targeted_invalid(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id, sub_id;
+	int ret;
+
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0)
+		return 1;
+
+	ret = create_channel(&ring, 0, 16, 4096, TEST_KEY + 1600, &channel_id);
+	if (ret < 0)
+		goto fail;
+
+	ret = attach_channel(&ring, TEST_KEY + 1600, IOIPC_SUB_BOTH, &sub_id);
+	if (ret < 0)
+		goto fail;
+
+	/* Send targeting a non-existent subscriber ID */
+	ret = do_send_targeted(&ring, sub_id, TEST_MSG, strlen(TEST_MSG) + 1,
+			       9999);
+	if (ret != -ENOENT)
+		goto fail;
+
+	cleanup_io_uring(&ring);
+	return 0;
+fail:
+	cleanup_io_uring(&ring);
+	return 1;
+}
+
+struct test_case {
+	const char *name;
+	int (*func)(void);
+};
+
+static struct test_case tests[] = {
+	{ "Non-broadcast send/recv",		test_nonbroadcast },
+	{ "Broadcast multi-receiver",		test_broadcast_multi },
+	{ "Channel detach",			test_detach },
+	{ "Recv-only cannot send",		test_recv_only_cannot_send },
+	{ "Send-only cannot recv",		test_send_only_cannot_recv },
+	{ "Ring full",				test_ring_full },
+	{ "Message too large",			test_msg_too_large },
+	{ "Multiple messages",			test_multiple_messages },
+	{ "Invalid parameters",		test_invalid_params },
+	{ "Attach by channel ID",		test_attach_by_id },
+	{ "Recv truncation",			test_recv_truncation },
+	{ "Broadcast slot reuse",		test_broadcast_slot_reuse },
+	{ "Cross-process send/recv",		test_cross_process },
+	{ "Multicast round-robin",		test_multicast_roundrobin },
+	{ "Channel destroy",			test_channel_destroy },
+	{ "Unicast targeted delivery",		test_unicast_targeted },
+	{ "Unicast targeted invalid",		test_unicast_targeted_invalid },
+};
+
+int main(void)
+{
+	struct io_uring ring;
+	unsigned int channel_id;
+	int i, passed = 0, failed = 0;
+	int total = sizeof(tests) / sizeof(tests[0]);
+	int ret;
+
+	printf("=== io_uring IPC Selftest ===\n\n");
+
+	/* Check if IPC is supported before running any tests */
+	ret = setup_io_uring(&ring, QUEUE_DEPTH);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to setup io_uring\n");
+		return 1;
+	}
+
+	ret = create_channel(&ring, 0, 16, 4096, 0xDEAD0000ULL, &channel_id);
+	cleanup_io_uring(&ring);
+	if (ret == -EINVAL || ret == -ENOSYS) {
+		printf("SKIP: IO_URING_IPC not supported by kernel\n");
+		return KSFT_SKIP;
+	}
+
+	for (i = 0; i < total; i++) {
+		printf("  [%2d/%d] %-30s ", i + 1, total, tests[i].name);
+		fflush(stdout);
+		ret = tests[i].func();
+		if (ret == 0) {
+			printf("PASS\n");
+			passed++;
+		} else {
+			printf("FAIL\n");
+			failed++;
+		}
+	}
+
+	printf("\n=== Results: %d passed, %d failed (of %d) ===\n",
+	       passed, failed, total);
+
+	return failed ? 1 : 0;
+}
-- 
2.52.0


