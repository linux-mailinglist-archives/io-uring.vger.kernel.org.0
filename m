Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F3957C712
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 11:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiGUJFJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 05:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiGUJFI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 05:05:08 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE3D5A2D5
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 02:05:03 -0700 (PDT)
Received: from integral2.. (unknown [125.160.97.11])
        by gnuweeb.org (Postfix) with ESMTPSA id 1671A7E24B;
        Thu, 21 Jul 2022 09:04:58 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658394302;
        bh=XpznbUTirmG/dfGyAfzd9MJ5J42Bsk+IAkrRQD6V+CM=;
        h=From:To:Cc:Subject:Date:From;
        b=RoEcVJzK2cbPYbHEPXpQOEdLTk4m50eG8sR8X0oDNuMlaSCLb63FdxuE27c56ZSwu
         69CI5dn/FkFpuyAj4GiVqLYK362ycreK3oBlNF3e9bGBL6ANjq0xHwD8bMClFgb4FZ
         QLG/ONcZTMGF+J5ACgKpdF4tiWNPpdZmfZrm9ZZ3ZPm/n/L8f1e2iPl6CKvy87WAVU
         AbCZNqPg095g6IYdidA7IGqtUIeVs0L+dNT60X6XfLdnr3LoAQp9HWNLQB+GtGbf07
         EP4/FqWy3OYTAEpDF2fwyc7qhKFEhf5i+9Tacu7uxhhMmyWMGVpjjxtpCvDD12Tyq9
         iZ+qSZH347zjQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing] Delete `src/syscall.c` and get back to use `__sys_io_uring*` functions
Date:   Thu, 21 Jul 2022 16:04:43 +0700
Message-Id: <20220721090443.733104-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=31942; i=ammarfaizi2@gnuweeb.org; h=from:subject; bh=XpznbUTirmG/dfGyAfzd9MJ5J42Bsk+IAkrRQD6V+CM=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBi2RZkzIQu3uGUQ0IgodQAGhIgrvVvjg+Mhro9RNuC fvNPwk+JATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYtkWZAAKCRA2T7o0/xcKS3j0CA C9qw2qBkyBq/S/fMZkakwKWGEgimyv7BY4m1zrmPXJAx0Yf4DW4r3j+z7mbqok9QZW83eGHXp88k9A ALEU8ct6cN1XVbaQfAMCPtTBfldmQ89zHPIQZRdASJGAALPfEvhWseMMYeYY6jN3wFz0bGCAhHsera cRUO1inXVzAJxnZoFdUOQNbl60EMHGEeR1c4OUi9PsscF+lxQRjpV1xe2jR+vOXXIMyV8OLP19kPAF gdrDs4nZZzjtyHEvHcaPVOLvstFErepOsD1kIFLFAdyUAe9MZjYNyxZys8MSLdzKXkNBI5HPL5cTpw mLFEcfFHvJ7cL2YJl82nn8JgCr697E
X-Developer-Key: i=ammarfaizi2@gnuweeb.org; a=openpgp; fpr=E893726DC8E4C0DE3BA20107364FBA34FF170A4B
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Back when I was adding nolibc support for liburing, I added new
wrapper functions for io_uring system calls. They are ____sys_io_uring*
functions (with 4 underscores), all defined as an inline function.

I left __sys_uring* functions (with 2 underscores) live in syscall.c
because I thought it might break the user if we delete them. But it
turned out that I was wrong, no user should use these functions
because we don't export them. This situation is reflected in
liburing.map and liburing.h which don't have those functions.

Do these:

  1) Delete src/syscall.c.
  2) Rename ____sys_io_uring* to __sys_io_uring*.
  3) Fix tests that still depend on libc `errno` for checking
     __sys_io_uring* functions error code.

to:

  1) Reduce the burden of maintaining syscall.c.
  2) Simplify the Makefile, no need extra branch to compile syscall.c
     with a specific condition.
  3) Simplify function naming and kill the confusion of deciding
     using __sys_uring* or ____sys_io_uring* when adding a new test that
     directly calls them. Because now we always use __sys_io_uring*.
     ____sys_io_uring* functions no longer exist.

After this patch, __sys_io_uring* functions now return -errno instead
of -1 when fails.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

=======================================================================

Test files that use __sys_io_uring* functions:

  ammarfaizi2@integral2:~/app/liburing/test$ grep -r __sys_io_uring | cut -d ':' -f 1 | sort | uniq
  35fa71a030ca.c
  917257daa0fe.c
  a0908ae19763.c
  a4c0b3decb33.c
  accept-reuse.c
  b19062a56726.c
  double-poll-crash.c
  empty-eownerdead.c
  fc2a85cb02ef.c
  iopoll.c
  io_uring_enter.c
  io_uring_register.c
  io_uring_setup.c
  ring-leak2.c
  ring-leak.c
  rsrc_tags.c
  sqpoll-cancel-hang.c
  sqpoll-disable-exit.c
  timeout.c

