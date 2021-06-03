Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFC6399A08
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhFCFcc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:32:32 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:37616 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFCFcc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:32:32 -0400
Received: by mail-ej1-f47.google.com with SMTP id ce15so7341383ejb.4
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lR2Kge/iJ+Ob1jBkNgu+qzHwfyJXJ/cQrU1W8EvWLRo=;
        b=ubRzogWXYcLyJyBMZkwtKSp8PrXeA48BnubEZcpwXrwqP/vRjX+1hM8sNxyQmhqj+h
         rXEeBUgyqrn//JmMZRjfAdGQN1VYEZn5yFbJZYytci30t79kGuFEJUR/JaB37nUr8UOk
         aavdxTox9RXZHeR3ZLMthzZowOgvPszVVZWkb63TCGmPi/E1uK0WVp3GYAOyPtMdMU+C
         32ymOFqCMneY1QP0Zr/A7QJuPqF+9avAvKMlhztMOixPaPUzwMeSRkQWy4noDOMBWMrw
         sGx1qvovcahRrlAxmhFOPFYMwvLlAsZS3n5Tq7MOsJUJv5Qw3VoxTp76vI/TkGUuUEeM
         BKdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lR2Kge/iJ+Ob1jBkNgu+qzHwfyJXJ/cQrU1W8EvWLRo=;
        b=ASstxJj+MZWOGq785OXKKPfqxFDRFuHcJevchg5x6Qs033Kc2n/RamgnK8vF94NQCG
         Juf1ur1DyTdI1C4YA+KnUB8rJFelQgKvFXm7YtYi4udx2EFwvuJEe67nc99BJ9lFJHsZ
         GoFXvxTdMiQnzfHD88gcn83i2uiZlKdU0jFODqef4LkcEMUGJeeVyaMQxb0qm8reVw03
         xql3K+xEdRxr/Fg2TIXPqwG+8VOTjTRtn87D8YCorrWTxhTZYvFvPHAYVCxifrwhwMHc
         XI+Uk1QABZV+BRJVBgNqbTOqoEa/tiabMqfzMughhCTVM3iUZj4+FtqVX8UXpqkC5UU6
         WJZA==
X-Gm-Message-State: AOAM5313pkISUSGUNKzUf+xuQubIO9HLDsNlB66VlZT6JgciA9K0an9S
        DkQo+lIVoZDXxzLrAXsBr18=
X-Google-Smtp-Source: ABdhPJw6K/t75FTc5Ha0HV9/8TnFaibw+O3A1cWG8rFbRdwv6+7nInjDJYwGKT2kAJrEe/Al9ZkQ/w==
X-Received: by 2002:a17:906:33d6:: with SMTP id w22mr36720311eja.222.1622698174770;
        Wed, 02 Jun 2021 22:29:34 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:34 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 11/11] Add mknod test case
Date:   Thu,  3 Jun 2021 12:29:06 +0700
Message-Id: <20210603052906.2616489-12-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603052906.2616489-1-dkadashev@gmail.com>
References: <20210603052906.2616489-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tests success (fifo, char dev), EEXISTS, ENOENT (no parent dir).

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 .gitignore    |   1 +
 test/Makefile |   2 +
 test/mknod.c  | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 158 insertions(+)
 create mode 100644 test/mknod.c

diff --git a/.gitignore b/.gitignore
index 7a6f75c..93cc1ea 100644
--- a/.gitignore
+++ b/.gitignore
@@ -70,6 +70,7 @@
 /test/link_drain
 /test/madvise
 /test/mkdir
+/test/mknod
 /test/nop
 /test/nop-all-sizes
 /test/open-close
diff --git a/test/Makefile b/test/Makefile
index 2f0a694..fbc6c0f 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -67,6 +67,7 @@ test_targets += \
 	link_drain \
 	madvise \
 	mkdir \
+	mknod \
 	multicqes_drain \
 	nop \
 	nop-all-sizes \
