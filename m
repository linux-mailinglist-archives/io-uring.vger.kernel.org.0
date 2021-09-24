Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EE7417B79
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344487AbhIXTJq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 15:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhIXTJq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 15:09:46 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1DBC061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:08:12 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v18so4543124edc.11
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0yu//2adI84qXJyu8Tlm8tizVoW5Hc90gPfWv7Tt61E=;
        b=FJFDj82aa3Aq8+xZrO14e2t8lqjrV30cFw4qPEftmONIObCV1s7e1E6aL8d6F6iAdg
         XSmIUidrnUpeoZPIsaxMj+wyoLhKkxoXGHkf3dESHr9IXkGvzQzQZukLuwfMx8F3Ajn5
         NcB+FZzkJfj1pfEMm3BjAhfO6v451ot/lnDVoTfTc9/zH/qPdWZAeNf3zEGWkgx3jZgh
         ZbQEHn65Hw6QRmnIhKJFYJ7p24Fn7epGPUe3eFJJrHviUECzheUPhlcIdnTw13y/etlN
         EsIYjdcX5okiEhrGMNLzBzeQDA5/X53uAuPR58uUGmzigYQupNxEE/FP/8v8nccizAQG
         NsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0yu//2adI84qXJyu8Tlm8tizVoW5Hc90gPfWv7Tt61E=;
        b=GdZDUB3W7Hh7ThsoTqQA8V7uuM2cgd7znZ8wlLjUeD7i0/51Aacmx3ktwzNcKvvy+R
         Y2yMcPb8wNHjVgK6WbJTDirBS/IaPfRIe3XA3203a8owk9R/EYkHw1WfKZ+FucpVFL9/
         AZ4+0dDqrecNY88kbVk2UZ7SgAuGyOn06FLdkBUNpPmT6jmzRfQ5JC9CWrYW61pQUlm3
         iVxFFPa4JjIF6q9gXPlv0ZZLRx57vxLKOnfN1B/6Sn76BIZ5kixs8PuSAtMltGthOb5U
         H++ya96ZAZ+KjuSdm7ffGJxOm14tjXR96ztn+24a2n+HTd1KQiA/JCvbjNAGoODNyv1Q
         FhlQ==
X-Gm-Message-State: AOAM533Y83ErmMfssJ1AwicsArBdCHbFUoy6wrcxcx0FMfcsxaFuSRMu
        obQJeD8GmdE5ZkGdZLEoLEdfAd0Juc8=
X-Google-Smtp-Source: ABdhPJxmEK9HUvLTmYu6Qm4NZ3JxYj5UpYB4/wh5EJISkitE3z0mRXkuwdKdHaV4e+58wtB+QvgkTQ==
X-Received: by 2002:a50:9b17:: with SMTP id o23mr7036276edi.341.1632510491400;
        Fri, 24 Sep 2021 12:08:11 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id m22sm6265511edq.71.2021.09.24.12.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 12:08:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: test close with fixed file table
Date:   Fri, 24 Sep 2021 20:07:30 +0100
Message-Id: <5e22cfaf9f0f513574a098dba6548cbb4fb5e2d8.1632510387.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test IO_CLOSE closing files in the fixed file table.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

P.S. not tested with kernels not supporting the feature

 test/open-close.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/test/open-close.c b/test/open-close.c
index 648737c..d5c116b 100644
--- a/test/open-close.c
+++ b/test/open-close.c
@@ -9,10 +9,119 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
+#include <assert.h>
 
 #include "helpers.h"
 #include "liburing.h"
 
+static int submit_wait(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return 1;
+	}
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		return 1;
+	}
+
+	ret = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return ret;
+}
+
+static inline int try_close(struct io_uring *ring, int fd, int slot)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_close(sqe, fd);
+	__io_uring_set_target_fixed_file(sqe, slot);
+	return submit_wait(ring);
+}
+
+static int test_close_fixed(void)
+{
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	int ret, fds[2];
+	char buf[1];
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return -1;
+	}
+	if (pipe(fds)) {
+		perror("pipe");
+		return -1;
+	}
+
+	ret = try_close(&ring, 0, 0);
+	if (ret == -EINVAL) {
+		fprintf(stderr, "close for fixed files is not supported\n");
+		return 0;
+	} else if (ret != -ENXIO) {
+		fprintf(stderr, "no table failed %i\n", ret);
+		return -1;
+	}
+
+	ret = try_close(&ring, 1, 0);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "set fd failed %i\n", ret);
+		return -1;
+	}
+
+	ret = io_uring_register_files(&ring, fds, 2);
+	if (ret) {
+		fprintf(stderr, "file_register: %d\n", ret);
+		return ret;
+	}
+
+	ret = try_close(&ring, 0, 2);
+	if (ret != -EINVAL) {
+		fprintf(stderr, "out of table failed %i\n", ret);
+		return -1;
+	}
+
+	ret = try_close(&ring, 0, 0);
+	if (ret != 0) {
+		fprintf(stderr, "close failed %i\n", ret);
+		return -1;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read(sqe, 0, buf, sizeof(buf), 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+	ret = submit_wait(&ring);
+	if (ret != -EBADF) {
+		fprintf(stderr, "read failed %i\n", ret);
+		return -1;
+	}
+
+	ret = try_close(&ring, 0, 1);
+	if (ret != 0) {
+		fprintf(stderr, "close 2 failed %i\n", ret);
+		return -1;
+	}
+
+	ret = try_close(&ring, 0, 0);
+	if (ret != -EBADF) {
+		fprintf(stderr, "empty slot failed %i\n", ret);
+		return -1;
+	}
+
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 static int test_close(struct io_uring *ring, int fd, int is_ring_fd)
 {
 	struct io_uring_cqe *cqe;
@@ -133,6 +242,12 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
+	ret = test_close_fixed();
+	if (ret) {
+		fprintf(stderr, "test_close_fixed failed\n");
+		goto err;
+	}
+
 done:
 	unlink(path);
 	if (do_unlink)
-- 
2.33.0