those are 19 files.

By manual checking of those 19 files, *only* the following files use `errno` to
check for __sys_io_uring* error:

  empty-eownerdead.c
  io_uring_enter.c
  io_uring_register.c
  io_uring_setup.c
  rsrc_tags.c

All are fixed and no longer rely on `errno` for checking __sys_io_uring*.
Tested on Linux 5.19-rc7 x86-64, all tests are fixed except: read-write.t
and poll-mshot-overflow.t that I reported recently.

 src/Makefile             |   2 -
 src/arch/syscall-defs.h  |  24 +++----
 src/queue.c              |  14 ++---
 src/register.c           | 133 +++++++++++++++++++--------------------
 src/setup.c              |   2 +-
 src/syscall.c            |  47 --------------
 src/syscall.h            |  13 ----
 test/Makefile            |  14 +----
 test/io_uring_enter.c    |  28 ++++-----
 test/io_uring_register.c |  33 +++++-----
 test/io_uring_setup.c    |  26 ++++----
 test/rsrc_tags.c         |  13 ++--
 12 files changed, 135 insertions(+), 214 deletions(-)
 delete mode 100644 src/syscall.c

diff --git a/src/Makefile b/src/Makefile
index 1fec779..dad379d 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -39,8 +39,6 @@ ifeq ($(CONFIG_NOLIBC),y)
 	override CFLAGS += -nostdlib -nodefaultlibs -ffreestanding
 	override CPPFLAGS += -nostdlib -nodefaultlibs -ffreestanding
 	override LINK_FLAGS += -nostdlib -nodefaultlibs
-else
-	liburing_srcs += syscall.c
 endif
 
 override CPPFLAGS += -MT "$@" -MMD -MP -MF "$@.d"
diff --git a/src/arch/syscall-defs.h b/src/arch/syscall-defs.h
index df90e0d..9ddac45 100644
--- a/src/arch/syscall-defs.h
+++ b/src/arch/syscall-defs.h
@@ -61,33 +61,33 @@ static inline int __sys_close(int fd)
 	return (int) __do_syscall1(__NR_close, fd);
 }
 
-static inline int ____sys_io_uring_register(int fd, unsigned opcode,
-					    const void *arg, unsigned nr_args)
+static inline int __sys_io_uring_register(int fd, unsigned opcode,
+					  const void *arg, unsigned nr_args)
 {
 	return (int) __do_syscall4(__NR_io_uring_register, fd, opcode, arg,
 				   nr_args);
 }
 
-static inline int ____sys_io_uring_setup(unsigned entries,
-					 struct io_uring_params *p)
+static inline int __sys_io_uring_setup(unsigned entries,
+				       struct io_uring_params *p)
 {
 	return (int) __do_syscall2(__NR_io_uring_setup, entries, p);
 }
 
-static inline int ____sys_io_uring_enter2(int fd, unsigned to_submit,
-					  unsigned min_complete, unsigned flags,
-					  sigset_t *sig, int sz)
+static inline int __sys_io_uring_enter2(int fd, unsigned to_submit,
+					unsigned min_complete, unsigned flags,
+					sigset_t *sig, int sz)
 {
 	return (int) __do_syscall6(__NR_io_uring_enter, fd, to_submit,
 				   min_complete, flags, sig, sz);
 }
 
-static inline int ____sys_io_uring_enter(int fd, unsigned to_submit,
-					 unsigned min_complete, unsigned flags,
-					 sigset_t *sig)
+static inline int __sys_io_uring_enter(int fd, unsigned to_submit,
+				       unsigned min_complete, unsigned flags,
+				       sigset_t *sig)
 {
-	return ____sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
-				       _NSIG / 8);
+	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
+				     _NSIG / 8);
 }
 
 #endif
