Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25E64FECE1
	for <lists+io-uring@lfdr.de>; Wed, 13 Apr 2022 04:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiDMC2k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 22:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiDMC2j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 22:28:39 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC85C275E3
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 19:26:19 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2ebd70a4cf5so7861817b3.3
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 19:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zhGt5FAgCnpy8hdwxua7b3m9MVC3AGU2zm+uN+Pi1Nw=;
        b=dbMRy4DWuDzzTkQk8qqy/LhGB4Q1J/f7HcQT/qwO+q8rUlRXJJT0o6ixLcro1zFv6/
         vj+3lflOdAl1BxLJlicEd8zY9KSTIdl5EA4PIulUvdKAf5EzrwOEZUSYtX8kA7ita5v0
         MT/1Q3HJCvDdhdEEnYTk2kdU2qHENkND3nJ29o4Hkg2DcT0z3Lpe2+HAgk9t2XBL3gM6
         o9pfF4YfhWkKbXovpmcbdSbv60DtuHGixfonN8Fj+vH7TEFcmCntEalMUmmOMwirOx87
         tnFpPb3XoO45eZDXTvurWFrkHGaaADZ+kLR/07uHQ41ag3sOm7L5CAkSl0Q+EK1EmBsm
         aJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zhGt5FAgCnpy8hdwxua7b3m9MVC3AGU2zm+uN+Pi1Nw=;
        b=YN+0OYyaRgYup0Bm8+NXPxlbDtFTzBN3s+JdGWaTgIx+4FHw1RjizUXkZdVQMtcn8M
         wHCbcWYLnnpweNrD7u4J9Sb5lsP6QEJoOdPIowhdpZdATrnVUBmRR2xeopHW2wiSbF0t
         4jOjZkf/sCh/SOqba5P5ge0Z/TE1u5Zw9lTWuHsa7IxC8BluPicMbIDW7Bmwbwb7nEBl
         K5d3pC0ra/82v6iyUJT1ysqzlw3RnicYEglBj2A3nPlKEqpgxUMYzYn+bvCAWzJbgp1s
         XZQW+1sS/7b1bHv3D5dPu9pDbudr7K4DmWFVc2pRat1gsHN+CfjxRR6Mqu1wnBwkmEzc
         27qg==
X-Gm-Message-State: AOAM530fI9wBAjanvY0rXjCj7S5KWZ+mdh24XY1SoM2I7k4+XGjNCYKN
        rX9JrwGsQnk2axaZRUnxd839W4k6bGGi3nhLQxesTizhXTHLA0q9
X-Google-Smtp-Source: ABdhPJxRYjve+Kr1TnHXbyjA6F97kvKWG8W1ZrYA9uzDU6oK0PBduReqY+S+jMpMjr6o2sBwSGyODDKLgDNvdTo00+A=
X-Received: by 2002:a81:1187:0:b0:2eb:ee1b:7d00 with SMTP id
 129-20020a811187000000b002ebee1b7d00mr17564377ywr.55.1649816778414; Tue, 12
 Apr 2022 19:26:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220412202613.234896-1-axboe@kernel.dk> <e7631a6f-b614-da4c-4f47-571a7b0149fc@gmail.com>
 <80ba97f9-3705-8fd6-8e7d-a934512d7ec0@kernel.dk> <CANn89iJRCeB2HZyy49J60KReZKwrLysffy9cmLSw6+Wd4qJy-g@mail.gmail.com>
 <d772ae66-6c0f-4083-8530-400546743ef6@kernel.dk> <CANn89i+1UJHYwDocWuaxzHoiPrJwi0WR0mELMidYBXYuPcLumg@mail.gmail.com>
 <22271a21-2999-2f2f-9270-c7233aa79c6d@kernel.dk> <CANn89iKXTbDJ594KN5K8u4eowpTWKdxXJ4hBQOqkuiZGcS7x0A@mail.gmail.com>
