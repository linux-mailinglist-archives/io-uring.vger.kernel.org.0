Return-Path: <io-uring+bounces-5371-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF1D9EA30D
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:44:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 539AD1669CA
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003C92248A3;
	Mon,  9 Dec 2024 23:44:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0037F19F489
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733787872; cv=none; b=jdWe/YvHOdev1CUTXIcersQrxUzJHaQzM2p2vuDdo60lh118G6qQTatzzSI7Mv6ekWFpvIgdBPtoVg04enTHgn4XV7exUaidk6lM+eTJOTsJmnp71m0bVy9C0EeLGK+tdGSMnxxc/e8w21+eLGkE4pico0luGl8fyzqSgnEKpcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733787872; c=relaxed/simple;
	bh=2trqCa9ISTOAj7a+vn0K/ax+fBjorO7j/HE0s42lrrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez3fxzGvX05/uMHAlKInhijTgUY4PQg5TCsjN5rdj8oBOFrC6lTxLxEr8C40PyHW+B3ikZfGeGyATYivBO4zqPJU1ZYrJdrpLH2BUGMob8ddY6wX4Lj7T6FbevPMwT4fvlruVKsfOGiObbCeSfakvo7ldRvXOKFxJUIKV+emuvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8BE6B21169;
	Mon,  9 Dec 2024 23:44:29 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3ACF7138A5;
	Mon,  9 Dec 2024 23:44:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4TY/B92AV2c3HQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 09 Dec 2024 23:44:29 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH RFC liburing 2/2] tests: Add test for CLONE/EXEC operations
Date: Mon,  9 Dec 2024 18:44:21 -0500
Message-ID: <20241209234421.4133054-3-krisman@suse.de>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241209234421.4133054-1-krisman@suse.de>
References: <20241209234421.4133054-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 8BE6B21169
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/Makefile     |   1 +
 test/clone-exec.c | 436 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 437 insertions(+)
 create mode 100644 test/clone-exec.c

diff --git a/test/Makefile b/test/Makefile
index 3fc4a42..70ebd5f 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -61,6 +61,7 @@ test_srcs := \
 	buf-ring-nommap.c \
 	buf-ring-put.c \
 	ce593a6c480a.c \
+	clone-exec.c \
 	close-opath.c \
 	connect.c \
 	connect-rep.c \
