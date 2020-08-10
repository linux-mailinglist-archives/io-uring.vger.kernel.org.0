Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2ED241248
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 23:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgHJV1Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 17:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgHJV1Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 17:27:24 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E0BC061756
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 14:27:23 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id i10so11239259ljn.2
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 14:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/WDS43rlS3733ZJcRlieCTJ4y/G+sqa5pD9t19aFErg=;
        b=XKpQj2TmMGlnJe5J+3klZSKWK18EJmh2RGy2FtJGTkQjOPYwfa4dsIXRD2BxDFL9TN
         cUYRWm1FwuDhPyrNPcaEM0A0+/FumReOuZi1MGFEwMCdCgoLnwRGoRtSt95WQiOh3App
         FB8ZjfHj+Kv7EJxwM4gfXO28Git8PP+ImavNqKI7n02oLTy65SXPIhTeBaL2apkF6Ypq
         u9XCGjpI3nS5ecDD9uUbO9v2Ied7niWkca7dwq1HD6nLvx7QfLFECsZYeF34FNpiv6on
         hvQ3CSg4i7qOeQHWWP/KPTCHMfXkpGhjA8BOCC516/IXzge5RGqTjyqG8FEMaNlnuPdQ
         2aJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/WDS43rlS3733ZJcRlieCTJ4y/G+sqa5pD9t19aFErg=;
        b=pjmimUNAR0mZBk8ylh/O5SE91834ptAwKgpt8jY5YmB59B0EybSXkXqm1fCa24Q0CB
         qBgP79iZt3NNgZX+0mJrbx29WM3veQDd8hOIB2ObRFaU3+YwPm8JUId4DKvIu5PeaIsf
         yqf6WM6h2lxm0UTggTgubqzoxW7XxMtqtwUHedn2yS78VaHoVT55MhXtzMr9XOmV7oJO
         DnTL9GKa6iUu7atBJbAGye03Mo6vRy0AjzZcUI3JrdIZWWIxrIKewwDIrMi1awLdg6m9
         /fxLdayw+InIr90Hs8xz3IgzVuSv6pafQJS2JY1ORmnNhQ1pe4LcoQfX7LzgNk5HTdnB
         wZmQ==
X-Gm-Message-State: AOAM533YESk9X20JIaaQsyTY8tettWyDTW6C2tFc1J1o14ybxF7Cssr8
        aKzDpkqkT+DwmU2dyn85cb4poK3QxpkZ6lB0B8fcqQ==
X-Google-Smtp-Source: ABdhPJzXc9rSqXbU3vOVd37HoiQZ04pedfQ7RrRG7IJXH22rbvY17HN8qaobdvJmQhCEKf1KN+w0j2oWyK8yrb8YmLo=
X-Received: by 2002:a2e:95cc:: with SMTP id y12mr1360162ljh.138.1597094841875;
 Mon, 10 Aug 2020 14:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200808183439.342243-1-axboe@kernel.dk> <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net> <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk> <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk> <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk> <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
In-Reply-To: <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 10 Aug 2020 23:26:55 +0200
Message-ID: <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 10, 2020 at 11:12 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 8/10/20 3:10 PM, Peter Zijlstra wrote:
> > On Mon, Aug 10, 2020 at 03:06:49PM -0600, Jens Axboe wrote:
> >
> >> should work as far as I can tell, but I don't even know if there's a
> >> reliable way to do task_in_kernel().
> >
> > Only on NOHZ_FULL, and tracking that is one of the things that makes it
> > so horribly expensive.
>
> Probably no other way than to bite the bullet and just use TWA_SIGNAL
> unconditionally...

Why are you trying to avoid using TWA_SIGNAL? Is there a specific part
of handling it that's particularly slow?
