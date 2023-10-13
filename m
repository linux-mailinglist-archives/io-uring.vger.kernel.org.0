Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B2F7C8BB3
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 18:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjJMQik (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 12:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjJMQih (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 12:38:37 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0E5BB
        for <io-uring@vger.kernel.org>; Fri, 13 Oct 2023 09:38:35 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-d9ad90e1038so1940443276.3
        for <io-uring@vger.kernel.org>; Fri, 13 Oct 2023 09:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1697215114; x=1697819914; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=85tz8MZnQIy0CUyHXD4OwO6hFEU+0OOkrrzLhDAPynw=;
        b=Q90R7Tdrw7oRx2g7QAuiOQfZ0moqLRi0ko1qyZhnLu68DdroxUEZIZKnYfrcTlEKHZ
         F2o9IHgWzk8aHLHfIF14T7v2rkjG2OaTJntJhFE020tmKlxjtdvweSw81h/GmEDVdT9A
         obdHXgUydPNnob+3r8KdEv1ojDVBnCdthXzgdmq56O3rNndoRI6ecYVSF13Q5/GpIJAG
         1PGe5u0iFbpoIMhdrS5/6EYJOBP4xVIj6gT6rMzbL535Bqnu3JiRuURSrChrMOZkF1HY
         J7lJIBRJCJsY8ji8W3H64++Bt/h22HUxEe9ijrUNRiqs5KdQxqiKKlyVD4AUGDpkk5T7
         c1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697215114; x=1697819914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=85tz8MZnQIy0CUyHXD4OwO6hFEU+0OOkrrzLhDAPynw=;
        b=pOaBSCqYPujajwG2oyyJIz2ep9ayVdX3c85S/rp8tCnr0AhwOALFjB4UWaKI3MQthT
         f+mPglUylZryuJIzJgjx8xFu8fIaCE7//6BahYStCLq6x2LFwiytprR2iSWnVfCpvexM
         B+8kft5/KO/3cXI7G759wUyOnOBqdyr09kZBp4/Yvl2cEGm2RA6q8nlmzIvonbegdnGu
         2vM7sy88ONi5KXdIG6lgTR8KrxBicZTByqihy+FY0gwSWKjZQp36+XmYFmzV/o69sdw7
         9hPx0R6fwxdzgCT+dKkSzHe4FxDqWPHmOpOy+r5dgD5vJ/wrgEtuKw55HcCJGU9C92Ph
         SX9Q==
X-Gm-Message-State: AOJu0YzdtyhZOUksQtP1uKMJq/L//KsI5imvvmDqJlSi4I9roe13KnBT
        08xLZ+dgGidtzdxKD1mtcOx57bUXWIQfhP0Bdzzx
X-Google-Smtp-Source: AGHT+IEIaSBfASZ5Mn1dNgyH878ixt7Ja/xhQg8a+sIaxL+NLRUpQv75KfQ3z3OfydJhIWt+cgU+2xUOjDRn5uIOySM=
X-Received: by 2002:a25:8f8c:0:b0:d89:f292:6e80 with SMTP id
 u12-20020a258f8c000000b00d89f2926e80mr26964031ybl.35.1697215114724; Fri, 13
 Oct 2023 09:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20231013-karierte-mehrzahl-6a938035609e@brauner> <CAHC9VhTQFyyE59A3WG3Z0xkP6m31h1M0bvS=yihE7ukpUiDMug@mail.gmail.com>
 <20231013-hakte-sitzt-853957a5d8da@brauner>
In-Reply-To: <20231013-hakte-sitzt-853957a5d8da@brauner>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 13 Oct 2023 12:38:24 -0400
Message-ID: <CAHC9VhQ2hX8QvQagt+J7V2OBtiSXctufVcVj0fi1bQEsduWD4Q@mail.gmail.com>
Subject: Re: [PATCH] audit,io_uring: io_uring openat triggers audit reference
 count underflow
To:     Christian Brauner <brauner@kernel.org>
Cc:     Dan Clash <daclash@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, dan.clash@microsoft.com,
        audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 13, 2023 at 12:22=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Fri, Oct 13, 2023 at 11:56:08AM -0400, Paul Moore wrote:
> > On Fri, Oct 13, 2023 at 11:44=E2=80=AFAM Christian Brauner <brauner@ker=
nel.org> wrote:
> > >
> > > On Thu, 12 Oct 2023 14:55:18 -0700, Dan Clash wrote:
> > > > An io_uring openat operation can update an audit reference count
> > > > from multiple threads resulting in the call trace below.
> > > >
> > > > A call to io_uring_submit() with a single openat op with a flag of
> > > > IOSQE_ASYNC results in the following reference count updates.
> > > >
> > > > These first part of the system call performs two increments that do=
 not race.
> > > >
> > > > [...]
> > >
> > > Picking this up as is. Let me know if this needs another tree.
> >
> > Whoa.  A couple of things:
> >
> > * Please don't merge patches into an upstream tree if all of the
> > affected subsystems haven't ACK'd the patch.  I know you've got your
> > boilerplate below about ACKs *after* the merge, which is fine, but I
> > find it breaks decorum a bit to merge patches without an explicit ACK
> > or even just a "looks good to me" from all of the relevant subsystems.
>
> I simply read your mail:
>
> X-Date: Fri, 13 Oct 2023 17:43:54 +0200
> X-URI: https://lore.kernel.org/lkml/CAHC9VhQcSY9q=3DwVT7hOz9y=3Do3a67BVUn=
VGNotgAvE6vK7WAkBw@mail.gmail.com
>
> "I'm not too concerned, either approach works for me, the important bit
>  is moving to an atomic_t/refcount_t so we can protect ourselves
>  against the race.  The patch looks good to me and I'd like to get this
>  fix merged."
>
> including that "The patch looks good to me [...]" part before I sent out
> the application message:

Some of this is likely due to email races, or far faster than normal
responses.  When I was writing the email you reference above ("This
patch looks good to me...") the last email I had from you was asking
for changes to the patch; since you were suggesting a change I made
the assumption (which arguably one shouldn't assume things) that you
were not planning to merge the patch.

> X-Date: Fri, 13 Oct 2023 17:44:36 +0200
> X-URI: https://lore.kernel.org/lkml/20231013-karierte-mehrzahl-6a93803560=
9e@brauner
>
> > Regardless, as I mentioned in my last email (I think our last emails
> > raced a bit), I'm okay with this change, please add my ACK.
>
> It's before the weekend and we're about to release -rc6. This thing
> needs to be in -next, you said it looks good to you in a prior mail. I'm
> not sure why I'm receiving this mail apart from the justified
> clarification about -stable although that was made explicit in your
> prior mail as well.

I hope I explained the intent in my last email a bit more clearly with
the explanation above.  Regardless, I think the lessons to be learned
is that I won't assume that your suggestion of changes and merging a
patch are mutually exclusive, and just to be on the safe side I would
ask that you not merge audit, LSM, or SELinux related patches without
an explicit ACK from those subsystems.  Hopefully that should prevent
things like this from happening again.

--=20
paul-moore.com
