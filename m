Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE7656473A
	for <lists+io-uring@lfdr.de>; Sun,  3 Jul 2022 14:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiGCMAf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jul 2022 08:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGCMAe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jul 2022 08:00:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23389AE50
        for <io-uring@vger.kernel.org>; Sun,  3 Jul 2022 05:00:34 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 855FF801C7;
        Sun,  3 Jul 2022 12:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656849633;
        bh=7IW/KH9krLSj5qXICwhCpREF8tIhi13EhO8qjdXCW44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ug2mOvlJSfpopymkZlOGNsmAsMPNUYalJosilHpR3Cm/R03IAe4Kh17rVgCqCXTm4
         sJJBoMA0Tn5H2RhSsI/VfcZTvRtlT1QpMqvBKE/qKtGAnCAtCmlbb2czo0guiH1MQq
         +0kQ70jsl6bBzRfp7B2aGzkgqKMjVR/lqf7Ij/4kqTOjYshuyl57LTTUIRLEwhxGYf
         JYoBeF1RJ1R0XbuC2MdvcUR6BDfW99HGbYApHOXM61H2j9xyWmkBIm6Z/Gq9TNAZ2C
         2vEsOBgyN/+9XMerm0UNy/p1xetOxLp2cJmNDN/wVm7yf78E0O46kvhTT10ht//jgH
         Ei8SVAvOESHZA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 2/2] setup: Mark the exported functions as __cold
Date:   Sun,  3 Jul 2022 18:59:12 +0700
Message-Id: <20220703115240.215695-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220703115240.215695-1-ammar.faizi@intel.com>
References: <20220703115240.215695-1-ammar.faizi@intel.com>
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

These functions are called at initialization, which are slow-paths.
Mark them as __cold so that the compiler will optimize for code size.

Here is the result compiling with Ubuntu clang
15.0.0-++20220601012204+ec2711b35411-1~exp1~20220601012300.510

Without this patch:

  $ wc -c src/liburing.so.2.3
  71288 src/liburing.so.2.3

With this patch:

  $ wc -c src/liburing.so.2.3
  69448 src/liburing.so.2.3

Take one slow-path function example, using __cold avoids aggresive
inlining.

Without this patch:

  00000000000024f0 <io_uring_queue_init>:
    24f0: pushq  %r14
    24f2: pushq  %rbx
    24f3: subq   $0x78,%rsp
    24f7: movq   %rsi,%r14
    24fa: xorps  %xmm0,%xmm0
    24fd: movaps %xmm0,(%rsp)
    2501: movaps %xmm0,0x60(%rsp)
    2506: movaps %xmm0,0x50(%rsp)
    250b: movaps %xmm0,0x40(%rsp)
    2510: movaps %xmm0,0x30(%rsp)
    2515: movaps %xmm0,0x20(%rsp)
    251a: movaps %xmm0,0x10(%rsp)
    251f: movq   $0x0,0x70(%rsp)
    2528: movl   %edx,0x8(%rsp)
    252c: movq   %rsp,%rsi
    252f: movl   $0x1a9,%eax
    2534: syscall
    2536: movq   %rax,%rbx
    2539: testl  %ebx,%ebx
    253b: js     256a <io_uring_queue_init+0x7a>
    253d: movq   %rsp,%rsi
    2540: movl   %ebx,%edi
    2542: movq   %r14,%rdx
    2545: callq  2080 <io_uring_queue_mmap@plt>
    254a: testl  %eax,%eax
    254c: je     255d <io_uring_queue_init+0x6d>
    254e: movl   %eax,%edx
    2550: movl   $0x3,%eax
    2555: movl   %ebx,%edi
    2557: syscall
    2559: movl   %edx,%ebx
    255b: jmp    256a <io_uring_queue_init+0x7a>
    255d: movl   0x14(%rsp),%eax
    2561: movl   %eax,0xc8(%r14)
    2568: xorl   %ebx,%ebx
    256a: movl   %ebx,%eax
    256c: addq   $0x78,%rsp
    2570: popq   %rbx
    2571: popq   %r14
    2573: retq

