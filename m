Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD63423B149
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 01:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgHCX4G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 19:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgHCX4F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 19:56:05 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7027C06174A
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 16:56:03 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 74so10932695pfx.13
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 16:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qCO0I9XODj8tcvSwCtrfb839SzPfAPZbTABsM0q9zhw=;
        b=uxCHtMGDCPrDsexQiLlLDBwZTUIrXfXTceIkO6FI9lI3VQOB0vdPqeTq4h77KpjB73
         VSHlpQnTxWhFZYXqdvCdXfhDufN4d0KlatMO/xUIM63TY/zrdOvPlhjznDrowD1ZKENt
         5JfxdTrZzx3AwMtsPZDEflD7Pt6ofu2pAjL+ZxNTT5hM0RNnVeR6cf46Bzs2HSl/lioo
         x+awvymEwJfq4CVhq+WCS3plYffZ8TiCDg5zdpRfyo2AY1sGQ4/tc5FPAXuLWlao6Ejn
         RP/0FyzfQLGC5xQc6V8bTpCVegtIpTDj3VNoK1JHc/KJe5LBv3wjh86losl+zRlSOsGj
         P1YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qCO0I9XODj8tcvSwCtrfb839SzPfAPZbTABsM0q9zhw=;
        b=UlrHKSDKBmZssKkSmq+U2S884Ixw8liWgH1NHFismI8lKztK69NIDHoW8stYl/JsHG
         t3/r8DcIa1feycGO4VDUPzeqLVw4kca3Q2eSypLApXRI340uDifpNlxDSLUsks2WuC5h
         8RnvgbOjvpH4qGrHGH69wmN+Vd2qtfz/7AMRpZ+MjPPQLId9ChsxUYIdvVRMdl+mtW9u
         fBU4dg0u5JjJN5QkdVlGY7YzNALmJ1n5JJhJnaxM+ouAWHfX96GJVnPTgZJq/EC4vkAt
         5KYp06tfqfAsQwWIN7LsCl9tRN5ZdQqpl9QbLidNjh//Nn5+Vv0JziYDgnW4vRnUUT8k
         Pvzg==
X-Gm-Message-State: AOAM5317+5nwoG4aSeFw2SXEgF0bWDQDimKLGOR44+AhRStofplkTxrF
        S4zLpmi7bbvS9pI6Ak6gtl8z2gioQgM=
X-Google-Smtp-Source: ABdhPJw4erZ1mLXZJquGpjZezftNibkHzY3dF38trJudjVXYiIpV9XpjXP8xH2DbTlj4B7LQvfcOtg==
X-Received: by 2002:a65:6644:: with SMTP id z4mr17317591pgv.391.1596498963444;
        Mon, 03 Aug 2020 16:56:03 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x9sm22720340pfq.216.2020.08.03.16.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:56:02 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring changes for 5.9-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk>
 <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
 <cd478521-e6ec-a1aa-5f93-29ad13d2a8bb@kernel.dk>
 <56cb11b1-7943-086e-fb31-6564f4d4d089@kernel.dk>
 <025dcd45-46df-b3fa-6b4a-a8c6a73787b0@kernel.dk>
 <CAHk-=whZYCK2eNEcTvKWgBvoSL8YLT6G0dexVkFbDiVCLN3zBQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <af6b61c1-e98e-f312-3550-deb7972751a9@kernel.dk>
Date:   Mon, 3 Aug 2020 17:56:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whZYCK2eNEcTvKWgBvoSL8YLT6G0dexVkFbDiVCLN3zBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/20 5:49 PM, Linus Torvalds wrote:
> On Mon, Aug 3, 2020 at 4:31 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Updated to honor exclusive return value as well:
> 
> See my previous email, You're just adding code that makes no sense,
> because your wait entry fundamentally isn't an exclusive one.

Right, I get that now, it's just dead code for my use case. It was sent
out before your previous email.

> So all that code is a no-op and only makes it more confusing to read.
> 
> Your wakeup handler has _nothing_ to do with the generic
> wake_page_function(). There is _zero_ overlap. Your wakeup handler
> gets called only for the wait entries _you_ created.
> 
> Trying to use the wakeup logic from wake_page_function() makes no
> sense, because the rules for wake_page_function() are entirely
> different. Yes, they are called for the same thing (somebody unlocked
> a page and is waking up waiters), but it's using a completely
> different sleeping logic.
> 
> See? When wake_page_function() does that
> 
>         wait->flags |= WQ_FLAG_WOKEN;
> 
> and does something different (and returns different values) depending
> on whether WQ_FLAG_EXCLUSIVE was set, that is all because
> wait_on_page_bit_common() entry set yo that wait entry (on its stack)
> with those exact rules in mind.
> 
> So the wakeup function is 1:1 tied to the code that registers the wait
> entry. wait_on_page_bit_common() has one set of rules, that are then
> honored by the wakeup function it uses. But those rules have _zero_
> impact on your use. You can have - and you *do* have - different sets
> of rules.
> 
> For example, none of your wakeups are ever exclusive. All you do is
> make a work runnable - that doesn't mean that other people shouldn't
> do other things when they get a "page was unlocked" wakeup
> notification.
> 
> Also, for you "list_del_init()" is fine, because you never do the
> unlocked "list_empty_careful()" on that wait entry.  All the waitqueue
> operations run under the queue head lock.
> 
> So what I think you _should_ do is just something like this:
> 
>     diff --git a/fs/io_uring.c b/fs/io_uring.c
>     index 2a3af95be4ca..1e243f99643b 100644
>     --- a/fs/io_uring.c
>     +++ b/fs/io_uring.c
>     @@ -2965,10 +2965,10 @@ static int io_async_buf_func(struct
> wait_queue_entry *wait, unsigned mode,
>             if (!wake_page_match(wpq, key))
>                     return 0;
> 
>     -       /* Stop waking things up if the page is locked again */
>     -       if (test_bit(key->bit_nr, &key->page->flags))
>     -              return -1;
>     -
>     +       /*
>     +        * Somebody unlocked the page. Unqueue the wait entry
>     +        * and run the task_work
>     +        */
>              list_del_init(&wait->entry);
> 
>              init_task_work(&req->task_work, io_req_task_submit);
> 
> because that matches what you're actually doing.
> 
> There's no reason to stop waking up others because the page is locked,
> because you don't know what others want.
> 
> And there's never any reason for the exclusive thing, b3ecause none of
> what you do guarantees that you take exclusive ownership of the page
> lock. Running the work *may* end up doing a "lock_page()", but you
> don't actually guarantee that.

What I ended up with after the last email was just removing the test
bit:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=cbd287c09351f1d3a4b3cb9167a2616a11390d32

and I clarified the comments on the io_async_buf_func() to add more
hints on how everything is triggered instead of just a vague "handler"
reference:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=c1dd91d16246b168b80af9b64c5cc35a66410455

-- 
Jens Axboe

