Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7895466BA6
	for <lists+io-uring@lfdr.de>; Thu,  2 Dec 2021 22:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349095AbhLBV3p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 16:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243442AbhLBV3o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 16:29:44 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A425C061758
        for <io-uring@vger.kernel.org>; Thu,  2 Dec 2021 13:26:22 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id n6so1727235uak.1
        for <io-uring@vger.kernel.org>; Thu, 02 Dec 2021 13:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Hn9In6dG6/T2rUegQRPLN+LJLRotI0z9a+p2oSgmSw=;
        b=WcLNPe7hi8P0a769XfSLDW7w5eRkULcbKfx7dM8r6rxLfqJDSlKAGrRjzWgWCu1yBE
         FTcMiBj74CHLSYb2X7t8R6PffWxPZxiuRiM0VpHebGEJYZMPWozDd4/1DjJXMN9vz+SU
         9h8aWhii8li6bipguj05vVjcXY1Qe7+iUoCqHjelzow8TIE7G0sP3ExCUascltLi4NTH
         gIifVEf+zJhTBoAYpVxGTLo/G7tGu0Y7stdZkUaamJHkAyiinRIFuv0YGcgPFk7aJj05
         upSI/uq4CmgnoIxwcDoH3RKoNxhNAe0qWfmX2r484uDLtutlPGJ89f8DdLEEWVixhBgs
         g8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Hn9In6dG6/T2rUegQRPLN+LJLRotI0z9a+p2oSgmSw=;
        b=aaBTW85EYF5q/Xau0tl+y15yHdvPFQ9xuuELWt52jsoYBLyTHE0PKXNssfQRSMfQj1
         4A+tySlPofc2lzeS0RH/As3otVnYr55iIxunzjuFz1bECXN8A7cnOz98pXbeUJCtO+ES
         dCTIyG6U+CLisJfrC/cCBqXKbvdOCd1R4GYHsNQq+G3w9T3KZI+Lv+cgET2CNdBusf2Y
         apUSo9josNeVH79fnrks0GAQSg9EevFUyTOiDfPaXf7ocmaNMVEQoes1L/y9EM5ODT0D
         nUHiaPOVVMpabBWV8zbw1iOLiQcbCg2Ymt1hbSZTui2nvDXDB2JYrKqmCsRmB8uVRKCS
         cJTw==
X-Gm-Message-State: AOAM530Mn9bH6MO83QYo29tR8+Cd8MyG77DiAHsHEf8Hv7uxJQwDP780
        3/B3EYDoMwqWrOrS9IIGO+QXti0Fv6Q=
X-Google-Smtp-Source: ABdhPJxYIoLo35ShrdYSU/lmsHfbLGMAdsHsDYzNOYNWKK7OW4Ld2RnVCiPNXyqN6mJ78L/nl3UUrA==
X-Received: by 2002:a67:ec10:: with SMTP id d16mr18367918vso.58.1638480381043;
        Thu, 02 Dec 2021 13:26:21 -0800 (PST)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com. [209.85.221.169])
        by smtp.gmail.com with ESMTPSA id t20sm196376vsj.27.2021.12.02.13.26.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 13:26:20 -0800 (PST)
Received: by mail-vk1-f169.google.com with SMTP id b192so514684vkf.3
        for <io-uring@vger.kernel.org>; Thu, 02 Dec 2021 13:26:19 -0800 (PST)
X-Received: by 2002:a05:6122:1350:: with SMTP id f16mr19584323vkp.10.1638480379557;
 Thu, 02 Dec 2021 13:26:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638282789.git.asml.silence@gmail.com> <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
 <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com> <CA+FuTSf1dk-ZCN_=oFcYo31XdkLLAaHJHHNfHwJKe01CVq3X+A@mail.gmail.com>
 <6e07fb0c-075b-4072-273b-f9d55ba1e1dd@gmail.com>
In-Reply-To: <6e07fb0c-075b-4072-273b-f9d55ba1e1dd@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 2 Dec 2021 16:25:42 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfe63=SuuZeC=eZPLWstgOL6oFUrsL4o+J8=3BwHJSTVg@mail.gmail.com>
Message-ID: <CA+FuTSfe63=SuuZeC=eZPLWstgOL6oFUrsL4o+J8=3BwHJSTVg@mail.gmail.com>
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

> > What if the ubuf pool can be found from the sk, and the index in that
> > pool is passed as a cmsg?
>
> It looks to me that ubufs are by nature is something that is not
> tightly bound to a socket (at least for io_uring API in the patchset),
> it'll be pretty ugly:
>
> 1) io_uring'd need to care to register the pool in the socket. Having
> multiple rings using the same socket would be horrible. It may be that
> it doesn't make much sense to send in parallel from multiple rings, but
> a per thread io_uring is a popular solution, and then someone would
> want to pass a socket from one thread to another and we'd need to support
> it.
>
> 2) And io_uring would also need to unregister it, so the pool would
> store a list of sockets where it's used, and so referencing sockets
> and then we need to bind it somehow to io_uring fixed files or
> register all that for tracking referencing circular dependencies.
>
> 3) IIRC, we can't add a cmsg entry from the kernel, right? May be wrong,
> but if so I don't like exposing basically io_uring's referencing through
> cmsg. And it sounds io_uring would need to parse cmsg then.
>
>
> A lot of nuances :) I'd really prefer to pass it on per-request basis,

Ok

> it's much cleaner, but still haven't got what's up with msghdr
> initialisation...

And passing the struct through multiple layers of functions.

> Maybe, it's better to add a flags field, which would include
> "msg_control_is_user : 1" and whether msghdr includes msg_iocb, msg_ubuf,
> and everything else that may be optional. Does it sound sane?

If sendmsg takes the argument, it will just have to be initialized, I think.

Other functions are not aware of its existence so it can remain
uninitialized there.
