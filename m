Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C134F0BBC
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 20:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359740AbiDCSYh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 14:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359738AbiDCSYg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 14:24:36 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D572339156
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 11:22:42 -0700 (PDT)
Received: from integral2.. (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id 1EB477E36E;
        Sun,  3 Apr 2022 18:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649010162;
        bh=opTE2r/RtYgKezFARssHjOFWp5Faa6kfx61ORKnwuZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvwylv/eSvna6O+Ll9s/NTAzdxgZ49xioQysBXwJbKfh0rzz6eRyWlVobruyeBD2v
         Jkz3MTPcBU/0FEhLJB1rgF8WSExfJ2n6Kguicy+PF9e+GzJo2OQIWm+uaELyrKoVFo
         dBAkql2MG/HBZ617tX/qjvmCv9vo7VgORI0q8G3in9pUHg8vqOqKMKHit+krXMqAnV
         b0EdLUQN8dkiZemX1ZijAzYvItD75WXrVr5GNG8oVQl0VaV4N7cxM3iaGIKJpY0Fsu
         VQbASungiImJZNRvk/xEOEDdI9x9SlDTBSVMPNnh5anUaEqLOFelrBhs5YDpsJ9RiT
         guN1oPxcj7OWg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v2 3/3] test/Makefile: Append `.t` to the test binary
Date:   Mon,  4 Apr 2022 01:22:00 +0700
Message-Id: <20220403182200.259937-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
References: <20220403182200.259937-1-ammarfaizi2@gnuweeb.org>
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
`.gitignore`. Append `.t` to the test binary filename, this way we can
use a wildcard matching "test/*.t" in `.gitignore` to ignore all
test binary files.

Goals:
  - Make the .gitignore simpler.
  - Avoid the burden of adding a new test to .gitignore.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .gitignore    | 131 +-------------------------------------------------
 test/Makefile |   8 +--
 2 files changed, 6 insertions(+), 133 deletions(-)

diff --git a/.gitignore b/.gitignore
index 58fff7f..60fddd7 100644
--- a/.gitignore
+++ b/.gitignore
@@ -16,136 +16,7 @@
 /examples/link-cp
 /examples/ucontext-cp
 
-/test/232c93d07b74
-/test/35fa71a030ca
-/test/500f9fbadef8
-/test/7ad0e4b2f83c
-/test/8a9973408177
-/test/917257daa0fe
-/test/a0908ae19763
-/test/a4c0b3decb33
-/test/accept
-/test/accept-link
-/test/accept-reuse
-/test/accept-test
-/test/across-fork
-/test/b19062a56726
-/test/b5837bd5311d
-/test/ce593a6c480a
-/test/close-opath
-/test/config.local
-/test/connect
-/test/cq-full
-/test/cq-overflow
-/test/cq-overflow-peek
-/test/cq-peek-batch
-/test/cq-ready
-/test/cq-size
-/test/d4ae271dfaae
-/test/d77a67ed5f27
-/test/defer
-/test/double-poll-crash
-/test/drop-submit
-/test/eeed8b54e0df
-/test/empty-eownerdead
-/test/eventfd
-/test/eventfd-disable
-/test/eventfd-reg
-/test/eventfd-ring
-/test/exit-no-cleanup
-/test/fadvise
-/test/fallocate
-/test/fc2a85cb02ef
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
+/test/*.t
 /test/*.dmesg
 /test/output/
 
diff --git a/test/Makefile b/test/Makefile
index eb1e7d5..d97341c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -183,7 +183,9 @@ endif
 all_targets += sq-full-cpp
 
 
-test_targets := $(patsubst %.c,%,$(patsubst %.cc,%,$(test_srcs)))
+test_targets := $(patsubst %.c,%,$(test_srcs))
+test_targets := $(patsubst %.cc,%,$(test_targets))
+test_targets := $(patsubst %,%.t,$(test_targets))
 all_targets += $(test_targets)
 
 #
@@ -204,10 +206,10 @@ all: $(test_targets)
 helpers.o: helpers.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
 
-%: %.c $(helpers) helpers.h ../src/liburing.a
+%.t: %.c $(helpers) helpers.h ../src/liburing.a
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
-%: %.cc $(helpers) helpers.h ../src/liburing.a
+%.t: %.cc $(helpers) helpers.h ../src/liburing.a
 	$(QUIET_CXX)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
 
 
-- 
Ammar Faizi

