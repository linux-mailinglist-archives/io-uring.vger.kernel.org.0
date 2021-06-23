Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02DB3B1409
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 08:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFWGnn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 02:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhFWGnn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 02:43:43 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0B9C061574;
        Tue, 22 Jun 2021 23:41:26 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id q64so2521807qke.7;
        Tue, 22 Jun 2021 23:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VLKL/JbywwcoMVqRPpfidUvcm/pM/rQrVd2QI+EWk9s=;
        b=LICfnK5kg9w0q1xG5FL5MSZ7BBtOOzLOx2z9n01j23gIvupbAnbhngkHqxnR16Gn8F
         BVTzBo+61M5EeIhAvcz3OiDTlr1WEvX/tdgLG8Hl6kwwMNB8eiCpF9Z6QTgZTCSQ6k2F
         PWYMP7+wN/fr+e5zTdXFKblixFhOS6k/z64LAkux8EyBjis9HXw/1RzAZu0/xZ2yDshQ
         uyH4Szyi4USUf4tlKP9y1k/tGk15fH5B4oTUHVLB6ByBOsP/TatEsUJD07f/rzDYbxkY
         jrEtk5QNzZKJ+6wc4UIYHNQPkg9FQ7U5WdRub5w5iQ/SX3pQfAiOOljRjDir5jgSsb3Q
         zkRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VLKL/JbywwcoMVqRPpfidUvcm/pM/rQrVd2QI+EWk9s=;
        b=GtcefLmNuTmWsYH9j2H2/C5elvgS/7Ulzu77RZ4jlUOZSlO7cHn5/MS09WwX/9CQAD
         bGqkQiWOexDuhi2yvaKNgXEhL5OmBB3DiXp2PiBpZKYQT6WDOqb1adZXhzPae29ohOSp
         s19VjMF0gQQ+CHc/5PfDEsVRyOc+cA/kq0xLj3cMa9YveO76JcNNVN3ifExME947tFFY
         /z2MvxMuGSYEl6PFUCFY8SgR+FsUqI8id9k88KGsR4S9p/ev7OQv8/a9Ul9bKYQfm5F8
         /RoZP9EeM7MQVD4ltHySxpcd2f+Z3/P1gmc63IIeeXPsdou5D3JATDcURMZWuCNC/Z94
         Xfuw==
X-Gm-Message-State: AOAM530S5c96EtZLcgi3m1dMikgZmKwLXEtQtTjnFCpRvdAzxtN8Lf9O
        kvWEBunaFb8L/QD5CpgwdW7liJeFyYQJga9208U=
X-Google-Smtp-Source: ABdhPJwtJclNFxYg/klIKFecu3iufJhXEA0AN2rBQ1dNSRt2LLUcl1/rSIkQ/wihKYnur0Z0MjdKLJ1Nnf0EKMHP/q4=
X-Received: by 2002:a25:9bc4:: with SMTP id w4mr9416755ybo.168.1624430485607;
 Tue, 22 Jun 2021 23:41:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <20210603051836.2614535-3-dkadashev@gmail.com>
 <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com> <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
In-Reply-To: <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Jun 2021 13:41:14 +0700
Message-ID: <CAOKbgA4ZwzUxyRxWrF7iC2sNVnEwXXAmrxVSsSxBMQRe2OyYVQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 22, 2021 at 6:50 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/22/21 12:41 PM, Pavel Begunkov wrote:
> > On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> >> IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
> >> and arguments.
> >>
> >> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> >> ---
> >>  fs/io_uring.c                 | 55 +++++++++++++++++++++++++++++++++++
> >>  include/uapi/linux/io_uring.h |  1 +
> >>  2 files changed, 56 insertions(+)
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index a1ca6badff36..8ab4eb559520 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -665,6 +665,13 @@ struct io_unlink {
> >>      struct filename                 *filename;
> >>  };
> >>
> >> +struct io_mkdir {
> >> +    struct file                     *file;
> >> +    int                             dfd;
> >> +    umode_t                         mode;
> >> +    struct filename                 *filename;
> >> +};
> >> +
> >>  struct io_completion {
> >>      struct file                     *file;
> >>      struct list_head                list;
> >> @@ -809,6 +816,7 @@ struct io_kiocb {
> >>              struct io_shutdown      shutdown;
> >>              struct io_rename        rename;
> >>              struct io_unlink        unlink;
> >> +            struct io_mkdir         mkdir;
> >>              /* use only after cleaning per-op data, see io_clean_op() */
> >>              struct io_completion    compl;
> >>      };
> >> @@ -1021,6 +1029,7 @@ static const struct io_op_def io_op_defs[] = {
> >>      },
> >>      [IORING_OP_RENAMEAT] = {},
> >>      [IORING_OP_UNLINKAT] = {},
> >> +    [IORING_OP_MKDIRAT] = {},
> >>  };
> >>
> >>  static bool io_disarm_next(struct io_kiocb *req);
> >> @@ -3530,6 +3539,44 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
> >>      return 0;
> >>  }
> >>
> >> +static int io_mkdirat_prep(struct io_kiocb *req,
> >> +                        const struct io_uring_sqe *sqe)
> >> +{
> >> +    struct io_mkdir *mkd = &req->mkdir;
> >> +    const char __user *fname;
> >> +
> >> +    if (unlikely(req->flags & REQ_F_FIXED_FILE))
> >> +            return -EBADF;
> >> +
> >> +    mkd->dfd = READ_ONCE(sqe->fd);
> >> +    mkd->mode = READ_ONCE(sqe->len);
> >> +
> >> +    fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
> >> +    mkd->filename = getname(fname);
> >> +    if (IS_ERR(mkd->filename))
> >> +            return PTR_ERR(mkd->filename);
> >
> > We have to check unused fields, e.g. buf_index and off,
> > to be able to use them in the future if needed.
> >
> > if (sqe->buf_index || sqe->off)
> >       return -EINVAL;
> >
> > Please double check what fields are not used, and
> > same goes for all other opcodes.

This changeset is based on some other ops that were added a while ago
(renameat, unlinkat), which lack the check as well. I guess I'll just go over
all of them and add the checks in a single patch if that's OK.

I'd imagine READ_ONCE is to be used in those checks though, isn't it? Some of
the existing checks like this lack it too btw. I suppose I can fix those in a
separate commit if that makes sense.

>
> + opcode specific flags, e.g.
>
> if (sqe->rw_flags)
>         return -EINVAL;

-- 
Dmitry Kadashev
