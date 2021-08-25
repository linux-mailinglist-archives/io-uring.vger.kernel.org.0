Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0253F6D09
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 03:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhHYBWF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Aug 2021 21:22:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229969AbhHYBWC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Aug 2021 21:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629854477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0muNwceDTuLhWI9aHa7QSqZqpe05O697Z6iihsbE+dQ=;
        b=MX+8PlR1y6W2e+FQrX6W5PSlxKVnxH7qz3ys+0eWhN9aGF17SMAnGTtQcAA76WbkGcgTYj
        0+XCjAvWJoNG3dl48dI6BP334Hwq2YzJX1JWtDmb5Hi8WASbXC8ZSb/kNUg4/qyE8Tn7+9
        lAnkyHCOH9A3F2CQEy+07etCaVbmYuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-6s3bVPGOPb6Dgpb9g7rqWw-1; Tue, 24 Aug 2021 21:21:15 -0400
X-MC-Unique: 6s3bVPGOPb6Dgpb9g7rqWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2702E18C89C4;
        Wed, 25 Aug 2021 01:21:14 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0A4710016FB;
        Wed, 25 Aug 2021 01:21:04 +0000 (UTC)
Date:   Tue, 24 Aug 2021 21:21:02 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/9] audit, io_uring, io-wq: add some basic audit
 support to io_uring
Message-ID: <20210825012102.GC490529@madcap2.tricolour.ca>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl>
 <20210602172924.GM447005@madcap2.tricolour.ca>
 <CAHC9VhS0sy_Y8yx4uiZeJhAf_a94ipt1EbE16BOVv6tXtWkgMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhS0sy_Y8yx4uiZeJhAf_a94ipt1EbE16BOVv6tXtWkgMg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-06-02 13:46, Paul Moore wrote:
