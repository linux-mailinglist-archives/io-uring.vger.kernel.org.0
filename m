Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613E123B031
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 00:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHCWaT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 18:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCWaT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 18:30:19 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775C3C06174A
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 15:30:19 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id i92so624133pje.0
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 15:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v0vJe2QQbLuLRPOMGBeOLYW9mds4pN3IYDK7FBMExww=;
        b=lkgPlbjdA9qpgN9WtnK0CZkXcM26LDe1n29A6AZqeAl+b2maq5U9lnBF71WfT3lr57
         TtcF48r7QTmZav0nVDc4Fsz1BtVzHMDJfRs3Daa9DW+9vtgLTop9CXglAWn3H5t0i8iU
         SDP1+7yAoLQ7MoJQ7Kgu7lpWcNXuQZAKn1EklPLARZlwCBFiXX29TAnj/Ke9elAxP9BW
         nybt5WprUtVc1xK4jbNPBgLZti0n05V4h2Kwl2wAFSpvYdnQZQ1pF0W0VWYSLmEdTUWq
         56xaVVdRilMZy4TIJJ+wbSSz8d4h214DePH4ymqfTs2IsfFrwUtnFCi2mdKiaEPqcpyZ
         GC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v0vJe2QQbLuLRPOMGBeOLYW9mds4pN3IYDK7FBMExww=;
        b=FNV9UsfnqF6BBbD84Vpro7xn1qLKxPs0lU950woz8qCMB4tHgqBhoaTnPBVLoz4QvH
         Be+JghKOIafvZfku6fmkx86ojcTzeinHqow9a4fk572N1aK5cT4e//EeLD/OMgBNH/wk
         Zj3GwSRkEn3+86wuwHzieEAuZKNnbe73XyISeKP/XMJ8WVeDz3AoAZNh9gXWIblq067X
         brO+u9ucNmtV6mqpaLW6tUW6+1QQ4ShkjWUFGTgDWayguA/Ykm6YnUT/EwtxTh2uwy8K
         4ZEleHI+tjxkbsM5hiyCygWJSsASGDItbPl7eCr2+sUvtH7yiiQjLLwfkdCiASXrRkZY
         5Svw==
X-Gm-Message-State: AOAM5318I0mKU2UyRIS+gVGQps3bvpj90/8BwWX42niScgYhXpB0/fZU
        ODNqOeeGhWAXh9RIbwRuZ7bAU8oig2M=
X-Google-Smtp-Source: ABdhPJwqzJFDSLzh8vMl+BtoQ1u9rRN5W6ckoucu7KKVBBZ/canVIGE0ALFEnbdZx4wx45vF1M9Aeg==
X-Received: by 2002:a17:90a:aa8f:: with SMTP id l15mr1346963pjq.123.1596493818792;
        Mon, 03 Aug 2020 15:30:18 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a26sm18374593pgm.20.2020.08.03.15.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 15:30:18 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring changes for 5.9-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk>
 <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cd478521-e6ec-a1aa-5f93-29ad13d2a8bb@kernel.dk>
Date:   Mon, 3 Aug 2020 16:30:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/20 2:48 PM, Linus Torvalds wrote:
> On Sun, Aug 2, 2020 at 2:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Lots of cleanups in here, hardening the code and/or making it easier to
>> read and fixing buts, but a core feature/change too adding support for
>> real async buffered reads. With the latter in place, we just need
>> buffered write async support and we're done relying on kthreads for the
>> fast path. In detail:
> 
> That async buffered reads handling the the page locking flag is a
> mess, and I'm really happy I committed my page locking scalability
> change early, so that the conflicts there caught it.
> 
> Re-using the page bit waitqueue types and exporting them?
> 
> That part is fine, I guess, particularly since it came from the
> wait_bit_key thing and have a smell of being generic.
> 
> Taking a random part of wake_page_function(), and calling it
> "wake_page_match()" even though that's not at all that it does?
> 
> Not ok.

OK, I actually thought it was kind of nice and better than having that
code duplicated in two spots.

> Adding random kiocb helper functions to a core header file, when they
> are only used in one place, and when they only make sense in that one
> place?
> 
> Not ok.

I'll move that into io_uring instead.

> When the function is called "wake_page_match()", you'd expect it
> matches the wake page information, wouldn't it?
> 
> Yeah, it did that. And then it also checked whether the bit we're
> waiting had been set again, because everybody ostensibly wanted that.
> Except they don't any more, and that's not what the name really
> implied anyway.
> 
> And kiocb_wait_page_queue_init() has absolutely zero business being in
> <linux/filemap.h>. There are absolutely no valid uses of that thing
> outside of the one place that calls it.
> 
> I tried to fix up the things I could.

