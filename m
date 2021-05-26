Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F339391A75
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 16:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhEZOkX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 10:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhEZOkX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 10:40:23 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C57C061574
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 07:38:50 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h16so1815271edr.6
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 07:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4yBeE8Xf/Fq4mUnYlQxVkTLJf9hFbr354bGFzsYff5g=;
        b=KRb/fDBwvStL03k+AAEmiYnoGtcxdl9dufQv95dxD+SuWfTPDmAckSDeo2MGp4JzUH
         1IxuNTA54tAPzBRIokqrzVDp97pAB50mWb1jNIFB5ajrywwV4ocx0TrcUSmo1cPqmFDV
         pIpfj6KFIECI1Ya2pMUsTdt07DMiX7ZckQivfLujScCV3qA94hJTsKpT0TeR3DGJJm4M
         xprhjnIAPpYABCLf0xik2kTgqz6lMUlKBRA57MlF3voJX7+nPym+k7INHDahRSS0fpIG
         TzlK1HjBygUv/LI9j6nAnvyu1QKSpPV9xY8Nw6YMOTqX3r5dKgIf3WsjhRCxsegio+C7
         +O7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4yBeE8Xf/Fq4mUnYlQxVkTLJf9hFbr354bGFzsYff5g=;
        b=KqStBW7MPD1We5Ps3+nPryzAPE++qOxaf3b1/q+vX3k2DkYhJF6hmZsPSKQTtCFvQ7
         coX6Y8o71cAm8wqsoppqf4Cr+kh2Cum7CHszDySiyCaiPW0Hqhh2/QBiZNOFmm9tLW5X
         6wTkUtywC04mhknmOWJu+uPTbs/lMNWznJbFk4V8mgJv9D3HEh58OpfnIfTM//WqfYKL
         7bVhD6Qd6HxOrM1pUm2s9or95MSvhyIZF2EJqbWhw+OrEwVY/rLFMyXkeYnikfUTY5Hs
         4rCEqetIBKpJTdSTTYbbTIsmFWGapcn33pP2gzAXvhdsN110lEIj8+MhUncChAoAU5mw
         c5Gw==
X-Gm-Message-State: AOAM531QJtw6YFq915/rr1s6CicPR9Lpf5k0r6L19HMcaVXcnvGOCLDG
        32Cahoh67FNt+bLgDFEOZf6CkvBmn68B4aNczqfi
X-Google-Smtp-Source: ABdhPJzYmCCVE+5LIwHiiKYytbKEjjju7Fqmoh+e+Ii4nBCArjGV+iGuobXs1xR1zjMey8kMg7YjXMHDgqh8jPFVbhw=
X-Received: by 2002:aa7:c7cd:: with SMTP id o13mr15720410eds.269.1622039929256;
 Wed, 26 May 2021 07:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com> <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk> <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com>
In-Reply-To: <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 26 May 2021 10:38:38 -0400
Message-ID: <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 26, 2021 at 6:19 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> On 5/26/21 3:04 AM, Paul Moore wrote:
> > On Tue, May 25, 2021 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 5/24/21 1:59 PM, Paul Moore wrote:
> >>> That said, audit is not for everyone, and we have build time and
> >>> runtime options to help make life easier.  Beyond simply disabling
> >>> audit at compile time a number of Linux distributions effectively
> >>> shortcut audit at runtime by adding a "never" rule to the audit
> >>> filter, for example:
> >>>
> >>>  % auditctl -a task,never
> >>
> >> As has been brought up, the issue we're facing is that distros have
> >> CONFIG_AUDIT=y and hence the above is the best real world case outside
> >> of people doing custom kernels. My question would then be how much
> >> overhead the above will add, considering it's an entry/exit call per op.
> >> If auditctl is turned off, what is the expectation in turns of overhead?
> >
> > I commented on that case in my last email to Pavel, but I'll try to go
> > over it again in a little more detail.
> >
> > As we discussed earlier in this thread, we can skip the req->opcode
> > check before both the _entry and _exit calls, so we are left with just
> > the bare audit calls in the io_uring code.  As the _entry and _exit
> > functions are small, I've copied them and their supporting functions
> > below and I'll try to explain what would happen in CONFIG_AUDIT=y,
> > "task,never" case.
> >
> > +  static inline struct audit_context *audit_context(void)
> > +  {
> > +    return current->audit_context;
> > +  }
> >
> > +  static inline bool audit_dummy_context(void)
> > +  {
> > +    void *p = audit_context();
> > +    return !p || *(int *)p;
> > +  }
> >
> > +  static inline void audit_uring_entry(u8 op)
> > +  {
> > +    if (unlikely(audit_enabled && audit_context()))
> > +      __audit_uring_entry(op);
> > +  }
>
> I'd rather agree that it's my cycle-picking. The case I care about
> is CONFIG_AUDIT=y (because everybody enable it), and io_uring
> tracing _not_ enabled at runtime. If enabled let them suffer
> the overhead, it will probably dip down the performance
>
> So, for the case I care about it's two of
>
> if (unlikely(audit_enabled && current->audit_context))
>
> in the hot path. load-test-jump + current, so it will
> be around 7x2 instructions. We can throw away audit_enabled
> as you say systemd already enables it, that will give
> 4x2 instructions including 2 conditional jumps.

We've basically got it down to the equivalent of two
"current->audit_context != NULL" checks in the case where audit is
built into the kernel but disabled at runtime, e.g. CONFIG_AUDIT=y and
"task,never".  I'm at a loss for how we can lower the overhead any
further, but I'm open to suggestions.

> That's not great at all. And that's why I brought up
> the question about need of pre and post hooks and whether
> can be combined. Would be just 4 instructions and that is
> ok (ish).

As discussed previously in this thread that isn't really an option
from an audit perspective.

> > We would need to check with the current security requirements (there
> > are distro people on the linux-audit list that keep track of that
> > stuff), but looking at the opcodes right now my gut feeling is that
> > most of the opcodes would be considered "security relevant" so
> > selective auditing might not be that useful in practice.  It would
> > definitely clutter the code and increase the chances that new opcodes
> > would not be properly audited when they are merged.
>
> I'm curious, why it's enabled by many distros by default? Are there
> use cases they use?

We've already talked about certain users and environments where audit
is an important requirement, e.g. public sector, health care,
financial institutions, etc.; without audit Linux wouldn't be an
option for these users, at least not without heavy modification,
out-of-tree/ISV patches, etc.  I currently don't have any direct ties
to any distros, "Enterprise" or otherwise, but in the past it has been
my experience that distros much prefer to have a single kernel build
to address the needs of all their users.  In the few cases I have seen
where a second kernel build is supported it is usually for hardware
enablement.  I'm sure there are other cases too, I just haven't seen
them personally; the big distros definitely seem to have a strong
desire to limit the number of supported kernel configs/builds.

> Tempting to add AUDIT_IOURING=default N, but won't work I guess

One of the nice things about audit is that it can give you a history
of what a user did on a system, which is very important for a number
of use cases.  If we selectively disable audit for certain subsystems
we create a blind spot in the audit log, and in the case of io_uring
this can be a very serious blind spot.  I fear that if we can't come
to some agreement here we will need to make io_uring and audit
mutually exclusive at build time which would be awful; forcing many
distros to either make a hard choice or carry out-of-tree patches.

-- 
paul moore
www.paul-moore.com