diff --git a/src/queue.c b/src/queue.c
index ce0ecf6..72cc77b 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -92,9 +92,9 @@ static int _io_uring_get_cqe(struct io_uring *ring,
 
 		if (ring->int_flags & INT_FLAG_REG_RING)
 			flags |= IORING_ENTER_REGISTERED_RING;
-		ret = ____sys_io_uring_enter2(ring->enter_ring_fd, data->submit,
-					      data->wait_nr, flags, data->arg,
-					      data->sz);
+		ret = __sys_io_uring_enter2(ring->enter_ring_fd, data->submit,
+					    data->wait_nr, flags, data->arg,
+					    data->sz);
 		if (ret < 0) {
 			err = ret;
 			break;
@@ -162,7 +162,7 @@ again:
 
 		if (ring->int_flags & INT_FLAG_REG_RING)
 			flags |= IORING_ENTER_REGISTERED_RING;
-		____sys_io_uring_enter(ring->enter_ring_fd, 0, 0, flags, NULL);
+		__sys_io_uring_enter(ring->enter_ring_fd, 0, 0, flags, NULL);
 		overflow_checked = true;
 		goto again;
 	}
@@ -360,8 +360,8 @@ static int __io_uring_submit(struct io_uring *ring, unsigned submitted,
 		if (ring->int_flags & INT_FLAG_REG_RING)
 			flags |= IORING_ENTER_REGISTERED_RING;
 
-		ret = ____sys_io_uring_enter(ring->enter_ring_fd, submitted,
-						wait_nr, flags, NULL);
+		ret = __sys_io_uring_enter(ring->enter_ring_fd, submitted,
+					   wait_nr, flags, NULL);
 	} else
 		ret = submitted;
 
@@ -407,5 +407,5 @@ int __io_uring_sqring_wait(struct io_uring *ring)
 	if (ring->int_flags & INT_FLAG_REG_RING)
 		flags |= IORING_ENTER_REGISTERED_RING;
 
-	return  ____sys_io_uring_enter(ring->enter_ring_fd, 0, 0, flags, NULL);
+	return __sys_io_uring_enter(ring->enter_ring_fd, 0, 0, flags, NULL);
 }
diff --git a/src/register.c b/src/register.c
index 8ec076f..2b37e5f 100644
--- a/src/register.c
+++ b/src/register.c
@@ -20,8 +20,7 @@ int io_uring_register_buffers_update_tag(struct io_uring *ring, unsigned off,
 		.nr = nr,
 	};
 
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_BUFFERS_UPDATE, &up,
+	return __sys_io_uring_register(ring->ring_fd,IORING_REGISTER_BUFFERS_UPDATE, &up,
 					 sizeof(up));
 }
 
@@ -36,9 +35,9 @@ int io_uring_register_buffers_tags(struct io_uring *ring,
 		.tags = (unsigned long)tags,
 	};
 
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_BUFFERS2, &reg,
-					 sizeof(reg));
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_BUFFERS2, &reg,
+				       sizeof(reg));
 }
 
 int io_uring_register_buffers_sparse(struct io_uring *ring, unsigned nr)
@@ -48,9 +47,8 @@ int io_uring_register_buffers_sparse(struct io_uring *ring, unsigned nr)
 		.nr = nr,
 	};
 
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_BUFFERS2, &reg,
-					 sizeof(reg));
+	return __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS2,
+				       &reg, sizeof(reg));
 }
 
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
@@ -58,8 +56,8 @@ int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
 {
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS,
-					iovecs, nr_iovecs);
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS,
+				      iovecs, nr_iovecs);
 	return (ret < 0) ? ret : 0;
 }
 
@@ -67,8 +65,8 @@ int io_uring_unregister_buffers(struct io_uring *ring)
 {
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd,
-					IORING_UNREGISTER_BUFFERS, NULL, 0);
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_BUFFERS,
+				      NULL, 0);
 	return (ret < 0) ? ret : 0;
 }
 
