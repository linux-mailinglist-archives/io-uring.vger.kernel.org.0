Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A8C3B5A60
	for <lists+io-uring@lfdr.de>; Mon, 28 Jun 2021 10:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhF1IUG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Jun 2021 04:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbhF1IUF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Jun 2021 04:20:05 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAC4C061574;
        Mon, 28 Jun 2021 01:17:39 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id s129so17173956ybf.3;
        Mon, 28 Jun 2021 01:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yo16IDYfLCJaIiPuLbVJvnGRWIBfolcZOU6h46YyfGQ=;
        b=esqPMpYcn0FwzcmXMosCraGTbDEEtgLS3Kk+5b3jhRRx2E8yr/l75lhI6XpWf4ufgK
         PfgX4m5s1L5weoQl07lN9AeIAyUICIR1bYTXPi7mVzpXSyHFg3hoaVYl249/0Y+zpxwe
         iSre8nHXQBPTxqU7Ti78iu8TaSEZHIvahJEVbpF1GqXODZItqJK/cEHAHTEqOAYs15dG
         t+v4kW2M8HViSFfjx9ygh0CkbWlBTU/82w3lrmbTt27/S2jcAtXMndiSYDimrYipTSV1
         Uewsw3dkhHrTUXuvdbXh2FlVanPKHuwCUhyOY2JVhu5LebAYQD1XeO+iYq5M9Lunefi0
         Zhzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yo16IDYfLCJaIiPuLbVJvnGRWIBfolcZOU6h46YyfGQ=;
        b=Q7uZs9Jgjc5YInhkq+NXCzl5fWhy01v6ZfftIxfk8WbvOfyscIjadNeKEZbHhIpN6J
         3B48r/O+zKMhlz3JCHYBT4M6J1Y0JyUbOqw0F4NSr4H3mFbCGSHEbHXPkxuP7KYyz5n2
         dFvacvXvgrQkvaWxN4Chl77qze4rBbY8eA17gXgfgWjmfEe50TMJGu1S8qN8SsRzVd3S
         SQ1jkMMUUZdalIM2NrTjapHfoBU7ciFenflgaLnighQxKHW7hSXBvFpa20JyI+Cl21bZ
         hxpYJqjaGf0KlVZecstttUI7BELEV3I0R+s5Fxy9oydDj1phTWwPUS1bzNFEM2f/JS9N
         QO0Q==
X-Gm-Message-State: AOAM5329cZ8OziO1KLMYKC0A/JGDILFtf6A/H7jY6rxZicwRFwXi31CF
        N43Iy4tM3nTMkj0fr5fGbzZhWMPtcPYo509Qboc=
X-Google-Smtp-Source: ABdhPJy2+pxpN9SEIxsnEteIg8UurGygQQUGqTkh4l0imOxBda4al3rNY941xvLqKsPc1C9NqmZDEf0L68RKy74Dbmg=
X-Received: by 2002:a5b:ac1:: with SMTP id a1mr32397929ybr.289.1624868259191;
 Mon, 28 Jun 2021 01:17:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <20210603051836.2614535-3-dkadashev@gmail.com>
 <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com> <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
 <CAOKbgA4ZwzUxyRxWrF7iC2sNVnEwXXAmrxVSsSxBMQRe2OyYVQ@mail.gmail.com>
 <15a9d84b-61df-e2af-0c79-75b54d4bae8f@gmail.com> <CAOKbgA4DCGANRGfsHw0SqmyRr4A4gYfwZ6WFXpOFdf_bE2b+Yw@mail.gmail.com>
 <b6ae2481-3607-d9f8-b543-bb922b726b3a@gmail.com>
In-Reply-To: <b6ae2481-3607-d9f8-b543-bb922b726b3a@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 28 Jun 2021 15:17:28 +0700
Message-ID: <CAOKbgA6va=89pLayQgC20QvPeTE0Tp-+TmgJLKy+O2KKw8dUBg@mail.gmail.com>
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 24, 2021 at 7:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/24/21 12:11 PM, Dmitry Kadashev wrote:
> > On Wed, Jun 23, 2021 at 6:54 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 6/23/21 7:41 AM, Dmitry Kadashev wrote:
> >>> I'd imagine READ_ONCE is to be used in those checks though, isn't it? Some of
> >>> the existing checks like this lack it too btw. I suppose I can fix those in a
> >>> separate commit if that makes sense.
> >>
> >> When we really use a field there should be a READ_ONCE(),
> >> but I wouldn't care about those we check for compatibility
> >> reasons, but that's only my opinion.
> >
> > I'm not sure how the compatibility check reads are special. The code is
> > either correct or not. If a compatibility check has correctness problems
> > then it's pretty much as bad as any other part of the code having such
> > problems, no?
>
> If it reads and verifies a values first, e.g. index into some internal
> array, and then compiler plays a joke and reloads it, we might be
> absolutely screwed expecting 'segfaults', kernel data leakages and all
> the fun stuff.
>
> If that's a compatibility check, whether it's loaded earlier or later,
> or whatever, it's not a big deal, the userspace can in any case change
> the memory at any moment it wishes, even tightly around the moment
> we're reading it.

Sorry for the slow reply, I have to balance this with my actual job that
is not directly related to the kernel development :)

I'm no kernel concurrency expert (actually I'm not any kind of kernel
expert), but my understanding is READ_ONCE does not just mean "do not
read more than once", but rather "read exactly once" (and more than
that), and if it's not applied then the compiler is within its rights to
optimize the read out, so the compatibility check can effectively be
disabled.

I don't think it's likely to happen, but "bad things do not happen in
practice" and "it is technically correct" are two different things :)

FWIW I'm not arguing it has to be changed, I just want to understand
things better (and if it helps to spot a bug at some point then great).
So if my reasoning is wrong then please point out where. And if it's
just the simplicity / clarity of the code that is the goal here and any
negative effects are considered to be unlikely then it's OK, I can
understand that.

-- 
Dmitry Kadashev
