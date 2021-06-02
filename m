Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310A0397E2C
	for <lists+io-uring@lfdr.de>; Wed,  2 Jun 2021 03:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhFBBl7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 21:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhFBBl6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 21:41:58 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E27C06175F
        for <io-uring@vger.kernel.org>; Tue,  1 Jun 2021 18:40:15 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id jt22so1340699ejb.7
        for <io-uring@vger.kernel.org>; Tue, 01 Jun 2021 18:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7+6GengPTpnBNKRiprYjAxUmTuo80Mwv0XF47zfhAB0=;
        b=eHaMWPqA67Ms9cMf+MpCDlqXpy7gUU+QZLG79G7lMeuxyBVPP6W+UzN3hICWjKjiBJ
         44peCH0PgM1siFi8Gc4aqT8FiLU/ehdSIKr0nBCH1uOLEJoZzDBKL2/MsPttMhJSGqeL
         heKa7CKjkZvPwSBHdRp7V8pLoZ3NIKPFNnJLrybRmV83gMVHIMG9st6DySEqrhg+/2nr
         Nt1dcVVMckoCjW6RMFbLosyOhYo5n1uhlUEhS/qG6jVenahGHkyqBFBNFyuZH/lDrEXZ
         Ufysh0UsjrPKikT6wQB8O9OUwbdDrkFBQIdmhfg06tut+RW2/WDitMIf6tve/CvEgA2O
         1jbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7+6GengPTpnBNKRiprYjAxUmTuo80Mwv0XF47zfhAB0=;
        b=rz3sJsbjMYqw13Qw1kMDChIcDVGfehFhXrzSwvNsBP04JKTCKSKxKbzqSW3BToSPJa
         ESl5z12qhzsTMnnJx8W8V+4SbBQl4tVPcRSD49N9eVChcaxPDV1g6Weu0H4DH1iEOhmE
         k5DLnxchEMHTe/PDKsaP1aeHJUOO7T3+zO5BISgYqIout51jS4AzHXx+NGU9V9q9RSUS
         msR4UjHaJqMGeJKWRdthwSq/+sxKD2LvFD9DFT/WFS27Ph7cu+D02mYJYX9ZzpdICyp5
         g+nP99GoA9F7hF/Z1VsVdcUrxnGRVM05tGijjGR4gSR1gc7gUCnRogLx+i/7bfTllH9j
         pplQ==
X-Gm-Message-State: AOAM532246Qbl9Jv84BjLFpv9ypK7L04eD7zzcvK+3pAOMrl3Vn2nTbQ
        hufPXSjkPua6ChNhph3I2M0Z+ZDUxmnTE+Pjx6X6
X-Google-Smtp-Source: ABdhPJzKGdNVsjgTej2xcBpuoKPd2C3Oqdgb3f4h5vrwkEShRjjAx36JJyUkFtyB1rEm/0O5DJTEmL545Nl/g7Jerlg=
X-Received: by 2002:a17:906:2c54:: with SMTP id f20mr14631744ejh.91.1622598014322;
 Tue, 01 Jun 2021 18:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163380685.8379.17381053199011043757.stgit@sifl> <20210528223544.GL447005@madcap2.tricolour.ca>
 <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com> <20210531134408.GL2268484@madcap2.tricolour.ca>
In-Reply-To: <20210531134408.GL2268484@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 1 Jun 2021 21:40:03 -0400
Message-ID: <CAHC9VhSFNNE7AGGA20fDk201VLvzr5HB60VEqqq5qt9yGTH4mg@mail.gmail.com>
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

On Mon, May 31, 2021 at 9:44 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2021-05-30 11:26, Paul Moore wrote:
> > On Fri, May 28, 2021 at 6:36 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2021-05-21 17:50, Paul Moore wrote:

...

> > > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > > index d8aa2c690bf9..4f6ab34020fb 100644
> > > > --- a/kernel/auditsc.c
> > > > +++ b/kernel/auditsc.c
> > > > @@ -799,6 +799,35 @@ static int audit_in_mask(const struct audit_krule *rule, unsigned long val)
> > > >       return rule->mask[word] & bit;
> > > >  }
> > > >
> > > > +/**
> > > > + * audit_filter_uring - apply filters to an io_uring operation
> > > > + * @tsk: associated task
> > > > + * @ctx: audit context
> > > > + */
> > > > +static void audit_filter_uring(struct task_struct *tsk,
> > > > +                            struct audit_context *ctx)
> > > > +{
> > > > +     struct audit_entry *e;
> > > > +     enum audit_state state;
> > > > +
> > > > +     if (auditd_test_task(tsk))
> > > > +             return;
> > >
> > > Is this necessary?  auditd and auditctl don't (intentionally) use any
> > > io_uring functionality.  Is it possible it might inadvertantly use some
> > > by virtue of libc or other library calls now or in the future?
> >
> > I think the better question is what harm does it do?  Yes, I'm not
> > aware of an auditd implementation that currently makes use of
> > io_uring, but it is also not inconceivable some future implementation
> > might want to make use of it and given the disjoint nature of kernel
> > and userspace development I don't want the kernel to block such
> > developments.  However, if you can think of a reason why having this
> > check here is bad I'm listening (note: we are already in the slow path
> > here so having the additional check isn't an issue as far as I'm
> > concerned).
> >
> > As a reminder, auditd_test_task() only returns true/1 if the task is
> > registered with the audit subsystem as an auditd connection, an
> > auditctl process should not cause this function to return true.
>
> My main concern was overhead, since the whole goal of io_uring is speed.

