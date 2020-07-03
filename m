Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2342140E4
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 23:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgGCVdW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 17:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgGCVdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 17:33:22 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A3BC061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 14:33:22 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q7so25277829ljm.1
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 14:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ER2cop4HqPTXLvb8XYVkwWYzJn3C9NyH+QIkRR56/dQ=;
        b=O48YzMfXsQLuO/Yd5XWBjL8xz36wIb3wBgKOYy9AJ6m/kNwBCqmkNXnYefMkDZ+ck2
         88shc5LXMJilAUjnkGctAaqw3zy+PiqU+QVYefZfdVGnZX1Pzwj0Xi3VKMDKXx+9QbLg
         mXUWMx6PxOPzRPJ/8jcX67vHbPLfI1QxR2vXq/f88+nXpx5GHh0M6QfCs6FrONGQ0+Lc
         RR6TwmpkZ64wATBkrUFEh8hoOCYzbk3xzbkTolHDycuNJK1ebfk5W9PNi9O9cnIEWb4D
         IFnSJPGLmgQGDP4tNffh0oV3uBrFlTcvn5NFuwOVAlxrsQ7haE7eDBAJt9Jnv1ztkzu1
         c0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ER2cop4HqPTXLvb8XYVkwWYzJn3C9NyH+QIkRR56/dQ=;
        b=FOm4a7zfoIOcB2RS5qxvn/BP9zpCVf5bXFn676oBhLJRPxqdZopScRrWvfuqC0+sPJ
         bg806svCGe5ZGUFkoRXJxuuEG+OwlRv+kNVmbze6vIQvblBoAVHPEaVJkhP1oO3IPqIe
         GE53QDTXr1MlrFFqoz28VSsADfTmH58H8+dBvd5KH7VKAN6XL9HDi2h1mVNILXRNKUeV
         ID5tiNnZxrQcosao3JE8zTFtEkniVeDDXnyKYlFfFcB5lORg4ZspIEpPjm6NWV6oMRlS
         acY1n4rJ7kJKq823GKldBuhxr6iRshdvy2FybWsnPTcPBE3y7k4fNf5NFr95O2bk0Cwq
         9h2g==
X-Gm-Message-State: AOAM533laCBj+GuJc4b5z9hQTzA0KrdPJcQdCsi5vAEzYq9phTtTLxGv
        XrNv5gpNAYJvINvwyDNfcPyOb9f7EsnMUj8XhZtbxg==
X-Google-Smtp-Source: ABdhPJyO2g2lc50NlzoTtn+hnnbru9HxxIw51X1BnV6UltshvSv3v2JCPDNAAinPkh3pQ87X8GBY4ArkIP5omyFOjoY=
X-Received: by 2002:a2e:7f02:: with SMTP id a2mr19500979ljd.138.1593812000245;
 Fri, 03 Jul 2020 14:33:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593424923.git.asml.silence@gmail.com> <1221be71ac8977607748d381f90439af4781c1e5.1593424923.git.asml.silence@gmail.com>
 <CAG48ez2yJdH3W_PHzvEuwpORB6MoTf9M5nOm1JL3H-wAnkJBBA@mail.gmail.com> <f7f4724d-a869-c867-ad8e-b2a59e89c727@gmail.com>
In-Reply-To: <f7f4724d-a869-c867-ad8e-b2a59e89c727@gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 3 Jul 2020 23:32:53 +0200
Message-ID: <CAG48ez3fR1QyVXapvwbYzbtv4AEb0BY2ebKsV7vNFLE-6NaUQA@mail.gmail.com>
Subject: Re: [PATCH 5/5] io_uring: fix use after free
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 3, 2020 at 9:50 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> On 03/07/2020 05:39, Jann Horn wrote:
> > On Mon, Jun 29, 2020 at 10:44 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >> After __io_free_req() put a ctx ref, it should assumed that the ctx may
> >> already be gone. However, it can be accessed to put back fallback req.
> >> Free req first and then put a req.
> >
> > Please stick "Fixes" tags on bug fixes to make it easy to see when the
> > fixed bug was introduced (especially for ones that fix severe issues
> > like UAFs). From a cursory glance, it kinda seems like this one
> > _might_ have been introduced in 2b85edfc0c90ef, which would mean that
> > it landed in 5.6? But I can't really tell for sure without investing
> > more time; you probably know that better.
>
> It was there from the beginning,
> 0ddf92e848ab7 ("io_uring: provide fallback request for OOM situations")
>
> >
> > And if this actually does affect existing releases, please also stick
> > a "Cc: stable@vger.kernel.org" tag on it so that the fix can be
> > shipped to users of those releases.
>
> As mentioned in the cover letter, it's pretty unlikely to ever happen.
> No one seems to have seen it since its introduction in November 2019.
> And as the patch can't be backported automatically, not sure it's worth
> the effort. Am I misjudging here?

Use-after-free bugs are often security bugs; in particular when, as in
this case, data is written through the freed pointer. That means that
even if this is extremely unlikely to occur in practice under normal
circumstances, you should assume that someone may invest a significant
amount of time into engineering some way to make this bug happen. If
you can show that the bug is _impossible_ to hit, that's fine, I
guess. But if it's merely "it's a really tight race and unlikely to
happen", I think we should be fixing it on the stable branches.
For example, on kernels with PREEMPT=y (typically you get that config
either with "lowlatency" kernels or on Android, I think), attackers
can play games like giving their own tasks "idle" scheduling priority
and intentionally preempting them right in the middle of a race
window, which makes it possible to delay execution for intervals on
the order of seconds if the attacker can manage to make the scheduler
IPI hit in the right place.

I guess one way to hit this bug on mainline would be to go through the
io_async_task_func() canceled==true case, right? That will drop
references on a request at the very end, without holding any locks or
so that might keep the context alive.
