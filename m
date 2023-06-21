Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AD773821B
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 13:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjFUKUU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 06:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjFUKTe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 06:19:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0151AC
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 03:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687342764;
        bh=mcCkvxVLHbiXhXVk27bzkzKsXfz5QT7GpKCLNfrraFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=PD9F0mX3mffRkhLwojUETY94RLenUfuA3AJWV/XFS6b/6uPf9h7XxldzUjD0r/Agm
         xhYgqEM9p/KFL+T+BEKnkx7dOuaIx75rCIsZaR7tSOw5KqzNQiPXJT11BUAGEvZZXv
         0DBNc1klm00xriHgKBYozFqJQcgPlVuD97Kn6aBZ36f7VbXjLPtfJD5AztQjHr1CaR
         ZTrU/OfwO/1jhYRiQb1rwIOvrGO2MF8LEmxagZ3rJXSDKFpoKbcr1CiSoG0UubQ3En
         KTfeOgDc8eElTw1wvCFXBmXQ/1HMRRToyy21/6957ypUVoQawO9HH+0mrQpp84jopl
         mTGL9Hscwb7BA==
Received: from biznet-home.integral.gnuweeb.org (unknown [68.183.184.174])
        by gnuweeb.org (Postfix) with ESMTPSA id 7B0B2249D30;
        Wed, 21 Jun 2023 17:19:22 +0700 (WIB)
Date:   Wed, 21 Jun 2023 17:19:18 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     io-uring@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Guillem Jover <guillem@hadrons.org>
Subject: Re: False positives in nolibc check
Message-ID: <ZJLOpuoI5X5IGAdk@biznet-home.integral.gnuweeb.org>
References: <20230620133152.GA2615339@fedora>
 <ZJHKdAf2tPe+6BS6@biznet-home.integral.gnuweeb.org>
 <20230621100447.GD2667602@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621100447.GD2667602@fedora>
X-Bpl:  hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 21, 2023 at 12:04:47PM +0200, Stefan Hajnoczi wrote:
> I don't know which features require the toolchain and libc to cooperate.
> I guess Thread Local Storage won't work and helper functions that
> compilers emit (like the memset example that Alviro gave).

Yeah, thread local storage won't work. But the point of my question is
about liburing. So I expect the answer that's relevant to liburing.

I mean, you can still use libc and TLS in your app even though the
liburing.so and liburing.a are nolibc.

> Disabling hardening because it requires work to support it in a nolibc
> world seems dubious to me. I don't think it's a good idea for io_uring
> to lower security because that hurts its image and reduces adoption.
> Especially right now, when the security of io_uring is being scrutinized
> (https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html).
> 
> While I'm sharing these opinions with you, I understand that some people
> want nolibc and are fine with disabling the stack protector. The main
> thing I would like is for liburing to compile or fail with a clear error
> message instead of breaking somewhere during the build.

Right, my mistake. I think it's fixed in upstream by commit:

   319f4be8bd049055c333185928758d0fb445fc43 ("build: Disable stack protector unconditionally")

Please give it a whirl. I apologize for breaking the Fedora build.

Regards,
-- 
Ammar Faizi

