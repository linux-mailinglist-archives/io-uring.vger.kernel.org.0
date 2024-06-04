Return-Path: <io-uring+bounces-2086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15A498FA6C4
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 02:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 806A31F21B11
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 00:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F05B182;
	Tue,  4 Jun 2024 00:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kEDZL/KR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yulPd71v";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kEDZL/KR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yulPd71v"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2EE195
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 00:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717459479; cv=none; b=LpUwqUJFMwZaXmDC9wxRqYG63qLu7NfXxX1bg25KaEZIatnjooGsYCnyV1BWUemwcBUmbBNK0tWzDEbaqNd358xDLBkWULy1QvODoOp8iqWEoxPIJyEyB9Ey+FAThm/rFpx5VK5zI9jUqCL3ILghud22zwyOY5K/NZ8Vjn0Yx10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717459479; c=relaxed/simple;
	bh=PoX07soQGXDXO6MxG3v1PFNxrv43rROGs1fCndgsCE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDSiEcrlvGdYh+nGw+6uLqWX0EGudNHtf9VFW+JLK0zO0GRf6kWpWFzJ/RglkZaOwqk509+S2GGVAQk5cR6Q2pnp7FgLdsEjlxpGm9xtGT/+9xUCiP7t+ThCfzU+hlNwcoruWpiABgPrvQaUy87QJUXMzHBhOC+GalO7JlHyciM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kEDZL/KR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yulPd71v; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kEDZL/KR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yulPd71v; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 079271F792;
	Tue,  4 Jun 2024 00:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CWI7NLZI8ai/8lIVt5walJmn0cO+OyeBp6boC2jG0ik=;
	b=kEDZL/KR/uPZvQRiNVzafOFaQGpnInP+BWhTMg0VcxDGqr/tL6IUEq+XJC15TEP5SZDFo/
	bdcG9JK4fhjIsjM7QPnOzEPGJdtUmHjMLQp/+ukbqDYOx7hk1bae7S6FYndAWTAcwiIjLx
	pnGqsIPlkF4El4z7sw0/hcEz1c/REwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CWI7NLZI8ai/8lIVt5walJmn0cO+OyeBp6boC2jG0ik=;
	b=yulPd71vr/uRLM/SLJm7pRvrUpfgh99NHBVbM2dOmqwCgb9QeixEAco/vmKPJJlrjHEkwj
	XHx5132OYvaPHiDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kEDZL/KR";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yulPd71v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717459475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CWI7NLZI8ai/8lIVt5walJmn0cO+OyeBp6boC2jG0ik=;
	b=kEDZL/KR/uPZvQRiNVzafOFaQGpnInP+BWhTMg0VcxDGqr/tL6IUEq+XJC15TEP5SZDFo/
	bdcG9JK4fhjIsjM7QPnOzEPGJdtUmHjMLQp/+ukbqDYOx7hk1bae7S6FYndAWTAcwiIjLx
	pnGqsIPlkF4El4z7sw0/hcEz1c/REwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717459475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CWI7NLZI8ai/8lIVt5walJmn0cO+OyeBp6boC2jG0ik=;
	b=yulPd71vr/uRLM/SLJm7pRvrUpfgh99NHBVbM2dOmqwCgb9QeixEAco/vmKPJJlrjHEkwj
	XHx5132OYvaPHiDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C1D9F13A92;
	Tue,  4 Jun 2024 00:04:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gHs1KRJaXmaFCwAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 04 Jun 2024 00:04:34 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 3/5] tests: Add test for bind/listen commands
Date: Mon,  3 Jun 2024 20:04:15 -0400
Message-ID: <20240604000417.16137-4-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240604000417.16137-1-krisman@suse.de>
References: <20240604000417.16137-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -5.01
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 079271F792
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

