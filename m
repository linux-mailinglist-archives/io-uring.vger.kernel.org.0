Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF857564743
	for <lists+io-uring@lfdr.de>; Sun,  3 Jul 2022 14:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiGCMYm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jul 2022 08:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGCMYm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jul 2022 08:24:42 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66A9559B
        for <io-uring@vger.kernel.org>; Sun,  3 Jul 2022 05:24:40 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        by gnuweeb.org (Postfix) with ESMTPSA id 75033801F3
        for <io-uring@vger.kernel.org>; Sun,  3 Jul 2022 12:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656851080;
        bh=hWdSff/FKBXSjb9Ti/71PKNERWEenDdtJqRsU52OBHw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ar4S4PVWJlE3CV1PYoMYWuH3snZoaspp/J8hoBMFQonHnVnE5jUMM1446vgDc3Krc
         YoNL+7/uMfUqZODmmZ3mjC21nEnRzJ9VEvaiLm2gWWrKmnmdaikBw/f0lOdtDtzb8M
         DvXVxp9bKtq+Yw0DW4lBR9yw/AvdKOtnXXhQQTjB0yEf7E4a+emRSTXdgET3DrlSmM
         gmar3spAxXSlrxFvtMbKGBUyKQ1LuruC/iZfpppV6z+Bwc2TVGTtWar8VqSG4Vdj2F
         ntICbZ3bXKKRWAGOe9SwqhUb4VA4FQwON8HNFGIQ5Mi4vj4/RMz2u0kgVYip56q7jR
         TwmjAhlroBqwA==
Received: by mail-lj1-f169.google.com with SMTP id a39so7841259ljq.11
        for <io-uring@vger.kernel.org>; Sun, 03 Jul 2022 05:24:40 -0700 (PDT)
X-Gm-Message-State: AJIora8um62LDrhh6TksEeYEEPYkteLYcC/sze0bluZYF7p5A4MQFo0f
        KarAzMX9DuGGAfxw0a3py7W9aaBvS6LVP0xo770=
X-Google-Smtp-Source: AGRyM1vD6HYy+WT+ogYFkZMeQAEt2/J/HDPzdsbcKScHvphamI7AfagCZvp+hYNifrhgzlMwddPYLhGuqAy8PNHzxXQ=
X-Received: by 2002:a2e:a485:0:b0:25a:735c:9f41 with SMTP id
 h5-20020a2ea485000000b0025a735c9f41mr12839290lji.389.1656851078596; Sun, 03
 Jul 2022 05:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220703115240.215695-1-ammar.faizi@intel.com> <20220703115240.215695-3-ammar.faizi@intel.com>
In-Reply-To: <20220703115240.215695-3-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Sun, 3 Jul 2022 19:24:27 +0700
X-Gmail-Original-Message-ID: <CAOG64qPR4QKLu8+GgeSBFyDQMUvBCPyZEoRtnMwbu_3dS385DA@mail.gmail.com>
Message-ID: <CAOG64qPR4QKLu8+GgeSBFyDQMUvBCPyZEoRtnMwbu_3dS385DA@mail.gmail.com>
Subject: Re: [PATCH liburing v1 2/2] setup: Mark the exported functions as __cold
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 3, 2022 at 6:59 PM Ammar Faizi wrote:
>
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> These functions are called at initialization, which are slow-paths.
> Mark them as __cold so that the compiler will optimize for code size.
>
> Here is the result compiling with Ubuntu clang
> 15.0.0-++20220601012204+ec2711b35411-1~exp1~20220601012300.510
>
> Without this patch:
>
>   $ wc -c src/liburing.so.2.3
>   71288 src/liburing.so.2.3
>
> With this patch:
>
>   $ wc -c src/liburing.so.2.3
>   69448 src/liburing.so.2.3
>
> Take one slow-path function example, using __cold avoids aggresive
> inlining.
>
> Without this patch:
>
>   00000000000024f0 <io_uring_queue_init>:
>     24f0: pushq  %r14
>     24f2: pushq  %rbx
>     24f3: subq   $0x78,%rsp
>     24f7: movq   %rsi,%r14
>     24fa: xorps  %xmm0,%xmm0
>     24fd: movaps %xmm0,(%rsp)
>     2501: movaps %xmm0,0x60(%rsp)
>     2506: movaps %xmm0,0x50(%rsp)
>     250b: movaps %xmm0,0x40(%rsp)
>     2510: movaps %xmm0,0x30(%rsp)
>     2515: movaps %xmm0,0x20(%rsp)
>     251a: movaps %xmm0,0x10(%rsp)
>     251f: movq   $0x0,0x70(%rsp)
>     2528: movl   %edx,0x8(%rsp)
>     252c: movq   %rsp,%rsi
>     252f: movl   $0x1a9,%eax
>     2534: syscall
>     2536: movq   %rax,%rbx
>     2539: testl  %ebx,%ebx
>     253b: js     256a <io_uring_queue_init+0x7a>
>     253d: movq   %rsp,%rsi
>     2540: movl   %ebx,%edi
>     2542: movq   %r14,%rdx
>     2545: callq  2080 <io_uring_queue_mmap@plt>
>     254a: testl  %eax,%eax
>     254c: je     255d <io_uring_queue_init+0x6d>
>     254e: movl   %eax,%edx
>     2550: movl   $0x3,%eax
>     2555: movl   %ebx,%edi
>     2557: syscall
>     2559: movl   %edx,%ebx
>     255b: jmp    256a <io_uring_queue_init+0x7a>
>     255d: movl   0x14(%rsp),%eax
>     2561: movl   %eax,0xc8(%r14)
>     2568: xorl   %ebx,%ebx
>     256a: movl   %ebx,%eax
>     256c: addq   $0x78,%rsp
>     2570: popq   %rbx
>     2571: popq   %r14
>     2573: retq
>
> With this patch:
>
>   000000000000240c <io_uring_queue_init>:
>     240c: subq   $0x78,%rsp
>     2410: xorps  %xmm0,%xmm0
>     2413: movq   %rsp,%rax
>     2416: movaps %xmm0,(%rax)
>     2419: movaps %xmm0,0x60(%rax)
>     241d: movaps %xmm0,0x50(%rax)
>     2421: movaps %xmm0,0x40(%rax)
>     2425: movaps %xmm0,0x30(%rax)
>     2429: movaps %xmm0,0x20(%rax)
>     242d: movaps %xmm0,0x10(%rax)
>     2431: movq   $0x0,0x70(%rax)
>     2439: movl   %edx,0x8(%rax)
>     243c: movq   %rax,%rdx
>     243f: callq  2090 <io_uring_queue_init_params@plt>
>     2444: addq   $0x78,%rsp
>     2448: retq
>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
