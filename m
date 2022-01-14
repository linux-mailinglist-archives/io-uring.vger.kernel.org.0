Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4F248E74D
	for <lists+io-uring@lfdr.de>; Fri, 14 Jan 2022 10:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiANJTx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jan 2022 04:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiANJTw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jan 2022 04:19:52 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D63C061574
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 01:19:51 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id u25so32759423edf.1
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 01:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NzE71MhjCUShzxvm2h8DsVIT1hIwhp1LevHcd53e3TE=;
        b=qZiFcExji+zJrPK/Kvz+8mzO/w4yBfDz+B7KpJILr+jIRUgT2bRm97CsSx3liquYqC
         YaNIR+TIcXlpFyVSfnsuF2q66nfw+uFNTkwDLrDwt6p0Jr9q9nfNWNgMSbMfoAnG9rA8
         NJslz4Q7XnRt9iYEL7oz0kF1sZxE42Y0xomWPnJn+bSDlcLULhQdANUW5dR9yu7zTt/X
         E8jPG3gK6JblOJtn5sp/gWYMXl0UIHz6B4FYxaHYvLEAAwY1UWBELaMMsGv7Dfy5y1Mi
         WrRrGGzDqxEhBNmguDFOPGpXbUTny+0DlQlj2cqiCjNjA8KonDkB7gS04xN3Q2HwP+tP
         LcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NzE71MhjCUShzxvm2h8DsVIT1hIwhp1LevHcd53e3TE=;
        b=4DbG7aMvaxAh7pWmMTQnJNc/uZjXoHdmUdgDWH/nG1nZEEOpqBf0kW8OkejOg6k0WK
         1Rn0pEKEWQmuLVg2UHKcm+R9NjeJiOS9eun0MEIsPLikOX2rbDVqaOTSQyMi75Rqnl+6
         Kh3oJSWy0xFLeiF5t3Km183xoeaLwyYCNd9xI9zcSxYlCKI8BanbVS9i+HeKgfQJvu0K
         QQS64FgnKzgqvSDyvM+J5hP4EvRO7Lq6D/vGedujUsoF09qtc2VEUHdJ9JHRTnSJURUD
         rqJLglEzVba5zzrZvl5Uy6GiTi9Cb31YcUIF4Am048AgHaI3ZJ7ryKDVV85ALobEhKrK
         PJ4Q==
X-Gm-Message-State: AOAM530ho3PJeH54xTPCNSBdc1osiBkc8EDCFhS2+Jd7OXEnI+Ejfrpe
        V8JMALZbTbJZcYLXZqmoXxzPbm3HZLGosXELvbEmVjWAyrk=
X-Google-Smtp-Source: ABdhPJzkfhgvLdY4FhY/XAxMhaEYfXnkEYPfEdrdcfWQQve270z7UIpwQFyGfLOaqBt5DlPBSZ5Y/9oInOsu6MT7wNs=
X-Received: by 2002:a17:907:728e:: with SMTP id dt14mr813998ejc.723.1642151990125;
 Fri, 14 Jan 2022 01:19:50 -0800 (PST)
MIME-Version: 1.0
References: <e354897-adca-114-3830-4cc243f99fc1@rydia.net> <CAAss7+q_qjYBbiN+RaGrd3ngOPPGRwJiQU+Gkq1YPzfy7X8wqg@mail.gmail.com>
In-Reply-To: <CAAss7+q_qjYBbiN+RaGrd3ngOPPGRwJiQU+Gkq1YPzfy7X8wqg@mail.gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Fri, 14 Jan 2022 10:19:38 +0100
Message-ID: <CAAss7+qkBUzADaG+B6WTHz5hdZbbGvLFkD56sRhUzni7Js7amA@mail.gmail.com>
Subject: Re: User questions: client code and SQE/CQE starvation
To:     dormando <dormando@rydia.net>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sorry i accidentally pressed send message...

run out of SQE should not be problem, when
io_uring_get_sqe(https://github.com/axboe/liburing/blob/master/src/queue.c#L409)
returns a null, you can run io_uring_submit
in netty we do that automatically when its full
https://github.com/netty/netty-incubator-transport-io_uring/blob/main/transport-classes-io_uring/src/main/java/io/netty/incubator/channel/uring/IOUringSubmissionQueue.java#L117

In theory you could run out of CQE, netty io_uring approach is a
little bit different.
https://github.com/netty/netty-incubator-transport-io_uring/blob/main/transport-classes-io_uring/src/main/java/io/netty/incubator/channel/uring/IOUringCompletionQueue.java#L86
(similar to io_uring_for_each_cqe) to make sure the kernel sees that
and the process function is called here
https://github.com/netty/netty-incubator-transport-io_uring/blob/main/transport-classes-io_uring/src/main/java/io/netty/incubator/channel/uring/IOUringEventLoop.java#L203



> On Wed, 12 Jan 2022 at 22:17, dormando <dormando@rydia.net> wrote:
> >
> > Hey,
> >
> > Been integrating io_uring in my stack which has been going well-ish.
> > Wondering if you folks have seen implementations of client libraries that
> > feel clean and user friendly?
> >
> > IE: with poll/select/epoll/kqueue most client libraries (like libcurl)
> > implement functions like "client_send_data(ctx, etc)", which returns
> > -WANT_READ/-WANT_WRITE/etc and an fd if it needs more data to move
> > forward. With the syscalls themselves externalized in io_uring I'm
> > struggling to come up with abstractions I like and haven't found much
> > public on a googlin'. Do any public ones exist yet?
> >
> > On implementing networked servers, it feels natural to do a core loop
> > like:
> >
> >       while (1) {
> >           io_uring_submit_and_wait(&t->ring, 1);
> >
> >           uint32_t head = 0;
> >           uint32_t count = 0;
> >
> >           io_uring_for_each_cqe(&t->ring, head, cqe) {
> >
> >               event *pe = io_uring_cqe_get_data(cqe);
> >               pe->callback(pe->udata, cqe);
> >
> >               count++;
> >           }
> >           io_uring_cq_advance(&t->ring, count);
> >       }
> >
> > ... but A) you can run out of SQE's if they're generated from within
> > callbacks()'s (retries, get further data, writes after reads, etc).
> > B) Run out of CQE's with IORING_FEAT_NODROP and can no longer free up
> > SQE's
> >
> > So this loop doesn't work under pressure :)
> >
> > I see that qemu's implementation walks an object queue, which calls
> > io_uring_submit() if SQE's are exhausted. I don't recall it trying to do
> > anything if submit returns EBUSY because of CQE exhaustion? I've not found
> > other merged code implementing non-toy network servers and most examples
> > are rewrites of CLI tooling which are much more constrained problems. Have
> > I missed anything?
> >
> > I can make this work but a lot of solutions are double walking lists
> > (fetch all CQE's into an array, advance them, then process), or not being
> > able to take advantage of any of the batching API's. Hoping the
> > community's got some better examples to untwist my brain a bit :)
> >
> > For now I have things working but want to do a cleanup pass before making
> > my clients/server bits public facing.
> >
> > Thanks!
> > -Dormando
>
>
>
> --
> Josef Grieb

--
Josef Grieb
