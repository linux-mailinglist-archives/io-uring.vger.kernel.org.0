Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384365A414D
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 05:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiH2DIS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Aug 2022 23:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiH2DIP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Aug 2022 23:08:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F3E3DF30;
        Sun, 28 Aug 2022 20:08:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.68.216])
        by gnuweeb.org (Postfix) with ESMTPSA id 1127A80B16;
        Mon, 29 Aug 2022 03:07:52 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661742475;
        bh=VlX7C/9ehX4QyKg5QD8GEmv081Be7gwIp1s3dgH//yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o64f1A3MlidJp35tF/cMKXgBgL2Vaj5V4SWmqMedI8qKaUwtkxe8EEDT4eXLeVchY
         bGw7WbvnfxZGNHdeepaHpkmHoU5QZPFJ6kSr5yAoozKYZgTnnS/iCRj2adDq0RMtkj
         /Sdd9eGMdDUyYWefiEnASTHCX8F9dod+1sD/SerSgiOhAaFZyCjpOREZqviy3kMHb0
         gpE3dK3UR3e4/tHmIo6wgp54iZQ048dXNBpurBzN34WHDQk/M8mgeO2b9n0zoXgQwC
         IMS/fOOJI7BEEE3/NSedv5J720kYdxypGok4OQSDRuKN98Z6Bs8DTL9CD7D/TBhtWQ
         RbBEslJiy9enA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 1/4] syscall: Add io_uring syscall functions
Date:   Mon, 29 Aug 2022 10:07:36 +0700
Message-Id: <20220829030521.3373516-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220829030521.3373516-1-ammar.faizi@intel.com>
References: <20220829030521.3373516-1-ammar.faizi@intel.com>
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

Link: https://github.com/axboe/liburing/pull/646#issuecomment-1229639532
Cc: Caleb Sander <csander@purestorage.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/Makefile           |  2 +-
 src/include/liburing.h |  8 ++++++++
 src/liburing.map       |  4 ++++
 src/syscall.c          | 30 ++++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 1 deletion(-)
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
index 66c5095..7db1ea9 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -202,6 +202,14 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 int io_uring_register_notifications(struct io_uring *ring, unsigned nr,
 				    struct io_uring_notification_slot *slots);
 int io_uring_unregister_notifications(struct io_uring *ring);
+int io_uring_enter(unsigned int fd, unsigned int to_submit,
+		   unsigned int min_complete, unsigned int flags,
+		   sigset_t *sig);
+int io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
+		    unsigned flags, sigset_t *sig, int sz);
+int io_uring_setup(unsigned entries, struct io_uring_params *p);
+int io_uring_register(int fd, unsigned opcode, const void *arg,
+		      unsigned nr_args);
 
 /*
  * Helper for the peek/wait single cqe functions. Exported because of that,
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
index 0000000..fcc6808
--- /dev/null
+++ b/src/syscall.c
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: MIT */
+
+#include "lib.h"
+#include "syscall.h"
+#include <liburing.h>
+
+int io_uring_enter(unsigned int fd, unsigned int to_submit,
+		   unsigned int min_complete, unsigned int flags,
+		   sigset_t *sig)
+{
+	return __sys_io_uring_enter(fd, to_submit, min_complete, flags, sig);
+}
+
+int io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
+		    unsigned flags, sigset_t *sig, int sz)
+{
+	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
+				     sz);
+}
+
+int io_uring_setup(unsigned entries, struct io_uring_params *p)
+{
+	return __sys_io_uring_setup(entries, p);
+}
+
+int io_uring_register(int fd, unsigned opcode, const void *arg,
+		      unsigned nr_args)
+{
+	return __sys_io_uring_register(fd, opcode, arg, nr_args);
+}
-- 
Ammar Faizi

