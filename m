Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462D437275D
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 10:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhEDIke (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 04:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhEDIk2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 May 2021 04:40:28 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149BFC06174A;
        Tue,  4 May 2021 01:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jHj0U851XAR8dHLCObZjvsMxkhCDRfe/hly+/JhNV6I=; b=i58/6+bhGSraSN+KcG3X89rTmB
        fhTwqUp8GO7z5KV9/cXXwo6ImpdHjCATymAK8Ue9U0dVBfSj1CLBLUMc5kETh3WNRiIOBLrxsfdXs
        ujSOJWFg0jIArJcvyOYUzLQYiE/qI2pyNISmOZEvUGx3YmgYp1IWCgmYdLJdcFMs8pyKVAmMs+mIY
        b+WI2qaeBU3bQv+Sonsso7Y1wLYCCF6G3JdAWTUSff0UrDccxrwcHrgEZc9nT2cVWs+SPjy25YGS0
        nwzG4eG2t5AU+NvsJAG+aCx+dVqFPIXHqyEq14SjsNIt04zVYAtlI+e1qM4GWCm/CYOWmBiVowWSE
        unLQnalg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ldqaT-00Floj-Gh; Tue, 04 May 2021 08:39:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BDE55300036;
        Tue,  4 May 2021 10:39:23 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ACADB20D77EF8; Tue,  4 May 2021 10:39:23 +0200 (CEST)
Date:   Tue, 4 May 2021 10:39:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-toolchains@vger.kernel.org
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Message-ID: <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


+ linux-toolchains

On Mon, May 03, 2021 at 12:14:45PM -0700, Linus Torvalds wrote:
> On Mon, May 3, 2021 at 9:05 AM Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > Linus, what is the actual effect of allowing gdb to attach these threads?  Can we instead make all the regset ops do:
> >
> > if (not actually a user thread) return -EINVAL;
> 
> I don't think it matters - the end result ends up  being the same, ie
> gdb gets confused about whether the (parent) thread is a 32-bit or
> 64-bit one.
> 
> So the basic issue is
> 
>  (a) we want the IO threads to look exactly like normal user threads
> as far as the kernel is concerned, because we had way too many bugs
> due to special cases.
> 
>  (b) but that means that they are also visible to user space, and then
> gdb has this odd thing where it takes the 64-bit vs 32-bit data for
> the whole process from one thread, and picks the worst possible thread
> to do it (ie explicitly not even the main thread, so usually the IO
> thread!)
> 
> That (a) ended up really being critical. The issues with special cases
> were just horrendous, both for security issues (ie "make them kernel
> threads but carry user credentials" just caused lots of problems) but
> also for various just random other state handling issues (signal state
> in particular).
> 
> So generally, the IO threads are now 100% normal threads - it's
> literally just that they never return to user space because they are
> always just doing the IO offload on the kernel side.
> 
> That part is lovely, but part of the "100% IO threads" really is that
> they share the signal struct too, which in turn means that they very
> much show up as normal threads. Again, not a problem: they really
> _are_ normal threads for all intents and purposes.
> 
> But then that (b) issue means that gdb gets confused by them. I
> personally think that's just a pure gdb mis-feature, but I also think
> that "hey, if we just make the register state look like the main
> thread, and unconfuse gdb that way, problem solved".
> 
> So I'd actually rather not make these non-special threads any more
> special at all. And I strongly suspect that making ptrace() not work
> on them will just confuse gdb even more - so it would make them just
> unnecessarily special in the kernel, for no actual gain.
> 
> Is the right thing to do to fix gdb to not look at irrelevant thread B
> when deciding whether thread A is 64-bit or not? Yeah, that seems like
> obviously the RightThing(tm) to me.
> 
> But at the same time, this is arguably about "regression", although at
> the same time it's "gdb doesn't understand new user programs that use
> new features, film at 11", so I think that argument is partly bogus
> too.
> 
> So my personal preference would be:
> 
>  - make those threads look even more like user threads, even if that
> means giving them pointless user segment data that the threads
> themselves will never use
> 
>    So I think Stefan's patch is reasonable, if not pretty. Literally
> becasue of that "make these threads look even more normal"
> 
>  - ALSO fix gdb that is doing obviously garbage stupid things
> 
> But I'm obviously not involved in that "ALSO fix gdb" part, and
> arguably the kernel hack then makes it more likely that gdb will
> continue doing its insane broken thing.

Anybody on toolchains that can help get GDB fixed?
