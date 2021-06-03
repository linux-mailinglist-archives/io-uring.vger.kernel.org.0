Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEA23999FB
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhFCFbn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhFCFbe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:31:34 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD34C061756
        for <io-uring@vger.kernel.org>; Wed,  2 Jun 2021 22:29:32 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ce15so7341219ejb.4
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DmgT1qYrWnCW2IMZcGXlLyJ6mEtAlxFrZjiqe+i9BsA=;
        b=mltu3Wg6gzsXl4xtK6P/zzD4pddoI0rZ2biMfsSdAddN1g0XoXIFmgJe9N88mH/7xN
         PjBES0oYHUMf8S8mghxDVGbKwgrP23/omxYLs7M5j1/Tncv93gheBKoE9OfETnv7FtWi
         xUW7kNJniTSIowizNaLX3wQTAt2WHKu59ye4eksSS43lx3cT+dzzT0mEwHD7w5LgmYO7
         STCGXsJ4kTmBwC3zDyjpHtVp32wRk6uk8GdLXmp7UK73y47v/8nOsssQi0L0xUOTUTC1
         0brPkx1263oknPPv85rT0XgtmXmYBJ57qoFu9Oc0OAeQjSg3XqSavYe1zGmCp8jj/Gby
         Wyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DmgT1qYrWnCW2IMZcGXlLyJ6mEtAlxFrZjiqe+i9BsA=;
        b=HLFhf7oF0+LmaxvtBZaltxrWiamFvKBQzJeA+KqB8Om4ad/WYPowMlFHYV+KsAYveH
         so0aQJE+vwsfmkyEZEK9rDodP0p9fuDiyfJBBwoB0EY2rHCgNzNN8DzLHH1J/KHfvF7j
         5yUhNVSEOu/KZw74Yq6wWbu+L3ikCpu1e+1xsWBpRoOXNaT5NSThLo+iMlrmVtvCAhfE
         e4l5DOVQvKHwmjG/CO8R0A6NVYo6F+PUtzO4Ee9zGLldJQMz3OQOREodtS/R+klaanog
         fLVDrgmmUudzqn0ZzY+a82NZiuZVN2HlGHBJdBlsBzutDTeTLzJnkt8tR8cHhHXqdaP+
         Z4Mw==
X-Gm-Message-State: AOAM533T6AEYNru5e5uqHmEy99GB0am+BjXej5k0u9FgFxPNig6wDV4g
        z9b7YT6Bq1anzbhI7H89v9r0HDXBmgkT1Q==
X-Google-Smtp-Source: ABdhPJxQ4+gtErW1lnyzaASHEpCslilWZShLHWDxToH3zPOQF1P6UVV4z72/1N4Wk8I68Bf0It0EWw==
X-Received: by 2002:a17:907:2156:: with SMTP id rk22mr25325875ejb.464.1622698171036;
        Wed, 02 Jun 2021 22:29:31 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:30 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 08/11] Add linkat test case
Date:   Thu,  3 Jun 2021 12:29:03 +0700
Message-Id: <20210603052906.2616489-9-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603052906.2616489-1-dkadashev@gmail.com>
References: <20210603052906.2616489-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tests success, EEXISTS, ENOENT (no parent dir).

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 .gitignore      |   1 +
 test/Makefile   |   2 +
 test/hardlink.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+)
 create mode 100644 test/hardlink.c

diff --git a/.gitignore b/.gitignore
index 0b336d6..7a6f75c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -57,6 +57,7 @@
 /test/files-exit-hang-timeout
 /test/fixed-link
 /test/fsync
+/test/hardlink
 /test/io-cancel
 /test/io_uring_enter
 /test/io_uring_register
diff --git a/test/Makefile b/test/Makefile
index 4fc78ea..2f0a694 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -54,6 +54,7 @@ test_targets += \
 	files-exit-hang-timeout \
 	fixed-link \
 	fsync \
+	hardlink \
 	io-cancel \
 	io_uring_enter \
 	io_uring_register \
@@ -193,6 +194,7 @@ test_srcs := \
 	files-exit-hang-timeout.c \
 	fixed-link.c \
 	fsync.c \
+	hardlink.c \
 	io-cancel.c \
 	io_uring_enter.c \
 	io_uring_register.c \
diff --git a/test/hardlink.c b/test/hardlink.c
new file mode 100644
index 0000000..1c73424
--- /dev/null
+++ b/test/hardlink.c
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test io_uring linkat handling
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
+static int do_linkat(struct io_uring *ring, const char *oldname, const char *newname)
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
+	io_uring_prep_linkat(sqe, AT_FDCWD, oldname, AT_FDCWD, newname, 0);
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
+int files_linked_ok(const char* fn1, const char *fn2)
+{
+	struct stat s1, s2;
+
+	if (stat(fn1, &s1)) {
+		fprintf(stderr, "stat(%s): %s\n", fn1, strerror(errno));
+		return 0;
+	}
+	if (stat(fn2, &s2)) {
+		fprintf(stderr, "stat(%s): %s\n", fn2, strerror(errno));
+		return 0;
+	}
+	if (s1.st_dev != s2.st_dev || s1.st_ino != s2.st_ino) {
+		fprintf(stderr, "linked files have different device / inode numbers\n");
+		return 0;
+	}
+	if (s1.st_nlink != 2 || s2.st_nlink != 2) {
+		fprintf(stderr, "linked files have unexpected links count\n");
+		return 0;
+	}
+	return 1;
+}
+
+int main(int argc, char *argv[])
+{
+	static const char target[] = "io_uring-linkat-test-target";
+	static const char linkname[] = "io_uring-linkat-test-link";
+	int ret;
+	struct io_uring ring;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = open(target, O_CREAT | O_RDWR | O_EXCL, 0600);
+	if (ret < 0) {
+		perror("open");
+		goto err;
+	}
+	if (write(ret, "linktest", 8) != 8) {
+		close(ret);
+		goto err1;
+	}
+	close(ret);
+
+	ret = do_linkat(&ring, target, linkname);
+	if (ret < 0) {
+		if (ret == -EBADF || ret == -EINVAL) {
+			fprintf(stdout, "linkat not supported, skipping\n");
+			goto out;
+		}
+		fprintf(stderr, "linkat: %s\n", strerror(-ret));
+		goto err1;
+	} else if (ret) {
+		goto err1;
+	}
+
+	if (!files_linked_ok(linkname, target))
+		goto err2;
+
+	ret = do_linkat(&ring, target, linkname);
+	if (ret != -EEXIST) {
+		fprintf(stderr, "test_linkat linkname already exists failed: %d\n", ret);
+		goto err2;
+	}
+
+	ret = do_linkat(&ring, target, "surely/this/does/not/exist");
+	if (ret != -ENOENT) {
+		fprintf(stderr, "test_linkat no parent failed: %d\n", ret);
+		goto err2;
+	}
+
+out:
+	unlinkat(AT_FDCWD, linkname, 0);
+	unlinkat(AT_FDCWD, target, 0);
+	io_uring_queue_exit(&ring);
+	return 0;
+err2:
+	unlinkat(AT_FDCWD, linkname, 0);
+err1:
+	unlinkat(AT_FDCWD, target, 0);
+err:
+	io_uring_queue_exit(&ring);
+	return 1;
+}
+
-- 
2.30.2

