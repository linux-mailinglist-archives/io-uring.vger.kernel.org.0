Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BC357FCEC
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 12:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbiGYKFS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 06:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiGYKFR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 06:05:17 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB22FCE
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:13 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 8-20020a05600c024800b003a2fe343db1so6043799wmj.1
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PHepNmSKP7t5bUW599osBQFozm7VKZstJuUhkkSkJPk=;
        b=aEZvzXdqyv3tmCDFSx7XG0es9IsMCdqDSeRRXo6jb+RFLkckmyFVZIDy/k2EL29AQR
         KYapZmogQGnMc74DQrbpRRjdnbd0JIMFh0PkvrAFJ4rQnCmWkxS8xOQwC5xqEEddiQad
         oJ2a8mBJy0PtRI03WkX4lnBxE0qPDhPA90Pw34eDJqEjKg/XnSKUOHpnw3MeXR7JawJV
         C6lET2dW2MPuHMY4/+pgAg7XHU19nY8qOr7tCj8RqM8O7qsMqKxKhZ3j7bYUxpQZKzO7
         sx3MI394sQAn+M5zN93KXImsfvyqk+/9EYxcjfLDAwcdjishGK9tXPAZaKFQQWS6/cuw
         MStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PHepNmSKP7t5bUW599osBQFozm7VKZstJuUhkkSkJPk=;
        b=Kmz9K4dbTUuZsSP8IRu7SIP+ZqJlTZz8SSBzzNfoZQqIRPtQL3QtES0iFi0+MyHTQA
         cGdKSMOvNQi5dzOPqWrku8I82+8UamqCq8s8GEeB47IYruchSwstGkvrIg7iZ0dqopyR
         Ah8Xv4sPJms1fDA0h0vExwYyRt3rhQHg6U7vdUgbncoSFnQPj0rI6EbtWs2NmK8kE7Yw
         TWuDcf1iAcb4VaW7KWPq+evaoF/2n0/tRft1FGN1aCfDf7n2MyrSpSZ8aSzjdjCnFlYQ
         Ib2uaoEjjisbs4JufuN6WBxnKJpceW5QY/t/ucStL5fVlYacDvr3fnVXByxw4BDSeBeE
         0Few==
X-Gm-Message-State: AJIora8khHPJxYaZgs3DtxAvzN/Nx4fWsTB2k8BTKePgGnwVSy3M0DMf
        /9B1rGMzcyONt0gPrnJHScyybuE3JWIHLw==
X-Google-Smtp-Source: AGRyM1uuFZzle3bbFBinmQLvkBzbKdkF3/dBLOn6V4F+UJ14sljqukNtC1c58ORmw0O4Sj1mrWRJsg==
X-Received: by 2002:a05:600c:358d:b0:3a3:2fe2:7d5e with SMTP id p13-20020a05600c358d00b003a32fe27d5emr15599997wmq.77.1658743511771;
        Mon, 25 Jul 2022 03:05:11 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003a32251c3f9sm20553959wms.5.2022.07.25.03.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 03:05:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/4] tests: add tests for zerocopy send and notifications
Date:   Mon, 25 Jul 2022 11:03:56 +0100
Message-Id: <92dccd4b172d5511646d72c51205241aa2e62458.1658743360.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658743360.git.asml.silence@gmail.com>
References: <cover.1658743360.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile     |   1 +
 test/send-zcopy.c | 879 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 880 insertions(+)
 create mode 100644 test/send-zcopy.c

diff --git a/test/Makefile b/test/Makefile
index 8945368..7b6018c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -175,6 +175,7 @@ test_srcs := \
 	xattr.c \
 	skip-cqe.c \
 	single-issuer.c \
+	send-zcopy.c \
 	# EOL
 
 all_targets :=
