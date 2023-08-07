Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882817717C4
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 03:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjHGBXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Aug 2023 21:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjHGBXy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Aug 2023 21:23:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72ECFE6A;
        Sun,  6 Aug 2023 18:23:53 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1691371430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vhJb2J/L1KJDuFhVdB4upWsep76HK4f9VwEApjjql5c=;
        b=K/RCubuoAnObH6wterQuWEHhzHTq4iMnJy11s8H2X2P2aOQvKLU9iBdYtL0CNT3YO6UbPT
        bNGmi2Zsf71wyvbdmKWE6mKR+tRuq89zbdEChAvoYmPt+KpRy8/68jtXsuZR1V1hcqYyQy
        1Oo85HRg0tQGV0WqXwPTC7Y164edFGQHu+JMtKH4oWJkxpwQWKC1leq8s81zZeoGq/eaPO
        zb1VAeuK9gQmTLkykxt+pZdxhDdMWkBQ3eUY6FN0VDC+TCjs2KTXbEbCFIZ9KfKg3aP5Ig
        WOMH2FrI5I4EFHzG/Njw8EBGU0iQkSEU2MieNSOKLq5s0nNBI1dWbkmNBV6aLQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1691371430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vhJb2J/L1KJDuFhVdB4upWsep76HK4f9VwEApjjql5c=;
        b=6zHWGu5lqw2afu1Gdp+86lvbhasHwRy8lHJjB+v1KAHA1zTuBMDYS/f4fXmav7TdY/VH/p
        sOSzyy0v1cfvf8AA==
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de
Subject: Re: [PATCHSET v4] Add io_uring futex/futexv support
In-Reply-To: <e136823c-b5c9-b6b3-a0e2-7e9cfda2b2d8@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk> <87jzugnjzy.ffs@tglx>
 <e136823c-b5c9-b6b3-a0e2-7e9cfda2b2d8@kernel.dk>
Date:   Mon, 07 Aug 2023 03:23:49 +0200
Message-ID: <875y5rmyqi.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens!

On Sun, Aug 06 2023 at 10:44, Jens Axboe wrote:
> On 7/31/23 10:06?AM, Thomas Gleixner wrote:
>> Can you please just wait until the futex core bits have been agreed on
>> and merged? No need to contribute more mess in everyones inbox.
>
> Also no need to keep dragging out the review of the other bits. The
> dependency is only there so we can use FUTEX2 flags for this - which
> does make sense to me, but we should probably split Peter's series in
> two as there's no dependency on the functional bits on that patch
> series. As we're getting ever closer to the merge window, and I have
> other things sitting on top of the futex series, that's problematic for
> me.

Seriously?

You are still trying to sell me "Features first - corrrectness
later/never"?

Go and look at the amount of fallout this has caused in the last years.
io-urine is definitely the leader of the pack in my security@kernel.org
inbox.

Vs. the problem at hand. I've failed to catch a major issue with futex
patches in the past and I'm not seeing any reason to rush any of this to
repeat the experience just because.

You know very well that your whatever depends on this series has to wait
until the basics are sorted and there is absolutely no reason that your
so important things have to be rushed into the next merge window.

It surely makes sense to split these things up into independent series,
but _you_ could have done that weeks ago instead of just reposting an
umodified and unreviewed RFC series from Peter and then coming out now
and complaining about the lack of progress.

Sorry no.

Thanks,

        tglx

