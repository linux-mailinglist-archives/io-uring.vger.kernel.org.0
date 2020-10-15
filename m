Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEE828F54F
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389078AbgJOOyX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388348AbgJOOyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:54:23 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE74C061755;
        Thu, 15 Oct 2020 07:54:23 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602773662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=ubYf3uIUdQo/Q6bT+xRjgGp11qUFxlJTueT4HYtcveA=;
        b=wSh6lUkYEO1tc7RiI88tbavWABCiJVEC6E3Kw0RReu+RntJxLXRtEVIuyng5FIs0U6lQb2
        P9VxdfdOeWxt/YhxzbdSFvdfSmEHiFcS5OHxcyEkIZOOT5psTnoGXzJTRC49HDRK57Ni0L
        RM1G/CroDEur8WHKZnsAbcI91/fIbjMweUGL2C/v4ldmTl+QXLMQo24Gd06EwC25LELvfb
        AEs8aaiti+tvYYGOBR1CYN7bgE/24HrmzmxskTVBy4ctSpJ0zybfxpHPeTFaR5+lrrqein
        xPok/m+ShBlgCitTumM2H4kSoHv+dq9i1umBO65QJuOYLlbhPfnDsdLk0SRofA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602773662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=ubYf3uIUdQo/Q6bT+xRjgGp11qUFxlJTueT4HYtcveA=;
        b=Cp/bi64bNNhdtVgNKP9ydTyMRMnC2HdODscc295c+nChqeID73hDstALv1QQGkMxiwfGTC
        OF27e7FgW7FIveAQ==
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
In-Reply-To: <20201015143409.GC24156@redhat.com>
Date:   Thu, 15 Oct 2020 16:54:21 +0200
Message-ID: <87v9fbv8te.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 15 2020 at 16:34, Oleg Nesterov wrote:
> On 10/15, Thomas Gleixner wrote:
>> Instead of adding this to every architectures signal magic, we can
>> handle TIF_NOTIFY_SIGNAL in the core code:
>> 
>> static void handle_singal_work(ti_work, regs)
>> {
>> 	if (ti_work & _TIF_NOTIFY_SIGNAL)
>>         	tracehook_notify_signal();
>> 
>>         arch_do_signal(ti_work, regs);
>> }
>> 
>>       loop {
>>       		if (ti_work & (SIGPENDING | NOTIFY_SIGNAL))
>>                 	handle_signal_work(ti_work, regs);
>>       }
>
> To me this looks like unnecessary complication. We need to change
> every architecture anyway, how can this helper help?

You need to change ONE architecture because nobody else uses the common
entry loop right now. For those who move over they have to supply
arch_do_signal() anyway, so the extra TIF check is not a problem.

We really don't want all architectures to have the same thing
copy&pasta'd. That's the whole point of common code to avoid that.

Thanks,

        tglx