@@ -207,6 +208,7 @@ test_srcs := \
 	link_drain.c \
 	madvise.c \
 	mkdir.c \
+	mknod.c \
 	multicqes_drain.c \
 	nop-all-sizes.c \
 	nop.c \
diff --git a/test/mknod.c b/test/mknod.c
new file mode 100644
index 0000000..d82e243
--- /dev/null
+++ b/test/mknod.c
@@ -0,0 +1,155 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test io_uring mknodat handling
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "liburing.h"
+
+static int do_mknodat(struct io_uring *ring, const char *fn, mode_t mode, dev_t dev)
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
+	io_uring_prep_mknodat(sqe, AT_FDCWD, fn, mode, dev);
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
+int check_fifo(const char* fn)
+{
+	char buf[4];
+	int fd = open(fn, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "failed to open fifo: %s\n", strerror(errno));
+		return 1;
+	}
+	if (write(fd, "42", 2) != 2) {
+		fprintf(stderr, "short write to fifo\n");
+		return 1;
+	}
+	if (read(fd, buf, 2) != 2) {
+		fprintf(stderr, "short read from fifo\n");
+		return 1;
+	}
+	buf[3] = 0;
+	if (strncmp(buf, "42", 2)) {
+		fprintf(stderr, "read unexpected data from fifo: %s\n", buf);
+		return 1;
+	}
+
+	return 0;
+}
+
+int test_device(struct io_uring *ring, const char* fn)
+{
+	// 1, 3 is /dev/null
+	struct stat sb;
+	dev_t dev = makedev(1, 3);
+	int ret = do_mknodat(ring, fn, 0600 | S_IFCHR, dev);
+	if (ret < 0) {
+		fprintf(stderr, "mknodat device: %s\n", strerror(-ret));
+		return ret;
+	} else if (ret) {
+		return ret;
+	}
+	ret = stat(fn, &sb);
+	if (ret) {
+		perror("stat");
+		return ret;
+	}
+	if (sb.st_rdev != dev) {
+		fprintf(stderr, "unexpected device number: %d, %d\n",
+			major(sb.st_rdev), minor(sb.st_rdev));
+		return 1;
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	static const char fn[] = "io_uring-mknodat-test";
+	int ret;
+	struct io_uring ring;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = do_mknodat(&ring, fn, 0600 | S_IFIFO, 0);
+	if (ret < 0) {
+		if (ret == -EBADF || ret == -EINVAL) {
+			fprintf(stdout, "mknodat not supported, skipping\n");
+			goto out;
+		}
+		fprintf(stderr, "mknodat: %s\n", strerror(-ret));
+		goto err;
+	} else if (ret) {
+		goto err;
+	}
+
+
+	if (check_fifo(fn))
+		goto err1;
+
+	ret = do_mknodat(&ring, fn, 0600 | S_IFIFO, 0);
+	if (ret != -EEXIST) {
+		fprintf(stderr, "do_mknodat already exists failed: %d\n", ret);
+		goto err1;
+	}
+
+	ret = do_mknodat(&ring, "surely/this/wont/exist", 0600 | S_IFIFO, 0);
+	if (ret != -ENOENT) {
+		fprintf(stderr, "do_mkdirat no parent failed: %d\n", ret);
+		goto err1;
+	}
+
+	unlinkat(AT_FDCWD, fn, 0);
+
+	if (!geteuid()) {
+		if (test_device(&ring, fn))
+			goto err1;
+	}
+	else
+		fprintf(stdout, "skipping the device test which needs root perms\n");
+
+out:
+	unlinkat(AT_FDCWD, fn, 0);
+	io_uring_queue_exit(&ring);
+	return 0;
+err1:
+	unlinkat(AT_FDCWD, fn, 0);
+err:
+	io_uring_queue_exit(&ring);
+	return 1;
+}
+
-- 
2.30.2

