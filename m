Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763F7144A32
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 04:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgAVDKK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 22:10:10 -0500
Received: from mail-qv1-f52.google.com ([209.85.219.52]:36861 "EHLO
        mail-qv1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729074AbgAVDKK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 22:10:10 -0500
Received: by mail-qv1-f52.google.com with SMTP id m14so2583570qvl.3
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 19:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=wEQkkYy3W5addOn8P1zK8gMhaNicCW1EOJVoVOnMO9Y=;
        b=YMq+N+o9hUK3azHQd6laspB+eMzWXmGZdj3O3ezce5t4b5wFBXm6zx9WOdXYU3q2YJ
         TeKv+oiW2P1P49CF+STFjt54QWfgoEE3Lpi7GRqxQGrsnw/HOrpi+7Rr2UyGxKFQhmlh
         GmwbFaHp2Ir4SX+lLJB8FLXpVwJ3YH/UStTKg72COXoos72lbWvziZZ+Prlzjmzpe5Yd
         T8KaziOTzZOGmyKKAphlcfeDQqVcGazFsYeif0qvteDmIDREA1X68vXVMR4WqhXgBeq4
         OwvrWZDJoZB29VejPYiPGQg9NtC2WKQVE+FE3D+gXza6eCmE9QVLptqOOCFKn6TkBewt
         q00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=wEQkkYy3W5addOn8P1zK8gMhaNicCW1EOJVoVOnMO9Y=;
        b=VsEipzy0ZjS2xLzlxs3h3eIQD+ajj3SY6lYVJunVJZrEZch7RBt90MKrDypWVDrius
         jJqxWQYuKtkgBiQYvDD67Y31jcjQtPMVLoPOlwsv+6ptDWYpk4w37dzkMamhDv8ioCHN
         t1WkNdzPh0VVI+RNz+uOHCpYGSz2tmmgLJ7vS/QhZOpisqHZQUoNrZy8dGy0bjhpmW4j
         DAkQ8Y690BPcyoSjHhkQbumHVWQvc9jrvTXrtIQ7rlEefTieuHbsvUJdLu9RmTthTPyf
         dziInRaf6I9aoK4JLGvzXGH2uy1GkvWtpTI5Y5sf9Tt5Aj0IlmWdazWi2ZL+pmTbafUr
         g4og==
X-Gm-Message-State: APjAAAU+U38YQqft94prjkdzSy2WEbrkZfsfWyuMBdJudqrg471mwTk7
        Z1k7ArP0UpDN/cgiA2kUN4HQQEiKkKvjYZCGXlaxwV32MAW3
X-Google-Smtp-Source: APXvYqzXtmd0eM0+c9pO5MFse/J0ErEwAEWnvogMiv7bLjvn9aiosXiAJjoglghcQg/AEU3DkKiMf0VptG0FrGei7Cc=
X-Received: by 2002:ad4:4511:: with SMTP id k17mr7901855qvu.135.1579662609341;
 Tue, 21 Jan 2020 19:10:09 -0800 (PST)
MIME-Version: 1.0
References: <CADPKF+ew9UEcpmo-pwiVqiLS5SK2ZHd0ApOqhqG1+BfgBaK5MQ@mail.gmail.com>
 <1f98dcc3-165e-2318-7569-e380b5959de7@kernel.dk>
In-Reply-To: <1f98dcc3-165e-2318-7569-e380b5959de7@kernel.dk>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 22 Jan 2020 06:09:33 +0300
Message-ID: <CADPKF+e3vzmfhYmGn1MSyjknMWQwCyi9NjWnzL23ADxAvbSNRw@mail.gmail.com>
Subject: Re: Waiting for requests completions from multiple threads
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Thank you for quick reply! Yes I understand that I need a sort of
serializable-level isolation
when accessing the rings - I hope this could be done with a simple
atomic cmp-add after optimistic write ring update.

Correct me if I'am wrong, but from my understanding the kernel can
start to pick up newly written Uring jobs
without waiting for the "io_uring_enter" user level call and that's
why we need a write barrier(so that
the ring state is always valid for the kernel), else "io_uring_enter"
could serve as a write barrier itself as well...


On Wed, Jan 22, 2020 at 5:51 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/21/20 7:45 PM, Dmitry Sychov wrote:
> > Really nice work, I have a question though.
> >
> > It is possible to efficiently wait for request completions
> > from multiple threads?
> >
> > Like, two threads are entering
> > " io_uring_enter" both with min_complete=1 while the completion ring
> > holds 2 events - will the first one goes to thread 1 and the second
> > one to thread 2?
> >
> > I just do not understand exactly the best way to scale this api into
> > multiple threads... with IOCP for example is is perfectly clear.
>
> You can have two threads waiting on events, and yes, if they each ask to
> wait for 1 event and 2 completes, then they will both get woken up. But
> the wait side doesn't give you any events, it merely tells you of the
> availability of them. When each thread is woken up and goes back to
> userspace, it'll have to reap an event from the ring. If each thread
> reaps one event from the CQ ring, then you're done.
>
> You need synchronization on the CQ ring side in userspace if you want
> two rings to access the CQ ring. That is not needed for entering the
> kernel, only when the application reads a CQE (or modifies the ring), if
> you can have more than one thread modifying the CQ ring. The exact same
> is true on the SQ ring side.
>
> --
> Jens Axboe
>
