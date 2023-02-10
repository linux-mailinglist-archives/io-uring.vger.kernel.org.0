Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EC76923AD
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 17:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbjBJQwa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 11:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbjBJQw2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 11:52:28 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDF1795D4
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 08:52:24 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso8985652pju.0
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 08:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c3KFR26HudIJ2YpWCveZm1/MGDe/z+10XXbKvDgndQ8=;
        b=CL0q7yxzqflzYPc92vRlz8DHpj/o7gGpLbD7YW4NH7SWa4LiY795ND9rBTy7bLl11o
         LyP0sTTtDFu8zvoLgVdvp3FijpkeHM742FqtiatA1gyeW7Oo8yk6iJ4K8eBdghQMhCvZ
         0eGHOcrlRSF8V9FcLGa/mdVGvikeHUa954Ctap3k4mHO1wQDOlFuyEjja9Iyb0bzD/Sy
         yfgDs+W6eq2lWBx0Pr9ZSz8Patm2GxVeWE1Xo7jyJrXMNBuuVWTldkLZJ6vQ0aJRfwv/
         06Es0QTquhrJmxEDRBVm8pO7K0du8PIwW5DaeMNRJ7WOfZKTD5yf/sqqmimk1C6Pt16k
         yMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c3KFR26HudIJ2YpWCveZm1/MGDe/z+10XXbKvDgndQ8=;
        b=40aDWVz+cJKkAJr5dZuXq2zZZwiLY+deJsjnAD0PIbRPWapNS0BkOYUYSEDessAunb
         ML70EnOZeNIwNHG+IrfnpvS7jWkqXlIVTavigdAgPiUon+BvmTpMh4wVZQMY9eGobVYa
         dWkhXMrWR+soeLCmnTEBS/tDHHb8p9LA//w9tlWqsRKHuQ29QVvkZWRcEc4PZtj1ZNko
         FF3rQDgbsoeFk8dVbHQ+WFnt8l+tAR04gbFFw1boqTKg1hguYudC0plR6iM7JTPDn7fv
         sYyLem0/tlQTU49X6x46r6bKRHvD59n5qNh+r4KC1w++9Z3MxjTqt4xbcHwGZEnSuvTE
         lgsQ==
X-Gm-Message-State: AO0yUKXhfY4oYpUrt4P/vxzYPbD4u8neRg3qEUAsMl+2wgZhjzmWTrU1
        Ja3KwD8+GO7cLTZe2WXsGAINhXWnbxT5Yb7bIasRoA0MO5KV
X-Google-Smtp-Source: AK7set/8twp6uj1E3lC55r9PaCueZJb09kIykX0QbYJbI2a/cJy1KEPxhQNR3RdsvwWOxHKAZdP7qH4UfX5EtM2ndHY=
X-Received: by 2002:a17:90a:8c0a:b0:230:950f:5766 with SMTP id
 a10-20020a17090a8c0a00b00230950f5766mr2576852pjo.123.1676047943440; Fri, 10
 Feb 2023 08:52:23 -0800 (PST)
MIME-Version: 1.0
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca> <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
 <13293926.uLZWGnKmhe@x2> <6939adfb-ce2c-1911-19ee-af32f7d9a5ca@kernel.dk>
 <CAHC9VhTGmGJ81M2CZWsTf1kNf8XNz2WsYFAP=5VAVSUfUiu1yQ@mail.gmail.com> <56ef99e4-f9de-0634-ce53-3bc2f1fa6665@kernel.dk>
