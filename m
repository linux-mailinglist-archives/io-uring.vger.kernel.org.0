Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7F91B3724
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 08:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgDVGGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 02:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVGGM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 02:06:12 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86031C03C1A6;
        Tue, 21 Apr 2020 23:06:12 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t12so642136edw.3;
        Tue, 21 Apr 2020 23:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Hf6xP/vargsYyqhriKqrcqcKu8IaknYAwCr2SAXzhXI=;
        b=aN+izJ3/KqQp3SAdWwIWSP+jcBw5otAN/1GD5K+BlWRji7Zd3bMHJzSqn7qsh7vAdK
         QXJV1CGsw102VJx6a1lvvX1cW0L3ps5LZh30zWvS1SkFwSb+XBig/NUk/pWP8GJtmBH7
         5IfjGFW1eUjF4/GQWX+9fMIJalMR0VrFF9vzKYNZurzjs9IqaeC4x5bf/Hdd+XCCHYsi
         albDIhy/E2gI2yvuF3cSVGxeV9A+wNbYK/GJNtYW1Mqrl8bcaOu4+ExKEmnFkp9bL5tP
         CxG3QuWgX0HPdmCvbUkia9CFzgUieDzExNpJSmvh8Uh1nRWWUafYiDal2wXaj6MB+0tF
         G7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Hf6xP/vargsYyqhriKqrcqcKu8IaknYAwCr2SAXzhXI=;
        b=d/dRm1a8KOF4ETZ40hOlUe23dVmp2/4tPWS0QqMmQmAhSc6FAWZX4xgZLorh2v+hC5
         cP5rPmO8hcIoX7juiNz+kU8o69v9n6REf6Fffjh93YlochOsXp0up3unPAPewPS8TJX3
         3nzJRMmON7vbBON+mTInsfh6dm2i9as1R/8RIKiCZG3d6n+6sCQCNpNYj8C9+UGtKKc4
         cptS6IeybL6e3ltiu0lxsIct9L7ENH+qJPPvrKRIAhYADlxzZDJbbsiudtAgHDf6q4aa
         BjOT3SG+zf8xWXPNxCDgJbKl/Hq6YH1/cthJbANc46hKb712RmXsiK3iVeeDXhfgIHuu
         +ajw==
X-Gm-Message-State: AGi0PubrmzEL9MSxdVPmp5LTNK1LCgtcmjS8sZqk9nWYi965NyXYm3Jh
        dU6Pn/R4dsYFb4RrEO4JQHbC+2ucVdt+5moDblgFAFPl
X-Google-Smtp-Source: APiQypKp3kYkG8TVoAcF4xcC377lvWoZyGD7nQURS2s/XU3TjDbIFNmVwIkeXXgllN7sKYVf37cWeyi+0nFEOU18pTk=
X-Received: by 2002:aa7:d513:: with SMTP id y19mr22472621edq.367.1587535571151;
 Tue, 21 Apr 2020 23:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587531463.git.josh@joshtriplett.org> <05c9a6725490c5a5c4ee71be73326c2fedf35ba5.1587531463.git.josh@joshtriplett.org>
In-Reply-To: <05c9a6725490c5a5c4ee71be73326c2fedf35ba5.1587531463.git.josh@joshtriplett.org>
Reply-To: mtk.manpages@gmail.com
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date:   Wed, 22 Apr 2020 08:06:00 +0200
Message-ID: <CAKgNAkhC1suyGaZzRee5x4Ret9Q_JVpqwhf_xELqm0SJAL61OA@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] fs: Support setting a minimum fd for "lowest
 available fd" allocation
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

