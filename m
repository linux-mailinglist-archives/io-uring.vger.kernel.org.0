Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C397D109F
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 15:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377364AbjJTNjg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 09:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377074AbjJTNjg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 09:39:36 -0400
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F911A4
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:33 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-9be02fcf268so126647266b.3
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 06:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697809171; x=1698413971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5aquoTQ7zTsA88/VEGHqLqBNmNNuVaBEFNaSIKTEsgw=;
        b=SdbZmcFAYdWuueT4uewqghwceYfHLy2xPbUoOSeban88qxulQF+jDBl6XUllSwNBLP
         WLQ97GBcDg4nLMJh6RbLFVLkUEVHhm7Hsihs1tvz7PnLnThrwzUqWY29L1IwFTciYT2m
         HkTFLLI6dQ3G4Ba0EoRFp+Vs7AbhMVhn20HUHubpBd8uorvlI7c2z//giTOZL8pnNu5P
         OWJeTHqkVwkmrctHNEUqyWeJieAnn+anB0iWvV0Z6b390SvWcQT51gKdMrYASHfdNiD7
         2RwTgfJe/Oj5IB1kEpi54XLFO1oo5FL4P/R6UNhYRBTAMdUIMZyXyOO++EZyBk05s5R+
         19mw==
X-Gm-Message-State: AOJu0YzpMQCksi/CCHMhOGvoLhrg8sEWbaa1Em7tpvgVlKc1sOvc5adW
        uaa4BO1Rl3DAMZ5EODLSTkE=
X-Google-Smtp-Source: AGHT+IHD6Ij6BJ46lDs/HCJHYXWpU8riKZAzhLt5FRf/o0oK4MXASVL+fqfGjU7IUHl0Ac4NrXUjHA==
X-Received: by 2002:a17:907:94c3:b0:9c3:bd63:4245 with SMTP id dn3-20020a17090794c300b009c3bd634245mr1288464ejc.47.1697809171201;
        Fri, 20 Oct 2023 06:39:31 -0700 (PDT)
