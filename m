Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7760B31A685
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 22:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhBLVG6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 16:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbhBLVG5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 16:06:57 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2676CC061756
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 13:06:17 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id v1so843954wrd.6
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 13:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=31sVI0nMNfk+tE2JcftspagRgwNCw3fgUFOkWR5c250=;
        b=hfYBIEFEJ3gM/RwDMGc97Dgn4hTIfG957y/JIGp3udeXvccOS5ExCNiKmvAHGKzpvA
         un64GL8NeREcXpx8S7eJ6+pbtV3HqgvNIUjDY+ZuwZvfaQ2CDu5Fg89rA7CCBm3KTcy0
         zLPB+2EZVsc1comdYNuxRdXOp1Qda5e8UVbXHm6wL42uHIZXKrtsyT3pcBat3Fpy6Rvx
         Z1ohbxb53BO8UNXVDxMdH2M2h7XfKKc3oSvWthwYqSKW64wB81CU8Y+evgAzU4xOBEUr
         8mmPT4xxkP/3GKAxC4/EXjiS7c6uo8a/tIoJKiT1Px0ZWLL9+NShI8At5ef6Ga4hIq9L
         7/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=31sVI0nMNfk+tE2JcftspagRgwNCw3fgUFOkWR5c250=;
        b=MRae3VZNZbFUd1qDb2cToHSpddwjycumWpSbTei5IZ0XaJSGnMaC+BBX1NkIDUVsCn
         6K4K23Jq0NXqNFfXvtqN0cmZzBeXWn7l2fTk+ud0iDEXYbrtCpYOTJWUVLqykUujzwUH
         vN2ZZAPrBGYTdHCjIjTJc4aiOHntVXpRzmANi/pUJxt121Gl8zKqe1nczvW0kiYIC0+o
         EDmVzXq3f+GTawthPT014CYNpnqgxYkW3WMnPgVBP0lpm43wyK2sMXrveF0+fvB4atbk
         jKuMHZgCMOY+jGMlRYRa025S+LPCvK00WkKUQ3l9gQM8W/zvYdaAmpNT6oSTS6B6KQK+
         UgTQ==
X-Gm-Message-State: AOAM530YrItvlphD7MXz5eINoYauR9KkUJC2QF6MFj7d1DIUQqWAAnH9
        rQ6OkO3zdDjv7+vMjO906AK+eURdXdCFKQ==
X-Google-Smtp-Source: ABdhPJwbZm0V7rVRYNQm0E9rWGTspHWojQap3eB0urxFMf5AQOfjJ6maVkeKNO9fQlTGojNs0XXHGg==
X-Received: by 2002:a5d:540d:: with SMTP id g13mr5575660wrv.143.1613163975295;
        Fri, 12 Feb 2021 13:06:15 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id d10sm11577619wrn.88.2021.02.12.13.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 13:06:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Petr Vorel <pvorel@suse.cz>
Subject: [PATCH liburing] a test for CVE-2020-29373 (AF_UNIX path resolution)
Date:   Fri, 12 Feb 2021 21:02:07 +0000
Message-Id: <43f46a40dbc37bebf78f14d7738d5195dbb64460.1613163628.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a regression test for CVE-2020-29373 where io-wq do path resolution
issuing sendmsg, but doesn't have proper fs set up.

Reported-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile         |   2 +
 test/sendmsg_fs_cve.c | 193 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+)
 create mode 100644 test/sendmsg_fs_cve.c

diff --git a/test/Makefile b/test/Makefile
index 157ff95..7751eff 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -111,6 +111,7 @@ test_targets += \
 	timeout-overflow \
 	unlink \
 	wakeup-hang \
+	sendmsg_fs_cve \
 	# EOL
 
 all_targets += $(test_targets)
@@ -238,6 +239,7 @@ test_srcs := \
 	timeout.c \
 	unlink.c \
 	wakeup-hang.c \
+	sendmsg_fs_cve.c \
 	# EOL
 
 test_objs := $(patsubst %.c,%.ol,$(patsubst %.cc,%.ol,$(test_srcs)))
