Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2AC53E3AB
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiFFGM4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiFFGMx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:12:53 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CBC18B2E
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:12:49 -0700 (PDT)
Received: from integral2.. (unknown [36.73.79.120])
        by gnuweeb.org (Postfix) with ESMTPSA id B95147E583;
        Mon,  6 Jun 2022 06:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1654495968;
        bh=NpXbzefATnYVVKP3TUgeub8VK+12T8oHEB9/5rBxbvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIXZqGn1yrFvcjncYqtIfdUq7Mt3yevC0pKn0OWVaIdmuo7t9PmYibddJlnaQNObi
         /Hfv1CvFzUPcx8zSoGqVL3a/Dueo99fB+vza7ve3pESyW49w5Ozd1diAV1FqyRJ4UY
         ef1WbFm/4+OT1tNZbP7YmHgXyPEoUfMthv2/iwOlqpCi5vnluPz8UYZ13KrtadBsO/
         rXwQG9wSE6Zak8b8R83ZCN9fcUkfM0NBu8d/TEwSl4/P/bE8FxhbnkvjdNzdwER75I
         jsYIYfMA7azRvNyGD96WRY5/GQ+jFTw2ibYAhErGOgPoul0kRqoezB2PHil/ay/dxa
         Tavz8AVsy9TKg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH v1 5/5] Add io_uring data structure build assertion
Date:   Mon,  6 Jun 2022 13:12:09 +0700
Message-Id: <20220606061209.335709-6-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220606061209.335709-1-ammarfaizi2@gnuweeb.org>
References: <20220606061209.335709-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ensure io_uring data structure consistent between the kernel and user
space. These assertions are taken from io_uring.c in the kernel.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/Makefile       |  3 ++-
 src/build_assert.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 1 deletion(-)
 create mode 100644 src/build_assert.h

diff --git a/src/Makefile b/src/Makefile
index 12cf49f..aed3c40 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -7,7 +7,8 @@ libdevdir ?= $(prefix)/lib
 
 CPPFLAGS ?=
 override CPPFLAGS += -D_GNU_SOURCE \
-	-Iinclude/ -include ../config-host.h
+	-Iinclude/ -include ../config-host.h \
+	-include build_assert.h
 CFLAGS ?= -g -O2 -Wall -Wextra -fno-stack-protector
 override CFLAGS += -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL
 SO_CFLAGS=-fPIC $(CFLAGS)
diff --git a/src/build_assert.h b/src/build_assert.h
new file mode 100644
index 0000000..5b2a9c6
--- /dev/null
+++ b/src/build_assert.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: MIT */
+
+#ifndef LIBURING_BUILD_ASSERT_H
+#define LIBURING_BUILD_ASSERT_H
+
+#include "liburing/io_uring.h"
+#include "lib.h"
+
+static inline __attribute__((__unused__)) void io_uring_build_assert(void)
+{
+#define __BUILD_BUG_VERIFY_ELEMENT(stype, eoffset, etype, ename) do { \
+	BUILD_BUG_ON(offsetof(stype, ename) != eoffset); \
+	BUILD_BUG_ON(sizeof(etype) != sizeof_field(stype, ename)); \
+} while (0)
+
+#define BUILD_BUG_SQE_ELEM(eoffset, etype, ename) \
+	__BUILD_BUG_VERIFY_ELEMENT(struct io_uring_sqe, eoffset, etype, ename)
+	BUILD_BUG_ON(sizeof(struct io_uring_sqe) != 64);
+	BUILD_BUG_SQE_ELEM(0,  __u8,   opcode);
+	BUILD_BUG_SQE_ELEM(1,  __u8,   flags);
+	BUILD_BUG_SQE_ELEM(2,  __u16,  ioprio);
+	BUILD_BUG_SQE_ELEM(4,  __s32,  fd);
+	BUILD_BUG_SQE_ELEM(8,  __u64,  off);
+	BUILD_BUG_SQE_ELEM(8,  __u64,  addr2);
+	BUILD_BUG_SQE_ELEM(16, __u64,  addr);
+	BUILD_BUG_SQE_ELEM(16, __u64,  splice_off_in);
+	BUILD_BUG_SQE_ELEM(24, __u32,  len);
+	BUILD_BUG_SQE_ELEM(28,     __kernel_rwf_t, rw_flags);
+	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
+	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
+	BUILD_BUG_SQE_ELEM(28, /* compat */ __u16,  poll_events);
+	BUILD_BUG_SQE_ELEM(28, __u32,  poll32_events);
+	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  accept_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  cancel_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  open_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  statx_flags);
+	BUILD_BUG_SQE_ELEM(28, __u32,  fadvise_advice);
+	BUILD_BUG_SQE_ELEM(28, __u32,  splice_flags);
+	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
+	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
+	BUILD_BUG_SQE_ELEM(40, __u16,  buf_group);
+	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
+	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
+	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
+	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
+
+	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
+		     sizeof(struct io_uring_rsrc_update));
+	BUILD_BUG_ON(sizeof(struct io_uring_rsrc_update) >
+		     sizeof(struct io_uring_rsrc_update2));
+}
+
+#endif
-- 
Ammar Faizi

