Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DCF391C62
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 17:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhEZPv3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 11:51:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234664AbhEZPvP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 11:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622044168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r1Ej9c3HqF4N34dLokWBDDDLrsUjOS1R2qnUxM+2GaA=;
        b=VMhFHGBF1oLVpsFcJ1cAJMwFwl663bVg9OK1ZO2bg1Fzt1SEiQ1CUi5Nc9TkbnXK6iZJgL
        JkS9/c30ZGQk95l4ue62YInZhrcE4F0LMiK7is51cWRe7nQkqr/+rtCO7vOPLNE2m5f7vP
        g1m9TJOd350wJ5MmT4TtlhktEXh9bqE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-8ehnYgxmNmaY3t-x9HlAHw-1; Wed, 26 May 2021 11:49:18 -0400
X-MC-Unique: 8ehnYgxmNmaY3t-x9HlAHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15355188E3C1;
        Wed, 26 May 2021 15:49:17 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE0AC90BE;
        Wed, 26 May 2021 15:49:07 +0000 (UTC)
Date:   Wed, 26 May 2021 11:49:05 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Paul Moore <paul@paul-moore.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <20210526154905.GJ447005@madcap2.tricolour.ca>
References: <162163379461.8379.9691291608621179559.stgit@sifl>
 <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
 <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com>
 <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
 <18823c99-7d65-0e6f-d508-a487f1b4b9e7@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18823c99-7d65-0e6f-d508-a487f1b4b9e7@samba.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-05-26 17:17, Stefan Metzmacher wrote:
