Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C1A77C452
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 02:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbjHOAM7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 20:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbjHOAMw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 20:12:52 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B700E51;
        Mon, 14 Aug 2023 17:12:51 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1692058369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ob9Aj8OmLEW2Umxh7qMxW+QoI1rjjsqyw5Bf2kHlBvU=;
        b=JV8axbewm3tO7ymekC+iSpuJ6kqQEGwK9zR/YF8vb/JQpdicE42ySXjDZnjPvQp4QqoxId
        +45SythGtOiepDb0OweMjZBrY7+J1qh3shynzSXS7HVzouOrDrxgySLnX0aEYd6PEzxHzi
        P68eazP2vl4JZVVUrqZngCvKP7lIyVyPoUkPbvBDk2knb3xUdEwIQcw1MBaDOGBksVzhcD
        pt4bB/2dBiCN7bNVlz64Dv0vZNBwg5blxsmoiywlA/yN4Z+fpX8jzNNhgF7q8taGq5tJuc
        rujVpoGptDckyjXKTKG7CMF4G/7VLJ+V0peL2MEceBQP9ejnT3FnpE2tPlv+jA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1692058369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ob9Aj8OmLEW2Umxh7qMxW+QoI1rjjsqyw5Bf2kHlBvU=;
        b=WTgQtowYYMcqpt0yEhcMp+uPxsh7I0UT4x+49dLML43GAL/5NsyzqkTx/KWLWvrGij3TVB
        c09uObnz+4HQ1dBA==
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de
Subject: Re: [PATCHSET v4] Add io_uring futex/futexv support
In-Reply-To: <9153c0bf-405b-7c16-d26c-12608a02ee29@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk> <87jzugnjzy.ffs@tglx>
 <e136823c-b5c9-b6b3-a0e2-7e9cfda2b2d8@kernel.dk> <875y5rmyqi.ffs@tglx>
 <9153c0bf-405b-7c16-d26c-12608a02ee29@kernel.dk>
Date:   Tue, 15 Aug 2023 02:12:48 +0200
Message-ID: <87y1idgo3j.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens!

On Mon, Aug 07 2023 at 12:23, Jens Axboe wrote:
> On 8/6/23 7:23?PM, Thomas Gleixner wrote:
>> Go and look at the amount of fallout this has caused in the last years.
>> io-urine is definitely the leader of the pack in my security@kernel.org
>> inbox.
>
> We're now resorting to name calling? Sorry, but I think that's pretty
> low and not very professional.

I'm not resorting to that. If you got offended by the meme which
happened to elapse into my reply, then I can definitely understand
that. That was not my intention at all. But you might think about why
that meme exists in the first place.

>> Vs. the problem at hand. I've failed to catch a major issue with futex
>> patches in the past and I'm not seeing any reason to rush any of this to
>> repeat the experience just because.
>
> I'm not asking anyone to rush anything.

 "As we're getting ever closer to the merge window, and I have other
  things sitting on top of the futex series, that's problematic for me."

That's your words and how should I pretty please interpret them
correctly?

Thanks,

        tglx