In-Reply-To: <56ef99e4-f9de-0634-ce53-3bc2f1fa6665@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 10 Feb 2023 11:52:12 -0500
Message-ID: <CAHC9VhSgSREUDzJfDq9H_VAbyCZBYakhE19OiUB19QCeEM3q2A@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 10, 2023 at 11:00 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/10/23 8:39?AM, Paul Moore wrote:
> > On Thu, Feb 9, 2023 at 7:15 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 2/9/23 3:54?PM, Steve Grubb wrote:
> >>> On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
> >>>> On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >>>>> On 2023-02-01 16:18, Paul Moore wrote:
> >>>>>> On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com>
> >>> wrote:
> >>>>>>> fadvise and madvise both provide hints for caching or access pattern
> >>>>>>> for file and memory respectively.  Skip them.
> >>>>>>
> >>>>>> You forgot to update the first sentence in the commit description :/
> >>>>>
> >>>>> I didn't forget.  I updated that sentence to reflect the fact that the
> >>>>> two should be treated similarly rather than differently.
> >>>>
> >>>> Ooookay.  Can we at least agree that the commit description should be
> >>>> rephrased to make it clear that the patch only adjusts madvise?  Right
> >>>> now I read the commit description and it sounds like you are adjusting
> >>>> the behavior for both fadvise and madvise in this patch, which is not
> >>>> true.
> >>>>
> >>>>>> I'm still looking for some type of statement that you've done some
> >>>>>> homework on the IORING_OP_MADVISE case to ensure that it doesn't end
> >>>>>> up calling into the LSM, see my previous emails on this.  I need more
> >>>>>> than "Steve told me to do this".
> >>>>>>
> >>>>>> I basically just want to see that some care and thought has gone into
> >>>>>> this patch to verify it is correct and good.
> >>>>>
> >>>>> Steve suggested I look into a number of iouring ops.  I looked at the
> >>>>> description code and agreed that it wasn't necessary to audit madvise.
> >>>>> The rationale for fadvise was detemined to have been conflated with
> >>>>> fallocate and subsequently dropped.  Steve also suggested a number of
> >>>>> others and after investigation I decided that their current state was
> >>>>> correct.  *getxattr you've advised against, so it was dropped.  It
> >>>>> appears fewer modifications were necessary than originally suspected.
> >>>>
> >>>> My concern is that three of the four changes you initially proposed
> >>>> were rejected, which gives me pause about the fourth.  You mention
> >>>> that based on your reading of madvise's description you feel auditing
> >>>> isn't necessary - and you may be right - but based on our experience
> >>>> so far with this patchset I would like to hear that you have properly
> >>>> investigated all of the madvise code paths, and I would like that in
> >>>> the commit description.
> >>>
> >>> I think you're being unnecessarily hard on this. Yes, the commit message
> >>> might be touched up. But madvise is advisory in nature. It is not security
> >>> relevant. And a grep through the security directory doesn't turn up any
> >>> hooks.
> >>
> >> Agree, it's getting a bit anal... FWIW, patch looks fine to me.
> >
> > Call it whatever you want, but the details are often important at this
> > level of code, and when I see a patch author pushing back on verifying
> > that their patch is correct it makes me very skeptical.
>
> Maybe it isn't intended, but the replies have generally had a pretty
> condescending tone to them. That's not the best way to engage folks, and
> may very well be why people just kind of give up on it. Nobody likes
> debating one-liners forever, particularly not if it isn't inviting.

I appreciate that you are coming from a different space, but I stand
by my comments.  Of course you are welcome to your own opinion, but I
would encourage you to spend some time reading the audit mail archives
going back a few years before you make comments like the above ... or
not, that's your call; I recognize it is usually easier to criticize.

On a quasi related note to the list/archives: unfortunately there was
continued resistance to opening up the linux-audit list so I've setup
audit@vger for upstream audit kernel work moving forward.  The list
address in MAINTAINERS will get updated during the next merge window
so hopefully some of the problems you had in the beginning of this
discussion will be better in the future.

> > I really would have preferred that you held off from merging this
> > until this was resolved and ACK'd ... oh well.
>
> It's still top of tree. If you want to ack it, let me know and I'll add
> it. If you want to nak it, give me something concrete to work off of.

I can't in good conscience ACK it without some comment from Richard
that he has traced the code paths; this shouldn't be surprising at
this point.  I'm not going to NACK it or post a revert, I would have
done that already if I felt that was appropriate.  Right now this
patch is in a gray area for me in that I suspect it is good, but I
can't ACK it without some comment that it has been properly
researched.

-- 
paul-moore.com
