Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6211373ACAF
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 00:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjFVWuA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 18:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjFVWt7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 18:49:59 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFE21BD3;
        Thu, 22 Jun 2023 15:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687474197;
        bh=GaDQ9JqTnH4ql7tm/PH+lPX5ScztcQCWp8V1WHR2uL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=ZO4RrMe6kl/hDCx8MMxQ7//zvdnLJpOzDQq8vZsmjue1MW+sbMoLlIiZZiHASO1b1
         dLPLYUQ0bqMjGQ7k6jzP15G2OQU6iaflTELX18eco/6C8/KBUk+dVW8K+WyzEhA1mt
         yvnmK1IMI13vOSXOsbQ5qoTcRY0h16v4fXV9wWr/EmiTvp0pFGDptZNEhoxjJnXpjX
         MnQQzC0Ab1idFQqeCChslOcleE8jbwX5sKkvxqsdjpTRifnnTfRulgNB2ddu1vCvGE
         Ee1zYcEO0t0X2LAdDG0yVp7YXjBN35rrQz3L6Sbln5e+ArsWxT8gFNb639OtYVKmFa
         PXQK6+e7SKDTg==
Received: from biznet-home.integral.gnuweeb.org (unknown [68.183.184.174])
        by gnuweeb.org (Postfix) with ESMTPSA id B119B249DA7;
        Fri, 23 Jun 2023 05:49:53 +0700 (WIB)
Date:   Fri, 23 Jun 2023 05:49:49 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas@t-8ch.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Guillem Jover <guillem@hadrons.org>,
        Jeff Moyer <jmoyer@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael William Jonathan <moe@gnuweeb.org>,
        Matthew Patrick <ThePhoenix576@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: Re: [RFC PATCH liburing v1 3/3] src/Makefile: Allow using stack
 protector with libc
Message-ID: <ZJTQDaAsN/e7irCa@biznet-home.integral.gnuweeb.org>
References: <20230622172029.726710-1-ammarfaizi2@gnuweeb.org>
 <20230622172029.726710-4-ammarfaizi2@gnuweeb.org>
 <6734a933-6e61-45b1-969c-1767f1aad43b@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6734a933-6e61-45b1-969c-1767f1aad43b@t-8ch.de>
X-Bpl:  hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 22, 2023 at 07:57:38PM +0200, Thomas Weißschuh wrote:
> There are patches in the pipeline that enable stackprotector support for
> nolibc [0]. They should land in 6.5.

That's interesting. I haven't been following Willy's tree for a while.
Hope 6.4 stable goes well by the end of this week.

> It only supports "global" mode and not per-thread-data.
> But as nolibc does not support threads anyways that should not matter.
> A compiler flag has to be passed though, but that can be automated [1].
> 
> So the -fno-stack-protector can probably be removed completely.
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/tree/tools/include/nolibc/stackprotector.h?h=dev.2023.06.16a
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/tree/tools/testing/selftests/nolibc/Makefile?h=dev.2023.06.16a#n81

This is a bit problematic because liburing.so and liburing.a must also
be compatible with apps that use libc. Note that liburing nolibc is also
used by apps that use libc.

The problem when an app uses libc.so and liburing.a:

Stack-protector functions from liburing nolibc will override the
stack-protector functions from libc because statically linked functions
will take precedence. The end result, the app will always use the
"global" mode stack protector even if it's multithreaded. There may be a
way to make those functions private to liburing only, but I don't know.

We had a similar problem with memset() in liburing:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/liburing.git/commit/?id=db5403e58083bef48d72656d7dea53a9f7affef4

Also, the app has to be compiled with those specific flags, which is out
of our control. Plus, I wonder if there is a chance to call
__stack_chk_init() from a static library point of view where we don't
control the entry point (__start).

Therefore, I won't implement the stack protector for liburing under
CONFIG_NOLIBC enabled. So far, I see that using the stack protector for
liburing nolibc is more trouble than it's worth.

But anyway, it's nice to see your stack protector work.

Regards,
-- 
Ammar Faizi

