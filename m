Return-Path: <io-uring+bounces-13632-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Jo3eLULtJWoyNwIAu9opvQ
	(envelope-from <io-uring+bounces-13632-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 00:14:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 208D9651CAF
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 00:14:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S8J9waPf;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13632-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13632-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1BA7A30234EA
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 22:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB55033BBC6;
	Sun,  7 Jun 2026 22:12:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911FF31194C
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 22:12:35 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780870357; cv=none; b=h5qp4QyD2ZETSldCq9XVDN9x+Dz/1EZj2TLQ7cQapZ9SECLmhUzJR1Ec+zVPRtt0HMYz+GSbmbtKXJ3PpSPFEGap77uQ4lRHKAXK+tcuOheFhlykcSlTlMa+eycuqSoZhInaRQF7WIOUC9ZLt1EadGvzd8xEp6NBSZJWY36pUOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780870357; c=relaxed/simple;
	bh=5Gv6HcYygMyhQXidp/OGzdRjg6V3YrRWUke26jM9Qo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UXA1tu3gJ30F+//66I7KJyBxnu9iDdS2qIT3v52z4zAL3MJ6y3Eho1MTwiU/1RkQuDdnQvLykMQgYQSbozRgFmNgtiadnUu++BN9HUelKXOCUdExhnhW030UH6RQWl2UZQNk3N+nMKW7cEPAQE1ORVBv768TrrC39Q39Yz6KtWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S8J9waPf; arc=none smtp.client-ip=209.85.128.41
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b211ee6aso27824965e9.3
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 15:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780870354; x=1781475154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8p4WQWA5RgafOeFKzM54X4fmRTN6X6fnEzGbViwwnSU=;
        b=S8J9waPf8qbd6fg67qwDXWwHhU+kYPalU+8XPaOzZv1n+pDlZklBa9Sy/TInlAwrZz
         LWc4oUrAKY814hr4r8lN2FIUJaAVaWIaNaq5E5zSb/dBovY4ec8k/Fn9GIzlUEem9unw
         mDOBfXCRwLS061ZgCbsUIY8ZSun7TKXenB+TX1dhKIXZJkW6l+pWl8wqmmWXi1x2pgT5
         pvLBhJ+D5pCymwArbSwlQKoXGNW6Z58ukxexbTVVGGJ1fT3v2a6C58utD3wR41MqeNi/
         fvYVDqvI0DrGdzz0QezrpGUVjSWjxbFJRiSUX1bICKbaDVIsAt2Obh06AJxUHa9VUiXz
         Z7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780870354; x=1781475154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8p4WQWA5RgafOeFKzM54X4fmRTN6X6fnEzGbViwwnSU=;
        b=LDOTOnWJQWZZD5JwhVYVtD708EwqqV2/UXiLMsRiCKGBFkbO2Lt35LoU26akjzZ1lI
         OrOjIiRFWo+BbIsGIv8+7l/nTuxQLFGJ7J3Y36wCyxVe87yz0ZQxSPkbTFSoDH6Cj43o
         vpuXynaMyQyrJP384Be4JC1niyR7q9tl16yyb2wkTzslC537pBqdCjDHBTR1JKU1aTCG
         GZg2JYh9gqP1WjfaPwFpRJ4xozi20IAhsgVUF4BKbLtQZsTHeGKr2GCDGKKE5LJKxh7g
         PsmLz4ncO+YDwtrnkvM+FdEVtL9srFBcljUqsS0ZmzBMXje5ZyB2VTPfTTLyyryF79lE
         4JdA==
X-Forwarded-Encrypted: i=1; AFNElJ+Ke1JdDSkm3LeNSnJTPvbgg07S+RUQF80+GkZ+HBIH37+s99LakqSFC1pE/aqSsyE8Ds12bwQ24g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8hSaULJl6SeXAJz+vjPbIsmHYbri/fUzsDXJf9KhGPQsyhRAO
	AHxXhI/Qvz3WClEMq3/XAs6m6/P1kyzpZBn/oHgkwSNbegUkjfhLFWiw
X-Gm-Gg: Acq92OFuLE39JJkL/1m3+LJ3TTRIL374PlNBVLsTVsJQoEswb8tg32KXlJHcNxeh4cC
	gpu/ChqZxv5pNs6Qydr1OkdCrSHDmZht7/CBoc1EG2Q7NsuNoH8scyJFSNyXrw9jaLGNF2NrWvX
	y3y1go3g9RbH3d2Pc7cGTxWiAOAc1ImPkt2e0k7v0Y9le0P92CbUyIyWeVkED5DhtyC1Nx3E79f
	FYBgDUJ2piF9sg/UdLLRD6OLFo1fYv5F/WltpQ7nqvrF+A1dizwFcPec7IXPcScfhI2kwEzqH1l
	Tzt5a4ZrGarQDnVogk3yeQpCQk0kQbIMZHOm5nD5IDumxTeHrXpo56CCcS20nHzUtX5Z3EyC881
	OwveauoT8S8yBd1dIiUi376q9t04uy028RI92zXxIfuEB66NkWlNS/5SfkB4ztDcww+fS6QA0Vk
	UoU+rcs78YM+bam5mATzCgtSQ5RyQg7Uo1ST0FI6nfS+FV9zxhuQY=
X-Received: by 2002:adf:e006:0:20b0:441:1e8e:d8fd with SMTP id ffacd0b85a97d-46030658bc5mr14810105f8f.29.1780870353903;
        Sun, 07 Jun 2026 15:12:33 -0700 (PDT)
Received: from localhost ([217.199.144.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ec711sm45291686f8f.12.2026.06.07.15.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 15:12:33 -0700 (PDT)
From: Nyakundi Emmanuel <nyariboemmanuel8@gmail.com>
To: axboe@kernel.dk
Cc: federico.brasili@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nyakundi Emmanuel <nyariboemmanuel8@gmail.com>
Subject: [PATCH] test/recv-bundle-pbuf-len-poison: add regression test for pbuf len corruption
Date: Mon,  8 Jun 2026 01:10:47 +0300
Message-ID: <20260607221114.135950-1-nyariboemmanuel8@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <1fd2ea63-c128-4641-9565-dbafd97de612@kernel.dk>
References: <1fd2ea63-c128-4641-9565-dbafd97de612@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13632-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[nyariboemmanuel8@gmail.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:federico.brasili@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:nyariboemmanuel8@gmail.com,m:federicobrasili@gmail.com,s:lists@lfdr.de];
	TO_DN_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nyariboemmanuel8@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 208D9651CAF

A failed IORING_RECVSEND_BUNDLE receive on a non-INC provided-buffer
ring can persistently corrupt the buffer descriptor length. When the
receive fails with -EAGAIN, the kernel writes the requested length into
buf->len during buffer selection but never restores it on failure.

A later unrelated IORING_OP_READ using the same buffer group then
consumes the corrupted length, returning fewer bytes than expected.

This test reproduces the issue as reported by Federico Brasili.

Reported-by: Federico Brasili <federico.brasili@gmail.com>
Link: https://lore.kernel.org/io-uring/CAAEr8jbY60noGj1fw_k91UJRBkyiRVoS6=nLhZ7Svwidjn4CAA@mail.gmail.com/
Signed-off-by: Nyakundi Emmanuel <nyariboemmanuel8@gmail.com>
---
 test/recv-bundle-pbuf-len-poison.c | 146 +++++++++++++++++++++++++++++
 1 file changed, 146 insertions(+)
 create mode 100644 test/recv-bundle-pbuf-len-poison.c

diff --git a/test/recv-bundle-pbuf-len-poison.c b/test/recv-bundle-pbuf-len-poison.c
new file mode 100644
index 00000000..90fafff4
--- /dev/null
+++ b/test/recv-bundle-pbuf-len-poison.c
@@ -0,0 +1,146 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Regression test for io_uring provided-buffer ring length corruption.
+ *
+ * A failed IORING_RECVSEND_BUNDLE receive on a non-INC provided-buffer
+ * ring can persistently shrink the user-visible buffer descriptor length.
+ * The modified length is not rolled back when the receive fails with
+ * -EAGAIN, and a later unrelated IORING_OP_READ from a pipe consumes
+ * the corrupted length.
+ *
+ * Reported-by: Federico Brasili <federico.brasili@gmail.com>
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/socket.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+#define BGID		8
+#define BUF_SIZE	4096
+#define NR_BUFS		2
+
+static int test(void)
+{
+	struct io_uring_buf_ring *br;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	struct io_uring_buf *buf_entry;
+	int sockfd, pipefds[2], ret;
+	void *buf;
+	char pipe_data[BUF_SIZE];
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (posix_memalign(&buf, 4096, BUF_SIZE * NR_BUFS))
+		return T_EXIT_FAIL;
+
+	/* set up non-INC provided buffer ring with 2 buffers of BUF_SIZE */
+	br = io_uring_setup_buf_ring(&ring, NR_BUFS, BGID, 0, &ret);
+	if (!br) {
+		if (ret == -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "buf ring setup failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_buf_ring_add(br, buf,             BUF_SIZE, 0, NR_BUFS - 1, 0);
+	io_uring_buf_ring_add(br, buf + BUF_SIZE,  BUF_SIZE, 1, NR_BUFS - 1, 1);
+	io_uring_buf_ring_advance(br, NR_BUFS);
+
+	/* create an empty SOCK_DGRAM socket to trigger -EAGAIN */
+	sockfd = socket(AF_UNIX, SOCK_DGRAM, 0);
+	if (sockfd < 0) {
+		perror("socket");
+		return T_EXIT_FAIL;
+	}
+
+	/* submit RECV_BUNDLE on empty socket — expects -EAGAIN */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_recv(sqe, sockfd, NULL, 1, MSG_DONTWAIT);
+	sqe->ioprio |= IORING_RECVSEND_BUNDLE;
+	sqe->flags  |= IOSQE_BUFFER_SELECT;
+	sqe->buf_group = BGID;
+	sqe->user_data  = 0x1111;
+	io_uring_submit(&ring);
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait cqe failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	if (cqe->res != -EAGAIN) {
+		fprintf(stderr, "expected -EAGAIN, got %d\n", cqe->res);
+		io_uring_cqe_seen(&ring, cqe);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* check entry0.len — must still be BUF_SIZE after failed RECV */
+	buf_entry = &br->bufs[0];
+	if (buf_entry->len != BUF_SIZE) {
+		fprintf(stderr,
+			"FAIL: entry0.len corrupted after -EAGAIN RECV_BUNDLE: "
+			"got %u, expected %u\n",
+			buf_entry->len, BUF_SIZE);
+		return T_EXIT_FAIL;
+	}
+
+	/* now do a pipe READ using the same buffer group */
+	if (pipe(pipefds)) {
+		perror("pipe");
+		return T_EXIT_FAIL;
+	}
+
+	memset(pipe_data, 'A', BUF_SIZE);
+	if (write(pipefds[1], pipe_data, BUF_SIZE) != BUF_SIZE) {
+		fprintf(stderr, "pipe write failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read(sqe, pipefds[0], NULL, BUF_SIZE, 0);
+	sqe->flags    |= IOSQE_BUFFER_SELECT;
+	sqe->buf_group = BGID;
+	sqe->user_data  = 0x6666;
+	io_uring_submit(&ring);
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait read cqe failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+	if (cqe->res != BUF_SIZE) {
+		fprintf(stderr,
+			"FAIL: READ got %d bytes, expected %d — "
+			"pbuf len was poisoned by failed RECV_BUNDLE\n",
+			cqe->res, BUF_SIZE);
+		io_uring_cqe_seen(&ring, cqe);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	close(sockfd);
+	close(pipefds[0]);
+	close(pipefds[1]);
+	io_uring_queue_exit(&ring);
+	free(buf);
+	return T_EXIT_PASS;
+}
+
+int main(int argc, char *argv[])
+{
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	return test();
+}
-- 
2.54.0


