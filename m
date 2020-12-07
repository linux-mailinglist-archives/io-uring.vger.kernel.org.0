Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670B52D146C
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 16:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgLGPIi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 10:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgLGPIi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 10:08:38 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274D4C061749
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 07:07:52 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id z136so13640351iof.3
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ndRz1cgh6hh8Vi60WHyqWhjYdmGIrY1tFdFrsvJKj0=;
        b=Cug+bh5vp+Kh8dhZp3BU1N6nKnZFtu8bMAzYXDCLkiJsiQrcbIPXobdpFY3WMQ/9U/
         r2PJRBVUAyFq6rEdnx3zNZl6o2uxpEFMlfgQt5iRRymBlOvvYZjokW0CCw52oj4fS93d
         /zQh9Qs2PqaudxGZ3oMZJld2LluVfXLJnKJ98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ndRz1cgh6hh8Vi60WHyqWhjYdmGIrY1tFdFrsvJKj0=;
        b=qEWQfniIobsMUSYBShPT2XlR3o3C4keGPzoIxAlvNHrdFqhyQbLD+IQO76+5MtlcBh
         YwlQZU8RckjuZD8wLamsbV7bxLgHf29vMyf/5CBDAbaLhciBuVkic0f0QgKGhywlLlvc
         xr9iAuFh7R697Fphjq54TemTMWh+GiBdrrDH1DQwW4jVZLLy2kgLjdM5It2NyqtEG7od
         mZp4JMcYSrTmbYMlZbbRJea8J84voEbyeY1JNaVdxvioSs7MWW91idI1O9uKJkM/4Hdk
         k9sdgxKei7y7mnemBMagBACgy66ih1UInhjmQleRlHS/bfLAmVP+ZAWXgcf6d9Yh2Khu
         osKQ==
X-Gm-Message-State: AOAM530zWV15LxKwRuBJZtPYPl2IJHY5eWmHQ/aUB3yD4ouNT1bu3rm1
        iIdOXBhD70AP85rrf1FLrUxSFuOb+FeoVw==
X-Google-Smtp-Source: ABdhPJyj9ygv91F+IXJlndQPaItyWNH55UD27oRouE+eTY+yLYElht02oL/tFHsRO1q/zQpfmHjf2A==
X-Received: by 2002:a6b:fb19:: with SMTP id h25mr21215885iog.200.1607353671207;
        Mon, 07 Dec 2020 07:07:51 -0800 (PST)
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com. [209.85.166.48])
        by smtp.gmail.com with ESMTPSA id q5sm6027337ile.48.2020.12.07.07.07.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 07:07:50 -0800 (PST)
Received: by mail-io1-f48.google.com with SMTP id o8so13666939ioh.0
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:07:50 -0800 (PST)
X-Received: by 2002:a02:90ca:: with SMTP id c10mr22358195jag.115.1607353669544;
 Mon, 07 Dec 2020 07:07:49 -0800 (PST)
MIME-Version: 1.0
References: <CANiDSCsXd1BLUJwgdET5XBF8wQEpbape6BoCPpG9cTGAkUJOBA@mail.gmail.com>
 <f0490f07-c59b-1dab-067f-f17dcfbb61da@gmail.com>
In-Reply-To: <f0490f07-c59b-1dab-067f-f17dcfbb61da@gmail.com>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 7 Dec 2020 16:07:38 +0100
X-Gmail-Original-Message-ID: <CANiDSCvyBBQyQV1PAqOGwaSRtcWn+1xXN=TLj59Gf-u3EWd49w@mail.gmail.com>
Message-ID: <CANiDSCvyBBQyQV1PAqOGwaSRtcWn+1xXN=TLj59Gf-u3EWd49w@mail.gmail.com>
Subject: Re: Zero-copy irq-driven data
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel

Thanks for your response

On Fri, Dec 4, 2020 at 5:09 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 03/12/2020 15:26, Ricardo Ribalda wrote:
> > Hello
> >
> > I have just started using io_uring so please bear with me.
> >
> > I have a device that produces data at random time and I want to read
> > it with the lowest latency possible and hopefully zero copy.
> >
> > In userspace:
> >
> > I have a sqe with a bunch of io_uring_prep_read_fixed and when they
> > are ready I process them and push them again to the sqe, so it always
> > has operations.
>
> SQ - submission queue, SQE - SQ entry.
> To clarify misunderstanding I guess you wanted to say that you have
> an SQ filled with fixed read requests (i.e. SQEs prep'ed with
> io_uring_prep_read_fixed()), and so on.


Sorry, I am a mess with acronyms.

>
>
> >
> > In kernelspace:
> >
> > I have implemented the read() file operation in my driver. The data
>
> I'd advise you to implement read_iter() instead, otherwise io_uring
> won't be able to get all performance out of it, especially for fixed
> reqs.
>
> > handling follows this loop:
> >
> > loop():
> >  1) read() gets called by io_uring
> >  2) save the userpointer and the length into a structure
> >  3) go to sleep
> >  4) get an IRQ from the device, with new data
> >  5) dma/copy the data to the user
> >  6) wake up read() and return
> >
> > I guess at this point you see my problem.... What happens if I get an
> > IRQ between 6 and 1?
> > Even if there are plenty of read_operations waiting in the sqe, that
> > data will be lost. :(
>
> Frankly, that's not related to io_uring and more rather a device driver
> writing question. That's not the right list to ask these questions.
> Though I don't know which would suit your case...
>
> > So I guess what I am asking is:
> >
> > A) Am I doing something stupid?
>
> In essence, since you're writing up your own driver from scratch
> (not on top of some framework), all that stuff is to you to handle.
> E.g. you may create a list and adding a short entry with an address
> to dma on each IRQ. And then dma and serve them only when you've got
> a request. Or any other design. But for sure there will be enough
> of pitfalls on your way.
>
> Also, I'd recommend first to make it work with old good read(2) first.
>
> >
> > B) Is there a way for a driver to call a callback when it receives
> > data and push it to a read operation on the cqe?
>
> In short: No
>
> After you fill an SQE (which is also just a chunk of memory), io_uring
> gets it and creates a request, which in your case will call ->read*().
> So you'd get a driver-visible read request (not necessarily issued by
> io_uring)
>
> >
> > C) Can I ask the io_uring to call read() more than once if there are
> > more read_operations in the sqe?
>
> "read_operations in the sqe" what it means?

Lets say I have 3 read_operations in the sq. A standard trace from the
driver will look like

read()
 return
read()
 return
read ()
 return

If I could get

read()
read()
read()
 return
 return
 return

Then I would not lose any data during " read() reloading"

>
> >
> > D) Can the driver inspect what is in the sqe, to make an educated
>
> No, and shouldn't be needed.
>
> > decision of delaying the irq handling for some cycles if there are
> > more reads pending?
>
> --
> Pavel Begunkov



-- 
Ricardo Ribalda
