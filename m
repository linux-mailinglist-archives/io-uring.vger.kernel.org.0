Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACF472D6B8
	for <lists+io-uring@lfdr.de>; Tue, 13 Jun 2023 03:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbjFMBJt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 21:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbjFMBJq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 21:09:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786D410C6
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 18:09:44 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-25bdae05eb3so387645a91.0
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 18:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686618584; x=1689210584;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qZ31Eejf6gGxMFCYNn50iENlEvlGAhtGTuwcm8797LQ=;
        b=FmZlSvkKP6AzCAOx4JjUkiZqrHHrMV6ScgST3tfkV1qvvvWhZGg5rTx32zGrS8zxDj
         rDUoV0dhR1yzGsH/qitdY6uvcfw+EC2sStWLV2n3c4IlnPIqlBXi7I1PvIe4qw8yseQk
         52OgiyT+PJXX/1MRqk5aRXjupg+93yLc7g7N9aC4tHaKuy+y3G+H2oaLfxhaUZcJ/u+0
         zAbyYNR3Wj/9fk5AU6GUfV/tnselVXO3LZOKz+jZ+fLKFMbRey/pR/lHjAwAPGO/TWwg
         c+Vbawpoi6MyuEM2bXYtyf0GS6p/dGfRsE8dsTOkkmkJXIWJD8TU6EigNIpV5FEcVVfT
         WrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686618584; x=1689210584;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qZ31Eejf6gGxMFCYNn50iENlEvlGAhtGTuwcm8797LQ=;
        b=gsFpIaxR18IP8uyjQA3Z9HeHwr9LkHfX/67WaP7mFjLcy0BL1gPxVhn+8t1llpgOhK
         +pEpumfAgiPi8v3sKfPztbGkHQVFbEuHB51DohDKe5eVw2ca5O9WoZqLGT+OYvmRZVnG
         dZmYbxTpMET7ucBzPoENsjiJrwVZ9YWso8X4AoEZAmkKnl5n8eAtpQMFCeK809bVv283
         /XCzW53CXYC6706Dbrg0gLeBgUssHzzxwpLFJ+SajvXyfw3aawXT0ASI2gI1GTq7gXoy
         pj5EfORj678fEXhfRs3qbZmh8zCcqeXIsKQDxiPXNx+CYm1UheFbxLQlbxzALyYnPzZc
         XKvA==
X-Gm-Message-State: AC+VfDwj2NbdXkv5i4byYi90QX/xNYMXZasqA8Ij/UdemjjenVnCMFPi
        kTl0p804JzYfElPXrNlSgM9/HBbuofUMR6ps2Bs=
X-Google-Smtp-Source: ACHHUZ6igg9aParRBUbSrN4DcOz0I0+R7sEt8+cvI4TF4KnVflVb44DdfWyWzx0JfhlDYV6nBqg9Nw==
X-Received: by 2002:a17:90b:3852:b0:25b:de63:f193 with SMTP id nl18-20020a17090b385200b0025bde63f193mr5703482pjb.4.1686618583770;
        Mon, 12 Jun 2023 18:09:43 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b15-20020a17090a010f00b00256799877ffsm8514718pjb.47.2023.06.12.18.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 18:09:43 -0700 (PDT)
Message-ID: <77293e8f-fbd2-be08-765a-513460781455@kernel.dk>
Date:   Mon, 12 Jun 2023 19:09:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5/6] io_uring: add support for futex wake and wait
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, andres@anarazel.de
References: <20230609183125.673140-1-axboe@kernel.dk>
 <20230609183125.673140-6-axboe@kernel.dk> <87352w3bsg.fsf@suse.de>
 <dc043733-b892-3abd-6e3b-4104bec3de2e@kernel.dk> <87r0qg1e25.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87r0qg1e25.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/23 5:00?PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 6/12/23 10:06?AM, Gabriel Krisman Bertazi wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> Add support for FUTEX_WAKE/WAIT primitives.
>>>
>>> This is great.  I was so sure io_uring had this support already for some
>>> reason.  I might have dreamed it.
>>
>> I think you did :-)
> 
> Premonitory!  Still, there should be better things to dream about than
> with the kernel code.

I dunno, if it's io_uring related I'm a supporter.

>>> Even with an asynchronous model, it might make sense to halt execution
>>> of further queued operations until futex completes.  I think
>>> IOSQE_IO_DRAIN is a barrier only against the submission part, so it
>>> wouldn't hep.  Is there a way to ensure this ordering?
>>
>> You'd use link for that - link whatever depends on the wake to the futex
>> wait. Or just queue it up once you reap the wait completion, when that
>> is posted because we got woken.
> 
> The challenge of linked requests, in my opinion, is that once a link
> chain starts, everything needs to be link together, and a single error
> fails everything, which is ok when operations are related, but
> not so much when doing IO to different files from the same ring.

Not quite sure if you're misunderstanding links, or just have a
different use case in mind. You can certainly have several independent
chains of links.

>>>> Cancelations are supported, both from the application point-of-view,
>>>> but also to be able to cancel pending waits if the ring exits before
>>>> all events have occurred.
>>>>
>>>> This is just the barebones wait/wake support. Features to be added
>>>> later:
>>>
>>> One item high on my wishlist would be the futexv semantics (wait on any
>>> of a set of futexes).  It cannot be implemented by issuing several
>>> FUTEX_WAIT.
>>
>> Yep, I do think that one is interesting enough to consider upfront.
>> Unfortunately the internal implementation of that does not look that
>> great, though I'm sure we can make that work.  ?  But would likely
>> require some futexv refactoring to make it work. I can take a look at
>> it.
> 
> No disagreement here.  To be fair, the main challenge was making the new
> interface compatible with a futex being waited on/waked the original
> interface. At some point, we had a really nice design for a single
> object, but we spent two years bikesheding over the interface and ended
> up merging something pretty much similar to the proposal from two years
> prior.

It turned out not to be too bad - here's a poc:

https://git.kernel.dk/cgit/linux/commit/?h=io_uring-futex&id=421b12df4ed0bb25c53afe496370bc2b70b04e15

needs a bit of splitting and cleaning, notably I think I need to redo
the futex_q->wake_data bit to make that cleaner with the current use
case and the async use case. With that, then everything can just use
futex_queue() and the only difference really is that the sync variants
will do timer setup upfront and then sleep at the bottom, where the
async part just calls the meat of the function.

>> You could obviously do futexv with this patchset, just posting N futex
>> waits and canceling N-1 when you get woken by one. Though that's of
>> course not very pretty or nice to use, but design wise it would totally
>> work as you don't actually block on these with io_uring.
> 
> Yes, but at that point, i guess it'd make more sense to implement the
> same semantics by polling over a set of eventfds or having a single
> futex and doing dispatch in userspace.

Oh yeah, would not recommend the above approach. Just saying that you
COULD do that if you really wanted to, which is not something you could
do with futex before waitv. But kind of moot now that there's at least a
prototype.

-- 
Jens Axboe