At the point where this test takes place we are already in the audit
slow path as far as io_uring is concerned.  I understand your concern,
but the advantage of being able to effectively use io_uring in the
future makes this worth keeping in my opinion.

> The chances that audit does use this functionality in the future suggest
> to me that it is best to leave this check in.

Sounds like we are in agreement.  We'll keep it for now.

> > > > +     rcu_read_lock();
> > > > +     list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_URING_EXIT],
> > > > +                             list) {
> > > > +             if (audit_in_mask(&e->rule, ctx->uring_op) &&
> > >
> > > While this seems like the most obvious approach given the parallels
> > > between syscalls and io_uring operations, as coded here it won't work
> > > due to the different mappings of syscall numbers and io_uring
> > > operations unless we re-use the auditctl -S field with raw io_uring
> > > operation numbers in the place of syscall numbers.  This should have
> > > been obvious to me when I first looked at this patch.  It became obvious
> > > when I started looking at the userspace auditctl.c.
> >
> > FWIW, my intention was to treat io_uring opcodes exactly like we treat
> > syscall numbers.  Yes, this would potentially be an issue if we wanted
> > to combine syscalls and io_uring opcodes into one filter, but why
> > would we ever want to do that?  Combining the two into one filter not
> > only makes the filter lists longer than needed (we will always know if
> > we are filtering on a syscall or io_uring op) and complicates the
> > filter rule processing.
> >
> > Or is there a problem with this that I'm missing?
>
> No, I think you have a good understanding of it.  I'm asking hard
> questions to avoid missing something important.  If we can reuse the
> syscall infrastructure for this then that is extremely helpful (if not
> lazy, which isn't necessarily a bad thing).  It does mean that the
> io_uring op dictionary will need to live in userspace audit the way it
> is currently implemented ....

Which I currently believe is the right thing to do.

> > > The easy first step would be to use something like this:
> > >         auditctl -a uring,always -S 18,28 -F key=uring_open
> > > to monitor file open commands only.  The same is not yet possible for
> > > the perm field, but there are so few io_uring ops at this point compared
> > > with syscalls that it might be manageable.  The arch is irrelevant since
> > > io_uring operation numbers are identical across all hardware as far as I
> > > can tell.  Most of the rest of the fields should make sense if they do
> > > for a syscall rule.
> >
> > I've never been a fan of audit's "perm" filtering; I've always felt
> > there were better ways to handle that so I'm not overly upset that we
> > are skipping that functionality with this initial support.  If it
> > becomes a problem in the future we can always add that support at a
> > later date.
>
> Ok, I don't see a pressing need to add it initially, but should add a
> check to block that field from being used to avoid the confusion of
> unpredictable behaviour should someone try to add a perm filter to a
> io_uring filter.  That should be done protectively in the kernel and
> proactively in userspace.

Sure, that's reasonable.

> > > Here's a sample of userspace code to support this
> > > patch:
> > >         https://github.com/rgbriggs/audit-userspace/commit/a77baa1651b7ad841a220eb962d4cc92bc07dc96
> > >         https://github.com/linux-audit/audit-userspace/compare/master...rgbriggs:ghau-iouring-filtering.v1.0
> >
> > Great, thank you.  I haven't grabbed a copy yet for testing, but I will.
>
> I've added a perm filter block as an additional patch in userspace and
> updated the tree so that first commit is no longer the top of tree but
> the branch name is current.
>
> I'll add a kernel perm filter check.
>
> I just noticed some list checking that is missing in tree and watch in
> your patch.
>
> Suggested fixup patches to follow...

I see them, thank you, comments will follow over there.  Although to
be honest I'm mostly focusing on the testing right now while we wait
to hear back from Jens on what he is willing to accept regarding audit
calls in io_issue_sqe().  If we can't do the _entry()/_exit() calls
then this work is pretty much dead and we just have to deal with it in
Kconfig.  I might make one last, clean patchset and put it in a branch
for the distros that want to carry the patchset, but it isn't clear to
me that it is something I would want to maintain long term.  Long
running out of tree patches are generally A Bad Idea.

> > > If we abuse the syscall infrastructure at first, we'd need a transition
> > > plan to coordinate user and kernel switchover to seperate mechanisms for
> > > the two to work together if the need should arise to have both syscall
> > > and uring filters in the same rule.
> >
> > See my comments above, I don't currently see why we would ever want
> > syscall and io_uring filtering to happen in the same rule.  Please
> > speak up if you can think of a reason why this would either be needed,
> > or desirable for some reason.
>
> I think they can be seperate rules for now.  Either a syscall rule
> catching all io_uring ops can be added, or an io_uring rule can be added
> to catch specific ops.  The scenario I was thinking of was catching
> syscalls of specific io_uring ops.

Perhaps I'm misunderstand you, but that scenario really shouldn't
exist.  The io_uring ops function independently of syscalls; you can
*submit* io_uring ops via io_uring_enter(), but they are not
guaranteed to be dispatched synchronously (obviously), and given the
cred shenanigans that can happen with io_uring there is no guarantee
the filters would even be applicable.

It isn't an issue of "can" the filters be separate, they *have* to be separate.

-- 
paul moore
www.paul-moore.com
