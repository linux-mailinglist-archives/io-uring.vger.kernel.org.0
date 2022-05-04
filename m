Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E1A519962
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 10:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346068AbiEDIQs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 May 2022 04:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343571AbiEDIQr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 May 2022 04:16:47 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3092252D
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 01:13:11 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-e2fa360f6dso486027fac.2
        for <io-uring@vger.kernel.org>; Wed, 04 May 2022 01:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3UF0+u4rgNSoSqS7hjmT0XqUFhNn3b8DMHbYypNxQJo=;
        b=B4CgaTkgbgOKNEW7G8xWkJgvHi0knKqnnYhXVFCDfv2vqcC6ffMaxfMoQUWh+NmYMI
         VU+p8OM7JGXIhrfcOxbFBrwT7Ru0kfZkqOdRmv7d/w9GOkyJiG+RblWwGtVAxediEVLv
         iL4djUXWHxJCpkp3+7VUHEz5hyrkQj+Ydk5bcWaCzrmYGNkrvyAcdhwwWA1JYXfxTIuL
         TtnnHHaCIt8Yo+buGJejE20l5BYe3aLWjrjeukk6SWYUDu245JEpW4+WqpwysgjCe6qH
         cihgmlIs/qLpxSN5C42a4HI9BhOZDQPNFMiS0maK4UcIiniMY6F/lse/biP3DkHTYwWB
         44Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3UF0+u4rgNSoSqS7hjmT0XqUFhNn3b8DMHbYypNxQJo=;
        b=oLVZWnTMfW3g6Bydv4wm439kCJpi+KgeFjoNjN027u++zUUydxQq8V5GracQ3JsYCa
         0MHAXdlZRPAkLynnAcKJC0DzARH0vL0Nn2FidTgAe2/rXJ9W7hOVfdraWYBip0BUox9P
         gL8U9u1QOKSb/bKiipPRb9xbQ4k9IW/bT+9JofYUoQWIWxEiRo2Wvlh54EYUJwZGRq5h
         JnDENuOLKErwHGA2pJmodZw793r57O0WPJI6zV3bnzwfM5IgS19lG3iQN18g/KUtHDfz
         7h/yEtU3QlJRUZksec5esC8TyI6NZawu3WSZcvQSI0jZHSBFIETvQrNOl0mD4G94C8OP
         UZeA==
X-Gm-Message-State: AOAM532kQIpraRyIZt6ODyT4Q7S3uKo/xTYDdSmxMv8EHcHf1MjTb43j
        EAbt2C4eHx9ArR+AHyTT0orfoMFIhzqO4FWzehM=
X-Google-Smtp-Source: ABdhPJye4VI9R7vY+bqkutt48/zBg8L+cudqX5CVp4PX3mqN3OPQKONhvddwmfrrp5yI67PGh2pKozw+26e1Qz89OpM=
X-Received: by 2002:a05:6870:c392:b0:e9:f20:fa8a with SMTP id
 g18-20020a056870c39200b000e90f20fa8amr3198866oao.15.1651651989729; Wed, 04
 May 2022 01:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220503184831.78705-1-p.raghav@samsung.com> <CGME20220503184912eucas1p1bb0e3d36c06cfde8436df3a45e67bd32@eucas1p1.samsung.com>
 <20220503184831.78705-2-p.raghav@samsung.com> <20220503205202.GA9567@lst.de>
