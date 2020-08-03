Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC12E23B0F9
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 01:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHCXe3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 19:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgHCXe3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 19:34:29 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B308DC06174A
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 16:34:28 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x24so4041640lfe.11
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 16:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v8TTFTWbfKbzJ4mcB7seLc7/y2CHIUC97FgV8OkOono=;
        b=F+DIMYJhv5KPMlGDUTa9T/vYKNhd4CXOo71c2kks4dabj/+B1XBvF+aGTQ/nTePvid
         pK1HKnl+/vF74yKZh3I7XgnZjUrsPJ0JL1paxKh7jyAk1/Nb/kpbRlC6gRQdGMLRxJrW
         iTMkXCCLr3T4gE/XyW10n4kVc9Vb0XMmu7ocs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v8TTFTWbfKbzJ4mcB7seLc7/y2CHIUC97FgV8OkOono=;
        b=n/jj+/sKMumzgSmXC0CXWJF4X1ZJYcHhfgUws+dak3FAiKW6KycEImUUm2G66VsSBs
         OdB1f2pcVXgmiwM3H5DJ+ZGU0U2q8izx/Mrm//on0hzotGSscq54X6GzDR/BHsxPROhr
         BMIxyCuNBp4yBfUz20ls3S2pe3m2W+aC5BTtAPRwn7ePlxq3PgD+dUE8Dsi+kfEzypGg
         e9EhjZq6+YlDmuxY5MmdYaMlOnoeUErhnunqKNkqD+AlORuPh3bKUgXrux1eXJ2hZRrU
         gdtZwZ/egijX77YCrxk4x3Yy9XlBCIpcQQK53fBTDXBdLH7Ve4fd/WkA19Z+9+wS8Dvu
         +sEw==
X-Gm-Message-State: AOAM531oEq5FldbLq1ZYa04YPVwet3oYVNYz+u4BkrRtrFxk+R0e0eRl
        iHF6hKrOWCFkbiqIx/YSkJNSAR1AXNY=
X-Google-Smtp-Source: ABdhPJzsYGavD2CGh+AAXJv2ANdAyTXlA84rkj/tTiDcLeEiG1FjVVZN2C5qR/+GFVXDotOacdZ99w==
X-Received: by 2002:ac2:5cbb:: with SMTP id e27mr9475637lfq.121.1596497666746;
        Mon, 03 Aug 2020 16:34:26 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id c21sm5413684lfh.38.2020.08.03.16.34.25
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:34:26 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id v15so16832587lfg.6
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 16:34:25 -0700 (PDT)
X-Received: by 2002:a05:6512:3b7:: with SMTP id v23mr9734948lfp.10.1596497665541;
 Mon, 03 Aug 2020 16:34:25 -0700 (PDT)
MIME-Version: 1.0
References: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk>
 <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
 <cd478521-e6ec-a1aa-5f93-29ad13d2a8bb@kernel.dk> <56cb11b1-7943-086e-fb31-6564f4d4d089@kernel.dk>
In-Reply-To: <56cb11b1-7943-086e-fb31-6564f4d4d089@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Aug 2020 16:34:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=whUiXjy5=LPQzNf2ruT3U6eELtXv7Cp9icN4eB4ByjROQ@mail.gmail.com>
Message-ID: <CAHk-=whUiXjy5=LPQzNf2ruT3U6eELtXv7Cp9icN4eB4ByjROQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring changes for 5.9-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 3, 2020 at 4:18 PM Jens Axboe <axboe@kernel.dk> wrote:
>
>
> I took a look at the rewrite you queued up, and made a matching change
> on the io_uring side:

Oh, no, you made it worse.

Now you're tying your odd wakeup routine to entirely irrelevant things
that can't even happen to you.

That io_async_buf_func() will never be called for any entry that isn't
your own, so testing

        wait->flags & WQ_FLAG_EXCLUSIVE

is completely pointless, because you never set that flag. And
similarly, for you to then do

        wait->flags |= WQ_FLAG_WOKEN;

is equally pointless, because the only thing that cares and looks at
that wait entry is you, and you don't care about the WOKEN flag.

So that patch shows a fundamental misunderstanding of how the
waitqueues actually work.

Which is kind of my _point_. The io_uring code that hooked into the
page wait queues really looks like complete cut-and-paste voodoo
programming.

It needs comments. It's hard to follow. Even somebody like me, who
actually knows how the page wait queues really work, have a really
hard time following how io_uring initializing a wait-queue entry and
pointing to it in the io ctx then interacts with the (later) generic
file reading path, and how it then calls back at unlock time to the
io_uring callback _if_ the page was locked.

And that patch you point to makes me 100% sure you don't quite
understand the code either.

So when you do

    /*
     * Only test the bit if it's an exclusive wait, as we know the
     * bit is cleared for non-exclusive waits. Also see mm/filemap.c
     */
    if ((wait->flags & WQ_FLAG_EXCLUSIVE) &&
        test_and_set_bit(key->bit_nr, &key->page->flags))
              return -1;

the first test guarantees that the second test is never done, which is
good, because if it *had* been done, you'd have taken the lock and
nothing you have actually expects that.

So the fix is to just remove those lines entirely. If somebody
unlocked the page you care about, and did a wakeup on that page and
bit, then you know you should start the async worker. Noi amount of
testing bits matters at all.

And similarly, the

    wait->flags |= WQ_FLAG_WOKEN;

is a no-op because nothing tests that WQ_FLAG_WOKEN bit. That wait
entry is _your_ wait entry. It's not the wait entry of some normal
page locker - those use wake_page_function().

Now *if* you had workers that actually expected to be woken up with
the page lock already held, and owning it, then that kind of
WQ_FLAG_EXCLUSIVE and WQ_FLAG_WOKEN logic would be a good idea. But
that's not what you have.

> and also queued a documentation patch for the retry logic and the
> callback handler:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=9541a9d4791c2d31ba74b92666edd3f1efd936a8

Better. Although I find the first comment a bit misleading.

You say

    /* Invoked from our "page is now unlocked" handler when someone ..

but that's not really the case. The function gets called by whoever
unlocks the page after you've registered that page wait entry through
lock_page_async().

So there's no "our handler" anywhere, which I find misleading and
confusing in the comment.

         Linus
