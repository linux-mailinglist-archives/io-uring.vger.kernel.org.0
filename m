Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4781B372D
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 08:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgDVGGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 02:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVGGm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 02:06:42 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F137C03C1A6;
        Tue, 21 Apr 2020 23:06:42 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id s10so621668edy.9;
        Tue, 21 Apr 2020 23:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=h0idybwDmEfa/korpolaf6WlP1SNgmMIfpFAf9kjpok=;
        b=uHIVILQblMiBLefW9MgoZ/hnnc0jylFYRKMcWcSmogDAqFpJILgubu7zJb/qgMho44
         JqBrt5oqkRGnc0q9dBssUmvBzYH+08LpLwfrxCc7yKM11wYGZLHp/sCTGmpqO2DCB0FI
         wUdvLQEAGF94SutI7EXpWPRGWRfnbKwztvH04dZ9nb+tu6pNOhjwJmUjC3pGZXDDrVCh
         f5ht9K+M5XoIDs8M++kfpnaKir92USIMzZ2ptLLSmXw56t4Xv10wLfPE8vXFQosAAPgd
         wV++XhtwbqqLQ4Wirs/iGMUyB4FK5O/kaQyUCQUSTHB/iQ5LXrt2OhCoMVt0bF6ZG84h
         Shxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=h0idybwDmEfa/korpolaf6WlP1SNgmMIfpFAf9kjpok=;
        b=uPve/WXKclgr+RdTkdFKLwDGw7+oSUKqQMje5GPaQEsHiMs0yeaEhN/vkvo21Am18i
         O2QZI600Hr6i+FhNYSUaA1P0QGabfTr3PAUZ/B9W82ExUW/a/R/Chjlt5xZgMa1wx6VK
         Sh42ShHW7bZb6fj0JY4PzhaSEj77i/VOlJ3VPmCmgQmKUeC4oZolNmY3QgbCQ4s4SIbw
         BNbGuum5KdaKNWyulV/vuC2NDxs3KetsWWAiPPb2AO1veNuwL5VlHSqpeHT9C+bHTfaL
         08N004oMzzuEExtEFEuERama+YOISVW/2/Xz+Obv+oRCDaiwgqDCOEyDR8MLIKiw04eO
         wd/A==
X-Gm-Message-State: AGi0PuYxME8SsGMEwNlJ27o3044Nn3nWIb1FqA0mrbaLebPi0b4d4kb0
        A/PYjboimoSo+Lwi9HgWu3nZYAD9StwORqfONf4=
X-Google-Smtp-Source: APiQypK8fsoLYZB3jXAi8Z7S/7K1N6GWwqC0AL1RbSB3HpMqR8Qrse8Ry7i/M+B6L0wavNDijl5Ftb2Zc0VKtQqwVhA=
X-Received: by 2002:a05:6402:1b08:: with SMTP id by8mr21832614edb.286.1587535601013;
 Tue, 21 Apr 2020 23:06:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587531463.git.josh@joshtriplett.org> <2bb2e92c688b97247f644fe8220054d6c6b66b65.1587531463.git.josh@joshtriplett.org>
In-Reply-To: <2bb2e92c688b97247f644fe8220054d6c6b66b65.1587531463.git.josh@joshtriplett.org>
Reply-To: mtk.manpages@gmail.com
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date:   Wed, 22 Apr 2020 08:06:30 +0200
Message-ID: <CAKgNAki3uoai+FWTQv6+DdQjCF3nc+7HoUZrLSC5dEf3ob9uRA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] fs: pipe2: Support O_SPECIFIC_FD
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[CC += linux-api]

On Wed, 22 Apr 2020 at 07:20, Josh Triplett <josh@joshtriplett.org> wrote:
>
> This allows the caller of pipe2 to specify one or both file descriptors
> rather than having them automatically use the lowest available file
> descriptor. The caller can specify either file descriptor as -1 to
> allow that file descriptor to use the lowest available.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  fs/pipe.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 16fb72e9abf7..4681a0d1d587 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -936,19 +936,19 @@ static int __do_pipe_flags(int *fd, struct file **files, int flags)
>         int error;
>         int fdw, fdr;
>
> -       if (flags & ~(O_CLOEXEC | O_NONBLOCK | O_DIRECT))
> +       if (flags & ~(O_CLOEXEC | O_NONBLOCK | O_DIRECT | O_SPECIFIC_FD))
>                 return -EINVAL;
>
>         error = create_pipe_files(files, flags);
>         if (error)
>                 return error;
>
> -       error = get_unused_fd_flags(flags);
> +       error = get_specific_unused_fd_flags(fd[0], flags);
>         if (error < 0)
>                 goto err_read_pipe;
>         fdr = error;
>
> -       error = get_unused_fd_flags(flags);
> +       error = get_specific_unused_fd_flags(fd[1], flags);
>         if (error < 0)
>                 goto err_fdr;
>         fdw = error;
> @@ -969,7 +969,11 @@ static int __do_pipe_flags(int *fd, struct file **files, int flags)
>  int do_pipe_flags(int *fd, int flags)
>  {
>         struct file *files[2];
> -       int error = __do_pipe_flags(fd, files, flags);
> +       int error;
> +
> +       if (flags & O_SPECIFIC_FD)
> +               return -EINVAL;
> +       error = __do_pipe_flags(fd, files, flags);
>         if (!error) {
>                 fd_install(fd[0], files[0]);
>                 fd_install(fd[1], files[1]);
> @@ -987,6 +991,10 @@ static int do_pipe2(int __user *fildes, int flags)
>         int fd[2];
>         int error;
>
> +       if (flags & O_SPECIFIC_FD)
> +               if (copy_from_user(fd, fildes, sizeof(fd)))
> +                       return -EFAULT;
> +
>         error = __do_pipe_flags(fd, files, flags);
>         if (!error) {
>                 if (unlikely(copy_to_user(fildes, fd, sizeof(fd)))) {
> --
> 2.26.2
>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