@@ -83,9 +81,9 @@ int io_uring_register_files_update_tag(struct io_uring *ring, unsigned off,
 		.nr = nr_files,
 	};
 
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_FILES_UPDATE2, &up,
-					 sizeof(up));
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_FILES_UPDATE2, &up,
+				       sizeof(up));
 }
 
 /*
@@ -103,9 +101,9 @@ int io_uring_register_files_update(struct io_uring *ring, unsigned off,
 		.fds	= (unsigned long) files,
 	};
 
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_FILES_UPDATE, &up,
-					 nr_files);
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_FILES_UPDATE, &up,
+				       nr_files);
 }
 
 static int increase_rlimit_nofile(unsigned nr)
@@ -134,9 +132,9 @@ int io_uring_register_files_sparse(struct io_uring *ring, unsigned nr)
 	int ret, did_increase = 0;
 
 	do {
-		ret = ____sys_io_uring_register(ring->ring_fd,
-						IORING_REGISTER_FILES2, &reg,
-						sizeof(reg));
+		ret = __sys_io_uring_register(ring->ring_fd,
+					      IORING_REGISTER_FILES2, &reg,
+					      sizeof(reg));
 		if (ret >= 0)
 			break;
 		if (ret == -EMFILE && !did_increase) {
@@ -161,9 +159,9 @@ int io_uring_register_files_tags(struct io_uring *ring, const int *files,
 	int ret, did_increase = 0;
 
 	do {
-		ret = ____sys_io_uring_register(ring->ring_fd,
-						IORING_REGISTER_FILES2, &reg,
-						sizeof(reg));
+		ret = __sys_io_uring_register(ring->ring_fd,
+					      IORING_REGISTER_FILES2, &reg,
+					      sizeof(reg));
 		if (ret >= 0)
 			break;
 		if (ret == -EMFILE && !did_increase) {
@@ -183,9 +181,9 @@ int io_uring_register_files(struct io_uring *ring, const int *files,
 	int ret, did_increase = 0;
 
 	do {
-		ret = ____sys_io_uring_register(ring->ring_fd,
-						IORING_REGISTER_FILES, files,
-						nr_files);
+		ret = __sys_io_uring_register(ring->ring_fd,
+					      IORING_REGISTER_FILES, files,
+					      nr_files);
 		if (ret >= 0)
 			break;
 		if (ret == -EMFILE && !did_increase) {
@@ -203,8 +201,8 @@ int io_uring_unregister_files(struct io_uring *ring)
 {
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_FILES,
-					NULL, 0);
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_FILES,
+				      NULL, 0);
 	return (ret < 0) ? ret : 0;
 }
 
@@ -212,8 +210,8 @@ int io_uring_register_eventfd(struct io_uring *ring, int event_fd)
 {
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd, IORING_REGISTER_EVENTFD,
-					&event_fd, 1);
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_EVENTFD,
+				      &event_fd, 1);
 	return (ret < 0) ? ret : 0;
 }
 
@@ -221,8 +219,8 @@ int io_uring_unregister_eventfd(struct io_uring *ring)
 {
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd,
-					IORING_UNREGISTER_EVENTFD, NULL, 0);
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_EVENTFD,
+				      NULL, 0);
 	return (ret < 0) ? ret : 0;
 }
 
@@ -230,9 +228,9 @@ int io_uring_register_eventfd_async(struct io_uring *ring, int event_fd)
 {
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd,
-					IORING_REGISTER_EVENTFD_ASYNC,
-					&event_fd, 1);
+	ret = __sys_io_uring_register(ring->ring_fd,
+				      IORING_REGISTER_EVENTFD_ASYNC, &event_fd,
+				      1);
 	return (ret < 0) ? ret : 0;
 }
 
@@ -241,22 +239,21 @@ int io_uring_register_probe(struct io_uring *ring, struct io_uring_probe *p,
 {
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd, IORING_REGISTER_PROBE, p,
-					nr_ops);
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_PROBE, p,
+				      nr_ops);
 	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_register_personality(struct io_uring *ring)
 {
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_PERSONALITY, NULL, 0);
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_PERSONALITY, NULL, 0);
 }
 
 int io_uring_unregister_personality(struct io_uring *ring, int id)
 {
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_UNREGISTER_PERSONALITY, NULL,
-					 id);
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_UNREGISTER_PERSONALITY, NULL, id);
 }
 
 int io_uring_register_restrictions(struct io_uring *ring,
@@ -265,36 +262,36 @@ int io_uring_register_restrictions(struct io_uring *ring,
 {
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd,
-					IORING_REGISTER_RESTRICTIONS, res,
-					nr_res);
+	ret = __sys_io_uring_register(ring->ring_fd,
+				      IORING_REGISTER_RESTRICTIONS, res,
+				      nr_res);
 	return (ret < 0) ? ret : 0;
 }
 
 int io_uring_enable_rings(struct io_uring *ring)
 {
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_ENABLE_RINGS, NULL, 0);
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_ENABLE_RINGS, NULL, 0);
 }
 
 int io_uring_register_iowq_aff(struct io_uring *ring, size_t cpusz,
 			       const cpu_set_t *mask)
 {
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_IOWQ_AFF, mask, cpusz);
+	return __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_IOWQ_AFF,
+				       mask, cpusz);
 }
 
 int io_uring_unregister_iowq_aff(struct io_uring *ring)
 {
-	return  ____sys_io_uring_register(ring->ring_fd,
-					  IORING_UNREGISTER_IOWQ_AFF, NULL, 0);
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_UNREGISTER_IOWQ_AFF, NULL, 0);
 }
 
 int io_uring_register_iowq_max_workers(struct io_uring *ring, unsigned int *val)
 {
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_IOWQ_MAX_WORKERS, val,
-					 2);
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_IOWQ_MAX_WORKERS, val,
+				       2);
 }
 
 int io_uring_register_ring_fd(struct io_uring *ring)
@@ -305,8 +302,8 @@ int io_uring_register_ring_fd(struct io_uring *ring)
 	};
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd, IORING_REGISTER_RING_FDS,
-					&up, 1);
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_RING_FDS,
+				      &up, 1);
 	if (ret == 1) {
 		ring->enter_ring_fd = up.offset;
 		ring->int_flags |= INT_FLAG_REG_RING;
@@ -322,8 +319,8 @@ int io_uring_unregister_ring_fd(struct io_uring *ring)
 	};
 	int ret;
 
-	ret = ____sys_io_uring_register(ring->ring_fd,
-					IORING_UNREGISTER_RING_FDS, &up, 1);
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_UNREGISTER_RING_FDS,
+				      &up, 1);
 	if (ret == 1) {
 		ring->enter_ring_fd = ring->ring_fd;
 		ring->int_flags &= ~INT_FLAG_REG_RING;
@@ -335,23 +332,23 @@ int io_uring_register_buf_ring(struct io_uring *ring,
 			       struct io_uring_buf_reg *reg,
 			       unsigned int __maybe_unused flags)
 {
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_PBUF_RING, reg, 1);
+	return __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_PBUF_RING,
+				       reg, 1);
 }
 
 int io_uring_unregister_buf_ring(struct io_uring *ring, int bgid)
 {
 	struct io_uring_buf_reg reg = { .bgid = bgid };
 
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_UNREGISTER_PBUF_RING, &reg, 1);
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_UNREGISTER_PBUF_RING, &reg, 1);
 }
 
 int io_uring_register_sync_cancel(struct io_uring *ring,
 				  struct io_uring_sync_cancel_reg *reg)
 {
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_SYNC_CANCEL, reg, 1);
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_SYNC_CANCEL, reg, 1);
 }
 
 int io_uring_register_file_alloc_range(struct io_uring *ring,
@@ -363,7 +360,7 @@ int io_uring_register_file_alloc_range(struct io_uring *ring,
 	range.off = off;
 	range.len = len;
 
-	return ____sys_io_uring_register(ring->ring_fd,
-					 IORING_REGISTER_FILE_ALLOC_RANGE,
-					 &range, 0);
+	return __sys_io_uring_register(ring->ring_fd,
+				       IORING_REGISTER_FILE_ALLOC_RANGE, &range,
+				       0);
 }
diff --git a/src/setup.c b/src/setup.c
index 2badcc1..dec55d9 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -144,7 +144,7 @@ __cold int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 {
 	int fd, ret;
 
-	fd = ____sys_io_uring_setup(entries, p);
+	fd = __sys_io_uring_setup(entries, p);
 	if (fd < 0)
 		return fd;
 
diff --git a/src/syscall.c b/src/syscall.c
deleted file mode 100644
index 362f1f5..0000000
--- a/src/syscall.c
+++ /dev/null
@@ -1,47 +0,0 @@
-/* SPDX-License-Identifier: MIT */
-#define _DEFAULT_SOURCE
-
-/*
- * Functions in this file require libc, only build them when we use libc.
- *
- * Note:
- * liburing's tests still need these functions.
- */
-#if defined(CONFIG_NOLIBC) && !defined(LIBURING_BUILD_TEST)
-#error "This file should only be compiled for libc build, or for liburing tests"
-#endif
-
-/*
- * Will go away once libc support is there
- */
-#include <unistd.h>
-#include <sys/syscall.h>
-#include <sys/uio.h>
-#include "liburing/compat.h"
-#include "liburing/io_uring.h"
-#include "syscall.h"
-
-int __sys_io_uring_register(int fd, unsigned opcode, const void *arg,
-			    unsigned nr_args)
-{
-	return syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
-}
-
-int __sys_io_uring_setup(unsigned entries, struct io_uring_params *p)
-{
-	return syscall(__NR_io_uring_setup, entries, p);
-}
-
-int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
-			  unsigned flags, sigset_t *sig, int sz)
-{
-	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete, flags,
-		       sig, sz);
-}
-
-int __sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
-			 unsigned flags, sigset_t *sig)
-{
-	return __sys_io_uring_enter2(fd, to_submit, min_complete, flags, sig,
-				     _NSIG / 8);
-}
diff --git a/src/syscall.h b/src/syscall.h
index 73b04b4..ba008ea 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -85,17 +85,4 @@ static inline bool IS_ERR(const void *ptr)
 /* libc syscall wrappers. */
 #include "arch/generic/syscall.h"
 #endif
