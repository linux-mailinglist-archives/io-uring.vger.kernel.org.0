Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460E018CFA8
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2020 15:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCTODi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Mar 2020 10:03:38 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:46841 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgCTODi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Mar 2020 10:03:38 -0400
Received: by mail-il1-f193.google.com with SMTP id e8so5605851ilc.13
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2020 07:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OpuMI95NOMBoPSuxbnmP8QASDWsV+lCqDzQunT49Io4=;
        b=fhpJjuXcK0CicEXTEClVGaY/gkUqqVoRvWxNlE5b185eBIHHaJqUlwKQA9rkd1Zf49
         1Vs/fznX6w17ZcwVnRcCN3OYP/TQNJMEwBRxb0qnVUrCa7oPEz0X3Hf7DaObYP9Oa1wZ
         PHU6EFa/a/RznO8o20BqgLVcdgsLrbQqWg4HOWkH0FVv/T3tBup8fszP2sTu0z089exl
         5DHVNu8DkVArpJ7lPAqQQhbCHrbcRuWNI/D/a+7jklCLH0A7Q8tAbP1hUogyl7P+j+82
         LyNman3/58mwe/DQI/iQXnU/pVBGeBVj7814EiG3PYDcpOZcEjPS6/XkUuLudRoVsRJs
         WUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OpuMI95NOMBoPSuxbnmP8QASDWsV+lCqDzQunT49Io4=;
        b=YhBIFGvhBDXdv9hpFJGtoSZFyhL6530UME4MFJ0xz85XYJk6ru2vjbnvoMLH2DnTTv
         SCotWKje0EdieOMkaFKRGX9MdMRb54oJvVtptoYgeYMlG0ePiIPZnruzFnxaUt+2kAaM
         H7QIDm7uhbUMv8t3b7QibsEYj1B30cmH8Gu8xSlahwCXcXlqIvcNU6uxf3nxIpv14NjJ
         O6EwcIPJ44PRxeza7d+gxq1MQYYKEfz3AGjpLasDvrG4U2IkoX1ZcL6hw5i2s9tn8qWM
         1gXaBVMv06yF1TlltfuYGd9e9mNS8+f70NstrEZHS/1d5uF7K4txzkMWf4VB6jb6r7pn
         VoIw==
X-Gm-Message-State: ANhLgQ0GHrJpncvZiOLnlg1qhfBY7Hpy/eH8Adb/Q3Ee6WYy7SwaqxaG
        i2piugJJXTQYL7gxaXn546ckRYh7z+XC/ZvaC2dhQw==
X-Google-Smtp-Source: ADFU+vvflercahkiMoppPtxyZ8+PTudLvN+igtrjEpX5cZ+VOGE43gQy0XTRifqpdh2kWs2i/LJvlyvq3Wz4WZbZPtw=
X-Received: by 2002:a92:da03:: with SMTP id z3mr7862609ilm.191.1584713017788;
 Fri, 20 Mar 2020 07:03:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAOKbgA7cgN=+zNVH9Jv1UHXC1qoWAgnPqZPPJuNaLUzzXOwwSg@mail.gmail.com>
 <67f104f9-b239-4d68-2f90-01a2d5e30388@kernel.dk>
In-Reply-To: <67f104f9-b239-4d68-2f90-01a2d5e30388@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Fri, 20 Mar 2020 21:03:25 +0700
Message-ID: <CAOKbgA5RvZrf=RD-5rp7gug0-SgcKaFY4aacup982NvxYTPjSQ@mail.gmail.com>
Subject: Re: openat ignores changes to RLIMIT_NOFILE?
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

Yes, with the patch it works perfectly, thank you.

-- 
Dmitry


On Fri, Mar 20, 2020 at 8:23 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/19/20 6:12 AM, Dmitry Kadashev wrote:
> > Hi,
> >
> > It seems that openat calls issued via io_uring ignore changes to
> > RLIMIT_NOFILE. Maybe a wrong limit is checked. A short reproducer is
> > attached, it sets RLIMIT_NOFILE to a very low value and the sync
> > openat() call fails with "Too many open files", but io_uring one
> > succeeds. The resulting FD is completely usable, I've tried writing to
> > it successfully.
> >
> > To be clear, originally I've encountered another side of this problem:
> > we increase the limit in our code, and io_uring's openat started to
> > fail after a while under load, while the sync calls executed on a
> > thread pool were working as expected. It's just easier to demo with
> > small limit.
> >
> > Kernel 5.6-rc2, 5.6-rc6.
> >
> > Hope it's the right place to report an issue like this.
>
> Can you try the below patch?
>
>
> diff --git a/fs/file.c b/fs/file.c
> index a364e1a9b7e8..c8a4e4c86e55 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -540,9 +540,14 @@ static int alloc_fd(unsigned start, unsigned flags)
>         return __alloc_fd(current->files, start, rlimit(RLIMIT_NOFILE), flags);
>  }
>
> +int __get_unused_fd_flags(unsigned flags, unsigned long nofile)
> +{
> +       return __alloc_fd(current->files, 0, nofile, flags);
> +}
> +
>  int get_unused_fd_flags(unsigned flags)
>  {
> -       return __alloc_fd(current->files, 0, rlimit(RLIMIT_NOFILE), flags);
> +       return __get_unused_fd_flags(flags, rlimit(RLIMIT_NOFILE));
>  }
>  EXPORT_SYMBOL(get_unused_fd_flags);
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c06082bb039a..be5705ff33b4 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -398,6 +398,7 @@ struct io_open {
>         struct filename                 *filename;
>         struct statx __user             *buffer;
>         struct open_how                 how;
> +       unsigned long                   nofile;
>  };
>
>  struct io_files_update {
> @@ -2578,6 +2579,7 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>                 return ret;
>         }
>
> +       req->open.nofile = rlimit(RLIMIT_NOFILE);
>         req->flags |= REQ_F_NEED_CLEANUP;
>         return 0;
>  }
> @@ -2619,6 +2621,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>                 return ret;
>         }
>
> +       req->open.nofile = rlimit(RLIMIT_NOFILE);
>         req->flags |= REQ_F_NEED_CLEANUP;
>         return 0;
>  }
> @@ -2637,7 +2640,7 @@ static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
>         if (ret)
>                 goto err;
>
> -       ret = get_unused_fd_flags(req->open.how.flags);
> +       ret = __get_unused_fd_flags(req->open.how.flags, req->open.nofile);
>         if (ret < 0)
>                 goto err;
>
> diff --git a/include/linux/file.h b/include/linux/file.h
> index c6c7b24ea9f7..142d102f285e 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -85,6 +85,7 @@ extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
>  extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
>  extern void set_close_on_exec(unsigned int fd, int flag);
>  extern bool get_close_on_exec(unsigned int fd);
> +extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
>  extern int get_unused_fd_flags(unsigned flags);
>  extern void put_unused_fd(unsigned int fd);
>
> --
> Jens Axboe
>