diff --git a/test/send-zcopy.c b/test/send-zcopy.c
new file mode 100644
index 0000000..cd7d655
--- /dev/null
+++ b/test/send-zcopy.c
@@ -0,0 +1,879 @@
+/* SPDX-License-Identifier: MIT */
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <assert.h>
+#include <errno.h>
+#include <error.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdbool.h>
+#include <string.h>
+
+#include <arpa/inet.h>
+#include <linux/errqueue.h>
+#include <linux/if_packet.h>
+#include <linux/ipv6.h>
+#include <linux/socket.h>
+#include <linux/sockios.h>
+#include <net/ethernet.h>
+#include <net/if.h>
+#include <netinet/ip.h>
+#include <netinet/in.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+#include <netinet/udp.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <sys/un.h>
+#include <sys/ioctl.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+#define MAX_MSG	128
+
+#define PORT	10200
+#define HOST	"127.0.0.1"
+#define HOSTV6	"::1"
+
+#define NR_SLOTS 5
+#define ZC_TAG 10000
+#define MAX_PAYLOAD 8195
+#define BUFFER_OFFSET 41
+
+#ifndef ARRAY_SIZE
+	#define ARRAY_SIZE(a) (sizeof(a)/sizeof((a)[0]))
+#endif
+
+static int seqs[NR_SLOTS];
+static char tx_buffer[MAX_PAYLOAD] __attribute__((aligned(4096)));
+static char rx_buffer[MAX_PAYLOAD] __attribute__((aligned(4096)));
+static struct iovec buffers_iov[] = {
+	{ .iov_base = tx_buffer,
+	  .iov_len = sizeof(tx_buffer), },
+	{ .iov_base = tx_buffer + BUFFER_OFFSET,
+	  .iov_len = sizeof(tx_buffer) - BUFFER_OFFSET - 13, },
+};
+
+static inline bool tag_userdata(__u64 user_data)
+{
+	return ZC_TAG <= user_data && user_data < ZC_TAG + NR_SLOTS;
+}
+
+static bool check_cq_empty(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe = NULL;
+	int ret;
+
+	ret = io_uring_peek_cqe(ring, &cqe); /* nothing should be there */
+	return ret == -EAGAIN;
+}
+
+static int register_notifications(struct io_uring *ring)
+{
+	struct io_uring_notification_slot slots[NR_SLOTS] = {};
+	int i;
+
+	memset(seqs, 0, sizeof(seqs));
+	for (i = 0; i < NR_SLOTS; i++)
+		slots[i].tag = ZC_TAG + i;
+	return io_uring_register_notifications(ring, NR_SLOTS, slots);
+}
+
+static int reregister_notifications(struct io_uring *ring)
+{
+	int ret;
+
+	ret = io_uring_unregister_notifications(ring);
+	if (ret) {
+		fprintf(stderr, "unreg notifiers failed %i\n", ret);
+		return ret;
+	}
+
+	return register_notifications(ring);
+}
+
+static int do_one(struct io_uring *ring, int sock_tx, int slot_idx)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int msg_flags = 0;
+	unsigned zc_flags = 0;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, 1, msg_flags,
+			     slot_idx, zc_flags);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(ring);
+	assert(ret == 1);
+	ret = io_uring_wait_cqe(ring, &cqe);
+	assert(!ret);
+	assert(cqe->user_data == 1);
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	assert(check_cq_empty(ring));
+	return ret;
+}
+
+static int test_invalid_slot(struct io_uring *ring, int sock_tx, int sock_rx)
+{
+	int ret;
+
+	ret = do_one(ring, sock_tx, NR_SLOTS);
+	assert(ret == -EINVAL);
+	return 0;
+}
+
+static int test_basic_send(struct io_uring *ring, int sock_tx, int sock_rx)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int msg_flags = 0;
+	int slot_idx = 0;
+	unsigned zc_flags = 0;
+	int payload_size = 100;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size, msg_flags,
+			     slot_idx, zc_flags);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(ring);
+	assert(ret == 1);
+	ret = io_uring_wait_cqe(ring, &cqe);
+	assert(!ret);
+	assert(cqe->user_data == 1 && cqe->res >= 0);
+	io_uring_cqe_seen(ring, cqe);
+	assert(check_cq_empty(ring));
+
+	ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
+	assert(ret == payload_size);
+	return 0;
+}
+
+static int test_send_flush(struct io_uring *ring, int sock_tx, int sock_rx)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int msg_flags = 0;
+	int slot_idx = 0;
+	unsigned zc_flags = 0;
+	int payload_size = 100;
+	int ret, i, j;
+	int req_cqes, notif_cqes;
+
+	/* now do send+flush, do many times to verify seqs */
+	for (j = 0; j < NR_SLOTS * 5; j++) {
+		zc_flags = IORING_RECVSEND_NOTIF_FLUSH;
+		slot_idx = rand() % NR_SLOTS;
+		sqe = io_uring_get_sqe(ring);
+		io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size,
+				     msg_flags, slot_idx, zc_flags);
+		sqe->user_data = 1;
+
+		ret = io_uring_submit(ring);
+		assert(ret == 1);
+
+		req_cqes = notif_cqes = 1;
+		for (i = 0; i < 2; i ++) {
+			ret = io_uring_wait_cqe(ring, &cqe);
+			assert(!ret);
+
+			if (cqe->user_data == 1) {
+				assert(req_cqes > 0);
+				req_cqes--;
+				assert(cqe->res == payload_size);
+			} else if (cqe->user_data == ZC_TAG + slot_idx) {
+				assert(notif_cqes > 0);
+				notif_cqes--;
+				assert(cqe->res == 0 && cqe->flags == seqs[slot_idx]);
+				seqs[slot_idx]++;
+			} else {
+				fprintf(stderr, "invalid cqe %lu %i\n",
+					(unsigned long)cqe->user_data, cqe->res);
+				return -1;
+			}
+			io_uring_cqe_seen(ring, cqe);
+		}
+		assert(check_cq_empty(ring));
+
+		ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
+		assert(ret == payload_size);
+	}
+	return 0;
+}
+
+static int test_multireq_notif(struct io_uring *ring, int sock_tx, int sock_rx)
+{
+	bool slot_seen[NR_SLOTS] = {};
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int msg_flags = 0;
+	int slot_idx = 0;
+	unsigned zc_flags = 0;
+	int payload_size = 1;
+	int ret, j, i = 0;
+	int nr = NR_SLOTS * 21;
+
+	while (i < nr) {
+		int nr_per_wave = 23;
+
+		for (j = 0; j < nr_per_wave && i < nr; j++, i++) {
+			slot_idx = rand() % NR_SLOTS;
+			sqe = io_uring_get_sqe(ring);
+			io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size,
+					     msg_flags, slot_idx, zc_flags);
+			sqe->user_data = i;
+		}
+		ret = io_uring_submit(ring);
+		assert(ret == j);
+	}
+
+	for (i = 0; i < nr; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		assert(!ret);
+		assert(cqe->user_data < nr && cqe->res == payload_size);
+		io_uring_cqe_seen(ring, cqe);
+
+		ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
+		assert(ret == payload_size);
+	}
+	assert(check_cq_empty(ring));
+
+	zc_flags = IORING_RECVSEND_NOTIF_FLUSH;
+	for (slot_idx = 0; slot_idx < NR_SLOTS; slot_idx++) {
+		sqe = io_uring_get_sqe(ring);
+		io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size,
+				     msg_flags, slot_idx, zc_flags);
+		sqe->user_data = slot_idx;
+		/* just to simplify cqe handling */
+		sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+	}
+	ret = io_uring_submit(ring);
+	assert(ret == NR_SLOTS);
+
+	for (i = 0; i < NR_SLOTS; i++) {
+		int slot_idx;
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		assert(!ret);
+		assert(tag_userdata(cqe->user_data));
+
+		slot_idx = cqe->user_data - ZC_TAG;
+		assert(!slot_seen[slot_idx]);
+		slot_seen[slot_idx] = true;
+
+		assert(cqe->res == 0 && cqe->flags == seqs[slot_idx]);
+		seqs[slot_idx]++;
+		io_uring_cqe_seen(ring, cqe);
+
+		ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
+		assert(ret == payload_size);
+	}
+	assert(check_cq_empty(ring));
+
+	for (i = 0; i < NR_SLOTS; i++)
+		assert(slot_seen[i]);
+	return 0;
+}
+
+static int test_multi_send_flushing(struct io_uring *ring, int sock_tx, int sock_rx)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	unsigned zc_flags = IORING_RECVSEND_NOTIF_FLUSH;
+	int msg_flags = 0, slot_idx = 0;
+	int payload_size = 1;
+	int ret, j, i = 0;
+	int nr = NR_SLOTS * 30;
+	unsigned long long check = 0, expected = 0;
+
+	while (i < nr) {
+		int nr_per_wave = 25;
+
+		for (j = 0; j < nr_per_wave && i < nr; j++, i++) {
+			sqe = io_uring_get_sqe(ring);
+			io_uring_prep_sendzc(sqe, sock_tx, tx_buffer, payload_size,
+					     msg_flags, slot_idx, zc_flags);
+			sqe->user_data = 1;
+			sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+		}
+		ret = io_uring_submit(ring);
+		assert(ret == j);
+	}
+
+	for (i = 0; i < nr; i++) {
+		int seq;
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		assert(!ret);
+		assert(!cqe->res);
+		assert(tag_userdata(cqe->user_data));
+
+		seq = cqe->flags;
+		check += seq * 100007UL;
+		io_uring_cqe_seen(ring, cqe);
+
+		ret = recv(sock_rx, rx_buffer, payload_size, MSG_TRUNC);
+		assert(ret == payload_size);
+	}
+	assert(check_cq_empty(ring));
+
+	for (i = 0; i < nr; i++)
+		expected += (i + seqs[slot_idx]) * 100007UL;
+	assert(check == expected);
+	seqs[slot_idx] += nr;
+	return 0;
+}
+
+static int do_one_fail_notif_flush(struct io_uring *ring, int off, int nr)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	/* single out-of-bounds slot */
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_notif_update(sqe, 0, off, nr);
+	sqe->user_data = 1;
+	ret = io_uring_submit(ring);
+	assert(ret == 1);
+	ret = io_uring_wait_cqe(ring, &cqe);
+	assert(!ret && cqe->user_data == 1);
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+}
+
+static int test_update_flush_fail(struct io_uring *ring)
+{
+	int ret;
+
+	/* single out-of-bounds slot */
+	ret = do_one_fail_notif_flush(ring, NR_SLOTS, 1);
+	assert(ret == -EINVAL);
+
+	/* out-of-bounds range */
+	ret = do_one_fail_notif_flush(ring, 0, NR_SLOTS + 3);
+	assert(ret == -EINVAL);
+	ret = do_one_fail_notif_flush(ring, NR_SLOTS - 1, 2);
+	assert(ret == -EINVAL);
+
+	/* overflow checks, note it's u32 internally */
+	ret = do_one_fail_notif_flush(ring, ~(__u32)0, 1);
+	assert(ret == -EOVERFLOW);
+	ret = do_one_fail_notif_flush(ring, NR_SLOTS - 1, ~(__u32)0);
+	assert(ret == -EOVERFLOW);
+	return 0;
+}
+
+static void do_one_consume(struct io_uring *ring, int sock_tx, int sock_rx,
+			  int slot_idx)
+{
+	int ret;
+
+	ret = do_one(ring, sock_tx, slot_idx);
+	assert(ret == 1);
+
+	ret = recv(sock_rx, rx_buffer, 1, MSG_TRUNC);
+	assert(ret == 1);
+}
+
+static int test_update_flush(struct io_uring *ring, int sock_tx, int sock_rx)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int offset = 1, nr_to_flush = 3;
+	int ret, i, slot_idx;
+
+	/*
+	 * Flush will be skipped for unused slots, so attached at least 1 req
+	 * to each active notifier / slot
+	 */
+	for (slot_idx = 0; slot_idx < NR_SLOTS; slot_idx++)
+		do_one_consume(ring, sock_tx, sock_rx, slot_idx);
+
+	assert(check_cq_empty(ring));
+
+	/* flush first */
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_notif_update(sqe, 0, 0, 1);
+	sqe->user_data = 1;
+	sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+	ret = io_uring_submit(ring);
+	assert(ret == 1);
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	assert(!ret && !cqe->res && cqe->user_data == ZC_TAG);
+	assert(cqe->flags == seqs[0]);
+	seqs[0]++;
+	io_uring_cqe_seen(ring, cqe);
+	do_one_consume(ring, sock_tx, sock_rx, 0);
+	assert(check_cq_empty(ring));
+
+	/* flush last */
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_notif_update(sqe, 0, NR_SLOTS - 1, 1);
+	sqe->user_data = 1;
+	sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+	ret = io_uring_submit(ring);
+	assert(ret == 1);
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	assert(!ret && !cqe->res && cqe->user_data == ZC_TAG + NR_SLOTS - 1);
+	assert(cqe->flags == seqs[NR_SLOTS - 1]);
+	seqs[NR_SLOTS - 1]++;
+	io_uring_cqe_seen(ring, cqe);
+	assert(check_cq_empty(ring));
+
+	/* we left the last slot without attached requests, flush should ignore it */
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_notif_update(sqe, 0, NR_SLOTS - 1, 1);
+	sqe->user_data = 1;
+	ret = io_uring_submit(ring);
+	assert(ret == 1);
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	assert(!ret && !cqe->res && cqe->user_data == 1);
+	io_uring_cqe_seen(ring, cqe);
+	assert(check_cq_empty(ring));
+
+	/* flush range */
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_notif_update(sqe, 0, offset, nr_to_flush);
+	sqe->user_data = 1;
+	sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+	ret = io_uring_submit(ring);
+	assert(ret == 1);
+
+	for (i = 0; i < nr_to_flush; i++) {
+		int slot_idx;
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		assert(!ret && !cqe->res);
+		assert(ZC_TAG + offset <= cqe->user_data &&
+		       cqe->user_data < ZC_TAG + offset + nr_to_flush);
+		slot_idx = cqe->user_data - ZC_TAG;
+		assert(cqe->flags == seqs[slot_idx]);
+		seqs[slot_idx]++;
+		io_uring_cqe_seen(ring, cqe);
+	}
+	assert(check_cq_empty(ring));
+	return 0;
+}
+
+static int test_registration(int sock_tx, int sock_rx)
+{
+	struct io_uring_notification_slot slots[2] = {
+		{.tag = 1}, {.tag = 2},
+	};
+	void *invalid_slots = (void *)1UL;
+	struct io_uring ring;
+	int ret, i;
+
+	ret = io_uring_queue_init(4, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_unregister_notifications(&ring);
+	if (ret != -ENXIO) {
+		fprintf(stderr, "unregister nothing: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_register_notifications(&ring, 2, slots);
+	if (ret) {
+		fprintf(stderr, "io_uring_register_notifications failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_register_notifications(&ring, 2, slots);
+	if (ret != -EBUSY) {
+		fprintf(stderr, "double register: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_unregister_notifications(&ring);
+	if (ret) {
+		fprintf(stderr, "unregister failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_register_notifications(&ring, 2, slots);
+	if (ret) {
+		fprintf(stderr, "second register failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = test_invalid_slot(&ring, sock_tx, sock_rx);
+	if (ret) {
+		fprintf(stderr, "test_invalid_slot() failed\n");
+		return ret;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = do_one(&ring, sock_tx, 0);
+		assert(ret == 1);
+
+		ret = recv(sock_rx, rx_buffer, 1, MSG_TRUNC);
+		assert(ret == 1);
+	}
+
+	io_uring_queue_exit(&ring);
+	ret = io_uring_queue_init(4, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_register_notifications(&ring, 4, invalid_slots);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "io_uring_register_notifications with invalid ptr: %d\n", ret);
+		return 1;
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock_server,
+		      bool ipv6, bool client_connect, bool msg_zc)
+{
+	int family, addr_size;
+	int ret, val;
+
+	memset(addr, 0, sizeof(*addr));
+	if (ipv6) {
+		struct sockaddr_in6 *saddr = (struct sockaddr_in6 *)addr;
+
+		family = AF_INET6;
+		saddr->sin6_family = family;
+		saddr->sin6_port = htons(PORT);
+		addr_size = sizeof(*saddr);
+	} else {
+		struct sockaddr_in *saddr = (struct sockaddr_in *)addr;
+
+		family = AF_INET;
+		saddr->sin_family = family;
+		saddr->sin_port = htons(PORT);
+		saddr->sin_addr.s_addr = htonl(INADDR_ANY);
+		addr_size = sizeof(*saddr);
+	}
+
+	/* server sock setup */
+	*sock_server = socket(family, SOCK_DGRAM, 0);
+	if (*sock_server < 0) {
+		perror("socket");
+		return 1;
+	}
+	val = 1;
+	setsockopt(*sock_server, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
+	ret = bind(*sock_server, (struct sockaddr *)addr, addr_size);
+	if (ret < 0) {
+		perror("bind");
+		return 1;
+	}
+
+	if (ipv6) {
+		struct sockaddr_in6 *saddr = (struct sockaddr_in6 *)addr;
+
+		inet_pton(AF_INET6, HOSTV6, &(saddr->sin6_addr));
+	} else {
+		struct sockaddr_in *saddr = (struct sockaddr_in *)addr;
+
+		inet_pton(AF_INET, HOST, &saddr->sin_addr);
+	}
+
+	/* client sock setup */
+	*sock_client = socket(family, SOCK_DGRAM, 0);
+	if (*sock_client < 0) {
+		perror("socket");
+		return 1;
+	}
+	if (client_connect) {
+		ret = connect(*sock_client, (struct sockaddr *)addr, addr_size);
+		if (ret < 0) {
+			perror("connect");
+			return 1;
+		}
+	}
+	if (msg_zc) {
+		val = 1;
+		if (setsockopt(*sock_client, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
+			perror("setsockopt zc");
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
+			     bool fixed_buf, struct sockaddr_storage *addr,
+			     size_t send_size, bool cork, bool mix_register,
+			     int buf_idx)
+{
+	const unsigned slot_idx = 0;
+	const unsigned zc_flags = 0;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int nr_reqs = cork ? 5 : 1;
+	int i, ret;
+	size_t chunk_size = send_size / nr_reqs;
+	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
+	char *buf = buffers_iov[buf_idx].iov_base;
+
+	assert(send_size <= buffers_iov[buf_idx].iov_len);
+	memset(rx_buffer, 0, sizeof(rx_buffer));
+
+	for (i = 0; i < nr_reqs; i++) {
+		bool cur_fixed_buf = fixed_buf;
+		size_t cur_size = chunk_size;
+		int msg_flags = 0;
+
+		if (mix_register)
+			cur_fixed_buf = rand() & 1;
+
+		if (cork && i != nr_reqs - 1)
+			msg_flags = MSG_MORE;
+		if (i == nr_reqs - 1)
+			cur_size = chunk_size_last;
+
+		sqe = io_uring_get_sqe(ring);
+		if (cur_fixed_buf)
+			io_uring_prep_sendzc_fixed(sqe, sock_client,
+					     buf + i * chunk_size,
+					     cur_size, msg_flags, slot_idx,
+					     zc_flags, buf_idx);
+		else
+			io_uring_prep_sendzc(sqe, sock_client,
+					     buf + i * chunk_size,
+					     cur_size, msg_flags, slot_idx,
+					     zc_flags);
+
+		if (addr) {
+			sa_family_t fam = ((struct sockaddr_in *)addr)->sin_family;
+			int addr_len = fam == AF_INET ? sizeof(struct sockaddr_in) :
+							sizeof(struct sockaddr_in6);
+
+			io_uring_prep_sendzc_set_addr(sqe, (const struct sockaddr *)addr,
+						      addr_len);
+		}
+		sqe->user_data = i;
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != nr_reqs)
+		error(1, ret, "submit");
+
+	for (i = 0; i < nr_reqs; i++) {
+		int expected = chunk_size;
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret)
+			error(1, ret, "wait cqe");
+		if (cqe->user_data >= nr_reqs)
+			error(1, cqe->user_data, "invalid user_data");
+		if (cqe->user_data == nr_reqs - 1)
+			expected = chunk_size_last;
+		if (cqe->res != expected)
+			error(1, cqe->res, "send failed");
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	ret = recv(sock_server, rx_buffer, send_size, 0);
+	if (ret != send_size) {
+		fprintf(stderr, "recv less than expected or recv failed %i\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < send_size; i++) {
+		if (buf[i] != rx_buffer[i]) {
+			fprintf(stderr, "botched data, first byte %i, %u vs %u\n",
+				i, buf[i], rx_buffer[i]);
+		}
+	}
+	return 0;
+}
+
+static int test_inet_send(struct io_uring *ring)
+{
+	struct sockaddr_storage addr;
+	int sock_client, sock_server;
+	int ret, j;
+	__u64 i;
+
+	for (j = 0; j < 8; j++) {
+		bool ipv6 = j & 1;
+		bool client_connect = j & 2;
+		bool msg_zc_set = j & 4;
+
+		ret = prepare_ip(&addr, &sock_client, &sock_server, ipv6,
+				 client_connect, msg_zc_set);
+		if (ret) {
+			fprintf(stderr, "sock prep failed %d\n", ret);
+			return 1;
+		}
+
+		for (i = 0; i < 64; i++) {
+			bool fixed_buf = i & 1;
+			struct sockaddr_storage *addr_arg = (i & 2) ? &addr : NULL;
+			size_t size = (i & 4) ? 137 : 4096;
+			bool cork = i & 8;
+			bool mix_register = i & 16;
+			bool aligned = i & 32;
+			int buf_idx = aligned ? 0 : 1;
+
+			if (mix_register && (!cork || fixed_buf))
+				continue;
+			if (!client_connect && addr_arg == NULL)
+				continue;
+
+			ret = do_test_inet_send(ring, sock_client, sock_server, fixed_buf,
+						addr_arg, size, cork, mix_register,
+						buf_idx);
+			if (ret) {
+				fprintf(stderr, "send failed fixed buf %i, conn %i, addr %i, "
+					"cork %i\n",
+					fixed_buf, client_connect, !!addr_arg,
+					cork);
+				return 1;
+			}
+		}
+
+		close(sock_client);
+		close(sock_server);
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int i, ret, sp[2];
+
+	if (argc > 1)
+		return 0;
+
+	ret = io_uring_queue_init(32, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = register_notifications(&ring);
+	if (ret == -EINVAL) {
+		printf("sendzc is not supported, skip\n");
+		return 0;
+	} else if (ret) {
+		fprintf(stderr, "register notif failed %i\n", ret);
+		return 1;
+	}
+
+	srand((unsigned)time(NULL));
+	for (i = 0; i < sizeof(tx_buffer); i++)
+		tx_buffer[i] = i;
+
+	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
+		perror("Failed to create Unix-domain socket pair\n");
+		return 1;
+	}
+
+	ret = test_registration(sp[0], sp[1]);
+	if (ret) {
+		fprintf(stderr, "test_registration() failed\n");
+		return ret;
+	}
+
+	ret = test_invalid_slot(&ring, sp[0], sp[1]);
+	if (ret) {
+		fprintf(stderr, "test_invalid_slot() failed\n");
+		return ret;
+	}
+
+	ret = test_basic_send(&ring, sp[0], sp[1]);
+	if (ret) {
+		fprintf(stderr, "test_basic_send() failed\n");
+		return ret;
+	}
+
+	ret = test_send_flush(&ring, sp[0], sp[1]);
+	if (ret) {
+		fprintf(stderr, "test_send_flush() failed\n");
+		return ret;
+	}
+
+	ret = test_multireq_notif(&ring, sp[0], sp[1]);
+	if (ret) {
+		fprintf(stderr, "test_multireq_notif() failed\n");
+		return ret;
+	}
+
+	ret = reregister_notifications(&ring);
+	if (ret) {
+		fprintf(stderr, "reregister notifiers failed %i\n", ret);
+		return ret;
+	}
+	/* retry a few tests after registering notifs */
+	ret = test_invalid_slot(&ring, sp[0], sp[1]);
+	if (ret) {
+		fprintf(stderr, "test_invalid_slot() failed\n");
+		return ret;
+	}
+
+	ret = test_multireq_notif(&ring, sp[0], sp[1]);
+	if (ret) {
+		fprintf(stderr, "test_multireq_notif2() failed\n");
+		return ret;
+	}
+
+	ret = test_multi_send_flushing(&ring, sp[0], sp[1]);
+	if (ret) {
+		fprintf(stderr, "test_multi_send_flushing() failed\n");
+		return ret;
+	}
+
+	ret = test_update_flush_fail(&ring);
+	if (ret) {
+		fprintf(stderr, "test_update_flush_fail() failed\n");
+		return ret;
+	}
+
+	ret = test_update_flush(&ring, sp[0], sp[1]);
+	if (ret) {
+		fprintf(stderr, "test_update_flush() failed\n");
+		return ret;
+	}
+
+	ret = t_register_buffers(&ring, buffers_iov, ARRAY_SIZE(buffers_iov));
+	if (ret == T_SETUP_SKIP) {
+		fprintf(stderr, "can't register bufs, skip\n");
+		goto out;
+	} else if (ret != T_SETUP_OK) {
+		error(1, ret, "io_uring: buffer registration");
+	}
+
+	ret = test_inet_send(&ring);
+	if (ret) {
+		fprintf(stderr, "test_inet_send() failed\n");
+		return ret;
+	}
+
+out:
+	io_uring_queue_exit(&ring);
+	close(sp[0]);
+	close(sp[1]);
+	return 0;
+}
-- 
2.37.0

