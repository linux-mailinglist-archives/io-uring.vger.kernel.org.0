Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4926D60EC
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbjDDMjH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbjDDMjG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:39:06 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E92DC
        for <io-uring@vger.kernel.org>; Tue,  4 Apr 2023 05:38:44 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id er13so89002864edb.9
        for <io-uring@vger.kernel.org>; Tue, 04 Apr 2023 05:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680611922;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SFJpT0cD7HbLgC+kUpLrWH4IrwcKoCVD5z5kMuUnJYA=;
        b=LQFFeSevcK5KMOiWrDO9QhsM5BxsafuCnyJvst6g/jp7rFKKvsYxRzJHpOBiow+XAs
         DaEv6kpr2m6YDQfEtpQa3c4rLBAHZBg4snA+X48OIeSQhrKuxNIoAOzzZGcNeRdUIjrz
         cl4mU3SLI5jY7VO8T0O0hWLo8Y/jpNHqJPPMSoHH+KjAofPYWYxaukw88fL8EqD7QnZ5
         gs6a37LSe6F5cGmHEjHE4C6GYTn4Rkgfb/iLbGgCIwPxuMicsWlFJDl7/7vvLEsbqZVn
         N7SjlK7JNZC+s79bWU3meazBzeiP19jylzxw3gu88Q1jaiHn08CYlGUeXnCwWEqyYFTa
         0rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680611922;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SFJpT0cD7HbLgC+kUpLrWH4IrwcKoCVD5z5kMuUnJYA=;
        b=kicYINU1FtGUuCWjuUGnnFQElDjp7R7YASBC+uwJ/CmZs/u19fsQD4HKl6IW/GDyWk
         FvXWBlqnXk2wJ3vAOa/ZdxcTGHuWs5qXd87g2j4zZMX7IbhL7cDYoBCINZ7sNIU/sAZ0
         J4Qr4sPtCw/uanmIR9me4EtUcYlCoYoP3qL6JkRUDLFOA1GN7LGmT6H9lFD0MmD9k/sx
         /ch9/d/+BGDCxvq1w8wiFRP8uYEZoJxVOofke5OWpeYtdoIaYYZMrCCCTtJnycUVUEub
         H7CIrsrLgktQO1kawG90KIXGxZ0vUMANJYykmuOmtRGtseo5CAHoh4kFvbzkBOBkMd28
         ccsg==
X-Gm-Message-State: AAQBX9f0afa1c2JhoD7YIhjVyPOyaPAxoyTvHuvurCmy4qoPjKM8AMKI
        OSCxa+5sLaXIwjPvZti6KriFD07kKxs=
X-Google-Smtp-Source: AKy350YJfkt5FWdQy0iB/bVwk3fv3vPud7giO4BZlpHIX9c+5NP9hD81rFZYcFimSzPCJRusWqsjGQ==
X-Received: by 2002:a17:906:488b:b0:948:a1ae:b2c4 with SMTP id v11-20020a170906488b00b00948a1aeb2c4mr2170441ejq.6.1680611922366;
        Tue, 04 Apr 2023 05:38:42 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id pg1-20020a170907204100b0092b546b57casm5872254ejb.195.2023.04.04.05.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:38:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 1/1] examples: add rsrc update benchmark
Date:   Tue,  4 Apr 2023 13:37:39 +0100
Message-Id: <6914bc136c752f50fc8a818773a4cb61b5e39077.1680576220.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a stupid benchmark updating files in a loop mainly for profiling
purposes and estimating the rsrc update overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/Makefile            |   3 +-
 examples/rsrc-update-bench.c | 100 +++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 examples/rsrc-update-bench.c

diff --git a/examples/Makefile b/examples/Makefile
index ce33af9..715ac4c 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -20,7 +20,8 @@ example_srcs := \
 	io_uring-udp.c \
 	link-cp.c \
 	poll-bench.c \
-	send-zerocopy.c
+	send-zerocopy.c \
+	rsrc-update-bench.c
 
 all_targets :=
 
diff --git a/examples/rsrc-update-bench.c b/examples/rsrc-update-bench.c
new file mode 100644
index 0000000..5e3cd99
--- /dev/null
+++ b/examples/rsrc-update-bench.c
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: MIT */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <signal.h>
+#include <poll.h>
+#include <sys/time.h>
+#include <sys/wait.h>
+
+#include "liburing.h"
+
+static unsigned long runtime_ms = 10000;
+
+static unsigned long gettimeofday_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
+}
+
+int main(void)
+{
+	unsigned long tstop;
+	unsigned long nr_reqs = 0;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int pipe1[2];
+	int ret, i, qd = 32;
+	int table_size = 128;
+
+	if (pipe(pipe1) != 0) {
+		perror("pipe");
+		return 1;
+	}
+
+	ret = io_uring_queue_init(1024, &ring, IORING_SETUP_SINGLE_ISSUER |
+					       IORING_SETUP_DEFER_TASKRUN);
+	if (ret) {
+		fprintf(stderr, "io_uring_queue_init failed: %d\n", ret);
+		return 1;
+	}
+	ret = io_uring_register_ring_fd(&ring);
+	if (ret < 0) {
+		fprintf(stderr, "io_uring_register_ring_fd failed\n");
+		return 1;
+	}
+	ret = io_uring_register_files_sparse(&ring, table_size);
+	if (ret < 0) {
+		fprintf(stderr, "io_uring_register_files_sparse failed\n");
+		return 1;
+	}
+
+	for (i = 0; i < table_size; i++) {
+		ret = io_uring_register_files_update(&ring, i, pipe1, 1);
+		if (ret < 0) {
+			fprintf(stderr, "io_uring_register_files_update failed\n");
+			return 1;
+		}
+	}
+
+	srand(time(NULL));
+
+	tstop = gettimeofday_ms() + runtime_ms;
+	do {
+		int off = rand();
+
+		for (i = 0; i < qd; i++) {
+			sqe = io_uring_get_sqe(&ring);
+			int roff = (off + i) % table_size;
+			io_uring_prep_files_update(sqe, pipe1, 1, roff);
+		}
+
+		ret = io_uring_submit(&ring);
+		if (ret != qd) {
+			fprintf(stderr, "child: sqe submit failed: %d\n", ret);
+			return 1;
+		}
+
+		for (i = 0; i < qd; i++) {
+			ret = io_uring_wait_cqe(&ring, &cqe);
+			if (ret < 0) {
+				fprintf(stderr, "child: wait completion %d\n", ret);
+				break;
+			}
+			io_uring_cqe_seen(&ring, cqe);
+			nr_reqs++;
+		}
+	} while (gettimeofday_ms() < tstop);
+
+	fprintf(stderr, "max updates/s: %lu\n", nr_reqs * 1000UL / runtime_ms);
+
+	io_uring_queue_exit(&ring);
+	close(pipe1[0]);
+	close(pipe1[1]);
+	return 0;
+}
-- 
2.39.1