-
-/*
- * For backward compatibility.
- * (these __sys* functions always use libc, see syscall.c)
- */
-int __sys_io_uring_setup(unsigned entries, struct io_uring_params *p);
-int __sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
-			 unsigned flags, sigset_t *sig);
-int __sys_io_uring_enter2(int fd, unsigned to_submit, unsigned min_complete,
-			  unsigned flags, sigset_t *sig, int sz);
-int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
-			    unsigned int nr_args);
-
 #endif
diff --git a/test/Makefile b/test/Makefile
index 45674c3..e958a35 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -197,22 +197,10 @@ test_targets := $(patsubst %.cc,%,$(test_targets))
 run_test_targets := $(patsubst %,%.run_test,$(test_targets))
 test_targets := $(patsubst %,%.t,$(test_targets))
 all_targets += $(test_targets)
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
+helpers = helpers.o
 
 all: $(test_targets)
 
-../src/syscall.o: ../src/syscall.c
-	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
-
 helpers.o: helpers.c
 	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<
 
diff --git a/test/io_uring_enter.c b/test/io_uring_enter.c
index 941c5b7..429f6ef 100644
--- a/test/io_uring_enter.c
+++ b/test/io_uring_enter.c
@@ -39,13 +39,13 @@ static int expect_fail(int fd, unsigned int to_submit,
 	int ret;
 
 	ret = __sys_io_uring_enter(fd, to_submit, min_complete, flags, sig);
-	if (ret != -1) {
-		fprintf(stderr, "expected %s, but call succeeded\n", strerror(error));
+	if (ret >= 0) {
+		fprintf(stderr, "expected %s, but call succeeded\n", strerror(-error));
 		return 1;
 	}
 
-	if (errno != error) {
-		fprintf(stderr, "expected %d, got %d\n", error, errno);
+	if (ret != error) {
+		fprintf(stderr, "expected %d, got %d\n", error, ret);
 		return 1;
 	}
 
@@ -54,17 +54,17 @@ static int expect_fail(int fd, unsigned int to_submit,
 
 static int try_io_uring_enter(int fd, unsigned int to_submit,
 			      unsigned int min_complete, unsigned int flags,
-			      sigset_t *sig, int expect, int error)
+			      sigset_t *sig, int expect)
 {
 	int ret;
 
-	if (expect == -1)
-		return expect_fail(fd, to_submit, min_complete,
-				   flags, sig, error);
+	if (expect < 0)
+		return expect_fail(fd, to_submit, min_complete, flags, sig,
+				   expect);
 
 	ret = __sys_io_uring_enter(fd, to_submit, min_complete, flags, sig);
 	if (ret != expect) {
-		fprintf(stderr, "Expected %d, got %d\n", expect, errno);
+		fprintf(stderr, "Expected %d, got %d\n", expect, ret);
 		return 1;
 	}
 
@@ -197,16 +197,16 @@ int main(int argc, char **argv)
 	mask = *sq->kring_mask;
 
 	/* invalid flags */
-	status |= try_io_uring_enter(ring.ring_fd, 1, 0, ~0U, NULL, -1, EINVAL);
+	status |= try_io_uring_enter(ring.ring_fd, 1, 0, ~0U, NULL, -EINVAL);
 
 	/* invalid fd, EBADF */
-	status |= try_io_uring_enter(-1, 0, 0, 0, NULL, -1, EBADF);
+	status |= try_io_uring_enter(-1, 0, 0, 0, NULL, -EBADF);
 
 	/* valid, non-ring fd, EOPNOTSUPP */
-	status |= try_io_uring_enter(0, 0, 0, 0, NULL, -1, EOPNOTSUPP);
+	status |= try_io_uring_enter(0, 0, 0, 0, NULL, -EOPNOTSUPP);
 
 	/* to_submit: 0, flags: 0;  should get back 0. */
-	status |= try_io_uring_enter(ring.ring_fd, 0, 0, 0, NULL, 0, 0);
+	status |= try_io_uring_enter(ring.ring_fd, 0, 0, 0, NULL, 0);
 
 	/* fill the sq ring */
 	sq_entries = *ring.sq.kring_entries;
@@ -214,7 +214,7 @@ int main(int argc, char **argv)
 	ret = __sys_io_uring_enter(ring.ring_fd, 0, sq_entries,
 					IORING_ENTER_GETEVENTS, NULL);
 	if (ret < 0) {
-		perror("io_uring_enter");
+		fprintf(stderr, "io_uring_enter: %s\n", strerror(-ret));
 		status = 1;
 	} else {
 		/*
diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index 311bfdf..4609354 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -37,7 +37,7 @@ static int expect_fail(int fd, unsigned int opcode, void *arg,
 	int ret;
 
 	ret = __sys_io_uring_register(fd, opcode, arg, nr_args);
-	if (ret != -1) {
+	if (ret >= 0) {
 		int ret2 = 0;
 
 		fprintf(stderr, "expected %s, but call succeeded\n", strerror(error));
@@ -55,8 +55,8 @@ static int expect_fail(int fd, unsigned int opcode, void *arg,
 		return 1;
 	}
 
-	if (errno != error) {
-		fprintf(stderr, "expected %d, got %d\n", error, errno);
+	if (ret != error) {
+		fprintf(stderr, "expected %d, got %d\n", error, ret);
 		return 1;
 	}
 	return 0;
@@ -279,7 +279,7 @@ static int test_iovec_nr(int fd)
 		iovs[i].iov_len = pagesize;
 	}
 
-	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, iovs, nr, EINVAL);
+	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, iovs, nr, -EINVAL);
 
 	/* reduce to UIO_MAXIOV */
 	nr = UIO_MAXIOV;
@@ -310,12 +310,12 @@ static int test_iovec_size(int fd)
 	/* NULL pointer for base */
 	iov.iov_base = 0;
 	iov.iov_len = 4096;
-	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, &iov, 1, EFAULT);
+	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, &iov, 1, -EFAULT);
 
 	/* valid base, 0 length */
 	iov.iov_base = &buf;
 	iov.iov_len = 0;
-	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, &iov, 1, EFAULT);
+	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, &iov, 1, -EFAULT);
 
 	/* valid base, length exceeds size */
 	/* this requires an unampped page directly after buf */
@@ -326,7 +326,7 @@ static int test_iovec_size(int fd)
 	assert(ret == 0);
 	iov.iov_base = buf;
 	iov.iov_len = 2 * pagesize;
-	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, &iov, 1, EFAULT);
+	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, &iov, 1, -EFAULT);
 	munmap(buf, pagesize);
 
 	/* huge page */
