Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB853E7CE6
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243049AbhHJPzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 11:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242563AbhHJPzi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 11:55:38 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9405CC0613C1;
        Tue, 10 Aug 2021 08:55:16 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n11so13398675wmd.2;
        Tue, 10 Aug 2021 08:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CjDLKR8li4rTZi6TgX6lcshQGEtX3BrsmDKJl9xgNW0=;
        b=lariljgWH7syzhpW6dbu1zdhMe6Kzc1Xmg7r5Ndo6u0TS0TwH+8XskpGlhuTxOeYeP
         U4ozPgqPRGe6X1Zl0xBsB7HEwBYS0AVkL+mCgchbJSbI3ISbH6c+X+z2DS71Zs6Z6HEv
         93TU9BznvlYsY+4VXStPjLVNgVWHG9L78tROCduxnEXGUtcg36QBjWyDbEkA6wMoOZ8V
         NVtoQ/sMEt+g1FlxmI0JbU7Yikv5UbLy3rtb6XFLtXcNOvotp1qCcVoJGSbmmA6tmWot
         aFrQrElGMQL8wa3ISKjJWoZ0PNqEexdIKKMhyAFwiBkpM61XR8ICud9d7EKXU26AOr4K
         MjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CjDLKR8li4rTZi6TgX6lcshQGEtX3BrsmDKJl9xgNW0=;
        b=sd1mUedWbYt3vopuQIsL4kAHTUqfccUIf07u7G9UDFPrtrt+kNhTTB5qyMg+suORhU
         jgI/6hxc+V2ldh/yNIaslrs2fPZQ8zPc/b8hNeluN1PaH9QU8LHIMIKsnMA/brpDV8/O
         sPswyjux2k25tD6fnnIy4AFye/ltUWsojX+IfdgbJyvdjBA/LguuIH7roHu6bGF1XUSO
         2Z3ghf01XDDhrwstaJgPMW+xRwH2ORLWCwIywM9bn5UkJVvCpToLKdrtIkOMsKxuphuu
         ob2z2cGAje2Jlcj3HQ3jPwx8NAmk5cMOpXWdfc8jg71sQPp0yIgDFZb8JRs/VC6RMdDz
         NYQA==
X-Gm-Message-State: AOAM530HafhqKyflQB2L2K1ifEmbUIppjQnYEzuVWz3iIvcPIN3Akvrd
        XjmWOuNLt7Z2sFABNx+rDYQ/znBQaM31SKwSSOU=
X-Google-Smtp-Source: ABdhPJydltLLXvnJh0zqKxJOceAnovFS++sQw0BeARcDNNG/TEvWlC0Q3qqv5tfxYPZ6/WU3Gzl+G/HsiM00q1mpHFQ=
X-Received: by 2002:a05:600c:3b8f:: with SMTP id n15mr5397381wms.155.1628610915110;
 Tue, 10 Aug 2021 08:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210809212401.19807-1-axboe@kernel.dk> <20210809212401.19807-2-axboe@kernel.dk>
 <YRJ74uUkGfXjR52l@T590> <79511eac-d5f2-2be3-f12c-7e296d9f1a76@kernel.dk> <6c06ac42-bda4-cef6-6b8e-7c96eeeeec47@kernel.dk>
In-Reply-To: <6c06ac42-bda4-cef6-6b8e-7c96eeeeec47@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 10 Aug 2021 21:24:50 +0530
Message-ID: <CA+1E3r+otujBbY8E49QL_MmxA_bGRTaivFbOkCvNvZEr93q=7g@mail.gmail.com>
Subject: Re: [PATCH 1/4] bio: add allocation cache abstraction
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 10, 2021 at 8:18 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/10/21 7:53 AM, Jens Axboe wrote:
> > On 8/10/21 7:15 AM, Ming Lei wrote:
> >> Hi Jens,
> >>
> >> On Mon, Aug 09, 2021 at 03:23:58PM -0600, Jens Axboe wrote:
> >>> Add a set of helpers that can encapsulate bio allocations, reusing them
> >>> as needed. Caller must provide the necessary locking, if any is needed.
> >>> The primary intended use case is polled IO from io_uring, which will not
> >>> need any external locking.
> >>>
> >>> Very simple - keeps a count of bio's in the cache, and maintains a max
> >>> of 512 with a slack of 64. If we get above max + slack, we drop slack
> >>> number of bio's.
> >>>
> >>> The cache is intended to be per-task, and the user will need to supply
> >>> the storage for it. As io_uring will be the only user right now, provide
> >>> a hook that returns the cache there. Stub it out as NULL initially.
> >>
> >> Is it possible for user space to submit & poll IO from different io_uring
> >> tasks?
> >>
> >> Then one bio may be allocated from bio cache of the submission task, and
> >> freed to cache of the poll task?
> >
> > Yes that is possible, and yes that would not benefit from this cache
> > at all. The previous version would work just fine with that, as the
> > cache is just under the ring lock and hence you can share it between
> > tasks.
> >
> > I wonder if the niftier solution here is to retain the cache in the
> > ring still, yet have the pointer be per-task. So basically the setup
> > that this version does, except we store the cache itself in the ring.
> > I'll give that a whirl, should be a minor change, and it'll work per
> > ring instead then like before.
>
> That won't work, as we'd have to do a ctx lookup (which would defeat the
> purpose), and we don't even have anything to key off of at that point...
>
> The current approach seems like the only viable one, or adding a member
> to kiocb so we can pass in the cache in question. The latter did work
> just fine, but I really dislike the fact that it's growing the kiocb to
> more than a cacheline.
>
Still under a cacheline seems. kiocb took 48 bytes, and adding a
bio-cache pointer made it 56.

-- 
Kanchan
