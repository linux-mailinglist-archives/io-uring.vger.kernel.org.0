Return-Path: <io-uring+bounces-2551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B91B93A9B9
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 01:17:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B08728377E
	for <lists+io-uring@lfdr.de>; Tue, 23 Jul 2024 23:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E7513D52B;
	Tue, 23 Jul 2024 23:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rHXgqlpM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NQ1LIu9E";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rHXgqlpM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NQ1LIu9E"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A15728E8
	for <io-uring@vger.kernel.org>; Tue, 23 Jul 2024 23:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721776666; cv=none; b=RQggDlJ4Ik+68wBLzAuDL9KFW3DSd0+Sv9iWqPFtDBgiAoN8wKf1Au3HQrRGlof+9n39FBwgY6pVInjAQbGbynoec7Aub2a7jKpilev+pQSvmmsEfrombksWw3NY+9vFTMPBF1m1UxAQOcNFxp4V5DzdTjQC5XVObOGg+4McaL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721776666; c=relaxed/simple;
	bh=ILZfS6plwPC0Xg1uBYrhpaSSN0M0tGqt5taJGmu+gdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PR2bbrF9CUP7vTxronON/blhQPgFEy4YH2qoLj/qtT87nO9XBu4xMfRozjh/8IjEb4p6qHIjcu2FmnWQKNO6S63a9M889UedtoqxCdJNBQ7A8p0DOwV0qZMd7me1A5KL0gMngmOxNDKlMPMt+URDTZk4xO3qEKkArnAoJxjgUZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rHXgqlpM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NQ1LIu9E; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rHXgqlpM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NQ1LIu9E; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C1C4D21AA9;
	Tue, 23 Jul 2024 23:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=42dBzkEY4jdARv4r2VXKGLDDJcOJR8Tw4CMl+5f9I7c=;
	b=rHXgqlpMnE1e/QpuxjhL0d4Xv7QMlHq8REnFZzN+xTifUwjNOJvp+dF8Gm+joiARd/Ufzx
	8xvvWJGVpbonVY4DmY+P4K7lQ1OvkxVeMrDukF1gMDdEPkm/JddqPOuQqGVB73XC5tZfW9
	vs+fCN7xFQwGN4EbfQmEKcacm6U9gu8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=42dBzkEY4jdARv4r2VXKGLDDJcOJR8Tw4CMl+5f9I7c=;
	b=NQ1LIu9E1FiolZcwkE3+QUvEx3SgMbJXi+LVDBo3lZOV2quSKVwKYF+YuqTZiDqJRL8K9w
	0q30YoxA5DtLCEAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721776662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=42dBzkEY4jdARv4r2VXKGLDDJcOJR8Tw4CMl+5f9I7c=;
	b=rHXgqlpMnE1e/QpuxjhL0d4Xv7QMlHq8REnFZzN+xTifUwjNOJvp+dF8Gm+joiARd/Ufzx
	8xvvWJGVpbonVY4DmY+P4K7lQ1OvkxVeMrDukF1gMDdEPkm/JddqPOuQqGVB73XC5tZfW9
	vs+fCN7xFQwGN4EbfQmEKcacm6U9gu8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721776662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=42dBzkEY4jdARv4r2VXKGLDDJcOJR8Tw4CMl+5f9I7c=;
	b=NQ1LIu9E1FiolZcwkE3+QUvEx3SgMbJXi+LVDBo3lZOV2quSKVwKYF+YuqTZiDqJRL8K9w
	0q30YoxA5DtLCEAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8844913874;
	Tue, 23 Jul 2024 23:17:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MMn5GhY6oGbOUgAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jul 2024 23:17:42 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing v2 3/5] tests: Add test for bind/listen commands
Date: Tue, 23 Jul 2024 19:17:31 -0400
Message-ID: <20240723231733.31884-4-krisman@suse.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723231733.31884-1-krisman@suse.de>
References: <20240723231733.31884-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: *
X-Spamd-Result: default: False [1.90 / 50.00];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,suse.de];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Score: 1.90

This test implements verification for bind/listen commands. First, it
creates a TCP connection with itself only using io_uring and verify it
works by sending data over it.  Then, some unit test verifies some
failed cases of malformed bind and listen operations.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/Makefile      |   1 +
 test/bind-listen.c | 381 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 382 insertions(+)
 create mode 100644 test/bind-listen.c

diff --git a/test/Makefile b/test/Makefile
index fcf6554..a47ca6f 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -52,6 +52,7 @@ test_srcs := \
 	across-fork.c \
 	b19062a56726.c \
 	b5837bd5311d.c \
+	bind-listen.c \
 	buf-ring.c \
 	buf-ring-nommap.c \
 	buf-ring-put.c \