diff --git a/test/clone-exec.c b/test/clone-exec.c
new file mode 100644
index 0000000..7e00345
--- /dev/null
+++ b/test/clone-exec.c
@@ -0,0 +1,436 @@
+#include <assert.h>
+#include <err.h>
+#include <inttypes.h>
+#include <sched.h>
+#include <spawn.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+
+ #include <sys/stat.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+char **t_envp;
+
+#define MAX_PATH 1024
+
+int test_fail_sequence(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int ret;
+
+	ret = t_create_ring(10, &ring, IORING_SETUP_SUBMIT_ALL);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return T_SETUP_SKIP;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_clone(sqe);
+	sqe->flags |= IOSQE_IO_LINK;
+
+	/* Add a command that will fail. */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+	sqe->nop_flags = IORING_NOP_INJECT_RESULT;
+
+	/*
+	 * A random magic number to be retrieved in cqe->res.  Not a
+	 * valid errno returned by io_uring.
+	 */
+	sqe->len = -255;
+	sqe->flags |= IOSQE_IO_LINK;
+
+	/* And a NOP that will succeed */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+
+	io_uring_submit(&ring);
+
+ 	if (io_uring_wait_cqes(&ring, &cqe, 3, NULL, NULL)) {
+ 		fprintf(stderr, "%s: Failed to wait for cqes\n", __func__);
+ 		return T_EXIT_FAIL;
+ 	}
+
+	/* Check the CLONE */
+	if (cqe->res) {
+ 		fprintf(stderr, "%s: failed to clone. Got %d\n",
+			__func__, cqe->res);
+ 		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_peek_cqe(&ring, &cqe);
+	if (cqe->res != -255) {
+ 		fprintf(stderr, "%s: This nop should have failed with 255. Got %d\n",
+			__func__, cqe->res);
+ 		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_peek_cqe(&ring, &cqe);
+	if (cqe->res != -ECANCELED) {
+ 		fprintf(stderr, "%s: This should have been -ECANCELED. Got %d\n",
+			__func__, cqe->res);
+ 		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+
+	return 0;
+}
+
+int test_bad_exec(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	char *command = "/usr/bin/echo";
+	char *const t_argv[] = { "/usr/bin/echo", "Hello World",  NULL };
+	int ret;
+
+	ret = t_create_ring(10, &ring, IORING_SETUP_SUBMIT_ALL);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return T_SETUP_SKIP;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_execveat(sqe, AT_FDCWD, command, t_argv, t_envp, 0);
+	io_uring_sqe_set_flags(sqe, IOSQE_IO_LINK|IOSQE_IO_HARDLINK);
+
+	io_uring_submit(&ring);
+
+ 	if (io_uring_wait_cqe(&ring, &cqe)) {
+ 		fprintf(stderr, "%s: Failed to wait for cqe\n", __func__);
+ 		return T_EXIT_FAIL;
+ 	}
+
+	/* Check the EXEC */
+	if (cqe->res != -EINVAL) {
+ 		fprintf(stderr, "%s: EXEC should have failed. Got %d\n",
+			__func__, cqe->res);
+ 		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+
+	return 0;
+}
+
+int test_simple_sequence(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int ret, head, i, reaped = 0;
+
+	ret = t_create_ring(10, &ring, IORING_SETUP_SUBMIT_ALL);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return T_SETUP_SKIP;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_clone(sqe);
+	sqe->flags |= IOSQE_IO_LINK;
+
+	/* And a few that will succeed */
+	for (i = 0; i < 5; i++) {
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_nop(sqe);
+		sqe->flags |= IOSQE_IO_LINK;
+	}
+
+	io_uring_submit(&ring);
+
+	if (io_uring_wait_cqes(&ring, &cqe, i+1, NULL, NULL)) {
+		fprintf(stderr, "%s: Failed to wait for cqes\n", __func__);
+		return T_EXIT_FAIL;
+ 	}
+
+	/* Check the CLONE */
+	if (cqe->res) {
+		fprintf(stderr, "%s: failed to clone. Got %d\n",
+			__func__, cqe->res);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* Check the NOPS */
+	io_uring_for_each_cqe(&ring, head, cqe) {
+		reaped++;
+		if (cqe->res) {
+			fprintf(stderr, "%s: This NOP should have succeeded. Got %d\n",
+				__func__, cqe->res);
+	 		return T_EXIT_FAIL;
+		}
+	} io_uring_cq_advance(&ring, reaped);
+
+	io_uring_queue_exit(&ring);
+
+	return 0;
+}
+
+
+int test_unlinked_clone_sequence(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int ret;
+
+	ret = t_create_ring(10, &ring, IORING_SETUP_SUBMIT_ALL);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return T_SETUP_SKIP;
+	}
+
+	/* Issue unlinked clone. */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_clone(sqe);
+
+	io_uring_submit(&ring);
+
+	if (io_uring_wait_cqe(&ring, &cqe)) {
+		fprintf(stderr, "%s: Failed to wait for cqes\n", __func__);
+		return T_EXIT_FAIL;
+	}
+
+	if (cqe->res != -EINVAL) {
+		fprintf(stderr,
+			"%s: Unlinked clone should have failed. Got %d\n",
+			__func__, cqe->res);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+int test_bad_link_sequence(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	int ret;
+
+	ret = t_create_ring(10, &ring, IORING_SETUP_SUBMIT_ALL);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return T_SETUP_SKIP;
+	}
+
+	/* Issue link that doesn't start with clone. */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_clone(sqe);
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+
+	io_uring_submit(&ring);
+
+	if (io_uring_wait_cqes(&ring, &cqe, 3, NULL, NULL)) {
+		fprintf(stderr, "%s: Failed to wait for cqes\n", __func__);
+		return T_EXIT_FAIL;
+	}
+
+	if (cqe->res != -ECANCELED) {
+		fprintf(stderr,
+			"%s: first NOP should have been canceled. Got %d\n",
+			__func__, cqe->res);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_peek_cqe(&ring, &cqe);
+	if (cqe->res != -EINVAL) {
+		fprintf(stderr,
+			"%s: CLONE not starting link should've failed. "
+			"Got %d\n", __func__, cqe->res);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+#define TEST_FILE "./clone-exec-test-file"
+
+/* Execute 'touch TEST_FILE' by doing a lookup in $PATH and verify the
+   command was executed by checking the file exists.  It would have been
+   better to just redirect the output and use an echo, but we have no
+   dup(2) in io_uring to redirect stdout inside the spawned task yet.
+ */
+int test_spawn_sequence(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	unsigned int head;
+	int ret, i, reaped = 0;
+	char *buf;
+
+	bool did_exec = false;
+	struct stat statbuf;
+
+	char *const t_argv[] = { "touch", TEST_FILE,  NULL };
+
+	char *path[]= { "/usr/local/bin/", "/usr/local/sbin/", "/usr/bin/",
+			"/usr/sbin/", "/sbin", "/bin" };
+
+	ret = t_create_ring(10, &ring, IORING_SETUP_SUBMIT_ALL);
+	if (ret < 0) {
+
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return T_SETUP_SKIP;
+	}
+
+	ret = fstatat(AT_FDCWD, TEST_FILE, &statbuf, 0);
+	if (!ret) {
+		ret = unlinkat(AT_FDCWD, TEST_FILE, 0);
+		if (ret) {
+			printf("Failed to unlink tmp file\n");
+			return T_SETUP_SKIP;
+		}
+	} else if (errno == ENOENT) {
+		ret = 0;
+	} else {
+		printf("failed to fstatat %d\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_clone(sqe);
+	/* allocate from heap to simplify freeing. */
+	sqe->user_data = (__u64) strdup("clone");
+	sqe->flags |= IOSQE_IO_LINK;
+
+	for (i = 0; i < ARRAY_SIZE(path); i++ ) {
+		buf = malloc(MAX_PATH);
+		if (!buf)
+			return -ENOMEM;
+		snprintf(buf, MAX_PATH, "%s/%s", path[i], "touch");
+
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_execveat(sqe, AT_FDCWD, buf, t_argv, t_envp, 0);
+		sqe->user_data = (__u64) buf;
+		io_uring_sqe_set_flags(sqe, IOSQE_IO_LINK|IOSQE_IO_HARDLINK);
+	}
+
+	io_uring_submit_and_wait(&ring, i + 1);
+
+	/* Check the CLONE */
+	io_uring_peek_cqe(&ring, &cqe);
+	if (cqe->res) {
+		fprintf(stderr, "%s: failed to clone. Got %d\n",
+			__func__, cqe->res);
+		return T_EXIT_FAIL;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* Check the EXEC */
+	io_uring_for_each_cqe(&ring, head, cqe) {
+		reaped++;
+
+		if (!did_exec) {
+			if (cqe->res == 0) {
+				/* An execve succeeded */
+				did_exec = true;
+			} else if (!(cqe->res == -ENOENT)) {
+				printf("EXEC %s: expecting -ENOENT got %d\n",
+				       (char*)cqe->user_data, cqe->res);
+				ret = T_EXIT_FAIL;
+			}
+			/* We are looking at $PATH to find a suitable
+			 * binary.  Any -ENOENT before succeeding the
+			 * exec is expected.
+			 */
+		} else {
+			/* After an exec, further requests must be canceled. */
+			if (!(cqe->res == -ECANCELED)) {
+				printf("EXEC %s: expecting -ECANCELED got %d\n",
+				       (char*)cqe->user_data, cqe->res);
+				ret = T_EXIT_FAIL;
+			}
+		}
+		free((char*)cqe->user_data);
+	} io_uring_cq_advance(&ring, reaped);
+
+
+	if (!did_exec) {
+		printf("All OP_EXEC failed!\n");
+		ret = T_EXIT_FAIL;
+	}
+
+	ret = fstatat(AT_FDCWD, TEST_FILE, &statbuf, 0);
+	if (ret) {
+		/* We might need to give the spawned command a chance to run. */
+		sleep(1);
+		ret = fstatat(AT_FDCWD, TEST_FILE, &statbuf, 0);
+		if (ret) {
+			printf("Touch didn't run? File wasn't created! errno=%d\n", errno);
+			return T_EXIT_FAIL;
+		}
+	}
+
+	io_uring_queue_exit(&ring);
+	return ret;
+}
+
+int main(int argc, char *argv[], char *envp[])
+{
+	int ret = 0;
+
+	t_envp = envp;
+
+	if (test_fail_sequence()) {
+		fprintf(stderr, "test_failed_sequence failed\n");
+		ret = T_EXIT_FAIL;
+	}
+
+	if (test_unlinked_clone_sequence()) {
+		fprintf(stderr, "test_unlinked_clone_sequence\n");
+		ret = T_EXIT_FAIL;
+	}
+
+	if (test_bad_link_sequence()) {
+		fprintf(stderr, "test_bad_link_sequence failed\n");
+		ret = T_EXIT_FAIL;
+	}
+
+	if (test_simple_sequence()) {
+		fprintf(stderr, "test_simple_sequence failed\n");
+		ret = T_EXIT_FAIL;
+	}
+
+	if (test_bad_exec()) {
+		fprintf(stderr, "test_bad_exec failed\n");
+		ret = T_EXIT_FAIL;
+	}
+
+	if (test_spawn_sequence()) {
+		fprintf(stderr, "test_spawn_sequence failed\n");
+		ret = T_EXIT_FAIL;
+	}
+
+	return ret;
+}
-- 
2.47.0