In-Reply-To: <20220503205202.GA9567@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 4 May 2022 08:12:44 -0700
Message-ID: <CA+1E3rKe6G8UC9Pzkm4Wbu50X=TT5tise8g6umduhj1eTbN0+w@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] fs,io_uring: add infrastructure for uring-cmd
To:     Christoph Hellwig <hch@lst.de>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stefan Roesch <shr@fb.com>, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 3, 2022 at 1:52 PM Christoph Hellwig <hch@lst.de> wrote:
>
> This mostly looks good, but a few comments an an (untested) patch
> to fix these complaints below:
>
> > +struct io_uring_cmd {
> > +     struct file     *file;
> > +     void            *cmd;
> > +     /* for irq-completion - if driver requires doing stuff in task-context*/
> > +     void (*driver_cb)(struct io_uring_cmd *cmd);
>
> I'd rename this task_Work_cb or similar, as driver is not very
> meaningful.
>
> > +     u32             flags;
> > +     u32             cmd_op;
> > +     u32             unused;
> > +     u8              pdu[28]; /* available inline for free use */
>
> The unused field here is not only unused, but also messed up the
> alignment so that any pointer in pdu will not be properly aligned
> on 64-bit platforms and tjus might cause crashes on some platforms.

Indeed, thanks. Since we are going to remove that, we can give that
space to pdu for now i.e. pdu[32].This will help in removing "packed"
attribute in nvme pdu (which is 32 bytes without packing).

> For now we can just remove it, but I really want to get rid of the pdu
> thing that causes these problems, but I will not hold the series off for
> that and plan to look into that later.
> Also a lot of the fields here were using spaces instead of tabs for
> indentation.
>
> >       union {
> >               __u64   addr;   /* pointer to buffer or iovecs */
> >               __u64   splice_off_in;
> > +             __u16   cmd_len;
> >       };
>
> This field isn't actually used and can be removed.
>
> >       __u32   len;            /* buffer size or number of iovecs */
> >       union {
> > @@ -61,7 +63,10 @@ struct io_uring_sqe {
> >               __s32   splice_fd_in;
> >               __u32   file_index;
> >       };
> > -     __u64   addr3;
> > +     union {
> > +             __u64   addr3;
> > +             __u64   cmd;
> > +     };
> >       __u64   __pad2[1];
>
> The way how the tail of the structure is handled here is a mess.  I
> think something like a union of two structs for the small and large
> case would be much better, so that cmd can be the actual array for
> the data that can be used directly and without the nasty cast (that
> also casted away the constness):
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b774e6eac5384..fe24d606ca306 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4544,7 +4544,7 @@ static int io_getxattr_prep(struct io_kiocb *req,
>         if (ret)
>                 return ret;
>
> -       path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
> +       path = u64_to_user_ptr(READ_ONCE(sqe->small.addr3));
>
>         ix->filename = getname_flags(path, LOOKUP_FOLLOW, NULL);
>         if (IS_ERR(ix->filename)) {
> @@ -4645,7 +4645,7 @@ static int io_setxattr_prep(struct io_kiocb *req,
>         if (ret)
>                 return ret;
>
> -       path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
> +       path = u64_to_user_ptr(READ_ONCE(sqe->small.addr3));
>
>         ix->filename = getname_flags(path, LOOKUP_FOLLOW, NULL);
>         if (IS_ERR(ix->filename)) {
> @@ -4909,15 +4909,15 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
>
>  static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
>  {
> -       req->uring_cmd.driver_cb(&req->uring_cmd);
> +       req->uring_cmd.task_work_cb(&req->uring_cmd);
>  }
>
>  void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> -                       void (*driver_cb)(struct io_uring_cmd *))
> +                       void (*task_work_cb)(struct io_uring_cmd *))
>  {
>         struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
>
> -       req->uring_cmd.driver_cb = driver_cb;
> +       req->uring_cmd.task_work_cb = task_work_cb;
>         req->io_task_work.func = io_uring_cmd_work;
>         io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
>  }
> @@ -4949,7 +4949,7 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
>                 return -EOPNOTSUPP;
>         if (!(req->ctx->flags & IORING_SETUP_CQE32))
>                 return -EOPNOTSUPP;
> -       ioucmd->cmd = (void *) &sqe->cmd;
> +       ioucmd->cmd = sqe->big.cmd;
>         ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
>         ioucmd->flags = 0;
>         return 0;
> @@ -12735,7 +12735,7 @@ static int __init io_uring_init(void)
>         BUILD_BUG_SQE_ELEM(42, __u16,  personality);
>         BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
>         BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
> -       BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
> +       BUILD_BUG_SQE_ELEM(48, __u64,  small.addr3);
>
>         BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
>                      sizeof(struct io_uring_rsrc_update));
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index a4ff4696cbead..7274884859910 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -13,20 +13,19 @@ enum io_uring_cmd_flags {
>  };
>
>  struct io_uring_cmd {
> -       struct file     *file;
> -       void            *cmd;
> -       /* for irq-completion - if driver requires doing stuff in task-context*/
> -       void (*driver_cb)(struct io_uring_cmd *cmd);
> -       u32             flags;
> -       u32             cmd_op;
> -       u32             unused;
> +       struct file     *file;
> +       const u8        *cmd;
> +       /* callback to defer completions to task context */
> +       void (*task_work_cb)(struct io_uring_cmd *cmd);
> +       u32             flags;
> +       u32             cmd_op;
>         u8              pdu[28]; /* available inline for free use */
>  };
>
>  #if defined(CONFIG_IO_URING)
>  void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
>  void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> -                       void (*driver_cb)(struct io_uring_cmd *));
> +                       void (*task_work_cb)(struct io_uring_cmd *));
>  struct sock *io_uring_get_socket(struct file *file);
>  void __io_uring_cancel(bool cancel_all);
>  void __io_uring_free(struct task_struct *tsk);
> @@ -56,7 +55,7 @@ static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
>  {
>  }
>  static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> -                       void (*driver_cb)(struct io_uring_cmd *))
> +                       void (*task_work_cb)(struct io_uring_cmd *))
>  {
>  }
>  static inline struct sock *io_uring_get_socket(struct file *file)
> diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
> index 630982b3c34c5..b1f64c2412935 100644
> --- a/include/trace/events/io_uring.h
> +++ b/include/trace/events/io_uring.h
> @@ -539,8 +539,8 @@ TRACE_EVENT(io_uring_req_failed,
>                 __entry->buf_index      = sqe->buf_index;
>                 __entry->personality    = sqe->personality;
>                 __entry->file_index     = sqe->file_index;
> -               __entry->pad1           = sqe->__pad2[0];
> -               __entry->addr3          = sqe->addr3;
> +               __entry->addr3          = sqe->small.addr3;
> +               __entry->pad1           = sqe->small.__pad2[0];
>                 __entry->error          = error;
>         ),
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index c081511119bfa..bd4221184f594 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -27,7 +27,6 @@ struct io_uring_sqe {
>         union {
>                 __u64   addr;   /* pointer to buffer or iovecs */
>                 __u64   splice_off_in;
> -               __u16   cmd_len;
>         };
>         __u32   len;            /* buffer size or number of iovecs */
>         union {
> @@ -64,16 +63,19 @@ struct io_uring_sqe {
>                 __u32   file_index;
>         };
>         union {
> -               __u64   addr3;
> -               __u64   cmd;
> +               struct {
> +                       __u64   addr3;
> +                       __u64   __pad2[1];
> +               } small;

Thinking if this can cause any issue for existing users of addr3, i.e.
in the userspace side? Since it needs to access this field with
small.addr3.
Jens - is xattr infra already frozen?

> +               /*
> +                * If the ring is initialized with IORING_SETUP_SQE128, then
> +                * this field is used for 80 bytes of arbitrary command data.
> +                */
> +               struct {
> +                       __u8    cmd[0];
> +               } big;
>         };
> -       __u64   __pad2[1];
> -
> -       /*
> -        * If the ring is initialized with IORING_SETUP_SQE128, then this field
> -        * contains 64-bytes of padding, doubling the size of the SQE.
> -        */
> -       __u64   __big_sqe_pad[0];
>  };
>
>  enum {



-- 
Joshi
