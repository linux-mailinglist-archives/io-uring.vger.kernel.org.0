Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420A277C49D
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 02:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjHOArw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 20:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbjHOArq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 20:47:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A421710;
        Mon, 14 Aug 2023 17:47:45 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1692060464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WU32HA/gaoI3ptIu4TOn7JE0oGwEzWimawkKnxR1rFg=;
        b=16whkwprCZ9w3g4SBEhDthpyRSyFklWeq0PYLbvOmZNve5M6He9wNAzo/uuEH8CvzHXQNX
        XXzHSe/4Xt+EaTA3tUlpf550PqkIqWEU35QsdfnO3iZwLB1N7LAw8LIRhaCZpEktMOZzeT
        32raIT7gPPA2eJeltkhWLr1ySMhQLn7XntPtqqxDAoDvXQeXCE/4WPKOAy/B4n4sRg0VSv
        Pntzfa7oguxVRO5zjSi9UkacnHXISC35+Ntqezsq3IfP2ymbh0nZ4oJ2LpEdYdo9YdDrij
        xF2AuIa5knp5/ez6SuA60kpHX1moZx6WWggdHLSHqM81+cZjdIi+I9tBZKTj0g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1692060464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WU32HA/gaoI3ptIu4TOn7JE0oGwEzWimawkKnxR1rFg=;
        b=35zh8PUGnAybysOL03Kh5dONQ85BOKJW/dX+69kYwacBfmsRVm07X8wnXlhPjB9vKNpEaM
        tnVGknpNvLTuDwDw==
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de
Subject: Re: [PATCHSET v4] Add io_uring futex/futexv support
In-Reply-To: <bda49491-4d7f-485f-b929-87a4bec6efaa@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk> <87jzugnjzy.ffs@tglx>
 <e136823c-b5c9-b6b3-a0e2-7e9cfda2b2d8@kernel.dk> <875y5rmyqi.ffs@tglx>
 <9153c0bf-405b-7c16-d26c-12608a02ee29@kernel.dk> <87y1idgo3j.ffs@tglx>
 <bda49491-4d7f-485f-b929-87a4bec6efaa@kernel.dk>
Date:   Tue, 15 Aug 2023 02:47:43 +0200
Message-ID: <87v8dhgmhc.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 14 2023 at 18:18, Jens Axboe wrote:
> On 8/14/23 6:12 PM, Thomas Gleixner wrote:

>>> We're now resorting to name calling? Sorry, but I think that's pretty
>>> low and not very professional.
>> 
>> I'm not resorting to that. If you got offended by the meme which
>> happened to elapse into my reply, then I can definitely understand
>> that. That was not my intention at all. But you might think about why
>> that meme exists in the first place.
>
> It's been there since day 1 because a) the spelling is close, and b)
> some people are just childish. Same reason kids in the 3rd grade come up
> with nicknames for each others. And that's fine, but most people grow
> out of that, and it certainly has no place in what is supposedly a
> professional setting.

Sure. Repeat that as often you want. I already made clear in my reply
that this was unintentional, no?

Though the fact that this "rush the feature" ends up in my security
inbox more than justified has absolutely nothing to do with my
potentially childish and non-professionl attitude, right?

Though you gracefully ignored that. Fair enough...
