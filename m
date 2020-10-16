Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3394029024E
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 11:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406459AbgJPJz0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 05:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406446AbgJPJzW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 05:55:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34864C061755;
        Fri, 16 Oct 2020 02:55:22 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602842120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JQCk6sSw96dKkKWAw68t6bVaXj3z565GzsunHnpV0/c=;
        b=T3NsBOLqXbyJX0qxq53mu2tDtBbnoSucVZGFpFhI7Z6J0s7/YVfyDGP0SkDj7nN5EUSDkN
        DWu0ko6dhh5S20q/N28Us3g42NHsxVNK16KiROcgjqs5Qu8W9WxoLO4bVvO+PJlEEmVIKm
        gzYeOf8d8MDxrxnZ1Bocdu0+Hi+5VAsGXmMhjcbAX1yvd9FZEllse1HjB/a1iBQ3LHxGb5
        BKhdKN6k00dYRgPWjoy+EJZ1d7jhzHHoAoSDJZP6AthHg34jaDQ2XweEcC5AT9XiUYnzM6
        xIfRWVNrMuMSc9RTabYUcdwYBo3pa6LzeMdQlgZ+4e/3JNcMtYBzyLP5t0Gn+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602842120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JQCk6sSw96dKkKWAw68t6bVaXj3z565GzsunHnpV0/c=;
        b=JKdCEipqAbkRwKZMerW1WttJwL4M4wO2zLIpCLUc2HtCjygDsGQh+sk3OfMvIyunHTlK0c
        hFrPm0MS5ThVHWBg==
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 4/5] x86: wire up TIF_NOTIFY_SIGNAL
In-Reply-To: <20201015143409.GC24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk> <20201015131701.511523-5-axboe@kernel.dk> <87o8l3a8af.fsf@nanos.tec.linutronix.de> <20201015143409.GC24156@redhat.com>
Date:   Fri, 16 Oct 2020 11:55:20 +0200
Message-ID: <87y2k6trzr.fsf@nanos.tec.linutronix.de>
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

This is about the generic entry code. For the users of that it makes
absolutely no sense to have that in architecture code.

Something which every architecture needs to do in the exactly same way
goes into the common code. If not, you can spare the exercise of having
common code in the first place.

Also arch_do_signal() becomes a misnomer with this new magic.

static void handle_signal_work(ti_work, regs)
{
	if (ti_work & _TIF_NOTIFY_SIGNAL)
        	tracehook_notify_signal();

        arch_do_signal_or_restart(ti_work, regs);
}

which makes it entirely clear what this is about.

Thanks,

        tglx
