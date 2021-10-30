Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E199440A17
	for <lists+io-uring@lfdr.de>; Sat, 30 Oct 2021 17:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhJ3P7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Oct 2021 11:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbhJ3P7v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Oct 2021 11:59:51 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45134C061570
        for <io-uring@vger.kernel.org>; Sat, 30 Oct 2021 08:57:21 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s136so12855881pgs.4
        for <io-uring@vger.kernel.org>; Sat, 30 Oct 2021 08:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YG0auAZGjMzZBeIatGdXIy6WsjNzUHxSPsvJgFpKkLg=;
        b=GOnrfgCRvylM17SZYbpJPpaOUOUrkGmo3EQM7aXsZlEBTFXctvbH9RuRLQzdB9VUvr
         eLhv17ppCHIgJawQh8D4fuTZgXS1DSGYCK4SFmXZeP9wZ27gF8EYMB8E/LeNLNNcu1uo
         JXeH0Ru2rzHxHoFR8DxKk+ZFNnhcRGSMHxh7pqMPLayqNXoFc0KkBA1VdM0icISgYL0V
         boPDFG05G24n88MA1Rw8PWyJ/364HzbRlXvkCj92JK1tV9+wQR2XtMAYluMcI1ZFJ4Cp
         7qxXo357JIeJUHXnsGDLTG2peK3WT1TjgSS+t71W3+w2MJjw98T0b59Dho6rADWFBiP0
         aRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YG0auAZGjMzZBeIatGdXIy6WsjNzUHxSPsvJgFpKkLg=;
        b=DG/o1Ewdl1muYmSiA7eUTrvqLzGEsvERT62+MmUKEft4nToMnx4rDoae1KwfLZ9few
         xPRHS8XrtIjo88jaLrqSkYLpSNRTVMBmpkKEzxEKp4N7xtx3DXJLPwjFJ2arKorjpnhS
         rS+BNatW34eG5hx6rB+fSs5y+Z5IUb6Dn50aACYzYTNhdWfahyhpuyndH5x7l99Av8BM
         lLN+hB+qNsksCUQMW3/sajkad0zJXsS8mXIEH5cMLprftW/uFj9SAtx/a5t/mDqQHrrp
         SfU5utXFbFxBO9zm1hgyANOwM2u1fa1aT/l0dzfchbiZU9v0bUFDORYVUTU0/F20QbmB
         M8rg==
X-Gm-Message-State: AOAM533vilHwWXKCo6nnpXFtYvQEIAX5MKyFkEZPi8/X977cQ8DSQIsb
        suAAS5jrRnyYwhSp6gxYEbJG5A==
X-Google-Smtp-Source: ABdhPJyRR+Dr8im7lxkL0f9CPVBWMAKK8tNNlG5BiC2E0s2IAZZKawB373b+8JNMee/WZa/1bEvPqQ==
X-Received: by 2002:a63:2b90:: with SMTP id r138mr13435435pgr.322.1635609440700;
        Sat, 30 Oct 2021 08:57:20 -0700 (PDT)
Received: from integral.. ([182.2.69.43])
        by smtp.gmail.com with ESMTPSA id z73sm2284818pgz.23.2021.10.30.08.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 08:57:20 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH liburing 2/2] test/Makefile: Refactor the Makefile
Date:   Sat, 30 Oct 2021 22:55:54 +0700
Message-Id: <20211030114858.320116-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211030114858.320116-1-ammar.faizi@intel.com>
References: <20211030114858.320116-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The Makefile for test is not efficient and reads bad. We have to
specify the name for each test 2 times (filename and name without
the ext) while we could have just elided the extension from the
source filename.

Let's make it simpler and easier to manage.

Changes summary:
 - Clean up and reorder things.
 - Sort the `test_srcs` alphabetically.
 - Remove `test_objs` (it turned out unused).
 - Generate `test_targets` variable from `test_srcs` by simply
   removing the `.c` and `.cc` file extension.

Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 test/Makefile | 263 ++++++++++++++++----------------------------------
 1 file changed, 83 insertions(+), 180 deletions(-)

