Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2460A79B446
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbjIKWKE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbjIKKep (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 06:34:45 -0400
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0A3120;
        Mon, 11 Sep 2023 03:34:39 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-9a58dbd5daeso560708866b.2;
        Mon, 11 Sep 2023 03:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694428478; x=1695033278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B9zL1pmqINyZLXRlcnhMXvmJgzBzwPRNb5BCtJUaRIM=;
        b=djWXp/nyhoDwGTfRRp1VDIXXd+Y1zFdtOPaXbZAd1q6AubDA5aZ5ByiChwvSnzHtPz
         e5W2t0jDWC3PYJNoVQi/0roxNOjQ8AsCvyYPwrpUxAH9S8LJZVESl9h4l/4O/2dIZG7J
         8A0gdG0xG/eRS86Ol1+GMqVkJ6ZsDu2BPtoCsMI5AvLac64g79Sj2/WREm3EpK/Xq2OI
         OItJ185Tq/UmmnhI2p1aMrUicy8i3oVf1pRRWNhEMlANRqQpgfuNn+gjaIbzjjXSO8VC
         Ko1lcXlU+lJRPxlq+aQv73Ob//UYN40/BZPx0mGmimzdcVxU/MjBCIMgIri2/n9Dvgm8
         fLOw==
X-Gm-Message-State: AOJu0Yxhu4s3Lb8+v/mpCzq7hvwO3L88ka2P7gPIJOiA+evrVbvud0Jv
        WRcyoxv/P7rl0cq/6wOM3b0=
X-Google-Smtp-Source: AGHT+IGan85eJL3k+7WmQDESk+9Zinrj8rDnKQeCJHeFU6qGhsNmoVgpkUeShEYgwcwZtqDNLjLoHw==
X-Received: by 2002:a17:907:7795:b0:9a1:db97:62a1 with SMTP id ky21-20020a170907779500b009a1db9762a1mr7028205ejc.46.1694428477772;
        Mon, 11 Sep 2023 03:34:37 -0700 (PDT)
Received: from localhost (fwdproxy-cln-004.fbsv.net. [2a03:2880:31ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id me15-20020a170906aecf00b009a193a5acffsm5073750ejb.121.2023.09.11.03.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 03:34:37 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        martin.lau@linux.dev, krisman@suse.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v5 4/8] selftests/net: Extract uring helpers to be reusable
Date:   Mon, 11 Sep 2023 03:34:03 -0700
Message-Id: <20230911103407.1393149-5-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230911103407.1393149-1-leitao@debian.org>
References: <20230911103407.1393149-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of defining basic io_uring functions in the test case, move them
to a common directory, so, other tests can use them.

This simplify the test code and reuse the common "mini" liburing
infrastructure. This is basically a copy of what we have in
io_uring_zerocopy_tx with some minor improvements.

A follow-up test will use the same helpers in a BPF sockopt test.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 tools/include/io_uring/mini_liburing.h        | 292 ++++++++++++++++++
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/io_uring_zerocopy_tx.c      | 268 +---------------
 3 files changed, 295 insertions(+), 266 deletions(-)
 create mode 100644 tools/include/io_uring/mini_liburing.h

diff --git a/tools/include/io_uring/mini_liburing.h b/tools/include/io_uring/mini_liburing.h
new file mode 100644
index 000000000000..e0e1e76def25
--- /dev/null
+++ b/tools/include/io_uring/mini_liburing.h
@@ -0,0 +1,292 @@
+/* SPDX-License-Identifier: MIT */
+
+#include <linux/io_uring.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+struct io_sq_ring {
+	unsigned int *head;
+	unsigned int *tail;
+	unsigned int *ring_mask;
+	unsigned int *ring_entries;
+	unsigned int *flags;
+	unsigned int *array;
+};
+
+struct io_cq_ring {
+	unsigned int *head;
+	unsigned int *tail;
+	unsigned int *ring_mask;
+	unsigned int *ring_entries;
+	struct io_uring_cqe *cqes;
+};
+
+struct io_uring_sq {
+	unsigned int *khead;
+	unsigned int *ktail;
+	unsigned int *kring_mask;
+	unsigned int *kring_entries;
+	unsigned int *kflags;
+	unsigned int *kdropped;
+	unsigned int *array;
+	struct io_uring_sqe *sqes;
+
+	unsigned int sqe_head;
+	unsigned int sqe_tail;
+
+	size_t ring_sz;
+};
+
+struct io_uring_cq {
+	unsigned int *khead;
+	unsigned int *ktail;
+	unsigned int *kring_mask;
+	unsigned int *kring_entries;
+	unsigned int *koverflow;
+	struct io_uring_cqe *cqes;
+
+	size_t ring_sz;
+};
+
+struct io_uring {
+	struct io_uring_sq sq;
+	struct io_uring_cq cq;
+	int ring_fd;
+};
+
+#if defined(__x86_64) || defined(__i386__)
+#define read_barrier()	__asm__ __volatile__("":::"memory")
+#define write_barrier()	__asm__ __volatile__("":::"memory")
+#else
+#define read_barrier()	__sync_synchronize()
+#define write_barrier()	__sync_synchronize()
+#endif
+
+static inline int io_uring_mmap(int fd, struct io_uring_params *p,
+				struct io_uring_sq *sq, struct io_uring_cq *cq)
+{
+	size_t size;
+	void *ptr;
+	int ret;
+
+	sq->ring_sz = p->sq_off.array + p->sq_entries * sizeof(unsigned int);
+	ptr = mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
+		   MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQ_RING);
+	if (ptr == MAP_FAILED)
+		return -errno;
+	sq->khead = ptr + p->sq_off.head;
+	sq->ktail = ptr + p->sq_off.tail;
+	sq->kring_mask = ptr + p->sq_off.ring_mask;
+	sq->kring_entries = ptr + p->sq_off.ring_entries;
+	sq->kflags = ptr + p->sq_off.flags;
+	sq->kdropped = ptr + p->sq_off.dropped;
+	sq->array = ptr + p->sq_off.array;
+
+	size = p->sq_entries * sizeof(struct io_uring_sqe);
+	sq->sqes = mmap(0, size, PROT_READ | PROT_WRITE,
+			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQES);
+	if (sq->sqes == MAP_FAILED) {
+		ret = -errno;
+err:
+		munmap(sq->khead, sq->ring_sz);
+		return ret;
+	}
+
+	cq->ring_sz = p->cq_off.cqes + p->cq_entries * sizeof(struct io_uring_cqe);
+	ptr = mmap(0, cq->ring_sz, PROT_READ | PROT_WRITE,
+		   MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_CQ_RING);
+	if (ptr == MAP_FAILED) {
+		ret = -errno;
+		munmap(sq->sqes, p->sq_entries * sizeof(struct io_uring_sqe));
+		goto err;
+	}
+	cq->khead = ptr + p->cq_off.head;
+	cq->ktail = ptr + p->cq_off.tail;
+	cq->kring_mask = ptr + p->cq_off.ring_mask;
+	cq->kring_entries = ptr + p->cq_off.ring_entries;
+	cq->koverflow = ptr + p->cq_off.overflow;
+	cq->cqes = ptr + p->cq_off.cqes;
+	return 0;
+}
+
+static inline int io_uring_setup(unsigned int entries,
+				 struct io_uring_params *p)
+{
+	return syscall(__NR_io_uring_setup, entries, p);
+}
+
+static inline int io_uring_enter(int fd, unsigned int to_submit,
+				 unsigned int min_complete,
+				 unsigned int flags, sigset_t *sig)
+{
+	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
+		       flags, sig, _NSIG / 8);
+}
+
+static inline int io_uring_queue_init(unsigned int entries,
+				      struct io_uring *ring,
+				      unsigned int flags)
+{
+	struct io_uring_params p;
+	int fd, ret;
+
+	memset(ring, 0, sizeof(*ring));
+	memset(&p, 0, sizeof(p));
+	p.flags = flags;
+
+	fd = io_uring_setup(entries, &p);
+	if (fd < 0)
+		return fd;
+	ret = io_uring_mmap(fd, &p, &ring->sq, &ring->cq);
+	if (!ret)
+		ring->ring_fd = fd;
+	else
+		close(fd);
+	return ret;
+}
+
+/* Get a sqe */
+static inline struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
+{
+	struct io_uring_sq *sq = &ring->sq;
+
+	if (sq->sqe_tail + 1 - sq->sqe_head > *sq->kring_entries)
+		return NULL;
+	return &sq->sqes[sq->sqe_tail++ & *sq->kring_mask];
+}
+
+static inline int io_uring_wait_cqe(struct io_uring *ring,
+				    struct io_uring_cqe **cqe_ptr)
+{
+	struct io_uring_cq *cq = &ring->cq;
+	const unsigned int mask = *cq->kring_mask;
+	unsigned int head = *cq->khead;
+	int ret;
+
+	*cqe_ptr = NULL;
+	do {
+		read_barrier();
+		if (head != *cq->ktail) {
+			*cqe_ptr = &cq->cqes[head & mask];
+			break;
+		}
+		ret = io_uring_enter(ring->ring_fd, 0, 1,
+				     IORING_ENTER_GETEVENTS, NULL);
+		if (ret < 0)
+			return -errno;
+	} while (1);
+
+	return 0;
+}
+
+static inline int io_uring_submit(struct io_uring *ring)
+{
+	struct io_uring_sq *sq = &ring->sq;
+	const unsigned int mask = *sq->kring_mask;
+	unsigned int ktail, submitted, to_submit;
+	int ret;
+
+	read_barrier();
+	if (*sq->khead != *sq->ktail) {
+		submitted = *sq->kring_entries;
+		goto submit;
+	}
+	if (sq->sqe_head == sq->sqe_tail)
+		return 0;
+
+	ktail = *sq->ktail;
+	to_submit = sq->sqe_tail - sq->sqe_head;
+	for (submitted = 0; submitted < to_submit; submitted++) {
+		read_barrier();
+		sq->array[ktail++ & mask] = sq->sqe_head++ & mask;
+	}
+	if (!submitted)
+		return 0;
+
+	if (*sq->ktail != ktail) {
+		write_barrier();
+		*sq->ktail = ktail;
+		write_barrier();
+	}
+submit:
+	ret = io_uring_enter(ring->ring_fd, submitted, 0,
+			     IORING_ENTER_GETEVENTS, NULL);
+	return ret < 0 ? -errno : ret;
+}
+
+static inline void io_uring_queue_exit(struct io_uring *ring)
+{
+	struct io_uring_sq *sq = &ring->sq;
+
+	munmap(sq->sqes, *sq->kring_entries * sizeof(struct io_uring_sqe));
+	munmap(sq->khead, sq->ring_sz);
+	close(ring->ring_fd);
+}
+
+/* Prepare and send the SQE */
+static inline void io_uring_prep_cmd(struct io_uring_sqe *sqe, int op,
+				     int sockfd,
+				     int level, int optname,
+				     const void *optval,
+				     const socklen_t optlen)
+{
+	memset(sqe, 0, sizeof(*sqe));
+	sqe->opcode = (__u8)IORING_OP_URING_CMD;
+	sqe->fd = sockfd;
+	sqe->cmd_op = op;
+
+	sqe->level = level;
+	sqe->optname = optname;
+	sqe->optval = (unsigned long long)optval;
+	sqe->optlen = (unsigned long long)optlen;
+}
+
+static inline void io_uring_prep_cmd_get(struct io_uring_sqe *sqe, int op,
+					 int sockfd,
+					 int level, int optname,
+					 const void *optval,
+					 const socklen_t *optlen)
+{
+	io_uring_prep_cmd(sqe, op, sockfd, level, optname, optval, 0);
+	sqe->optlen = (unsigned long long)optlen;
+}
+
+static inline int io_uring_register_buffers(struct io_uring *ring,
+					    const struct iovec *iovecs,
+					    unsigned int nr_iovecs)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_register, ring->ring_fd,
+		      IORING_REGISTER_BUFFERS, iovecs, nr_iovecs);
+	return (ret < 0) ? -errno : ret;
+}
+
+static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
+				      const void *buf, size_t len, int flags)
+{
+	memset(sqe, 0, sizeof(*sqe));
+	sqe->opcode = (__u8)IORING_OP_SEND;
+	sqe->fd = sockfd;
+	sqe->addr = (unsigned long)buf;
+	sqe->len = len;
+	sqe->msg_flags = (__u32)flags;
+}
+
+static inline void io_uring_prep_sendzc(struct io_uring_sqe *sqe, int sockfd,
+					const void *buf, size_t len, int flags,
+					unsigned int zc_flags)
+{
+	io_uring_prep_send(sqe, sockfd, buf, len, flags);
+	sqe->opcode = (__u8)IORING_OP_SEND_ZC;
+	sqe->ioprio = zc_flags;
+}
+
+static inline void io_uring_cqe_seen(struct io_uring *ring)
+{
+	*(&ring->cq)->khead += 1;
+	write_barrier();
+}
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 8b017070960d..f8d99837b9dc 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -98,6 +98,7 @@ $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
 $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread -lcrypto
 $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
 $(OUTPUT)/bind_bhash: LDLIBS += -lpthread
