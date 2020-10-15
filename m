Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF9628F56E
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 17:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbgJOPBP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 11:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388086AbgJOPBP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 11:01:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ADCC061755;
        Thu, 15 Oct 2020 08:01:14 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602774073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+DuzvGKr+uouQPicd3btzTpBKj/5LVLg1yi/nXnEH1M=;
        b=mDMRS/8Et7iVSKGXRG0qPg3GpdinFibrmtscDezhbH4liiBttp5q78MM84WhBgjcFM4KBm
        0R5bGiuJFiP5vgDnebSITaFljWa/pXVPjUrWBfh7/4r8R8dNAzTD/ZQlRKPTKioFp/X0Rm
        Ufkt9ooD/LPSdrmUJn6f6WXi8jyhW2aT+/ZptAj7EFdKGTbcN6TXDSelPUTUppAv4cwnNY
        3zo7Q8rYY6d6AdTejhqVtBnbBGBE6hx8g0MjOckTt7CztrqBVskc149aCzprowHXwhdNEA
        fSNZrALNGPCepVpCjULiys/SxRN+tMGR1FiWMWojXoB1r8H/8+E0cI71zu35rQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602774073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+DuzvGKr+uouQPicd3btzTpBKj/5LVLg1yi/nXnEH1M=;
        b=eztVgQEYp+HzQIkMh71WxUwdkCYIhvU3k+Rlk0GbSO0yB7CAcXf9YgE65sVh7V59zpNRIm
        HQbLwiakXwA2LUBA==
To:     Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
In-Reply-To: <20201015143728.GE24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk> <20201015131701.511523-4-axboe@kernel.dk> <20201015143151.GB24156@redhat.com> <5d231aa1-b8c7-ae4e-90bb-211f82b57547@kernel.dk> <20201015143728.GE24156@redhat.com>
Date:   Thu, 15 Oct 2020 17:01:13 +0200
Message-ID: <87r1pzv8hy.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 15 2020 at 16:37, Oleg Nesterov wrote:
> On 10/15, Jens Axboe wrote:
>> On 10/15/20 8:31 AM, Oleg Nesterov wrote:
>> > I don't understand why does this version requires CONFIG_GENERIC_ENTRY.
>> > 
>> > Afaics, it is very easy to change all the non-x86 arches to support
>> > TIF_NOTIFY_SIGNAL, but it is not trivial to change them all to use
>> > kernel/entry/common.c ?
>> 
>> I think that Thomas wants to gate TIF_NOTIFY_SIGNAL on conversion to
>> the generic entry code?
>
> Then I think TIF_NOTIFY_SIGNAL will be never fully supported ;)

Yeah, we proliferate crap on that basis forever. _ALL_ architectures
have the very same entry/exit ordering problems (or subsets and
different ones) which we fixed on x86.

So no, we don't want to have 24 different variants of the same thing
again. That's what common code is for.

Not doing that is making the life of everyone working on core
infrastructure pointlessly harder. Architecture people still have enough
ways to screw everyone up.

Thanks,

        tglx


