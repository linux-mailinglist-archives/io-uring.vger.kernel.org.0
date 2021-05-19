Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52690389279
	for <lists+io-uring@lfdr.de>; Wed, 19 May 2021 17:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240263AbhESPY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 11:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbhESPYY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 11:24:24 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6B8C06175F
        for <io-uring@vger.kernel.org>; Wed, 19 May 2021 08:23:04 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id k14so17073381eji.2
        for <io-uring@vger.kernel.org>; Wed, 19 May 2021 08:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2kcMHiUdBh2RX9lqzPjQo7AnDIczfIylBe4oy/anXE4=;
        b=Ozr9QX2vejijzqnJiHLv3IEed5XqEa5tCvrp4GWhBWSBVsToH+RmYdiIwm3uQ8Rd1+
         J9PuijBn2eRbEI1jVMnt5WZfi9ziUoMOy8uc2Q3VD6SCdOC3t9t8qoBn2Q44BZ7jr48e
         F892B/DS76Lcor5RWCGtbq2A8vth6kTdpxuk/rjirPcFFbSRhoZN8miOTdA1a4gxo1zI
         Cj8Wp039/MPhSS4QXTAfFJLdQCGuF65cX8GOrtTFFgaoqT21vCWGJW9hqVlc89YiWNgq
         sj8FkAItA82GtRljXobNcFgKBEJsiwslTzt1OKqLOCeZnCjIHmQN8zEvGocBnYyFVZfL
         5u+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2kcMHiUdBh2RX9lqzPjQo7AnDIczfIylBe4oy/anXE4=;
        b=UbXMg86abF9nioVsf4CzzIvrFAy+rL3hJwctSv2n2lLP3HiMe/JQYG7xHt5wjUTL4z
         RdYheMJy47cEWiSzyz0HgdyIAIKX7ZIlyElZ+1EfXjgSKOpdRkZbUJEqYGu8LmB3OSpx
         AEF9Lo6EIx8r2l7BW/rDjI0ikG5zlwE88ia7dSIjJVeDdTqaAnkEaDNwAvWZH/Y/UTYa
         Z77JOS4Fhwsm4eE1HEgvCiyQR2NdZK4U2K2nY8xzTVDmSjUNABH0lQzqpm8nQUxNtO3b
         FS7orhr99knb2Fn9QgtpvxOYc69b2O0y1kiJkrpcvm8lMChQYLhc3LTDFUbXcKiR9zLB
         ft9A==
X-Gm-Message-State: AOAM5308CjLuRBIwkKFNx/1M/cIztRdVqSe8jSW4BF6rKD41KWvJOv+K
        MkQPrbTbSKF5VAMBCix28rt1Ss5QfS8dF/9EqEyhpAurpw==
X-Google-Smtp-Source: ABdhPJyfh/Fy9DHSztbus3l4CzHOkkEYqRjXK6/08Yh4J+xdsoExgFRhQ+pqMygupCb94lvG9QjZu3YfmHF5IUWHWmE=
X-Received: by 2002:a17:906:840c:: with SMTP id n12mr13191151ejx.431.1621437782490;
 Wed, 19 May 2021 08:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210519113058.1979817-1-memxor@gmail.com> <20210519113058.1979817-2-memxor@gmail.com>
In-Reply-To: <20210519113058.1979817-2-memxor@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 19 May 2021 11:22:51 -0400
Message-ID: <CAHC9VhTBcCJ1TfvB-HbzrByroeqfFE-SF_REik9PDSdqmJbuYA@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: anon_inodes: export anon_inode_getfile_secure helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     io-uring@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Eric Biggers <ebiggers@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 19, 2021 at 7:37 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This is the non-fd installing analogue of anon_inode_getfd_secure. In
> addition to allowing LSMs to attach policy to the distinct inode, this
> is also needed for checkpoint restore of an io_uring instance where a
> mapped region needs to mapped back to the io_uring fd by CRIU. This is
> currently not possible as all anon_inodes share a single inode.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  fs/anon_inodes.c            | 9 +++++++++
>  include/linux/anon_inodes.h | 4 ++++
>  2 files changed, 13 insertions(+)

[NOTE: dropping dancol@google as that email is bouncy]

> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index a280156138ed..37032786b211 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -148,6 +148,15 @@ struct file *anon_inode_getfile(const char *name,
>  }
>  EXPORT_SYMBOL_GPL(anon_inode_getfile);

This function should have a comment block at the top similar to
anon_inode_getfile(); in fact you can likely copy-n-paste the bulk of
it to use as a start.

If you don't want to bother respinning, I've got this exact patch
(+comments) in my patchset that I'll post later and I'm happy to
give/share credit if that is important to you.

> +struct file *anon_inode_getfile_secure(const char *name,
> +                                      const struct file_operations *fops,
> +                                      void *priv, int flags,
> +                                      const struct inode *context_inode)
> +{
> +       return __anon_inode_getfile(name, fops, priv, flags, context_inode, true);
> +}
> +EXPORT_SYMBOL_GPL(anon_inode_getfile_secure);

-- 
paul moore
www.paul-moore.com
