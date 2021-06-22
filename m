Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7E93AFF59
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 10:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFVIhF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 04:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhFVIhF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 04:37:05 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCADC061574;
        Tue, 22 Jun 2021 01:34:49 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id d196so37390715qkg.12;
        Tue, 22 Jun 2021 01:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gL3H7bDENRo2j2X/f748deAvZNms0Hat6RO/9z/xyro=;
        b=dxhLFr8Isf4w5x5gOgXnn7+Et9cF28/4YT/bRbS89GIL2/fIjDd8J2R830cgrM7zJ9
         By9jNyY4bYeQp8gEmUtUbzT4xHjqnBY1BOsjcW5FOsO9Xy1Vp4pjGixOk4lSTEOo7DOW
         09C1FUsDohvb4wb7Cl0h8OXkqKdglQ+r26QHL2BEJHWtXjf7XylA+DmslojdKB68Ywbj
         IniltvRhkTyzSk+thOxZnBu4IzHv4RPpTtl1Bry4PuEZkAOb49zC5LmE0RdNjKvBaJvx
         rR0GmT+eH1FMXUl4aDmx7/K0nTpAXRvplYcPlljaFIUdNlAe7PHDxzNkzpMAjtEm6qvp
         hgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gL3H7bDENRo2j2X/f748deAvZNms0Hat6RO/9z/xyro=;
        b=SB017wUrsCmNDgMXBxHghmEEEVlK7bWVaparK7x6RYlwsfb6+z3xbjsOeC9sAnG0FA
         lGboUKIFmaTcLB3N5IjxOtlsi9DcrhPlc6RvXh5lgx2fGYFbDW4V20jcdAqA8qts+eqC
         eCz32+lrXZxzs5oTbwpolUJiKtnIqehLcZACAZu3Oc/tNtkmOgrAjTbDiruanIt6D7VP
         qydr9AxCtW6hZMi2bAxLJCg2Ea+eCTNEZL2PLJjr1526AnTLjJi6SSGDzCf2jAzyJ2cB
         zfUhduBrcp+bWTUwrDZ7ixy1XL8n6GeQvMzqKjy9kG6vjNOZddMFyMr1ZzCbyI26QCvN
         rdeQ==
X-Gm-Message-State: AOAM533AKmGshYsVK2xxxI1ssim4Tv+VhLzAcjpqkSS1zyCqN1OhM8m8
        aUCeBtUh7NNsim6V3Wb9RU/PIoUXbNP1GsW5X8c=
X-Google-Smtp-Source: ABdhPJzwPTP8zV52/BdFa+lENb6ob1/omQ26G88zh6dbaZTk84Kc5dLwsKQqTSXIuJYYrQwo72CT2i12BsGgAcNMXgY=
X-Received: by 2002:a25:8088:: with SMTP id n8mr3146217ybk.375.1624350888265;
 Tue, 22 Jun 2021 01:34:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <CAOKbgA69B=nnNOaHH239vegj5_dRd=9Y-AcQBCD3viLxcH=LiQ@mail.gmail.com>
 <2c4d5933-965e-29b5-0c76-3f2e5f518fe8@kernel.dk> <a459abe3-b051-ea60-d8d9-412562a255d5@kernel.dk>
 <20210622081240.c7tzq7e7gt3y3u7j@wittgenstein>
In-Reply-To: <20210622081240.c7tzq7e7gt3y3u7j@wittgenstein>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 22 Jun 2021 15:34:37 +0700
Message-ID: <CAOKbgA5ak=yVo1Pw+8xzSH4vWVJSPG_rmwRCCOiUUGPp2tq+vQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat support
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 22, 2021 at 3:12 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Mon, Jun 21, 2021 at 09:21:23AM -0600, Jens Axboe wrote:
> > On 6/18/21 10:10 AM, Jens Axboe wrote:
> > > On 6/18/21 12:24 AM, Dmitry Kadashev wrote:
> > >> On Thu, Jun 3, 2021 at 12:18 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> > >>>
> > >>> This started out as an attempt to add mkdirat support to io_uring which
> > >>> is heavily based on renameat() / unlinkat() support.
> > >>>
> > >>> During the review process more operations were added (linkat, symlinkat,
> > >>> mknodat) mainly to keep things uniform internally (in namei.c), and
> > >>> with things changed in namei.c adding support for these operations to
> > >>> io_uring is trivial, so that was done too. See
> > >>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> > >>
> > >> Ping. Jens, are we waiting for the audit change to be merged before this
> > >> can go in?
> > >
> > > Not necessarily, as that should go in for 5.14 anyway.
> > >
> > > Al, are you OK with the generic changes?
> >
> > I have tentatively queued this up.
>
> Hey Dmitry,
> hey Jens,
>
> The additional op codes and suggested rework is partially on me. So I
> should share the blame in case this gets a NAK:
>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Hi Christian,

Thank you very much for your help with this! Just wanted to say that you
were quite supportive and really helped me a lot.

-- 
Dmitry
