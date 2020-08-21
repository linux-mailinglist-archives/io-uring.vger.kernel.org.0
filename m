Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B9624D680
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 15:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgHUNrT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Aug 2020 09:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbgHUNoG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Aug 2020 09:44:06 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE759C0617A4
        for <io-uring@vger.kernel.org>; Fri, 21 Aug 2020 06:43:55 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id dd12so642343qvb.0
        for <io-uring@vger.kernel.org>; Fri, 21 Aug 2020 06:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kpXOnh5i2AaRDVmRHLm2jM2CEwuxQXJnsRXDJkr/5kc=;
        b=qN1IGVdsM6LgXCvrGw+98pP9MwcapCGxGoS6VWLvmRQwM06KYM+GkCuNahN7AY4W/L
         HLfp1TgS7lC1ljh6YQhUF738ASMknz1v34dbiuLK++a8L1dBe4dJp1BsCZiMTJK3Pzpg
         n4CEb9S1TWkzBSjxxBNtmIbOzI0370JOrP1qhnpi7TQ5u6r2ivfu3YCaVagD+HAaW1Uq
         REOpCGU9tJdQPT4nx3JOmb2DiVSX+YXGdkfjVCZ/E5HIKCYJVwVerH1G5HGoskh6+ITi
         nDH+1t9DLyJAH8lVPNSmtVWztcCGEHas0sgPPeJHOcpAj/afWnPTVGS7cdy3t4hjYqYp
         7DZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kpXOnh5i2AaRDVmRHLm2jM2CEwuxQXJnsRXDJkr/5kc=;
        b=FopvQvCEYubqh63Gei5SxSZjm2Ug2DoPT9LLQ4H+n3ybddxwTXwFZLbOheyt/mDTe+
         MW/i/rXk2BDHCIbqsEbW1zxCYF6FxuXf9GpVYiqQSHb+PZNNRCRbPl3NseCKuzB6sAdD
         ID6PxWy0apuIs3TicVcq+sGiGFijJltcsKV5pk6ounDEY5wbhxx9GjLCRd1kbEqGoJEL
         dgRX76z40i+KjSBVhri/fv+5Io9G6Xq7/kujmVhlpdYKUjhMYvO85g5NPrLNuCDSru6+
         ka6nTrKBP8FaKPLPkiPtKiXKlwo6dQYFQW07Vh5LQkXIK5RSLQidcRwsb8fy2AlP1xV+
         8Nhw==
X-Gm-Message-State: AOAM531bJ2cL/4fQ6GfIGDYXTBL1e1lavO7gRxavTA4Wp5ofE/KqT6gQ
        Tup1S3KGiHyhEFx6sXbRvppEko9yxNgnjjywMJNyF+SUuAY=
X-Google-Smtp-Source: ABdhPJxMw56GS21pmjnlmpUgnLRaL3sx4dMJEsP8hksfoirSQ6jZ56DRne4Whqwp9kxJdNCt+JTOxwrsBoCGSGkAPQg=
X-Received: by 2002:a0c:ea45:: with SMTP id u5mr2327812qvp.191.1598017435112;
 Fri, 21 Aug 2020 06:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
 <477c2759-19c1-1cb8-af4c-33f87f7393d7@kernel.dk> <CAF-ewDp5i0MmY8Xw6XZDZZTJu_12EH9BuAFC59pEdhhp57c0dQ@mail.gmail.com>
 <004a0e61-80a5-cba1-0894-1331686fcd1a@kernel.dk> <CAF-ewDqANgn-F=9bQiXZtLyPXOs2Dwi-CHS=80hXpiZYGrJjgg@mail.gmail.com>
 <af9ffef1-fe53-e4d5-069b-8cfba31273c2@kernel.dk> <CAF-ewDrW-7hRuQ1QkNzJVbBWM5U4cTMi1reB=e=-dTuh8WymMg@mail.gmail.com>
In-Reply-To: <CAF-ewDrW-7hRuQ1QkNzJVbBWM5U4cTMi1reB=e=-dTuh8WymMg@mail.gmail.com>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Fri, 21 Aug 2020 16:43:43 +0300
Message-ID: <CAF-ewDoqyx5knsnd_qgfRXE+CxK==PO1zF+RE=oEuv9NQq+48g@mail.gmail.com>
Subject: Re: Very low write throughput on file opened with O_SYNC/O_DSYNC
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

noticed that i made a mistake in c reproducer. it doesn't reap
completelitions correctly, but it was still sufficient to reproduce
the problem.
the idea is to submit writes at the high rate, waiting only when
necessary and at the end.

anyway, i am not so interested in making it work on my computer but
rather would like to ask, what are your thoughts about serializing
writes in the kernel?
it looks like that sometimes it is strictly worse and might be a
problem for integrations into the runtimes (e.g. libuv, nodejs,
golang). at the same time it is very easy to
serialize in user space if necessary.

On Wed, 19 Aug 2020 at 10:55, Dmitry Shulyak <yashulyak@gmail.com> wrote:
>
> reproducer with liburing -
> https://github.com/dshulyak/liburing/blob/async-repro/test/async-repro.c
> i am using self-written library in golang for interacting with uring,
> but i can reproduce the same issue with that snippet consistently.
>
> On Tue, 18 Aug 2020 at 19:42, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 8/18/20 9:09 AM, Dmitry Shulyak wrote:
> > > it worked, but there are some issues.
> > > with o_dsync and even moderate submission rate threads are stuck in
> > > some cpu task (99.9% cpu consumption), and make very slow progress.
> > > have you expected it? it must be something specific to uring, i can't
> > > reproduce this condition by writing from 2048 threads.
> >
> > Do you have a reproducer I can run? Curious what that CPU spin is,
> > that obviously shouldn't happen.
> >
> > --
> > Jens Axboe
> >
