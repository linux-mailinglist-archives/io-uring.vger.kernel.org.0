Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2982B287C3E
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 21:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgJHTPP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 15:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729699AbgJHTPK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 15:15:10 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA167C0613D2
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 12:15:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id dg9so4607275edb.12
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 12:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YfZfZnaERkqPGB2gGvHnDF9tWhylzGCwvN0kr160d3o=;
        b=EU3IvPZT1qrarikUHrvLKAxBGi3bVKJs0zCSZlivvI6umTuzeH4Wvdmad20HGIqsjp
         gzhFpLD9thpIBdRIhY+D4YGrpLSSySZkS2KDuuvmpT0YaFHE259gf8BLBo3oTIiY2Yv/
         ye/GJnVVhgy5RozPa4nO0EA/PpFrkyapQ8wFgmT8Ggh0g9z8/uX98SnXSPZRL7Gw/7II
         Fb+sekakOy/Bd5nkEluPT0I2WBptg8Cqzq+3vRMOHKcMI04zj/J5aKTaOiyTTFhFu5Bg
         KnrklRQL9VteQbPeTa35T7QEYo30iWp53uP8Z3oVLd/RHZJ49N5CaKz5tyEsqHHzJD5g
         VOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YfZfZnaERkqPGB2gGvHnDF9tWhylzGCwvN0kr160d3o=;
        b=R/O5sGRghRWk7yFD6z5MyeDuPtp3row4r+e8uj3UyafFPf9FYZG9gloqZDWhiZ7VH4
         c9jwtsmGbNpNj8luEFU9coskqQzGppjPp9hy8NWABBRqib2SYB+jqdjCTjSXiWBnRyfz
         vYIOWcTrZC8Sf6q7BG2rxrURM9sTPZs0hH+9+FQCSe2mQUciDswGAqq/4Zxc0CNVAytm
         e598zhuVZ4fsTYZw8Ur7QyN/gbhrr2AeAesAbZ5KvR0FjAh2kq8qUFMusQ7GsvcbNsdb
         SNWkiUgmW7FNU380gpoVjwMHcgwwX5mPwz565DwaQMB+i9c5XVrbB97d7CQvNflr0GhC
         VADQ==
X-Gm-Message-State: AOAM531Y9Hb82vqxwy7cxUgABkz5DZcchtfpqO3w3mOHgIDFgxjks9gU
        XtiqS6vh/BTEXwdYOjum86aFQI2SAz8MyqSCrF8GUA==
X-Google-Smtp-Source: ABdhPJyFBlN7boUQCesb35wLUZR3ZBS6yJ+NQq18F8P2ms8O/FcyKZgkHVXpn/LRi65HGJKo/6aCP+dzJHDcLp6c2D0=
X-Received: by 2002:aa7:dd01:: with SMTP id i1mr10907549edv.84.1602184508070;
 Thu, 08 Oct 2020 12:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <f7ac4874-9c6c-4f41-653b-b5a664bfc843@canonical.com> <CAG48ez1i9pTYihJAd8sXC5BdP+5fLO-mcqDU1TdA2C3bKTXYCw@mail.gmail.com>
In-Reply-To: <CAG48ez1i9pTYihJAd8sXC5BdP+5fLO-mcqDU1TdA2C3bKTXYCw@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 8 Oct 2020 21:14:42 +0200
Message-ID: <CAG48ez0pLGtc6_NPcYa0nVPexrSOJvfKgArgY6OT4AXS5tOF4A@mail.gmail.com>
Subject: Re: io_uring: process task work in io_uring_register()
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 8, 2020 at 9:13 PM Jann Horn <jannh@google.com> wrote:
>
> On Thu, Oct 8, 2020 at 8:24 PM Colin Ian King <colin.king@canonical.com> wrote:
> > Static analysis with Coverity has detected a "dead-code" issue with the
> > following commit:
> >
> > commit af9c1a44f8dee7a958e07977f24ba40e3c770987
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   Thu Sep 24 13:32:18 2020 -0600
> >
> >     io_uring: process task work in io_uring_register()
> >
> > The analysis is as follows:
> >
> > 9513                do {
> > 9514                        ret =
> > wait_for_completion_interruptible(&ctx->ref_comp);
> >
> > cond_const: Condition ret, taking false branch. Now the value of ret is
> > equal to 0.
>
> Does this mean Coverity is claiming that
> wait_for_completion_interruptible() can't return non-zero values? If
> so, can you figure out why Coverity thinks that? If that was true,
> it'd sound like a core kernel bug, rather than a uring issue...

Ah, nevermind, I missed the part where we only break out of the loop
if ret==0... sorry for the noise, ignore me.
