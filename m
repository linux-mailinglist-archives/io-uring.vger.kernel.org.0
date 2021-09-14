Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276E940B838
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 21:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhINTir (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 15:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbhINTir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 15:38:47 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893F2C061762
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 12:37:29 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b6so353803ilv.0
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 12:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AHaD45tpXhY3cAJWkx8UAo5BfY2ep0mljpAehjK+qGI=;
        b=SJnU0hXQxSIp4tRyqhlrSD+Vd4qc4sfB/TtW619ax2br6XynKuLnLR7VFMNr2JaOIQ
         gR/JFVHg+G/qOrKrZ7BQldMhCs7L/zD4YkhTdkJgRmXBuxG4QN8RRqxK8zNXp7Pcrtky
         uybtK4AwABvC991fm0S9rdEbzNIn1ed/GeyefIu/Cuhe2sy6N2ssUU6GhvSXmy24ry6r
         jpnDOkUJ3mw5zucwcXfhRmQFzDKpU5g1F3CBGz8dtEpt3eb0462qcMkmiuRyNh+Ag5QD
         Z5MKJ5VJZh8A1FVTdQmd8YXmWIRfxp0gDl6+6Hy5XqXlm+Ir2NBDLSP749iWMVKlvLOE
         oFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AHaD45tpXhY3cAJWkx8UAo5BfY2ep0mljpAehjK+qGI=;
        b=UnPjupxhfCSaN8D82O5I+3iCB5YAJHvSfJmiDzciurboHrGt0neGSq2jhk4BqlcS4O
         t9sxqrIyoLAYf+j5l4/2Y9JBtn7YUJccagDbF1Wn6mbPMF2w2dX6+VGJbKMKTu7NP4yy
         sD97VJUR8vAQJmGREUP71qCL2s4NCcguUSileSgd2/N4lamzoETg8/TG08bAg95JhWFx
         7CrHNrN7GnkW9tXqHLPQTm5Ld42d/emCwVoF1aQu61WFF6JQJu7iwp3ksx/SJoKLasF7
         xWqnnxp/ll9s1HlgGjOU1TjJODX5ZmGt9D15hextLExt7kUo3bFHE4U2bw78ZaXt49Yt
         6A6w==
X-Gm-Message-State: AOAM532KxAMMzSxh3K9FuVrIp6WyA40D7pRPDSDgSe7Z+Ciklqqcr2Sw
        K8No9QOb7E7fFEsAATA32ITM4Q==
X-Google-Smtp-Source: ABdhPJz1wdVfCbLt9JCsYqzWuwQYqKBa1mHikabT2SNfvPmOl3utJtSPCxizok4BnuWPeKtUihgyjg==
X-Received: by 2002:a92:ce48:: with SMTP id a8mr7372875ilr.115.1631648248879;
        Tue, 14 Sep 2021 12:37:28 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c1sm6417140iot.44.2021.09.14.12.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 12:37:28 -0700 (PDT)
Subject: Re: [PATCH 2/3] io_uring: use iov_iter state save/restore helpers
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210914141750.261568-1-axboe@kernel.dk>
 <20210914141750.261568-3-axboe@kernel.dk>
 <CAHk-=wh6mGm0b7AnKNRzDO07nrdpCrvHtUQ=afTH6pZ2JiBpeQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5659d7ba-e198-9df0-c6f8-bd6511bf44a0@kernel.dk>
Date:   Tue, 14 Sep 2021 13:37:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wh6mGm0b7AnKNRzDO07nrdpCrvHtUQ=afTH6pZ2JiBpeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 12:45 PM, Linus Torvalds wrote:
> On Tue, Sep 14, 2021 at 7:18 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>
>> +       iov_iter_restore(iter, state);
>> +
> ...
>>                 rw->bytes_done += ret;
>> +               iov_iter_advance(iter, ret);
>> +               if (!iov_iter_count(iter))
>> +                       break;
>> +               iov_iter_save_state(iter, state);
> 
> Ok, so now you keep iovb_iter and the state always in sync by just
> always resetting the iter back and then walking it forward explicitly
> - and re-saving the state.
> 
> That seems safe, if potentially unnecessarily expensive.

Right, it's not ideal if it's a big range of IO, then it'll definitely
be noticeable. But not too worried about it, at least not for now...

> I guess re-walking lots of iovec entries is actually very unlikely in
> practice, so maybe this "stupid brute-force" model is the right one.

Not sure what the alternative is here. We could do something similar to
__io_import_fixed() as we're only dealing with iter types where we can
do that, but probably best left as a later optimization if it's deemed
necessary.

> I do find the odd "use __state vs rw->state" to be very confusing,
> though. Particularly in io_read(), where you do this:
> 
> +       iov_iter_restore(iter, state);
> +
>         ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
>         if (ret2)
>                 return ret2;
> 
>         iovec = NULL;
>         rw = req->async_data;
> -       /* now use our persistent iterator, if we aren't already */
> -       iter = &rw->iter;
> +       /* now use our persistent iterator and state, if we aren't already */
> +       if (iter != &rw->iter) {
> +               iter = &rw->iter;
> +               state = &rw->iter_state;
> +       }
> 
>         do {
> -               io_size -= ret;
>                 rw->bytes_done += ret;
> +               iov_iter_advance(iter, ret);
> +               if (!iov_iter_count(iter))
> +                       break;
> +               iov_iter_save_state(iter, state);
> 
> 
> Note how it first does that iov_iter_restore() on iter/state, buit
> then it *replaces&* the iter/state pointers, and then it does
> iov_iter_advance() on the replacement ones.

We restore the iter so it's the same as before we did the read_iter
call, and then setup a consistent copy of the iov/iter in case we need
to punt this request for retry. rw->iter should have the same state as
iter at this point, and since rw->iter is the copy we'll use going
forward, we're advancing that one in case ret > 0.

The other case is that no persistent state is needed, and then iter
remains the same.

I'll take a second look at this part and see if I can make it a bit more
straight forward, or at least comment it properly.

-- 
Jens Axboe

