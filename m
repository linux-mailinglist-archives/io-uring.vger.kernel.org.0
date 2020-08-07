Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C111723E8BB
	for <lists+io-uring@lfdr.de>; Fri,  7 Aug 2020 10:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgHGIR1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Aug 2020 04:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgHGIR1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Aug 2020 04:17:27 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B11EC061574
        for <io-uring@vger.kernel.org>; Fri,  7 Aug 2020 01:17:27 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id j10so369075qvo.13
        for <io-uring@vger.kernel.org>; Fri, 07 Aug 2020 01:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=AoKThlq6VtqLQY35g2UBR3GmiVU5JuS1iQetbPRkfpg=;
        b=C9nQAzKvBxHmBb2jbvCpHWh1SrhzQq7f2tl/NluBPjU2zgTNRdbiMaDMFp2mWIDmdk
         BNMoX1hcQ4Qr429MRDWx0DE+/n62bxxhpiXdswA7sS1W0m2OnL1Xwx56XlN0Q9CaAoSe
         X2sPPkr9oHx/bh7JddxVG+gYcBgxO7yRvwIbEZwb5i2ScS5/+7kY9717PUErTSDyavca
         L5+CnPnCQbsOPUg8zHbPUZuSQZSELCbvhysy4gDgpNQVbMFKODEcXIUbxhb1e1Kf/+FA
         X2fhFEBF3mn5g5y4zZNBf6HaN390Ysk5x1HcFTJdCU7cq6dn88Fpbqd0AKNB5Lm1li0B
         vP+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=AoKThlq6VtqLQY35g2UBR3GmiVU5JuS1iQetbPRkfpg=;
        b=ellhGK92DukwrZ0MVP+mw/bM/1Vw0Xe0ikpkMJVmd/kb9YA9Nk0FROnLLlMrZ+wCKZ
         7A86uIOICQdd+H0lmGrb3pn99XG7QtbocE2wtyPE32DncbzxqLFZaecVvFMOt+4g6F4B
         MOIPTi9/6Y7WjTEU3q44Kca935+Re431zOwXTdJCffvxPQzqoWNo2mwKCl0mmpCboieO
         OCIigzNTZxGkwOWI15yQpOV16W8LCuH71yKIsQvUhw6cEYd+RmuoBdXJTe0svmPwcGvV
         8opL7FCrPMaCecMIc5eTDb5IIbHAEAvb0ymbj8H4fHiwBidBIo7uo26X2Qto3WdIPcFI
         kb9w==
X-Gm-Message-State: AOAM533tjowMJEx/SeRIVgQp2pDm4XVazWv27fkwkyasmERO53cthrL4
        4iXs43t6wv7tMAe5JIvbiqKCyDO4JviygwSH0WI=
X-Google-Smtp-Source: ABdhPJwS2Ah+I4KYSvZj3vM0dNjlFEDU60arJ9BaCK7mPu8Axui0fdu8hWUd0dBpCaFJs4+jLQKZ+vsVw8QAcbmIptI=
X-Received: by 2002:a0c:fa0a:: with SMTP id q10mr13714485qvn.33.1596788245107;
 Fri, 07 Aug 2020 01:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+rhVS669Q=PCHrmHXbr067HpdC7Dtu0ogm4u-uj6-qK3Q@mail.gmail.com>
 <2cc90695-3705-b602-beac-db2252d13b86@gmail.com>
In-Reply-To: <2cc90695-3705-b602-beac-db2252d13b86@gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Fri, 7 Aug 2020 10:17:13 +0200
Message-ID: <CAAss7+rbm8D8OyM1gjj7wXCizVPeGxh19WUOiiX3bzcqe4v2zQ@mail.gmail.com>
Subject: Re: wake up io_uring_enter(...IORING_ENTER_GETEVENTS..) via eventfd
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

yeah thanks, there is already a fix patch from Jens [PATCH] io_uring:
use TWA_SIGNAL for task_work related to eventfd


On Fri, 7 Aug 2020 at 09:31, Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> Hi,
>
> I'd love to help but don't have time at the moment. I'll take a look but
> in a week, either send it to io-uring@vger.kernel.org. Jens deals with
> such stuff lightning fast!
>
> > io_uring application should be a single thread in my application which
> > means a different thread wakes up io_uring_enter via eventfd. The issue is
> > that io_uring_enter(fd, 0, min_complete, IORING_ENTER_GETEVENTS, 0) which
> > is blocking doesn't get any poling event from eventfd_write when both
> > functions are executed in different threads
>
> Yeah, sounds strange. Did you try to do the same but without io_uring?
> e.g. with write(2), select(2).
>
> >
> >
> > here small example
> >
> > https://gist.github.com/1Jo1/6496d1b8b6b363c301271340e2eab95b
> >
> >
> > io_uring_enter will get a polling event if you move eventfd_write(efd,
> > (eventfd_t) 1L) to the main thread,
> >
> > I don't get it..probably I missed something, why can't I run both functions
> > on different threads, any ideas what the cause might be?
> >
> >
> > (Linux Kernel 5.7.10-201) liburing 0.6 & 0.7
> >
> > ---
> > Josef
> >
>
> --
> Pavel Begunkov
