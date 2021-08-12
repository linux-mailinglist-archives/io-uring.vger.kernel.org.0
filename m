Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D5F3EA6A5
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 16:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbhHLOd2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 10:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238072AbhHLOd1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 10:33:27 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43179C0617A8
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 07:33:02 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id go31so11978833ejc.6
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 07:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tf3TpEvP9E7186InLyyaf92hJ3EmJ36m+RywVZpSgPY=;
        b=R/MuhpWp9RvhseRjm4R0jGRMhlHQsOmEJE1n2UUz0eGJ/hijPkEUFgXK1gUyCDZsN4
         GOJMZdHsaYi6ZpN2Qg2ML12TUevHGmF40wJBD3TVT612ErE7duytSyU5zvwCRExQTL8m
         5gkvg3x8jeY8EFUNS3dfNUKLt31Zot49diHU1ua9oWvrU2f5P1DwegTgSdWXMqoLeTV0
         FRCueROZZsOmtAmIT9Zm7916s1YUYohTZzvUvjdDlrTLl0iBlkS0K80nyMKP+AVY0sqg
         n3gQDqdWk7cPkxkXRfkLunbkGT6cAAaTGP3BC7O3rwIQuNWWx9PcPczRmfwKJ+D1U3B0
         NzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tf3TpEvP9E7186InLyyaf92hJ3EmJ36m+RywVZpSgPY=;
        b=YFGW/h8G7/iHUfrffrAqUVLt1HNjZzCoSbP69U7A7ntvLYptTunItKdxuuRFtuMyp2
         JRXCj1yu05sN6i4f3Xs4EQK0b6DDAIiUbondSrTW3fZe6s2nmXuZe/skxqcYzBZKiQMM
         miA8L26ST0i7E4qDXwkn27d8Emr0rG3sgnNGiK9Rx8HrGP5HfMvW26telEd66IKLjBdh
         hyrqKBEO+0/jL0FyRNx6Mj9g74k7slxx5rJAVxmeJ3usu70LXgpC9F6oJrEJ7hXeAyLR
         r/cwLL7YcnXY+fAPR5I+g1fac4Zw+kG1bceAfX7A2BmemSZJSlLCbI5Jtcnq5+/nE6rh
         TC6A==
X-Gm-Message-State: AOAM531lgDZl+BqHtUxNV3dIqpoxnaQRtwS+oFrlf4w7Psmi81WadBjK
        NoUaeXZGd6PZrSmuiXe4bl5rvpQo7Bb6fHU5+JoVvNmx5zdB4tU=
X-Google-Smtp-Source: ABdhPJzAG+KxRcFQg5frwrLx7u2ThZW6azkYAv7FMiBSgbLG3jxMShQvp886ILKHc2KwMX5wMmNXVbVHSV9qauldwmg=
X-Received: by 2002:a17:907:3345:: with SMTP id yr5mr3971377ejb.542.1628778780618;
 Thu, 12 Aug 2021 07:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <162871480969.63873.9434591871437326374.stgit@olly>
 <162871492283.63873.8743976556992924333.stgit@olly> <1d19ca85-c6f9-7aa5-162a-f9728e0a8ccd@digikod.net>
In-Reply-To: <1d19ca85-c6f9-7aa5-162a-f9728e0a8ccd@digikod.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 12 Aug 2021 10:32:49 -0400
Message-ID: <CAHC9VhRe3cgYuaV7w-BUwj_i=8_uuy3+5-8oA6QVsdXp3JgVtw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/9] fs: add anon_inode_getfile_secure() similar to anon_inode_getfd_secure()
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 12, 2021 at 5:32 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> On 11/08/2021 22:48, Paul Moore wrote:
> > Extending the secure anonymous inode support to other subsystems
> > requires that we have a secure anon_inode_getfile() variant in
> > addition to the existing secure anon_inode_getfd() variant.
> >
> > Thankfully we can reuse the existing __anon_inode_getfile() function
> > and just wrap it with the proper arguments.
> >
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
> >
> > ---
> > v2:
> > - no change
> > v1:
> > - initial draft
> > ---
> >  fs/anon_inodes.c            |   29 +++++++++++++++++++++++++++++
> >  include/linux/anon_inodes.h |    4 ++++
> >  2 files changed, 33 insertions(+)
> >
> > diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> > index a280156138ed..e0c3e33c4177 100644
> > --- a/fs/anon_inodes.c
> > +++ b/fs/anon_inodes.c
> > @@ -148,6 +148,35 @@ struct file *anon_inode_getfile(const char *name,
> >  }
> >  EXPORT_SYMBOL_GPL(anon_inode_getfile);
> >
> > +/**
> > + * anon_inode_getfile_secure - Like anon_inode_getfile(), but creates =
a new
> > + *                             !S_PRIVATE anon inode rather than reuse=
 the
> > + *                             singleton anon inode and calls the
> > + *                             inode_init_security_anon() LSM hook.  T=
his
> > + *                             allows for both the inode to have its o=
wn
> > + *                             security context and for the LSM to enf=
orce
> > + *                             policy on the inode's creation.
> > + *
> > + * @name:    [in]    name of the "class" of the new file
> > + * @fops:    [in]    file operations for the new file
> > + * @priv:    [in]    private data for the new file (will be file's pri=
vate_data)
> > + * @flags:   [in]    flags
> > + * @context_inode:
> > + *           [in]    the logical relationship with the new inode (opti=
onal)
> > + *
> > + * The LSM may use @context_inode in inode_init_security_anon(), but a
> > + * reference to it is not held.  Returns the newly created file* or an=
 error
> > + * pointer.  See the anon_inode_getfile() documentation for more infor=
mation.
> > + */
> > +struct file *anon_inode_getfile_secure(const char *name,
> > +                                    const struct file_operations *fops=
,
> > +                                    void *priv, int flags,
> > +                                    const struct inode *context_inode)
> > +{
> > +     return __anon_inode_getfile(name, fops, priv, flags,
> > +                                 context_inode, true);
>
> This is not directly related to this patch but why using the "secure"
> boolean in __anon_inode_getfile() and __anon_inode_getfd() instead of
> checking that context_inode is not NULL? This would simplify the code,
> remove this anon_inode_getfile_secure() wrapper and avoid potential
> inconsistencies.

The issue is that it is acceptable for the context_inode to be either
valid or NULL for callers who request the "secure" code path.

Look at the SELinux implementation of the anonymous inode hook in
selinux_inode_init_security_anon() and you will see that in cases
where the context_inode is valid we simply inherit the label from the
given inode, whereas if context_inode is NULL we do a type transition
using the requesting task and the anonymous inode's "name".

--=20
paul moore
www.paul-moore.com
