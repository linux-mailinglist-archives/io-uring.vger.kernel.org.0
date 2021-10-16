Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B67430584
	for <lists+io-uring@lfdr.de>; Sun, 17 Oct 2021 00:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbhJPW7w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Oct 2021 18:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbhJPW7v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Oct 2021 18:59:51 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375C9C061765
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 15:57:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id l6so8713101plh.9
        for <io-uring@vger.kernel.org>; Sat, 16 Oct 2021 15:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zc9YYTM+dezLtxTJUQZRBFDaWnorZ9yi2o8pLUnatQA=;
        b=dQcIJXTvZ17KBal1nuOPljJ21tD2nf2yTmTwEUeTI8oakMAr8gPJ5KPOBiC5F/Yg+Z
         C36qM3Pzf/lHJiSD7gn0trIZNHi0OIwHh4QuDaIeGtMtDR39BjqhrQLuD4mulGbsVzcH
         nXP1Q/IdQCuoFT/BNXEFjyAXcEiE6cV0TAkEBhYyuSq2psBgeceJL2ytPICx2bYMVYsI
         hqMlW59MKd/AsR10HvOBmI7ZEEF8cPTxjXGLqFMrTUl2DBM3o1ibkU9CT7aiWjc48VHX
         ity1bTBYl4y9O+vKevqKy226dUKc9/6CsmG1xOVeb2Dhn0Do2nobpGdMIX/Ae/Lm7Xan
         ii/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zc9YYTM+dezLtxTJUQZRBFDaWnorZ9yi2o8pLUnatQA=;
        b=kGi4RvcU4wZ6tTqJ8r2+dnhQngud/V7MBQFkEkwWCeQKLR90U2gEYA8athsoaOfcx2
         QmN697WpEAEAL/1pzTSsRdNGKMHyRpUa91l6YCQYf235z3LDBFqPRZtAfdi3EKwXjeFY
         Pc5siIw7+a/J0ifmS1F16o70LoEw77K74Fgv8IRENCxk+hatx7eLe3PqapUnT2WnBoxT
         emUcEfimvc2sJ94UVbPxW3xitPL8oKXK0PQZJJ9YgMsoLEcoFiGzkh33gO3uvTZdYDEF
         yZfEUoj6tym0oWoiFwGXTIrMKINNFPHYk4fKE3hp+GLllI1OVSdO3LtcYhkCOj40P4G2
         v3gg==
X-Gm-Message-State: AOAM532gGuO8EQAFs26hm2BSrO1U4JP21uC9403Sj1OjYBA1XMcbco8f
        B8MmL8ST8zjkDgYEMISgz92JAzF7FUVLWSGxUaK8ORW1Q4Y=
X-Google-Smtp-Source: ABdhPJzwZ6wg5wqwN0fFPY7HkDhjI3e6jhb28qMAnVVPU6dGe6exY6BGRnA23gr48c9ipO0wooCQ+1EJ+S4D0fs7jQs=
X-Received: by 2002:a17:90a:b794:: with SMTP id m20mr23449123pjr.178.1634425062528;
 Sat, 16 Oct 2021 15:57:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634314022.git.asml.silence@gmail.com> <6e72153f8de78d836b9b7595a2a6f1c6a9f137b1.1634314022.git.asml.silence@gmail.com>
