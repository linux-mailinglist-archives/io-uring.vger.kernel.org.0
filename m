Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CB83999FE
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFCFcM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:32:12 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:33622 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCFcL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:32:11 -0400
Received: by mail-ed1-f42.google.com with SMTP id f5so638827eds.0
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FPa2g3eK9tYrcajzFX65Mso033dEZnhad8GDbRoWQ/A=;
        b=vLCpp1tk2TexQKvMcIe5KiGIV0bjbyqE+5mtJD8frBcCk9VElIWVER+AeKMfB1X3ML
         Q/WR8dNtVVy8k34bXWLoydTLz/pU9UI0lRJPsv/F6DypGQD3+W9KvYY7jTO9Oo+sqNm7
         IdSm2nLj3fIrpIioUFOpeS0iT8RCyEYWGHEBPtCVUxQW+RZtvkM41LmAToppO/QYp/0T
         hDVd7yVCKyprB01Eu+IPF3hemaHTse+NfE8yHkpH2lIDKFs+yoyCxoeSxf9yU7I6q8XO
         nSfdfR3m1SYucGIumsWElPFBcJSjKERitCDcpjBAusecP0fo0LfuxyR6yIFd1Pryi0WX
         QXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FPa2g3eK9tYrcajzFX65Mso033dEZnhad8GDbRoWQ/A=;
        b=eWyPaifPHoBCc00bUbXkuT5+A/11Zv/OHECcPIzvtFnm4Grcu5/WxNnnnYXXJawxcW
         HIfVGaH28ErelFpRxDNQC6GVX7TtpETd+2nscW/dJJfM8Kgzxs5llMritvDkEr7RPK8Q
         7E7TzrWxdXDPOXgrnUJalMQhiTbW02xz03BuC96EmaiDApVifjVFqsqLp1gayQ/3zsR+
         scm3m8Oqzb2NLB2lHPlBgKfLnITm9xakvuMUae7UJk676KhOwTnoAEgk7JkM3SwVC9bL
         2mUwFyMRdnRAFnBRTzKNDmOzl9HzMmP9Wgo74t/UF8SIKqKNDd/O7Ca/zOXqbCywm95Z
         v+2w==
X-Gm-Message-State: AOAM531jDCrQRTAlNuKMKR61FKDZJBggRixsC9yRkKvQ5LLa1LYOL+Mq
        QSXddIiytqceeNq4q9K//6o=
X-Google-Smtp-Source: ABdhPJxxa8kFLLiBx53IIauH5SMXCQvDuimn0h9ZcyOTW4Nw+ehI8hi/7UiOxUpqJP6lwHbvPhN6Jw==
X-Received: by 2002:aa7:c44b:: with SMTP id n11mr29589837edr.4.1622698167191;
        Wed, 02 Jun 2021 22:29:27 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:26 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 05/11] Add symlinkat test case
Date:   Thu,  3 Jun 2021 12:29:00 +0700
Message-Id: <20210603052906.2616489-6-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603052906.2616489-1-dkadashev@gmail.com>
References: <20210603052906.2616489-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tests successful creation (using readlink() to verify the contents),
EEXIST, ENOENT cases.

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 .gitignore     |   1 +
 test/Makefile  |   2 +
 test/symlink.c | 113 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)
 create mode 100644 test/symlink.c

diff --git a/.gitignore b/.gitignore
index a9ae5bb..0b336d6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -112,6 +112,7 @@
 /test/statx
 /test/stdout
 /test/submit-reuse
+/test/symlink
 /test/teardowns
 /test/thread-exit
 /test/timeout
diff --git a/test/Makefile b/test/Makefile
index 86437d5..4fc78ea 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -108,6 +108,7 @@ test_targets += \
 	sq-space_left \
 	stdout \
 	submit-reuse \
+	symlink \
 	teardowns \
 	thread-exit \
 	timeout \
@@ -248,6 +249,7 @@ test_srcs := \
 	statx.c \
 	stdout.c \
 	submit-reuse.c \
+	symlink.c \
 	teardowns.c \
 	thread-exit.c \
 	timeout-new.c \
diff --git a/test/symlink.c b/test/symlink.c
new file mode 100644
index 0000000..8b5e04a
--- /dev/null
+++ b/test/symlink.c
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test io_uring symlinkat handling
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "liburing.h"
+
+
+static int do_symlinkat(struct io_uring *ring, const char *oldname, const char *newname)
+{
+	int ret;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "sqe get failed\n");
+		goto err;
+	}
+	io_uring_prep_symlinkat(sqe, oldname, AT_FDCWD, newname);
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit failed: %d\n", ret);
+		goto err;
+	}
+
+	ret = io_uring_wait_cqes(ring, &cqe, 1, 0, 0);
+	if (ret) {
+		fprintf(stderr, "wait_cqe failed: %d\n", ret);
+		goto err;
+	}
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+err:
+	return 1;
+}
+
+int test_link_contents(const char* linkname, const char *expected_contents)
+{
+	char buf[128];
+	int ret = readlink(linkname, buf, 127);
+	if (ret < 0) {
+		perror("readlink");
+		return ret;
+	}
+	buf[ret] = 0;
+	if (strncmp(buf, expected_contents, 128)) {
+		fprintf(stderr, "link contents differs from expected: '%s' vs '%s'",
+			buf, expected_contents);
+		return -1;
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	static const char target[] = "io_uring-symlinkat-test-target";
+	static const char linkname[] = "io_uring-symlinkat-test-link";
+	int ret;
+	struct io_uring ring;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = do_symlinkat(&ring, target, linkname);
+	if (ret < 0) {
+		if (ret == -EBADF || ret == -EINVAL) {
+			fprintf(stdout, "symlinkat not supported, skipping\n");
+			goto out;
+		}
+		fprintf(stderr, "symlinkat: %s\n", strerror(-ret));
+		goto err;
+	} else if (ret) {
+		goto err;
+	}
+
+	ret = test_link_contents(linkname, target);
+	if (ret < 0)
+		goto err1;
+
+	ret = do_symlinkat(&ring, target, linkname);
+	if (ret != -EEXIST) {
+		fprintf(stderr, "test_symlinkat linkname already exists failed: %d\n", ret);
+		goto err1;
+	}
+
+	ret = do_symlinkat(&ring, target, "surely/this/does/not/exist");
+	if (ret != -ENOENT) {
+		fprintf(stderr, "test_symlinkat no parent failed: %d\n", ret);
+		goto err1;
+	}
+
+out:
+	unlinkat(AT_FDCWD, linkname, 0);
+	io_uring_queue_exit(&ring);
+	return 0;
+err1:
+	unlinkat(AT_FDCWD, linkname, 0);
+err:
+	io_uring_queue_exit(&ring);
+	return 1;
+}
-- 
2.30.2