Received: from localhost (fwdproxy-cln-016.fbsv.net. [2a03:2880:31ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id p20-20020a170906a01400b009b655c43710sm1531946ejy.24.2023.10.20.06.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 06:39:30 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH 3/5] tests/socket-getsetsock-cmd: New test for {g,s}etsockopt
Date:   Fri, 20 Oct 2023 06:39:15 -0700
Message-Id: <20231020133917.953642-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020133917.953642-1-leitao@debian.org>
References: <20231020133917.953642-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce a new test to exercise the io_uring getsockopt and setsockopt
commands.

On the liburing side, use the io_uring_prep_cmd_sock() function to
prepare the SQE.

The test executes the same operation using a regular systemcall, such as
getsockopt(2), and the io_uring getsockopt command and compare the
results. The same for the setsockopt counterpart.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 test/Makefile                |   1 +
 test/socket-getsetsock-cmd.c | 328 +++++++++++++++++++++++++++++++++++
 2 files changed, 329 insertions(+)
 create mode 100644 test/socket-getsetsock-cmd.c

diff --git a/test/Makefile b/test/Makefile
index c15b2a3..6b25e58 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -167,6 +167,7 @@ test_srcs := \
 	skip-cqe.c \
 	socket.c \
 	socket-io-cmd.c \
+	socket-getsetsock-cmd.c \
 	socket-rw.c \
 	socket-rw-eagain.c \
 	socket-rw-offset.c \
diff --git a/test/socket-getsetsock-cmd.c b/test/socket-getsetsock-cmd.c
new file mode 100644
index 0000000..5b6aa48
--- /dev/null
+++ b/test/socket-getsetsock-cmd.c
@@ -0,0 +1,328 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: Check that {g,s}etsockopt CMD operations on sockets are
+ * consistent.
+ *
+ * The tests basically do the same socket operation using regular system calls
+ * and io_uring commands, and then compare the results.
+ */
+
+#include <stdio.h>
+#include <assert.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/tcp.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+#define USERDATA 0xff42ff
+#define MSG "foobarbaz"
+
+struct fds {
+	int tx;
+	int rx;
+};
+
+static struct fds create_sockets(void)
+{
+	struct fds retval;
+	int fd[2];
+
+	t_create_socket_pair(fd, true);
+
+	retval.tx = fd[0];
+	retval.rx = fd[1];
+
+	return retval;
+}
+
+static struct io_uring create_ring(void)
+{
+	struct io_uring ring;
+	int ring_flags = 0;
+	int err;
+
+	err = io_uring_queue_init(32, &ring, ring_flags);
+	assert(err == 0);
+
+	return ring;
+}
+
+static int submit_cmd_sqe(struct io_uring *ring, int32_t fd,
+			  int op, int level, int optname,
+			  void *optval, int optlen)
+{
+	struct io_uring_sqe *sqe;
+	int err;
+
+	assert(fd > 0);
+
+	sqe = io_uring_get_sqe(ring);
+	assert(sqe != NULL);
+
+	io_uring_prep_cmd_sock(sqe, op, fd, level, optname, optval, optlen);
+	sqe->user_data = USERDATA;
+
+	/* Submitting SQE */
+	err = io_uring_submit_and_wait(ring, 1);
+	if (err != 1)
+		fprintf(stderr, "Failure: io_uring_submit_and_wait returned %d\n", err);
+
+	return err;
+}
+
+static int receive_cqe(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	int err;
+
+	err = io_uring_wait_cqe(ring, &cqe);
+	assert(err ==  0);
+	assert(cqe->user_data == USERDATA);
+	io_uring_cqe_seen(ring, cqe);
+
+	/* Return the result of the operation */
+	return cqe->res;
+}
+
+/*
+ * Run getsock operation using SO_RCVBUF using io_uring cmd operation and
+ * getsockopt(2) and compare the results.
+ */
+static int run_get_rcvbuf(struct io_uring *ring, struct fds *sockfds)
+{
+	int sval, uval, ulen, err;
+	unsigned int slen;
+
+	/* System call values */
+	slen = sizeof(sval);
+	/* io_uring values */
+	ulen = sizeof(uval);
+
+	/* get through io_uring cmd */
+	err = submit_cmd_sqe(ring, sockfds->rx, SOCKET_URING_OP_GETSOCKOPT,
+			     SOL_SOCKET, SO_RCVBUF, &uval, ulen);
+	assert(err == 1);
+
+	/* Wait for the CQE */
+	err = receive_cqe(ring);
+	if (err == -EOPNOTSUPP)
+		return T_EXIT_SKIP;
+	if (err < 0) {
+		fprintf(stderr, "Error received. %d\n", err);
+		return T_EXIT_FAIL;
+	}
+	/* The output of CQE->res contains the length */
+	ulen = err;
+
+	/* Executes the same operation using system call */
+	err = getsockopt(sockfds->rx, SOL_SOCKET, SO_RCVBUF, &sval, &slen);
+	assert(err == 0);
+
+	/* Make sure that io_uring operation returns the same value as the systemcall */
+	assert(ulen == slen);
+	assert(uval == sval);
+
+	return T_EXIT_PASS;
+}
+
+/*
+ * Run getsock operation using SO_PEERNAME using io_uring cmd operation
+ * and getsockopt(2) and compare the results.
+ */
+static int run_get_peername(struct io_uring *ring, struct fds *sockfds)
+{
+	struct sockaddr sval, uval = {};
+	socklen_t slen = sizeof(sval);
+	socklen_t ulen = sizeof(uval);
+	int err;
+
+	/* Get values from the systemcall */
+	err = getsockopt(sockfds->tx, SOL_SOCKET, SO_PEERNAME, &sval, &slen);
+	assert(err == 0);
+
+	/* Getting SO_PEERNAME */
+	err = submit_cmd_sqe(ring, sockfds->rx, SOCKET_URING_OP_GETSOCKOPT,
+			     SOL_SOCKET, SO_PEERNAME, &uval, ulen);
+	assert(err == 1);
+
+	/* Wait for the CQE */
+	err = receive_cqe(ring);
+	if (err == -EOPNOTSUPP)
+		return T_EXIT_SKIP;
+
+	if (err < 0) {
+		fprintf(stderr, "%s: Error in the CQE: %d\n", __func__, err);
+		return T_EXIT_FAIL;
+	}
+
+	/* The length comes from cqe->res, which is returned from receive_cqe() */
+	ulen = err;
+
+	/* Make sure that io_uring operation returns the same values as the systemcall */
+	assert(sval.sa_family == uval.sa_family);
+	assert(slen == ulen);
+
+	return T_EXIT_PASS;
+}
+
+/*
+ * Run getsockopt tests. Basically comparing io_uring output and systemcall results
+ */
+static int run_getsockopt_test(struct io_uring *ring, struct fds *sockfds)
+{
+	int err;
+
+	fprintf(stderr, "Testing getsockopt SO_PEERNAME\n");
+	err = run_get_peername(ring, sockfds);
+	if (err)
+		return err;
+
+	fprintf(stderr, "Testing getsockopt SO_RCVBUF\n");
+	err = run_get_rcvbuf(ring, sockfds);
+
+	return err;
+}
+
+/*
+ * Given a `val` value, set it in SO_REUSEPORT using io_uring cmd, and read using
+ * getsockopt(2), and make sure they match.
+ */
+static int run_setsockopt_reuseport(struct io_uring *ring, struct fds *sockfds, int val)
+{
+	unsigned int slen, ulen;
+	int sval, uval = val;
+	int err;
+
+	slen = sizeof(sval);
+	ulen = sizeof(uval);
+
+	/* Setting SO_REUSEPORT */
+	err = submit_cmd_sqe(ring, sockfds->rx, SOCKET_URING_OP_SETSOCKOPT,
+			     SOL_SOCKET, SO_REUSEPORT, &uval, ulen);
+	assert(err == 1);
+
+	err = receive_cqe(ring);
+	if (err == -EOPNOTSUPP)
+		return T_EXIT_SKIP;
+
+	/* Get values from the systemcall */
+	err = getsockopt(sockfds->rx, SOL_SOCKET, SO_REUSEPORT, &sval, &slen);
+	assert(err == 0);
+
+	/* Make sure the set using io_uring cmd matches what systemcall returns */
+	assert(uval == sval);
+	assert(ulen == slen);
+
+	return T_EXIT_PASS;
+}
+
+/*
+ * Given a `val` value, set the TCP_USER_TIMEOUT using io_uring and read using
+ * getsockopt(2). Make sure they match
+ */
+static int run_setsockopt_usertimeout(struct io_uring *ring, struct fds *sockfds, int val)
+{
+	int optname = TCP_USER_TIMEOUT;
+	int level = IPPROTO_TCP;
+	unsigned int slen, ulen;
+	int sval, uval, err;
+
+	slen = sizeof(uval);
+	ulen = sizeof(uval);
+
+	uval = val;
+
+	/* Setting timeout */
+	err = submit_cmd_sqe(ring, sockfds->rx, SOCKET_URING_OP_SETSOCKOPT,
+			     level, optname, &uval, ulen);
+	assert(err == 1);
+
+	err = receive_cqe(ring);
+	if (err == -EOPNOTSUPP)
+		return T_EXIT_SKIP;
+	if (err < 0) {
+		fprintf(stderr, "%s: Got an error: %d\n", __func__, err);
+		return T_EXIT_FAIL;
+	}
+
+	/* Get the value from the systemcall, to make sure it was set */
+	err = getsockopt(sockfds->rx, level, optname, &sval, &slen);
+	assert(err == 0);
+	assert(uval == sval);
+
+	return T_EXIT_PASS;
+}
+
+/* Test setsockopt() for SOL_SOCKET */
+static int run_setsockopt_test(struct io_uring *ring, struct fds *sockfds)
+{
+	int err, i;
+
+	fprintf(stderr, "Testing setsockopt SOL_SOCKET/SO_REUSEPORT\n");
+	for (i = 0; i <= 1; i++) {
+		err = run_setsockopt_reuseport(ring, sockfds, i);
+		if (err)
+			return err;
+	}
+
+	fprintf(stderr, "Testing setsockopt IPPROTO_TCP/TCP_FASTOPEN\n");
+	for (i = 1; i <= 10; i++) {
+		err = run_setsockopt_usertimeout(ring, sockfds, i);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+/* Send data throughts the sockets */
+void send_data(struct fds *s)
+{
+	int written_bytes;
+	/* Send data sing the sockstruct->send */
+	written_bytes = write(s->tx, MSG, strlen(MSG));
+	assert(written_bytes == strlen(MSG));
+}
+
+int main(int argc, char *argv[])
+{
+	struct fds sockfds;
+	struct io_uring ring;
+	int err;
+
+	if (argc > 1)
+		return 0;
+
+	/* Simply io_uring ring creation */
+	ring = create_ring();
+
+	/* Create sockets */
+	sockfds = create_sockets();
+
+	send_data(&sockfds);
+
+	err = run_getsockopt_test(&ring, &sockfds);
+	if (err) {
+		if (err == T_EXIT_SKIP) {
+			fprintf(stderr, "Skipping tests.\n");
+			return T_EXIT_SKIP;
+		}
+		fprintf(stderr, "Failed to run test: %d\n", err);
+		return err;
+	}
+
+	err = run_setsockopt_test(&ring, &sockfds);
+	if (err) {
+		if (err == T_EXIT_SKIP) {
+			fprintf(stderr, "Skipping tests.\n");
+			return T_EXIT_SKIP;
+		}
+		fprintf(stderr, "Failed to run test: %d\n", err);
+		return err;
+	}
+
+	io_uring_queue_exit(&ring);
+	return err;
+}
-- 
2.34.1