diff --git a/test/Makefile b/test/Makefile
index 1a10a24..f7eafad 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -8,177 +8,32 @@ include ../config-host.mak
 endif
 
 CPPFLAGS ?=
-override CPPFLAGS += -D_GNU_SOURCE -D__SANE_USERSPACE_TYPES__ \
-	-I../src/include/ -include ../config-host.h
-CFLAGS ?= -g -O2 -Wall -Wextra
 
+override CPPFLAGS += \
+	-D_GNU_SOURCE \
+	-D__SANE_USERSPACE_TYPES__ \
+	-I../src/include/ \
+	-include ../config-host.h
+
+CFLAGS ?= -g -O2 -Wall -Wextra
 XCFLAGS = -Wno-unused-parameter -Wno-sign-compare
+
 ifdef CONFIG_HAVE_STRINGOP_OVERFLOW
-  XCFLAGS += -Wstringop-overflow=0
+	XCFLAGS += -Wstringop-overflow=0
 endif
+
 ifdef CONFIG_HAVE_ARRAY_BOUNDS
-  XCFLAGS += -Warray-bounds=0
+	XCFLAGS += -Warray-bounds=0
 endif
 
 CXXFLAGS ?= $(CFLAGS)
 override CFLAGS += $(XCFLAGS) -DLIBURING_BUILD_TEST
 override CXXFLAGS += $(XCFLAGS) -std=c++11 -DLIBURING_BUILD_TEST
+
 LDFLAGS ?=
 override LDFLAGS += -L../src/ -luring
 
-test_targets += \
-	232c93d07b74-test \
-	35fa71a030ca-test \
-	500f9fbadef8-test \
-	7ad0e4b2f83c-test \
-	8a9973408177-test \
-	917257daa0fe-test \
-	a0908ae19763-test \
-	a4c0b3decb33-test \
-	accept \
-	accept-link \
-	accept-reuse \
-	accept-test \
-	across-fork splice \
-	b19062a56726-test \
-	b5837bd5311d-test \
-	ce593a6c480a-test \
-	close-opath \
-	connect \
-	cq-full \
-	cq-overflow \
-	cq-peek-batch \
-	cq-ready \
-	cq-size \
-	d4ae271dfaae-test \
-	d77a67ed5f27-test \
-	defer \
-	double-poll-crash \
-	eeed8b54e0df-test \
-	empty-eownerdead \
-	eventfd \
-	eventfd-disable \
-	eventfd-ring \
-	fadvise \
-	fallocate \
-	fc2a85cb02ef-test \
-	file-register \
-	file-verify \
-	file-update \
-	files-exit-hang-poll \
-	files-exit-hang-timeout \
-	fixed-link \
-	fsync \
-	hardlink \
-	io-cancel \
-	io_uring_enter \
-	io_uring_register \
-	io_uring_setup \
-	iopoll \
-	lfs-openat \
-	lfs-openat-write \
-	link \
-	link-timeout \
-	link_drain \
-	madvise \
-	mkdir \
-	multicqes_drain \
-	nop \
-	nop-all-sizes \
-	open-close \
-	openat2 \
-	personality \
-	pipe-eof \
-	pipe-reuse \
-	poll \
-	poll-cancel \
-	poll-cancel-ton \
-	poll-link \
-	poll-many \
-	poll-mshot-update \
-	poll-ring \
-	poll-v-poll \
-	probe \
-	read-write \
-	register-restrictions \
-	rename \
-	ring-leak \
-	ring-leak2 \
-	rw_merge_test \
-	self \
-	send_recv \
-	send_recvmsg \
-	shared-wq \
-	short-read \
-	shutdown \
-	sigfd-deadlock \
-	socket-rw \
-	socket-rw-eagain \
-	sq-full \
-	sq-poll-dup \
-	sq-poll-kthread \
-	sq-poll-share \
-	sqpoll-disable-exit \
-	sqpoll-exit-hang \
-	sqpoll-cancel-hang \
-	sqpoll-sleep \
-	sq-space_left \
-	stdout \
-	submit-reuse \
-	submit-link-fail \
-	symlink \
-	teardowns \
-	thread-exit \
-	timeout \
-	timeout-new \
-	timeout-overflow \
-	unlink \
-	wakeup-hang \
-	sendmsg_fs_cve \
-	rsrc_tags \
-	exec-target \
-	# EOL
-
-all_targets += $(test_targets)
-
-include ../Makefile.quiet
-
-ifdef CONFIG_HAVE_STATX
-test_targets += statx
-endif
-all_targets += statx
-
-ifdef CONFIG_HAVE_CXX
-test_targets += sq-full-cpp
-endif
-all_targets += sq-full-cpp
-
-#
-# Build ../src/syscall.c manually from test's Makefile to support
-# liburing nolibc.
-#
-# Functions in ../src/syscall.c require libc to work with, if we
-# build liburing without libc, we don't have those functions
-# in liburing.a. So build it manually here.
-#
-helpers = helpers.o ../src/syscall.o
-
-all: ${helpers} $(test_targets)
-
-../src/syscall.o: ../src/syscall.c
-	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
-
-helpers.o: helpers.c
-	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
-
-%: %.c ${helpers} helpers.h
-	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< ${helpers} $(LDFLAGS)
-
-%: %.cc ${helpers} helpers.h
-	$(QUIET_CXX)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $< ${helpers} $(LDFLAGS)
-
 test_srcs := \
