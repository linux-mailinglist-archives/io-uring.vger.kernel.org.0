Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A370473A7D4
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 19:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjFVR5p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 13:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjFVR5o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 13:57:44 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3261FE7;
        Thu, 22 Jun 2023 10:57:42 -0700 (PDT)
Date:   Thu, 22 Jun 2023 19:57:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
        t=1687456660; bh=Lh5/dT2/13B9EXy2EOf+33Uc0+KDF5N223sZ8gY2ghQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a0jIRN6uorF/F9EBzVqYUuTtrds07ROblRlgUxndZHn9hogyVPkXLdTvXTO2UkIEg
         5NJ6D7H4aayk10KSXeDefsxm80Krs5ulztsuXcgyyX6455EaAatxYTI5PLJNKY5J2x
         EGDjVFq8DyAUrAUEtt9JtfNlCLmTtT9m6jZYNpmo=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
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
Message-ID: <6734a933-6e61-45b1-969c-1767f1aad43b@t-8ch.de>
References: <20230622172029.726710-1-ammarfaizi2@gnuweeb.org>
 <20230622172029.726710-4-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622172029.726710-4-ammarfaizi2@gnuweeb.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-06-23 00:20:29+0700, Ammar Faizi wrote:
> Currently, the stack protector is forcefully disabled. Let's allow using
> the stack protector feature only if libc is used.
> 
> The stack protector will remain disabled by default if no custom CFLAGS
> are provided. This ensures the default behavior doesn't change while
> still offering the option to enable the stack protector.

FYI

There are patches in the pipeline that enable stackprotector support for
nolibc [0]. They should land in 6.5.

It only supports "global" mode and not per-thread-data.
But as nolibc does not support threads anyways that should not matter.
A compiler flag has to be passed though, but that can be automated [1].

So the -fno-stack-protector can probably be removed completely.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/tree/tools/include/nolibc/stackprotector.h?h=dev.2023.06.16a
[1] https://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git/tree/tools/testing/selftests/nolibc/Makefile?h=dev.2023.06.16a#n81

> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Guillem Jover <guillem@hadrons.org>
> Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  src/Makefile | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/src/Makefile b/src/Makefile
> index 951c48fc6797be75..c4c28cbe87c7a8de 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -10,9 +10,8 @@ CPPFLAGS ?=
>  override CPPFLAGS += -D_GNU_SOURCE \
>  	-Iinclude/ -include ../config-host.h \
>  	-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64
> -CFLAGS ?= -g -O3 -Wall -Wextra
> +CFLAGS ?= -g -O3 -Wall -Wextra -fno-stack-protector
>  override CFLAGS += -Wno-unused-parameter \
> -	-fno-stack-protector \
>  	-DLIBURING_INTERNAL \
>  	$(LIBURING_CFLAGS)
>  SO_CFLAGS=-fPIC $(CFLAGS)
> @@ -46,8 +45,8 @@ liburing_srcs := setup.c queue.c register.c syscall.c version.c
>  
>  ifeq ($(CONFIG_NOLIBC),y)
>  	liburing_srcs += nolibc.c
> -	override CFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-builtin
> -	override CPPFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-builtin
> +	override CFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-builtin -fno-stack-protector
> +	override CPPFLAGS += -nostdlib -nodefaultlibs -ffreestanding -fno-builtin -fno-stack-protector
>  	override LINK_FLAGS += -nostdlib -nodefaultlibs
>  endif
>  
> -- 
> Ammar Faizi
> 
