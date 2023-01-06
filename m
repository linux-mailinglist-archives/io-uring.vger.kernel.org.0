Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FDD6603A0
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 16:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjAFPnU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 10:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjAFPnT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 10:43:19 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54273D5FA
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 07:43:18 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 32A2D7E3C7;
        Fri,  6 Jan 2023 15:43:15 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673019798;
        bh=FANsrJvFg39qFeGYuVJwpL+yRHSuzVVlTCWLyaOaKiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8jxLOqUtK6vdoVZNgILWm0z/2KBtRt38ddzKVh35tqoG/nhm+wLm+LEQ0UTCYh1w
         dxIVCYZ4kSrcaEVgpbK03jdDJhbGK8OLoiEs277cGoyudBSSJIivIvU2IkBil8fowT
         nAByu1lT4J9zss5LuaMJMSxt5SD2iKK7CSOTkWS0aA3Qjns7WmhnLQKIRTo0+v0FxH
         FKQ4NLC3cp5o8J9ZuSA1qKMr4pUwGywROcIakwjEwvciAlO7u7SYAP80Qx/m/2Zo6j
         wJy8zWD4Jr7egTPQFIDf8a1f+LwP9Xm9SERuj6Jg/cDZS3iZnEV1Wkny2jfnBZ9b8A
         yBhvrKTT/TUQg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: [PATCH liburing v1 2/2] register: Simplify `io_uring_register_file_alloc_range()` function
Date:   Fri,  6 Jan 2023 22:42:59 +0700
Message-Id: <20230106154259.556542-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106154259.556542-1-ammar.faizi@intel.com>
References: <20230106154259.556542-1-ammar.faizi@intel.com>
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

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Use a struct initializer instead of memset(). It simplifies the C code
plus effectively reduces the code size.

Extra bonus on x86-64. It reduces the stack allocation because it
doesn't need to allocate stack for the local variable @range. It can
just use 128 bytes of redzone below the `%rsp` (redzone is only
available in a leaf function).

Before this patch:

```
  0000000000003910 <io_uring_register_file_alloc_range>:
    3910:  push   %rbp
    3911:  push   %r15
    3913:  push   %r14
    3915:  push   %rbx
    3916:  sub    $0x18,%rsp
    391a:  mov    %edx,%r14d
    391d:  mov    %esi,%ebp
    391f:  mov    %rdi,%rbx
    3922:  lea    0x8(%rsp),%r15
    3927:  mov    $0x10,%edx
    392c:  mov    %r15,%rdi
    392f:  xor    %esi,%esi
    3931:  call   3a00 <__uring_memset>
    3936:  mov    %ebp,0x8(%rsp)
    393a:  mov    %r14d,0xc(%rsp)
    393f:  mov    0xc4(%rbx),%edi
    3945:  mov    $0x1ab,%eax
    394a:  mov    $0x19,%esi
    394f:  mov    %r15,%rdx
    3952:  xor    %r10d,%r10d
    3955:  syscall
    3957:  add    $0x18,%rsp
    395b:  pop    %rbx
    395c:  pop    %r14
    395e:  pop    %r15
    3960:  pop    %rbp
    3961:  ret
    3962:  cs nopw 0x0(%rax,%rax,1)
    396c:  nopl   0x0(%rax)
```

After this patch:

```
  0000000000003910 <io_uring_register_file_alloc_range>:
    3910:  mov    %esi,-0x10(%rsp) # set range.off
    3914:  mov    %edx,-0xc(%rsp)  # set range.len
    3918:  movq   $0x0,-0x8(%rsp)  # zero the resv
    3921:  mov    0xc4(%rdi),%edi
    3927:  lea    -0x10(%rsp),%rdx
    392c:  mov    $0x1ab,%eax
    3931:  mov    $0x19,%esi
    3936:  xor    %r10d,%r10d
    3939:  syscall
    393b:  ret
```

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/register.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/src/register.c b/src/register.c
index 5fdc6e5..ac4c9e3 100644
--- a/src/register.c
+++ b/src/register.c
@@ -333,11 +333,10 @@ int io_uring_register_sync_cancel(struct io_uring *ring,
 int io_uring_register_file_alloc_range(struct io_uring *ring,
 					unsigned off, unsigned len)
 {
-	struct io_uring_file_index_range range;
-
-	memset(&range, 0, sizeof(range));
-	range.off = off;
-	range.len = len;
+	struct io_uring_file_index_range range = {
+		.off = off,
+		.len = len
+	};
 
 	return __sys_io_uring_register(ring->ring_fd,
 				       IORING_REGISTER_FILE_ALLOC_RANGE, &range,
-- 
Ammar Faizi