diff --git a/test/bind-listen.c b/test/bind-listen.c
new file mode 100644
index 0000000..1fa3b54
--- /dev/null
+++ b/test/bind-listen.c
@@ -0,0 +1,381 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Configure and operate a TCP socket solely with io_uring.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <liburing.h>
+#include <err.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <sys/socket.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <netinet/ip.h>
+#include "liburing.h"
+#include "helpers.h"
+
+static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
+{
+        ts->tv_sec = msec / 1000;
+        ts->tv_nsec = (msec % 1000) * 1000000;
+}
+
+const char *magic = "Hello World!";
+
+enum {
+	SRV_INDEX = 0,
+	CLI_INDEX,
+	CONN_INDEX,
+};
+
+static int connect_client(struct io_uring *ring, unsigned short peer_port)
+{
+
+	struct __kernel_timespec ts;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int head, ret, submitted = 0;
+	struct sockaddr_in peer_addr;
+ 	socklen_t addr_len = sizeof(peer_addr);
+
+	peer_addr.sin_family = AF_INET;
+	peer_addr.sin_port = peer_port;
+	peer_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_socket_direct(sqe, AF_INET, SOCK_STREAM, 0,
+				    CLI_INDEX, 0);
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_connect(sqe, CLI_INDEX, (struct sockaddr*) &peer_addr, addr_len);
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_send(sqe, CLI_INDEX, magic, strlen(magic), 0);
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	submitted = ret = io_uring_submit(ring);
+	if (ret < 0)
+		return T_SETUP_SKIP;
+
+	msec_to_ts(&ts, 300);
+	ret = io_uring_wait_cqes(ring, &cqe, submitted, &ts, NULL);
+	if (ret < 0)
+		return T_SETUP_SKIP;
+
+	io_uring_for_each_cqe(ring, head, cqe) {
+		ret = cqe->res;
+		if (ret < 0)
+			return T_SETUP_SKIP;
+	} io_uring_cq_advance(ring, submitted);
+
+	return T_SETUP_OK;
+}
+
+static int setup_srv(struct io_uring *ring, struct sockaddr_in *server_addr)
+{
+	int val;
+	int submitted;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec ts;
+	int head;
+
+	int ret;
+
+	memset(server_addr, 0, sizeof(struct sockaddr_in));
+	server_addr->sin_family = AF_INET;
+	server_addr->sin_port = htons(8000);
+	server_addr->sin_addr.s_addr = htons(INADDR_ANY);
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_socket_direct(sqe, AF_INET, SOCK_STREAM, 0, SRV_INDEX, 0);
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(ring);
+	val = 1;
+	io_uring_prep_cmd_sock(sqe, SOCKET_URING_OP_SETSOCKOPT, 0, SOL_SOCKET,
+			       SO_REUSEADDR, &val, sizeof(val));
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_bind(sqe, SRV_INDEX, (struct sockaddr *) server_addr,
+			   sizeof(struct sockaddr_in));
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_listen(sqe, SRV_INDEX, 1);
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	submitted = ret = io_uring_submit(ring);
+	if (ret < 0) {
+		fprintf(stderr, "submission failed. %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	msec_to_ts(&ts, 300);
+	ret = io_uring_wait_cqes(ring, &cqe, ret, &ts, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "submission failed. %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_for_each_cqe(ring, head, cqe) {
+		ret = cqe->res;
+		if (ret < 0) {
+			fprintf(stderr, "Server startup failed. step %d got %d \n", head, ret);
+			return T_EXIT_FAIL;
+		}
+	} io_uring_cq_advance(ring, submitted);
+
+	return T_SETUP_OK;
+}
+
+static int test_good_server()
+{
+	struct sockaddr_in server_addr;
+	struct __kernel_timespec ts;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int ret;
+	int fds[3];
+	char buf[1024];
+
+	memset(fds, -1, sizeof(fds));
+
+	ret = t_create_ring(10, &ring, IORING_SETUP_SUBMIT_ALL);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return T_SETUP_SKIP;
+	}
+
+	ret = io_uring_register_files(&ring, fds, 3);
+	if (ret) {
+		fprintf(stderr, "server file register %d\n", ret);
+		return T_SETUP_SKIP;
+	}
+
+	ret = setup_srv(&ring, &server_addr);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "srv startup failed.\n");
+		return T_EXIT_FAIL;
+	}
+
+	if (connect_client(&ring, server_addr.sin_port) != T_SETUP_OK) {
+		fprintf(stderr, "cli startup failed.\n");
+		return T_SETUP_SKIP;
+	}
+
+	/* Wait for a request */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_accept_direct(sqe, SRV_INDEX, NULL, NULL, 0, CONN_INDEX);
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	io_uring_submit(&ring);
+	io_uring_wait_cqe(&ring, &cqe);
+	if (cqe->res < 0) {
+		fprintf(stderr, "accept failed. %d\n", cqe->res);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_recv(sqe, CONN_INDEX, buf, BUFSIZ, 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	io_uring_submit(&ring);
+	io_uring_wait_cqe_timeout(&ring, &cqe, &ts);
+
+	if (cqe->res < 0) {
+		fprintf(stderr, "bad receive cqe. %d\n", cqe->res);
+		return T_EXIT_FAIL;
+	}
+	ret = cqe->res;
+
+	io_uring_queue_exit(&ring);
+
+	if (ret != strlen(magic) || strncmp(buf, magic, ret)) {
+		fprintf(stderr, "didn't receive expected string. Got %d '%s'\n", ret, buf);
+		return T_EXIT_FAIL;
+	}
+	fprintf(stderr, "expected string. Got %d '%s'\n", ret, buf);
+	return T_EXIT_PASS;
+}
+
+int test_bad_bind()
+{
+	int sock;
+	struct sockaddr_in server_addr;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int err;
+	int ret = T_EXIT_FAIL;
+
+	memset(&server_addr, 0, sizeof(struct sockaddr_in));
+	server_addr.sin_family = AF_INET;
+	server_addr.sin_port = htons(8001);
+	server_addr.sin_addr.s_addr = htons(INADDR_ANY);
+
+	err = t_create_ring(1, &ring, 0);
+	if (err < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return T_SETUP_SKIP;
+	}
+
+	sock = socket(AF_INET, SOCK_STREAM, 0);
+
+	/* Bind with size 0 */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_bind(sqe, sock, (struct sockaddr *) &server_addr, 0);
+	err = io_uring_submit(&ring);
+	if (err < 0)
+		goto fail;
+
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (err)
+		goto fail;
+
+	if (cqe->res != -EINVAL)
+		goto fail;
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* Bind with bad fd */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_bind(sqe, 0, (struct sockaddr *) &server_addr,  sizeof(struct sockaddr_in));
+	err = io_uring_submit(&ring);
+	if (err < 0)
+		goto fail;
+
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (err)
+		goto fail;
+	if (cqe->res != -ENOTSOCK)
+		goto fail;
+	io_uring_cqe_seen(&ring, cqe);
+
+	ret = T_EXIT_PASS;
+
+	/* bind with weird value */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_bind(sqe, sock, (struct sockaddr *) &server_addr,  sizeof(struct sockaddr_in));
+	sqe->rw_flags = 1;
+	err = io_uring_submit(&ring);
+	if (err < 0)
+		goto fail;
+
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (err)
+		goto fail;
+	if (cqe->res != -EINVAL)
+		goto fail;
+	io_uring_cqe_seen(&ring, cqe);
+
+	ret = T_EXIT_PASS;
+
+fail:
+	io_uring_queue_exit(&ring);
+	if (sock)
+		close(sock);
+	return ret;
+}
+
+int test_bad_listen()
+{
+	int sock;
+	struct sockaddr_in server_addr;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int err;
+	int ret = T_EXIT_FAIL;
+
+	memset(&server_addr, 0, sizeof(struct sockaddr_in));
+	server_addr.sin_family = AF_INET;
+	server_addr.sin_port = htons(8001);
+	server_addr.sin_addr.s_addr = htons(INADDR_ANY);
+
+	err = t_create_ring(1, &ring, 0);
+	if (err < 0) {
+		fprintf(stderr, "queue_init: %d\n", err);
+		return T_SETUP_SKIP;
+	}
+
+	sock = socket(AF_INET, SOCK_STREAM, 0);
+	if (!sock) {
+		fprintf(stderr, "bad sock\n");
+		goto fail;
+	}
+	if (bind(sock, (struct sockaddr *) &server_addr,  sizeof(struct sockaddr_in))) {
+		fprintf(stderr, "bad bind\n");
+		goto fail;
+	}
+
+	/* listen on bad sock */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_listen(sqe, 0, 1);
+	err = io_uring_submit(&ring);
+	if (err < 0)
+		goto fail;
+
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (err)
+		goto fail;
+
+	if (cqe->res != -ENOTSOCK)
+		goto fail;
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* listen with weird parameters */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_listen(sqe, sock, 1);
+	sqe->addr2 = 0xffffff;
+	err = io_uring_submit(&ring);
+	if (err < 0)
+		goto fail;
+
+	err = io_uring_wait_cqe(&ring, &cqe);
+	if (err)
+		goto fail;
+
+	if (cqe->res != -EINVAL)
+		goto fail;
+	io_uring_cqe_seen(&ring, cqe);
+
+	ret = T_EXIT_PASS;
+fail:
+	io_uring_queue_exit(&ring);
+	if (sock)
+		close(sock);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring_probe *probe;
+	int failures = 0;
+	if (argc > 1)
+		return 0;
+
+	/*
+	 * This test is not supported in older kernels. Check for
+	 * OP_LISTEN, since that is the last feature required to support
+	 * it.
+	 */
+	probe = io_uring_get_probe();
+	if (!probe)
+		return 1;
+	if (!io_uring_opcode_supported(probe, IORING_OP_LISTEN))
+		return T_EXIT_SKIP;
+
+	failures += test_good_server();
+	failures += test_bad_bind();
+	failures += test_bad_listen();
+
+	if (!failures)
+		return T_EXIT_PASS;
+	return T_EXIT_FAIL;
+}
-- 
2.45.2


