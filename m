Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412203B13BB
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 08:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFWGMG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 02:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWGMF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 02:12:05 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D98AC061574;
        Tue, 22 Jun 2021 23:09:48 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id g4so2438784qkl.1;
        Tue, 22 Jun 2021 23:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YRY58gbIUIlCY/rSeJH8+ECPvoOOlIlyVFcl07+b0VE=;
        b=oAl+gHuPuyxhk0ycCrQAeSI+2LOuzcsXDEaVsaAHf1DKs90x4McVLecNeVjAMnt9DL
         56PproESoucKHYIfpIMJB0UzpX1P7OJyPGAsMADJwOfOV+M1AcbLnGn7uEHnSVV5FdCC
         DfywV+8b0i14KdYV1m3kzTe5lwcaAjnUPlg27U+Yc+3df5Wmy+5+li7Sb5JYCCf6n5rQ
         cdCvoKqw7DM2ekek2TDxuFGjF4bnqwl5LirmJMKYoz/3EHTg7cXi0pmA/XiAa8xfHJyy
         JkeGvMx8FlOwwyVKBIm2rXDmddsuefAIlJlJwuMa4rsECnTsu0JySj3xmkqPpTV7xFHt
         U+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YRY58gbIUIlCY/rSeJH8+ECPvoOOlIlyVFcl07+b0VE=;
        b=mXAEH7WP7tHNqgswn9cf2tU7YjEImVJNqHFvFhKc7rfJKFde+roPmTFyejvfNyhj3U
         aFZWM++tTGTQ7vmlFf7ct5HBjvNkDIgkSLmPP2mRxHnVfXgoQ7DB15RUpRP/BFBOZu1K
         HwgHzGiKIyiTF3sP2U3E4dcL7LHEzZIWbFlnJe6wZZw+GCwkk7AfbX/8qD2An+t629om
         jnqP91Wv/sG8csjaSrl0hZ1vvT4Tb2wkVCu/q1fq/Fl0/aAi9XklKeQOQLjJiR4Z60m8
         tZIz2i7yo4/So6bPpSga4Fq/mITdNvTklRtcyeQKmVtxFYshc/R6rHDS2ZZ/k0iEd0t3
         CsSg==
X-Gm-Message-State: AOAM532dp4HNkOelKn9rTgTkYT98+Zt6CyCp2REIDqLE0LFbygI740mH
        Gx+D3VZsqhaXz4THTrWF4sRaN+WRGfkEJdBygJA=
X-Google-Smtp-Source: ABdhPJx153FvDFQv9ts7odmVICh/Wp24UD3HKCV3iA4vi8zsKjxYyXYLvJ8CEwpXyGbQgtTDo70et6+3AOlxcE9Wwps=
X-Received: by 2002:a5b:ac1:: with SMTP id a1mr10464021ybr.289.1624428587786;
 Tue, 22 Jun 2021 23:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <20210603051836.2614535-10-dkadashev@gmail.com>
 <77b4b24f-b905-ed36-b70e-657f08de7fd1@gmail.com>
In-Reply-To: <77b4b24f-b905-ed36-b70e-657f08de7fd1@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Jun 2021 13:09:36 +0700
Message-ID: <CAOKbgA71puEF4Te+svaRD1MRYEpkQOLigq5xQu85Ch4rDO7_Rw@mail.gmail.com>
Subject: Re: [PATCH v5 09/10] io_uring: add support for IORING_OP_LINKAT
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 22, 2021 at 6:48 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> > IORING_OP_LINKAT behaves like linkat(2) and takes the same flags and
> > arguments.
> >
> > In some internal places 'hardlink' is used instead of 'link' to avoid
> > confusion with the SQE links. Name 'link' conflicts with the existing
> > 'link' member of io_kiocb.
> >
> > Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> > Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> > ---
> >  fs/internal.h                 |  2 ++
> >  fs/io_uring.c                 | 67 +++++++++++++++++++++++++++++++++++
> >  fs/namei.c                    |  2 +-
> >  include/uapi/linux/io_uring.h |  2 ++
> >  4 files changed, 72 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/internal.h b/fs/internal.h
> > index 3b3954214385..15a7d210cc67 100644
> > --- a/fs/internal.h
> > +++ b/fs/internal.h
>
> [...]
> > +
> > +static int io_linkat(struct io_kiocb *req, int issue_flags)
> > +{
> > +     struct io_hardlink *lnk = &req->hardlink;
> > +     int ret;
> > +
> > +     if (issue_flags & IO_URING_F_NONBLOCK)
> > +             return -EAGAIN;
> > +
> > +     ret = do_linkat(lnk->old_dfd, lnk->oldpath, lnk->new_dfd,
> > +                             lnk->newpath, lnk->flags);
>
> I'm curious, what's difference b/w SYMLINK and just LINK that
> one doesn't use old_dfd and another does?

Symlink's content does not have to exist, it's pretty much an arbitrary string.
E.g. try `ln -s http://example.com/ foo` :)

> Can it be supported/wished by someone in the future?

I don't really know. I guess it could be imagined that someone wants to try and
resolve the full target name against some dfd. But to me the whole idea looks
inherently problematic. Accepting the old dfd feels like the path is going to
be resolved, and historically it is not the case, and we'd need a special dfd
value to mean "do not resolve", and AT_FDCWD won't work for this (since it
means "resolve against the CWD", not "do not resolve").

> In that case I'd rather reserve and verify a field for old_dfd for both, even
> if one won't really support it for now.

If I understand you correctly, at this point you mean just checking that
old_dfd is not set (i.e. == -1)? I'll add a check.

-- 
Dmitry Kadashev
