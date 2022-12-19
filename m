Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4293650F50
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbiLSPxg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiLSPxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:53:07 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81A113D6A
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:50:36 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id 091AB8191C;
        Mon, 19 Dec 2022 15:50:33 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671465036;
        bh=ms/xp3631C8/NzQzavvt9KMEMJkJxT0MXN4ilU9Nqsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPcLjS0qjYNIz8+ESvQZtjizU0J7473HYcKbjMEfl9JfGEaRqMYHfQ6ZtboSLsZPM
         eisppRhfOa9mzMkyFwOSJiSrNUWVK4atLke2hnKOZ1kI+g4TiTYZN3h6x4Mhab/vAm
         RkmdN8dPJVkhSbvUUoQfklXysiZuZKYiEOgRitmyZEsrqi8zEj8LCOOJYwxQyk7TIv
         C3CY5XeLvRY7gjWvHwHK05B7Npm+v6G3oaY394kMKJurpMqD+HcSYR7wp0Bka9QdFX
         imrJDjNCFjrxcbNbAvASfZgyszH49jhrLeNPjt9W1+gOme0pTjCcTFWPqanS/U4J/R
         9tw6rbNEOPVxg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1 3/8] tests: Fix `-Wstrict-prototypes` warnings from Clang
Date:   Mon, 19 Dec 2022 22:49:55 +0700
Message-Id: <20221219155000.2412524-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219155000.2412524-1-ammar.faizi@intel.com>
References: <20221219155000.2412524-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a preparation patch to integrate -Wstrict-prototypes flag to
the GitHub CI robot. Clang says:

  warning: a function declaration without a prototype is \
  deprecated in all versions of C [-Wstrict-prototypes]

Make sure we put "void" in the argument list of the function
declaration if the function doesn't accept any argument.

Reproducer (with clang-16):

  ./configure --cc=clang --cxx=clang++;
  CFLAGS="-Wall -Wextra -Wstrict-prototypes" make -j8;

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/35fa71a030ca.c        | 2 +-
 test/a4c0b3decb33.c        | 2 +-
 test/accept.c              | 2 +-
 test/fc2a85cb02ef.c        | 2 +-
 test/pollfree.c            | 2 +-
 test/sqpoll-disable-exit.c | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/test/35fa71a030ca.c b/test/35fa71a030ca.c
index fc1a419..5540d8d 100644
--- a/test/35fa71a030ca.c
+++ b/test/35fa71a030ca.c
@@ -169,21 +169,21 @@ static void kill_and_wait(int pid, int* status)
       close(fd);
     }
     closedir(dir);
   } else {
   }
   while (waitpid(-1, status, __WALL) != pid) {
   }
 }
 
 #define SYZ_HAVE_SETUP_TEST 1
-static void setup_test()
+static void setup_test(void)
 {
   prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
   setpgrp();
   write_file("/proc/self/oom_score_adj", "1000");
 }
 
 struct thread_t {
   int created, call;
   event_t ready, done;
 };
diff --git a/test/a4c0b3decb33.c b/test/a4c0b3decb33.c
index eb9587c..626f60a 100644
--- a/test/a4c0b3decb33.c
+++ b/test/a4c0b3decb33.c
@@ -88,21 +88,21 @@ static void kill_and_wait(int pid, int* status)
 			}
 			close(fd);
 		}
 		closedir(dir);
 	} else {
 	}
 	while (waitpid(-1, status, __WALL) != pid) {
 	}
 }
 
-static void setup_test()
+static void setup_test(void)
 {
 	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
 	setpgrp();
 	write_file("/proc/self/oom_score_adj", "1000");
 }
 
 static void execute_one(void);
 
 #define WAIT_FLAGS __WALL
 
diff --git a/test/accept.c b/test/accept.c
index 1821faa..61737fa 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -604,21 +604,21 @@ static int test_multishot_accept(int count, bool before, bool overflow)
 	if (no_accept_multi)
 		return T_EXIT_SKIP;
 
 	ret = io_uring_queue_init(MAX_FDS + 10, &m_io_uring, 0);
 	assert(ret >= 0);
 	ret = test(&m_io_uring, args);
 	io_uring_queue_exit(&m_io_uring);
 	return ret;
 }
 
-static int test_accept_multishot_wrong_arg()
+static int test_accept_multishot_wrong_arg(void)
 {
 	struct io_uring m_io_uring;
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	int fd, ret;
 
 	ret = io_uring_queue_init(4, &m_io_uring, 0);
 	assert(ret >= 0);
 
 	fd = start_accept_listen(NULL, 0, 0);
diff --git a/test/fc2a85cb02ef.c b/test/fc2a85cb02ef.c
index 6fd5fd8..c828f67 100644
--- a/test/fc2a85cb02ef.c
+++ b/test/fc2a85cb02ef.c
@@ -47,21 +47,21 @@ static int inject_fault(int nth)
   fd = open("/proc/thread-self/fail-nth", O_RDWR);
   if (fd == -1)
     exit(1);
   char buf[16];
   sprintf(buf, "%d", nth + 1);
   if (write(fd, buf, strlen(buf)) != (ssize_t)strlen(buf))
     exit(1);
   return fd;
 }
 
-static int setup_fault()
+static int setup_fault(void)
 {
   static struct {
     const char* file;
     const char* val;
     bool fatal;
   } files[] = {
       {"/sys/kernel/debug/failslab/ignore-gfp-wait", "N", true},
       {"/sys/kernel/debug/failslab/verbose", "0", false},
       {"/sys/kernel/debug/fail_futex/ignore-private", "N", false},
       {"/sys/kernel/debug/fail_page_alloc/verbose", "0", false},
diff --git a/test/pollfree.c b/test/pollfree.c
index d753ffe..ebd88b1 100644
--- a/test/pollfree.c
+++ b/test/pollfree.c
@@ -245,21 +245,21 @@ static void kill_and_wait(int pid, int* status)
       }
       close(fd);
     }
     closedir(dir);
   } else {
   }
   while (waitpid(-1, status, __WALL) != pid) {
   }
 }
 
-static void setup_test()
+static void setup_test(void)
 {
   prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
   setpgrp();
 }
 
 struct thread_t {
   int created, call;
   event_t ready, done;
 };
 
diff --git a/test/sqpoll-disable-exit.c b/test/sqpoll-disable-exit.c
index 76b6cf5..5283702 100644
--- a/test/sqpoll-disable-exit.c
+++ b/test/sqpoll-disable-exit.c
@@ -129,21 +129,21 @@ static void kill_and_wait(int pid, int* status)
       }
       close(fd);
     }
     closedir(dir);
   } else {
   }
   while (waitpid(-1, status, __WALL) != pid) {
   }
 }
 
-static void setup_test()
+static void setup_test(void)
 {
   prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
   setpgrp();
   write_file("/proc/self/oom_score_adj", "1000");
 }
 
 static void execute_one(void);
 
 #define WAIT_FLAGS __WALL
 
-- 
Ammar Faizi

