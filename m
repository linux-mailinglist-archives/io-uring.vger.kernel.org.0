Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CC172D0B0
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 22:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjFLUic (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 16:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjFLUia (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 16:38:30 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3279E19BC
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 13:38:03 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1a35f67d8efso1296493fac.1
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 13:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686602273; x=1689194273;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=57fPrHaXnPslzcK7ssGudSjuBFv2dfCgiktDOByKzOA=;
        b=R3PmPJPoPb+T/Flf7xX3JMyilN+j1ZPTty0jOw4FvLrCM7rAX54i6LZTrKwNiTyiBI
         7/tyyyu+fiKYSOlQ+D14xHFmZLu07EsDRpfDcQJYg4mPVQUmyXSuibz2RppVAuphrkDS
         +52940hX3TrSxpTbmT2yNDY4TgBX6Shd4bUCy4GiTPwvGzQHBzho7PCDwJnVioDRTltO
         /GkE2yy0S7S512tWQj6dFHWaAPnNRf0EUtnQqd9cK/XjtCdh45kpKKxwlQc8Wy8xAsty
         EsnxSETLRgAb0uFh49IKsgg/dtKCWResXItq+jyn4wyI++/ndInRoCPukePrgRwCNQ5j
         rq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686602273; x=1689194273;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57fPrHaXnPslzcK7ssGudSjuBFv2dfCgiktDOByKzOA=;
        b=VKZClrD80De2SNMb8mLjh+Tv//xw3w+BRP8gH9RS4fBLAOj2l49ZXx3vgpT1IcJAmG
         EzKKmcWcbHk0ymtasaqFthvnH7ZkE+xGrp+3xpkfyqyMBknUKDmGU4o6Bso/Xnzrczok
         Oz/sGSGTXxZAlW8Tk0ad+IGmI+ix2eqAY1e08qrbYANv5PKbRnja3Zny7KFvFwrA7cks
         AgfoBywXsJWjQc3SwOBwJJoZr1fTjrQlbDlfn2P1fpENoW0Cl9k0+mblYFIfOkp6Wxyo
         oJVIEreB3D35MrTGzvwQWQGzOATgn2v+aX+nS/dHSVkWmLyZq0TUkrBTGhhtwwSfzQm5
         EEPg==
X-Gm-Message-State: AC+VfDy3VTDELB/lwWXn2/ldg3VxX7RBCkZ8DgfGgaCyyn3ZX3RI8QsU
        6Ei3/DT2j7bAHi6zoVEMkFoWadWsVHd2XYmEiws=
X-Google-Smtp-Source: ACHHUZ7szPdq8nAsjtrbbCjnUMfzTqkxB5OaQ1LAhGSR15ynqvE3hgFa2flarU6EkugfhtWHpq8Tuw==
X-Received: by 2002:a05:6870:f591:b0:192:5423:10f0 with SMTP id eh17-20020a056870f59100b00192542310f0mr6609823oab.5.1686602273221;
        Mon, 12 Jun 2023 13:37:53 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o27-20020a02c6bb000000b004186badba5esm2903485jan.36.2023.06.12.13.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 13:37:52 -0700 (PDT)
Message-ID: <dc043733-b892-3abd-6e3b-4104bec3de2e@kernel.dk>
Date:   Mon, 12 Jun 2023 14:37:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5/6] io_uring: add support for futex wake and wait
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, andres@anarazel.de
References: <20230609183125.673140-1-axboe@kernel.dk>
 <20230609183125.673140-6-axboe@kernel.dk> <87352w3bsg.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87352w3bsg.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/23 10:06?AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Add support for FUTEX_WAKE/WAIT primitives.
> 
> This is great.  I was so sure io_uring had this support already for some
> reason.  I might have dreamed it.

I think you did :-)

> The semantics are tricky, though. You might want to CC peterZ and tglx
> directly.

For sure, I'll take it wider soon enough. Just wanted to iron out
io_uring details first.

>> IORING_OP_FUTEX_WAKE is mix of FUTEX_WAKE and FUTEX_WAKE_BITSET, as
>> it does support passing in a bitset.
> 
> As far as I know, the _BITSET variant are not commonly used in the
> current interface.  I haven't seen any code that really benefits from
> it.

Since FUTEX_WAKE is a strict subset of FUTEX_WAKE_BITSET, makes little
sense to not just support both imho.

>> Similary, IORING_OP_FUTEX_WAIT is a mix of FUTEX_WAIT and
>> FUTEX_WAIT_BITSET.
> 
> But it is definitely safe to have a single one, basically with the
> _BITSET semantics.

Yep I think so.

>> FUTEX_WAKE is straight forward, as we can always just do those inline.
>> FUTEX_WAIT will queue the futex with an appropriate callback, and
>> that callback will in turn post a CQE when it has triggered.
> 
> Even with an asynchronous model, it might make sense to halt execution
> of further queued operations until futex completes.  I think
> IOSQE_IO_DRAIN is a barrier only against the submission part, so it
> wouldn't hep.  Is there a way to ensure this ordering?

You'd use link for that - link whatever depends on the wake to the futex
wait. Or just queue it up once you reap the wait completion, when that
is posted because we got woken.

> I know, it goes against the asynchronous nature of io_uring, but I think
> it might be a valid use case. Say we extend FUTEX_WAIT with a way to
> acquire the futex in kernel space.  Then, when the CQE returns, we know
> the lock is acquired.  if we can queue dependencies on that (stronger
> than the link semantics), we could queue operations to be executed once
> the lock is taken. Makes sense?

It does, and acquiring it _may_ make sense indeed. But I'd rather punt
that to a later thing, and focus on getting the standard (and smaller)
primitives done first.

>> Cancelations are supported, both from the application point-of-view,
>> but also to be able to cancel pending waits if the ring exits before
>> all events have occurred.
>>
>> This is just the barebones wait/wake support. Features to be added
>> later:
> 
> One item high on my wishlist would be the futexv semantics (wait on any
> of a set of futexes).  It cannot be implemented by issuing several
> FUTEX_WAIT.

Yep, I do think that one is interesting enough to consider upfront.
Unfortunately the internal implementation of that does not look that
great, though I'm sure we can make that work. But would likely require
some futexv refactoring to make it work. I can take a look at it.

You could obviously do futexv with this patchset, just posting N futex
waits and canceling N-1 when you get woken by one. Though that's of
course not very pretty or nice to use, but design wise it would totally
work as you don't actually block on these with io_uring.

-- 
Jens Axboe