With this patch:

  000000000000240c <io_uring_queue_init>:
    240c: subq   $0x78,%rsp
    2410: xorps  %xmm0,%xmm0
    2413: movq   %rsp,%rax
    2416: movaps %xmm0,(%rax)
    2419: movaps %xmm0,0x60(%rax)
    241d: movaps %xmm0,0x50(%rax)
    2421: movaps %xmm0,0x40(%rax)
    2425: movaps %xmm0,0x30(%rax)
    2429: movaps %xmm0,0x20(%rax)
    242d: movaps %xmm0,0x10(%rax)
    2431: movq   $0x0,0x70(%rax)
    2439: movl   %edx,0x8(%rax)
    243c: movq   %rax,%rdx
    243f: callq  2090 <io_uring_queue_init_params@plt>
    2444: addq   $0x78,%rsp
    2448: retq

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/setup.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/src/setup.c b/src/setup.c
index d2adc7f..2badcc1 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -89,7 +89,8 @@ err:
  * Returns -errno on error, or zero on success.  On success, 'ring'
  * contains the necessary information to read/write to the rings.
  */
-int io_uring_queue_mmap(int fd, struct io_uring_params *p, struct io_uring *ring)
+__cold int io_uring_queue_mmap(int fd, struct io_uring_params *p,
+			       struct io_uring *ring)
 {
 	int ret;
 
@@ -107,7 +108,7 @@ int io_uring_queue_mmap(int fd, struct io_uring_params *p, struct io_uring *ring
  * Ensure that the mmap'ed rings aren't available to a child after a fork(2).
  * This uses madvise(..., MADV_DONTFORK) on the mmap'ed ranges.
  */
-int io_uring_ring_dontfork(struct io_uring *ring)
+__cold int io_uring_ring_dontfork(struct io_uring *ring)
 {
 	size_t len;
 	int ret;
@@ -138,8 +139,8 @@ int io_uring_ring_dontfork(struct io_uring *ring)
 	return 0;
 }
 
-int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
-			       struct io_uring_params *p)
+__cold int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
+				      struct io_uring_params *p)
 {
 	int fd, ret;
 
@@ -161,7 +162,8 @@ int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
  * Returns -errno on error, or zero on success. On success, 'ring'
  * contains the necessary information to read/write to the rings.
  */
-int io_uring_queue_init(unsigned entries, struct io_uring *ring, unsigned flags)
+__cold int io_uring_queue_init(unsigned entries, struct io_uring *ring,
+			       unsigned flags)
 {
 	struct io_uring_params p;
 
@@ -171,7 +173,7 @@ int io_uring_queue_init(unsigned entries, struct io_uring *ring, unsigned flags)
 	return io_uring_queue_init_params(entries, ring, &p);
 }
 
-void io_uring_queue_exit(struct io_uring *ring)
+__cold void io_uring_queue_exit(struct io_uring *ring)
 {
 	struct io_uring_sq *sq = &ring->sq;
 	struct io_uring_cq *cq = &ring->cq;
@@ -191,7 +193,7 @@ void io_uring_queue_exit(struct io_uring *ring)
 	__sys_close(ring->ring_fd);
 }
 
-struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
+__cold struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
 {
 	struct io_uring_probe *probe;
 	size_t len;
@@ -211,7 +213,7 @@ struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
 	return NULL;
 }
 
-struct io_uring_probe *io_uring_get_probe(void)
+__cold struct io_uring_probe *io_uring_get_probe(void)
 {
 	struct io_uring ring;
 	struct io_uring_probe *probe;
@@ -226,7 +228,7 @@ struct io_uring_probe *io_uring_get_probe(void)
 	return probe;
 }
 
-void io_uring_free_probe(struct io_uring_probe *probe)
+__cold void io_uring_free_probe(struct io_uring_probe *probe)
 {
 	uring_free(probe);
 }
@@ -284,7 +286,8 @@ static size_t rings_size(struct io_uring_params *p, unsigned entries,
  * return the required memory so that the caller can ensure that enough space
  * is available before setting up a ring with the specified parameters.
  */
-ssize_t io_uring_mlock_size_params(unsigned entries, struct io_uring_params *p)
+__cold ssize_t io_uring_mlock_size_params(unsigned entries,
+					  struct io_uring_params *p)
 {
 	struct io_uring_params lp = { };
 	struct io_uring ring;
@@ -343,7 +346,7 @@ ssize_t io_uring_mlock_size_params(unsigned entries, struct io_uring_params *p)
  * Return required ulimit -l memory space for a given ring setup. See
  * @io_uring_mlock_size_params().
  */
-ssize_t io_uring_mlock_size(unsigned entries, unsigned flags)
+__cold ssize_t io_uring_mlock_size(unsigned entries, unsigned flags)
 {
 	struct io_uring_params p = { .flags = flags, };
 
-- 
Ammar Faizi