-	helpers.c \
 	232c93d07b74-test.c \
 	35fa71a030ca-test.c \
 	500f9fbadef8-test.c \
@@ -187,10 +42,10 @@ test_srcs := \
 	917257daa0fe-test.c \
 	a0908ae19763-test.c \
 	a4c0b3decb33-test.c \
+	accept.c \
 	accept-link.c \
 	accept-reuse.c \
 	accept-test.c \
-	accept.c \
 	across-fork.c \
 	b19062a56726-test.c \
 	b5837bd5311d-test.c \
@@ -200,7 +55,7 @@ test_srcs := \
 	cq-full.c \
 	cq-overflow.c \
 	cq-peek-batch.c \
-	cq-ready.c\
+	cq-ready.c \
 	cq-size.c \
 	d4ae271dfaae-test.c \
 	d77a67ed5f27-test.c \
@@ -208,56 +63,60 @@ test_srcs := \
 	double-poll-crash.c \
 	eeed8b54e0df-test.c \
 	empty-eownerdead.c \
+	eventfd.c \
 	eventfd-disable.c \
 	eventfd-ring.c \
-	eventfd.c \
+	exec-target.c \
 	fadvise.c \
 	fallocate.c \
 	fc2a85cb02ef-test.c \
 	file-register.c \
-	file-verify.c \
-	file-update.c \
 	files-exit-hang-poll.c \
 	files-exit-hang-timeout.c \
+	file-update.c \
+	file-verify.c \
 	fixed-link.c \
 	fsync.c \
 	hardlink.c \
 	io-cancel.c \
+	iopoll.c \
 	io_uring_enter.c \
 	io_uring_register.c \
 	io_uring_setup.c \
-	iopoll.c \
-	lfs-openat-write.c \
 	lfs-openat.c \
-	link-timeout.c \
+	lfs-openat-write.c \
 	link.c \
 	link_drain.c \
+	link-timeout.c \
 	madvise.c \
 	mkdir.c \
 	multicqes_drain.c \
 	nop-all-sizes.c \
 	nop.c \
-	open-close.c \
 	openat2.c \
+	open-close.c \
 	personality.c \
 	pipe-eof.c \
 	pipe-reuse.c \
-	poll-cancel-ton.c \
+	poll.c \
 	poll-cancel.c \