@@ -346,20 +346,21 @@ static int test_iovec_size(int fd)
 		iov.iov_len = 2*1024*1024;
 		ret = __sys_io_uring_register(fd, IORING_REGISTER_BUFFERS, &iov, 1);
 		if (ret < 0) {
-			if (errno == ENOMEM)
+			if (ret == -ENOMEM)
 				printf("Unable to test registering of a huge "
 				       "page.  Try increasing the "
 				       "RLIMIT_MEMLOCK resource limit by at "
 				       "least 2MB.");
 			else {
-				fprintf(stderr, "expected success, got %d\n", errno);
+				fprintf(stderr, "expected success, got %d\n", ret);
 				status = 1;
 			}
 		} else {
 			ret = __sys_io_uring_register(fd,
 					IORING_UNREGISTER_BUFFERS, 0, 0);
 			if (ret < 0) {
-				perror("io_uring_unregister");
+				fprintf(stderr, "io_uring_unregister: %s\n",
+					strerror(-ret));
 				status = 1;
 			}
 		}
@@ -373,7 +374,7 @@ static int test_iovec_size(int fd)
 		status = 1;
 	iov.iov_base = buf;
 	iov.iov_len = 2*1024*1024;
-	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, &iov, 1, EOPNOTSUPP);
+	status |= expect_fail(fd, IORING_REGISTER_BUFFERS, &iov, 1, -EOPNOTSUPP);
 	munmap(buf, 2*1024*1024);
 
 	/* bump up against the soft limit and make sure we get EFAULT
@@ -401,7 +402,7 @@ static int ioring_poll(struct io_uring *ring, int fd, int fixed)
 
 	ret = io_uring_submit(ring);
 	if (ret != 1) {
-		fprintf(stderr, "failed to submit poll sqe: %d.\n", errno);
+		fprintf(stderr, "failed to submit poll sqe: %d.\n", ret);
 		return 1;
 	}
 
@@ -443,7 +444,7 @@ static int test_poll_ringfd(void)
 	 * fail, because the kernel does not allow registering of the
 	 * ring_fd.
 	 */
