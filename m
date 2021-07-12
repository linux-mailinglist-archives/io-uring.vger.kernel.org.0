Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560E43C62E9
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 20:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhGLSta (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 14:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbhGLSt3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 14:49:29 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E5BC0613DD
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 11:46:40 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id a12so139526lfb.7
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 11:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bxXQRushEcGK/228boQLTeFcixL6JKTeFr1JKo01BZI=;
        b=Tlry1eux2Hcx7MU+4zkcbNM31M5MIL6ev1CDwVobZ3dmqyxD3CRbq9n+R5zIeW+f5E
         /pUYGRPccuQmHytw6FAT+URWZgGdXjTk6awgcXP7GMrcm9GkHbXFoDXc3j+725y1Ro9c
         pyL0qYs9udnU+Sg+L7d/g+PVS2NZad3eOsddY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bxXQRushEcGK/228boQLTeFcixL6JKTeFr1JKo01BZI=;
        b=iBvmHqrNhc5XWuL1rWlGusQYxkhOQ0S5EHG1HTh5NbR+QKEVgBQhblRoy44fKaSEFu
         iFiQJqWwvXmvlOcaOiWIDVMXMRoVb3LuuufuU8ZUcboZIm1E+BW5YMjaiTzmZgJRYswT
         vqZ8kHKwZfDVxJL3qfCQmTb7wGimJzuNc34V5cm1QrwVdrQL63oYjWmdfWlbpBTm0WXm
         4qK3qq1zOc5eIsoHMXcIrk9kUjn6pfon8tY3+pXz/zjIMeIyDv7N9beVozosHok3pC8W
         7WP7+Xp2JsSg1OrlolX7K/2Su9piXzkfmmLYeBf4ba80zn9zplMKFz2e+3hsaRQEd88M
         ELGg==
X-Gm-Message-State: AOAM53146l59lsJ5Gf00tWD0A7IQlRiqlNf5uiHHKRbhZhs6dtv/pv1X
        NFtdIt51xGxKfFY9htKqqUqoTBUGDCFW/hyh
X-Google-Smtp-Source: ABdhPJw40lmVTgla9JG+o6So+NLeK0w2xUMqfuDsBTvGzCfPMceeesOYPF/3nOWv7j+1v0vuTreHog==
X-Received: by 2002:a19:4907:: with SMTP id w7mr152002lfa.136.1626115598477;
        Mon, 12 Jul 2021 11:46:38 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id q20sm1045290lfu.168.2021.07.12.11.46.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 11:46:36 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id a18so25831049ljk.6
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 11:46:36 -0700 (PDT)
X-Received: by 2002:a2e:9241:: with SMTP id v1mr515604ljg.48.1626115595994;
 Mon, 12 Jul 2021 11:46:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210712123649.1102392-1-dkadashev@gmail.com> <20210712123649.1102392-5-dkadashev@gmail.com>
In-Reply-To: <20210712123649.1102392-5-dkadashev@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Jul 2021 11:46:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjFd0qn6asio=zg7zUTRmSty_TpAEhnwym1Qb=wFgCKzA@mail.gmail.com>
Message-ID: <CAHk-=wjFd0qn6asio=zg7zUTRmSty_TpAEhnwym1Qb=wFgCKzA@mail.gmail.com>
Subject: Re: [PATCH 4/7] namei: clean up do_mknodat retry logic
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 12, 2021 at 5:37 AM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> Moving the main logic to a helper function makes the whole thing much
> easier to follow.

This patch works, but the conversion is not one-to-one.

> -static int do_mknodat(int dfd, struct filename *name, umode_t mode,
> -               unsigned int dev)
> +static int mknodat_helper(int dfd, struct filename *name, umode_t mode,
> +                         unsigned int dev, unsigned int lookup_flags)
>  {
>         struct user_namespace *mnt_userns;
>         struct dentry *dentry;
>         struct path path;
>         int error;
> -       unsigned int lookup_flags = 0;
>
>         error = may_mknod(mode);
>         if (error)
> -               goto out1;
> -retry:

Note how "may_mknod()" was _outside_ the retry before, and now it's inside:

> +static int do_mknodat(int dfd, struct filename *name, umode_t mode,
> +               unsigned int dev)
> +{
> +       int error;
> +
> +       error = mknodat_helper(dfd, name, mode, dev, 0);
> +       if (retry_estale(error, 0))
> +               error = mknodat_helper(dfd, name, mode, dev, LOOKUP_REVAL);
> +
>         putname(name);
>         return error;

which happens to not be fatal - doing the may_mknod() twice will not
break anything - but it doesn't match what it used to do.

A few options options:

 (a) a separate patch to move the "may_mknod()" to the two callers first

 (b) a separate patch to move the "may_mknod()" first into the repeat
loop, with the comment being that it's ok.

 (c) keep the logic the same, with the code something like

  static int do_mknodat(int dfd, struct filename *name, umode_t mode,
                unsigned int dev)
  {
        int error;

        error = may_mknod(mode);
        if (!error) {
                error = mknodat_helper(dfd, name, mode, dev, 0);
                if (retry_estale(error, 0))
                        error = mknodat_helper(dfd, name, mode, dev,
LOOKUP_REVAL);
        }

        putname(name);
        return error;
  }

or

 (d) keep the patch as-is, but with an added commit message note about
how it's not one-to-one and why it's ok.

Hmm?

So this patch could be fine, but it really wants to note how it
changes the logic and why that's fine. Or, the patch should be
modified.

                Linus
