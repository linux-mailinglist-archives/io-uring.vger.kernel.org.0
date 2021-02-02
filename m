Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E308430B69B
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 05:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhBBEj5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 23:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbhBBEjz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 23:39:55 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA436C061573;
        Mon,  1 Feb 2021 20:39:14 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id x21so19934197iog.10;
        Mon, 01 Feb 2021 20:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2RIPP8JkySUeXqRq6gkwS6PJg+amwtEBNh61/t1nd+c=;
        b=crgKu/kcvIuwkrKkhwHo+6s72RksutLbBzEDCuDsF/BffYEWsWAr1ZatTZPBgyQyjL
         9IHUn5UDFOEilfCWHNyox2LxN0oF1g+XTHN4YACfBkTi7iSNEUgBvzqgESU8ESlbeUuI
         rimRMLKADJilc0Quyrq2DU5z1otSgEmhUSFwAtU1flpPIiIFiWVVUerqnM+Y1xoA3AXG
         L7QGwzsrzIhjzPT8m2Jot2mfimnxCKGo/IOQUApanSZZMQCPRwZ/3gWR8RzzyKCRWH6A
         sVgE2TmfXA7ovOo36bP1qkmPs038R1byWjBAlauTRsXKLwj+Fcm6sMpyoQsXAsEUV7ZR
         RniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2RIPP8JkySUeXqRq6gkwS6PJg+amwtEBNh61/t1nd+c=;
        b=LlLsxLI6qrNhpHoHTs8l9e3iEI4C1P2uIwU1LQ9RbigaG1qH06jeGoWQEuw1OUcg0P
         /30guI8LjCpWf0aKJ6u6k26l0RFf7CpMLpJWPfV/BPrFnSiZkTliI2f8zmT7w9BHUVhS
         oSsH/t0kEL1xJmyT7at7MQrmerjIrP8yAk/cotmw5GLotAnMk0cvxaqYG4BT8HxAaRFo
         MpHuAUG+IIyhr8unGXeqbRNRtjAm+z795kDymZBfx2+DAMIaOCRkICLAsZMXaFdszimy
         A2QcsW6lG/l8AOG4PZt0q1KzxWqkWLj+20ndKCetaIzCpi688AwBB6Db7KcSnn0UnkGs
         u3Jg==
X-Gm-Message-State: AOAM531tsVAr4B56ZNK4oT4TEXdKxJJgK/KqLe1V4lonUMcxDF6EI00Z
        MshpM68k7AKdv5Xk6jjXE1PNZ4vRf9jAfCTu34Y=
X-Google-Smtp-Source: ABdhPJzrebJOLMb3N07jMLmpZg+pLab3XzdxtQVPJkcm8SzdU6lrbZHtf2OXKJ8F5HKc6jpSxqYQS8ADpOQwrHvF/fY=
X-Received: by 2002:a5d:8887:: with SMTP id d7mr14876206ioo.151.1612240754272;
 Mon, 01 Feb 2021 20:39:14 -0800 (PST)
MIME-Version: 1.0
References: <20201116044529.1028783-1-dkadashev@gmail.com> <20201116044529.1028783-2-dkadashev@gmail.com>
 <027e8488-2654-12cd-d525-37f249954b4d@kernel.dk> <20210126225504.GM740243@zeniv-ca>
 <CAOKbgA4fTyiU4Xi7zqELT+WeU79S07JF4krhNv3Nq_DS61xa-A@mail.gmail.com> <20210201150042.GQ740243@zeniv-ca>
In-Reply-To: <20210201150042.GQ740243@zeniv-ca>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 2 Feb 2021 11:39:03 +0700
Message-ID: <CAOKbgA6uvujF1FB=6AoPVww1uSQmFQdcUrX8DGcgqAnH126g+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: make do_mkdirat() take struct filename
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 1, 2021 at 10:00 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Mon, Feb 01, 2021 at 06:09:01PM +0700, Dmitry Kadashev wrote:
>
> > Hi Al,
> >
> > I think I need more guidance here. First of all, I've based that code on
> > commit 7cdfa44227b0 ("vfs: Fix refcounting of filenames in fs_parser"), which
> > does exactly the same refcount bump in fs_parser.c for filename_lookup().  I'm
> > not saying it's a good excuse to introduce more code like that if that's a bad
> > code though.
>
> It is a bad code.  If you look at that function, you'll see that the entire
> mess around put_f is rather hard to follow and reason about.  That's a function
> with no users, and I'm not sure we want to keep it long-term.

But the reason for the put_f mess is the fact that the function accepts either a
string (which it resolves to a struct filename that it then owns) or a struct
filename (that it does not own), not the meddling with the refcount. I'm not
trying to argue that we should do the meddling though, I'm fine with the other
approach.

> > What I _am_ saying is we probably want to make the approaches consistent (at
> > least eventually), which means we'd need the same "don't drop the name" variant
> > of filename_lookup?
>
> "don't drop the name on success", similar to what filename_parentat() does.

OK, that makes things much simpler.

> > And given the fact filename_parentat (used from
> > filename_create) drops the name on error it looks like we'd need another copy of
> > it too?
>
> No need.

OK.

> > Do you think it's really worth it or maybe all of these functions will
> > make things more confusing? (from the looks of it right now the convention is
> > that the `struct filename` ownership is always transferred when it is passed as
> > an arg)
> >
> > Also, do you have a good name for such functions that do not drop the name?
> >
> > And, just for my education, can you explain why the reference counting for
> > struct filename exists if it's considered a bad practice to increase the
> > reference counter (assuming the cleanup code is correct)?
>
> The last one is the easiest to answer - we want to keep the imported strings
> around for audit.  It's not so much a proper refcounting as it is "we might
> want freeing delayed" implemented as refcount.
>
> As for do_mkdirat(), you probably want semantics similar to do_unlinkat(), i.e.
> have it consume the argument passed to it.  The main complication comes
> from ESTALE retries; want -ESTALE from ->mkdir() itself to trigger "redo
> filename_parentat() with LOOKUP_REVAL, then try the rest one more time".
> For which you need to keep filename around.  OK, so you want a variant of
> filename_create() that would _not_ consume the filename on success (i.e.
> act as filename_parentat() itself does).  Which is trivial to implement -
> just rename filename_create() to __filename_create() and remove one of
> two putname() in there, leaving just the one in failure exits.  Then
> filename_create() itself becomes simply
>
> static inline struct dentry *filename_create(int dfd, struct filename *name,
>                                 struct path *path, unsigned int lookup_flags)
> {
>         struct dentry *res = __filename_create(dfd, name, path, lookup_flags);
>         if (!IS_ERR(res))
>                 putname(name);
>         return res;
> }
>
> and in your do_mkdirat() replacement use
>         dentry = __filename_create(dfd, filename, &path, lookup_flags);
> instead of
>         dentry = user_path_create(dfd, pathname, &path, lookup_flags);
> and add
>         putname(filename);
> in the very end.  All it takes...

Yeah, I just was not sure about naming or whether you'd prefer for other
functions to be changed too. You've answered pretty much all my questions and
even more :)

Thanks a lot Al! I'll post v2 soon (since the audit thing you've discovered does
not affect this patch directly).

--
Dmitry Kadashev
