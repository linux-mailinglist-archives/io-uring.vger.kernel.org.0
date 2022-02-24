Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556634C38B4
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 23:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiBXWZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 17:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiBXWZc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 17:25:32 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE76624776C
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 14:25:01 -0800 (PST)
Received: from integral2.. (unknown [36.78.50.60])
        by gnuweeb.org (Postfix) with ESMTPSA id ECC467E292;
        Thu, 24 Feb 2022 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1645741501;
        bh=6vctS5iYH0YyIX2EePWweCYuhNIlTlk1uUwKmBJaHlA=;
        h=From:To:Cc:Subject:Date:From;
        b=bM+8fB0UkQqCju7XlkdcKMEi24KR6u1yp/9TxwhoXkHY51aJzVi2qvC6hdqaXzXqO
         6nrLjh7nBO0xSxXjYirmHP6b3jCTvy/a99zF+EM8ajJZudOzubS1GBG4JD8lcHQr+K
         mPWrMO11jKeyQC6pEJWH9vf12YEXq1xDEHNQFLO8tftY8vBsVfWK33GBcVc0ObNfGb
         0stzavrx97OKW14prGeA98aQ2J7ushuDqzAfNhT7P6MZ25s6NUQQgaFSKYcq2DbP7n
         in93igPIBnWkOqKrp64yQC1L/Zuk4Jd6LJIo66qYWAr4TCgXdZolUxbcsyQAREkfde
         l//88G8GIplrQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Nugra <richiisei@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1] src/Makefile: Don't use stack protector for all builds by default
Date:   Fri, 25 Feb 2022 05:24:27 +0700
Message-Id: <20220224222427.66206-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
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

Stack protector adds extra mov, extra stack allocation and extra branch
to save and validate the stack canary. While this feature could be
useful to detect stack corruption in some scenarios, it is not really
needed for liburing which is simple enough to review.

Good code shouldn't corrupt the stack. We don't need this extra
checking at the moment. Just for comparison, let's take a hot function
__io_uring_get_cqe.

Before this patch:
```
0000000000002b80 <__io_uring_get_cqe>:
  2b80:   f3 0f 1e fa             endbr64
  2b84:   48 83 ec 28             sub    $0x28,%rsp
  2b88:   64 48 8b 04 25 28 00    mov    %fs:0x28,%rax
  2b8f:   00 00
  2b91:   48 89 44 24 18          mov    %rax,0x18(%rsp)
  2b96:   31 c0                   xor    %eax,%eax
  2b98:   89 14 24                mov    %edx,(%rsp)
  2b9b:   48 89 e2                mov    %rsp,%rdx
  2b9e:   48 b8 00 00 00 00 08    movabs $0x800000000,%rax
  2ba5:   00 00 00
  2ba8:   89 4c 24 04             mov    %ecx,0x4(%rsp)
  2bac:   48 89 44 24 08          mov    %rax,0x8(%rsp)
  2bb1:   4c 89 44 24 10          mov    %r8,0x10(%rsp)
  2bb6:   e8 45 fe ff ff          call   2a00 <_io_uring_get_cqe>
  2bbb:   48 8b 54 24 18          mov    0x18(%rsp),%rdx
  2bc0:   64 48 2b 14 25 28 00    sub    %fs:0x28,%rdx
  2bc7:   00 00
  2bc9:   75 05                   jne    2bd0 <__io_uring_get_cqe+0x50>
  2bcb:   48 83 c4 28             add    $0x28,%rsp
  2bcf:   c3                      ret
  2bd0:   e8 9b f5 ff ff          call   2170 <__stack_chk_fail@plt>
  2bd5:   66 66 2e 0f 1f 84 00    data16 cs nopw 0x0(%rax,%rax,1)
  2bdc:   00 00 00 00
```

After this patch:
```
0000000000002ab0 <__io_uring_get_cqe>:
  2ab0:   f3 0f 1e fa             endbr64
  2ab4:   48 b8 00 00 00 00 08    movabs $0x800000000,%rax
  2abb:   00 00 00
  2abe:   48 83 ec 28             sub    $0x28,%rsp
  2ac2:   89 14 24                mov    %edx,(%rsp)
  2ac5:   48 89 e2                mov    %rsp,%rdx
  2ac8:   89 4c 24 04             mov    %ecx,0x4(%rsp)
  2acc:   48 89 44 24 08          mov    %rax,0x8(%rsp)
  2ad1:   4c 89 44 24 10          mov    %r8,0x10(%rsp)
  2ad6:   e8 55 fe ff ff          call   2930 <_io_uring_get_cqe>
  2adb:   48 83 c4 28             add    $0x28,%rsp
  2adf:   c3                      ret
```

Previously, we only use `-fno-stack-protector` for nolibc build as the
stack protector needs to call `__stack_chk_fail@plt` function from the
libc. Now, we always use `-fno-stack-protector` for both nolibc and
libc builds to generate shorter Assembly code.

Cc: Nugra <richiisei@gmail.com>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc: GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Cc: Tea Inside Mailing List <timl@vger.teainside.org>
Cc: io-uring Mailing List <io-uring@vger.kernel.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index cc6c871..3e1192f 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -8,7 +8,7 @@ libdevdir ?= $(prefix)/lib
 CPPFLAGS ?=
 override CPPFLAGS += -D_GNU_SOURCE \
 	-Iinclude/ -include ../config-host.h
-CFLAGS ?= -g -fomit-frame-pointer -O2 -Wall -Wextra
+CFLAGS ?= -g -fomit-frame-pointer -O2 -Wall -Wextra -fno-stack-protector
 override CFLAGS += -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL
 SO_CFLAGS=-fPIC $(CFLAGS)
 L_CFLAGS=$(CFLAGS)
@@ -36,8 +36,8 @@ liburing_srcs := setup.c queue.c register.c
 
 ifeq ($(CONFIG_NOLIBC),y)
 	liburing_srcs += nolibc.c
-	override CFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-stack-protector
-	override CPPFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-stack-protector
+	override CFLAGS += -nostdlib -nodefaultlibs -ffreestanding
+	override CPPFLAGS += -nostdlib -nodefaultlibs -ffreestanding
 	override LINK_FLAGS += -nostdlib -nodefaultlibs
 else
 	liburing_srcs += syscall.c

base-commit: 896a1d3ab14a8777a45db6e7b67cf557a44923fb
-- 
2.32.0