diff --git a/test/sendmsg_fs_cve.c b/test/sendmsg_fs_cve.c
new file mode 100644
index 0000000..85f271b
--- /dev/null
+++ b/test/sendmsg_fs_cve.c
@@ -0,0 +1,193 @@
+/*
+ * repro-CVE-2020-29373 -- Reproducer for CVE-2020-29373.
+ *
+ * Copyright (c) 2021 SUSE
+ * Author: Nicolai Stange <nstange@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <unistd.h>
+#include <syscall.h>
+#include <stdio.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <inttypes.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include "liburing.h"
+
+/*
+ * This attempts to make the kernel issue a sendmsg() to
+ * path from io_uring's async io_sq_wq_submit_work().
+ *
+ * Unfortunately, IOSQE_ASYNC is available only from kernel version
+ * 5.6 onwards. To still force io_uring to process the request
+ * asynchronously from io_sq_wq_submit_work(), queue a couple of
+ * auxiliary requests all failing with EAGAIN before. This is
+ * implemented by writing repeatedly to an auxiliary O_NONBLOCK
+ * AF_UNIX socketpair with a small SO_SNDBUF.
+ */
+static int try_sendmsg_async(const char * const path)
+{
+	int snd_sock, r;
+	struct io_uring ring;
+	char sbuf[16] = {};
+	struct iovec siov = { .iov_base = &sbuf, .iov_len = sizeof(sbuf) };
+	struct sockaddr_un addr = {};
+	struct msghdr msg = {
+		.msg_name = &addr,
+		.msg_namelen = sizeof(addr),
+		.msg_iov = &siov,
+		.msg_iovlen = 1,
+	};
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+
+	snd_sock = socket(AF_UNIX, SOCK_DGRAM, 0);
+	if (snd_sock < 0) {
+		perror("socket(AF_UNIX)");
+		return -1;
+	}
+
+	addr.sun_family = AF_UNIX;
+	strcpy(addr.sun_path, path);
+
+	r = io_uring_queue_init(512, &ring, 0);
+	if (r < 0) {
+		fprintf(stderr, "ring setup failed: %d\n", r);
+		goto close_iour;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		r = -EFAULT;
+		goto close_iour;
+	}
+
+	/* the actual one supposed to fail with -ENOENT. */
+	io_uring_prep_sendmsg(sqe, snd_sock, &msg, 0);
+	sqe->flags = IOSQE_ASYNC;
+	sqe->user_data = 255;
+
+	r = io_uring_submit(&ring);
+	if (r != 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", r);
+		r = -EFAULT;
+		goto close_iour;
+	}
+
+	r = io_uring_wait_cqe(&ring, &cqe);
+	if (r < 0) {
+		fprintf(stderr, "wait completion %d\n", r);
+		r = -EFAULT;
+		goto close_iour;
+	}
+	if (cqe->user_data != 255) {
+		fprintf(stderr, "user data %d\n", r);
+		r = -EFAULT;
+		goto close_iour;
+	}
+	if (cqe->res != -ENOENT) {
+		r = 3;
+		fprintf(stderr,
+			"error: cqe %i: res=%i, but expected -ENOENT\n",
+			(int)cqe->user_data, (int)cqe->res);
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+close_iour:
+	io_uring_queue_exit(&ring);
+	close(snd_sock);
+	return r;
+}
+
+int main(int argc, char *argv[])
+{
+	int r;
+	char tmpdir[] = "/tmp/tmp.XXXXXX";
+	int rcv_sock;
+	struct sockaddr_un addr = {};
+	pid_t c;
+	int wstatus;
+
+	if (!mkdtemp(tmpdir)) {
+		perror("mkdtemp()");
+		return 1;
+	}
+
+	rcv_sock = socket(AF_UNIX, SOCK_DGRAM, 0);
+	if (rcv_sock < 0) {
+		perror("socket(AF_UNIX)");
+		r = 1;
+		goto rmtmpdir;
+	}
+
+	addr.sun_family = AF_UNIX;
+	snprintf(addr.sun_path, sizeof(addr.sun_path), "%s/sock", tmpdir);
+
+	r = bind(rcv_sock, (struct sockaddr *)&addr,
+		 sizeof(addr));
+	if (r < 0) {
+		perror("bind()");
+		close(rcv_sock);
+		r = 1;
+		goto rmtmpdir;
+	}
+
+	c = fork();
+	if (!c) {
+		close(rcv_sock);
+
+		if (chroot(tmpdir)) {
+			perror("chroot()");
+			return 1;
+		}
+
+		r = try_sendmsg_async(addr.sun_path);
+		if (r < 0) {
+			/* system call failure */
+			r = 1;
+		} else if (r) {
+			/* test case failure */
+			r += 1;
+		}
+		return r;
+	}
+
+	if (waitpid(c, &wstatus, 0) == (pid_t)-1) {
+		perror("waitpid()");
+		r = 1;
+		goto rmsock;
+	}
+	if (!WIFEXITED(wstatus)) {
+		fprintf(stderr, "child got terminated\n");
+		r = 1;
+		goto rmsock;
+	}
+	r = WEXITSTATUS(wstatus);
+	if (r)
+		fprintf(stderr, "error: Test failed\n");
+rmsock:
+	close(rcv_sock);
+	unlink(addr.sun_path);
+rmtmpdir:
+	rmdir(tmpdir);
+	return r;
+}
-- 
2.24.0