On Wed, 22 Apr 2020 at 07:19, Josh Triplett <josh@joshtriplett.org> wrote:
>
> Some applications want to prevent the usual "lowest available fd"
> allocation from allocating certain file descriptors. For instance, they
> may want to prevent allocation of a closed fd 0, 1, or 2 other than via
> dup2/dup3, or reserve some low file descriptors for other purposes.
>
> Add a prctl to increase the minimum fd and return the previous minimum.
>
> System calls that allocate a specific file descriptor, such as
> dup2/dup3, ignore this minimum.
>
> exec resets the minimum fd, to prevent one program from interfering with
> another program's expectations about fd allocation.
>
> Test program:
>
>     #include <err.h>
>     #include <fcntl.h>
>     #include <stdio.h>
>     #include <sys/prctl.h>
>
>     int main(int argc, char *argv[])
>     {
>         if (prctl(PR_INCREASE_MIN_FD, 100, 0, 0, 0) < 0)
>             err(1, "prctl");
>         int fd = open("/dev/null", O_RDONLY);
>         if (fd < 0)
>             err(1, "open");
>         printf("%d\n", fd); // prints 100
>         return 0;
>     }
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  fs/file.c                  | 23 +++++++++++++++++------
>  include/linux/fdtable.h    |  1 +
>  include/linux/file.h       |  1 +
>  include/uapi/linux/prctl.h |  3 +++
>  kernel/sys.c               |  5 +++++
>  5 files changed, 27 insertions(+), 6 deletions(-)
>
> diff --git a/fs/file.c b/fs/file.c
> index c8a4e4c86e55..ba06140d89af 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -286,7 +286,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
>         spin_lock_init(&newf->file_lock);
>         newf->resize_in_progress = false;
>         init_waitqueue_head(&newf->resize_wait);
> -       newf->next_fd = 0;
>         new_fdt = &newf->fdtab;
>         new_fdt->max_fds = NR_OPEN_DEFAULT;
>         new_fdt->close_on_exec = newf->close_on_exec_init;
> @@ -295,6 +294,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
>         new_fdt->fd = &newf->fd_array[0];
>
>         spin_lock(&oldf->file_lock);
> +       newf->next_fd = newf->min_fd = oldf->min_fd;
>         old_fdt = files_fdtable(oldf);
>         open_files = count_open_files(old_fdt);
>
> @@ -487,9 +487,7 @@ int __alloc_fd(struct files_struct *files,
>         spin_lock(&files->file_lock);
>  repeat:
>         fdt = files_fdtable(files);
> -       fd = start;
> -       if (fd < files->next_fd)
> -               fd = files->next_fd;
> +       fd = max3(start, files->min_fd, files->next_fd);
>
>         if (fd < fdt->max_fds)
>                 fd = find_next_fd(fdt, fd);
> @@ -514,7 +512,7 @@ int __alloc_fd(struct files_struct *files,
>                 goto repeat;
>
>         if (start <= files->next_fd)
> -               files->next_fd = fd + 1;
> +               files->next_fd = max(fd + 1, files->min_fd);
>
>         __set_open_fd(fd, fdt);
>         if (flags & O_CLOEXEC)
> @@ -555,7 +553,7 @@ static void __put_unused_fd(struct files_struct *files, unsigned int fd)
>  {
>         struct fdtable *fdt = files_fdtable(files);
>         __clear_open_fd(fd, fdt);
> -       if (fd < files->next_fd)
> +       if (fd < files->next_fd && fd >= files->min_fd)
>                 files->next_fd = fd;
>  }
>
> @@ -684,6 +682,7 @@ void do_close_on_exec(struct files_struct *files)
>
>         /* exec unshares first */
>         spin_lock(&files->file_lock);
> +       files->min_fd = 0;
>         for (i = 0; ; i++) {
>                 unsigned long set;
>                 unsigned fd = i * BITS_PER_LONG;
> @@ -865,6 +864,18 @@ bool get_close_on_exec(unsigned int fd)
>         return res;
>  }
>
> +unsigned int increase_min_fd(unsigned int num)
> +{
> +       struct files_struct *files = current->files;
> +       unsigned int old_min_fd;
> +
> +       spin_lock(&files->file_lock);
> +       old_min_fd = files->min_fd;
> +       files->min_fd += num;
> +       spin_unlock(&files->file_lock);
> +       return old_min_fd;
> +}
> +
>  static int do_dup2(struct files_struct *files,
>         struct file *file, unsigned fd, unsigned flags)
>  __releases(&files->file_lock)
> diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
> index f07c55ea0c22..d1980443d8b3 100644
> --- a/include/linux/fdtable.h
> +++ b/include/linux/fdtable.h
> @@ -60,6 +60,7 @@ struct files_struct {
>     */
>         spinlock_t file_lock ____cacheline_aligned_in_smp;
>         unsigned int next_fd;
> +       unsigned int min_fd; /* min for "lowest available fd" allocation */
>         unsigned long close_on_exec_init[1];
>         unsigned long open_fds_init[1];
>         unsigned long full_fds_bits_init[1];
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 142d102f285e..b67986f818d2 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -88,6 +88,7 @@ extern bool get_close_on_exec(unsigned int fd);
>  extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
>  extern int get_unused_fd_flags(unsigned flags);
>  extern void put_unused_fd(unsigned int fd);
> +extern unsigned int increase_min_fd(unsigned int num);
>
>  extern void fd_install(unsigned int fd, struct file *file);
>
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index 07b4f8131e36..916327272d21 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -238,4 +238,7 @@ struct prctl_mm_map {
>  #define PR_SET_IO_FLUSHER              57
>  #define PR_GET_IO_FLUSHER              58
>
> +/* Increase minimum file descriptor for "lowest available fd" allocation */
> +#define PR_INCREASE_MIN_FD             59
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/sys.c b/kernel/sys.c
> index d325f3ab624a..daa0ce43cecc 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2514,6 +2514,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>
>                 error = (current->flags & PR_IO_FLUSHER) == PR_IO_FLUSHER;
>                 break;
> +       case PR_INCREASE_MIN_FD:
> +               if (arg3 || arg4 || arg5)
> +                       return -EINVAL;
> +               error = increase_min_fd((unsigned int)arg2);
> +               break;
>         default:
>                 error = -EINVAL;
>                 break;
> --
> 2.26.2
>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
