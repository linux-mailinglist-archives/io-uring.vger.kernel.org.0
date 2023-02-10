Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1446924CA
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 18:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbjBJRrt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 12:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbjBJRrs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 12:47:48 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB041C7CE
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 09:47:47 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ud5so17947881ejc.4
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 09:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qgcGO8+97UxFzUa9otLoe9WhcHYqh4IFJols7jxOVL4=;
        b=LPrqOkJVT4UEg85v/nAzVlpJ472gmcKMbYYeMraUOPgiYjqle9VbUDBs8e3Zm1gWBH
         WQRxTLfEGgHGfiMMIfID24IotHRUddIaw08CZd8coY3Et2DEy+b/r/ymu4POvA/PHwNn
         rJAnwEUqrti8kF2sB3Coh+mEuGxmaaVK+5Ue4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qgcGO8+97UxFzUa9otLoe9WhcHYqh4IFJols7jxOVL4=;
        b=e1yqJLZEG4czLe1x7sanJdJFZsssGmx0KyZBjSi93iJCbJW5P58fRD5t5eB8266iZD
         Flru/6p5YpJrB6LcC52KA0gNg1iKDYIMY7Rg470jxJHWzvNlhBbVTmjAQv9ETgtRafvL
         eHf6+7j0NnKab0u4jXofW+PfjlBauaw5Py3+rjbe3/+hM/2YtlxXIjAjS1H+IpJQhKyb
         ONEWnJEwI9sA0DSJ2Xpu7XSGaKJuRQBkqbidlofewdNOnznoS3mqSZMAs0Zwgk4L0D0Z
         0fsEb8oPoI8uIundPpeHXsy78HI4kWZq+Co64fo0QAz4i/BMjqgbJvcmZmB3yAm6tPBY
         7j7g==
X-Gm-Message-State: AO0yUKXmuhkscodQg7X9ng5XtoIjZkNk4ya2lO6Av2IhOeHmjnbZflAx
        ID9gZbpfCp4Mmy/m2I2RDTzuIvP5TOCAUY1q1jM=
X-Google-Smtp-Source: AK7set+wd7W4+bwvMAfS3xfokk4/lc0v69BNPjWazn5NqAZRtHVhLUXj7OW9MiKHjFI09UoAmAsbHw==
X-Received: by 2002:a17:907:1c90:b0:8aa:be1a:2d1b with SMTP id nb16-20020a1709071c9000b008aabe1a2d1bmr18093448ejc.46.1676051266054;
        Fri, 10 Feb 2023 09:47:46 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id ko3-20020a170907986300b0088b93bfa782sm2692899ejc.176.2023.02.10.09.47.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 09:47:45 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id ud5so17947742ejc.4
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 09:47:45 -0800 (PST)
X-Received: by 2002:a17:906:651:b0:88a:b6ca:7d3a with SMTP id
 t17-20020a170906065100b0088ab6ca7d3amr3101829ejb.1.1676051265120; Fri, 10 Feb
 2023 09:47:45 -0800 (PST)
MIME-Version: 1.0
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area> <20230210040626.GB2825702@dread.disaster.area>
 <CAHk-=wip9xx367bfCV8xaF9Oaw4DZ6edF9Ojv10XoxJ-iUBwhA@mail.gmail.com>
 <20230210061953.GC2825702@dread.disaster.area> <CAHk-=wj6jd0JWtxO0JvjYUgKfnGEj4BzPVOfY+4_=-0iiGh0tw@mail.gmail.com>
In-Reply-To: <CAHk-=wj6jd0JWtxO0JvjYUgKfnGEj4BzPVOfY+4_=-0iiGh0tw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Feb 2023 09:47:28 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgXvRKwsHUjA9T9Tw6n5x1pCO6B+4kk0GAx+oQ5qhUyRw@mail.gmail.com>
Message-ID: <CAHk-=wgXvRKwsHUjA9T9Tw6n5x1pCO6B+4kk0GAx+oQ5qhUyRw@mail.gmail.com>
Subject: Re: copy on write for splice() from file to pipe?
To:     Dave Chinner <david@fromorbit.com>
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 9:23 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And when it comes to networking, in general things like TCP checksums
> etc should be ok even with data that isn't stable.  When doing things
> by hand, networking should always use the "copy-and-checksum"
> functions that do the checksum while copying (so even if the source
> data changes, the checksum is going to be the checksum for the data
> that was copied).
>
> And in many (most?) smarter network cards, the card itself does the
> checksum, again on the data as it is transferred from memory.
>
> So it's not like "networking needs a stable source" is some really
> _fundamental_ requirement for things like that to work.
>
> But it may well be that we have situations where some network driver
> does the checksumming separately from then copying the data.

Ok, so I decided to try to take a look.

Somebody who actually does networking (and drivers in particular)
should probably check this, but it *looks* like the IPv4 TCP case
(just to pick the ony I looked at) gores through
tcp_sendpage_locked(), which does

        if (!(sk->sk_route_caps & NETIF_F_SG))
                return sock_no_sendpage_locked(sk, page, offset, size, flags);

which basically says "if you can't handle fragmented socket buffers,
do that 'no_sendpage' case".

So that will basically end up just falling back to a kernel
'sendmsg()', which does a copy and then it's stable.

But for the networks that *can* handle fragmented socket buffers, it
then calls do_tcp_sendpages() instead, which just creates a skb
fragment of the page (with tcp_build_frag()).

I wonder if that case should just require NETIF_F_HW_CSUM?

              Linus