In-Reply-To: <CANn89iKXTbDJ594KN5K8u4eowpTWKdxXJ4hBQOqkuiZGcS7x0A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Apr 2022 19:26:07 -0700
Message-ID: <CANn89iK5Jxpc6TCqa-KE_0UjjfXspCQgdLTEhrkkE9+tp+U9pg@mail.gmail.com>
Subject: Re: [PATCHSET 0/4] Add support for no-lock sockets
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, io-uring@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 12, 2022 at 7:19 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Apr 12, 2022 at 7:12 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 4/12/22 8:05 PM, Eric Dumazet wrote:
> > > On Tue, Apr 12, 2022 at 7:01 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>
> > >> On 4/12/22 7:54 PM, Eric Dumazet wrote:
> > >>> On Tue, Apr 12, 2022 at 6:26 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>>>
> > >>>> On 4/12/22 6:40 PM, Eric Dumazet wrote:
> > >>>>>
> > >>>>> On 4/12/22 13:26, Jens Axboe wrote:
> > >>>>>> Hi,
> > >>>>>>
> > >>>>>> If we accept a connection directly, eg without installing a file
> > >>>>>> descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
> > >>>>>> we have a socket for recv/send that we can fully serialize access to.
> > >>>>>>
> > >>>>>> With that in mind, we can feasibly skip locking on the socket for TCP
> > >>>>>> in that case. Some of the testing I've done has shown as much as 15%
> > >>>>>> of overhead in the lock_sock/release_sock part, with this change then
> > >>>>>> we see none.
> > >>>>>>
> > >>>>>> Comments welcome!
> > >>>>>>
> > >>>>> How BH handlers (including TCP timers) and io_uring are going to run
> > >>>>> safely ? Even if a tcp socket had one user, (private fd opened by a
> > >>>>> non multi-threaded program), we would still to use the spinlock.
> > >>>>
> > >>>> But we don't even hold the spinlock over lock_sock() and release_sock(),
> > >>>> just the mutex. And we do check for running eg the backlog on release,
> > >>>> which I believe is done safely and similarly in other places too.
> > >>>
> > >>> So lets say TCP stack receives a packet in BH handler... it proceeds
> > >>> using many tcp sock fields.
> > >>>
> > >>> Then io_uring wants to read/write stuff from another cpu, while BH
> > >>> handler(s) is(are) not done yet,
> > >>> and will happily read/change many of the same fields
> > >>
> > >> But how is that currently protected?
> > >
> > > It is protected by current code.
> > >
> > > What you wrote would break TCP stack quite badly.
> >
> > No offense, but your explanations are severely lacking. By "current
> > code"? So what you're saying is that it's protected by how the code
> > currently works? From how that it currently is? Yeah, that surely
> > explains it.
> >
> > > I suggest you setup/run a syzbot server/farm, then you will have a
> > > hundred reports quite easily.
> >
> > Nowhere am I claiming this is currently perfect, and it should have had
> > an RFC on it. Was hoping for some constructive criticism on how to move
> > this forward, as high frequency TCP currently _sucks_ in the stack.
> > Instead I get useless replies, not very encouraging.
> >
> > I've run this quite extensively on just basic send/receive over sockets,
> > so it's not like it hasn't been run at all. And it's been fine so far,
> > no ill effects observed. If we need to tighten down the locking, perhaps
> > a valid use would be to simply skip the mutex and retain the bh lock for
> > setting owner. As far as I can tell, should still be safe to skip on
> > release, except if we need to process the backlog. And it'd serialize
> > the owner setting with the BH, which seems to be your main objection in.
> > Mostly guessing here, based on the in-depth replies.
> >
> > But it'd be nice if we could have a more constructive dialogue about
> > this, rather than the weird dismisiveness.
> >
> >
>
> Sure. It would be nice that I have not received such a patch series
> the day I am sick.
>
> Jakub, David, Paolo, please provide details to Jens, thanks.

FYI, include/net/sock.h has this comment, which has been served for
20+ years just fine.

/* Used by processes to "lock" a socket state, so that
 * interrupts and bottom half handlers won't change it
 * from under us. It essentially blocks any incoming
 * packets, so that we won't get any new data or any
 * packets that change the state of the socket.
 *
 * While locked, BH processing will add new packets to
 * the backlog queue.  This queue is processed by the
 * owner of the socket lock right before it is released.
 *
 * Since ~2.3.5 it is also exclusive sleep lock serializing
 * accesses from user process context.
 */
