Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9612B3C56
	for <lists+io-uring@lfdr.de>; Mon, 16 Nov 2020 06:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgKPFKe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 00:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKPFKd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 00:10:33 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E13C0613CF
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 21:10:33 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id e139so3940337lfd.1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 21:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xp3eGa/RFeg2sw+iealbDspCj30fx9K0fYpy/y+qAbE=;
        b=kWtxPHJWApySgFEexcXxsY6PjgFu6ptJKcAWgD1Fxs7+Bu7ad95Bz4IIa9KX5oH0pm
         +j34dK5gs3NYz2y1G+ISb5pjLM1yHTequjL3aMY0/y0U5Od8C23UGNGm6fNBE+7Q0qUC
         BkN49zAtzkgBaH06RYpwLau5MCGYpR1Le2gBoDUTn7e45YROFknrFJ4y1RDHbO9Cq8Pm
         IEErV1UMDsEtdJ5NXets3JblvrOldE3TQuRSSbDe17bfelRLMaRfp5KwbEv75QHU4KC7
         rOlejZyG8OkRhXnrWq4Blhk5g+Ri6RxidAXB46VkXJPHkVdg3srsvoGJyNCs9wtrR0XE
         i/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xp3eGa/RFeg2sw+iealbDspCj30fx9K0fYpy/y+qAbE=;
        b=ZZWzj1TVA79dH7PO7gHdOD3yi96mDMJ5eqaG5FE+IptkF80wHWGFno2PvAEPz4qGWO
         cLh3Vmr2KTuDBYSE3lZmu1W7EEkDxh7W6taJk6NR8KKu/7w1yxm2yV6zLwpq1byAU+i8
         ssPlUJ6sF+Cj7UNjCA6vSCZCOeJBzf95ykww+6AAJ69lYoYc++5FXrnC/wZ9xjJhSsVC
         ux+atazw6yh5irZwjTk0SpDI8chkWahhb8vJrKm4ABjRkI0LIELDG7rO2pdxiXZiO+27
         vq85ZsAi+LcU6tuZzjFXr/81qY6XTtMCP69zkYzBax/OGTUBxDznNfuBwM1CBsw9ZjEX
         qIiA==
X-Gm-Message-State: AOAM533PmKgfla3FRj/Z9/XBedX755+ecmlDaSgVBSXxxo1gn7Fk15uy
        3zpnaA7mE5PWTMkA7Y3hA8n6V1MtWLIH1A==
X-Google-Smtp-Source: ABdhPJzbh6e1pklr64dPCyK2OzIoYzDImRb8ftasHLZYNFAH/ZN/ciAl1XoWJnMAP3z9uDN/BFoymw==
X-Received: by 2002:ac2:52b2:: with SMTP id r18mr4552657lfm.50.1605503431674;
        Sun, 15 Nov 2020 21:10:31 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id b79sm2595909lfg.243.2020.11.15.21.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 21:10:31 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH liburing 3/3] Add mkdirat test case
Date:   Mon, 16 Nov 2020 12:10:05 +0700
Message-Id: <20201116051005.1100302-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116051005.1100302-1-dkadashev@gmail.com>
References: <20201116051005.1100302-1-dkadashev@gmail.com>
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
index 53c076f..0a49dad 100644
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
index f457ac7..718bca9 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -66,6 +66,7 @@ test_targets += \
 	link-timeout \
 	link_drain \
 	madvise \
+	mkdir \
 	nop \
 	nop-all-sizes \
 	open-close \
@@ -186,6 +187,7 @@ test_srcs := \
 	link.c \
 	link_drain.c \
 	madvise.c \
+	mkdir.c \
 	nop-all-sizes.c \
 	nop.c \
 	open-close.c \
diff --git a/test/mkdir.c b/test/mkdir.c
new file mode 100644
index 0000000..88bb9b6
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
+static int test_mkdirat(struct io_uring *ring, const char *fn)
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
+static int stat_file(const char *buf)
+{
+	struct stat sb;
+
+	if (!stat(buf, &sb))
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
+	ret = test_mkdirat(&ring, fn);
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
+	ret = test_mkdirat(&ring, fn);
+	if (ret != -EEXIST) {
+		fprintf(stderr, "test_mkdirat already exists failed: %d\n", ret);
+		goto err1;
+	}
+
+	ret = test_mkdirat(&ring, "surely/this/wont/exist");
+	if (ret != -ENOENT) {
+		fprintf(stderr, "test_mkdirat no parent failed: %d\n", ret);
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
2.29.2

