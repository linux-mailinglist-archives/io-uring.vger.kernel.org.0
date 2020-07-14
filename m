Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BD721EA6D
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 09:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgGNHld (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jul 2020 03:41:33 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:39375 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNHlc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jul 2020 03:41:32 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 8BCAA240007;
        Tue, 14 Jul 2020 07:41:28 +0000 (UTC)
Date:   Tue, 14 Jul 2020 00:41:26 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH] tools: io_uring-bench: rename gettid to avoid conflict with
 glibc
Message-ID: <0d4af5e77c9f5f3fe490f0287072084ed8624c56.1594712356.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Current glibc defines a gettid function, which results in the following error:

io_uring-bench.c:133:12: error: static declaration of ‘gettid’ follows non-static declaration
  133 | static int gettid(void)
      |            ^~~~~~
In file included from /usr/include/unistd.h:1170,
                 from io_uring-bench.c:27:
/usr/include/x86_64-linux-gnu/bits/unistd_ext.h:34:16: note: previous declaration of ‘gettid’ was here
   34 | extern __pid_t gettid (void) __THROW;
      |                ^~~~~~

Rename the syscall-based gettid to sys_gettid to avoid a name conflict.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
Another alternative would be for io_uring-bench to count on recent
glibc, and call settid without defining its own version.

 tools/io_uring/io_uring-bench.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/io_uring/io_uring-bench.c b/tools/io_uring/io_uring-bench.c
index 0f257139b003..850f0ee90828 100644
--- a/tools/io_uring/io_uring-bench.c
+++ b/tools/io_uring/io_uring-bench.c
@@ -130,7 +130,7 @@ static int io_uring_register_files(struct submitter *s)
 					s->nr_files);
 }
 
-static int gettid(void)
+static int sys_gettid(void)
 {
 	return syscall(__NR_gettid);
 }
@@ -281,7 +281,7 @@ static void *submitter_fn(void *data)
 	struct io_sq_ring *ring = &s->sq_ring;
 	int ret, prepped;
 
-	printf("submitter=%d\n", gettid());
+	printf("submitter=%d\n", sys_gettid());
 
 	srand48_r(pthread_self(), &s->rand);
 
-- 
2.28.0.rc0

