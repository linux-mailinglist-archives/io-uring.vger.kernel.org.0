Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AF8230FF2
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 18:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731380AbgG1Qiq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 12:38:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57130 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731367AbgG1Qiq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 12:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595954324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lfXFlpbGvMhx/MnSEZvdqag2kTGHfYxJ2BxlFyRKySQ=;
        b=AyDCHVuEtftf30IRmlPR1NVCDyRTJOl11J3KSjHReaBK6XBFs0hYZX4lDy0fX7MrLpyO7u
        6sFs3AyWSv0Pk5MHWmVGWGjBEL5QoLnVOIjW7pRYxYan9urni9rXPyRpyw69AW6HzS97Ra
        k+Mji4LWn9ukIgpPnovkZDckfatEHVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-UEo7nIeXOISlV7IXDVxEmg-1; Tue, 28 Jul 2020 12:38:39 -0400
X-MC-Unique: UEo7nIeXOISlV7IXDVxEmg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C407100961D;
        Tue, 28 Jul 2020 16:38:38 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-82.ams2.redhat.com [10.36.112.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 234AD71901;
        Tue, 28 Jul 2020 16:38:34 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing] test: generate binaries in test/bin/
Date:   Tue, 28 Jul 2020 18:38:28 +0200
Message-Id: <20200728163828.78835-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In order to avoid to update .gitignore for every test that we add,
we can build them into a subfolder (test/bin) and ignore all
its contents.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 .gitignore          | 79 ---------------------------------------------
 test/Makefile       | 26 ++++++++-------
 test/bin/.gitignore |  1 +
 3 files changed, 15 insertions(+), 91 deletions(-)
 create mode 100644 test/bin/.gitignore

diff --git a/.gitignore b/.gitignore
index 00f7a86..e5cb507 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,85 +15,6 @@
 /examples/link-cp
 /examples/ucontext-cp
 
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
-/test/connect
-/test/close-opath
-/test/cq-full
-/test/cq-overflow
-/test/cq-peek-batch
-/test/cq-ready
-/test/cq-size
-/test/d4ae271dfaae-test
-/test/d77a67ed5f27-test
-/test/defer
-/test/eeed8b54e0df-test
-/test/eventfd
-/test/eventfd-disable
-/test/eventfd-ring
-/test/fadvise
-/test/fallocate
-/test/fc2a85cb02ef-test
-/test/file-register
-/test/file-update
-/test/fixed-link
-/test/fsync
-/test/io_uring_enter
-/test/io_uring_register
-/test/io_uring_setup
-/test/io-cancel
-/test/lfs-openat
-/test/lfs-openat-write
-/test/link
-/test/link-timeout
-/test/link_drain
-/test/madvise
-/test/nop
-/test/nop-all-sizes
-/test/open-close
-/test/openat2
-/test/personality
-/test/poll
-/test/poll-cancel
-/test/poll-cancel-ton
-/test/poll-link
-/test/poll-many
-/test/poll-v-poll
-/test/probe
-/test/read-write
-/test/ring-leak
-/test/send_recv
-/test/send_recvmsg
-/test/shared-wq
-/test/short-read
-/test/socket-rw
-/test/splice
-/test/sq-full
-/test/sq-full-cpp
-/test/sq-poll-kthread
-/test/sq-space_left
-/test/statx
-/test/stdout
-/test/submit-reuse
-/test/teardowns
-/test/timeout
-/test/timeout-overflow
-/test/iopoll
-/test/cq-overflow-peek
 /test/config.local
 /test/*.dmesg
 
diff --git a/test/Makefile b/test/Makefile
index a693d6f..b574c02 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -42,12 +42,14 @@ ifdef CONFIG_HAVE_CXX
 all_targets += sq-full-cpp
 endif
 
+all_targets := $(addprefix bin/,$(all_targets))
+
 all: $(all_targets)
 
-%: %.c
+bin/%: %.c
 	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $< -luring $(XCFLAGS)
 
-%: %.cc
+bin/%: %.cc
 	$(QUIET_CC)$(CXX) $(CXXFLAGS) -o $@ $< -luring $(XCFLAGS)
 
 test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
@@ -79,16 +81,16 @@ endif
 
 test_objs := $(patsubst %.c,%.ol,$(test_srcs))
 
-35fa71a030ca-test: XCFLAGS = -lpthread
-232c93d07b74-test: XCFLAGS = -lpthread
-send_recv: XCFLAGS = -lpthread
-send_recvmsg: XCFLAGS = -lpthread
-poll-link: XCFLAGS = -lpthread
-accept-link: XCFLAGS = -lpthread
-submit-reuse: XCFLAGS = -lpthread
-poll-v-poll: XCFLAGS = -lpthread
-across-fork: XCFLAGS = -lpthread
-ce593a6c480a-test: XCFLAGS = -lpthread
+bin/35fa71a030ca-test: XCFLAGS = -lpthread
+bin/232c93d07b74-test: XCFLAGS = -lpthread
+bin/send_recv: XCFLAGS = -lpthread
+bin/send_recvmsg: XCFLAGS = -lpthread
+bin/poll-link: XCFLAGS = -lpthread
+bin/accept-link: XCFLAGS = -lpthread
+bin/submit-reuse: XCFLAGS = -lpthread
+bin/poll-v-poll: XCFLAGS = -lpthread
+bin/across-fork: XCFLAGS = -lpthread
+bin/ce593a6c480a-test: XCFLAGS = -lpthread
 
 install: $(all_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
diff --git a/test/bin/.gitignore b/test/bin/.gitignore
new file mode 100644
index 0000000..72e8ffc
--- /dev/null
+++ b/test/bin/.gitignore
@@ -0,0 +1 @@
+*
-- 
2.26.2

