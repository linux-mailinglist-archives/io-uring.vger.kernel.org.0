Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231DF28F4D2
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388348AbgJOOeh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:34:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38270 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387589AbgJOOeh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:34:37 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602772476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Skwtr1L/ml3AFpge62Q6x9UKEnNj6/PYgeEkAUrhwYs=;
        b=1odp1ddEnX1ugOpOy3b0L/qvR9XSDoyAsjobhOsjVzwQjJGawjWzJ+C9Vjo69ZiwPED/je
        JQ7jdYeu1glcEinzjM6/5rWLUTmNsA7/NKhRihRe0wXwll64iSqOgtk8XWvq9LlvF7+ceC
        MCCXIG8/yiqiVvf8NWPCTqCrIKJdZkJac9gTD7mIZxjGe2/BlzCq9kIJT35Gbi8dICjlG0
        lwOKXOof0hW0xLMRRpHewVMtjmSGcI5OyJ/SZ0PkS+rC5J2KOJ1n7nJ6sFjBqNRowpp9B1
        kW1Lwe5v/oKHn/pdgJaroRvDgWx6EZJ4G7ySDoyXHsEMPoHnd0/ETardjT7alA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602772476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Skwtr1L/ml3AFpge62Q6x9UKEnNj6/PYgeEkAUrhwYs=;
        b=La+twWgj/McvsrWXN6WPR+NdPJyat7AJ+l2KNhg/wjh3tEeoyZkNWFzU76oJyYMRl0YQoE
        wXj36SxbBCW3NGAQ==
To:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com
Subject: Re: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
In-Reply-To: <da84a2a7-f94a-d0aa-14e0-3925f758aa0e@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk> <20201015131701.511523-5-axboe@kernel.dk> <87o8l3a8af.fsf@nanos.tec.linutronix.de> <da84a2a7-f94a-d0aa-14e0-3925f758aa0e@kernel.dk>
Date:   Thu, 15 Oct 2020 16:34:35 +0200
Message-ID: <87ft6fa77o.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 15 2020 at 08:31, Jens Axboe wrote:
> On 10/15/20 8:11 AM, Thomas Gleixner wrote:
> We could, should probably make it:
>
> static void handle_signal_work(ti_work, regs)
> {
> 	if (ti_work & _TIF_NOTIFY_SIGNAL)
>         	tracehook_notify_signal();
>
> 	if (ti_work & _TIF_SIGPENDING)
>         	arch_do_signal(regs);
> }
>
> and then we can skip modifying arch_do_signal() all together, as it'll
> only be called if _TIF_SIGPENDING is set.

Then you loose the syscall restart thing which was the whole point of
this exercise :)

Thanks,

        tglx
