Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971081F0C6F
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgFGPeI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 11:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgFGPeH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 11:34:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7431C08C5C3;
        Sun,  7 Jun 2020 08:34:06 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r7so14747618wro.1;
        Sun, 07 Jun 2020 08:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9s7KhI5vPLtATNHxZx+Ggu/v5wUXaWs1QuIcEHVtVjI=;
        b=mZDUJvhFPu1sE9sM07ARXY7uxXaCDlfATkVD6AeXQ1OhsAAO8MdQ+pZ7ZZj+xLpm9l
         dspCK+V55UAFZ+FFtFxkr+hPBG2uXDzVJRbA8JWLZsHlIDLDfA4fMrkREi7lyOWh0Emc
         Es9sIo+JvhBqyerOhryTO5ToYJqipDp1RH/ueYMHDlue6Xetg4wrjiB2LC/BMvz9YDpP
         g/ly38tSsQ5zt/pdV2sH+cyulN7PS3X+5bEEuboVrNwsVMuKwbdmqNI2oQxabAhmUE8u
         xSGvNK7JmMppyUQaRNgdJyFVQJPd9Wytt1GRaY2jmFa0r83yJoVhFCdX9HYJnAyLX/i+
         eifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9s7KhI5vPLtATNHxZx+Ggu/v5wUXaWs1QuIcEHVtVjI=;
        b=shbRG/tqZznSgkC04XBOn5lEuh/BGC8RJWqt1GgDWyiXtfGDJI3yHEUQcBVv7bi5gT
         YpVuG8Vjnf08RN+teodq6RlDbI7V8WuPrQOJG1DshsVxjIyLX8JJjR8gNBwOBoK6jL24
         nzhIRFHAboNIyc3sZBY5Ql1xjxaUKsyQkK3a+E3m2l/zdzIcT4W/cZUvSCt+Fwzy1f7s
         FSAGAK3zMh5bWIsr6AGFOAYeS6vmfz0ZkiHG2q4s1WliboKJqqZQXnslscWCNtlGdmoT
         Z/toQfgTVUCach4V4g3B6D22ypo97293oi9y7Kn3ahBrD1dM1HqUy7mjVw8y0sK6AneA
         bLIQ==
X-Gm-Message-State: AOAM533kPEp5uOoMV9d1cTqQk1zUDmGCAe7M1SC8d5G70NIOwuQ+coO3
        nAe7DNnRjANfVuwpc4joVcdXF3Yr
X-Google-Smtp-Source: ABdhPJx5E3sX/HJCs/UWv1Cwm+jXbfE48MLL9+ygRY1yx224DLfXO9us/H5C7iBsT3nYyYNGEdp0PQ==
X-Received: by 2002:adf:dd46:: with SMTP id u6mr17990482wrm.44.1591544045556;
        Sun, 07 Jun 2020 08:34:05 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id 1sm19589015wmz.13.2020.06.07.08.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 08:34:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [liburing PATCH] flush/test: test flush of dying process
Date:   Sun,  7 Jun 2020 18:32:21 +0300
Message-Id: <b8223d3555dd47160ba5daf1f0a0f9080dcbf13c.1591537421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591541128.git.asml.silence@gmail.com>
References: <cover.1591541128.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make sure all requests of a going away process are cancelled.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io-cancel.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/test/io-cancel.c b/test/io-cancel.c
index 75fbf43..d8b04d9 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -10,6 +10,8 @@
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/time.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
 
 #include "liburing.h"
 
@@ -17,6 +19,8 @@
 #define BS		4096
 #define BUFFERS		(FILE_SIZE / BS)
 
+#define NR_REQS 10
+
 static struct iovec *vecs;
 
 static int create_buffers(void)
@@ -228,10 +232,108 @@ err:
 	return 1;
 }
 
+static void submit_child(struct io_uring *ring, int fds[2])
+{
+	struct io_uring_sqe *sqe;
+	int ret, i;
+	char buffer[128];
+
+	for (i = 0; i < NR_REQS; ++i) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "get sqe failed\n");
+			goto err;
+		}
+		io_uring_prep_read(sqe, fds[0], buffer, sizeof(buffer), 0);
+		sqe->flags |= IOSQE_ASYNC;
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret != NR_REQS) {
+		printf("sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	exit(0);
+err:
+	exit(-1);
+}
+
+/* make sure requests of a going away task are cancelled */
+static int test_cancel_exiting_task(void)
+{
+	struct io_uring *ring;
+	int ret, i;
+	pid_t p;
+	int fds[2];
+
+	ring = mmap(0, sizeof(*ring), PROT_READ|PROT_WRITE,
+		    MAP_SHARED | MAP_ANONYMOUS, 0, 0);
+	if (!ring) {
+		fprintf(stderr, "mmap failed\n");
+		return 1;
+	}
+
+	ret = io_uring_queue_init(NR_REQS * 2, ring, 0);
+	if (ret < 0) {
+		fprintf(stderr, "queue init failed\n");
+		return 1;
+	}
+
+	if (pipe(fds)) {
+		perror("pipe() failed");
+		exit(1);
+	}
+
+	p = fork();
+	if (p < 0) {
+		printf("fork() failed\n");
+		return 1;
+	}
+
+	if (p == 0) {
+		/* child */
+		submit_child(ring, fds);
+	} else {
+		int wstatus;
+		struct io_uring_cqe *cqe;
+
+		waitpid(p, &wstatus, 0);
+		if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus) != 0) {
+			fprintf(stderr, "child failed\n");
+			return 1;
+		}
+
+		for (i = 0; i < NR_REQS; ++i) {
+			ret = io_uring_wait_cqe(ring, &cqe);
+			if (ret < 0) {
+				printf("wait_cqes: wait completion %d\n", ret);
+				return 1;
+			}
+			if (cqe->res != -ECANCELED && cqe->res != -EINTR) {
+				fprintf(stderr, "invalid CQE: %i\n", cqe->res);
+				return 1;
+			}
+			io_uring_cqe_seen(ring, cqe);
+		}
+	}
+
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(ring);
+	munmap(ring, sizeof(*ring));
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int i, ret;
 
+	if (test_cancel_exiting_task()) {
+		fprintf(stderr, "test_cancel_exiting_task failed\n");
+		return 1;
+	}
+
 	if (create_file(".basic-rw")) {
 		fprintf(stderr, "file creation failed\n");
 		goto err;
-- 
2.24.0