> On Wed, Jun 2, 2021 at 1:29 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2021-05-21 17:49, Paul Moore wrote:
> > > WARNING - This is a work in progress and should not be merged
> > > anywhere important.  It is almost surely not complete, and while it
> > > probably compiles it likely hasn't been booted and will do terrible
> > > things.  You have been warned.
> > >
> > > This patch adds basic auditing to io_uring operations, regardless of
> > > their context.  This is accomplished by allocating audit_context
> > > structures for the io-wq worker and io_uring SQPOLL kernel threads
> > > as well as explicitly auditing the io_uring operations in
> > > io_issue_sqe().  The io_uring operations are audited using a new
> > > AUDIT_URINGOP record, an example is shown below:
> > >
> > >   % <TODO - insert AUDIT_URINGOP record example>
> > >
> > > Thanks to Richard Guy Briggs for review and feedback.
> > >
> > > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > > ---
> > >  fs/io-wq.c                 |    4 +
> > >  fs/io_uring.c              |   11 +++
> > >  include/linux/audit.h      |   17 ++++
> > >  include/uapi/linux/audit.h |    1
> > >  kernel/audit.h             |    2 +
> > >  kernel/auditsc.c           |  173 ++++++++++++++++++++++++++++++++++++++++++++
> > >  6 files changed, 208 insertions(+)
> 
> ...
> 
> > > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > > index e481ac8a757a..e9941d1ad8fd 100644
> > > --- a/fs/io_uring.c
> > > +++ b/fs/io_uring.c
> > > @@ -78,6 +78,7 @@
> > >  #include <linux/task_work.h>
> > >  #include <linux/pagemap.h>
> > >  #include <linux/io_uring.h>
> > > +#include <linux/audit.h>
> > >
> > >  #define CREATE_TRACE_POINTS
> > >  #include <trace/events/io_uring.h>
> > > @@ -6105,6 +6106,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
> > >       if (req->work.creds && req->work.creds != current_cred())
> > >               creds = override_creds(req->work.creds);
> > >
> > > +     if (req->opcode < IORING_OP_LAST)
> > > +             audit_uring_entry(req->opcode);
> 
> Note well the override_creds() call right above the audit code that is
> being added, it will be important later in this email.
> 
> > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > index cc89e9f9a753..729849d41631 100644
> > > --- a/kernel/auditsc.c
> > > +++ b/kernel/auditsc.c
> > > @@ -1536,6 +1562,52 @@ static void audit_log_proctitle(void)
> > >       audit_log_end(ab);
> > >  }
> > >
> > > +/**
> > > + * audit_log_uring - generate a AUDIT_URINGOP record
> > > + * @ctx: the audit context
> > > + */
> > > +static void audit_log_uring(struct audit_context *ctx)
> > > +{
> > > +     struct audit_buffer *ab;
> > > +     const struct cred *cred;
> > > +
> > > +     /*
> > > +      * TODO: What do we log here?  I'm tossing in a few things to start the
> > > +      *       conversation, but additional thought needs to go into this.
> > > +      */
> > > +
> > > +     ab = audit_log_start(ctx, GFP_KERNEL, AUDIT_URINGOP);
> > > +     if (!ab)
> > > +             return;
> > > +     cred = current_cred();
> >
> > This may need to be req->work.creds.  I haven't been following if the
> > io_uring thread inherited the user task's creds (and below, comm and
> > exe).
> 
> Nope, we're good.  See the existing code in io_issue_sqe() :)
> 
> > > +     audit_log_format(ab, "uring_op=%d", ctx->uring_op);
> >
> > arch is stored below in __audit_uring_entry() and never used in the
> > AUDIT_CTX_URING case.  That assignment can either be dropped or printed
> > before uring_op similar to the SYSCALL record.
> 
> Good point, I'll drop the code that records the arch from _entry(); it
> is really only useful to give the appropriate context if needed for
> other things in the audit stream, and that isn't the case like it is
> with syscalls.
> 
> > There aren't really any arg[0-3] to print.
> 
> Which is why I didn't print them.
> 
> > io_uring_register and io_uring_setup() args are better covered by other
> > records.  io_uring_enter() has 6 args and the last two aren't covered by
> > SYSCALL anyways.
> 
>  ???
> 
> I think you are confusing the io_uring ops with syscalls; they are
> very different things from an audit perspective and the io_uring
> auditing is not intended to replace syscall records.  The
> io_uring_setup() and io_uring_enter() syscalls will be auditing just
> as any other syscalls would be using the existing syscall audit code.
> 
> > > +     if (ctx->return_valid != AUDITSC_INVALID)
> > > +             audit_log_format(ab, " success=%s exit=%ld",
> > > +                              (ctx->return_valid == AUDITSC_SUCCESS ?
> > > +                               "yes" : "no"),
> > > +                              ctx->return_code);
> > > +     audit_log_format(ab,
> > > +                      " items=%d"
> > > +                      " ppid=%d pid=%d auid=%u uid=%u gid=%u"
> > > +                      " euid=%u suid=%u fsuid=%u"
> > > +                      " egid=%u sgid=%u fsgid=%u",
> > > +                      ctx->name_count,
> > > +                      task_ppid_nr(current),
> > > +                      task_tgid_nr(current),
> > > +                      from_kuid(&init_user_ns, audit_get_loginuid(current)),
> > > +                      from_kuid(&init_user_ns, cred->uid),
> > > +                      from_kgid(&init_user_ns, cred->gid),
> > > +                      from_kuid(&init_user_ns, cred->euid),
> > > +                      from_kuid(&init_user_ns, cred->suid),
> > > +                      from_kuid(&init_user_ns, cred->fsuid),
> > > +                      from_kgid(&init_user_ns, cred->egid),
> > > +                      from_kgid(&init_user_ns, cred->sgid),
> > > +                      from_kgid(&init_user_ns, cred->fsgid));
> >
> > The audit session ID is still important, relevant and qualifies auid.
> > In keeping with the SYSCALL record format, I think we want to keep
> > ses=audit_get_sessionid(current) in here.
> 
> This might be another case of syscall/io_uring confusion.  An io_uring
> op doesn't necessarily have an audit session ID or an audit UID in the
> conventional sense; for example think about SQPOLL works, shared
> rings, etc.

Right, but those syscalls are what instigate io_uring operations, so
whatever process starts that operation, or gets handed that handle
should be tracked with auid and sessionid (the two work together to
track) unless we can easily track io_uring ops to connect them to a
previous setup syscall.  If we see a need to keep the auid, then the
sessionid goes with it.

> > I'm pretty sure we also want to keep comm= and exe= too, but may have to
> > reach into req->task to get it.  There are two values for comm possible,
> > one from the original task and second "iou-sqp-<pid>" set at the top of
> > io_sq_thread().
> 
> I think this is more syscall/io_uring confusion.

I wouldn't call them confusion but rather parallels, attributing a
particular subject to an action.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

