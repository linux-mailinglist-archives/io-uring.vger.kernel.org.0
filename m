Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1293994C8
	for <lists+io-uring@lfdr.de>; Wed,  2 Jun 2021 22:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhFBUsv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Jun 2021 16:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBUsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Jun 2021 16:48:50 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C7CC06174A
        for <io-uring@vger.kernel.org>; Wed,  2 Jun 2021 13:46:51 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id g8so5884237ejx.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 13:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fmjdGsZgyfhH82V3nYsUARig/lnO3sllBQpi/gDMFvc=;
        b=MuvgcTuAIXOaGGA++L/YavJDqGoEu5mG11y7jbFWn+bjS0yuutVVvCSh4/wsETk1cj
         irDindvdBjVVC5Nypb04oqK5y9kvwErAOXUzBg/D5+uuE6jmwwFmKdrUxjftl6g9XUpw
         iZ4AVRmt6rkwr2r0x+v6JlPsB1M2TpcIbf3t4t051jj2McFmGwZ9Pp7WEjFULKlG6fY/
         RT410/1rOrww8zNzjLW91sxSjKjDDx5/KB5gk2ueLb5xDwQf3FVui57Vq3jYZuAO5Wji
         qSpqbeI9wNbA64Toaoc6mJ6u7x8aeKU+E+v6bhOdEoH3+902WGdj/Xcrpkcc6rAcFONW
         CFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fmjdGsZgyfhH82V3nYsUARig/lnO3sllBQpi/gDMFvc=;
        b=CDp1yU5p6gkPs0Thdr4T4+3RW6NaiXi28YALcSA2+y8KJfaB5SW87SgUnez+GW/o1e
         t/+3C0Z41852cYh2fDX4wJjW46V5oGzRvvZg7+oGbO7xhlJAOpZpPiT9PlRdDoYo0/qP
         Aeze20ODjGPKKzXL0raZ2dxzD0gKmoe4d/pjKD1Qy3ZIkXfxT3ZkGxvwXQeE45ZU83Dw
         k0w7otfaTGJMekoTa0a8cqCGLNBX4oHFYPrACBxlIxWuTJEtxZCSi7l6hPQH6ow6sjX+
         m8+t8N2+Ebh2OiYXSe5brcCqLV7u1y82qORvaQNCidsTTe3MtmaNfvEpLezZS3cPQBnt
         Scrg==
X-Gm-Message-State: AOAM530ON2pmY8TToy1FxXf6LeTVRadwVpagxq8+zjnyx6W9zn3+8oGG
        iJ0nP+ShwUkaT0wkENe0iSttG/jFcrS1UKP+QjNL
X-Google-Smtp-Source: ABdhPJx/n1S5UyuIfGVXGC2QsiIR2Cy08Xe7mAk9pLAL6gbKDdUveE6w4bsXPazI8bBpKsR9b5qc2FdUOfr3XdARSsY=
X-Received: by 2002:a17:906:17d8:: with SMTP id u24mr36904730eje.106.1622666810379;
 Wed, 02 Jun 2021 13:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl> <20210602172924.GM447005@madcap2.tricolour.ca>
In-Reply-To: <20210602172924.GM447005@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 2 Jun 2021 16:46:39 -0400
Message-ID: <CAHC9VhS0sy_Y8yx4uiZeJhAf_a94ipt1EbE16BOVv6tXtWkgMg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] audit, io_uring, io-wq: add some basic audit
 support to io_uring
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

On Wed, Jun 2, 2021 at 1:29 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2021-05-21 17:49, Paul Moore wrote:
> > WARNING - This is a work in progress and should not be merged
> > anywhere important.  It is almost surely not complete, and while it
> > probably compiles it likely hasn't been booted and will do terrible
> > things.  You have been warned.
> >
> > This patch adds basic auditing to io_uring operations, regardless of
> > their context.  This is accomplished by allocating audit_context
> > structures for the io-wq worker and io_uring SQPOLL kernel threads
> > as well as explicitly auditing the io_uring operations in
> > io_issue_sqe().  The io_uring operations are audited using a new
> > AUDIT_URINGOP record, an example is shown below:
> >
> >   % <TODO - insert AUDIT_URINGOP record example>
> >
> > Thanks to Richard Guy Briggs for review and feedback.
> >
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > ---
> >  fs/io-wq.c                 |    4 +
> >  fs/io_uring.c              |   11 +++
> >  include/linux/audit.h      |   17 ++++
> >  include/uapi/linux/audit.h |    1
> >  kernel/audit.h             |    2 +
> >  kernel/auditsc.c           |  173 ++++++++++++++++++++++++++++++++++++++++++++
> >  6 files changed, 208 insertions(+)

