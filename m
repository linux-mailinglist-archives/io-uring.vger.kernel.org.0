Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3A723B12F
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 01:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgHCXno (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 19:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgHCXno (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 19:43:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A01DC06174A
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 16:43:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t10so16520277plz.10
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 16:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wTUV0IlBas5oY3OHR4PGqhPRpHlIYrzKntHQwyyC4pg=;
        b=JZwkyV/3Eehf9b+PMt5bu/laXByrKXwimmNuxX/xGhhZtg2tbSGS/YWaeMibIfmacK
         URdiACIdYLA/D54h+t5KqvoiEWtQcmbxfm8jJT1JRADgZD0H9VsIE5deUKlFwT8C+i/k
         ZodCKD6CU1WqIs12YAbRP2tcheRreCm6H5PaeCKcI5gF0l//JlTaZNm3Muwbgx81uxH2
         eXW/XmFLc6sT2LgYKuChxNaNQp9JkiuN/dfDvigt5NDHG0hJLDNHcN6mfp2CkyoThb48
         d4UO/4dNIxh2E+BKVuSBMURBDTC9aRwpgd2KtHdZ1/tbzXLoLwgJ8VqK9N7Q9PsRIvF3
         QQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wTUV0IlBas5oY3OHR4PGqhPRpHlIYrzKntHQwyyC4pg=;
        b=F47IpnR2T/JcTgQ8412vcFxbFZHyczmlMVveH2ctLXaikszYZ6va71aBvlBvBLDUl0
         JfNQKDa2CBvKM7w6Q/r6Q9C36AuJKUw3hMvu9V/FOrJSVLNmGLFjDl9w6qo79G95pYtU
         07aAcuFJUfIJG+wmjVPqujlSK4dJ4A4/mSjWd+TdQn1A98e+kp5qaa368k3qy0bFZPJP
         paxeFFc9N5VUN302g8AqGKg/A7P9FI4YQoPMbLUVJHtbRgDeusy0hfgWoG7R5bFns67u
         SGg9RZQZ85a635mb0aPcGqU/A7PJRhyNz3XfP1m1fqdw9Thyilz1xGzQRjq8Q4IwKfP9
         B1IA==
X-Gm-Message-State: AOAM533X7RXkAWQUTZFnt4ZHFllMcSte1tI9S03d9jHe+ugBWWxuHIWR
        XfrPWyCwqsAaUUzV3wYUHA89SyBdww4=
X-Google-Smtp-Source: ABdhPJz4TXBq0r8YZ1GaCInBFqCj9mQJXkGirDbrQ/Gxaf7fypSbh8x+8m4vz5SckNI47yunXJSYTA==
X-Received: by 2002:a17:902:b40f:: with SMTP id x15mr16327490plr.329.1596498223585;
        Mon, 03 Aug 2020 16:43:43 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n13sm536262pjb.20.2020.08.03.16.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:43:43 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring changes for 5.9-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk>
 <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
 <cd478521-e6ec-a1aa-5f93-29ad13d2a8bb@kernel.dk>
 <56cb11b1-7943-086e-fb31-6564f4d4d089@kernel.dk>
 <CAHk-=whUiXjy5=LPQzNf2ruT3U6eELtXv7Cp9icN4eB4ByjROQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cb4b53ff-2e61-ca48-e3fc-517827927e60@kernel.dk>
Date:   Mon, 3 Aug 2020 17:43:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whUiXjy5=LPQzNf2ruT3U6eELtXv7Cp9icN4eB4ByjROQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/20 5:34 PM, Linus Torvalds wrote:
> On Mon, Aug 3, 2020 at 4:18 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>
>> I took a look at the rewrite you queued up, and made a matching change
>> on the io_uring side:
> 
> Oh, no, you made it worse.
> 
> Now you're tying your odd wakeup routine to entirely irrelevant things
> that can't even happen to you.
> 
> That io_async_buf_func() will never be called for any entry that isn't
> your own, so testing
> 
>         wait->flags & WQ_FLAG_EXCLUSIVE
> 
> is completely pointless, because you never set that flag. And
> similarly, for you to then do
> 
>         wait->flags |= WQ_FLAG_WOKEN;
> 
> is equally pointless, because the only thing that cares and looks at
> that wait entry is you, and you don't care about the WOKEN flag.
> 
> So that patch shows a fundamental misunderstanding of how the
> waitqueues actually work.
> 
> Which is kind of my _point_. The io_uring code that hooked into the
> page wait queues really looks like complete cut-and-paste voodoo
> programming.
> 
> It needs comments. It's hard to follow. Even somebody like me, who
> actually knows how the page wait queues really work, have a really
> hard time following how io_uring initializing a wait-queue entry and
> pointing to it in the io ctx then interacts with the (later) generic
> file reading path, and how it then calls back at unlock time to the
> io_uring callback _if_ the page was locked.
> 
> And that patch you point to makes me 100% sure you don't quite
> understand the code either.
> 
> So when you do
> 
>     /*
>      * Only test the bit if it's an exclusive wait, as we know the
>      * bit is cleared for non-exclusive waits. Also see mm/filemap.c
>      */
>     if ((wait->flags & WQ_FLAG_EXCLUSIVE) &&
>         test_and_set_bit(key->bit_nr, &key->page->flags))
>               return -1;
> 
> the first test guarantees that the second test is never done, which is
> good, because if it *had* been done, you'd have taken the lock and
> nothing you have actually expects that.
> 
> So the fix is to just remove those lines entirely. If somebody
> unlocked the page you care about, and did a wakeup on that page and
> bit, then you know you should start the async worker. Noi amount of
> testing bits matters at all.
> 
> And similarly, the
> 
>     wait->flags |= WQ_FLAG_WOKEN;
> 
> is a no-op because nothing tests that WQ_FLAG_WOKEN bit. That wait
> entry is _your_ wait entry. It's not the wait entry of some normal
> page locker - those use wake_page_function().
> 
> Now *if* you had workers that actually expected to be woken up with
> the page lock already held, and owning it, then that kind of
> WQ_FLAG_EXCLUSIVE and WQ_FLAG_WOKEN logic would be a good idea. But
> that's not what you have.

Yes, looks like I was a bit too trigger happy without grokking the whole
thing, and got it mixed up with the broader more generic waitqueue
cases. Thanks for clueing me in, I've updated the patch so the use case
is inline with only what io_uring is doing here.

>> and also queued a documentation patch for the retry logic and the
>> callback handler:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=9541a9d4791c2d31ba74b92666edd3f1efd936a8
> 
> Better. Although I find the first comment a bit misleading.
> 
> You say
> 
>     /* Invoked from our "page is now unlocked" handler when someone ..
> 
> but that's not really the case. The function gets called by whoever
> unlocks the page after you've registered that page wait entry through
> lock_page_async().
> 
> So there's no "our handler" anywhere, which I find misleading and
> confusing in the comment.

The 'handler' refers to the io_uring waitqueue callback, but I should
probably spell that out. I'll adjust it.

-- 
Jens Axboe

