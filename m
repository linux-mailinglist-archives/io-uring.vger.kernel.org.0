Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751963D0D44
	for <lists+io-uring@lfdr.de>; Wed, 21 Jul 2021 13:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhGUKds (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jul 2021 06:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbhGUJWT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jul 2021 05:22:19 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E466BC061762;
        Wed, 21 Jul 2021 03:02:48 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id i18so2465622yba.13;
        Wed, 21 Jul 2021 03:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xkMJBLZN9fy/5kAuqvFzH7GQg2psPTM32F6Q49lpB24=;
        b=Djs21qto2cvBWrKYwUeg1m2mPBsRKck0mfPwm1L7G6/YR3FMNdAzTo5iYPpk7QUAci
         nLBm78dpVqbK0ebX0lCrjj+HhZNqbDfoYePOYzOVANsFLYClpqHmEmMR26LzBnbMWrjl
         DEL3+qF28hAKPR0OpAXBJWjI773WLc5NDSH8twE4BbisUuZ6LFKWaSYIBZBUoIEe9YKN
         A0ToMREpKBflYlwvicryRBwJkNKbrNkjR0DzJxKiYcXodwmDzsBNC7vfBMISgcB1IjSa
         ErMSlP4zUV1+mamSvMm4HmA8K/hVzSUDMXEIhR0o3ppZjaEeaLWz31PiLprr3XlLqs55
         nEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xkMJBLZN9fy/5kAuqvFzH7GQg2psPTM32F6Q49lpB24=;
        b=ELL6ZTlmb7ncaYrHRk1bRexnT5QBAhdGsF8G7IgX07z+IjCIj/u3dfXTMn9fUs5/UB
         y4qL7mtRmx6pcNnEqzdFpwgr9PDMTdVJem+DUZRDzKOca/T8Sb5I2c3c9+MKp50ut6Xb
         DEzjp6Dx9a1mnuX1O3JtyqUUHOsFvPLyLLu+eEqlryPctU4KI9xKinGUah4rzkomom8F
         tb57kdZ374WKaz0n5z6vXB5H6cT1IdGEG1XJMmzckp47ultEKRzx+OnN1Us0vQK5BB/6
         /yQdDCZOEnGW7PPEADXul+teaon69tHSUL4aSU9Qo3oPC9UhagzW9YtFqCagSruJ2phf
         0uZQ==
X-Gm-Message-State: AOAM532WPxGUalEEfyukyENlrjJEImYQobA5c8t4/LmmiNpj4At6xXlG
        h4qRQ1Nl+/DAeeKUl62C4h9cidZYBrSkeBqOHA4=
X-Google-Smtp-Source: ABdhPJye24HWaB5wVPgUna1mBLCVEDqswvGWcQfriUcCBK0P4RmLYZ4vGxyS6wQzHbc4ASgoY235/d/yq/7yismTpu8=
X-Received: by 2002:a25:da11:: with SMTP id n17mr45066985ybf.428.1626861768164;
 Wed, 21 Jul 2021 03:02:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210715103600.3570667-1-dkadashev@gmail.com> <20210715103600.3570667-6-dkadashev@gmail.com>
 <YPCX5/0NtbEySW9q@zeniv-ca.linux.org.uk> <CAOKbgA79ODk_swv9nsU50ZrRe9Xqv3n9-JOH+H0zyhUF2SYcRw@mail.gmail.com>
 <YPbV5wnUNw3SsSfI@zeniv-ca.linux.org.uk>
In-Reply-To: <YPbV5wnUNw3SsSfI@zeniv-ca.linux.org.uk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 21 Jul 2021 17:02:37 +0700
Message-ID: <CAOKbgA6JAGioiqMu1CQbTe-Wpb2_HDszRaz+rf=qna-oieF75A@mail.gmail.com>
Subject: Re: [PATCH 05/14] namei: prepare do_mkdirat for refactoring
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

.On Tue, Jul 20, 2021 at 8:58 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Tue, Jul 20, 2021 at 01:59:29PM +0700, Dmitry Kadashev wrote:
>
> > > This is the wrong way to go.  Really.  Look at it that way - LOOKUP_REVAL
> > > is the final stage of escalation; if we had to go there, there's no
> > > point being optimistic about the last dcache lookup, nevermind trying
> > > to retry the parent pathwalk if we fail with -ESTALE doing it.
> > >
> > > I'm not saying that it's something worth optimizing for; the problem
> > > is different - the logics makes no sense whatsoever that way.  It's
> > > a matter of reader's cycles wasted on "what the fuck are we trying
> > > to do here?", not the CPU cycles wasted on execution.
> > >
> > > While we are at it, it makes no sense for filename_parentat() and its
> > > ilk to go for RCU and normal if it's been given LOOKUP_REVAL - I mean,
> > > look at the sequence of calls in there.  And try to make sense of
> > > it.  Especially of the "OK, RCU attempt told us to sod off and try normal;
> > > here, let's call path_parentat() with LOOKUP_REVAL for flags and if it
> > > says -ESTALE, call it again with exact same arguments" part.
> > >
> > > Seriously, look at that from the point of view of somebody who tries
> > > to make sense of the entire thing
> >
> > OK, let me try to venture down that "change the way ESTALE retries are
> > done completely" path. The problem here is I'm not familiar with the
> > code enough to be sure the conversion is 1-to-1 (i.e. that we can't get
> > ESTALE from somewhere unexpected), and that retries are open-coded in
> > quite a few places it seems. Anyway, I'll try and dig in and come back
> > with either an RFC patch or some questions. Thanks for the feedback, Al.
>
> I'd try to look at the primitives that go through RCU/normal/REVAL series.
> They are all in fs/namei.c; filename_lookup(), filename_parentat(),
> do_filp_open() and do_filo_open_root().  The latter pair almost certainly
> is fine as-is.
>
> retry_estale() crap is limited to user_path_at/user_path_at_empty users,
> along with some filename_parentat() ones.
>
> There we follow that series with something that might give us ESTALE,
> and if it does, we want to repeat the whole thing in REVAL mode.
>
> OTOH, there are callers (and fairly similar ones, at that - look at e.g.
> AF_UNIX bind doing mknod) where we don't have that kind of logics.
>
> Question 1: which of those are lacking retry_estale(), even though they
> might arguably need it?  Note that e.g. AF_UNIX bind uses kern_path_create(),
> so we need to look at all callchains leading to those, not just the ones
> in fs/namei.c guts.
>
> If most of those really want retry_estale, we'd be better off if we took
> the REVAL fallback out of filename_lookup() and filename_parentat()
> and turned massaged the users from
>         do rcu/normal/reval lookups
>         if failed, fuck off
>         do other work
>         if it fails with ESTALE
>                 do rcu/reval/reval (yes, really)
>                 if failed, fuck off
>                 do other work
> into
>         do rcu/normal lookups
>         if not failed
>                 do other work
>         if something (including initial lookup) failed with ESTALE
>                 repeat the entire thing with LOOKUP_REVAL in the mix
> possibly with a helper function involved.
> For the ones that need retry_estale that's a win; for the rest it'd
> be boilerplate (that's basically the ones where "do other work" never
> fails with ESTALE).
>
> Question 2: how are "need retry_estale"/"fine just with ESTALE fallback
> in filename_{lookup,parentat}()" cases are distributed?
>
> If the majority is in "need retry_estale" class, then something similar
> to what's been outlined above would probably be a decent solution.
>
> Otherwise we'll need wrappers equivalent to current behaviour, and that's
> where it can get unpleasant - at which level in call chain do we put
> that wrapper?  Sure, we can add filename_lookup_as_it_fucking_used_to_be().
> Except that it's not called directly by those "don't need retry_estale"
> users, so we'd need to provide such counterparts for them as well ;-/
>
> IOW, we need the call tree for filename_lookup()/filename_parentat(),
> with leaves (originators of call chain) marked with "does that user
> do retry_estale?" (and tracked far back for the answer to depend only
> upon the call site - if an intermediate can come from both kinds
> of places, we need to track back to its callers).
>
> Then we'll be able to see at which levels do we want those "as it used
> to behave" wrappers...
>
> If you want to dig around, that would probably be a reasonable place to
> start.

Thanks for the pointers! I am happy to dig into this. I can't spend much
time per week on this though, so it will take some time.

-- 
Dmitry Kadashev