-	status |= expect_fail(fd, IORING_REGISTER_FILES, &fd, 1, EBADF);
+	status |= expect_fail(fd, IORING_REGISTER_FILES, &fd, 1, -EBADF);
 
 	/* tear down queue */
 	io_uring_queue_exit(&ring);
@@ -476,14 +477,14 @@ int main(int argc, char **argv)
 	}
 
 	/* invalid fd */
-	status |= expect_fail(-1, 0, NULL, 0, EBADF);
+	status |= expect_fail(-1, 0, NULL, 0, -EBADF);
 	/* valid fd that is not an io_uring fd */
-	status |= expect_fail(devnull, 0, NULL, 0, EOPNOTSUPP);
+	status |= expect_fail(devnull, 0, NULL, 0, -EOPNOTSUPP);
 
 	/* invalid opcode */
 	memset(&p, 0, sizeof(p));
 	fd = new_io_uring(1, &p);
-	ret = expect_fail(fd, ~0U, NULL, 0, EINVAL);
+	ret = expect_fail(fd, ~0U, NULL, 0, -EINVAL);
 	if (ret) {
 		/* if this succeeds, tear down the io_uring instance
 		 * and start clean for the next test. */
diff --git a/test/io_uring_setup.c b/test/io_uring_setup.c
index 3c50e2a..67d5f4f 100644
--- a/test/io_uring_setup.c
+++ b/test/io_uring_setup.c
@@ -98,9 +98,9 @@ dump_resv(struct io_uring_params *p)
 /* bogus: setup returns a valid fd on success... expect can't predict the
    fd we'll get, so this really only takes 1 parameter: error */
 int
-try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect, int error)
+try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect)
 {
-	int ret, err;
+	int ret;
 
 	ret = __sys_io_uring_setup(entries, p);
 	if (ret != expect) {
@@ -110,13 +110,13 @@ try_io_uring_setup(unsigned entries, struct io_uring_params *p, int expect, int
 			close(ret);
 		return 1;
 	}
-	err = errno;
-	if (expect == -1 && error != err) {
-		if (err == EPERM && geteuid() != 0) {
+
+	if (expect < 0 && expect != ret) {
+		if (ret == -EPERM && geteuid() != 0) {
 			printf("Needs root, not flagging as an error\n");
 			return 0;
 		}
-		fprintf(stderr, "expected errno %d, got %d\n", error, err);
+		fprintf(stderr, "expected errno %d, got %d\n", expect, ret);
 		return 1;
 	}
 
@@ -134,29 +134,29 @@ main(int argc, char **argv)
 		return T_EXIT_SKIP;
 
 	memset(&p, 0, sizeof(p));
-	status |= try_io_uring_setup(0, &p, -1, EINVAL);
-	status |= try_io_uring_setup(1, NULL, -1, EFAULT);
+	status |= try_io_uring_setup(0, &p, -EINVAL);
+	status |= try_io_uring_setup(1, NULL, -EFAULT);
 
 	/* resv array is non-zero */
 	memset(&p, 0, sizeof(p));
 	p.resv[0] = p.resv[1] = p.resv[2] = 1;
-	status |= try_io_uring_setup(1, &p, -1, EINVAL);
+	status |= try_io_uring_setup(1, &p, -EINVAL);
 
 	/* invalid flags */
 	memset(&p, 0, sizeof(p));
 	p.flags = ~0U;
-	status |= try_io_uring_setup(1, &p, -1, EINVAL);
+	status |= try_io_uring_setup(1, &p, -EINVAL);
 
 	/* IORING_SETUP_SQ_AFF set but not IORING_SETUP_SQPOLL */
 	memset(&p, 0, sizeof(p));
 	p.flags = IORING_SETUP_SQ_AFF;
-	status |= try_io_uring_setup(1, &p, -1, EINVAL);
+	status |= try_io_uring_setup(1, &p, -EINVAL);
 
 	/* attempt to bind to invalid cpu */
 	memset(&p, 0, sizeof(p));
 	p.flags = IORING_SETUP_SQPOLL | IORING_SETUP_SQ_AFF;
 	p.sq_thread_cpu = get_nprocs_conf();
-	status |= try_io_uring_setup(1, &p, -1, EINVAL);
+	status |= try_io_uring_setup(1, &p, -EINVAL);
 
 	/* I think we can limit a process to a set of cpus.  I assume
 	 * we shouldn't be able to setup a kernel thread outside of that.
@@ -167,7 +167,7 @@ main(int argc, char **argv)
 	fd = __sys_io_uring_setup(1, &p);
 	if (fd < 0) {
 		fprintf(stderr, "io_uring_setup failed with %d, expected success\n",
-		       errno);
+		       -fd);
 		status = 1;
 	} else {
 		char buf[4096];
diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
index 2d11d2a..ca380d8 100644
--- a/test/rsrc_tags.c
+++ b/test/rsrc_tags.c
@@ -40,7 +40,7 @@ static int register_rsrc(struct io_uring *ring, int type, int nr,
 			  const void *arg, const __u64 *tags)
 {
 	struct io_uring_rsrc_register reg;
-	int ret, reg_type;
+	int reg_type;
 
 	memset(&reg, 0, sizeof(reg));
 	reg.nr = nr;
@@ -51,9 +51,8 @@ static int register_rsrc(struct io_uring *ring, int type, int nr,
 	if (type != TEST_IORING_RSRC_FILE)
 		reg_type = IORING_REGISTER_BUFFERS2;
 
-	ret = __sys_io_uring_register(ring->ring_fd, reg_type,
-					&reg, sizeof(reg));
-	return ret ? -errno : 0;
+	return __sys_io_uring_register(ring->ring_fd, reg_type, &reg,
+				       sizeof(reg));
 }
 
 /*
@@ -64,7 +63,7 @@ static int update_rsrc(struct io_uring *ring, int type, int nr, int off,
 			const void *arg, const __u64 *tags)
 {
 	struct io_uring_rsrc_update2 up;
-	int ret, up_type;
+	int up_type;
 
 	memset(&up, 0, sizeof(up));
 	up.offset = off;
@@ -75,9 +74,7 @@ static int update_rsrc(struct io_uring *ring, int type, int nr, int off,
 	up_type = IORING_REGISTER_FILES_UPDATE2;
 	if (type != TEST_IORING_RSRC_FILE)
 		up_type = IORING_REGISTER_BUFFERS_UPDATE;
-	ret = __sys_io_uring_register(ring->ring_fd, up_type,
-				      &up, sizeof(up));
-	return ret < 0 ? -errno : ret;
+	return __sys_io_uring_register(ring->ring_fd, up_type, &up, sizeof(up));
 }
 
 static bool has_rsrc_update(void)

base-commit: 4e6eec8bdea906fe5341c97aef96986d605004e9
-- 
Ammar Faizi

