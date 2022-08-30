Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EA25A589B
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 02:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiH3A5H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 20:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiH3A5B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 20:57:01 -0400
Received: from linux.gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098D0883EF;
        Mon, 29 Aug 2022 17:56:58 -0700 (PDT)
Received: from localhost.localdomain (unknown [68.183.184.174])
        by linux.gnuweeb.org (Postfix) with ESMTPSA id 5BB45374EC4;
        Tue, 30 Aug 2022 00:56:55 +0000 (UTC)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 2/7] syscall: Add io_uring syscall functions
Date:   Tue, 30 Aug 2022 07:56:38 +0700
Message-Id: <20220830005122.885209-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830005122.885209-1-ammar.faizi@intel.com>
References: <20220830005122.885209-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

We have:

  man 2 io_uring_setup;
  man 2 io_uring_enter;
  man 2 io_uring_register;

Those entries say that io_uring syscall functions are declared in
`<linux/io_uring.h>`. But they don't actually exist and never existed.
This is causing confusion for people who read the manpage. Let's just
implement them in liburing so they exist.

This also allows the user to invoke io_uring syscalls directly instead
of using the full liburing provided setup.

v2:
  - Use consistent argument types.
  - Separate syscall declarations in liburing.h with a blank line.
  - Remove unused include in syscall.c.

Link: https://github.com/axboe/liburing/pull/646#issuecomment-1229639532
Reviewed-by: Caleb Sander <csander@purestorage.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/Makefile           |  2 +-
 src/include/liburing.h | 12 ++++++++++++
 src/liburing.map       |  4 ++++
 src/syscall.c          | 29 +++++++++++++++++++++++++++++
 4 files changed, 46 insertions(+), 1 deletion(-)
 create mode 100644 src/syscall.c

diff --git a/src/Makefile b/src/Makefile
index dad379d..73a98ba 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -32,7 +32,7 @@ endif
 
 all: $(all_targets)
 
-liburing_srcs := setup.c queue.c register.c
+liburing_srcs := setup.c queue.c register.c syscall.c
 
 ifeq ($(CONFIG_NOLIBC),y)
 	liburing_srcs += nolibc.c
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 66c5095..6e86847 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -203,6 +203,18 @@ int io_uring_register_notifications(struct io_uring *ring, unsigned nr,
 				    struct io_uring_notification_slot *slots);
 int io_uring_unregister_notifications(struct io_uring *ring);
 
+/*
+ * io_uring syscalls.
+ */
+int io_uring_enter(unsigned int fd, unsigned int to_submit,
+		   unsigned int min_complete, unsigned int flags, sigset_t *sig);
+int io_uring_enter2(unsigned int fd, unsigned int to_submit,
+		    unsigned int min_complete, unsigned int flags,
+		    sigset_t *sig, size_t sz);
+int io_uring_setup(unsigned int entries, struct io_uring_params *p);
+int io_uring_register(unsigned int fd, unsigned int opcode, const void *arg,
+		      unsigned int nr_args);
+
 /*
  * Helper for the peek/wait single cqe functions. Exported because of that,
  * but probably shouldn't be used directly in an application.
diff --git a/src/liburing.map b/src/liburing.map
index 7d8f143..8573dfc 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -62,4 +62,8 @@ LIBURING_2.3 {
 		io_uring_register_file_alloc_range;
 		io_uring_register_notifications;
 		io_uring_unregister_notifications;
+		io_uring_enter;
+		io_uring_enter2;
+		io_uring_setup;
+		io_uring_register;
 } LIBURING_2.2;
diff --git a/src/syscall.c b/src/syscall.c
new file mode 100644
index 0000000..2054d17
--- /dev/null
+++ b/src/syscall.c
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: MIT */
+
+#include "syscall.h"
+#include <liburing.h>
+
+int io_uring_enter(unsigned int fd, unsigned int to_submit,
+		   unsigned int min_complete, unsigned int flags, sigset_t *sig)
+{
+	return __sys_io_uring_enter(fd, to_submit, min_complete, flags, sig);
+}
+
+int io_uring_enter2(unsigned int fd, unsigned int to_submit,
+		    unsigned int min_complete, unsigned int flags,
+		    sigset_t *sig, size_t sz)
+{
+	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
+				     sz);
+}
+
+int io_uring_setup(unsigned int entries, struct io_uring_params *p)
+{
+	return __sys_io_uring_setup(entries, p);
+}
+
+int io_uring_register(unsigned int fd, unsigned int opcode, const void *arg,
+		      unsigned int nr_args)
+{
+	return __sys_io_uring_register(fd, opcode, arg, nr_args);
+}
-- 
Ammar Faizi

