Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242A52A80CD
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 15:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbgKEOZX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 09:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730465AbgKEOZW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 09:25:22 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10879C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 06:25:22 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id w14so1976661wrs.9
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 06:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ePO72MCBv2a9564rzPXy9aGUUCaNwFJrALT41ol35EU=;
        b=lGupBkH8GJMzTHyhVSSCZ5+/8NnN4ie7OOqVNxI2axFG/QoK5ZcQWUWhI6us2tGznk
         ezI1dFIPaI/cKppuJ8e4+H42aZKYkox8kR5rtCyZhPjA27o3DxLfkpbwaFlG8lSBMcVN
         oYZ5iVmPDRn/vk5CCKzJOwhpAjmOSmvrmmNWuIfZhu/1EggGI0DliSqPZatyvuzV1QTk
         kQu0Mt7SeLPf1EfN5h7E0ZbZlu/ITM9OlXebgR/SBh5tkJ4CerX37Vj7+B7/ToUWQciB
         DPHw31cj/jvWUnIUMer7SwJwdKsAXKjaAdUApBSlXQvR4gTY3WZHDMSWtyc+iJZmtKp0
         ganQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ePO72MCBv2a9564rzPXy9aGUUCaNwFJrALT41ol35EU=;
        b=oU42UOzdhuCxdzSrJL6hY3hOe+DOM7tBZLSWeSSU8aAuCaD/BnFdFmwyEuB2QEFkEy
         g4GEZGt6vYkbBSStlAuJ98vx1u3S6iKxazzJ4YuFM6A3NKfgrn03quyBgu7FXmCwJJ4Y
         R/2HJNhDWsbiF+rlCh/0W+RHUifOpi+mS4b28EktQ8c8OQa31VrhaIczFOLEh5mTBWgl
         2i8Q9XSeZmZzbrzsFuJmJm3/gFemm9oR/TIAoRIEsi1thyIiYzcGeFzwykxr+Ekn+V1b
         1N1VOymRU9q9bmSUXfV7w8jLtK+0Evz2T2F8zCgNxueOO25nLyTMbf7JB6O6mJnwB4eZ
         fTLA==
X-Gm-Message-State: AOAM533V4BcnBjd9+2a1bZnRkS/1wXP/XvB/3j9WHPXgYza5qmCAAFZY
        PSqLqWlsBKDSRGG6Whos2h2XI4CpBWs=
X-Google-Smtp-Source: ABdhPJw5WppN+Wdf7nZZehiE7GhLW2QiO1gWLiWkQQyWKqNHvD3z69cspcOkuFI4FakoZr8uhfvzVA==
X-Received: by 2002:adf:f3d1:: with SMTP id g17mr3374767wrp.156.1604586320594;
        Thu, 05 Nov 2020 06:25:20 -0800 (PST)
Received: from [192.168.1.47] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t199sm2693656wmt.46.2020.11.05.06.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 06:25:20 -0800 (PST)
To:     Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
Message-ID: <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
Date:   Thu, 5 Nov 2020 14:22:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/11/2020 12:36, Dmitry Kadashev wrote:
> Hi Jens,
> 
> I am trying to implement mkdirat support in io_uring and was using
> commit 3c5499fa56f5 ("fs: make do_renameat2() take struct filename") as
> an example (kernel newbie here). But either I do not understand how it
> works, or on retry struct filename is used that is not owned anymore
> (and is probably freed).
> 
> Here is the relevant part of the patch:
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index d4a6dd772303..a696f99eef5c 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -4346,8 +4346,8 @@ int vfs_rename(struct inode *old_dir, struct
> dentry *old_dentry,
>  }
>  EXPORT_SYMBOL(vfs_rename);
> 
> -static int do_renameat2(int olddfd, const char __user *oldname, int newdfd,
> -                       const char __user *newname, unsigned int flags)
> +int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
> +                struct filename *newname, unsigned int flags)
>  {
>         struct dentry *old_dentry, *new_dentry;
>         struct dentry *trap;
> @@ -4359,28 +4359,28 @@ static int do_renameat2(int olddfd, const char
> __user *oldname, int newdfd,
>         struct filename *to;
>         unsigned int lookup_flags = 0, target_flags = LOOKUP_RENAME_TARGET;
>         bool should_retry = false;
> -       int error;
> +       int error = -EINVAL;
> 
>         if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
> -               return -EINVAL;
> +               goto put_both;
> 
>         if ((flags & (RENAME_NOREPLACE | RENAME_WHITEOUT)) &&
>             (flags & RENAME_EXCHANGE))
> -               return -EINVAL;
> +               goto put_both;
> 
>         if (flags & RENAME_EXCHANGE)
>                 target_flags = 0;
> 
>  retry:
> -       from = filename_parentat(olddfd, getname(oldname), lookup_flags,
> -                               &old_path, &old_last, &old_type);

filename_parentat(getname(oldname), ...)

It's passing a filename directly, so filename_parentat() also takes ownership
of the passed filename together with responsibility to put it. Yes, it should
be destroying it inside.

struct filename {
	...
	int			refcnt;
};

The easiest solution is to take an additional ref. Looks like it's not atomic,
but double check to not add additional overhead.

> +       from = filename_parentat(olddfd, oldname, lookup_flags, &old_path,
> +                                       &old_last, &old_type);
> 
> With the new code on the first run oldname ownership is released. And if
> we do end up on the retry path then it is used again erroneously (also
> `from` was already put by that time).
> 
> Am I getting it wrong or is there a bug?
> 
> do_unlinkat that you reference does things a bit differently, as far as
> I can tell the problem does not exist there.
> 
> Thanks,
> Dmitry
> 

-- 
Pavel Begunkov
