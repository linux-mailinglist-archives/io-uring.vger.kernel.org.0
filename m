Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AF07383B6
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 14:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjFUM0t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 08:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjFUM0r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 08:26:47 -0400
X-Greylist: delayed 2080 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 21 Jun 2023 05:26:44 PDT
Received: from pulsar.hadrons.org (2.152.192.238.dyn.user.ono.com [2.152.192.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2BE129
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 05:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hadrons.org
        ; s=201908; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:From:Reply-To:Subject:Content-Transfer-Encoding:
        Content-ID:Content-Description:X-Debbugs-Cc;
        bh=7jACDv7Gm569Nyo9vX3owsXsVZyraqAYr4+Pv0P/Fkw=; b=tNUX901QBRmSNHD9dSukAByFRv
        D0A+3pCrzznN2Ci6bkiSyjB7w9FIZOQ5qhHpOr0aKir+azCgsAxP1Wpz6i4R0HX08tbaA8hsNwh1l
        n6piGt8aDXVe3pq0XfC1itYR/pVl3eowWIhTzG6/f6eSOIdFoaNDO8wmZNGVns53eSGCMyKcLlU5f
        43EhL5L2y6TgUPqjCBjWB4YzwWCNoa31rfCPir8CDCZeeXVu55kr9Qr8FZwr+tGj1oF4Vz8EhpORC
        6cqb1tEB2AmLUfsI/DEJNVKxMUGxkQ7xViLY577iBJsrHXKWvcJ9U/jcSPfNSeGfA1CyRBEjCuTOl
        nZoBSqYw==;
Received: from guillem by pulsar.hadrons.org with local (Exim 4.96)
        (envelope-from <guillem@hadrons.org>)
        id 1qBwNQ-0002Z6-27;
        Wed, 21 Jun 2023 13:51:56 +0200
Date:   Wed, 21 Jun 2023 13:51:56 +0200
From:   Guillem Jover <guillem@hadrons.org>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: Re: False positives in nolibc check
Message-ID: <ZJLkXC7QffsoCnpu@thunder.hadrons.org>
Mail-Followup-To: Guillem Jover <guillem@hadrons.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
References: <20230620133152.GA2615339@fedora>
 <ZJHKdAf2tPe+6BS6@biznet-home.integral.gnuweeb.org>
 <20230621100447.GD2667602@fedora>
 <ZJLOpuoI5X5IGAdk@biznet-home.integral.gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJLOpuoI5X5IGAdk@biznet-home.integral.gnuweeb.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_RDNS_DYNAMIC_FP,
        RCVD_IN_SORBS_DUL,RDNS_DYNAMIC,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi!

On Wed, 2023-06-21 at 17:19:18 +0700, Ammar Faizi wrote:
> On Wed, Jun 21, 2023 at 12:04:47PM +0200, Stefan Hajnoczi wrote:
> > I don't know which features require the toolchain and libc to cooperate.
> > I guess Thread Local Storage won't work and helper functions that
> > compilers emit (like the memset example that Alviro gave).
> 
> Yeah, thread local storage won't work. But the point of my question is
> about liburing. So I expect the answer that's relevant to liburing.
> 
> I mean, you can still use libc and TLS in your app even though the
> liburing.so and liburing.a are nolibc.

> > Disabling hardening because it requires work to support it in a nolibc
> > world seems dubious to me. I don't think it's a good idea for io_uring
> > to lower security because that hurts its image and reduces adoption.
> > Especially right now, when the security of io_uring is being scrutinized
> > (https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html).
> > 
> > While I'm sharing these opinions with you, I understand that some people
> > want nolibc and are fine with disabling the stack protector. The main
> > thing I would like is for liburing to compile or fail with a clear error
> > message instead of breaking somewhere during the build.
> 
> Right, my mistake. I think it's fixed in upstream by commit:
> 
>    319f4be8bd049055c333185928758d0fb445fc43 ("build: Disable stack protector unconditionally")

While I sent that to make it build again, I have to say when I was
preparing the new liburing upload for Debian I hesitated to simply
disable nolibc support for all arches there. Went for now with this
because it is what is supported upstream and seemed like the smaller
delta for now, and going through all functions it seemed "safe", but
I might revisit this TBH.

We have been through this already with libaio, where going through the
nolibc model also caused problems, see:

  https://pagure.io/libaio/c/672eaebd131c789a528e3a9cd089b4b69a82012b

So, I also think I'd appreciate a --use-libc mode (or similar) which I'd
probably consider enabling for Debian. OTOH, I've no idea how much impact
that would cause to performance? Do any of you have numbers?

Thanks,
Guillem
