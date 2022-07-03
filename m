Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A41564738
	for <lists+io-uring@lfdr.de>; Sun,  3 Jul 2022 14:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbiGCMAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jul 2022 08:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGCMA3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jul 2022 08:00:29 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F6DAE44
        for <io-uring@vger.kernel.org>; Sun,  3 Jul 2022 05:00:28 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id C73508018E;
        Sun,  3 Jul 2022 12:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656849628;
        bh=6ixysMJEI/NXhltM7GfMgHUkYnnZyyw11I6A9dx6ux8=;
        h=From:To:Cc:Subject:Date:From;
        b=U4EkeMeVq1K8MyvhVIk4LkXDq5Rh6hN/hbtej/07SqJK+g6oZc2fF51U1+44Zuweb
         IO1UTSXhkSgZwQ+BhcFsLycxgU2mtjnMmvl43Fa4aFrmVTRxaP5CGmJCom2EjAjS//
         w2u3HmWIuvFKGPY93Uljj8t8n1jvAT9kyn+wlCmAu4eQaB/LDFWgvmaw8HkF1Jmnu5
         qNHi3Fcz4Xa1pcENJ3pdhnJd5qP2BfPwg8esA98vgT84pNkh4XEp2gTcL1xgxNBotN
         kBx+HeZmksBjKv/QEI+6oDaR8TjFhbqAmF3MYejZfV8z4zCuIJ8BtZiFTKWrn2BzKa
         qQc2AAV86l/Eg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 0/2] __hot and __cold
Date:   Sun,  3 Jul 2022 18:59:10 +0700
Message-Id: <20220703115240.215695-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
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

Hi Jens,

This series adds __hot and __cold macros. Currently, the __hot macro
is not used. The __cold annotation hints the compiler to optimize for
code size. This is good for the slow-path in the setup.c file.

Here is the result compiling with Ubuntu clang
15.0.0-++20220601012204+ec2711b35411-1~exp1~20220601012300.510

Without this patchset:

  $ wc -c src/liburing.so.2.3
  71288 src/liburing.so.2.3

With this patchset:

  $ wc -c src/liburing.so.2.3
  69448 src/liburing.so.2.3

Take one slow-path function example, using __cold avoids aggresive
inlining.

Without this patchset:

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

With this patchset:

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

Ammar Faizi (2):
  lib: Add __hot and __cold macros
  setup: Mark the exported functions as __cold

 src/lib.h   |  2 ++
 src/setup.c | 25 ++++++++++++++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)


base-commit: 98c14a04e2c0dcdfbb71372a1a209ed889fb3e4d
-- 
Ammar Faizi

