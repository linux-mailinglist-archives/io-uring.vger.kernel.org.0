Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A108B30213E
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 05:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbhAYEjJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Jan 2021 23:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbhAYEjF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Jan 2021 23:39:05 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3B6C06174A
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 20:38:21 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id h15so4339638pli.8
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 20:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rlMwQ4UjBqmcnnv1HhqFR3ddy1dMdXnd73kPoCOEZvE=;
        b=yisTh96BqCkWR0r0M/ANAEEgksMvN0KVBU/cXRNOSB9gT3E47W3ZSagLUVoJSLTGkR
         Zsk13ZZzvxn9v8LuBERIJ4suZIBb3mfgydATGN6t2XGPI+0voxL/hdolqAoW/QAxDxCY
         KL5T1syIcS7UReS9L7JJkxKJDg/ia3U4RxrcKmMzwvQHWFwCh+bEtq7FLTbJvvCx7hA6
         1KaLsFYZZAKbEyXIbzWgw35q0swdIsshIkN5I7UT2lU1SnrpxDmFRUWkTDczpsdi+Ekw
         Q1tdIzJzy6YEuFa163hN9J9ofmjzEUtFz7O7cfUYE4ngYNxnerCsCTmmlFTzuAoDCzh9
         cREg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rlMwQ4UjBqmcnnv1HhqFR3ddy1dMdXnd73kPoCOEZvE=;
        b=L+s43rz8OTvx+mhWH75nkCgvWqLE6A+Z+QQZH38HodS2iFyWlm1owTkwfqhdNqTI7d
         1ABPChiBv1UyIGAseuDDc3U9/C5y8P1nPoHsfPCJODSIoWiyKs86GK5N/fjD9oETs9px
         dUoh0yEZVwlY9YOP5nnWj5QQAVsYH4En2WFgs/aTRJCvxDYNuv0D0CT1NvaCH1+Z6HeC
         Ar8YS/u68IT4rrVT1TuofUQXHjZFpNLWviSKMufvgcgW3wLg5O+TbFPYdZ/IV5ZB9R3o
         MRTiVl4CeR5WyJLZbcEFylKM2SNAo1/WxZGdIV8hMQkoCRb1Q2/3f5x3x8BY33hwXLYl
         vX6w==
X-Gm-Message-State: AOAM5302pdbriVst0J4Rz2ztqFEZpMu02g3wEhNIDC/hcXZHBK4OMtYj
        DYuZJbYKeu0JHTbLXwcnPbXMwxnsMY9JTQ==
X-Google-Smtp-Source: ABdhPJyFGLdEb+gj8r0CQ9KO/ejVuv34dIniR9rCF1+N6QiTicDB6ra3qUnKXSowzZP3twaAnFB8Fw==
X-Received: by 2002:a17:90a:1e65:: with SMTP id w92mr19679023pjw.64.1611549501368;
        Sun, 24 Jan 2021 20:38:21 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x125sm14516720pgb.35.2021.01.24.20.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 20:38:20 -0800 (PST)
Subject: Re: [PATCH 1/2] fs: make do_mkdirat() take struct filename
To:     Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
References: <20201116044529.1028783-1-dkadashev@gmail.com>
 <20201116044529.1028783-2-dkadashev@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <027e8488-2654-12cd-d525-37f249954b4d@kernel.dk>
Date:   Sun, 24 Jan 2021 21:38:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201116044529.1028783-2-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/15/20 9:45 PM, Dmitry Kadashev wrote:
> Pass in the struct filename pointers instead of the user string, and
> update the three callers to do the same. This is heavily based on
> commit dbea8d345177 ("fs: make do_renameat2() take struct filename").
> 
> This behaves like do_unlinkat() and do_renameat2().

Al, are you OK with this patch? Leaving it quoted, though you should
have the original too.

> 
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---
>  fs/internal.h |  1 +
>  fs/namei.c    | 20 ++++++++++++++------
>  2 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 6fd14ea213c3..23b8b427dbd2 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -80,6 +80,7 @@ long do_unlinkat(int dfd, struct filename *name);
>  int may_linkat(struct path *link);
>  int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
>  		 struct filename *newname, unsigned int flags);
> +long do_mkdirat(int dfd, struct filename *name, umode_t mode);
>  
>  /*
>   * namespace.c
> diff --git a/fs/namei.c b/fs/namei.c
> index 03d0e11e4f36..9d26a51f3f54 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3654,17 +3654,23 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  }
>  EXPORT_SYMBOL(vfs_mkdir);
>  
> -static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
> +long do_mkdirat(int dfd, struct filename *name, umode_t mode)
>  {
>  	struct dentry *dentry;
>  	struct path path;
>  	int error;
>  	unsigned int lookup_flags = LOOKUP_DIRECTORY;
>  
> +	if (IS_ERR(name))
> +		return PTR_ERR(name);
> +
>  retry:
> -	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
> -	if (IS_ERR(dentry))
> -		return PTR_ERR(dentry);
> +	name->refcnt++; /* filename_create() drops our ref */
> +	dentry = filename_create(dfd, name, &path, lookup_flags);
> +	if (IS_ERR(dentry)) {
> +		error = PTR_ERR(dentry);
> +		goto out;
> +	}
>  
>  	if (!IS_POSIXACL(path.dentry->d_inode))
>  		mode &= ~current_umask();
> @@ -3676,17 +3682,19 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
>  		lookup_flags |= LOOKUP_REVAL;
>  		goto retry;
>  	}
> +out:
> +	putname(name);
>  	return error;
>  }
>  
>  SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
>  {
> -	return do_mkdirat(dfd, pathname, mode);
> +	return do_mkdirat(dfd, getname(pathname), mode);
>  }
>  
>  SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
>  {
> -	return do_mkdirat(AT_FDCWD, pathname, mode);
> +	return do_mkdirat(AT_FDCWD, getname(pathname), mode);
>  }
>  
>  int vfs_rmdir(struct inode *dir, struct dentry *dentry)
> 


-- 
Jens Axboe

