Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E2753AD16
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 20:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiFASxU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 14:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiFASxT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 14:53:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5E2149159
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 11:53:14 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n10so5616239ejk.5
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 11:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=idL2yQRFOy1hBJ1NSHecJbxG0rxoSuhlYFXzZ6X/QIM=;
        b=hNYIo0IZSnyCKjBFpFC2T9gjitpRKQVi4I9fJpADdeDspIfTd2nupJGSDU7VQ+Zgij
         Qn0tNA6U9mWY7NGRGKjYEgUxjqB2u7JvzG0fpOHmmuH16+LBKLwHiIXijjNGOIru9s8U
         csUPTQwy1QPVAFkRogZVGmc0/VHLLLmBK22rQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=idL2yQRFOy1hBJ1NSHecJbxG0rxoSuhlYFXzZ6X/QIM=;
        b=wlmLoWqiHsudytuENQ8a31Vn4/33VtUrvR/yEK3Usz1ng9T8ilb/uPrG8yV+SrK6J/
         wHxco/0PCawo09SvZfwWDdnDtPwBxZtQ5sn4g6ubFodu9rfV6zO7s0S8Z3Ug5dgZ+dLd
         pNeReSkofEFGbk22drLILchnJ/3fPZEm96h/cxPg2bgt0mDRBoU839CJ6xkUE4BG9pzs
         4sg9bnI0PlhJMxnSYSE8nxz6ba2r1Ju74frkWtgVv+UEEQyAYEOPaEJzN9VUoXQRro4O
         oBtQwzokADYG2DnXI0KCDcw/ssDdMAVTloZ+zWNkw5QzXusRvO6NhvcI3ccny6YNpZlA
         tbrg==
X-Gm-Message-State: AOAM530mxEAmYXEvCCbYvHfbSRJ6npsdhch6VUst4PWCCAVapyuXauF8
        jmVsNoYnEYUGB7Z55B8ACMCvCgkV82+1JhYS
X-Google-Smtp-Source: ABdhPJxjW9XTOiZEllzodqfMq2YyNSt0A+LxN4PXk0K5rta4IHIRevcmrBb8+0mSUsjypovZWEMKnA==
X-Received: by 2002:a17:907:1c8c:b0:6ff:144d:e7da with SMTP id nb12-20020a1709071c8c00b006ff144de7damr845905ejc.542.1654109592573;
        Wed, 01 Jun 2022 11:53:12 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id fg16-20020a1709069c5000b006fe8d8c54a7sm986578ejc.87.2022.06.01.11.53.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 11:53:12 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id f7-20020a1c3807000000b0039c1a10507fso1592322wma.1
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 11:53:11 -0700 (PDT)
X-Received: by 2002:a7b:cb91:0:b0:397:3225:244 with SMTP id
 m17-20020a7bcb91000000b0039732250244mr29945960wmi.68.1654109591504; Wed, 01
 Jun 2022 11:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk> <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk> <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
 <20220326143049.671b463c@kernel.org> <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
 <CAHk-=wiTyisXBgKnVHAGYCNvkmjk=50agS2Uk6nr+n3ssLZg2w@mail.gmail.com>
 <32c3c699-3e3a-d85e-d717-05d1557c17b9@kernel.dk> <CAHk-=wiCjtDY0UW8p5c++u_DGkrzx6k91bpEc9SyEqNYYgxbOw@mail.gmail.com>
 <a59ba475-33fc-b91c-d006-b7d8cc6f964d@kernel.dk>
In-Reply-To: <a59ba475-33fc-b91c-d006-b7d8cc6f964d@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Jun 2022 11:52:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg9jtV5JWxBudYgoL0GkiYPefuRu47d=L+7701kLWoQaA@mail.gmail.com>
Message-ID: <CAHk-=wg9jtV5JWxBudYgoL0GkiYPefuRu47d=L+7701kLWoQaA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 1, 2022 at 11:34 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> But as a first step, let's just mark it deprecated with a pr_warn() for
> 5.20 and then plan to kill it off whenever a suitable amount of relases
> have passed since that addition.

I'd love to, but it's not actually realistic as things stand now.
epoll() is used in a *lot* of random libraries. A "pr_warn()" would
just be senseless noise, I bet.

No, there's a reason that EPOLL is still there, still 'default y',
even though I dislike it and think it was a mistake, and we've had
several nasty bugs related to it over the years.

It really can be a very useful system call, it's just that it really
doesn't work the way the actual ->poll() interface was designed, and
it kind of hijacks it in ways that mostly work, but the have subtle
lifetime issues that you don't see with a regular select/poll because
those will always tear down the wait queues.

Realistically, the proper fix to epoll is likely to make it explicit,
and make files and drivers that want to support it have to actually
opt in. Because a lot of the problems have been due to epoll() looking
*exactly* like a regular poll/select to a driver or a filesystem, but
having those very subtle extended requirements.

(And no, the extended requirements aren't generally onerous, and
regular ->poll() works fine for 99% of all cases. It's just that
occasionally, special users are then fooled about special contexts).

In other words, it's a bit like our bad old days when "splice()" ended
up falling back to regular ->read()/->write() implementations with
set_fs(KERNEL_DS). Yes, that worked fine for 99% of all cases, and we
did it for years, but it also caused several really nasty issues for
when the read/write actor did something slightly unusual.

So I may dislike epoll quite intensely, but I don't think we can
*really* get rid of it. But we might be able to make it a bit more
controlled.

But so far every time it has caused issues, we've worked around it by
fixing it up in the particular driver or whatever that ended up being
triggered by epoll semantics.

                Linus
