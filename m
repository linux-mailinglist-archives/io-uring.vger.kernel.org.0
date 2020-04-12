Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2431A5F2C
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 17:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgDLPPA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Apr 2020 11:15:00 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:38228 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgDLPO7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Apr 2020 11:14:59 -0400
Received: by mail-io1-f48.google.com with SMTP id f19so6961709iog.5
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 08:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H85Nfa9RpX5+4O70O8A24XegkOR2H2Xtw9lPqC2Xs5Q=;
        b=KjQyOZBgp+DT2Vw4tY0QZT/phoqAJgeRAol+UV9Bc/rmmHj1+iiAC85+9OJ0jP2nBX
         z/INUlAbEeHYsP3uahPlkqbve/Iji0UgHv2zKpQ5mGjfjAdWuylyR/PI5OFVc5P3kZvA
         A2XLnELBVLL/LDktgobZPLxEIDcPh2I9ets8mhA91IxVeUMl3YrauBariD8JqKaLgLs2
         n8Piq9c/EAqnT34Or8ve6iP15DE7GP2NOr2d1Kv3AfBdLz1n96zcdNNe2gQK0hamqPcW
         EMy5wiQ+HBNYZbgXGmlDs9npoKm06VSmcV8/V0edGJrtnBPyqy3klWP4J2DPPvc6cmgR
         Zw0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H85Nfa9RpX5+4O70O8A24XegkOR2H2Xtw9lPqC2Xs5Q=;
        b=NLBCIsYM/Ff0ETaQHe7xGwkyxbXsqEaTPYQ/xP3ZIX5UGPzLrHcrHdUOkMquTziulB
         0KFv83u/Iv4qBpzIsnA0hzDVzH+45dKUSphuuULqDnTiKSJ4ZAoVygYK09j+Fj4oQOoc
         eVOM3wX28bN4Sc8uvE9S5LQ66kxjpMAXnoObWRCThOmOt4Cmm4xqiRcuVxkRvK0cYOuS
         5tm2bkDLvR8V3Zd+WlrWGHA0Fvsw3c9HMd7CXY5uEkF/G42bDFwy1Dpfeff6SoC+d7dp
         f10xP0Yd2l2fr+PuABKbhwGwbP/h1EOFqlPREgiH8LzarnAcTFo6LhaVhp2EEq8fO2DW
         1P+Q==
X-Gm-Message-State: AGi0PuY2hlD+MFQ1yWbM2IIDh4KMvN8lg/8y6aa2VPH4gxvksBtHAfQF
        wLFthfz9zyzQT2JFwRDhhwmDHHxM84ObXIiCNms=
X-Google-Smtp-Source: APiQypKllufSX2sCzmZuhYmKZSUi/o1+fXTNWpJZdkCoUQyCd5xZ+DTaU4LY/eTz0Bi2L6ua5u35IPth2sLiv3D0+VA=
X-Received: by 2002:a6b:e611:: with SMTP id g17mr12717363ioh.31.1586704497536;
 Sun, 12 Apr 2020 08:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAEsUgYgTSVydbQdjVn1QuqFSHZp_JfDZxRk7KwWVSZikxY+hYg@mail.gmail.com>
 <e146dd8a-f6b6-a101-a40e-ece22b7fe320@kernel.dk> <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
In-Reply-To: <fe383a44-bcfb-d6fa-2afe-983b456e7112@gmail.com>
From:   Hrvoje Zeba <zeba.hrvoje@gmail.com>
Date:   Sun, 12 Apr 2020 11:14:46 -0400
Message-ID: <CAEsUgYiwyjpbaUbHwbx9pHD6x5DBpDop_Z4w9_QXKDd=FdjDjw@mail.gmail.com>
Subject: Re: Odd timeout behavior
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 12, 2020 at 5:15 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 4/12/2020 5:07 AM, Jens Axboe wrote:
> > On 4/11/20 5:00 PM, Hrvoje Zeba wrote:
> >> Hi,
> >>
> >> I've been looking at timeouts and found a case I can't wrap my head around.
> >>
> >> Basically, If you submit OPs in a certain order, timeout fires before
> >> time elapses where I wouldn't expect it to. The order is as follows:
> >>
> >> poll(listen_socket, POLLIN) <- this never fires
> >> nop(async)
> >> timeout(1s, count=X)
> >>
> >> If you set X to anything but 0xffffffff/(unsigned)-1, the timeout does
> >> not fire (at least not immediately). This is expected apart from maybe
> >> setting X=1 which would potentially allow the timeout to fire if nop
> >> executes after the timeout is setup.
> >>
> >> If you set it to 0xffffffff, it will always fire (at least on my
> >> machine). Test program I'm using is attached.
> >>
> >> The funny thing is that, if you remove the poll, timeout will not fire.
> >>
> >> I'm using Linus' tree (v5.6-12604-gab6f762f0f53).
> >>
> >> Could anybody shine a bit of light here?
> >
> > Thinking about this, I think the mistake here is using the SQ side for
> > the timeouts. Let's say you queue up N requests that are waiting, like
> > the poll. Then you arm a timeout, it'll now be at N + count before it
> > fires. We really should be using the CQ side for the timeouts.
>
> As I get it, the problem is that timeout(off=0xffffffff, 1s) fires
> __immediately__ (i.e. not waiting 1s).

Correct.

> And still, the described behaviour is out of the definition. It's sounds
> like int overflow. Ok, I'll debug it, rest assured. I already see a
> couple of flaws anyway.

For this particular case,

req->sequence = ctx->cached_sq_head + count - 1;

ends up being 1 which triggers in __req_need_defer() for nop sq.

-- 
I doubt, therefore I might be.