> 
> Am 26.05.21 um 16:38 schrieb Paul Moore:
> > On Wed, May 26, 2021 at 6:19 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >> On 5/26/21 3:04 AM, Paul Moore wrote:
> >>> On Tue, May 25, 2021 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 5/24/21 1:59 PM, Paul Moore wrote:
> >>>>> That said, audit is not for everyone, and we have build time and
> >>>>> runtime options to help make life easier.  Beyond simply disabling
> >>>>> audit at compile time a number of Linux distributions effectively
> >>>>> shortcut audit at runtime by adding a "never" rule to the audit
> >>>>> filter, for example:
> >>>>>
> >>>>>  % auditctl -a task,never
> >>>>
> >>>> As has been brought up, the issue we're facing is that distros have
> >>>> CONFIG_AUDIT=y and hence the above is the best real world case outside
> >>>> of people doing custom kernels. My question would then be how much
> >>>> overhead the above will add, considering it's an entry/exit call per op.
> >>>> If auditctl is turned off, what is the expectation in turns of overhead?
> >>>
> >>> I commented on that case in my last email to Pavel, but I'll try to go
> >>> over it again in a little more detail.
> >>>
> >>> As we discussed earlier in this thread, we can skip the req->opcode
> >>> check before both the _entry and _exit calls, so we are left with just
> >>> the bare audit calls in the io_uring code.  As the _entry and _exit
> >>> functions are small, I've copied them and their supporting functions
> >>> below and I'll try to explain what would happen in CONFIG_AUDIT=y,
> >>> "task,never" case.
> >>>
> >>> +  static inline struct audit_context *audit_context(void)
> >>> +  {
> >>> +    return current->audit_context;
> >>> +  }
> >>>
> >>> +  static inline bool audit_dummy_context(void)
> >>> +  {
> >>> +    void *p = audit_context();
> >>> +    return !p || *(int *)p;
> >>> +  }
> >>>
> >>> +  static inline void audit_uring_entry(u8 op)
> >>> +  {
> >>> +    if (unlikely(audit_enabled && audit_context()))
> >>> +      __audit_uring_entry(op);
> >>> +  }
> >>
> >> I'd rather agree that it's my cycle-picking. The case I care about
> >> is CONFIG_AUDIT=y (because everybody enable it), and io_uring
> >> tracing _not_ enabled at runtime. If enabled let them suffer
> >> the overhead, it will probably dip down the performance
> >>
> >> So, for the case I care about it's two of
> >>
> >> if (unlikely(audit_enabled && current->audit_context))
> >>
> >> in the hot path. load-test-jump + current, so it will
> >> be around 7x2 instructions. We can throw away audit_enabled
> >> as you say systemd already enables it, that will give
> >> 4x2 instructions including 2 conditional jumps.
> > 
> > We've basically got it down to the equivalent of two
> > "current->audit_context != NULL" checks in the case where audit is
> > built into the kernel but disabled at runtime, e.g. CONFIG_AUDIT=y and
> > "task,never".  I'm at a loss for how we can lower the overhead any
> > further, but I'm open to suggestions.
> > 
> >> That's not great at all. And that's why I brought up
> >> the question about need of pre and post hooks and whether
> >> can be combined. Would be just 4 instructions and that is
> >> ok (ish).
> > 
> > As discussed previously in this thread that isn't really an option
> > from an audit perspective.
> > 
> >>> We would need to check with the current security requirements (there
> >>> are distro people on the linux-audit list that keep track of that
> >>> stuff), but looking at the opcodes right now my gut feeling is that
> >>> most of the opcodes would be considered "security relevant" so
> >>> selective auditing might not be that useful in practice.  It would
> >>> definitely clutter the code and increase the chances that new opcodes
> >>> would not be properly audited when they are merged.
> >>
> >> I'm curious, why it's enabled by many distros by default? Are there
> >> use cases they use?
> > 
> > We've already talked about certain users and environments where audit
> > is an important requirement, e.g. public sector, health care,
> > financial institutions, etc.; without audit Linux wouldn't be an
> > option for these users, at least not without heavy modification,
> > out-of-tree/ISV patches, etc.  I currently don't have any direct ties
> > to any distros, "Enterprise" or otherwise, but in the past it has been
> > my experience that distros much prefer to have a single kernel build
> > to address the needs of all their users.  In the few cases I have seen
> > where a second kernel build is supported it is usually for hardware
> > enablement.  I'm sure there are other cases too, I just haven't seen
> > them personally; the big distros definitely seem to have a strong
> > desire to limit the number of supported kernel configs/builds.
> > 
> >> Tempting to add AUDIT_IOURING=default N, but won't work I guess
> > 
> > One of the nice things about audit is that it can give you a history
> > of what a user did on a system, which is very important for a number
> > of use cases.  If we selectively disable audit for certain subsystems
> > we create a blind spot in the audit log, and in the case of io_uring
> > this can be a very serious blind spot.  I fear that if we can't come
> > to some agreement here we will need to make io_uring and audit
> > mutually exclusive at build time which would be awful; forcing many
> > distros to either make a hard choice or carry out-of-tree patches.
> 
> I'm wondering why it's not enough to have the native auditing just to happen.

The audit context needs to be set up for each event.  This happens in
audit_syslog_entry and audit_syslog_exit.

> E.g. all (I have checked RECVMSG,SENDMSG,SEND and CONNECT) socket related io_uring opcodes
> already go via security_socket_{recvmsg,sendmsg,connect}()
> 
> IORING_OP_OPENAT* goes via do_filp_open() which is in common with the open[at[2]]() syscalls
> and should also trigger audit_inode() and security_file_open().

These are extra hooks to grab operation-specific (syscall) parameters.

> So why is there anything special needed for io_uring (now that the native worker threads are used)?

Because syscall has been bypassed by a memory-mapped work queue.

> Is there really any io_uring opcode that bypasses the security checks the corresponding native syscall
> would do? If so, I think that should just be fixed...

This is by design to speed it up.  This is what Paul's iouring entry and
exit hooks do.

> Additional LSM based restrictions could be hooked into the io_check_restriction() path
> and setup at io_uring_setup() or early io_uring_register() time.
> 
> What do you think?
> 
> metze

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

