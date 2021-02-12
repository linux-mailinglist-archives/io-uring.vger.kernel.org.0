Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671DE319C09
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 10:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBLJno (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 04:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBLJnl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 04:43:41 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFB7C061574;
        Fri, 12 Feb 2021 01:43:00 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id m17so8652966ioy.4;
        Fri, 12 Feb 2021 01:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3S5RLTLok1pQUJwa2EYNw4MYnr3DPOV2Q+scsowAtbc=;
        b=h1bUpwNW9Q9tprM2WJ7Wz15LkBh2uYIjoRKVNHISj7E1NSJYhPFVKjbUs8QhWVsS2y
         uFIsF44CAhAEPwesU904/8HzAypQaUXGVjLPTdywfgtgdFAsRLdNktsfpb9hdwTULHQG
         g5Sbcnx236BkX2HdR2MyN9rlYN2iC2LpJJD3fzh6zcNDcBb+8IxHPM76tlhUn49Ft0GJ
         MqfTkb8sgO1Avr138xz58oThd4ACHS/wre8uuLs9Ka5+5CfJoXV3z0nvuTxXKR0A21tN
         elgEcqt8Dppr5suYpggIF6kCxlujNYJK/mHK35FHBFK0epDfQRWuokzduk41kOjTpXz/
         6ZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3S5RLTLok1pQUJwa2EYNw4MYnr3DPOV2Q+scsowAtbc=;
        b=EQUq8cGmeYtzQ16KH9hphfqynSi/ZJ7eCGdhVfW0reftf9GS7ytxRpWQk7/UYf+ekN
         XK/FFl1A91XUDrIlRvwAnVc5ZPexbgStXGfHIKLj52DfZtKMzMa2nLB1s5QfLoGtm7Rt
         XwiSIQoh2ZcAkvEf4eqsVHeHwnAisNBHxk/UmKMm7j4nlcZM5y8rIG5TqrkJcpveg4vV
         pBeQCIROtrJWUTazzS5L9fGw3Lc3NwFIoGuOVPaTnAi6wNabNAE8Ckcb67A5u6EoPRwL
         JXNLYCoRf1iI/YF67BtEDMr4uhdfZT1OGw6b+sxgDbPmmsirDAPhQdlUe/kboxWLOLNw
         ZOuw==
X-Gm-Message-State: AOAM530Phq3z7o1lht2SZ4sOTRre5F+JkyI2h4THxbUeaCubw4HFAGCF
        K3CeyvetIwo522I4uPu8J52h7Xsjbb3kAAzXZXc=
X-Google-Smtp-Source: ABdhPJwNrVQzk76irgDYoKO+++bE9yFzzDAWVdMpGNevJaJbEN8cW6/05m8Xj+XLVT0Fqrr0ZFa4hj+otA6SGmSLfxE=
X-Received: by 2002:a05:6638:1928:: with SMTP id p40mr1912460jal.3.1613122980432;
 Fri, 12 Feb 2021 01:43:00 -0800 (PST)
MIME-Version: 1.0
References: <20210202082353.2152271-1-dkadashev@gmail.com> <20210202082353.2152271-2-dkadashev@gmail.com>
In-Reply-To: <20210202082353.2152271-2-dkadashev@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Fri, 12 Feb 2021 16:42:49 +0700
Message-ID: <CAOKbgA7fBRpnkjvDRynZcyHxB_L6NYNCprwUtz+HwxqcqiJcLA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] fs: make do_mkdirat() take struct filename
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 2, 2021 at 3:25 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> Pass in the struct filename pointers instead of the user string, and
> update the three callers to do the same. This is heavily based on
> commit dbea8d345177 ("fs: make do_renameat2() take struct filename").
>
> This behaves like do_unlinkat() and do_renameat2().
>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---
>  fs/internal.h |  1 +
>  fs/namei.c    | 25 +++++++++++++++++++------
>  2 files changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/fs/internal.h b/fs/internal.h
> index c6c85f6ad598..b10005dfaa48 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -76,6 +76,7 @@ long do_unlinkat(int dfd, struct filename *name);
>  int may_linkat(struct path *link);
>  int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
>                  struct filename *newname, unsigned int flags);
> +long do_mkdirat(int dfd, struct filename *name, umode_t mode);
>
>  /*
>   * namespace.c
> diff --git a/fs/namei.c b/fs/namei.c
> index 4cae88733a5c..3657bdf1aafc 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3431,7 +3431,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
>         return file;
>  }
>
> -static struct dentry *filename_create(int dfd, struct filename *name,
> +static struct dentry *__filename_create(int dfd, struct filename *name,
>                                 struct path *path, unsigned int lookup_flags)
>  {
>         struct dentry *dentry = ERR_PTR(-EEXIST);
> @@ -3487,7 +3487,6 @@ static struct dentry *filename_create(int dfd, struct filename *name,
>                 error = err2;
>                 goto fail;
>         }
> -       putname(name);
>         return dentry;
>  fail:
>         dput(dentry);
> @@ -3502,6 +3501,16 @@ static struct dentry *filename_create(int dfd, struct filename *name,
>         return dentry;
>  }
>
> +static inline struct dentry *filename_create(int dfd, struct filename *name,
> +                               struct path *path, unsigned int lookup_flags)
> +{
> +       struct dentry *res = __filename_create(dfd, name, path, lookup_flags);
> +
> +       if (!IS_ERR(res))
> +               putname(name);
> +       return res;
> +}
> +
>  struct dentry *kern_path_create(int dfd, const char *pathname,
>                                 struct path *path, unsigned int lookup_flags)
>  {
> @@ -3654,15 +3663,18 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  }
>  EXPORT_SYMBOL(vfs_mkdir);
>
> -static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
> +long do_mkdirat(int dfd, struct filename *name, umode_t mode)
>  {
>         struct dentry *dentry;
>         struct path path;
>         int error;
>         unsigned int lookup_flags = LOOKUP_DIRECTORY;
>
> +       if (IS_ERR(name))
> +               return PTR_ERR(name);
> +
>  retry:
> -       dentry = user_path_create(dfd, pathname, &path, lookup_flags);
> +       dentry = __filename_create(dfd, name, &path, lookup_flags);
>         if (IS_ERR(dentry))
>                 return PTR_ERR(dentry);
>
> @@ -3676,17 +3688,18 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
>                 lookup_flags |= LOOKUP_REVAL;
>                 goto retry;
>         }
> +       putname(name);
>         return error;
>  }
>
>  SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
>  {
> -       return do_mkdirat(dfd, pathname, mode);
> +       return do_mkdirat(dfd, getname(pathname), mode);
>  }
>
>  SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
>  {
> -       return do_mkdirat(AT_FDCWD, pathname, mode);
> +       return do_mkdirat(AT_FDCWD, getname(pathname), mode);
>  }
>
>  int vfs_rmdir(struct inode *dir, struct dentry *dentry)
> --
> 2.30.0

Hi Al,

Are you OK with this version?

-- 
Dmitry Kadashev