Thanks! As mentioned, I'll prep a cleanup patch that moves the
kiocb_wait_page_queue_init() out of there.

> That said, like a lot of io_uring code, this is some seriously opaque
> code. You say you've done a lot of cleanups, but I'm not convinced
> those cleanups are in any way offsetting adding yet another union (how
> many bugs did the last one add?) and a magic flag of "use this part of
> the union" now.

I had to think a bit about what you are referring to here, but I guess
it's the iocb part. And yes, it's not ideal, but until we support polled
IO with buffered IO, then there's no overlap in the use case. And I
don't see us ever doing that.

> And I don't know what loads you use for testing that thing, or what
> happens when the "lock_page_async()" case actually fails to lock, and
> just calls back the io_async_buf_func() wakeup function when the page
> has unlocked...
> 
> That function doesn't actually lock the page either, but does the task
> work. I hope that work then knows to do the right thing, but it's
> really opaque and hard to follow.

The task work retries the whole thing, so it'll go through the normal
page cache read path again with all that that entails. We only really
ever use the callback to tell us when it's a good idea to retry again,
there's no other retained state there at all.

I didn't realize that part wasn't straight forward, so I'll add some
comments as well explaining how that code flow works.

It's seen a good amount of testing, both from myself and also from
others. The postgres IO rewrite has been putting it through its paces,
and outside of a few initial issues months ago, it's been rock solid.

> Anyway, I'm not entirely happy with doing these kinds of changes in
> the merge resolution, but the alternative was to not do the pull at
> all, and require you to do a lot of cleanups before I would pull it.
> Maybe I should have done that.
> 
> So this is a slightly grumpy email about how io_uring is (a) still
> making me very nervous about a very lackadaisical approach to things,
> and having the codepaths so obscure that I'm not convinced it's not
> horribly buggy. And (b) I fixed things up without really being able to
> test them. I tested that the _normal_ paths still seem to work fine,
> but..

I need to do a better job at commenting these parts, obviously. And
while nothing is perfect, and we're definitely perfect yet, the general
trend is definitely strongly towards getting rid of odd states through
flags and unifying more of the code, and tons of fixes/cleanups that
make things easier to read and verify...

> I really think that whole thing needs a lot of comments, particularly
> around the whole io_rw_should_retry() area.
>
> A bit and legible comment about how it will be caught by the
> generic_file_buffered_read() page locking code, how the two cases
> differ (it might get caught by the "I'm just waiting for it to be
> unlocked", but it could *also* get caught by the "lock page now"
> case), and how it continues the request.

Noted, I'll write that up.

> As it is, it bounces between the generic code and very io_uring
> specific code in strange and not easy to follow ways.
> 
> I've pushed out my merge of this thing, but you might also want to
> take a look at commit 2a9127fcf229 ("mm: rewrite
> wait_on_page_bit_common() logic"). I particular, the comment about how
> there's no point in even testing the page bit any more when you get
> woken up.
> 
> I left that
> 
>         if (test_bit(key->bit_nr, &key->page->flags))
>                 return -1;
> 
> logic in io_async_buf_func() (but it's not in "wake_page_match()" any
> more), but I suspect it's bogus and pointless, for the same reason
> that it isn't done for normal page waits now. Maybe it's better to
> just queue the actual work regardless, it will then be caught in the
> _real_ lock_page() or whatever it ends up doing - and if it only
> really wants to see the "uptodate" bit being set, and was just waiting
> for IO to finish, then it never really cared about the page lock bit
> at all, it just wanted to be notified about IO being done.

I just did notice your rewrite commit, and I'll adjust accordingly and
test it with that too.

> So this was a really long email to tell you - again - that I'm not
> happy  with how fragile io_uring is, and how the code seems to be
> almost intentionally written to *be* fragile. Complex and hard to
> understand, and as a result it has had a fairly high rate of fairly
> nasty bugs.
> 
> I'm hoping this isn't going to be yet another case of "nasty bugs
> because of complexity and a total disregard for explaining what is
> going on".

Outside of the review from Johannes, lots of other people did look over
the async buffered bits, and Andrew as well said it look good to him. So
while the task_work retry apparently isn't as obvious as I had hoped,
it's definitely not fragile or intentionally trying to be obtuse.

I'll make a few adjustments based on your feedback, and add a patch with
some comments as well. Hopefully that'll make the end result easier to
follow.

-- 
Jens Axboe

