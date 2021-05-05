Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96150374B20
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 00:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhEEWWX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 18:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbhEEWWV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 18:22:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58758C061574;
        Wed,  5 May 2021 15:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=w28lTs+isPuYTItHq/Cj3XPDLWxEqW4ZNssg8znZ3O8=; b=tr0gyHWf0dJ2rB+9/4KdbEuHiP
        qp6B3iGGRo/mIvmLvtsGOmED4EzSnr2EdlxvoIuc6Ub16f1XYtfVUPhZwO4IB2dzRY4sTSS4Dt61z
        Zs3CG/bkVjRRftAak2XBN9FWcXQK7W+0XZoBOgQgLjvaZEgZyOr9ETlaYy0OuB+BdNFVBwLQSxUDR
        ZGYBrQyhbAgxbzT1rHzMFCszro28w++TiLNHHiiBCzUqhKhP71l6Y1nyDQlk2xFjcUllmx+pLZok+
        GnEV1GGACM9PDZNWpq3Xpf/PnI9Wvanku7beRO/aUQRBKmeqIlapawz9PBKdxlliRgShC/mc/vAfK
        2kBnb0WIrpzJXRxh55lY7WPzw23P329fFqPvVUckuIELIDczrIzBIK+DvGKOnHYLYuiFGlkcIAOty
        GzyFaZDwIYqXhgruExe+kPJCiRlmXaA119DmOsM//3ExOf4QVrc9iDrV+f8KZ3tQHV+BHFRMSeYS3
        7rx2Do5R+FKKtoWbyGkryd2S;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lePtQ-0007KM-5l; Wed, 05 May 2021 22:21:20 +0000
To:     Simon Marchi <simon.marchi@polymtl.ca>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-toolchains@vger.kernel.org
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net> <YJFptPyDtow//5LU@zn.tnic>
 <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca>
 <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
 <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Message-ID: <f15f0ccd-fe30-c3cf-9b01-df7ba462401f@samba.org>
Date:   Thu, 6 May 2021 00:21:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Simon,

> When you attach to PIDVAL (assuming that PIDVAL is a thread-group
> leader), GDB attaches to all the threads of that thread group.  The
> inferior_ptid global variable is "the thread we are currently working
> with", and changes whenever GDB wants to deal with a different thread.
> 
> After attaching to all threads, GDB wants to know more about that
> process' architecture (that read_description call mentioned in [1]).
> The way this is implemented varies from arch to arch, but as you found
> out, for x86-64 it consists of peeking into a thread's CS/DS to
> determine whether the process is x86-64, x32 or i386.  The thread used
> for this - the inferior_ptid value - just happens to be the latest
> thread we switched inferior_ptid to (presumably because we iterated on
> the thread list to do something and that was the last thread in the
> list).  And up to now, this was working under the assumption that
> picking any thread of the process would yield the same values for that
> purpose.  I don't think it was intentionally done this way, but it
> worked and didn't cause any trouble until now.
> 
> With io threads, that assumption doesn't hold anymore.

Yes, in 5.12

> From what I understand, your v1 patch made it so that the kernel puts the CS/DS
> values GDB expects in the io threads (even though they are never
> actually used otherwise).  I don't understand how your v2 patch
> addresses the problem though.

v1 did clear everything and tried to keep some selected registers:

  'memset(childregs, 0, sizeof(struct pt_regs));'
  childregs->cs = currenttrgs->cs;
  childregs->ss = currenttrgs->ss;
  childregs->ds = currenttrgs->ds;
  childregs->es = currenttrgs->es;

v2 copies everything and only clears 3 selected registers (I added the last two for
   the PF_IO_WORKER case:

  *childregs = *current_pt_regs();
  childregs->ax = 0;
  ...
  childregs->ip = 0;
  childregs->sp = 0;

So regarding childregs->cs and childregs->ds the effect is the same.

(Also note that on x86_64 ds in handled by savesegment(ds, p->thread.ds);
already instead so the effective problem as only childregs->cs which
is cleared in 5.12, but will be kept with both of my patches.

> I don't think it would be a problem on the GDB-side to make sure to
> fetch these values from a "standard" thread.  Most likely the thread
> group leader, like Tom has proposed in [1].

Ok.

Is it clear now?
metze
