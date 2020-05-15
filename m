Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5251D5667
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgEOQoF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:44:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25762 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726212AbgEOQoE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589561043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CkOvvG2F5gpwkIYhJqk6+XiHdLz1yGtGRt8qIyN2fEU=;
        b=g0N/jdzP/51xCMsdnFnpZsQ/16yVi0OJpr8Le41MorvSxIelLPnWb5mLlS5+IGg1854qRH
        tRk2Sj2yXPMt9mAocTZ80tHTZTiE/Ahs9lFTqZ8+l2dGwo3+khblEPscBCfCL4dZCDT8af
        Y52TbtYNEqbp6wBK6V0/qBmUTJ5bw84=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-NpiscRK_PLayyRy9U4Z0Aw-1; Fri, 15 May 2020 12:44:00 -0400
X-MC-Unique: NpiscRK_PLayyRy9U4Z0Aw-1
Received: by mail-wm1-f70.google.com with SMTP id o8so686724wmd.0
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CkOvvG2F5gpwkIYhJqk6+XiHdLz1yGtGRt8qIyN2fEU=;
        b=TE+zh59ZPholMMhRW5mrZQep08JoyyvNZvJCCAEOwa0zNu9qs1PSVbm1nXUFhnppK0
         uX6XELu00taL52bRNNntPbVt/4DRvJbzXlZxfapjajww4/O80nTs/oUJXO0ikqmRI8lg
         jMrUmNHAhzfyvBjYia75oVOQ+SHMGSMVsLQs+HzPWe+IC65YJ3Cp4o8BGAukAThWjPbG
         9Xv3ZT7xHj+nLDEVoB+XNmLyvwfvLNmsgKFhnGhRsSajTSSBzn3apzPpbBffOpstI+dG
         G2vCSCUlyr0ppux2TVMYsq8Zy8qXpZaBI07u9CuxhopDX9bbXPJi3+iYGYQ/tNnvzWTJ
         8okA==
X-Gm-Message-State: AOAM530Yi6iOludvn7CxCoh7Jxy8rZLGyk58kCY7D9oxyv5GOc5vaEyN
        fRM9cQSrdK42mX1lkc8yQoC3RO+qH2p40j/1zc6wmAUTCkophBpvSsbFN3nF9ZChpB/18uaeIVM
        uKT3zj7m6sj+Y6GG3Scs=
X-Received: by 2002:adf:dfc6:: with SMTP id q6mr5470139wrn.217.1589561039329;
        Fri, 15 May 2020 09:43:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK51bvhCsbnoQLseIFbRTa/XSbiJuxxnbRPUQAHmudE75PdRFddFK58cfO0V72TXxaStrYig==
X-Received: by 2002:adf:dfc6:: with SMTP id q6mr5470122wrn.217.1589561039096;
        Fri, 15 May 2020 09:43:59 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id k131sm4678790wma.2.2020.05.15.09.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:43:58 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 5/5] Add test/eventfd-disable.c test case
Date:   Fri, 15 May 2020 18:43:31 +0200
Message-Id: <20200515164331.236868-6-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515164331.236868-1-sgarzare@redhat.com>
References: <20200515164331.236868-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This new test checks if the mechanism to enable/disable notifications
through eventfd when a request is completed works correctly.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 .gitignore             |   1 +
 test/Makefile          |   4 +-
 test/eventfd-disable.c | 148 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 151 insertions(+), 2 deletions(-)
 create mode 100644 test/eventfd-disable.c

diff --git a/.gitignore b/.gitignore
index 9784f0b..7f01e6e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -40,6 +40,7 @@
 /test/defer
 /test/eeed8b54e0df-test
 /test/eventfd
+/test/eventfd-disable
 /test/eventfd-ring
 /test/fadvise
 /test/fallocate
diff --git a/test/Makefile b/test/Makefile
index ff4d4b8..a46e45d 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -21,7 +21,7 @@ all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register
 		file-update accept-reuse poll-v-poll fadvise madvise \
 		short-read openat2 probe shared-wq personality eventfd \
 		send_recv eventfd-ring across-fork sq-poll-kthread splice \
-		lfs-openat lfs-openat-write
+		lfs-openat lfs-openat-write eventfd-disable
 
 include ../Makefile.quiet
 
@@ -53,7 +53,7 @@ test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
 	file-update.c accept-reuse.c poll-v-poll.c fadvise.c \
 	madvise.c short-read.c openat2.c probe.c shared-wq.c \
 	personality.c eventfd.c eventfd-ring.c across-fork.c sq-poll-kthread.c \
-	splice.c lfs-openat.c lfs-openat-write.c
+	splice.c lfs-openat.c lfs-openat-write.c eventfd-disable.c
 
 ifdef CONFIG_HAVE_STATX
 test_srcs += statx.c
diff --git a/test/eventfd-disable.c b/test/eventfd-disable.c
new file mode 100644
index 0000000..d4fb14e
--- /dev/null
+++ b/test/eventfd-disable.c
@@ -0,0 +1,148 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test disable/enable notifications through eventfd
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/poll.h>
+#include <sys/eventfd.h>
+
+#include "liburing.h"
+
+int main(int argc, char *argv[])
+{
+	struct io_uring_params p = {};
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	uint64_t ptr;
+	struct iovec vec = {
+		.iov_base = &ptr,
+		.iov_len = sizeof(ptr)
+	};
+	int ret, evfd, i;
+
+	ret = io_uring_queue_init_params(64, &ring, &p);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	evfd = eventfd(0, EFD_CLOEXEC);
+	if (evfd < 0) {
+		perror("eventfd");
+		return 1;
+	}
+
+	ret = io_uring_register_eventfd(&ring, evfd);
+	if (ret) {
+		fprintf(stderr, "failed to register evfd: %d\n", ret);
+		return 1;
+	}
+
+	if (!io_uring_cq_eventfd_enabled(&ring)) {
+		fprintf(stderr, "eventfd disabled\n");
+		return 1;
+	}
+
+	ret = io_uring_cq_eventfd_enable(&ring, false);
+	if (ret) {
+		fprintf(stdout, "Skipping, CQ flags not available!\n");
+		return 0;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_readv(sqe, evfd, &vec, 1, 0);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < 63; i++) {
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_nop(sqe);
+		sqe->user_data = 2;
+	}
+
+	ret = io_uring_submit(&ring);
+	if (ret != 63) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < 63; i++) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait: %d\n", ret);
+			return 1;
+		}
+
+		switch (cqe->user_data) {
+		case 1: /* eventfd */
+			fprintf(stderr, "eventfd unexpected: %d\n", (int)ptr);
+			return 1;
+		case 2:
+			if (cqe->res) {
+				fprintf(stderr, "nop: %d\n", cqe->res);
+				return 1;
+			}
+			break;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	ret = io_uring_cq_eventfd_enable(&ring, true);
+	if (ret) {
+		fprintf(stderr, "io_uring_cq_eventfd_enable: %d\n", ret);
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit: %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait: %d\n", ret);
+			return 1;
+		}
+
+		switch (cqe->user_data) {
+		case 1: /* eventfd */
+			if (cqe->res != sizeof(ptr)) {
+				fprintf(stderr, "read res: %d\n", cqe->res);
+				return 1;
+			}
+
+			if (ptr != 1) {
+				fprintf(stderr, "eventfd: %d\n", (int)ptr);
+				return 1;
+			}
+			break;
+		case 2:
+			if (cqe->res) {
+				fprintf(stderr, "nop: %d\n", cqe->res);
+				return 1;
+			}
+			break;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	return 0;
+}
-- 
2.25.4

