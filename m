Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6FC37F3AF
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhEMHri (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 03:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbhEMHrC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 03:47:02 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3219FC061760;
        Thu, 13 May 2021 00:45:51 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id e190so33774161ybb.10;
        Thu, 13 May 2021 00:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+W/n1QoXcsHe+NwYrSh/O57L0KSIAv6lK9nGMhRnD0I=;
        b=G8c0euQZvUJR8/LiGUpL5JyZVQjCNDh9eDvua4Y97kxDNOIY+p4Zg7/b5mWMxZxsol
         FO0jfi3obdmLcGhRG7HveejzOPtOJ6vUMOZEEFsMoHOx/2Sq4pET4pigh5k7VQ56H3I6
         w/ZbD1+csjJ+BSluu6iuRIS53WsuahDd9beDFgEJ1r78xpscRo+l1zuWlVWvNpgQLSVJ
         bnbLZy2gBCvBK+pLYNUv3J+x41jEmkC+XSIeOw5RcbyZg7KRcmsYaQZ5NomYkWW77BcN
         SMl3E7Fc5gvh9V00UF/m/qfqxOte5Yhdm5m0VYalrUB5U/ngVBoVoL5XyfebGioSV/n0
         EtWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+W/n1QoXcsHe+NwYrSh/O57L0KSIAv6lK9nGMhRnD0I=;
        b=iM7qzjbja25g0By+xqAuvDNtJ2a07RSRcTp6ZLFwvh5S4L1g4K6jwpjLcWdIm12yzB
         19wFCrqmqvHJBWmcBZZkt/Yz5NpnGYmSU9mKjCuYB60/mmyiFb9dfZKhMsVNnplTBwLC
         acWUF8boDnRhDGtP+BdjxzVkd/sxLf6hf9T8Qi59huTWw2txWKw6fk2S3ghAn+mdnqbo
         +yKW+j1QjHN8vJxNvfoohSdsFp/SKtlucCtWuk5dLVj5SAgU5BBoj9AMLYIz3Bq+sgHF
         +AUVexblTj4ARJbCF2l+5I/CvsCSrlsSolTzf5+CGVaWusl6Nj1FF7GtdGqxfcagN7kG
         BODQ==
X-Gm-Message-State: AOAM530lO/swIZGOXg1AtsifXsAAuBQe/+MYvcPFlUF7X5RyD5XKnqWw
        76YMe+r10o/58/iUS7Ev3jtfgUGro+H5m4QFO+E=
X-Google-Smtp-Source: ABdhPJxnDTyS6SszYWpogLwxuFOjj+CwVec48G3WISHLQL4mhuCIPDZYCR/nhbvqIglJKH5x8tJ473BpYAg35uLd9D8=
X-Received: by 2002:a25:ac4e:: with SMTP id r14mr18388269ybd.289.1620891950578;
 Thu, 13 May 2021 00:45:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210330055957.3684579-1-dkadashev@gmail.com> <20210330055957.3684579-2-dkadashev@gmail.com>
 <20210330071700.kpjoyp5zlni7uejm@wittgenstein> <CAOKbgA6spFzCJO+L_uwm9nhG+5LEo_XjVt7R7D8K=B5BcWSDbA@mail.gmail.com>
 <CAOKbgA6Qrs5DoHsHgBvrSGbyzHcaiGVpP+UBS5f25CtdBx3SdA@mail.gmail.com>
 <20210415100815.edrn4a7cy26wkowe@wittgenstein> <20210415100928.3ukgiaui4rhspiq6@wittgenstein>
 <CAOKbgA6Tn9uLJCAWOzWfysQDmFWcPBCOT6x47D-q-+_tu9z2Hg@mail.gmail.com> <20210415140932.uriiqjx3klzzmluu@wittgenstein>
In-Reply-To: <20210415140932.uriiqjx3klzzmluu@wittgenstein>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 13 May 2021 14:45:39 +0700
Message-ID: <CAOKbgA7JM24D2iuCoVjRV=oC1LW8JCcUMeAWMvFr1GHxb7T57g@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 15, 2021 at 9:09 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> Hm, I get your point but if you e.g. look at fs/exec.c we already do
> have that problem today:
>
>  SYSCALL_DEFINE5(execveat,
>                 int, fd, const char __user *, filename,
>                 const char __user *const __user *, argv,
>                 const char __user *const __user *, envp,
>                 int, flags)
> {
>         int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
>
>         return do_execveat(fd,
>                            getname_flags(filename, lookup_flags, NULL),
>                            argv, envp, flags);
> }
>
> The new simple flag helper would simplify things because right now it
> pretends that it cares about multiple flags where it actually just cares
> about whether or not empty pathnames are allowed and it forces callers
> to translate between flags too.

Hi Christian,

Sorry for the long silence, I got overwhelmed by the primary job and life
stuff. I've finally carved out some time to work on this. I left out the
"make getname_flags accept a single boolean instead of flags" bit to
make the change smaller. If you think it's something that definitely
should be in this patch set then let me know, I'll put it back in. I'm
still somewhat concerned about the separation of the capability check
and the actual logic to get the name, but I guess I'll just post what I
have and collect comments.

I'll send the v4 soon.

-- 
Dmitry Kadashev
