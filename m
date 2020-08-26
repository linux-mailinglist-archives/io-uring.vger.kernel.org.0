Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7DF2525AE
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 05:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHZDBP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 23:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgHZDBO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 23:01:14 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679FAC061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 20:01:14 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id b2so139183qvp.9
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 20:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U96iW8XhlWO/ZKKc3NPCz1Gocg3Huq1H4mawqbD/dEM=;
        b=adA1WrSfR0YiWFxJGQXZmBNB5l5Uznjh9UfL+nkr9JTiB0llJKfqLYDOM5WVT7PaTh
         mhjVq4ynVEh5pEFt3MTxcefnouKFgoDWsqRrDJ4/Lyy4h1Vjut0dXoTb3bTQD0pzUKSY
         q4XAsUhpBH2/1RHRwJXbnNtGc4Ucl8GWediOk4ImH4egngA80X/dCQRR6nJPfjWKAWkN
         cUsekaiE17X0hBLpwSLu0T9m/25SkrI4WuebOvDtgpVVifSYlKmhSy+9427ojBBGJOw8
         n81m8qPTEEnAJz7vNFM7ksyOOyaun7Q1iQPfKfTlgPX+UdoW1K44wmQGXWVnjH+gMS09
         euRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U96iW8XhlWO/ZKKc3NPCz1Gocg3Huq1H4mawqbD/dEM=;
        b=jWcT3Tg4HYR4SfoTZdZ5uzhOUiOooXa3JLOINYeA4LSt36AwpbW7Wih3AyrNGcGf1s
         hQpioxFwUw1+IImkCbKGAw5xqzb9WV7Ds9MDuaNwKfdvOdQdvI1qe6K0DVb/qP3VHlNF
         RTR4PJmXBhH4TvybDWFQwOk7Ik4t21xYwbc8FdNpCLCbOPp+zrTkI77VWbxZ24Y+9dR1
         8ijOVVWjMyg+LqNPnOrhGkRURfrB/sPTAlNy5oPQqpBfhFTn+3SUNXeQf+F6ggN4GdwL
         PMaAhkvKHnxOOL4tEaHD/ymyrKkmrk5/7FyxuVtFqjfCSpvHAZqY0n81uibQsML+4+RQ
         pXWQ==
X-Gm-Message-State: AOAM531mWpRHXpolRTuE/INpx3mtk6mlTTgb+kmHOpcwzNenfxI0CtDO
        /MAFMzSuAsiNsrHEygpEVP8EnnzekndBXnApn67g1kisVpHB9ey3
X-Google-Smtp-Source: ABdhPJy6+p8ujktrrJhpAbLnqyTJ1jtc+xZ4kXzkVzjA5+502wL15I46jSfi7qUEUN9yfoPEZe4HeGrRlQRN60LlnSw=
X-Received: by 2002:a0c:fb11:: with SMTP id c17mr12002479qvp.113.1598410872669;
 Tue, 25 Aug 2020 20:01:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
 <639db33b-08f2-4e10-8f06-b6d345677df8@kernel.dk> <308222a7-8bd2-44a6-c46c-43adf5469fa3@kernel.dk>
 <c07b29d1-fff4-3019-4cba-0566c8a75fd0@kernel.dk> <CAAss7+rKt6Eh7ozCz5syJSOjVVaZnrVSXi8zS8MxuPJ=kcUwCQ@mail.gmail.com>
 <ab3ddb12-c3ca-5ebb-32ff-d041f8eb20d1@kernel.dk>
In-Reply-To: <ab3ddb12-c3ca-5ebb-32ff-d041f8eb20d1@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Wed, 26 Aug 2020 05:01:01 +0200
Message-ID: <CAAss7+o5_74C3tG09Yw2KaL4B7vVg68aNf=UF-YmTaNGokSOfQ@mail.gmail.com>
Subject: Re: io_uring file descriptor address already in use error
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> In order for the patch to be able to move ahead, we'd need to be able
> to control this behavior. Right now we rely on the file being there if
> we need to repoll, see:
>
> commit a6ba632d2c249a4390289727c07b8b55eb02a41d
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Fri Apr 3 11:10:14 2020 -0600
>
>     io_uring: retry poll if we got woken with non-matching mask
>
> If this never happened, we would not need the file at all and we could
> make it the default behavior. But don't think that's solvable.
>
> > is there no other way around to close the file descriptor? Even if I
> > remove the poll, it doesn't work
>
> If you remove the poll it should definitely work, as nobody is holding a
> reference to it as you have nothing else in flight. Can you clarify what
> you mean here?
>
> I don't think there's another way, outside of having a poll (io_uring
> or poll(2), doesn't matter, the behavior is the same) being triggered in
> error. That doesn't happen, as mentioned if you do epoll/poll on a file
> and you close it, it won't trigger an event.
>
> > btw if understood correctly poll remove operation refers to all file
> > descriptors which arming a poll in the ring buffer right?
> > Is there a way to cancel a specific file descriptor poll?
>
> You can cancel specific requests by identifying them with their
> ->user_data. You can cancel a poll either with POLL_REMOVE or
> ASYNC_CANCEL, either one will find it. So as long as you have that, and
> it's unique, it'll only cancel that one specific request.

thanks it works, my bad, I was not aware that user_data is associated
with the poll request user_data...just need to remove my server socket
poll which binds to an address so I think this patch is not really
necessary

btw IORING_FEAT_FAST_POLL feature which arming poll for read events,
how does it work when the file descriptor(not readable yet) wants to
read(non blocking) something and I close(2) the file descriptor? I'm
guessing io_uring doesn't hold any reference to it anymore right?


---
Josef Grieb
