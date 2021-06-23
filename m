Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDA63B13E7
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 08:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFWG2x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 02:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWG2x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 02:28:53 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A139EC061574;
        Tue, 22 Jun 2021 23:26:35 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id q190so2507338qkd.2;
        Tue, 22 Jun 2021 23:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZllIwWVemXDvwlm73xztDmeRRoqxcapNkpHU6zD7SA=;
        b=rXs6F99sOPUrI2zhUB9M/IhI2fZZF/nG7x8LSnb71tfHRkJzIfmWbUdL9hG89PZ4F3
         6k6qDyzrHvDxoFDuM3IHpnCwPsuRcxfYapRXuqwYEP9S/6HwE80/Jc0O8vdGRnCwlk3a
         1KkCh0y6wcyEy4sglMGnGNhvJJYMPf+3VFvqT2XoR9Pp/RxqkOvdeBRndYcm9gVh1vDV
         4jIEtEV3iETwClE4Zb1BHwP64GORw6qFj8Fe//5lES9pkgpTmI/rcRdRxVDtRMTUeRUf
         le9/iWc534FnFrl2Cnr/+ZY5K2oo0adfPrz4WYhhvRt++EDma2Cht2aFWgTi0dyWywTE
         WRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZllIwWVemXDvwlm73xztDmeRRoqxcapNkpHU6zD7SA=;
        b=ShpZNkymwppSqWpbGogrTlzSZwmWF7qCZTOsXlPAGRmqRAR5UIuNDxj3kYbx9t8Scg
         L8oX5AffNKLb38s2HIlYTbSJy86pWGt/8Zw0XE3PiLHhZSS/6pvasv062RUjfRJNaSm1
         J6mUAeSV9/lmdXefurdWkEhEvEVOLJVm13hI/M7fGVZKWosU496LMM2b6+jccE68Njr6
         5lgJ245SU4DztrGZDH9PdnbOzUm10F/i9nnSZy8/QiQauE85U0yozXxgw/L3CUNPZmhF
         RopwwPnNmFfuzqRNTRDrskdKRmDT7KKJipVDKMLbQu9qcizSFxhb/SgIqZKAFSgt6UK4
         tBfA==
X-Gm-Message-State: AOAM530/7Ml5KuJygRLY7U1wrIXwOzuU/2YGGuwgQ0bVs5DgHIV9Qydh
        ejuLsPy4kJimJzqOhHnCUUaz+xYWTzTjTri+BDA=
X-Google-Smtp-Source: ABdhPJzInDOiwu3SBNEnxLopp+yyHPT+jlMWsmMmA8hJfDIYbOqiZ+3q0QZ/0C+LQePILn8t+zk3RZcYjlJB8iSoGtg=
X-Received: by 2002:a25:6c0a:: with SMTP id h10mr9786570ybc.167.1624429594694;
 Tue, 22 Jun 2021 23:26:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <20210603051836.2614535-11-dkadashev@gmail.com>
 <1a3812fe-1e57-a2ad-dc19-9658c0cf613b@gmail.com>
In-Reply-To: <1a3812fe-1e57-a2ad-dc19-9658c0cf613b@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Jun 2021 13:26:23 +0700
Message-ID: <CAOKbgA489C=ZS_E6YCBFxo+zYNb5ccE4dfFBntAO=qNH7_Uu=A@mail.gmail.com>
Subject: Re: [PATCH v5 10/10] io_uring: add support for IORING_OP_MKNODAT
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 22, 2021 at 6:52 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> > IORING_OP_MKNODAT behaves like mknodat(2) and takes the same flags and
> > arguments.
> >
> > Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> > Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> > ---
> >  fs/internal.h                 |  2 ++
> >  fs/io_uring.c                 | 56 +++++++++++++++++++++++++++++++++++
> >  fs/namei.c                    |  2 +-
> >  include/uapi/linux/io_uring.h |  2 ++
> >  4 files changed, 61 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/internal.h b/fs/internal.h
> > index 15a7d210cc67..c6fb9974006f 100644
>
> [...]
>
> >  static bool io_disarm_next(struct io_kiocb *req);
> > @@ -3687,6 +3697,44 @@ static int io_linkat(struct io_kiocb *req, int issue_flags)
> >       io_req_complete(req, ret);
> >       return 0;
> >  }
> > +static int io_mknodat_prep(struct io_kiocb *req,
> > +                         const struct io_uring_sqe *sqe)
> > +{
> > +     struct io_mknod *mkn = &req->mknod;
> > +     const char __user *fname;
> > +
> > +     if (unlikely(req->flags & REQ_F_FIXED_FILE))
> > +             return -EBADF;
>
> IOPOLL won't support it, and the check is missing.
> Probably for other opcodes as well.
>
> if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>         return -EINVAL;

This change is based on some other similar opcodes (unlinkat, renameat) that
were added a while ago. Those lack the check as well. I guess I'll just prepare
a patch that adds the checks to all of them. Thanks, Pavel.

Jens, separately it's my understanding that you do not want the MKNODAT opcode
at all, should I drop this from the subsequent series?

-- 
Dmitry Kadashev
