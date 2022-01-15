Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9412848F9CE
	for <lists+io-uring@lfdr.de>; Sun, 16 Jan 2022 00:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiAOXcc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Jan 2022 18:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiAOXcc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Jan 2022 18:32:32 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461D0C061574
        for <io-uring@vger.kernel.org>; Sat, 15 Jan 2022 15:32:32 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id a5so6226982pfo.5
        for <io-uring@vger.kernel.org>; Sat, 15 Jan 2022 15:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lVyxhCI3iLqfjpAEROZNvvsw5mjAaY6idxkjkt9xJ5s=;
        b=ilr7C1lqwsZJrlf6XwaAvIuax+PuTu9PFgnleBvFcw0uGG5CfV3asbtnQ7HERhIDW1
         HoMzJgJcB91+iWGiyMYv1nigQOuMnLPgJluoycsOL7o+lb4IvsbQlQSnl41gsc94RQnX
         tDVGHTV3Zd9pIux0CZrI106tBW7HJ///yK690fY5kgzVolSUHdxlqYSelB2D8Y6pFoP1
         RV6u+N/lB4rqhl1mIdZvswYRZHZgoQEapvYJfzXp4qUApd9lnox2bydLiBDx+A4ifdhz
         otg2yck8Y41f+1a+iJGy8v3YlWRIow7iSqoXjVM2Ve6jXtChO8Xx25qE8hNhlgz8tUAF
         h8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lVyxhCI3iLqfjpAEROZNvvsw5mjAaY6idxkjkt9xJ5s=;
        b=lbK8CH4dSPMmgCfSW6DFx+yw2iWJSuMhZT01P7AdPYnGARC6YjA2BUgbdlYLuMTKz5
         Rb9twpxasDxP56mHI/epb50aJuWzT4zBl0SL6eAT0aJcH8Axy0CeN25z0sW6YH2FSXQj
         OWPiPTP3X2/8lT3OV5TQh+X212mSvxeJ5N4x58nqG4EkmkbCbNyYTQpKyzGKMOkZeOUu
         ASpfyVuoIzfedalLcGQsEwOwuiNhvt3tZ5Ta0aoBhN7Zu9Wu85h9w/41aZIv4ugPLqo9
         dV3pqoDG8a9hwAGSG88NBx20uOvpdZvA4E/v5KhK3WNhVNyhoTzPqzB5lj/4ikwMxAtY
         Ppcg==
X-Gm-Message-State: AOAM531cJBb/5/iH4XysmZ+IA+eNXk6/BqOqHrpr/r03QFV98dbpc+5R
        UfPAIPkSPW1st7+YTvmiLCln/wa/V28zakduo1UJ91YLJuo=
X-Google-Smtp-Source: ABdhPJwOEHmP2lLRMygeRwVHHTJ1NPGTq/Xgq8F7b94PyUNJIqnwfGi1d/47WMlD0fQ15SlHvs7MU2u1VepwS7mCAqE=
X-Received: by 2002:a63:7407:: with SMTP id p7mr13435802pgc.14.1642289551389;
 Sat, 15 Jan 2022 15:32:31 -0800 (PST)
MIME-Version: 1.0
References: <e354897-adca-114-3830-4cc243f99fc1@rydia.net>
In-Reply-To: <e354897-adca-114-3830-4cc243f99fc1@rydia.net>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Sat, 15 Jan 2022 17:32:20 -0600
Message-ID: <CAFUsyfJ1FqLHHRy7dQ7T20nPxs1MEbfd1DyfvmQLw=G2rFUhMw@mail.gmail.com>
Subject: Re: User questions: client code and SQE/CQE starvation
To:     dormando <dormando@rydia.net>
Cc:     "open list:IO_URING" <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 12, 2022 at 3:17 PM dormando <dormando@rydia.net> wrote:
>
> Hey,
>
> Been integrating io_uring in my stack which has been going well-ish.
> Wondering if you folks have seen implementations of client libraries that
> feel clean and user friendly?

libev: http://cvs.schmorp.de/libev/
has an io_uring backend: http://cvs.schmorp.de/libev/ev_iouring.c?view=markup

>
> IE: with poll/select/epoll/kqueue most client libraries (like libcurl)
> implement functions like "client_send_data(ctx, etc)", which returns
> -WANT_READ/-WANT_WRITE/etc and an fd if it needs more data to move
> forward. With the syscalls themselves externalized in io_uring I'm
> struggling to come up with abstractions I like and haven't found much
> public on a googlin'. Do any public ones exist yet?
>
> On implementing networked servers, it feels natural to do a core loop
> like:
>
>       while (1) {
>           io_uring_submit_and_wait(&t->ring, 1);
>
>           uint32_t head = 0;
>           uint32_t count = 0;
>
>           io_uring_for_each_cqe(&t->ring, head, cqe) {
>
>               event *pe = io_uring_cqe_get_data(cqe);
>               pe->callback(pe->udata, cqe);
>
>               count++;
>           }
>           io_uring_cq_advance(&t->ring, count);
>       }
>
> ... but A) you can run out of SQE's if they're generated from within
> callbacks()'s (retries, get further data, writes after reads, etc).
> B) Run out of CQE's with IORING_FEAT_NODROP and can no longer free up
> SQE's
>
> So this loop doesn't work under pressure :)
>
> I see that qemu's implementation walks an object queue, which calls
> io_uring_submit() if SQE's are exhausted. I don't recall it trying to do
> anything if submit returns EBUSY because of CQE exhaustion? I've not found
> other merged code implementing non-toy network servers and most examples
> are rewrites of CLI tooling which are much more constrained problems. Have
> I missed anything?
>
> I can make this work but a lot of solutions are double walking lists
> (fetch all CQE's into an array, advance them, then process), or not being
> able to take advantage of any of the batching API's. Hoping the
> community's got some better examples to untwist my brain a bit :)
>
> For now I have things working but want to do a cleanup pass before making
> my clients/server bits public facing.
>
> Thanks!
> -Dormando