+	poll-cancel-ton.c \
 	poll-link.c \
 	poll-many.c \
 	poll-mshot-update.c \
 	poll-ring.c \
 	poll-v-poll.c \
-	poll.c \
 	probe.c \
 	read-write.c \
 	register-restrictions.c \
 	rename.c \
-	ring-leak.c \
 	ring-leak2.c \
+	ring-leak.c \
+	rsrc_tags.c \
 	rw_merge_test.c \
 	self.c \
+	sendmsg_fs_cve.c \
+	send_recv.c \
 	send_recvmsg.c \
 	shared-wq.c \
 	short-read.c \
@@ -266,34 +125,74 @@ test_srcs := \
 	socket-rw.c \
 	socket-rw-eagain.c \
 	splice.c \
-	sq-full-cpp.cc \
 	sq-full.c \
+	sq-full-cpp.cc \
+	sqpoll-cancel-hang.c \
+	sqpoll-disable-exit.c \
 	sq-poll-dup.c \
+	sqpoll-exit-hang.c \
 	sq-poll-kthread.c \
 	sq-poll-share.c \
-	sqpoll-disable-exit.c \
-	sqpoll-exit-hang.c \
-	sqpoll-cancel-hang.c \
 	sqpoll-sleep.c \
 	sq-space_left.c \
 	statx.c \
 	stdout.c \
-	submit-reuse.c \
 	submit-link-fail.c \
+	submit-reuse.c \
 	symlink.c \
 	teardowns.c \
 	thread-exit.c \
+	timeout.c \
 	timeout-new.c \
 	timeout-overflow.c \
-	timeout.c \
 	unlink.c \
 	wakeup-hang.c \
-	sendmsg_fs_cve.c \
-	rsrc_tags.c \
-	exec-target.c \
 	# EOL
 
-test_objs := $(patsubst %.c,%.ol,$(patsubst %.cc,%.ol,$(test_srcs)))
+
+all_targets :=
+include ../Makefile.quiet
+
+
+ifdef CONFIG_HAVE_STATX
+	test_srcs += statx.c
+endif
+all_targets += statx
+
+
+ifdef CONFIG_HAVE_CXX
+	test_srcs += sq-full-cpp.cc
+endif
+all_targets += sq-full-cpp
+
+
+test_targets := $(patsubst %.c,%,$(patsubst %.cc,%,$(test_srcs)))
+all_targets += $(test_targets)
+
+#
+# Build ../src/syscall.c manually from test's Makefile to support
+# liburing nolibc.
+#
+# Functions in ../src/syscall.c require libc to work with, if we
+# build liburing without libc, we don't have those functions
+# in liburing.a. So build it manually here.
+#
+helpers = helpers.o ../src/syscall.o
+
+all: $(test_targets)
+
+../src/syscall.o: ../src/syscall.c
+	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
+
+helpers.o: helpers.c
+	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
+
+%: %.c $(helpers) helpers.h
+	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
+
+%: %.cc $(helpers) helpers.h
+	$(QUIET_CXX)$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $< $(helpers) $(LDFLAGS)
+
 
 35fa71a030ca-test: override LDFLAGS += -lpthread
 232c93d07b74-test: override LDFLAGS += -lpthread
@@ -317,11 +216,15 @@ install: $(test_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -m 755 $(test_targets) $(datadir)/liburing-test/
 	$(INSTALL) -D -m 755 runtests.sh  $(datadir)/liburing-test/
 	$(INSTALL) -D -m 755 runtests-loop.sh  $(datadir)/liburing-test/
+
 clean:
-	@rm -f $(all_targets) $(test_objs) helpers.o output/*
+	@rm -f $(all_targets) helpers.o output/*
 	@rm -rf output/
 
 runtests: all
 	@./runtests.sh $(test_targets)
+
 runtests-loop: all
 	@./runtests-loop.sh $(test_targets)
+
+.PHONY: all install clean runtests runtests-loop
-- 
2.30.2

