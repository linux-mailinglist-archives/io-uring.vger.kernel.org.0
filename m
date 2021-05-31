Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EAA395D9C
	for <lists+io-uring@lfdr.de>; Mon, 31 May 2021 15:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhEaNsI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 May 2021 09:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232907AbhEaNqD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 May 2021 09:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622468661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BNVsRsSTYg+9sj6VK8BUfR+yYRTc6ppPi/wkssTbwkk=;
        b=cdDiRfGRw8TYYXogxmf3vlNPuxW7aK7Gv0espoRvLi456cdgTbeY2JbBQQFFLqFaLufzMP
        QU/zMbD+mHJ00hA2c4EWOV7neXAIJ21U6C6onVw9tZG/Aq5kCQvtKGYQgutbKRCqmplrDm
        +PXkAYISNhgpCZHqvwOmOgUIwi7t8wY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-YjrdoqkrPLC6Rl8gGecCug-1; Mon, 31 May 2021 09:44:18 -0400
X-MC-Unique: YjrdoqkrPLC6Rl8gGecCug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF11D108C1E1;
        Mon, 31 May 2021 13:44:13 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92F8C5C1B4;
        Mon, 31 May 2021 13:44:11 +0000 (UTC)
Date:   Mon, 31 May 2021 09:44:08 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 4/9] audit: add filtering for io_uring records
Message-ID: <20210531134408.GL2268484@madcap2.tricolour.ca>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163380685.8379.17381053199011043757.stgit@sifl>
 <20210528223544.GL447005@madcap2.tricolour.ca>
 <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-05-30 11:26, Paul Moore wrote:
> On Fri, May 28, 2021 at 6:36 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2021-05-21 17:50, Paul Moore wrote:
> > > WARNING - This is a work in progress and should not be merged
> > > anywhere important.  It is almost surely not complete, and while it
> > > probably compiles it likely hasn't been booted and will do terrible
> > > things.  You have been warned.
> > >
> > > This patch adds basic audit io_uring filtering, using as much of the
> > > existing audit filtering infrastructure as possible.  In order to do
> > > this we reuse the audit filter rule's syscall mask for the io_uring
> > > operation and we create a new filter for io_uring operations as
> > > AUDIT_FILTER_URING_EXIT/audit_filter_list[7].
> > >
> > > <TODO - provide some additional guidance for the userspace tools>
> > >
> > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > > ---
> > >  include/uapi/linux/audit.h |    3 +-
> > >  kernel/auditfilter.c       |    4 ++-
> > >  kernel/auditsc.c           |   65 ++++++++++++++++++++++++++++++++++----------
> > >  3 files changed, 55 insertions(+), 17 deletions(-)
> 
> ...
> 
> > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > index d8aa2c690bf9..4f6ab34020fb 100644
> > > --- a/kernel/auditsc.c
> > > +++ b/kernel/auditsc.c
> > > @@ -799,6 +799,35 @@ static int audit_in_mask(const struct audit_krule *rule, unsigned long val)
> > >       return rule->mask[word] & bit;
> > >  }
> > >
> > > +/**
> > > + * audit_filter_uring - apply filters to an io_uring operation
> > > + * @tsk: associated task
> > > + * @ctx: audit context
> > > + */
> > > +static void audit_filter_uring(struct task_struct *tsk,
> > > +                            struct audit_context *ctx)
> > > +{
> > > +     struct audit_entry *e;
> > > +     enum audit_state state;
> > > +
> > > +     if (auditd_test_task(tsk))
> > > +             return;
> >
> > Is this necessary?  auditd and auditctl don't (intentionally) use any
> > io_uring functionality.  Is it possible it might inadvertantly use some
> > by virtue of libc or other library calls now or in the future?
> 
> I think the better question is what harm does it do?  Yes, I'm not
> aware of an auditd implementation that currently makes use of
> io_uring, but it is also not inconceivable some future implementation
> might want to make use of it and given the disjoint nature of kernel
> and userspace development I don't want the kernel to block such
> developments.  However, if you can think of a reason why having this
> check here is bad I'm listening (note: we are already in the slow path
> here so having the additional check isn't an issue as far as I'm
> concerned).
> 
> As a reminder, auditd_test_task() only returns true/1 if the task is
> registered with the audit subsystem as an auditd connection, an
> auditctl process should not cause this function to return true.

My main concern was overhead, since the whole goal of io_uring is speed.

The chances that audit does use this functionality in the future suggest
to me that it is best to leave this check in.