+$(OUTPUT)/io_uring_zerocopy_tx: CFLAGS += -I../../../include/
 
 # Rules to generate bpf obj nat6to4.o
 CLANG ?= clang
diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.c b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
index 154287740172..76e604e4810e 100644
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.c
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
@@ -36,6 +36,8 @@
 #include <sys/un.h>
 #include <sys/wait.h>
 
+#include <io_uring/mini_liburing.h>
+
 #define NOTIF_TAG 0xfffffffULL
 #define NONZC_TAG 0
 #define ZC_TAG 1
@@ -60,272 +62,6 @@ static struct sockaddr_storage cfg_dst_addr;
 
 static char payload[IP_MAXPACKET] __attribute__((aligned(4096)));
 
-struct io_sq_ring {
-	unsigned *head;
-	unsigned *tail;
-	unsigned *ring_mask;
-	unsigned *ring_entries;
-	unsigned *flags;
-	unsigned *array;
-};
-
-struct io_cq_ring {
-	unsigned *head;
-	unsigned *tail;
-	unsigned *ring_mask;
-	unsigned *ring_entries;
-	struct io_uring_cqe *cqes;
-};
-
-struct io_uring_sq {
-	unsigned *khead;
-	unsigned *ktail;
-	unsigned *kring_mask;
-	unsigned *kring_entries;
-	unsigned *kflags;
-	unsigned *kdropped;
-	unsigned *array;
-	struct io_uring_sqe *sqes;
-
-	unsigned sqe_head;
-	unsigned sqe_tail;
-
-	size_t ring_sz;
-};
-
-struct io_uring_cq {
-	unsigned *khead;
-	unsigned *ktail;
-	unsigned *kring_mask;
-	unsigned *kring_entries;
-	unsigned *koverflow;
-	struct io_uring_cqe *cqes;
-
-	size_t ring_sz;
-};
-
-struct io_uring {
-	struct io_uring_sq sq;
-	struct io_uring_cq cq;
-	int ring_fd;
-};
-
-#ifdef __alpha__
-# ifndef __NR_io_uring_setup
-#  define __NR_io_uring_setup		535
-# endif
-# ifndef __NR_io_uring_enter
-#  define __NR_io_uring_enter		536
-# endif
-# ifndef __NR_io_uring_register
-#  define __NR_io_uring_register	537
-# endif
-#else /* !__alpha__ */
-# ifndef __NR_io_uring_setup
-#  define __NR_io_uring_setup		425
-# endif
-# ifndef __NR_io_uring_enter
-#  define __NR_io_uring_enter		426
-# endif
-# ifndef __NR_io_uring_register
-#  define __NR_io_uring_register	427
-# endif
-#endif
-
-#if defined(__x86_64) || defined(__i386__)
-#define read_barrier()	__asm__ __volatile__("":::"memory")
-#define write_barrier()	__asm__ __volatile__("":::"memory")
-#else
-
-#define read_barrier()	__sync_synchronize()
-#define write_barrier()	__sync_synchronize()
-#endif
-
-static int io_uring_setup(unsigned int entries, struct io_uring_params *p)
-{
-	return syscall(__NR_io_uring_setup, entries, p);
-}
-
-static int io_uring_enter(int fd, unsigned int to_submit,
-			  unsigned int min_complete,
-			  unsigned int flags, sigset_t *sig)
-{
-	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
-			flags, sig, _NSIG / 8);
-}
-
-static int io_uring_register_buffers(struct io_uring *ring,
-				     const struct iovec *iovecs,
-				     unsigned nr_iovecs)
-{
-	int ret;
-
-	ret = syscall(__NR_io_uring_register, ring->ring_fd,
-		      IORING_REGISTER_BUFFERS, iovecs, nr_iovecs);
-	return (ret < 0) ? -errno : ret;
-}
-
-static int io_uring_mmap(int fd, struct io_uring_params *p,
-			 struct io_uring_sq *sq, struct io_uring_cq *cq)
-{
-	size_t size;
-	void *ptr;
-	int ret;
-
-	sq->ring_sz = p->sq_off.array + p->sq_entries * sizeof(unsigned);
-	ptr = mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
-		   MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQ_RING);
-	if (ptr == MAP_FAILED)
-		return -errno;
-	sq->khead = ptr + p->sq_off.head;
-	sq->ktail = ptr + p->sq_off.tail;
-	sq->kring_mask = ptr + p->sq_off.ring_mask;
-	sq->kring_entries = ptr + p->sq_off.ring_entries;
-	sq->kflags = ptr + p->sq_off.flags;
-	sq->kdropped = ptr + p->sq_off.dropped;
-	sq->array = ptr + p->sq_off.array;
-
-	size = p->sq_entries * sizeof(struct io_uring_sqe);
-	sq->sqes = mmap(0, size, PROT_READ | PROT_WRITE,
-			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQES);
-	if (sq->sqes == MAP_FAILED) {
-		ret = -errno;
-err:
-		munmap(sq->khead, sq->ring_sz);
-		return ret;
-	}
-
-	cq->ring_sz = p->cq_off.cqes + p->cq_entries * sizeof(struct io_uring_cqe);
-	ptr = mmap(0, cq->ring_sz, PROT_READ | PROT_WRITE,
-			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_CQ_RING);
-	if (ptr == MAP_FAILED) {
-		ret = -errno;
-		munmap(sq->sqes, p->sq_entries * sizeof(struct io_uring_sqe));
-		goto err;
-	}
-	cq->khead = ptr + p->cq_off.head;
-	cq->ktail = ptr + p->cq_off.tail;
-	cq->kring_mask = ptr + p->cq_off.ring_mask;
-	cq->kring_entries = ptr + p->cq_off.ring_entries;
-	cq->koverflow = ptr + p->cq_off.overflow;
-	cq->cqes = ptr + p->cq_off.cqes;
-	return 0;
-}
-
-static int io_uring_queue_init(unsigned entries, struct io_uring *ring,
-			       unsigned flags)
-{
-	struct io_uring_params p;
-	int fd, ret;
-
-	memset(ring, 0, sizeof(*ring));
-	memset(&p, 0, sizeof(p));
-	p.flags = flags;
-
-	fd = io_uring_setup(entries, &p);
-	if (fd < 0)
-		return fd;
-	ret = io_uring_mmap(fd, &p, &ring->sq, &ring->cq);
-	if (!ret)
-		ring->ring_fd = fd;
-	else
-		close(fd);
-	return ret;
-}
-
-static int io_uring_submit(struct io_uring *ring)
-{
-	struct io_uring_sq *sq = &ring->sq;
-	const unsigned mask = *sq->kring_mask;
-	unsigned ktail, submitted, to_submit;
-	int ret;
-
-	read_barrier();
-	if (*sq->khead != *sq->ktail) {
-		submitted = *sq->kring_entries;
-		goto submit;
-	}
-	if (sq->sqe_head == sq->sqe_tail)
-		return 0;
-
-	ktail = *sq->ktail;
-	to_submit = sq->sqe_tail - sq->sqe_head;
-	for (submitted = 0; submitted < to_submit; submitted++) {
-		read_barrier();
-		sq->array[ktail++ & mask] = sq->sqe_head++ & mask;
-	}
-	if (!submitted)
-		return 0;
-
-	if (*sq->ktail != ktail) {
-		write_barrier();
-		*sq->ktail = ktail;
-		write_barrier();
-	}
-submit:
-	ret = io_uring_enter(ring->ring_fd, submitted, 0,
-				IORING_ENTER_GETEVENTS, NULL);
-	return ret < 0 ? -errno : ret;
-}
-
-static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
-				      const void *buf, size_t len, int flags)
-{
-	memset(sqe, 0, sizeof(*sqe));
-	sqe->opcode = (__u8) IORING_OP_SEND;
-	sqe->fd = sockfd;
-	sqe->addr = (unsigned long) buf;
-	sqe->len = len;
-	sqe->msg_flags = (__u32) flags;
-}
-
-static inline void io_uring_prep_sendzc(struct io_uring_sqe *sqe, int sockfd,
-				        const void *buf, size_t len, int flags,
-				        unsigned zc_flags)
-{
-	io_uring_prep_send(sqe, sockfd, buf, len, flags);
-	sqe->opcode = (__u8) IORING_OP_SEND_ZC;
-	sqe->ioprio = zc_flags;
-}
-
-static struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring)
-{
-	struct io_uring_sq *sq = &ring->sq;
-
-	if (sq->sqe_tail + 1 - sq->sqe_head > *sq->kring_entries)
-		return NULL;
-	return &sq->sqes[sq->sqe_tail++ & *sq->kring_mask];
-}
-
-static int io_uring_wait_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr)
-{
-	struct io_uring_cq *cq = &ring->cq;
-	const unsigned mask = *cq->kring_mask;
-	unsigned head = *cq->khead;
-	int ret;
-
-	*cqe_ptr = NULL;
-	do {
-		read_barrier();
-		if (head != *cq->ktail) {
-			*cqe_ptr = &cq->cqes[head & mask];
-			break;
-		}
-		ret = io_uring_enter(ring->ring_fd, 0, 1,
-					IORING_ENTER_GETEVENTS, NULL);
-		if (ret < 0)
-			return -errno;
-	} while (1);
-
-	return 0;
-}
-
-static inline void io_uring_cqe_seen(struct io_uring *ring)
-{
-	*(&ring->cq)->khead += 1;
-	write_barrier();
-}
-
 static unsigned long gettimeofday_ms(void)
 {
 	struct timeval tv;
-- 
2.34.1