In-Reply-To: <6e72153f8de78d836b9b7595a2a6f1c6a9f137b1.1634314022.git.asml.silence@gmail.com>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Sat, 16 Oct 2021 17:57:31 -0500
Message-ID: <CAFUsyfLH46EOJHvGJRToE0GApdjdX4UhO7DgnV9S4di4O1CCMQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] io_uring: arm poll for non-nowait files
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     "open list:IO_URING" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Oct 16, 2021 at 5:19 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> Don't check if we can do nowait before arming apoll, there are several
> reasons for that. First, we don't care much about files that don't
> support nowait. Second, it may be useful -- we don't want to be taking
> away extra workers from io-wq when it can go in some async. Even if it
> will go through io-wq eventually, it make difference in the numbers of
> workers actually used. And the last one, it's needed to clean nowait in
> future commits.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 65 +++++++++++++++++----------------------------------
>  1 file changed, 21 insertions(+), 44 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ce9a1b89da3f..c9acb4d2a1ff 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -732,8 +732,7 @@ enum {
>         REQ_F_ARM_LTIMEOUT_BIT,
>         REQ_F_ASYNC_DATA_BIT,
>         /* keep async read/write and isreg together and in order */
> -       REQ_F_NOWAIT_READ_BIT,
> -       REQ_F_NOWAIT_WRITE_BIT,
> +       REQ_F_SUPPORT_NOWAIT_BIT,
>         REQ_F_ISREG_BIT,
>
>         /* not a real bit, just to check we're not overflowing the space */
> @@ -774,10 +773,8 @@ enum {
>         REQ_F_COMPLETE_INLINE   = BIT(REQ_F_COMPLETE_INLINE_BIT),
>         /* caller should reissue async */
>         REQ_F_REISSUE           = BIT(REQ_F_REISSUE_BIT),
> -       /* supports async reads */
> -       REQ_F_NOWAIT_READ       = BIT(REQ_F_NOWAIT_READ_BIT),
> -       /* supports async writes */
> -       REQ_F_NOWAIT_WRITE      = BIT(REQ_F_NOWAIT_WRITE_BIT),
> +       /* supports async reads/writes */
> +       REQ_F_SUPPORT_NOWAIT    = BIT(REQ_F_SUPPORT_NOWAIT_BIT),
>         /* regular file */
>         REQ_F_ISREG             = BIT(REQ_F_ISREG_BIT),
>         /* has creds assigned */
> @@ -1390,18 +1387,13 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
>         return false;
>  }
>
> -#define FFS_ASYNC_READ         0x1UL
> -#define FFS_ASYNC_WRITE                0x2UL
> -#ifdef CONFIG_64BIT
> -#define FFS_ISREG              0x4UL
> -#else
> -#define FFS_ISREG              0x0UL
> -#endif
> -#define FFS_MASK               ~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
> +#define FFS_NOWAIT             0x1UL
> +#define FFS_ISREG              0x2UL
> +#define FFS_MASK               ~(FFS_NOWAIT|FFS_ISREG)
>
>  static inline bool io_req_ffs_set(struct io_kiocb *req)
>  {
> -       return IS_ENABLED(CONFIG_64BIT) && (req->flags & REQ_F_FIXED_FILE);
> +       return req->flags & REQ_F_FIXED_FILE;
>  }
>
>  static inline void io_req_track_inflight(struct io_kiocb *req)
> @@ -2775,7 +2767,7 @@ static bool io_bdev_nowait(struct block_device *bdev)
>   * any file. For now, just ensure that anything potentially problematic is done
>   * inline.
>   */
> -static bool __io_file_supports_nowait(struct file *file, int rw)
> +static bool __io_file_supports_nowait(struct file *file)
>  {
>         umode_t mode = file_inode(file)->i_mode;
>
> @@ -2798,24 +2790,14 @@ static bool __io_file_supports_nowait(struct file *file, int rw)
>         /* any ->read/write should understand O_NONBLOCK */
>         if (file->f_flags & O_NONBLOCK)
>                 return true;
> -
> -       if (!(file->f_mode & FMODE_NOWAIT))
> -               return false;
> -
> -       if (rw == READ)
> -               return file->f_op->read_iter != NULL;
> -
> -       return file->f_op->write_iter != NULL;
> +       return file->f_mode & FMODE_NOWAIT;
>  }
>
> -static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
> +static inline bool io_file_supports_nowait(struct io_kiocb *req)
>  {
> -       if (rw == READ && (req->flags & REQ_F_NOWAIT_READ))
> -               return true;
> -       else if (rw == WRITE && (req->flags & REQ_F_NOWAIT_WRITE))
> +       if (likely(req->flags & REQ_F_SUPPORT_NOWAIT))
>                 return true;
> -
> -       return __io_file_supports_nowait(req->file, rw);
> +       return __io_file_supports_nowait(req->file);
>  }
>
>  static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
> @@ -2847,7 +2829,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>          * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
>          */
>         if ((kiocb->ki_flags & IOCB_NOWAIT) ||
> -           ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
> +           ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
>                 req->flags |= REQ_F_NOWAIT;
>
>         ioprio = READ_ONCE(sqe->ioprio);
> @@ -3238,7 +3220,8 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
>          */
>         if (kiocb->ki_flags & IOCB_HIPRI)
>                 return -EOPNOTSUPP;
> -       if (kiocb->ki_flags & IOCB_NOWAIT)
> +       if ((kiocb->ki_flags & IOCB_NOWAIT) &&
> +           !(kiocb->ki_filp->f_flags & O_NONBLOCK))
>                 return -EAGAIN;

Instead of 2x branches on what appears to be the error (not hot path)

what about:
    if (kiocb->ki_flags & (IOCB_HIPRI | IOCB_NOWAIT)) {
        if (kiocb->ki_flags & IOCB_HIPRI)
            return -EOPNOTSUPP;
        if (!(kiocb->ki_filp->f_flags & O_NONBLOCK)) {
            return -EAGAIN;
        }
    }
>
>         while (iov_iter_count(iter)) {
> @@ -3478,7 +3461,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>
>         if (force_nonblock) {
>                 /* If the file doesn't support async, just async punt */
> -               if (unlikely(!io_file_supports_nowait(req, READ))) {
> +               if (unlikely(!io_file_supports_nowait(req))) {
>                         ret = io_setup_async_rw(req, iovec, s, true);
>                         return ret ?: -EAGAIN;
>                 }
> @@ -3602,7 +3585,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
>
>         if (force_nonblock) {
>                 /* If the file doesn't support async, just async punt */
> -               if (unlikely(!io_file_supports_nowait(req, WRITE)))
> +               if (unlikely(!io_file_supports_nowait(req)))
>                         goto copy_iov;
>
>                 /* file path doesn't support NOWAIT for non-direct_IO */
> @@ -3634,7 +3617,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
>         }
>         kiocb->ki_flags |= IOCB_WRITE;
>
> -       if (req->file->f_op->write_iter)
> +       if (likely(req->file->f_op->write_iter))
>                 ret2 = call_write_iter(req->file, kiocb, &s->iter);
>         else if (req->file->f_op->write)
>                 ret2 = loop_rw_iter(WRITE, req, &s->iter);
> @@ -5613,10 +5596,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>                 mask |= POLLOUT | POLLWRNORM;
>         }
>
> -       /* if we can't nonblock try, then no point in arming a poll handler */
> -       if (!io_file_supports_nowait(req, rw))
> -               return IO_APOLL_ABORTED;
> -
>         apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
>         if (unlikely(!apoll))
>                 return IO_APOLL_ABORTED;
> @@ -6788,10 +6767,8 @@ static void io_fixed_file_set(struct io_fixed_file *file_slot, struct file *file
>  {
>         unsigned long file_ptr = (unsigned long) file;
>
> -       if (__io_file_supports_nowait(file, READ))
> -               file_ptr |= FFS_ASYNC_READ;
> -       if (__io_file_supports_nowait(file, WRITE))
> -               file_ptr |= FFS_ASYNC_WRITE;
> +       if (__io_file_supports_nowait(file))
> +               file_ptr |= FFS_NOWAIT;
>         if (S_ISREG(file_inode(file)->i_mode))
>                 file_ptr |= FFS_ISREG;
>         file_slot->file_ptr = file_ptr;
> @@ -6810,7 +6787,7 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
>         file = (struct file *) (file_ptr & FFS_MASK);
>         file_ptr &= ~FFS_MASK;
>         /* mask in overlapping REQ_F and FFS bits */
> -       req->flags |= (file_ptr << REQ_F_NOWAIT_READ_BIT);
> +       req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
>         io_req_set_rsrc_node(req, ctx);
>         return file;
>  }
> --
> 2.33.0
>