> > > +     rcu_read_lock();
> > > +     list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_URING_EXIT],
> > > +                             list) {
> > > +             if (audit_in_mask(&e->rule, ctx->uring_op) &&
> >
> > While this seems like the most obvious approach given the parallels
> > between syscalls and io_uring operations, as coded here it won't work
> > due to the different mappings of syscall numbers and io_uring
> > operations unless we re-use the auditctl -S field with raw io_uring
> > operation numbers in the place of syscall numbers.  This should have
> > been obvious to me when I first looked at this patch.  It became obvious
> > when I started looking at the userspace auditctl.c.
> 
> FWIW, my intention was to treat io_uring opcodes exactly like we treat
> syscall numbers.  Yes, this would potentially be an issue if we wanted
> to combine syscalls and io_uring opcodes into one filter, but why
> would we ever want to do that?  Combining the two into one filter not
> only makes the filter lists longer than needed (we will always know if
> we are filtering on a syscall or io_uring op) and complicates the
> filter rule processing.
> 
> Or is there a problem with this that I'm missing?

No, I think you have a good understanding of it.  I'm asking hard
questions to avoid missing something important.  If we can reuse the
syscall infrastructure for this then that is extremely helpful (if not
lazy, which isn't necessarily a bad thing).  It does mean that the
io_uring op dictionary will need to live in userspace audit the way it
is currently implemented, or provide a flag to indicate it is a syscall
number to be translated in the kernel either at the time of rule
addition or translated on the fly on rule check in the kernel adding
overhead to a critical path.

> > The easy first step would be to use something like this:
> >         auditctl -a uring,always -S 18,28 -F key=uring_open
> > to monitor file open commands only.  The same is not yet possible for
> > the perm field, but there are so few io_uring ops at this point compared
> > with syscalls that it might be manageable.  The arch is irrelevant since
> > io_uring operation numbers are identical across all hardware as far as I
> > can tell.  Most of the rest of the fields should make sense if they do
> > for a syscall rule.
> 
> I've never been a fan of audit's "perm" filtering; I've always felt
> there were better ways to handle that so I'm not overly upset that we
> are skipping that functionality with this initial support.  If it
> becomes a problem in the future we can always add that support at a
> later date.

Ok, I don't see a pressing need to add it initially, but should add a
check to block that field from being used to avoid the confusion of
unpredictable behaviour should someone try to add a perm filter to a
io_uring filter.  That should be done protectively in the kernel and
proactively in userspace.

> I currently fear that just getting io_uring and audit to coexist is
> going to be a large enough problem in the immediate future.

Agreed.

> > Here's a sample of userspace code to support this
> > patch:
> >         https://github.com/rgbriggs/audit-userspace/commit/a77baa1651b7ad841a220eb962d4cc92bc07dc96
> >         https://github.com/linux-audit/audit-userspace/compare/master...rgbriggs:ghau-iouring-filtering.v1.0
> 
> Great, thank you.  I haven't grabbed a copy yet for testing, but I will.

I've added a perm filter block as an additional patch in userspace and
updated the tree so that first commit is no longer the top of tree but
the branch name is current.

I'll add a kernel perm filter check.

I just noticed some list checking that is missing in tree and watch in
your patch.

Suggested fixup patches to follow...

> > If we abuse the syscall infrastructure at first, we'd need a transition
> > plan to coordinate user and kernel switchover to seperate mechanisms for
> > the two to work together if the need should arise to have both syscall
> > and uring filters in the same rule.
> 
> See my comments above, I don't currently see why we would ever want
> syscall and io_uring filtering to happen in the same rule.  Please
> speak up if you can think of a reason why this would either be needed,
> or desirable for some reason.

I think they can be seperate rules for now.  Either a syscall rule
catching all io_uring ops can be added, or an io_uring rule can be added
to catch specific ops.  The scenario I was thinking of was catching
syscalls of specific io_uring ops.

> > It might be wise to deliberately not support auditctl "-w" (and the
> > exported audit_add_watch() function) since that is currently hardcoded
> > to the AUDIT_FILTER_EXIT list and is the old watch form [replaced by
> > audit_rule_fieldpair_data()] anyways that is more likely to be
> > deprecated.  It also appears to make sense not to support autrace (at
> > least initially).
> 
> I'm going to be honest with you and simply say that I've run out of my
> email/review time in front of the computer on this holiday weekend
> (blame the lockdown/bpf/lsm discussion <g>) and I need to go for
> today, but this is something I'll take a look it this coming week.
> Hopefully the comments above give us something to think/talk about in
> the meantime.

I wasn't expecting you to work the weekend.  :-)

> Regardless, thanks for your help on the userspace side of the
> filtering, that should make testing a lot easier moving forward.

Standard RFC disclaimers apply.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

