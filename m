Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EDA30A639
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 12:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhBALJz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 06:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbhBALJx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 06:09:53 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F773C061573;
        Mon,  1 Feb 2021 03:09:13 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id m20so7624079ilj.13;
        Mon, 01 Feb 2021 03:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YzQvdlXctMa3+sQViAWK7yy7v5HM0rc2edAXiDeXkEU=;
        b=t2O2A6P6hQn+lUsxuJtA99W922Cz3eDRmxcmVFpCESBDUW2DuVQ00It5WD5XhD1g69
         cZjx/34Kv0D6j+VqKA+zS8liVa3aRjdUn+CwStziq4NwBR4RCP55YlUkBFK9BFSvwkwj
         A4UU8mhLtQNh7O7fZuiB+upsw6BQ19Xu5eMnGuQKBrwkTmCkxB8+mTtd4lT8TVqxeTQ3
         DhWWxlF8ZOR7tNz0znKKPfHxgbW/aK90w2yLFGlI0aQ8n2K/e2pBtbGKAVmgdOUa6G9S
         c0XSfkyM5pYc1QzbZPO93FRrNqXVpUh5Civ/UGCLKmGYdu5mTRO/+OWc/ofuZZtMH+3x
         0TEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YzQvdlXctMa3+sQViAWK7yy7v5HM0rc2edAXiDeXkEU=;
        b=LKEYMUN3mXCs5noi1z2D8WLasJoFeqON/jinVbLlW/EeUPN6miCyEn3JQfpkdjgeIT
         rH6sWnRple0vHNSgx2zm/H0QItjbf9Ja8XRvcXWd/4yJmZr8jC3KZVraao1Cfw+eEBtg
         Ct3sFmy7x8YPYeErivl8yY1emyVsFcEarRoyjO+737P/dLI6HMf3A3PtE1oZyMMfpPqZ
         G+6MsEgLonbOKLONEGcNrAanpwBUyDAEfxDmwy9WQDC/dLeEnCx2eWirTjeGqB4gDiP5
         tDplhuk7W8wtEpy+Y/rQjVtF4dZDqMktec3SVi4gG8lIABHPNtb5+w/CFPNvrWaRaTD4
         hR/g==
X-Gm-Message-State: AOAM531d6EdjOIt4A+8Hh8OuwhVHgHxNfRO9r+N/WaUWxFm4JrKRWvuy
        tgDnW7QuBxpXqWjKW7tkdzsSy4mO571MkTX9QxE=
X-Google-Smtp-Source: ABdhPJwhKRaRns5u2A3UiVbAM3UwNpo0F1F9rYFD3EVVEOS+W1z/fj1Pv2tYse0yftoyDDLPArHC/f22UvSbCs2YG0w=
X-Received: by 2002:a92:2c06:: with SMTP id t6mr11632960ile.92.1612177752835;
 Mon, 01 Feb 2021 03:09:12 -0800 (PST)
MIME-Version: 1.0
References: <20201116044529.1028783-1-dkadashev@gmail.com> <20201116044529.1028783-2-dkadashev@gmail.com>
 <027e8488-2654-12cd-d525-37f249954b4d@kernel.dk> <20210126225504.GM740243@zeniv-ca>
In-Reply-To: <20210126225504.GM740243@zeniv-ca>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 1 Feb 2021 18:09:01 +0700
Message-ID: <CAOKbgA4fTyiU4Xi7zqELT+WeU79S07JF4krhNv3Nq_DS61xa-A@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: make do_mkdirat() take struct filename
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 27, 2021 at 5:55 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Sun, Jan 24, 2021 at 09:38:19PM -0700, Jens Axboe wrote:
> > On 11/15/20 9:45 PM, Dmitry Kadashev wrote:
> > > Pass in the struct filename pointers instead of the user string, and
> > > update the three callers to do the same. This is heavily based on
> > > commit dbea8d345177 ("fs: make do_renameat2() take struct filename").
> > >
> > > This behaves like do_unlinkat() and do_renameat2().
> >
> > Al, are you OK with this patch? Leaving it quoted, though you should
> > have the original too.
>
> > > -static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
> > > +long do_mkdirat(int dfd, struct filename *name, umode_t mode)
> > >  {
> > >     struct dentry *dentry;
> > >     struct path path;
> > >     int error;
> > >     unsigned int lookup_flags = LOOKUP_DIRECTORY;
> > >
> > > +   if (IS_ERR(name))
> > > +           return PTR_ERR(name);
> > > +
> > >  retry:
> > > -   dentry = user_path_create(dfd, pathname, &path, lookup_flags);
> > > -   if (IS_ERR(dentry))
> > > -           return PTR_ERR(dentry);
> > > +   name->refcnt++; /* filename_create() drops our ref */
> > > +   dentry = filename_create(dfd, name, &path, lookup_flags);
> > > +   if (IS_ERR(dentry)) {
> > > +           error = PTR_ERR(dentry);
> > > +           goto out;
> > > +   }
>
> No.  This is going to be a source of confusion from hell.  If anything,
> you want a variant of filename_create() that does not drop name on
> success.  With filename_create() itself being an inlined wrapper
> for it.

Hi Al,

I think I need more guidance here. First of all, I've based that code on
commit 7cdfa44227b0 ("vfs: Fix refcounting of filenames in fs_parser"), which
does exactly the same refcount bump in fs_parser.c for filename_lookup().  I'm
not saying it's a good excuse to introduce more code like that if that's a bad
code though.

What I _am_ saying is we probably want to make the approaches consistent (at
least eventually), which means we'd need the same "don't drop the name" variant
of filename_lookup? And given the fact filename_parentat (used from
filename_create) drops the name on error it looks like we'd need another copy of
it too? Do you think it's really worth it or maybe all of these functions will
make things more confusing? (from the looks of it right now the convention is
that the `struct filename` ownership is always transferred when it is passed as
an arg)

Also, do you have a good name for such functions that do not drop the name?

And, just for my education, can you explain why the reference counting for
struct filename exists if it's considered a bad practice to increase the
reference counter (assuming the cleanup code is correct)?

Thanks.

-- 
Dmitry Kadashev
