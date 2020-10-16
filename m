Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D058C290704
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395344AbgJPORO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 10:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395333AbgJPORO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 10:17:14 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD97FC061755;
        Fri, 16 Oct 2020 07:17:13 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602857832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xa3I34LAVRoUUNBS2HyMAtk2zTSqAOC3alxtWLiNXD4=;
        b=d6NRaZrNNssH/jyNQVLdl0TVVZZ3yoCv0a6YEZl+hFwzZ4Tl4HqsFCCajGB+W1AyFu+rFN
        Zchik3URLzFBxj2PuUPFNPhZHj+X++6Ol7SX2/GK2vQVhCFZLRDC9xHM337ojxLZqKRHKt
        LtJomhXIUH6+TC4QZFf9RKhBDIlNrydNO0LVXDRqMoeoz4/HLbE7tT/XC3HVkZ3GK4IBeH
        fZS10BH1JgOOw1XkYiKOasa6opTs9xbkBQtMRrw7uvxUNN1kJMh010ALOoYUNTHrxjT9oe
        WfjD9swFOpSZedepfUm3hFGEurYx28uPC0Gnh46hmee7+ojjZI5lwJkfGeRucA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602857832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xa3I34LAVRoUUNBS2HyMAtk2zTSqAOC3alxtWLiNXD4=;
        b=l5ziGxNNpoT5AZTEg0huk4dknE0uQz06cTMngvONtYdMkc7icfV+wgzk/XVzxVyi28gv+v
        ZFDf4Rl8qej7EKCA==
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, Roman Gershman <romger@amazon.com>
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
In-Reply-To: <fbaab94b-dd85-9756-7a99-06bf684b80a4@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk> <20201015131701.511523-6-axboe@kernel.dk> <20201015154953.GM24156@redhat.com> <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk> <87a6wmv93v.fsf@nanos.tec.linutronix.de> <871rhyv7a8.fsf@nanos.tec.linutronix.de> <fbaab94b-dd85-9756-7a99-06bf684b80a4@kernel.dk>
Date:   Fri, 16 Oct 2020 16:17:12 +0200
Message-ID: <87a6wmtfvb.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 16 2020 at 07:35, Jens Axboe wrote:
> On 10/16/20 3:39 AM, Thomas Gleixner wrote:
>> On Fri, Oct 16 2020 at 11:00, Thomas Gleixner wrote:
>> That's a truly great suggestion:
>> 
>>    X86 is going to have that TIF bit once the above is available.
>> 
>> I'm happy to help with the merge logistics of this.
>
> Not really following this email...

What I tried to convey is, that the x86 tif bit is not going in before
the complete thing (including cleanups) is available. I'm only half
joking.

> But it seems to me that you're happy with approach 2, so I'll do
> the following:
>
> - Get rid of the CONFIG_GENERIC_ENTRY dependency for TIF_NOTIFY_SIGNAL
> - Respin the arch additions and cleanups on top of that again
>
> And hopefully we'll have something mergeable at that point. Once we
> have this series merged somewhere (would be great if you could carry
> it), I'll be talking to arch folks on the rest. Once archs have taken
> the necessary bits, I'll be posting the third and final series which
> is the cleanups that are currently sitting on top of the arch support.

Can you please just post the full thing after resolving #1 of the list
items which I pointed out in the other reply?

With moving the handling into get_signal() you don't need more changes
to arch/* than adding the TIF bit, right? So there should not be much
talking involved other than agreeing on the bit number to use.

I might be missing something though.

Thanks,

        tglx


