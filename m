Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A05320CA40
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 21:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgF1T6g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 15:58:36 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36415 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1T6g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 15:58:36 -0400
Received: by mail-pf1-f196.google.com with SMTP id 207so6788451pfu.3
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 12:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mpSFLMmiikr7eEIZbxCFUVNoINE7Or/87VBtV4SC1FQ=;
        b=oAFfgt3b6yHwIaEV3CBNv3NsT1y931VnFrDaGrTblhxjURv2huRKg3GLBQEkkP94qP
         j75eodWgs1AG2/qVO7JOCqLBP40LMi8uUHWpusjcW5hQDN1hDlOs4KlUGzuuBz6UJKQW
         EcA3KkvKArFcnku7hmG6D0tIlgcvv07Yt65CWcSjLDgstKeT4dOB2y/f7ZXuaoFwSMGP
         2idqxDRIlguEk4iKaJ5mfPU45dr8e6++x2FeALS8lw8YwR/6JfDxBgdQhIXUL5M2PRQF
         d8g2vLU53XT9Te028YzBAk9uDH2VJ9At7HDwrQ42rI2nXx7iR/C0CBjfhzu+7umYRgmO
         AR1A==
X-Gm-Message-State: AOAM532ncsE5zet3ZWWbRi/A++6igiKo/0MM5bGSCVFx0/DmuQEyDLkv
        cz3VrTUH5I7trP83COa6ujbu/7Sc
X-Google-Smtp-Source: ABdhPJzKDdUKZ2JqM5y4WE7D5F89z4FYcOiOuW18RejtjZPsrkEnUrZ/2j/U5GKFM96XnLkExpDyrA==
X-Received: by 2002:a63:6741:: with SMTP id b62mr7411889pgc.58.1593374315905;
        Sun, 28 Jun 2020 12:58:35 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d37sm1349394pgd.18.2020.06.28.12.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:58:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH liburing 4/7] Add a C++ unit test
Date:   Sun, 28 Jun 2020 12:58:20 -0700
Message-Id: <20200628195823.18730-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195823.18730-1-bvanassche@acm.org>
References: <20200628195823.18730-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since the liburing header files support C++ compilers, add a C++ unit test.
This helps to verify C++ compatibility of the liburing header files.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 test/Makefile       | 12 ++++++++++++
 test/sq-full-cpp.cc | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)
 create mode 100644 test/sq-full-cpp.cc

diff --git a/test/Makefile b/test/Makefile
index e103296fabdd..c80ad421a938 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -8,6 +8,7 @@ XCFLAGS =
 override CFLAGS += -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare\
 	-D_GNU_SOURCE -D__SANE_USERSPACE_TYPES__ -L../src/ \
 	-I../src/include/ -include ../config-host.h
+CXXFLAGS += $(CFLAGS) -std=c++11
 
 all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register \
 	       io_uring_enter nop sq-full cq-full 35fa71a030ca-test \
@@ -36,11 +37,18 @@ ifdef CONFIG_HAVE_STATX
 all_targets += statx
 endif
 
+ifdef CONFIG_HAVE_CXX
+all_targets += sq-full-cpp
+endif
+
 all: $(all_targets)
 
 %: %.c
 	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $< -luring $(XCFLAGS)
 
+%: %.cc
+	$(QUIET_CC)$(CXX) $(CXXFLAGS) -o $@ $< -luring $(XCFLAGS)
+
 test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
 	io_uring_register.c io_uring_enter.c nop.c sq-full.c cq-full.c \
 	35fa71a030ca-test.c 917257daa0fe-test.c b19062a56726-test.c \
@@ -63,6 +71,10 @@ ifdef CONFIG_HAVE_STATX
 test_srcs += statx.c
 endif
 
+ifdef CONFIG_HAVE_CXX
+test_srcs += sq-full-cpp
+endif
+
 test_objs := $(patsubst %.c,%.ol,$(test_srcs))
 
 35fa71a030ca-test: XCFLAGS = -lpthread
diff --git a/test/sq-full-cpp.cc b/test/sq-full-cpp.cc
new file mode 100644
index 000000000000..ba400996e615
--- /dev/null
+++ b/test/sq-full-cpp.cc
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test SQ queue full condition
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+
+int main(int argc, char *argv[])
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int ret, i;
+
+	if (argc > 1)
+		return 0;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+
+	}
+
+	i = 0;
+	while ((sqe = io_uring_get_sqe(&ring)) != NULL)
+		i++;
+
+	if (i != 8) {
+		fprintf(stderr, "Got %d SQEs, wanted 8\n", i);
+		goto err;
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+err:
+	io_uring_queue_exit(&ring);
+	return 1;
+}