...

> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index e481ac8a757a..e9941d1ad8fd 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -78,6 +78,7 @@
> >  #include <linux/task_work.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/io_uring.h>
> > +#include <linux/audit.h>
> >
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/io_uring.h>
> > @@ -6105,6 +6106,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
> >       if (req->work.creds && req->work.creds != current_cred())
> >               creds = override_creds(req->work.creds);
> >
> > +     if (req->opcode < IORING_OP_LAST)
> > +             audit_uring_entry(req->opcode);

Note well the override_creds() call right above the audit code that is
being added, it will be important later in this email.

> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index cc89e9f9a753..729849d41631 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1536,6 +1562,52 @@ static void audit_log_proctitle(void)
> >       audit_log_end(ab);
> >  }
> >
> > +/**
> > + * audit_log_uring - generate a AUDIT_URINGOP record
> > + * @ctx: the audit context
> > + */
> > +static void audit_log_uring(struct audit_context *ctx)
> > +{
> > +     struct audit_buffer *ab;
> > +     const struct cred *cred;
> > +
> > +     /*
> > +      * TODO: What do we log here?  I'm tossing in a few things to start the
> > +      *       conversation, but additional thought needs to go into this.
> > +      */
> > +
> > +     ab = audit_log_start(ctx, GFP_KERNEL, AUDIT_URINGOP);
> > +     if (!ab)
> > +             return;
> > +     cred = current_cred();
>
> This may need to be req->work.creds.  I haven't been following if the
> io_uring thread inherited the user task's creds (and below, comm and
> exe).

Nope, we're good.  See the existing code in io_issue_sqe() :)

> > +     audit_log_format(ab, "uring_op=%d", ctx->uring_op);
>
> arch is stored below in __audit_uring_entry() and never used in the
> AUDIT_CTX_URING case.  That assignment can either be dropped or printed
> before uring_op similar to the SYSCALL record.

Good point, I'll drop the code that records the arch from _entry(); it
is really only useful to give the appropriate context if needed for
other things in the audit stream, and that isn't the case like it is
with syscalls.

> There aren't really any arg[0-3] to print.

Which is why I didn't print them.

> io_uring_register and io_uring_setup() args are better covered by other
> records.  io_uring_enter() has 6 args and the last two aren't covered by
> SYSCALL anyways.

 ???

I think you are confusing the io_uring ops with syscalls; they are
very different things from an audit perspective and the io_uring
auditing is not intended to replace syscall records.  The
io_uring_setup() and io_uring_enter() syscalls will be auditing just
as any other syscalls would be using the existing syscall audit code.

> > +     if (ctx->return_valid != AUDITSC_INVALID)
> > +             audit_log_format(ab, " success=%s exit=%ld",
> > +                              (ctx->return_valid == AUDITSC_SUCCESS ?
> > +                               "yes" : "no"),
> > +                              ctx->return_code);
> > +     audit_log_format(ab,
> > +                      " items=%d"
> > +                      " ppid=%d pid=%d auid=%u uid=%u gid=%u"
> > +                      " euid=%u suid=%u fsuid=%u"
> > +                      " egid=%u sgid=%u fsgid=%u",
> > +                      ctx->name_count,
> > +                      task_ppid_nr(current),
> > +                      task_tgid_nr(current),
> > +                      from_kuid(&init_user_ns, audit_get_loginuid(current)),
> > +                      from_kuid(&init_user_ns, cred->uid),
> > +                      from_kgid(&init_user_ns, cred->gid),
> > +                      from_kuid(&init_user_ns, cred->euid),
> > +                      from_kuid(&init_user_ns, cred->suid),
> > +                      from_kuid(&init_user_ns, cred->fsuid),
> > +                      from_kgid(&init_user_ns, cred->egid),
> > +                      from_kgid(&init_user_ns, cred->sgid),
> > +                      from_kgid(&init_user_ns, cred->fsgid));
>
> The audit session ID is still important, relevant and qualifies auid.
> In keeping with the SYSCALL record format, I think we want to keep
> ses=audit_get_sessionid(current) in here.

This might be another case of syscall/io_uring confusion.  An io_uring
op doesn't necessarily have an audit session ID or an audit UID in the
conventional sense; for example think about SQPOLL works, shared
rings, etc.

> I'm pretty sure we also want to keep comm= and exe= too, but may have to
> reach into req->task to get it.  There are two values for comm possible,
> one from the original task and second "iou-sqp-<pid>" set at the top of
> io_sq_thread().

I think this is more syscall/io_uring confusion.

-- 
paul moore
www.paul-moore.com
