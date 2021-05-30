Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86B63951B3
	for <lists+io-uring@lfdr.de>; Sun, 30 May 2021 17:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhE3P2Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 May 2021 11:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhE3P2Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 May 2021 11:28:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF66C061574
        for <io-uring@vger.kernel.org>; Sun, 30 May 2021 08:26:37 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l3so12764403ejc.4
        for <io-uring@vger.kernel.org>; Sun, 30 May 2021 08:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e83Xdcrb8ArQTK3BfJ+SKjS0Z61QsbiftdtWKkLx9t0=;
        b=xxmRfSdqR7k/5JUg2bVa/HZl4RASa24Zfj1QgGechwXgZHEtHOd0ktJScwP5bQimAm
         XUYqJtP0hDxk+ZXVnZR4aY1OyjeHBf+veNfgXsQ3vgLWtPekUJL/BZGg3oI1MAThdQTI
         VDjF7lyY0rwv9afdqBsYU7gAlRJxy5AFHgVvegxl82XdF/HwAEB3uDOjThe/mpZ0IHtx
         gvJWtS2SmUqSAW4v401VZRgrbfAl79crzB3oMHe0uRFOXkOawtpQXplEsxlMa4gTfuN9
         zX3d54/1D/AucoBl0RsmoItn6LRW7Syu3nCvuZzyeFkQTxMQH7XvVVLZiF6lCoDV8xyt
         7KBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e83Xdcrb8ArQTK3BfJ+SKjS0Z61QsbiftdtWKkLx9t0=;
        b=gbPI4Q9E1KPkYQ4JHS8HkKGndSF/leWHj28lKVzno2hbesNNQPFZqKqr5KICdmnAgn
         3I+yS3XJsu6YJFDJW5m9s9r3zmGOfJNZHhuPBNZCXjomvM2iySIQmqEK1qjm888XhgAn
         Xj6l1m5A3b35dA5FO5Hva8xSxBaPu4b6kF/y0A1Dz89mX2qplIcNmSjokvmUQsoZ92m9
         v16+1QVnQz3m/67nX4B3ljFx8QrCvHO2acgnafznvQxJPcR1/UyNS6DOlFUfLJjkfx2l
         9wSopmUINzEUUs8FviRBpjMXuRSQoitPyGVTXJg7oAPGwXGo/gt0hcxmXQFJLEGz2Sf0
         73Pg==
X-Gm-Message-State: AOAM531Qc+SWOmt9ljNkwFW0JFqGyxJcnNY338HziKqpkaBVF2f38EDi
        uVktvIqf3m2j1svlMSfGV2A17Y0QxNzTcSbfjQAdjwmXDw==
X-Google-Smtp-Source: ABdhPJwPsCNauSlDJZZCjOpy5U50sK0NxibF5HbYEJWlsb/BX8Aa7YBzBA+a2fJHbO4WCKa8o/7Q2nAhnogkBmdUNtg=
X-Received: by 2002:a17:906:4111:: with SMTP id j17mr9037573ejk.488.1622388396174;
 Sun, 30 May 2021 08:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163380685.8379.17381053199011043757.stgit@sifl> <20210528223544.GL447005@madcap2.tricolour.ca>
In-Reply-To: <20210528223544.GL447005@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 30 May 2021 11:26:25 -0400
Message-ID: <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/9] audit: add filtering for io_uring records
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 28, 2021 at 6:36 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2021-05-21 17:50, Paul Moore wrote:
> > WARNING - This is a work in progress and should not be merged
> > anywhere important.  It is almost surely not complete, and while it
> > probably compiles it likely hasn't been booted and will do terrible
> > things.  You have been warned.
> >
> > This patch adds basic audit io_uring filtering, using as much of the
> > existing audit filtering infrastructure as possible.  In order to do
> > this we reuse the audit filter rule's syscall mask for the io_uring
> > operation and we create a new filter for io_uring operations as
> > AUDIT_FILTER_URING_EXIT/audit_filter_list[7].
> >
> > <TODO - provide some additional guidance for the userspace tools>
> >
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > ---
> >  include/uapi/linux/audit.h |    3 +-
> >  kernel/auditfilter.c       |    4 ++-
> >  kernel/auditsc.c           |   65 ++++++++++++++++++++++++++++++++++----------
> >  3 files changed, 55 insertions(+), 17 deletions(-)

...

> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index d8aa2c690bf9..4f6ab34020fb 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -799,6 +799,35 @@ static int audit_in_mask(const struct audit_krule *rule, unsigned long val)
> >       return rule->mask[word] & bit;
> >  }
> >
> > +/**
> > + * audit_filter_uring - apply filters to an io_uring operation
> > + * @tsk: associated task
> > + * @ctx: audit context
> > + */
> > +static void audit_filter_uring(struct task_struct *tsk,
> > +                            struct audit_context *ctx)
> > +{
> > +     struct audit_entry *e;
> > +     enum audit_state state;
> > +
> > +     if (auditd_test_task(tsk))
> > +             return;
>
> Is this necessary?  auditd and auditctl don't (intentionally) use any
> io_uring functionality.  Is it possible it might inadvertantly use some
> by virtue of libc or other library calls now or in the future?

I think the better question is what harm does it do?  Yes, I'm not
aware of an auditd implementation that currently makes use of
io_uring, but it is also not inconceivable some future implementation
might want to make use of it and given the disjoint nature of kernel
and userspace development I don't want the kernel to block such
developments.  However, if you can think of a reason why having this
check here is bad I'm listening (note: we are already in the slow path
here so having the additional check isn't an issue as far as I'm
concerned).

As a reminder, auditd_test_task() only returns true/1 if the task is
registered with the audit subsystem as an auditd connection, an
auditctl process should not cause this function to return true.

> > +     rcu_read_lock();
> > +     list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_URING_EXIT],
> > +                             list) {
> > +             if (audit_in_mask(&e->rule, ctx->uring_op) &&
>
> While this seems like the most obvious approach given the parallels
> between syscalls and io_uring operations, as coded here it won't work
> due to the different mappings of syscall numbers and io_uring
> operations unless we re-use the auditctl -S field with raw io_uring
> operation numbers in the place of syscall numbers.  This should have
> been obvious to me when I first looked at this patch.  It became obvious
> when I started looking at the userspace auditctl.c.

FWIW, my intention was to treat io_uring opcodes exactly like we treat
syscall numbers.  Yes, this would potentially be an issue if we wanted
to combine syscalls and io_uring opcodes into one filter, but why
would we ever want to do that?  Combining the two into one filter not
only makes the filter lists longer than needed (we will always know if
we are filtering on a syscall or io_uring op) and complicates the
filter rule processing.

Or is there a problem with this that I'm missing?

> The easy first step would be to use something like this:
>         auditctl -a uring,always -S 18,28 -F key=uring_open
> to monitor file open commands only.  The same is not yet possible for
> the perm field, but there are so few io_uring ops at this point compared
> with syscalls that it might be manageable.  The arch is irrelevant since
> io_uring operation numbers are identical across all hardware as far as I
> can tell.  Most of the rest of the fields should make sense if they do
> for a syscall rule.

I've never been a fan of audit's "perm" filtering; I've always felt
there were better ways to handle that so I'm not overly upset that we
are skipping that functionality with this initial support.  If it
becomes a problem in the future we can always add that support at a
later date.

I currently fear that just getting io_uring and audit to coexist is
going to be a large enough problem in the immediate future.

> Here's a sample of userspace code to support this
> patch:
>         https://github.com/rgbriggs/audit-userspace/commit/a77baa1651b7ad841a220eb962d4cc92bc07dc96
>         https://github.com/linux-audit/audit-userspace/compare/master...rgbriggs:ghau-iouring-filtering.v1.0

Great, thank you.  I haven't grabbed a copy yet for testing, but I will.

> If we abuse the syscall infrastructure at first, we'd need a transition
> plan to coordinate user and kernel switchover to seperate mechanisms for
> the two to work together if the need should arise to have both syscall
> and uring filters in the same rule.

See my comments above, I don't currently see why we would ever want
syscall and io_uring filtering to happen in the same rule.  Please
speak up if you can think of a reason why this would either be needed,
or desirable for some reason.

> It might be wise to deliberately not support auditctl "-w" (and the
> exported audit_add_watch() function) since that is currently hardcoded
> to the AUDIT_FILTER_EXIT list and is the old watch form [replaced by
> audit_rule_fieldpair_data()] anyways that is more likely to be
> deprecated.  It also appears to make sense not to support autrace (at
> least initially).

I'm going to be honest with you and simply say that I've run out of my
email/review time in front of the computer on this holiday weekend
(blame the lockdown/bpf/lsm discussion <g>) and I need to go for
today, but this is something I'll take a look it this coming week.
Hopefully the comments above give us something to think/talk about in
the meantime.

Regardless, thanks for your help on the userspace side of the
filtering, that should make testing a lot easier moving forward.

--
paul moore
www.paul-moore.com
