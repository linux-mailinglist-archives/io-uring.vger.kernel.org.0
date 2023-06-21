Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B76F738A7C
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 18:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjFUQIh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 12:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjFUQIf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 12:08:35 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E87186
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 09:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687363703;
        bh=WQ9YL5OdxYoIwBKZRRQ1x0TwINKvuny9+d3/SF0HALI=;
        h=Date:From:To:Subject:References:In-Reply-To;
        b=QSidXJA9ZG0bV222htbzh0hBKgkuBFCwmhvC0Pf1tKTiXVtvm565den/Kr7DGjPwu
         ajb5H5e33ZLh7t2cn2fVwPrZPS2xTXWYkghdbdv5mZi45exS3WRgkjg7Y+VuEwi0sz
         k1T/aYCOsbuYFRoNU4C8wIZzsrWnjjuGFu0XHJNDAWWlW9TKiWeURabaMpqLwRXjZc
         FdLKBIOrKmYQbdZ7l0UTWQpi1aNK4Jinlyyt/ltQFnOCRrxowM/+1aGi/x4wyJ+0yt
         shaG+V6mj+VY4khzN41V17JrhxGL3toq5zrF6OJHpJ4/ooaAd8zYAsmhlzwsTBlwgt
         prIcqRjweMLTw==
Received: from biznet-home.integral.gnuweeb.org (unknown [103.125.42.5])
        by gnuweeb.org (Postfix) with ESMTPSA id CE657249D56;
        Wed, 21 Jun 2023 23:08:20 +0700 (WIB)
Date:   Wed, 21 Jun 2023 23:08:15 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Guillem Jover <guillem@hadrons.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: Re: False positives in nolibc check
Message-ID: <ZJMgby+JVuFP/wLs@biznet-home.integral.gnuweeb.org>
References: <20230620133152.GA2615339@fedora>
 <ZJHKdAf2tPe+6BS6@biznet-home.integral.gnuweeb.org>
 <20230621100447.GD2667602@fedora>
 <ZJLOpuoI5X5IGAdk@biznet-home.integral.gnuweeb.org>
 <ZJLkXC7QffsoCnpu@thunder.hadrons.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJLkXC7QffsoCnpu@thunder.hadrons.org>
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

On Wed, Jun 21, 2023 at 01:51:56PM +0200, Guillem Jover wrote:
> So, I also think I'd appreciate a --use-libc mode (or similar) which I'd
> probably consider enabling for Debian.

I'll send a patch to add that mode for review tomorrow morning.

> OTOH, I've no idea how much impact that would cause to performance? Do
> any of you have numbers?

The only real *hot path* that depended on a libc function was
io_uring_submit(). It used syscall(2) function.

But now even when compiled with libc, we no longer use syscall(2),
instead we use inline assembly to invoke syscall. So there is nothing to
worry about performance here.

Side note:
liburing still uses syscall(2) on architectures other than x86, x86-64
and aarch64.

-- 
Ammar Faizi