This is implemented as a server/client tool that only uses io_uring
commands for setup.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/Makefile      |   1 +
 test/bind-listen.c | 231 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 232 insertions(+)
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
index 0000000..cd1e386
--- /dev/null
+++ b/test/bind-listen.c
@@ -0,0 +1,231 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * echo server using solely io_uring operations
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
+#include <pthread.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
+{
+        ts->tv_sec = msec / 1000;
+        ts->tv_nsec = (msec % 1000) * 1000000;
+}
+
+struct srv_data {
+	pthread_mutex_t mutex;
+};
+struct sockaddr_in server_addr;
+
+const char *magic = "Hello World!";
+
+static void *do_server(void *data)
+{
+	struct srv_data *rd = data;
+
+	struct io_uring_params p = { };
+	struct __kernel_timespec ts;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int ret, conn, sock_index;
+	unsigned head;
+	int fd, val;
+	char buf[1024];
+
+	ret = t_create_ring_params(4, &ring, &p);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		goto err;
+	}
+
+	ret = io_uring_register_files(&ring, &fd, 1);
+	if (ret) {
+		fprintf(stderr, "file register %d\n", ret);
+		goto err;
+	}
+
+	memset(&server_addr, 0, sizeof(struct sockaddr_in));
+	server_addr.sin_family = AF_INET;
+	server_addr.sin_port = htons(8000);
+	server_addr.sin_addr.s_addr = htons(INADDR_ANY);
+
+	sock_index = 0;
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_socket_direct(sqe, AF_INET, SOCK_STREAM, 0,
+				    sock_index, 0);
+
+	sqe = io_uring_get_sqe(&ring);
+	val = 1;
+	io_uring_prep_cmd_sock(sqe, SOCKET_URING_OP_SETSOCKOPT, 0,
+			       SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_bind(sqe, sock_index, (struct sockaddr *) &server_addr,
+			   sizeof(struct sockaddr_in));
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_listen(sqe, sock_index, 1);
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	ret = io_uring_submit(&ring);
+	if (ret < 0) {
+		printf("submission failed. %d\n", ret);
+		goto err;
+	}
+
+	msec_to_ts(&ts, 300);
+	ret = io_uring_wait_cqes(&ring, &cqe, 4, &ts, NULL);
+	if (ret < 0) {
+		printf("submission failed. %d\n", ret);
+		goto err;
+	}
+
+	io_uring_for_each_cqe(&ring, head, cqe) {
+		if (cqe->res < 0) {
+			printf("Server startup failed. step %d got %d \n", head, cqe->res);
+			goto err;
+		}
+	}
+	io_uring_cq_advance(&ring, 4);
+
+	pthread_mutex_unlock(&rd->mutex);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_accept(sqe, sock_index, NULL, NULL, 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	io_uring_submit(&ring);
+	io_uring_wait_cqe(&ring, &cqe);
+
+
+	if (cqe->res < 0) {
+		printf("accept failed. %d\n", cqe->res);
+		goto err;
+	}
+	conn = cqe->res;
+	io_uring_cqe_seen(&ring, cqe);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_recv(sqe, conn, buf, BUFSIZ, 0);
+	io_uring_submit(&ring);
+	io_uring_wait_cqe_timeout(&ring, &cqe, &ts);
+
+	if (cqe->res < 0) {
+		printf("bad receive cqe. %d\n", cqe->res);
+		goto err;
+	}
+	val = cqe->res;
+
+	if (val != strlen(magic) || strncmp(buf, magic, val)) {
+		printf("didn't receive expected string\n");
+		ret = -1;
+		goto err;
+	}
+
+	io_uring_queue_exit(&ring);
+
+	ret = 0;
+err:
+	return (void *)(intptr_t)ret;
+}
+
+static int do_client()
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct sockaddr_in peer_addr;
+	socklen_t addr_len = sizeof(peer_addr);
+	struct io_uring ring;
+	int ret, fd = -1, sock_index;
+	int i;
+
+	ret = io_uring_queue_init(3, &ring, 0);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return -1;
+	}
+
+	ret = io_uring_register_files(&ring, &fd, 1);
+	if (ret) {
+		fprintf(stderr, "file register %d\n", ret);
+		goto err;
+	}
+
+
+	peer_addr.sin_family = AF_INET;
+	peer_addr.sin_port = server_addr.sin_port;
+	peer_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+
+	sock_index = 0;
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_socket_direct(sqe, AF_INET, SOCK_STREAM, 0,
+				    sock_index, 0);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_connect(sqe, sock_index, (struct sockaddr*) &peer_addr, addr_len);
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+
+	io_uring_prep_send(sqe, sock_index, magic, strlen(magic), 0);
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_IO_LINK;
+
+	io_uring_submit(&ring);
+	io_uring_wait_cqe_nr(&ring, &cqe, 3);
+
+	io_uring_for_each_cqe(&ring, i, cqe) {
+		if (cqe->res < 0) {
+			printf("client cqe. idx=%d, %d\n", i, cqe->res);
+		}
+	}
+	io_uring_cq_advance(&ring, 2);
+
+	return 0;
+err:
+	return -1;
+}
+
+int main(int argc, char *argv[])
+{
+	pthread_mutexattr_t attr;
+	pthread_t srv_thread;
+	struct srv_data srv_data;
+	int ret;
+	void *retval;
+
+	if (argc > 1)
+		return 0;
+
+	pthread_mutexattr_init(&attr);
+	pthread_mutexattr_setpshared(&attr, 1);
+	pthread_mutex_init(&srv_data.mutex, &attr);
+	pthread_mutex_lock(&srv_data.mutex);
+
+	ret = pthread_create(&srv_thread, NULL, do_server, &srv_data);
+	if (ret) {
+		fprintf(stderr, "Thread create failed: %d\n", ret);
+		pthread_mutex_unlock(&srv_data.mutex);
+		return 1;
+	}
+	pthread_mutex_lock(&srv_data.mutex);
+	do_client();
+
+	pthread_join(srv_thread, &retval);
+	return (intptr_t)retval;
+}
+
+
-- 
2.44.0


