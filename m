Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C36C467B65
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 17:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241840AbhLCQeX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 11:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353069AbhLCQeX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 11:34:23 -0500
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A370C061353
        for <io-uring@vger.kernel.org>; Fri,  3 Dec 2021 08:30:59 -0800 (PST)
Received: by mail-vk1-xa29.google.com with SMTP id e27so2205071vkd.4
        for <io-uring@vger.kernel.org>; Fri, 03 Dec 2021 08:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fy6nFfjADw6fr8YI8a7lhyf+7ziGDaRPP8bieG/IP5k=;
        b=U0hdU6lIyPXdwQfpH3O2TsoxFPwgmk/EQR7bf+BguobfjjsTaPzo/xXepEyXbpgBpm
         0XmdjKHmqxI4pIGbwNnjVVkGY8R3NAwdJARNAWqSDEcv3kHiIeVjmO23yneUZG1BPZQK
         p+DQ0iLSMVfK15FPrwV6xU7fUziB2e5f21qUpiWXEeosvVDivvAJf6lX6cYnupY6SvMX
         8D68n2lV3lSdZ72dhYgwV1s21v6RktQrVJ8nLALQD0Yfyt9DvwcsOdX1vmKCpdKGBYuQ
         aFoum+p9Qc38DaE9qDg5CQ5mJtBwJm2x5zFe5gLBcScxC3hsv+5NA65IxmjQdC8tK9Lk
         OYxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fy6nFfjADw6fr8YI8a7lhyf+7ziGDaRPP8bieG/IP5k=;
        b=gflPgCDxChHc9syHAvC84uqQ2x/dlKCSQkfrgY2mrTo4FS8HRpPJeaOYMmy7WurLo2
         E9sanKkHRUWz76R8zfg9NUNFLxwWhvPR6tSSBfYPaMg+App5v24okkq0bq05UZc0Cx4/
         j74uWqbc39lglvb4N7nGM5pi4VETAiDwrJ9n4tB02tgm4at2sqGglKSsaHcgXIGXMhCD
         bMwx+4cY5DtsPJ+wHwtBoSLZN13FEkrCffLzp43lie63Vh2sIBnXdI2enbkPhxYAhtNZ
         28orVqh1+Rv11hAbZV4m9HjwNAfQNwKkAEQ6bkzvdfk4OYs7iZSUi0oAhktR2pndK0QT
         NNqA==
X-Gm-Message-State: AOAM532okJ+r7VJTDVfC7D4gjjYw0cKjsOJS2onNgIBlibvubsZK7KYP
        SKYrA//8FfCusWdwhRjE1c3A0e1yloE=
X-Google-Smtp-Source: ABdhPJxNFgcbCMku3njmuegHvOqnZHptp3yP9YD55XmXV8cZCgIAKxOQCcsiEhAzVntLq+iAQFFwPw==
X-Received: by 2002:a1f:78c1:: with SMTP id t184mr23771249vkc.39.1638549058519;
        Fri, 03 Dec 2021 08:30:58 -0800 (PST)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id u145sm579167vsu.25.2021.12.03.08.30.57
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 08:30:57 -0800 (PST)
Received: by mail-vk1-f176.google.com with SMTP id q21so2210031vkn.2
        for <io-uring@vger.kernel.org>; Fri, 03 Dec 2021 08:30:57 -0800 (PST)
X-Received: by 2002:a05:6122:1350:: with SMTP id f16mr24382684vkp.10.1638549057130;
 Fri, 03 Dec 2021 08:30:57 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638282789.git.asml.silence@gmail.com> <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
 <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com> <CA+FuTSf1dk-ZCN_=oFcYo31XdkLLAaHJHHNfHwJKe01CVq3X+A@mail.gmail.com>
 <6e07fb0c-075b-4072-273b-f9d55ba1e1dd@gmail.com> <CA+FuTSfe63=SuuZeC=eZPLWstgOL6oFUrsL4o+J8=3BwHJSTVg@mail.gmail.com>
 <e79a9cf6-b315-d4a5-a4a8-1071b5046c6e@gmail.com>
In-Reply-To: <e79a9cf6-b315-d4a5-a4a8-1071b5046c6e@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 3 Dec 2021 11:30:21 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeNvG9XCv0a8W0h1vZL+CrVQJnv-Ym57LfS3HnsDjLKSA@mail.gmail.com>
Message-ID: <CA+FuTSeNvG9XCv0a8W0h1vZL+CrVQJnv-Ym57LfS3HnsDjLKSA@mail.gmail.com>
Subject: Re: [RFC 00/12] io_uring zerocopy send
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 3, 2021 at 11:19 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 12/2/21 21:25, Willem de Bruijn wrote:
> >>> What if the ubuf pool can be found from the sk, and the index in that
> >>> pool is passed as a cmsg?
> >>
> >> It looks to me that ubufs are by nature is something that is not
> >> tightly bound to a socket (at least for io_uring API in the patchset),
> >> it'll be pretty ugly:
> >>
> >> 1) io_uring'd need to care to register the pool in the socket. Having
> >> multiple rings using the same socket would be horrible. It may be that
> >> it doesn't make much sense to send in parallel from multiple rings, but
> >> a per thread io_uring is a popular solution, and then someone would
> >> want to pass a socket from one thread to another and we'd need to support
> >> it.
> >>
> >> 2) And io_uring would also need to unregister it, so the pool would
> >> store a list of sockets where it's used, and so referencing sockets
> >> and then we need to bind it somehow to io_uring fixed files or
> >> register all that for tracking referencing circular dependencies.
> >>
> >> 3) IIRC, we can't add a cmsg entry from the kernel, right? May be wrong,
> >> but if so I don't like exposing basically io_uring's referencing through
> >> cmsg. And it sounds io_uring would need to parse cmsg then.
> >>
> >>
> >> A lot of nuances :) I'd really prefer to pass it on per-request basis,
> >
> > Ok
> >
> >> it's much cleaner, but still haven't got what's up with msghdr
> >> initialisation...
> >
> > And passing the struct through multiple layers of functions.
>
> If you refer to ip_make_skb(ubuf) -> __ip_append_data(ubuf), I agree
> it's a bit messier, will see what can be done. If you're about
> msghdr::msg_ubuf, for me it's more like passing a callback,
> which sounds like a normal thing to do.

Thanks, I do mean the first.

Also, small nit now that it comes up again msghdr::msg_ubuf is not
plain C. I would avoid that pseudo C++ notation (in the subject line
of 3/12)
>
> >> Maybe, it's better to add a flags field, which would include
> >> "msg_control_is_user : 1" and whether msghdr includes msg_iocb, msg_ubuf,
> >> and everything else that may be optional. Does it sound sane?
> >
> > If sendmsg takes the argument, it will just have to be initialized, I think.
> >
> > Other functions are not aware of its existence so it can remain
> > uninitialized there.
>
> Got it, need to double check, but looks something like 1/12 should
> be as you outlined.
>
> And if there will be multiple optional fields that have to be
> initialised, we would be able to hide all the zeroing under a
> single bitmask. E.g. instead of
>
> msg->field1 = NULL;
> ...
> msg->fieldN = NULL;
>
> It may look like
>
> msg->mask = 0; // HAS_FIELD1 | HAS_FIELDN;

Makes sense to me. This patch series only adds one field, so you can
leave the optimization for a possible future separate patch series?
