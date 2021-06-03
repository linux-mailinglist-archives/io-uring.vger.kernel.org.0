Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915B73999F9
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhFCFbn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFCFb2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:31:28 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9875C06174A
        for <io-uring@vger.kernel.org>; Wed,  2 Jun 2021 22:29:24 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gb17so7312611ejc.8
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 22:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lGGPvmrXsX671EomgZnTABC+ac2Q8+DxgwxuD22zii4=;
        b=FWvqX9xYHUpC3L73/5TbmN3ANR+wd0M19SYnPQHBSyI9XUUToxtpQ0p4FU0xJ/TQhx
         JJTCcItHCvcnWWLnt7gBE242elKLv6UafNPJKJFzy4ClNHeJfS9NftkREIkE2PfA8Zyz
         sk9FHWm6PBboN7TO1WNc09JcuSRboKeP3qZHh5+Ys+OYwMSqNVz+zMcUyq9LGvbJ8alX
         bkteOAChJaeRlgjeOF1F6XhnY5W3UpEo5RdKAOOm4v8UD8frazIxnPCPfl/tThi1wAqc
         5IYXBdWnbuNAad0ZKxUkk9Yfiiot+I+N6uq0p778kRWgn/SN02beGAsYr3//te7lW3xh
         TEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGGPvmrXsX671EomgZnTABC+ac2Q8+DxgwxuD22zii4=;
        b=lFdghBA/z1iRQwUBe8bsu0RmhqeS8ph3/aPAnPyrreWA3Mcw3UUwbxGSBtA+1R94Xf
         PzB+1Bb8gobdD0autymiJdi7cGFXIcYa6n/k9RIGDWGoRjjEcT+HCt4v9wmLYJkoEnUc
         crVkkia4p8Acq3+4lkarPa2Fv8Y6Psozz+OoBgBVQmn8142hRoen1TGD8BMTVzMKTx0b
         Nb5dW5astn6G2N6HoYTLPO+5LWrjIPbWdAyFX9M/vWsKItHca0OJckKQjB4Th91m6ULy
         pJ5xTPW5NIYny4OHr1KjyGg49HftoWUY0IExx7RwENeHoLS4lg1wlyXHNZNlGHXPDjo0
         37wQ==
X-Gm-Message-State: AOAM532/p5jdwwBz3JG0NH34jfgWG5Gl/5j+FDFARAOrYEHlrPNrbcJj
        9g1Yc7BSjM8bZgijFOqM8b3kuEVuB5cw2g==
X-Google-Smtp-Source: ABdhPJyzpXnMHZDht1jN0zG5Bhf+ZWnI89SFiAoXhTjhenZKb/Xx/fDgy3s8Pt9Nv1F7Vk/JAThJAw==
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr38011164ejc.1.1622698163461;
        Wed, 02 Jun 2021 22:29:23 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id hr23sm943291ejc.101.2021.06.02.22.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:29:23 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing v2 02/11] Add mkdirat test case
Date:   Thu,  3 Jun 2021 12:28:57 +0700
Message-Id: <20210603052906.2616489-3-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603052906.2616489-1-dkadashev@gmail.com>
References: <20210603052906.2616489-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The test is relative basic: tests only success, EEXISTS, ENOENT (no
parent dir).

Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 .gitignore    |   1 +
 test/Makefile |   2 +
 test/mkdir.c  | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+)
 create mode 100644 test/mkdir.c

diff --git a/.gitignore b/.gitignore
index 17ec415..a9ae5bb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -68,6 +68,7 @@
 /test/link-timeout
 /test/link_drain
 /test/madvise
+/test/mkdir
 /test/nop
 /test/nop-all-sizes
 /test/open-close
diff --git a/test/Makefile b/test/Makefile
index a312409..86437d5 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -65,6 +65,7 @@ test_targets += \
 	link-timeout \
 	link_drain \
 	madvise \
+	mkdir \
 	multicqes_drain \
 	nop \
 	nop-all-sizes \
@@ -202,6 +203,7 @@ test_srcs := \
 	link.c \
 	link_drain.c \
 	madvise.c \
+	mkdir.c \
 	multicqes_drain.c \
 	nop-all-sizes.c \
 	nop.c \
diff --git a/test/mkdir.c b/test/mkdir.c
new file mode 100644
index 0000000..c044652
--- /dev/null
+++ b/test/mkdir.c
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test io_uring mkdirat handling
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
+static int do_mkdirat(struct io_uring *ring, const char *fn)
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
+	io_uring_prep_mkdirat(sqe, AT_FDCWD, fn, 0700);
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
+static int stat_file(const char *fn)
+{
+	struct stat sb;
+
+	if (!stat(fn, &sb))
+		return 0;
+
+	return errno;
+}
+
+int main(int argc, char *argv[])
+{
+	static const char fn[] = "io_uring-mkdirat-test";
+	int ret;
+	struct io_uring ring;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = do_mkdirat(&ring, fn);
+	if (ret < 0) {
+		if (ret == -EBADF || ret == -EINVAL) {
+			fprintf(stdout, "mkdirat not supported, skipping\n");
+			goto out;
+		}
+		fprintf(stderr, "mkdirat: %s\n", strerror(-ret));
+		goto err;
+	} else if (ret) {
+		goto err;
+	}
+
+	if (stat_file(fn)) {
+		perror("stat");
+		goto err;
+	}
+
+	ret = do_mkdirat(&ring, fn);
+	if (ret != -EEXIST) {
+		fprintf(stderr, "do_mkdirat already exists failed: %d\n", ret);
+		goto err1;
+	}
+
+	ret = do_mkdirat(&ring, "surely/this/wont/exist");
+	if (ret != -ENOENT) {
+		fprintf(stderr, "do_mkdirat no parent failed: %d\n", ret);
+		goto err1;
+	}
+
+out:
+	unlinkat(AT_FDCWD, fn, AT_REMOVEDIR);
+	io_uring_queue_exit(&ring);
+	return 0;
+err1:
+	unlinkat(AT_FDCWD, fn, AT_REMOVEDIR);
+err:
+	io_uring_queue_exit(&ring);
+	return 1;
+}
-- 
2.30.2

