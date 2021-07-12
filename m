Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BDF3C5C8D
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhGLMrL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhGLMrI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:47:08 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB38C0613DD;
        Mon, 12 Jul 2021 05:44:18 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id b13so28726205ybk.4;
        Mon, 12 Jul 2021 05:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DX832C1ORCmgy/UOcPCcG0r1je+DNmKGQEEfCl2H8To=;
        b=SsMCziO9nKi00fbPUQs6Ov1CBkeYVO159tUPDhZ9pv1Cu62AwGS+iWscrQvxbwEAhX
         CHcMoixXvxiPmci+qJZxx2x7NFBtsGxxLaRfwJn3yApL7brEO8Hl+eEWcNR/OXBbXHo/
         NnQt+dJWgeWbsEJ73o9QTWPrPJA/zGt+SelUsUctRYUe45Pi2gfySwqW5KnTCmf2s8r+
         TaTY+NvhDNaThwf8dOtFnEiR/cSaGDHkyXSVAqenDLnYQ8t52QtxG9uBf0qSgbirtq0z
         ZmuFSLaxoKIbrap6V+4GFh8R3lVF4V6vla7ZmayFqQ2BKZRarockeby0bBgX7vYXat/Q
         RaLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DX832C1ORCmgy/UOcPCcG0r1je+DNmKGQEEfCl2H8To=;
        b=dgn4QorHDy+azu9OnpodigEEkX6xY1kQL9Zlhgk7UMiUPGqrm3LoJLeneYhQwDYGW+
         x8aHrvIOsLfm08cqUW+vSL4HyB47uDjNPIvyHFXwCEHGIw112vK7IMB3WP/SkJnhS8SZ
         bj1GOOrszTnqc1FOn6KpVDYcfg/Xq57ZSbrSV+Usf/BR76Ixjry+rHqkbIcmETbtkHF/
         ULIOCJtrEFFTWQGwTtwIiQcnWmD3JZFbF3y4KtVNTrNesiOFBWykCd5Y76Vu7jsaADaP
         wD9j11xcS+Z2LQzMunN1AuLjVvvTppA+35EG53PVqCU8zkGJd+gR3ZnscbaVbRR56O2h
         clGg==
X-Gm-Message-State: AOAM530KX3ct54Fcxk2N00Gs6Eduz8zCruigMcGszkzgBHfoxoN1aSoA
        hu0enSFQJpkbklG7dV3tJ90PvUbAGwuPiY+wU7k=
X-Google-Smtp-Source: ABdhPJwVkRHoGSNY7CuN4dpeI2RE4XDEmHpMYIQMUjcpQNUv0J87tkif+R87M/P1uaxwmc6QZLVc4UFCDpy6y5zRNmU=
X-Received: by 2002:a25:9bc4:: with SMTP id w4mr60758616ybo.168.1626093858256;
 Mon, 12 Jul 2021 05:44:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <20210603051836.2614535-3-dkadashev@gmail.com>
 <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com> <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
 <CAOKbgA4ZwzUxyRxWrF7iC2sNVnEwXXAmrxVSsSxBMQRe2OyYVQ@mail.gmail.com>
 <15a9d84b-61df-e2af-0c79-75b54d4bae8f@gmail.com> <CAOKbgA4DCGANRGfsHw0SqmyRr4A4gYfwZ6WFXpOFdf_bE2b+Yw@mail.gmail.com>
 <b6ae2481-3607-d9f8-b543-bb922b726b3a@gmail.com> <CAOKbgA6va=89pLayQgC20QvPeTE0Tp-+TmgJLKy+O2KKw8dUBg@mail.gmail.com>
 <5a6e1315-4034-0494-878a-a417e8294519@gmail.com>
In-Reply-To: <5a6e1315-4034-0494-878a-a417e8294519@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 12 Jul 2021 19:44:07 +0700
Message-ID: <CAOKbgA4XirCKFxC8EzURBJsEVXRmVTeqza0Rf5PW=ifB2H80_A@mail.gmail.com>
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 7, 2021 at 9:06 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/28/21 9:17 AM, Dmitry Kadashev wrote:
> > On Thu, Jun 24, 2021 at 7:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 6/24/21 12:11 PM, Dmitry Kadashev wrote:
> >>> On Wed, Jun 23, 2021 at 6:54 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>>>
> >>>> On 6/23/21 7:41 AM, Dmitry Kadashev wrote:
> >>>>> I'd imagine READ_ONCE is to be used in those checks though, isn't it? Some of
> >>>>> the existing checks like this lack it too btw. I suppose I can fix those in a
> >>>>> separate commit if that makes sense.
> >>>>
> >>>> When we really use a field there should be a READ_ONCE(),
> >>>> but I wouldn't care about those we check for compatibility
> >>>> reasons, but that's only my opinion.
> >>>
> >>> I'm not sure how the compatibility check reads are special. The code is
> >>> either correct or not. If a compatibility check has correctness problems
> >>> then it's pretty much as bad as any other part of the code having such
> >>> problems, no?
> >>
> >> If it reads and verifies a values first, e.g. index into some internal
> >> array, and then compiler plays a joke and reloads it, we might be
> >> absolutely screwed expecting 'segfaults', kernel data leakages and all
> >> the fun stuff.
> >>
> >> If that's a compatibility check, whether it's loaded earlier or later,
> >> or whatever, it's not a big deal, the userspace can in any case change
> >> the memory at any moment it wishes, even tightly around the moment
> >> we're reading it.
> >
> > Sorry for the slow reply, I have to balance this with my actual job that
> > is not directly related to the kernel development :)
> >
> > I'm no kernel concurrency expert (actually I'm not any kind of kernel
> > expert), but my understanding is READ_ONCE does not just mean "do not
> > read more than once", but rather "read exactly once" (and more than
> > that), and if it's not applied then the compiler is within its rights to
> > optimize the read out, so the compatibility check can effectively be
> > disabled.
>
> Yep, as they say it's about all the "inventive" transformations
> compilers can do, double read is just one of those that may turn very
> nasty for us.
>
> One big difference for me is whether it have a potential to crash the
> kernel or not, though it's just one side.

Ah, that makes sense.

> Compilers can't drop the check just because, it first should be proven
> to be safe to do, and there are all sorts barriers around and
> limitations on how CQEs and SQEs are used, making impossible to alias
> memory. E.g. CQEs and SQEs can't be reused in a single syscall, they're
> only written and read respectively, and so on. Maybe, the only one I'd
> worry about is the call to io_commit_sqring(), i.e. for SQE reads not
> happening after it, but we need to take a look whether it's
> theoretically possible.

Thanks for the explanation, Pavel!

-- 
Dmitry Kadashev
