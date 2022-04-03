Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEFF4F0AB4
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 17:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbiDCPlC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 11:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359188AbiDCPlC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 11:41:02 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7E126E3
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 08:39:07 -0700 (PDT)
Received: from integral2.. (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id 226397E346;
        Sun,  3 Apr 2022 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649000347;
        bh=WCTCUhv28n9R2WxBQKHCsannOMLh1r6SzF/qcfWoNps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZikLOYumy7d5XTLoHe1/jA6YXBqsb8mwTu0XlASlKi9TUwIIB5xneneSt9CsW8zb
         7SmePPzs46y45MUYa0G5MiLfFR1AaYlcp+N7KEvy/dDOumvtDnf6qrDn8oN4AAN33U
         MTaGLX3yRevnQQbgeYX9VH+5Y8XEWe0LjLo4u0RjRV1QuKhQKcCJMT4w5g5Hk72SLI
         wn1IzElFQBWKT9nf/nCA5BeFN1+qJa6JPgFvxkt2jGWaW35wsnGZZsHP/2jpwvR6VP
         hN3wiwiREOwOKMyNNKlLaYC3jingRXkQhwL9fU8TviYeBUQm5ZEp+Uo56qhuuySQHD
         GfCQ8JiH0Zu3A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing 2/2] test/Makefile: Append `.test` to the test binary filename
Date:   Sun,  3 Apr 2022 22:38:49 +0700
Message-Id: <20220403153849.176502-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220403153849.176502-1-ammarfaizi2@gnuweeb.org>
References: <20220403153849.176502-1-ammarfaizi2@gnuweeb.org>
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

When adding a new test, we often forget to add the new test binary to
`.gitignore`. Append `.test` to the test binary filename, this way we
can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
test binary files.

Goals:
  - Make the .gitignore simpler.
  - Avoid the burden of adding a new test to .gitignore.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .gitignore    | 132 +-------------------------------------------------
 test/Makefile |   8 +--
 2 files changed, 6 insertions(+), 134 deletions(-)

diff --git a/.gitignore b/.gitignore
index 4a6e585..0b0add0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,137 +15,7 @@
 /examples/io_uring-test
 /examples/link-cp
 /examples/ucontext-cp
-
-/test/232c93d07b74-test
-/test/35fa71a030ca-test
-/test/500f9fbadef8-test
-/test/7ad0e4b2f83c-test
-/test/8a9973408177-test
-/test/917257daa0fe-test
-/test/a0908ae19763-test
-/test/a4c0b3decb33-test
-/test/accept
-/test/accept-link
-/test/accept-reuse
-/test/accept-test
-/test/across-fork
-/test/b19062a56726-test
-/test/b5837bd5311d-test
-/test/ce593a6c480a-test
-/test/close-opath
-/test/config.local
-/test/connect
-/test/cq-full
-/test/cq-overflow
-/test/cq-overflow-peek
-/test/cq-peek-batch
-/test/cq-ready
-/test/cq-size
-/test/d4ae271dfaae-test
-/test/d77a67ed5f27-test
-/test/defer
-/test/double-poll-crash
-/test/drop-submit
-/test/eeed8b54e0df-test
-/test/empty-eownerdead
-/test/eventfd
-/test/eventfd-disable
-/test/eventfd-reg
-/test/eventfd-ring
-/test/exit-no-cleanup
-/test/fadvise
-/test/fallocate
-/test/fc2a85cb02ef-test
-/test/file-register
-/test/file-update
-/test/file-verify
-/test/files-exit-hang-poll
-/test/files-exit-hang-timeout
-/test/fixed-buf-iter
-/test/fixed-link
-/test/fixed-reuse
-/test/fpos
-/test/fsync
-/test/hardlink
-/test/io-cancel
-/test/io_uring_enter
-/test/io_uring_register
-/test/io_uring_setup
-/test/iopoll
-/test/lfs-openat
-/test/lfs-openat-write
-/test/link
-/test/link-timeout
-/test/link_drain
-/test/madvise
-/test/mkdir
-/test/msg-ring
-/test/nop
-/test/nop-all-sizes
-/test/open-close
-/test/open-direct-link
-/test/openat2
-/test/personality
-/test/pipe-eof
-/test/pipe-reuse
-/test/poll
-/test/poll-cancel
-/test/poll-cancel-ton
-/test/poll-link
-/test/poll-many
-/test/poll-ring
-/test/poll-v-poll
-/test/pollfree
-/test/probe
-/test/read-write
-/test/recv-msgall
-/test/recv-msgall-stream
-/test/register-restrictions
-/test/rename
-/test/ring-leak
-/test/ring-leak2
-/test/self
-/test/send_recv
-/test/send_recvmsg
-/test/sendmsg_fs_cve
-/test/shared-wq
-/test/short-read
-/test/shutdown
-/test/sigfd-deadlock
-/test/socket-rw
-/test/socket-rw-eagain
-/test/socket-rw-offset
-/test/splice
-/test/sq-full
-/test/sq-full-cpp
-/test/sq-poll-dup
-/test/sq-poll-kthread
-/test/sq-poll-share
-/test/sqpoll-disable-exit
-/test/sqpoll-exit-hang
-/test/sqpoll-sleep
-/test/sq-space_left
-/test/statx
-/test/stdout
-/test/submit-reuse
-/test/symlink
-/test/teardowns
-/test/thread-exit
-/test/timeout
-/test/timeout-new
-/test/timeout-overflow
-/test/tty-write-dpoll
-/test/unlink
-/test/wakeup-hang
-/test/multicqes_drain
-/test/poll-mshot-update
-/test/rsrc_tags
-/test/rw_merge_test
-/test/sqpoll-cancel-hang
-/test/testfile
-/test/submit-link-fail
-/test/exec-target
-/test/skip-cqe
+/test/*.test
 /test/*.dmesg
 /test/output/
 
diff --git a/test/Makefile b/test/Makefile
index e43738f..f62740e 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -183,7 +183,9 @@ endif
 all_targets += sq-full-cpp
 
 
-test_targets := $(patsubst %.c,%,$(patsubst %.cc,%,$(test_srcs)))
+test_targets := $(patsubst %.c,%,$(test_srcs))
+test_targets := $(patsubst %.cc,%,$(test_targets))
+test_targets := $(patsubst %,%.test,$(test_targets))
 all_targets += $(test_targets)
 
 #
@@ -204,10 +206,10 @@ all: $(test_targets)
 helpers.o: helpers.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
 
-%: %.c $(helpers) helpers.h ../src/liburing.a
+%.test: %.c $(helpers) helpers.h ../src/liburing.a
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
-%: %.cc $(helpers) helpers.h ../src/liburing.a
+%.test: %.cc $(helpers) helpers.h ../src/liburing.a
 	$(QUIET_CXX)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
 install: $(test_targets) runtests.sh runtests-loop.sh
-- 
Ammar Faizi

