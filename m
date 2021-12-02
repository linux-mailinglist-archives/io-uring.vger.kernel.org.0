Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145D3465B08
	for <lists+io-uring@lfdr.de>; Thu,  2 Dec 2021 01:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354628AbhLBAkY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 19:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235910AbhLBAkX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 19:40:23 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA794C06174A
        for <io-uring@vger.kernel.org>; Wed,  1 Dec 2021 16:37:01 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id r15so52724299uao.3
        for <io-uring@vger.kernel.org>; Wed, 01 Dec 2021 16:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o514D1uhYEuhVflwqtCZuE/ZpMReL0NhA7xwmfYSlag=;
        b=g+P9kPgV2HDyvGog5C8JdvOkx1/LJz+d7iJwKg7PWMfXLR9Z7bHpmRzY7OJMrXBenc
         Vr2F24EkEgLGkEVm7aRxKWrJ8rPL1rIs/kFYEY5hYFJtUSMfVxXiqCUny+1WWQZI6ibt
         +WgPNeEmWWelHagVXeI9196nciM57pA38C96o/6nWdzLrSFN2YmROMtzlYexPtto9wb9
         1Ru9opswNpzj1Kxpl5/+qAew5CBARJzqdZpYVXuImRXTSa4Ds7gKUK7vBjS+K0z4L7H9
         6QDCOKruK47OiMPvpyJ+HW/tLvPVRv5RNLFpOf/gXkSGIC+izuC69LKv2bkmaUG/AqIo
         OgkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o514D1uhYEuhVflwqtCZuE/ZpMReL0NhA7xwmfYSlag=;
        b=WLoxotPL1yqV0O4llqxd17dNeNEesWVZ2f3fJxNTgRv4GrRNjH7lsp3vl98mrYPgIC
         90FfcEPg0u4Y5Lhho36YZwXBRcdUO7Bsz5JJw0K0kMch4dYOB4Q30aC+e+IPp/M0F/gj
         U5sKEOvE1VomdoRrQucUjCLAr4Dpy8r78Uoi84X9tnr8LcIN24lvK9vTvOekkJ5+HRnP
         l2yfRMWQ87R1/8S87CQtcCTxif8RbuEVAjeRmAyT47Xgfe0QUcW0QuodcOiPL2PEYZHN
         +cf3wbyvsYKAwk4LRe7gLav2h/2Ye7vXpP3kCviDvP46k9S2BsfJ/Vmn2rUZdfna006c
         eReQ==
X-Gm-Message-State: AOAM5339FyWPwNzNPxihzR5cwJwgcaJI94zQbyLCFVCd62pQMJUigUhz
        L7d3Q/BIY4fw4JRyzdc00Cv7fktLe13KYA==
X-Google-Smtp-Source: ABdhPJx7XhHb+jqCgAzvjvQiRN6ksSZQR+wcdMrVbk0P7V6bIq52IUPvq+CrrDmPxCbYh/mrGMMRfQ==
X-Received: by 2002:a05:6102:32c3:: with SMTP id o3mr12327810vss.36.1638405421018;
        Wed, 01 Dec 2021 16:37:01 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id p130sm409297vke.56.2021.12.01.16.37.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 16:37:00 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id o1so52688978uap.4
        for <io-uring@vger.kernel.org>; Wed, 01 Dec 2021 16:37:00 -0800 (PST)
X-Received: by 2002:ab0:15a1:: with SMTP id i30mr12304408uae.122.1638405419938;
 Wed, 01 Dec 2021 16:36:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638282789.git.asml.silence@gmail.com> <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
 <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com> <d5a07e01-7fc3-2f73-a406-21246a252876@gmail.com>
In-Reply-To: <d5a07e01-7fc3-2f73-a406-21246a252876@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Dec 2021 19:36:22 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeP-W-ePV1EkWMmD4Ycsfq9viYdtyfDbUW3LXTc2q+BHQ@mail.gmail.com>
Message-ID: <CA+FuTSeP-W-ePV1EkWMmD4Ycsfq9viYdtyfDbUW3LXTc2q+BHQ@mail.gmail.com>
Subject: Re: [RFC 00/12] io_uring zerocopy send
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
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

> >>> 1) we pass a bvec, so no page table walks.
> >>> 2) zerocopy_sg_from_iter() is just slow, adding a bvec optimised version
> >>>     still doing page get/put (see 4/12) slashed 4-5%.
> >>> 3) avoiding get_page/put_page in 5/12
> >>> 4) completion events are posted into io_uring's CQ, so no
> >>>     extra recvmsg for getting events
> >>> 5) no poll(2) in the code because of io_uring
> >>> 6) lot of time is spent in sock_omalloc()/free allocating ubuf_info.
> >>>     io_uring caches the structures reducing it to nearly zero-overhead.
> >>
> >> Nice set of complementary optimizations.
> >>
> >> We have looked at adding some of those as independent additions to
> >> msg_zerocopy before, such as long-term pinned regions. One issue with
> >> that is that the pages must remain until the request completes,
> >> regardless of whether the calling process is alive. So it cannot rely
> >> on a pinned range held by a process only.
> >>
> >> If feasible, it would be preferable if the optimizations can be added
> >> to msg_zerocopy directly, rather than adding a dependency on io_uring
> >> to make use of them. But not sure how feasible that is. For some, like
> >> 4 and 5, the answer is clearly it isn't.  6, it probably is?
>
> Forgot about 6), io_uring uses the fact that submissions are
> done under an per ring mutex, and completions are under a per
> ring spinlock, so there are two lists for them and no extra
> locking. Lists are spliced in a batched manner, so it's
> 1 spinlock per N (e.g. 32) cached ubuf_info's allocations.
>
> Any similar guarantees for sockets?

For datagrams it might matter, not sure if it would show up in a
profile. The current notification mechanism is quite a bit more
heavyweight than any form of fixed ubuf pool.

For TCP this matters less, as multiple sends are not needed and
completions are coalesced, because in order.
